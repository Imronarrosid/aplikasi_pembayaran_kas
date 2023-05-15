import 'package:flutter/material.dart';
import 'package:pembayaran_kas/controller/start_button_controller.dart';
import 'package:pembayaran_kas/service/notification.dart';
import 'package:pembayaran_kas/view/root_page.dart';

Future<void> startPaymentDialog(BuildContext context) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog( // <-- SEE HERE
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titlePadding: EdgeInsets.zero,
       
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Setelah selesai melakukan semua pembayaran, tekan tombol akhiri pembayaran',style: TextStyle(fontSize: 16),),
              const SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 35),
                      ),
                                child: const Text('Mulai'),
                                onPressed: () {
                                StartButtonController().trueState(); 
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const RootPage()), (route) => false);
                                   ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pembayaran dimulai')),
                          );
                  
                          Notif.showNotification(
                            id: 0,title: 'Pembayaran Kas',
                            body: 'Pembayaran Kas sedang berjalan'
                          );
                                },
                              ),
                  ),
            const SizedBox(width: 10,),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 35)
                ),
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
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20,vertical:15),
      );
    },
  );
}