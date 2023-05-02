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
  late bool isActive;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    isActive = StartButtonController.getState();

    super.initState();
  }

  @override
  void dispose() {
    initialValue = 0;
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    paidController.selection =
        TextSelection.collapsed(offset: paidController.text.length);
    double secreenWidth = MediaQuery.of(context).size.width;

    if (paidController.text == '0') {
      setState(() {
        isActive = false;
        print(StartButtonController.getState());
      });
    } else if (paidController.text != '0' &&
        StartButtonController.getState() == true) {
      setState(() {
        isActive = true;
      });
    }
    return Scaffold(
        appBar: AppBar(
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
                    width: secreenWidth,
                    height: 200,
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Telah dibayar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  NumberFormater.numFormat(
                                      int.parse(widget.person.paid)),
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
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const SizedBox(
                              height: 150,
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListView(
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                        Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          width: secreenWidth - 180,
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
                                                const TextStyle(fontSize: 20),
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 10),
                                              hintText: 'Masukan Nominal',
                                            ),
                                            onChanged: (value) => {
                                              if (value.runtimeType == int)
                                                initialValue = int.parse(value),
                                              print(value),
                                              paidController.text= value,
                                              paidController.selection =
                                                  TextSelection.collapsed(
                                                      offset: paidController
                                                          .text.length)
                                            },
                                            onSaved: (value) {
                                              initialValue = int.parse(value!);
                                            },
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
                                              initialValue +=
                                                  Payment.getAmount();
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
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  minimumSize: const Size(
                                                      double.infinity, 35),
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      width: 1)),
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
                                                minimumSize: const Size(
                                                    double.infinity, 35),
                                              ),
                                              onPressed: !isActive
                                                  ? null
                                                  : () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        int paidResult = int
                                                                .parse(widget
                                                                    .person
                                                                    .paid) +
                                                            int.parse(
                                                                paidController
                                                                    .text);
                                                        int notPaidd = int
                                                                .parse(widget
                                                                    .person
                                                                    .notPaid) -
                                                            int.parse(
                                                                paidController
                                                                    .text);

                                                        int notPaidResult =
                                                            notPaidd <= 0
                                                                ? 0
                                                                : notPaidd;

                                                        Person person = Person(
                                                            id: widget
                                                                .person.id,
                                                            name: widget
                                                                .person.name,
                                                            notPaid:
                                                                notPaidResult
                                                                    .abs()
                                                                    .toString(),
                                                            paid: paidResult
                                                                .toString(),
                                                            createdAt: DateTime
                                                                    .now()
                                                                .toString());
                                                        await DatabaseHelper
                                                            .instance
                                                            .update(person);
                                                        Payment.setCashIn(
                                                            int.parse(
                                                                paidController
                                                                    .text));
                                                        if (context.mounted) {
                                                          paidDialog(
                                                              context,
                                                              person.name,
                                                              paidController
                                                                  .text);
                                                        }
                                                        setState(() {});
                                                      }
                                                    },
                                              child: const Text('Bayar')),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
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
                                              child:
                                                  Center(child: Text('Belum ada pembayaran')),
                                            )
                                          : ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (_, index) {
                                                var item =
                                                    snapshot.data![index];
                                                return Card(
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      height: 60,
                                                      child: Row(
                                                        children: [
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
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black54),
                                                              )
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Text(NumberFormater
                                                                  .numFormat(item
                                                                      .amount)
                                                              .toString()),
                                                        ],
                                                      )),
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

paidDialog(context, person, amount) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          title: Container(
              alignment: Alignment.center,
              height: 50,
              color: Theme.of(context).colorScheme.primary,
              child: const Text(
                'Konfirmasi',
                style: TextStyle(color: Colors.white),
              )),
          content: SingleChildScrollView(
            child: ListBody(
                children: [Text('Yakin bayar Rp$amount dari "$person"')]),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: ElevatedButton(
                  onPressed: () {
                    var formatter =
                        DateFormat('EEEE, d MMMM yyyy - hh:mm', 'id_ID');

                    PersonPayment payment = PersonPayment(
                        name: person,
                        amount: int.parse(amount),
                        createdAt: formatter.format(DateTime.now()));
                    DatabaseHelper.instance.addPayment(payment);
                    Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (context) => const RootPage()),
                        ((route) => false));
                  },
                  child: const Text('Bayar')),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.maxFinite),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Batal')),
            ),
          ],
        );
      });
}
