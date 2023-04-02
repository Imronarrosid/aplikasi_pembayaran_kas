import 'package:flutter/material.dart';

Future<void> notStartedDialog(BuildContext context) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // <-- SEE HERE
        title: const Text('Pembayaran Belum Dimulai'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Tekan tombol "Mulai Kas" sebelum melakaukan pembayaran'),
            ],
          ),
        ),
        actions: <Widget>[
          
          TextButton(
            child: const Text('Oke'),
            onPressed: () {
             Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
