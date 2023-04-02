import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/number_formater/number_format.dart';

class CashOutHistory extends StatefulWidget {
  const CashOutHistory({super.key});

  @override
  State<CashOutHistory> createState() => _CashOutHistoryState();
}

class _CashOutHistoryState extends State<CashOutHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Pengeluaran'),),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: 
      FutureBuilder(
          future: DatabaseHelper.instance.getAllCashOut(),
          builder: ((context, snapshot) {

          return snapshot.hasData? ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context , index){
            var item =snapshot.data![index];
            return Card(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(IconlyBroken.paper,size: 40,color: Theme.of(context).colorScheme.primary,),
                  const SizedBox(width: 5,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.description,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                  Text(item.createdAt.toString(),style: const TextStyle(color: Colors.black54),)
                    ],
                  ),
                  const Spacer(),
                      Text('- Rp${NumberFormater.numFormat( item.amount)}',style: const TextStyle(color:Colors.red),)
                ],
              )),
          );
          }):const Center(
                      child: CircularProgressIndicator(),
                    );
        }))

      ),
    );
  }
}