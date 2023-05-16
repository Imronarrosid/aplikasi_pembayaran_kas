
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/formater/number_format.dart';

class BalanceLeft extends StatefulWidget {
  const BalanceLeft({super.key});

  @override
  State<BalanceLeft> createState() => _BalanceLeftState();
}

class _BalanceLeftState extends State<BalanceLeft> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    int  allPaid = Payment.getBalaceLeft();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              IconlyBroken.wallet,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(
              width: 9,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Sisa dana',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                Text('Rp${NumberFormater.numFormat(allPaid)}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white))
                
                
              ],
            ),
          ],
        ));
  }

  
}
