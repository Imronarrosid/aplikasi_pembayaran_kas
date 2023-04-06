import 'package:flutter/material.dart';
import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/view/card_person.dart';

import '../model/model.dart';

Widget showPersonCard(BuildContext context){
  return FutureBuilder(
    future: DatabaseHelper.instance.getPerson(),
    builder: (_, AsyncSnapshot<List<Person>> snapshot){
        return snapshot.hasData
                  ? StretchingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    child: Theme(
                      data: ThemeData(
                        colorScheme: const ColorScheme.light(secondary: Colors.transparent)
                      ),
                      child: NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overScroll){
                          overScroll.disallowIndicator();
                          return true;
                        },
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                                itemCount: snapshot.data!.length,
                                itemBuilder: ((_, index) {
                                var person=snapshot.data![index];
                                return cardPrson(context:context,person:person,cardNumber: index+1);
                              })),
                      ),
                    ),
                  ):const Center(
                      child: CircularProgressIndicator(),
                    );
    });
}