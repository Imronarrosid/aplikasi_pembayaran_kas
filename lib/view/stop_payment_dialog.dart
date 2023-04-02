import 'package:flutter/material.dart';
import 'package:pembayaran_kas/controller/not_paid_controller.dart';
import 'package:pembayaran_kas/controller/start_button_controller.dart';
import 'package:pembayaran_kas/view/home.dart';

Future<void> stopPaymentDialog(BuildContext context) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // <-- SEE HERE
        titlePadding: EdgeInsets.zero,
        title: Container(
          height: 50,
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: const Text('Selesaikan Kas',style: TextStyle(color: Colors.white),)),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Pastikan tidak ada pembayaran lagi untuk hari ini'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        actions: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: ElevatedButton(
              child: const Text('Selesai'),
              onPressed: () async {
                await StartButtonController().falseState();
                await resetNotPaid();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                      (route) => false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pembayaran diselesaikan')),
                  );
                }
              },
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
          ),
        ],
      );
    },
  );
}
