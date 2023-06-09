import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/controller/start_button_controller.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/formater/number_format.dart';
import 'package:pembayaran_kas/screen/search_screen.dart';
import 'package:pembayaran_kas/widget/show_card.dart';
import 'package:pembayaran_kas/widget/start_payment_dialog.dart';
import 'package:pembayaran_kas/widget/stop_payment_dialog.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Color drawerBackgroundColor = Colors.white;

  @override
  void initState() {
    // ignore: unnecessary_null_comparison
    if (StartButtonController.getState() == null) {
      StartButtonController().falseState();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TextStyle title1 = Theme.of(context)
        .textTheme
        .titleMedium!
        .merge(const TextStyle(color: Colors.white));
    late String paymentName = Payment.getName();
    var dateFormatNow = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    Future<int> isTableEmpty() async {
      final db = await DatabaseHelper.instance.database;

      int? count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM person'));
      return count!;
    }

    return Scaffold(
        extendBody: false,
        key: _key,
        body: SizedBox(
          width: screenWidth,
          height: double.infinity,
          child: StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child: ListView(shrinkWrap: true, children: [
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    alignment: Alignment.centerLeft,
                    height: 70,
                    child: Entry.offset(
                      yOffset: -1000,
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (Payment.getName() == null)
                                ? 'Pembayaran kas'
                                : paymentName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Text(
                            dateFormatNow.format(DateTime.now()),
                            style: const TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  height: 190,
                  width: double.infinity,
                  child: Entry(
                    yOffset: -1000,
                    duration: const Duration(milliseconds: 300),
                    delay: const Duration(microseconds: 120),
                    curve: Curves.fastOutSlowIn,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        //padding component inside card
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Sisa',
                                            style: title1.merge(const TextStyle(
                                                color: Colors.black87))),
                                        Text(
                                          NumberFormater.numFormat(
                                              Payment.getBalaceLeft()),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge!
                                              .merge(const TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.black87)),
                                        ),
                                      ],
                                    ),
                                    FutureBuilder(
                                        future:
                                            DatabaseHelper.instance.getPerson(),
                                        builder: (_, snapshot) {
                                          var data = snapshot.data;
                                          return snapshot.hasData
                                              ? (Payment.getName() != null &&
                                                      Payment.getAmount() !=
                                                          0 &&
                                                      data!.isNotEmpty)
                                                  ? Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5,
                                                              left: 5,
                                                              top: 0,
                                                              bottom: 15),
                                                      height: 50,
                                                      child: (StartButtonController
                                                              .getState())
                                                          ? OutlinedButton(
                                                              style: OutlinedButton.styleFrom(
                                                                  foregroundColor:
                                                                      const Color(
                                                                          0xFFF7444E),
                                                                  side: const BorderSide(
                                                                      color: Color(
                                                                          0xFFF7444E),
                                                                      width: 1),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(
                                                                          100)),
                                                                  minimumSize:
                                                                      const Size(
                                                                          110, 15),
                                                                  maximumSize:
                                                                      const Size(
                                                                          120, 15)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Text(
                                                                    'Selesai  ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Icon(Icons
                                                                      .pause_rounded)
                                                                ],
                                                              ),
                                                              onPressed: () {
                                                                stopPaymentDialog(
                                                                    context);
                                                                setState(() {});
                                                              })
                                                          : ElevatedButton(
                                                              style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Theme.of(context).colorScheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)), minimumSize: const Size(110, 15), maximumSize: const Size(120, 15)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: const [
                                                                  Text(
                                                                      'Mulai  '),
                                                                  Icon(Icons
                                                                      .play_arrow_rounded)
                                                                ],
                                                              ),
                                                              onPressed: () {
                                                                startPaymentDialog(
                                                                    context);
                                                                setState(() {});
                                                              }))
                                                  : Container()
                                              : Container();
                                        }),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 35,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Pemasukan',
                                                    style: title1.merge(
                                                        const TextStyle(
                                                            color: Colors
                                                                .black87))),
                                                const Icon(Icons.add,
                                                    size: 16,
                                                    color: Colors.black87),
                                              ],
                                            ),
                                            Text(
                                              NumberFormater.numFormat(
                                                  Payment.getCashIn()),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .merge(const TextStyle(
                                                      color: Colors.black87)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        height: 35,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Pengeluaran',
                                                    style: title1.merge(
                                                        const TextStyle(
                                                            color: Colors
                                                                .black87))),
                                                const Icon(Icons.remove,
                                                    size: 16,
                                                    color: Colors.black87),
                                              ],
                                            ),
                                            Text(
                                              NumberFormater.numFormat(
                                                  Payment.getCashOut()),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge!
                                                  .merge(const TextStyle(
                                                      color: Colors.black87)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Entry.offset(
                  xOffset: 0,
                  yOffset: -1000,
                  duration: const Duration(milliseconds: 150),
                  delay: const Duration(microseconds: 10),
                  curve: Curves.fastOutSlowIn,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()));
                      },
                      child: const TextField(
                        enabled: false,
                        decoration: InputDecoration(
                            hintText: 'Cari',
                            border: InputBorder.none,
                            icon: Icon(
                              IconlyBroken.search,
                              color: Colors.black45,
                            )),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      child: FutureBuilder(
                        future: isTableEmpty(),
                        builder: (_, AsyncSnapshot<int> snapshot) {
                          var isTableEmpty = snapshot.data;
                          if (isTableEmpty == 0) {
                            StartButtonController().falseState();
                            return Container(
                              alignment: Alignment.center,
                              height: 300,
                              child: const Text(
                                'Belum ada pembayaran',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,),
                              ),
                            );
                          } else {
                            return showPersonCard(context);
                          }
                        },
                      ),
                    )
                    // ListView.builder(
                    //     padding: EdgeInsets.zero,
                    //     scrollDirection: Axis.vertical,
                    //     shrinkWrap: true,
                    //     itemCount: data.length,
                    //     itemBuilder: ((context, index) {
                    //       var items = data[index];
                    //       return Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal:10.0),
                    //         child: cardPrson(
                    //             personName: items.name,
                    //             paid: items.getPaid(),
                    //             notPaid: items.getNotPaid(),
                    //             index: index),
                    //       );
                    //     })),
                    ),
              ]),
            ),
          ),
        ));
  }

  Container cashInWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Pemasukan',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
          Icon(IconlyBold.arrow_up_2, color: Colors.green)
        ],
      ),
    );
  }

  Container cashOutWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.grey[200]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Pengeluaran',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
          Icon(IconlyBold.arrow_down_2, color: Colors.red)
        ],
      ),
    );
  }
}
