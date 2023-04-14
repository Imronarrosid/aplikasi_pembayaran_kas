import 'package:flutter/material.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/model/model.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/view/root_page.dart';


class CreatePayment extends StatefulWidget {
  const CreatePayment({super.key});

  @override
  State<CreatePayment> createState() => _CreatePaymentState();
}

class _CreatePaymentState extends State<CreatePayment> {
  TextEditingController nameController = TextEditingController(
      text: (Payment.getName() != null) ? Payment.getName() : null);

  TextEditingController amountController = TextEditingController(
      text: (Payment.getAmount() != 0) ? Payment.getAmount().toString() : '');
  TextEditingController personNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> form = [];
  @override
  Widget build(BuildContext context) {
    double sreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: (Payment.getName() != null)
              ? const Text('Edit Kas')
              : const Text('Buat Kas')),
      persistentFooterButtons: [
        SizedBox.expand(
          child: ElevatedButton(
              onPressed: () async {


                if (_formKey.currentState!.validate()) {
                  //execute whwn paymen name null

                  if (Payment.getName() == null) {
                    Payment.setPaymentName(nameController.text);

                    Payment.setAmount(int.parse(amountController.text));

                    Payment.setHaveToPaid(int.parse(amountController.text));
                  }

                  //looping for add person to database

                  for (int i = 0; i < form.length; i++) {
                    var item = form[i];

                    Person person = Person(
                        name: item.text,
                        paid: '0',
                        notPaid: Payment.getHaveToPaid().toString(),
                        createdAt: DateTime.now().toString());

                    await DatabaseHelper.instance.add(person);
                  }

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (context) => const RootPage()),
                        ((route) => false));
                  }
                }
              },
              child: const Text('Simpan')),
        )
      ],
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: sreenWidth,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text('Judul kas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: nameController,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Form tidak boleh kosong';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    hintText: 'Judul kas',
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelStyle: TextStyle(fontSize: 216),
                    contentPadding: EdgeInsets.only(left: 10),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Nominal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Form tidak boleh kosong';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: 'Nominal/pembayaran',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      floatingLabelStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tambah Anggota',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ElevatedButton(
                          
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)
                            ),
                            alignment: Alignment.center,
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2)
                          ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                form.insert(0, TextEditingController());
                              }
                              setState(() {});
                            },
                            child: Icon(Icons.add,
                                size: 30,
                                color: Theme.of(context).colorScheme.primary)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: form.length,
                  itemBuilder: (_, index) {
                    //Form person list
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${form.length - index}.',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: sreenWidth - 105,
                            child: TextFormField(
                              controller: form[index],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Form tidak boleh kosong';
                                }
                                return null;
                              },
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                hintText: 'Nama',
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                floatingLabelStyle: TextStyle(fontSize: 20),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (){
                            form.removeAt(index);
                            setState(() {
                              
                            });
                          },
                          icon:const Icon(Icons.clear_rounded,size:30,color: Colors.black45,))
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
