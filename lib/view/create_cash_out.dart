import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/model/cash_out_model.dart';
import 'package:pembayaran_kas/view/root_page.dart';

import '../model/payment.dart';
import 'home.dart';

class CashOutPage extends StatefulWidget {
  const CashOutPage({super.key});

  @override
  State<CashOutPage> createState() => _CashOutPageState();
}

class _CashOutPageState extends State<CashOutPage> {
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Pengeluaran'),),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10,),
              const Text('Pngeluaran',style: TextStyle(height:2,fontSize: 20,fontWeight: FontWeight.w500),),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  controller: descController,
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Form tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Tujuan pengeluaran',),
                ),
              ),
              const SizedBox(height: 5,),
              const Text('Nominal',style: TextStyle(height: 2,fontSize: 20,fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                color: Colors.grey[100]),
                child: TextFormField(
                  controller: amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Form tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Nominal pengeluaran',),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: () async{

                if (_formKey.currentState!.validate()){
                  
                var formatter = DateFormat('yyyy-MM-dd');
                Payment.setCashOut(int.parse(amountController.text));
                CashOut cashOut =CashOut(description: descController.text,amount: int.parse(amountController.text),createdAt: formatter.format(DateTime.now()));
                await DatabaseHelper.instance.addCashOutHistory(cashOut);

                if(context.mounted){
                Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (context) => const RootPage()),
                        ((route) => false));
                  
                }
                }
              }, child: const Text('Simpan'))
            ],
          ),
        ),
      ),
    );
  }
}