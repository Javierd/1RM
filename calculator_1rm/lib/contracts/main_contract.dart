import 'package:calculator_1rm/models/extended_record.dart';
import 'package:calculator_1rm/models/moor_database.dart';
import 'package:flutter/widgets.dart';

abstract class MainPresenterContract{
  void onDataEntered(String weight, String reps);
  void onExerciseSelected(Exercise exercise);
  void onExerciseAdded(String name);
  void onFabPressed(BuildContext context, int tabIndex);

  void loadRecordsSelectedExercise();
  void loadGridEnteredInfo();

  void loadExercises();
}

abstract class MainPageContract{
  String get enteredWeight;
  String get enteredReps;
  Exercise get selectedExercise;

  void setExerciseList(Future<List<Exercise>> exercises);

  /* If the user wants to create a new exercise, this functions
   * shows a dialog asking for the name and return it */
  Future<String> showTextInputDialog(BuildContext context,
      {final String initText, String title});

  /* If the user*/
  Future<Exercise> showExerciseDropdownDialog(BuildContext context, {String title});
}

abstract class GridResultsViewContract{
  void updateResults(Future<Map<int, double>> results);
  void setValidEntry(bool valid);
}

abstract class ExerciseRecordsViewContract{
  void loadExercise(Exercise exercise, Future<List<ExtendedRecord>> records);
}