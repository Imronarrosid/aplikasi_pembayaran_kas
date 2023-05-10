import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:iconly/iconly.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/formater/number_format.dart';
import 'package:pembayaran_kas/model/model.dart';
import 'package:pembayaran_kas/view/person.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searcController= TextEditingController();
  String _searchText = '';
   List<Person> _items = [];
  List<Person> _filteredItems = [];

    void _onSearchTextChanged(String value) async{
      _items=await DatabaseHelper.instance.getPerson();
    setState(() {
      _searchText = value;
      _filteredItems = _items
          .where((item) => item.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      if(_searchText.isEmpty){
        _filteredItems=[];
      }
    });
  }
    bool _searchNotFound(){
      return _filteredItems.isEmpty ? true :false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black87),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children:  [
                const Hero(
                  tag: 'search',
                  child: Icon(
                    IconlyBroken.search,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _searcController,
                  decoration: const InputDecoration(
                    hintText: 'Cari',
                    border: InputBorder.none),
                  onChanged: _onSearchTextChanged,
                )),
              ],
            ),
          )),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _searchNotFound() && _searcController.text.isNotEmpty? Center(child: Text('$_searchText Tidak ditamukan'),):ListView.builder(
          itemCount: _filteredItems.length,
                    shrinkWrap: true,
                    itemBuilder: (_,index){
                      var items = _filteredItems[index];
                    return ListTile(
                      title: Text(items.name),
                      minVerticalPadding: 15,
                      trailing: const Icon(IconlyBroken.arrow_right_2),
                      subtitle: (int.parse(items.notPaid) <= 0)
                            ? Align(
                              alignment: Alignment.centerLeft,
                              child: UnconstrainedBox(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            const Color(0xFF4273FF).withOpacity(0.2)),
                                    child: const Text(
                                      'Lunas',
                                      style: TextStyle(
                                          color: Color(0xFF4273FF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                            )
                            : Text(
                                '- ${NumberFormater.numFormat(int.parse(items.notPaid))}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFFF7444E),
                                    fontWeight: FontWeight.w500),
                              ),
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: ((context) =>  PersonPage(person: items,)))),
      
                    );
                  }),
      )
          
    );
  }
}
