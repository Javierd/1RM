import 'package:calculator_1rm/models/calculator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings{

  static Future<Map<String, bool>> loadUserSettings(Future<SharedPreferences> _prefs) async{
    final SharedPreferences prefs = await _prefs;
    Map<String, bool> activeFormulas = Map();

    Calculator.formulas.forEach((String name){
      bool tmp = prefs.getBool(name);
      if (tmp == null){
        prefs.setBool(name, true);
      }

      activeFormulas[name] = tmp;
    });

    return activeFormulas;
  }

}