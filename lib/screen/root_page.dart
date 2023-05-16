import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/screen/create_cash_out.dart';
import 'package:pembayaran_kas/screen/create_payment.dart';
import 'package:pembayaran_kas/screen/home.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex=0;
  List<Widget> listScreen=[
    const Home(),
    const CreatePayment(),
    const CashOutPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Entry.offset(
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
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
            activeIcon: const Icon(IconlyBold.editSquare),
            label: (Payment.getName() == null)?'Buat':'Edit',
            icon:const Icon(IconlyBroken.edit_square)),
          const BottomNavigationBarItem(
            activeIcon: Icon(IconlyBold.paper),
            label: 'Pengeluaran'
            ,icon:Icon(IconlyBroken.paper))
        ]),
      ),
      body: listScreen[selectedIndex],
    );
  }
}