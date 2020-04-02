import 'dart:math';

import 'package:calculator_1rm/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculator{

  static const List<String> formulas = ["Brzycki",
    "McGlothin", "Lombardi", "Mayhew et al", "O'Conner et al", "Wathen"];

  static Future<Map<int, double>> estimateReps(double weight, int reps, int nEstimations) async{
    Map<int, double> estimations = Map();
    double estimatedRM = await estimateRM(weight, reps);

    try{
      for (int i=1; i <= nEstimations; i++){
        estimations[i] = await estimateWeight(estimatedRM, i);
      }
    } on NoFormulaSelectedException catch (e){
      throw e;
    }

    return estimations;
  }

  static Future<double> estimateRM(double weight, int reps) async{
    try{
      return _estimateMean(weight, reps, _estimateRM);
    } on NoFormulaSelectedException catch (e){
      throw e;
    }
  }

  static Future<double> estimateWeight(double rm, int reps) async{
    try{
      return _estimateMean(rm, reps, _estimateWeight);
    } on NoFormulaSelectedException catch (e){
      throw e;
    }
  }

  static Future<double> _estimateMean(double weight, int reps, Function estimateFunct) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    Map<String, bool> formulas = await Settings.loadUserSettings(_prefs);
    double sum = 0;
    int n = 0;

    formulas.forEach((k, v){
      if (v){
        n += 1;
        sum += estimateFunct(weight, reps, k);
      }
    });

    if (n == 0){
      throw NoFormulaSelectedException();
    }

    return (sum/n).roundToDouble();
  }

  static double _estimateRM(double weight, int reps, String formula){
    switch (formula){
      case "Brzycki":
        return weight*36/(37-reps);
      case "McGlothin":
        return 100*weight/(101.3-2.67123*reps);
      case "Lombardi":
        return weight*pow(reps,0.1);
      case "Mayhew et al":
        return 100*weight/(52.2+41.9*pow(e, -0.055*reps));
      case "O'Conner et al"  :
        return weight*(1+reps/40);
      case "Wathen":
        return 100*weight/(48.8+53.8*pow(e, -0.075*reps));
    }
  }

  static double _estimateWeight(double rm, int reps, String formula){
    switch (formula){
      case "Brzycki":
        return rm*(37-reps)/36;
      case "McGlothin":
        return rm*(101.3-2.67123*reps)/100;
      case "Lombardi":
        return rm/pow(reps,0.1);
      case "Mayhew et al":
        return rm*(52.2+41.9*pow(e, -0.055*reps))/100;
      case "O'Conner et al"  :
        return rm/(1+reps/40);
      case "Wathen":
        return rm*(48.8+53.8*pow(e, -0.075*reps))/100;
    }
  }

}

class NoFormulaSelectedException implements Exception{

  @override
  String toString() {
    return 'NoFormulaSelectedException';
  }
}