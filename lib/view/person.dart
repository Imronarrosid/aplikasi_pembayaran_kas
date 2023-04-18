import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/model/model.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/number_formater/number_format.dart';
import 'package:pembayaran_kas/view/root_page.dart';
import 'home.dart';

class PersonPage extends StatefulWidget {
  final Person person;
  const PersonPage({super.key, required this.person});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  static int paid = Payment.getAmount();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    paid = Payment.getAmount();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController paidController =
        TextEditingController(text: paid.toString());
        paidController.selection = TextSelection.collapsed(offset: paidController.text.length);
    double secreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
        actions: [
          IconButton(
              onPressed: () {
                deleteDialog(context,widget.person.name,widget.person.id!);
                // DatabaseHelper.instance.remove(widget.person.id!);
                // Navigator.pushAndRemoveUntil<dynamic>(
                //     context,
                //     MaterialPageRoute<dynamic>(
                //         builder: (context) => const Home()),
                //     ((route) => false));
                // setState(() {});
              },
              icon: const Icon(IconlyBroken.delete))
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: secreenWidth,
            height: 200,
            color: Theme.of(context).colorScheme.primary,
            child: Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Telah dibayar',style: TextStyle(color: Colors.white),),
                        const SizedBox(height: 10,),
                        Text('Rp${NumberFormater.numFormat(int.parse(widget.person.paid))}'
              ,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600),
            ),
                      ],
                    ))),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: secreenWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const Text(
                              'Bayar Kas',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10,),


                            //Paid form layout
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(50, 50)),
                                  onPressed: () {
                                    setState(() {
                                      if (paid > 0) {
                                        paid -= Payment.getAmount();
                                      }
                                    });
                                  },
                                  color: Theme.of(context).colorScheme.primary,
                                  icon: const Icon(Icons.remove),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  width: secreenWidth - 180,
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: paidController,
                                      textAlignVertical: TextAlignVertical.center,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Form tidak boleh kosong';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center,
                                      decoration:  const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                                          hintText: 'Masukan Nominal',
                                         )),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(50, 50)),
                                  onPressed: (() {
                                    setState(() {
                                      paid += Payment.getAmount();
                                    });
                                  }),
                                  color: Theme.of(context).colorScheme.primary,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    int paidResult =
                                        int.parse(widget.person.paid) +
                                            int.parse(paidController.text);
                                            int notPaidd=int.parse(widget.person.notPaid)-int.parse(paidController.text);

                                            int notPaidResult=notPaidd<=0?0:notPaidd;

                                    Person person = Person(
                                        id: widget.person.id,
                                        name: widget.person.name,
                                        notPaid: notPaidResult.abs().toString(),
                                        paid: paidResult.toString(),
                                        createdAt: DateTime.now().toString());
                                    await DatabaseHelper.instance
                                        .update(person);
                                    Payment.setCashIn(
                                        int.parse(paidController.text));
                                    if (context.mounted) {
                                      paidDialog(context, person.name, paidController.text);
                                     
                                    }
                                    setState(() {});
                                  }
                                },
                                child: const Text('Bayar')),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Batal'))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

void deleteDialog(context,String person,int id){
showDialog(context: context, builder: (BuildContext context){
  return AlertDialog(
    title: const Text('Hapus'),
    content: SingleChildScrollView(
      child: ListBody(children: [
        Text('Yakin mau hapus "$person"')
      ]),
      
    ),
    actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: const Text('Batal')),
      ElevatedButton(onPressed: (){
        DatabaseHelper.instance.remove(id);
                Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (context) => const RootPage()),
                    ((route) => false));

      }, child: const Text('Hapus'))
    ],
  );
});
}

paidDialog(context,person,amount){
 showDialog(context: context, builder: (BuildContext context){
  return AlertDialog(
    titlePadding: EdgeInsets.zero,
    actionsPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
    title: Container(
      alignment: Alignment.center,
      height: 50,
      color: Theme.of(context).colorScheme.primary,
      child: const Text('Konfirmasi',style: TextStyle(color: Colors.white),)),
    content: SingleChildScrollView(
      child: ListBody(children: [
        Text('Yakin bayar Rp$amount dari "$person"')
      ]),
      
    ),
    actionsAlignment: MainAxisAlignment.spaceAround,
    actions: [
      ConstrainedBox(
  constraints: const BoxConstraints(minWidth: double.infinity),
        child: ElevatedButton(onPressed: (){
                  Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (context) => const Home()),
                      ((route) => false));
      
        }, child: const Text('Bayar')),
      ),
      ConstrainedBox(
  constraints: const BoxConstraints(minWidth: double.maxFinite),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).colorScheme.primary )
          ),
          onPressed: (){
          Navigator.pop(context);
        }, child: const Text('Batal')),
      ),
    ],
  );
} );
}