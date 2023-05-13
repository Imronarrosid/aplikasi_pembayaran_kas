import 'package:flutter/material.dart';
import 'package:pembayaran_kas/view/root_page.dart';

import '../controller/dbhelper.dart';
import '../formater/date_format.dart';
import '../model/cash_out_model.dart';
import '../model/payment.dart';

Future<void> cashOutDialog(BuildContext context,
    {required String description, required String amount}) async {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // <-- SEE HERE
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        titlePadding: EdgeInsets.zero,

        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Buat pengeluaran \n$amount untuk $description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 35),
                      ),
                      child: const Text('Buat'),
                      onPressed: () async {
                        String date = dateFormater(DateTime.now());
                        Payment.setCashOut(int.parse(amount));
                        CashOut cashOut = CashOut(
                            description: description,
                            createdAt: date,
                            amount: int.parse(
                              amount,
                            ));
                        await DatabaseHelper.instance
                            .addCashOutHistory(cashOut);

                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (context) => const RootPage()),
                              ((route) => false));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Sukses membuat pengeluaran')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 35)),
                      child: const Text('Batal'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      );
    },
  );
}

Future<void> notEnoughDialog(BuildContext context,
    {required String description, required String amount}) async {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // <-- SEE HERE
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        titlePadding: EdgeInsets.zero,

        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Sisa dana tidak cukup membuat pengeluaran \n\n$amount untuk $description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 35)),
                  child: const Text('Oke'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      );
    },
  );
}
