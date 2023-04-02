import 'package:hive/hive.dart';

class StartButtonController{
    static final Box box= Hive.box('startButtonState');

    falseState(){
      box.put('state', false);
    }
    trueState(){
      box.put('state', true);
    }
    static dynamic getState(){
     
      return box.get('state');
    }
}