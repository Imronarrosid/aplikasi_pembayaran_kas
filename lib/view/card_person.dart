import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:pembayaran_kas/controller/start_button_controller.dart';
import 'package:pembayaran_kas/model/model.dart';
import 'package:pembayaran_kas/model/payment.dart';
import 'package:pembayaran_kas/number_formater/number_format.dart';
import 'package:pembayaran_kas/view/not_started_dialog.dart';
import 'package:pembayaran_kas/view/person.dart';

Widget cardPrson({required Person person, required int cardNumber}) {
  return Builder(builder: (context) {
    return Entry.offset(
      xOffset: 300,
      yOffset: 0,
      delay: const Duration(milliseconds: 200),
      child: Container(
        height: 70,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Card(
          borderOnForeground: false,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0.5,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 35,
                width: 5,
                decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30),top: Radius.circular(30))
              ),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Card number
                  //Layout card NUmber
                  Container(
                    width: 40,
                    height: 38,
                    alignment: Alignment.center,
                    child: Text(
                      '${cardNumber.toString()}.',
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(left: 0),
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person.name,
                            maxLines: 1,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          (int.parse(person.notPaid) == 0 && int.parse(person.paid)-Payment.getHaveToPaid()>=0)
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green[100]),
                                  child: const Text(
                                    'Lunas',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ))
                              : Text(
                                  '- Rp${NumberFormater.numFormat(int.parse(person.notPaid))}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                )
                        ],
                      )),
                  const Spacer(),
                  IconButton(
                      autofocus: true,
                      splashRadius: 40,
                      style: ButtonStyle(
                          elevation: const MaterialStatePropertyAll(0),
                          iconColor: MaterialStatePropertyAll<Color>(
                              Theme.of(context).colorScheme.primary)),
                      onPressed: () {
                        if (StartButtonController.getState()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => PersonPage(
                                        person: person,
                                      ))));
                        } else {
                          notStartedDialog(context);
                        }
                      },
                      icon: Icon(
                        IconlyBroken.arrow_right_2,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  });
}
