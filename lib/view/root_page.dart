import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:iconly/iconly.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/view/create_cash_out.dart';
import 'package:pembayaran_kas/view/create_payment.dart';
import 'package:pembayaran_kas/view/home.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex=0;
  List<Widget> listScreen=[
    Home(),
    CreatePayment(),
    CashOutPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex=index;
          });
        },
        items: [
        const BottomNavigationBarItem(
          label: 'Beranda',
          activeIcon: Icon(IconlyBold.home),
          icon:Icon(IconlyBroken.home)),
        BottomNavigationBarItem(
          activeIcon: Icon(IconlyBold.editSquare),
          label: (Payment.getName() == null)?'Buat':'Edit',
          icon:Icon(IconlyBroken.edit_square)),
        BottomNavigationBarItem(
          activeIcon: Icon(IconlyBold.paper),
          label: 'Pengeluaran'
          ,icon:Icon(IconlyBroken.paper_plus))
      ]),
      body: listScreen[selectedIndex],
    );
  }
}