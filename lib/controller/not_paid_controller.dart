import 'package:pembayaran_kas/controller/dbhelper.dart';
import 'package:pembayaran_kas/model/model.dart';
import 'package:pembayaran_kas/model/payment.dart';

Future<void> resetNotPaid() async {
  int index;
  int paymentAmount = Payment.getAmount();
  var persons = await DatabaseHelper.instance.getPerson();
  var haveToPaid = Payment.getHaveToPaid() + Payment.getAmount();
  for (index = 0; index < persons.length; index++) {
    var item = persons[index];
    var notPaid =
        int.parse(item.paid) - int.parse(item.notPaid) >= Payment.getHaveToPaid()
            ? 0
            : paymentAmount;
    var reseted = int.parse(item.notPaid) + notPaid;
    var personObj = Person(
        id: item.id,
        name: item.name,
        paid: item.paid,
        notPaid: reseted.toString(),
        createdAt: DateTime.now().toString());

    Payment.setHaveToPaid(haveToPaid);
    await DatabaseHelper.instance.update(personObj);
    print('${item.name} ${item.notPaid}');
  }
}
