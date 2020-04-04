abstract class MainPresenterContract{
  void onDataEntered(String weight, String reps);
}

abstract class MainPageContract{

}

abstract class GridResultsViewContract{
  void updateResults(Future<Map<int, double>> results);
  void setValidEntry(bool valid);
}