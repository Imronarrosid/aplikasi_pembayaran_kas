import 'package:hive/hive.dart';

class Payment{
  static final _box= Hive.box('payment');

  static setPaymentName(String name){
    _box.put('name', name);
  }
  static dynamic getName(){

 
    return _box.get('name');
  }

  static setAmount( int amount){
    _box.put('amount', amount);
  }
  static int getAmount(){
    return _box.get('amount')??0;
  }
  static setHaveToPaid(int haveToPaid){
    _box.put('haveToPaid', haveToPaid);
  }
  static int getHaveToPaid(){
    return _box.get('haveToPaid');
  }
  static setCashOut(int cashOut){
    int result=getCashOut()+cashOut;
    _box.put('cashOut', result);
    setBalanceLeft();
  }
  static int getCashOut(){
    return _box.get('cashOut')??0;
  }
  static setBalanceLeft(){
    int result;
    result = getCashIn() - getCashOut();
    _box.put('balanceLeft', result);
  }
  static  int getBalaceLeft(){
    return _box.get('balanceLeft')??0;
  }
  static setCashIn(int cashIn){
    int result =getCashIn()+cashIn;
    _box.put('cashIn', result);
    setBalanceLeft();  
  }
  static int getCashIn(){
    return _box.get('cashIn')??0;
  }
}