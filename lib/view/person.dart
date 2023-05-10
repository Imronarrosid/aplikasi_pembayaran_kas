import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/controller/start_button_controller.dart';
import 'package:pembayaran_kas/model/model.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/model/person_payment_model.dart';
import 'package:pembayaran_kas/formater/number_format.dart';
import 'package:pembayaran_kas/view/root_page.dart';
import 'package:sqflite/sqflite.dart';
import 'home.dart';

class PersonPage extends StatefulWidget {
  final Person person;
  const PersonPage({super.key, required this.person});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  TextEditingController paidController =
      TextEditingController(text: initialValue.toString());
  static int initialValue = 0;
  bool isEmpty = true;

  static int paid = Payment.getAmount();
  bool isActive = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    print(StartButtonController.getState());
    super.initState();
  }

  @override
  void dispose() {
    initialValue = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double secreenWidth = MediaQuery.of(context).size.width;

    if (paidController.text != '' &&
        paidController.text != '0' &&
        StartButtonController.getState() == true &&
        initialValue != 0) {
      setState(() {
        isActive = true;
        print(StartButtonController.getState());
      });
    } else if (paidController.text == '') {
      setState(() {
        isActive = false;
      });
    } else if (StartButtonController.getState() == false) {
      setState(() {
        isActive = false;
      });
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          title: Text(widget.person.name),
          actions: [
            IconButton(
                onPressed: () {
                  deleteDialog(context, widget.person.name, widget.person.id!);
                },
                icon: const Icon(IconlyBroken.delete))
          ],
        ),
        body: StretchingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: secreenWidth,
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              width: secreenWidth,
                              height: 170,
                              child: Center(
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 40),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Telah dibayar',
                                            style: TextStyle(),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            NumberFormater.numFormat(
                                                int.parse(widget.person.paid)),
                                            style: const TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ))),
                            ),
                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                const Text(
                                  'Bayar',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //Paid form layout
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      IconButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(50, 50)),
                                        onPressed: () {
                                          setState(() {
                                            if (initialValue > 0) {
                                              initialValue -=
                                                  Payment.getAmount();

                                              paidController.text =
                                                  initialValue.toString();
                                              paidController.selection =
                                                  TextSelection.collapsed(
                                                      offset: paidController
                                                          .text.length);
                                            }
                                            if (initialValue < 0) {
                                              initialValue = 0;
                                            }
                                          });
                                        },
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        icon: const Icon(Icons.remove),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: paidController,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value == '0') {
                                                return 'Form tidak boleh kosong';
                                              }
                                              return null;
                                            },
                                            style:
                                                const TextStyle(fontSize: 16),
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              hintText: 'Masukan nominal',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                initialValue = value.isNotEmpty
                                                    ? int.parse(value)
                                                    : 0;
                                                int baseOffset = paidController
                                                    .selection.baseOffset;
                                                if (value.length <
                                                    paidController
                                                        .text.length) {
                                                  paidController.selection =
                                                      TextSelection.collapsed(
                                                          offset: baseOffset);
                                                  paidController.text = value;
                                                }
                                              });
                                              print(
                                                  '$initialValue \n ${paidController.text}');
                                              // setState(() {
                                              //   if (value.length >
                                              //       paidController
                                              //           .text.length || value != paidController.text) {
                                              //     int offset = baseOffset -
                                              //         paidController
                                              //             .text.length -
                                              //         value.length;
                                              //         print('offset $offset');
                                              //     paidController.selection =
                                              //         TextSelection.collapsed(
                                              //             offset: offset);
                                              //     paidController.text = value;
                                              //   }
                                              // });
                                            },
                                            onSaved: (value) {
                                              initialValue = int.parse(value!);
                                            },
                                            onTap: () {
                                              setState(() {
                                                if (paidController.text ==
                                                    '0') {
                                                  paidController.text = '';
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(50, 50)),
                                        onPressed: (() {
                                          setState(() {
                                            initialValue += Payment.getAmount();
                                            int baseOffset = paidController
                                                .selection.baseOffset;
                                            if (initialValue.toString() !=
                                                paidController.text) {
                                              paidController.text =
                                                  initialValue.toString();
                                              paidController.selection =
                                                  TextSelection.collapsed(
                                                      offset: baseOffset);
                                            }
                                          });
                                          print(initialValue);
                                        }),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              minimumSize: const Size(
                                                  double.infinity, 35),
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Batal')),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            minimumSize:
                                                const Size(double.infinity, 35),
                                          ),
                                          onPressed: isActive
                                              ? () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    if (context.mounted) {
                                                      paidDialog(
                                                          context,
                                                          widget.person,
                                                          paidController.text);
                                                    }
                                                    setState(() {});
                                                  }
                                                }
                                              : null,
                                          child: const Text('Bayar')),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                child: const Text(
                                  'Riwayat Pembayaran',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                )),
                            FutureBuilder(
                                future: DatabaseHelper.instance
                                    .getPaymentByName(widget.person.name),
                                builder: (_, snapshot) {
                                  if (snapshot.hasData) {
                                    final dataLength = snapshot.data!.length;
                                    isEmpty = dataLength == 0;
                                  }
                                  return snapshot.hasData
                                      ? isEmpty
                                          ? const SizedBox(
                                              height: 300,
                                              child: Center(
                                                  child: Text(
                                                      'Belum ada pembayaran')),
                                            )
                                          : ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (_, index) {
                                                var item =
                                                    snapshot.data![index];
                                                return Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  height: 60,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.2)),
                                                          child: Icon(
                                                            IconlyBroken
                                                                .arrow_down_3,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          )),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            'Membayar',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            item.createdAt
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black54),
                                                          )
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Text(NumberFormater
                                                              .numFormat(
                                                                  item.amount)
                                                          .toString()),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                      : const Center(
                                          child: CircularProgressIndicator
                                              .adaptive(),
                                        );
                                })
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}

void deleteDialog(context, String person, int id) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus'),
          content: SingleChildScrollView(
            child: ListBody(children: [Text('Yakin mau hapus "$person"')]),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Batal')),
            ElevatedButton(
                onPressed: () {
                  DatabaseHelper.instance.remove(id);

                  Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (context) => const RootPage()),
                      ((route) => false));
                },
                child: const Text('Hapus'))
          ],
        );
      });
}

paidDialog(context, Person person, amount) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          titlePadding: EdgeInsets.zero,
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          content: SingleChildScrollView(
            child: ListBody(children: [
              Text('"${person.name}" memayar kas Rp$amount '),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0),
                        onPressed: () async {
                          var formatter =
                              DateFormat('EEEE, d MMMM yyyy - hh:mm', 'id_ID');

                          PersonPayment payment = PersonPayment(
                              name: person.name,
                              amount: int.parse(amount),
                              createdAt: formatter.format(DateTime.now()));
                          DatabaseHelper.instance.addPayment(payment);

                          int paidResult =
                              int.parse(person.paid) + int.parse(amount);
                          int notPaidd =
                              int.parse(person.notPaid) - int.parse(amount);

                          int notPaidResult = notPaidd <= 0 ? 0 : notPaidd;

                          Person data = Person(
                              id: person.id,
                              name: person.name,
                              notPaid: notPaidResult.abs().toString(),
                              paid: paidResult.toString(),
                              createdAt: DateTime.now().toString());
                          await DatabaseHelper.instance.update(data);
                          print(paidResult);
                          Payment.setCashIn(int.parse(amount));
                          Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (context) => const RootPage()),
                              ((route) => false));
                        },
                        child: const Text('Bayar')),
                  ),
                  Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal')),
                  ),
                ],
              )
            ]),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      });
}
