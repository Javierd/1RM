import 'package:calculator_1rm/contracts/main_contract.dart';
import 'package:calculator_1rm/models/calculator.dart';
import 'package:calculator_1rm/presenters/base_presenter.dart';

class MainPresenter extends BasePresenter<MainPageContract> implements MainPresenterContract{
  static final MainPresenter _presenter = MainPresenter._internal();

  GridResultsViewContract grid;

  factory MainPresenter() => _presenter;
  MainPresenter._internal();

  void attachGrid(GridResultsViewContract grid){
    this.grid = grid;
  }

  bool get isGridAttached => grid != null;


  void checkGridAttached(){
    if(grid==null){
      throw new Exception("Attached grid is null!");
    }
  }


  @override
  void onDataEntered(String weight, String reps) {
    double _weight = double.tryParse(weight);
    int _reps = int.tryParse(reps);

    if (_weight == null || _reps == null || _weight == 0 || _reps == 0){
      grid.setValidEntry(false);
    }else {
      Future<Map<int, double>> estimations = Calculator.estimateReps(_weight, _reps, 12);
      grid.updateResults(estimations);
    }
  }
}