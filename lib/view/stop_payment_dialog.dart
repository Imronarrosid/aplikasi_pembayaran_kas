import 'package:flutter/material.dart';
import 'package:pembayaran_kas/controller/not_paid_controller.dart';
import 'package:pembayaran_kas/controller/start_button_controller.dart';
import 'package:pembayaran_kas/service/notification.dart';
import 'package:pembayaran_kas/view/home.dart';
import 'package:pembayaran_kas/view/root_page.dart';

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
          color: const Color(0xFFF7444E),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: const Text('Selesaikan Kas',style: TextStyle(color: Colors.white),)),
        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
              const Text('Pastikan tidak ada pembayaran lagi untuk sesi pembayaran hari ini',style: TextStyle(fontSize: 16),),
              const SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7444E)
                ),
                child: const Text('Selesai'),
                onPressed: () async {
                  await StartButtonController().falseState();
                  await resetNotPaid();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const RootPage()),
                        (route) => false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pembayaran diselesaikan')),
                    );
                    Notif.cacelSingleNotification();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF7444E),
                  side: const BorderSide(
                    color: Color(0xFFF7444E)
                  )
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Batal'),
              ),
            ),
          ),
                ],
              )
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      );
    },
  );
}
