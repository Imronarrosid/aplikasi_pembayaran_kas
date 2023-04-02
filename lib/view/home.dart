import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/controller/start_button_controller.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/number_formater/number_format.dart';
import 'package:pembayaran_kas/view/balance_left.dart';
import 'package:pembayaran_kas/view/cash_out_history.dart';
import 'package:pembayaran_kas/view/create_cash_out.dart';
import 'package:pembayaran_kas/view/create_payment.dart';
import 'package:pembayaran_kas/view/show_card.dart';
import 'package:pembayaran_kas/view/start_payment_dialog.dart';
import 'package:pembayaran_kas/view/stop_payment_dialog.dart';
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
    Color listTileIconColor = Theme.of(context).colorScheme.primary;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    late String paymentName = Payment.getName();
    var dateFormat = DateFormat('yyyy-MM-dd');
    Future<int> isTableEmpty() async {
      final db = await DatabaseHelper.instance.database;

      int? count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM person'));
      return count!;
    }

    return Scaffold(
      extendBody: false,
      key: _key,
      drawer: Container(
        color: Colors.white,
        child: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      color: Theme.of(context).colorScheme.primary,
                      child: const Text(
                        'Aplikasi Kas',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w600),
                      ))),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                leading: const Icon(IconlyBroken.home),
                iconColor: Theme.of(context).colorScheme.primary,
                title: const Text('Beranda'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                leading: const Icon(IconlyBroken.edit_square),
                iconColor: listTileIconColor,
                title: (Payment.getName() != null)
                    ? const Text('Edit Kas')
                    : const Text('Buat Kas'),
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePayment(),
                      ));
                }),
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                leading: const Icon(IconlyBroken.paper_plus),
                iconColor: listTileIconColor,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const CashOutPage())));
                },
                title: const Text('Buat Pengeluaran'),
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                leading: const Icon(IconlyBroken.paper),
                iconColor: listTileIconColor,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const CashOutHistory())));
                },
                title: const Text('Catatan Pengeluaran'),
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        FutureBuilder(
            future: DatabaseHelper.instance.getPerson(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              return snapshot.hasData
                  ? (Payment.getName() != null &&
                          Payment.getAmount() != 0 &&
                          data!.isNotEmpty)
                      ? Container(
                          padding: const EdgeInsets.only(
                              right: 5, left: 5, top: 0, bottom: 15),
                          height: 65,
                          child: (StartButtonController.getState())
                              ? OutlinedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          const MaterialStatePropertyAll<Color>(
                                              Colors.white),
                                      foregroundColor: MaterialStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      minimumSize: const MaterialStatePropertyAll<Size>(
                                          Size(400, 20)),
                                      maximumSize:
                                          const MaterialStatePropertyAll<Size>(
                                              Size(500, 20)),
                                      side: MaterialStatePropertyAll(BorderSide(
                                          color: Theme.of(context).colorScheme.primary,
                                          width: 1))),
                                  child: const Text(
                                    'Selesaikan Kas',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () {
                                    stopPaymentDialog(context);
                                    setState(() {});
                                  })
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, minimumSize: const Size(400, 20), maximumSize: const Size(500, 20)),
                                  child: const Text('Mulai Kas'),
                                  onPressed: () {
                                    startPaymentDialog(context);
                                    setState(() {});
                                  }))
                      : Container()
                  : const CircularProgressIndicator();
            }),
      ],
      body: SizedBox(
        width: screenWidth,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start, children: [
              Stack(
                children: [
                  //layout heading app
                  SafeArea(
                    child: Stack(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          height: screenheight * 0.13,
                        ),
                        Container(
                          color: Theme.of(context).primaryColor,
                          height: screenheight * 0.1,
                          alignment: Alignment.centerRight,
//Header LAyout
                          child: SafeArea(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: IconButton(
                                    onPressed: () {
                                      _key.currentState!.openDrawer();
                                    },
                                    icon: const Icon(
                                        size: 30,
                                        color: Colors.white,
                                        Icons.menu)),
                              ),
                              const Text(
                                'Aplikasi Kas',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              const BalanceLeft(),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 120.0,
                    ),
                    child: SizedBox(
                      width: screenWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          //Row cash in and Cash out
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 100,
                              width: screenWidth * 0.45,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: cashInWidget(),
                                        ),
                                        const Spacer(),
                                        Text(
                                            'Rp${NumberFormater.numFormat(Payment.getCashIn())}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                                const SizedBox(height: 10,)
                                      ],
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 100,
                              width: screenWidth * 0.45,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: cashOutWidget(),
                                        ),
                                        const Spacer(),
                                        Text(
                                            // ignore: prefer_const_constructors
                                            '-Rp${NumberFormater.numFormat(Payment.getCashOut())}',style: TextStyle(
                                              fontWeight:FontWeight.w600,
                                              color: Colors.red
                                            ),),
                                      const SizedBox( height: 10,)
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              (Payment.getName() != null)
                  ? Container(
                      height: 34,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (Payment.getName() == null)
                                ? 'Pembayaran kas'
                                : paymentName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(dateFormat.format(DateTime.now()))
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: FutureBuilder(
                        future: isTableEmpty(),
                        builder: (context, AsyncSnapshot<int> snapshot) {
                          var isTableEmpty = snapshot.data;
                          if (isTableEmpty == 0) {
                            StartButtonController().falseState();
                            return const Center(
                              child: Text('Belum ada pembayaran'),
                            );
                          } else {
                            return showPersonCard();
                          }
                        },
                      ))
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
          ],
        ),
      ),
    );
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
