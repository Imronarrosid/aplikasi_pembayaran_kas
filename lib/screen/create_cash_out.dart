import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/formater/number_format.dart';
import 'package:pembayaran_kas/widget/cash_out_dialog.dart';
import '../model/payment.dart';

class CashOutPage extends StatefulWidget {
  const CashOutPage({super.key});

  @override
  State<CashOutPage> createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: Entry.offset(
          yOffset: -1000,
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text('Buat Pengeluaran',
                style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: Theme(
                  data: ThemeData(
                      colorScheme: const ColorScheme.light(
                          primary: Color(0xFF4273FF),
                          secondary: Colors.transparent)),
                  child: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overScroll) {
                        overScroll.disallowIndicator();
                        return true;
                      },
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Entry.offset(
                              xOffset: 1000,
                              yOffset: 0,
                              child: Text(
                                'Pngeluaran',
                                style: TextStyle(
                                    height: 2,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )),
                          Entry.offset(
                            xOffset: 1000,
                            yOffset: 0,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                controller: descController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Form tidak boleh kosong';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Tujuan pengeluaran',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Entry.offset(
                              xOffset: 1000,
                              yOffset: 0,
                              delay: Duration(milliseconds: 100),
                              child: Text('Nominal',
                                  style: TextStyle(
                                      height: 2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))),
                          Entry.offset(
                            xOffset: 1000,
                            yOffset: 0,
                            delay: const Duration(milliseconds: 100),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[200]),
                              child: TextFormField(
                                controller: amountController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Form tidak boleh kosong';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Nominal pengeluaran',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Entry.offset(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    minimumSize:
                                        const Size(double.infinity, 45),
                                    maximumSize:
                                        const Size(double.infinity, 45)),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (Payment.getBalaceLeft() -
                                            int.parse(amountController.text) >=
                                        0) {
                                      cashOutDialog(context,
                                          description: descController.text,
                                          amount: amountController.text);
                                    } else {
                                      notEnoughDialog(context,
                                          description: descController.text,
                                          amount: amountController.text);
                                    }
                                  }
                                },
                                child: const Text('Simpan')),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                              future: DatabaseHelper.instance.getAllCashOut(),
                              builder: ((context, snapshot) {
                                return snapshot.hasData
                                    ? ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          var item = snapshot.data![index];
                                          return Entry.offset(
                                            delay: const Duration(
                                                milliseconds: 50),
                                            child: SizedBox(
                                                height: 60,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                    0xFFF7444E)
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                        child: const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 4),
                                                            child: Icon(
                                                              IconlyBroken
                                                                  .upload,
                                                              color: Color(
                                                                  0xFFF7444E),
                                                              size: 20,
                                                            ))),
                                                    const SizedBox(
                                                      width: 14,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.description,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          item.createdAt
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                        )
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      '- ${NumberFormater.numFormat(item.amount)}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                )),
                                          );
                                        })
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              }))
                        ],
                      )))),
        ),
      ),
    );
  }
}
