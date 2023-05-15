import 'dart:io';
import 'package:pembayaran_kas/model/cash_out_model.dart';
import 'package:pembayaran_kas/model/model.dart';
import 'package:pembayaran_kas/model/person_payment_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, 'person.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE person(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          paid TEXT,
          not_paid TEXT,
          created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      ''');
      await db.execute('''
        CREATE TABLE cash_out_history(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          description TEXT,
          amount INTEGER,
          created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');
        await db.execute(''' 
        CREATE TABLE payment(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          amount INTEGER,
          created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )''');
           
  }

  Future<List<Person>> getPerson() async {
    Database db = await instance.database;
    var person = await db.query('person', orderBy: 'name');
    List<Person> listPerson =
        person.isNotEmpty ? person.map((c) => Person.fromMap(c)).toList() : [];
    return listPerson;
  }

  Future<int> add(Person person) async {
    Database db = await instance.database;
    return await db.insert('person', person.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('person', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Person person) async {
    Database db = await instance.database;
    return await db.update('person', person.toMap(),
        where: "id = ?", whereArgs: [person.id]);
  }

  Future<List<CashOut>> getAllCashOut() async {
    Database db = await instance.database;
    var person = await db.query('cash_out_history', orderBy: 'id');
    List<CashOut> listCashOutHistory =
        person.isNotEmpty ? person.map((c) => CashOut.fromMap(c)).toList().reversed.toList() : [];
    return listCashOutHistory;
  }

  Future<int> addCashOutHistory(CashOut person) async {
    Database db = await instance.database;
    return await db.insert('cash_out_history', person.toMap());
  }

  Future<int> removeCashOutHistory(int id) async {
    Database db = await instance.database;
    return await db.delete('cash_out_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCashOutHistory(CashOut cashOut) async {
    Database db = await instance.database;
    return await db.update('cash_out_history', cashOut.toMap(),
        where: "id = ?", whereArgs: [cashOut.id]);
  }

  Future<int> addPayment(PersonPayment payment) async {
    Database db = await instance.database;
    return await db.insert('payment', payment.toMap());
  }

  Future<List<PersonPayment>> getPaymentByName(String name) async {
    Database db = await instance.database;
    var payment = await db.query('payment', orderBy: 'id',where: 'name = ?',whereArgs: [name]);
    List<PersonPayment> listPayment =
        payment.isNotEmpty ? payment.map((c) => PersonPayment.fromMap(c)).toList().reversed.toList() : [];
    return listPayment;
  }
}
