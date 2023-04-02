import 'package:flutter/material.dart';
import 'package:pembayaran_kas/controller/start_button_controller.dart';
import 'package:pembayaran_kas/view/home.dart';

Future<void> startPaymentDialog(BuildContext context) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog( // <-- SEE HERE
      titlePadding: EdgeInsets.zero,
        title: Container(
          alignment: Alignment.center,
          height: 50, color:Theme.of(context).colorScheme.primary,
          child: const Text('Mulai Pembayaran',style: TextStyle(color: Colors.white),)),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Setelah selesai melakukan semua pembayaran, tekan tombol akhiri pembayaran'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20,vertical:15),
        actions: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: ElevatedButton(
              child: const Text('Mulai'),
              onPressed: () {
              StartButtonController().trueState(); 
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                 ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pembayaran dimulai')),
                        );
              },
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.primary)
              ),
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}