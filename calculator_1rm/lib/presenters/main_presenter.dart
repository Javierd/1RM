import 'package:calculator_1rm/contracts/main_contract.dart';
import 'package:calculator_1rm/models/calculator.dart';
import 'package:calculator_1rm/models/moor_database.dart';
import 'package:calculator_1rm/presenters/base_presenter.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moor/moor.dart';

class MainPresenter extends BasePresenter<MainPageContract> implements MainPresenterContract{
  static final MainPresenter _presenter = MainPresenter._internal();
  static final AppDatabase _database = AppDatabase();

  GridResultsViewContract grid;
  ExerciseRecordsViewContract exerciseRecordsView;

  factory MainPresenter() => _presenter;
  MainPresenter._internal();

  void attachGrid(GridResultsViewContract grid){
    this.grid = grid;
  }

  void attachExerciseRecordsView(ExerciseRecordsViewContract exerciseRecordsView) =>
    this.exerciseRecordsView = exerciseRecordsView;

  bool get isGridAttached => grid != null;

  bool get isExerciseRecordsViewAttached => grid != null;

  void checkGridAttached(){
    if(grid==null){
      throw new Exception("Attached grid is null!");
    }
  }

  void checkExerciseRecordsViewAttached(){
    if(exerciseRecordsView==null){
      throw new Exception("Attached exerciseRecordsView is null!");
    }
  }

  void detachGrid(){
    this.grid=null;
  }

  void detachExerciseRecordsView() => this.exerciseRecordsView=null;

  @override
  void onDataEntered(String weight, String reps) {
    double _weight = double.tryParse(weight??"");
    int _reps = int.tryParse(reps??"");

    checkGridAttached();
    if (_weight == null || _reps == null || _weight == 0 || _reps == 0){
      grid.setValidEntry(false);
    }else {
      Future<Map<int, double>> estimations = Calculator.estimateReps(_weight, _reps, 12);
      grid.updateResults(estimations);
    }
  }

  @override
  void onExerciseSelected(Exercise exercise) {
    checkExerciseRecordsViewAttached();

    Future<List<Record>> records = _database.getExerciseRecords(exercise);
    exerciseRecordsView.loadExercise(exercise, Calculator.extendRecords(records));
  }

  @override
  /* TODO: Improve this method by not calling loadExercise, simply adding the new one etc??*/
  void onExerciseAdded(String name) {
    _database.insertExercise(ExercisesCompanion(name: Value(name))).then(
        (value) {
          Fluttertoast.showToast(
              msg: "$name saved.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0
          );
        }
    );
    loadExercises();
  }

  @override
  void loadExercises() {
    checkViewAttached();
    view.setExerciseList(_database.getAllExercises());
  }

  @override
  /* TODO Show a toast or something similar */
  void onFabPressed(BuildContext context, int tabIndex) async{
    checkViewAttached();
    if (tabIndex == 0){
      /* Using ?? we make sure the app doesn't crash if some field is null */
      double weight = double.tryParse(view.enteredWeight ?? "");
      int reps = int.tryParse(view.enteredReps ?? "");

      if (weight == null || reps == null || weight == 0 || reps == 0){
        Fluttertoast.showToast(
            msg: "Fill Weights and Reps before saving the data.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0
        );

        return;
      }else {
        Exercise exercise = await view.showExerciseDropdownDialog(context);

        _database.insertRecord(RecordsCompanion(
          exercise: Value(exercise.id),
          reps: Value(reps),
          weight: Value(weight),
          timestamp: Value(DateTime.now())
        )).then((value) {
          Fluttertoast.showToast(
              msg: "Record saved.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0
          );
        });
      }


    }else if(tabIndex == 1) {
      String res = await view.showTextInputDialog(context);
      if (res != null){
        onExerciseAdded(res);
      }
    }
  }

  @override
  void loadRecordsSelectedExercise() {
    checkViewAttached();

    if (view.selectedExercise != null){
      onExerciseSelected(view.selectedExercise);
    }
  }

  @override
  void loadGridEnteredInfo(){
    checkViewAttached();

    onDataEntered(view.enteredWeight, view.enteredReps);
  }
}