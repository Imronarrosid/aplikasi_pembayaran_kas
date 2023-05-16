import 'package:flutter/material.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/widget/card_person.dart';

import '../model/model.dart';

Widget showPersonCard(BuildContext context){
  return FutureBuilder(
    future: DatabaseHelper.instance.getPerson(),
    builder: (_, AsyncSnapshot<List<Person>> snapshot){
        return snapshot.hasData
                  ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                                itemCount: snapshot.data!.length,
                                itemBuilder: ((_, index) {
                                var person=snapshot.data![index];
                                return cardPrson(context:context,person:person,cardNumber: index+1);
                              })
                  ):const Center(
                      child: CircularProgressIndicator(),
                    );
    });
}