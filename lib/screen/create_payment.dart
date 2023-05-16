import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/model/model.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/screen/root_page.dart';

class CreatePayment extends StatefulWidget {
  const CreatePayment({super.key});

  @override
  State<CreatePayment> createState() => _CreatePaymentState();
}

class _CreatePaymentState extends State<CreatePayment> {
  bool isActive = true;
  TextEditingController nameController = TextEditingController(
      text: (Payment.getName() != null) ? Payment.getName() : null);

  TextEditingController amountController = TextEditingController(
      text: (Payment.getAmount() != 0) ? Payment.getAmount().toString() : '');
  TextEditingController personNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> form = [];

  @override
  Widget build(BuildContext context) {
    if (nameController.text.isEmpty && amountController.text.isEmpty) {
      setState(() {
        isActive = false;
      });
    } else if (nameController.text == Payment.getName() ||
        amountController.text == Payment.getAmount().toString()) {
      setState(() {
        isActive = false;
      });
    }
    if (nameController.text.isNotEmpty &&
        amountController.text.isNotEmpty &&
        nameController.text != Payment.getName()) {
      setState(() {
        isActive = true;
      });
    } else if (amountController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        amountController.text != Payment.getAmount().toString()) {
      setState(() {
        isActive = true;
      });
    }
    if (form.isNotEmpty) {
      setState(() {
        isActive = true;
      });
    }
    double sreenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData().copyWith(
        colorScheme: const ColorScheme.light(
              primary: Color(0xFF4273FF),),
        dividerColor: Colors.transparent,
      ),
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 60),
            child: Entry.offset(
                yOffset: -1000,
                child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    titleTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                    title: (Payment.getName() != null)
                        ? const Text('Edit Kas')
                        : const Text('Buat Kas')))),
        persistentFooterButtons: [
          Entry.offset(
            xOffset: 0,
            child: SizedBox.expand(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(double.infinity, 45),
                      maximumSize: const Size(double.infinity, 45)),
                  onPressed: isActive
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            //execute whwn paymen name null

                            if (Payment.getName() == null ||
                                nameController.text != Payment.getName()) {
                              Payment.setPaymentName(nameController.text);

                              Payment.setHaveToPaid(
                                  int.parse(amountController.text));
                            }
                            if (Payment.getAmount() == 0 ||
                                amountController.text !=
                                    Payment.getAmount().toString()) {
                              Payment.setAmount(
                                  int.parse(amountController.text));

                              Payment.setHaveToPaid(
                                  int.parse(amountController.text));
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
                        }
                      : null,
                  child: const Text('Simpan')),
            ),
          )
        ],
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: sreenWidth,
          child: Form(
              key: _formKey,
              child: StretchingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowIndicator();
                      return true;
                    },
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Entry.offset(
                          yOffset: 0,
                          xOffset: 1000,
                          child: Text('Judul kas',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        Entry.offset(
                          yOffset: 0,
                          xOffset: 1000,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                              controller: nameController,
                              onChanged: (value) {
                                setState(() {
                                  int baseOffset =
                                      nameController.selection.baseOffset;
                                  if (value.length <
                                      nameController.text.length) {
                                    nameController.selection =
                                        TextSelection.collapsed(
                                            offset: baseOffset);
                                    nameController.text = value;
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Form tidak boleh kosong';
                                }
                                return null;
                              },
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: const InputDecoration(
                                hintText: 'Contoh : Kas kelas',
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                floatingLabelStyle: TextStyle(fontSize: 216),
                                contentPadding: EdgeInsets.only(left: 10),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Entry.offset(
                          yOffset: 0,
                          xOffset: 1000,
                          delay: Duration(milliseconds: 50),
                          child: Text('Nomina kas',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                        Entry.offset(
                          yOffset: 0,
                          xOffset: 1000,
                          delay: const Duration(milliseconds: 50),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            child: TextFormField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    int baseOffset =
                                        amountController.selection.baseOffset;
                                    if (value.length <
                                        amountController.text.length) {
                                      int offset = baseOffset -
                                          amountController.text.length -
                                          value.length;
                                      amountController.selection =
                                          TextSelection.collapsed(
                                              offset: offset);
                                      amountController.text = value;
                                    }
                                    // amountController.selection =
                                    //     TextSelection.collapsed(
                                    //         offset: amountController.text.length);
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Form tidak boleh kosong';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  var baseOffset =
                                      amountController.selection.baseOffset;
                                  print(baseOffset);
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  hintText: 'Contoh : 5000',
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.start,
                                  floatingLabelStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Entry.offset(
                          yOffset: 0,
                          xOffset: 1000,
                          delay: const Duration(milliseconds: 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tambah Anggota',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        alignment: Alignment.center,
                                        backgroundColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        form.insert(0, TextEditingController());
                                      }
                                      setState(() {});
                                    },
                                    child: Icon(Icons.add,
                                        size: 30,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                              ),
                            ],
                          ),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
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
                                        autofocus: true,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 10),
                                          hintText: 'Nama',
                                          floatingLabelAlignment:
                                              FloatingLabelAlignment.start,
                                          floatingLabelStyle:
                                              TextStyle(fontSize: 20),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        form.removeAt(index);
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.clear_rounded,
                                        size: 30,
                                        color: Colors.black45,
                                      ))
                                ],
                              );
                            }),
                      ],
                    ),
                  ))),
        ),
      ),
    );
  }
}
