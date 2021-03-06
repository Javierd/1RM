import 'package:calculator_1rm/contracts/main_contract.dart';
import 'package:calculator_1rm/models/moor_database.dart';
import 'package:calculator_1rm/presenters/main_presenter.dart';
import 'package:calculator_1rm/views/dialogs.dart';
import 'package:calculator_1rm/views/fabBottomNavigationBar.dart';
import 'package:calculator_1rm/views/settingsPage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:calculator_1rm/utils/decimalTextInputFormatter.dart';
import 'package:calculator_1rm/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moor/moor.dart' as moor;
import 'package:tuple/tuple.dart';

import 'models/calculator.dart';
import 'models/extended_record.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(RMCalculator());
  });
}

class RMCalculator extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1RM Calculator',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: lightBlueIsh,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
        ),
        textSelectionColor: Colors.black,
        cursorColor: Colors.black
      ),
      home: MainPage(title: '1RM Calculator'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> implements MainPageContract{
  static const Duration animatePageDuration = Duration(milliseconds: 300);
  Future<List<Exercise>> _exercises;
  Exercise _selectedExercise;

  String _enteredWeight, _enteredReps;

  final List<Widget> _tabs = [GridResults(), ExerciseRecordsView()];
  int _currentTabIndex = 0;

  void _onRepsChanged(String reps){
    _enteredReps = reps;
    MainPresenter().onDataEntered(_enteredWeight, _enteredReps);
  }

  void _onWeightChanged(String weight){
    _enteredWeight = weight;
    MainPresenter().onDataEntered(_enteredWeight, _enteredReps);
  }

  String get enteredWeight => _enteredWeight;
  String get enteredReps => _enteredReps;
  Exercise get selectedExercise => _selectedExercise;

  @override
  void initState() {
    super.initState();
    MainPresenter().attachView(this);
    MainPresenter().loadExercises();
  }

  @override
  void dispose(){
    super.dispose();
    MainPresenter().detachView();
  }

  Widget get _inputBar {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(child: TextInputCard(
            cardTitle: "Weight",
            hintText: "Required",
            decimal: true,
            onChanged: _onWeightChanged,
            text: _enteredWeight
        )),
        Expanded(child: TextInputCard(
            cardTitle: "Reps",
            hintText: "Required",
            decimal: false,
            onChanged: _onRepsChanged,
            text: _enteredReps
        )),
      ],
    );
  }

  Widget get _dropDownBar {
    return Center(
      child: FutureBuilder(
          future: _exercises,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            switch (snapshot.connectionState){
              case ConnectionState.waiting:
                return Container();
              default:
                if (snapshot.hasError){
                  print("Error on _dropDownBar FutureBuilder: ${snapshot.error}");
                  return UnexpectedErrorWidget();
                } else if (!snapshot.hasData || snapshot.data.length == 0) {
                  /* If _estimatedRM is null, it means that entered weight/reps is not valid*/
                  return CustomCard(
                    title: "Exercise",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12.0,
                      ),
                      child: Text(
                        "No exercises available",
                        style: TextStyle(color: Colors.black45, fontSize: 18),
                      ),
                    )
                  );
                } else {
                  return CustomCard(
                    title: "Exercise",
                    child: DropdownButton<Exercise>(
                      underline: Container(),
                      hint:  Text("Select exercise"),
                      value: _selectedExercise,
                      onChanged: (Exercise value) {
                        MainPresenter().onExerciseSelected(value);
                        setState(() {
                          _selectedExercise = value;
                        });
                      },
                      items: snapshot.data.map<DropdownMenuItem<Exercise>>((Exercise exercise) {
                        return  DropdownMenuItem<Exercise>(
                          value: exercise,
                          child: Text(
                            exercise.name,
                            style:  TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
            }
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                AnimatedContainer(
                  duration: animatePageDuration,
                  padding: EdgeInsets.all(screenAwareSize(40, context)),
                  constraints: BoxConstraints.expand(
                    height: screenAwareSize(200, context)
                  ),
                  decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [lightBlueIsh, lightGreen],
                          begin: const FractionalOffset(1.0, 1.0),
                          end: const FractionalOffset(0.2, 0.2),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp
                      ),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight:  Radius.circular(30))
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: screenAwareSize(40, context)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('1RM Calculator', style: titleStyleWhite,)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + screenAwareSize(10, context),  //StatusBar Height + 10
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.settings, size: 28, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => SettingsPage()),
                      ).then((value) {
                        if (_currentTabIndex==0) {
                          MainPresenter().onDataEntered(_enteredWeight, _enteredReps);
                        }
                      });
                    },
                  )
                ),
                AnimatedContainer(
                  duration: animatePageDuration,
                  margin: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: screenAwareSize(145, context)
                  ),
                  child:  AnimatedSwitcher(
                    child: _currentTabIndex==0 ? _inputBar:_dropDownBar,
                    duration: animatePageDuration,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                  )
                ),
              ],
            ),
            Expanded(
                child: _tabs[_currentTabIndex],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => MainPresenter().onFabPressed(context, _currentTabIndex),
        backgroundColor: _currentTabIndex==0 ? lightBlueIsh:lightGreen,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FABBottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: _currentTabIndex==0 ? lightBlueIsh:lightGreen,
        unselectedItemColor: Colors.black45,
        onTap: this._onTabTapped,
        notchedShape: CircularNotchedRectangle(),
        currentIndex: this._currentTabIndex,
        // TODO: Add items text, animations, double tap to just refresh, etc
        items: [
          new FABBottomNavigationBarItem(
            icon: Icons.account_balance,
            title: 'Calculator',
          ),
          new FABBottomNavigationBarItem(
            icon: Icons.poll,
            title: 'Records',
          ),
        ],
      ),
    );
  }

  Future<String> showTextInputDialog(BuildContext context,
      {final String initText,
        String title: "Add new exercise",
        String hintText: "Exercise name",
      }) async {

    String name = initText;
    return showDialog<String>(
      context: context,
      barrierDismissible: true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return TextInputDialog(
          title: title,
          hintText: hintText,
          initText: initText,
          onCancel: () {
            Navigator.of(context).pop(initText);
          },
          onOk: () {
            Navigator.of(context).pop(name);
          },
          onInputChanged: (value) {
            name = value;
          },
        );
      },
    );
  }

  void _onTabTapped(int index){
    setState(() => this._currentTabIndex = index);
  }

  @override
  void setExerciseList(Future<List<Exercise>> exercises){
    _exercises = exercises;
    if (_currentTabIndex==1){
      setState(() {
      });
    }

  }

  @override
  Future<Tuple2<Exercise, String>> showExerciseDropdownDialog(BuildContext context,
      {String title: "Select an exercise",
        hintText: "Notes",
      }) async{

    List<Exercise> exercises = await _exercises;
    if (exercises.length == 0){
      return Tuple2<Exercise, String>(null, null);
    }

    Exercise selectedExercise;
    String notes;

    return showDialog<Tuple2<Exercise, String>>(
      context: context,
      barrierDismissible: true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return SaveRecordDialog(
          title: title,
          hintText: hintText,
          exercises: exercises,
          onCancel: () {
            Navigator.of(context).pop(null);
          },
          onOk: () {
            Navigator.of(context).pop(Tuple2<Exercise, String>(selectedExercise, notes));
          },
          onInputChanged: (value) {
            notes = value;
          },
          onSelectedOptionChanged: (Exercise exercise) {
            selectedExercise = exercise;
          }
        );
      },
    );
  }
}

class GridResults extends StatefulWidget{
  @override
  _GridResultsState createState() => _GridResultsState();

}

class _GridResultsState extends State<GridResults> implements GridResultsViewContract{
  static const Widget _noDataAvailableWidget =  Center(child: Text("No data available", style: titleStyleLighterBlack,));
  static const Widget _noFormulaSelectedWidget =  Center(child: Text("No formula selected", style: titleStyleLighterBlack,));
  static const columnCount = 4;

  Future<Map<int, double>> _estimations;
  bool validEntry;

  @override
  void initState() {
    super.initState();
    MainPresenter().attachGrid(this);
    MainPresenter().loadGridEnteredInfo();
  }

  @override
  void dispose(){
    super.dispose();
    MainPresenter().detachGrid();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _estimations,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
              return Container();
            default:
              if (snapshot.hasError && snapshot.error is NoFormulaSelectedException) {
                return _noFormulaSelectedWidget;
              } else if(snapshot.hasError){
                print("Error on _GridResultsState FutureBuilder: ${snapshot.error}");
                return UnexpectedErrorWidget();
              } else if (!snapshot.hasData || !validEntry) {
                /* If _estimatedRM is null, it means that entered weight/reps is not valid*/
                return _noDataAvailableWidget;
              } else {
                return GridView.count(
                  crossAxisCount: columnCount,
                  children: List.generate(12, (int index) {
                    /* Once we have the rm, we need to estimate every rep weight */
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: columnCount,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: Center(
                              child: ResultCard(
                                  weight: snapshot.data[index+1],
                                  reps: index + 1)
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }
          }
        }
    );
  }

  @override
  void setValidEntry(bool valid) {
    if (valid != validEntry){
      setState(() {
        validEntry = valid;
      });
    }
  }

  @override
  void updateResults(Future<Map<int, double>> results) {
    setState(() {
      validEntry = true;
      _estimations = results;
    });
  }

}

class ExerciseRecordsView extends StatefulWidget{
  @override
  _ExerciseRecordsViewState createState() => _ExerciseRecordsViewState();

}

class _ExerciseRecordsViewState extends State<ExerciseRecordsView> implements ExerciseRecordsViewContract{
  Exercise _exercise;
  Future<List<ExtendedRecord>> _records;

  @override
  void initState() {
    super.initState();
    MainPresenter().attachExerciseRecordsView(this);
    MainPresenter().loadRecordsSelectedExercise();
  }

  @override
  void dispose(){
    super.dispose();
    MainPresenter().detachExerciseRecordsView();
  }

  List<charts.Series<ExtendedRecord, DateTime>> _getChartSeries(List<ExtendedRecord> records){
    return [
      charts.Series<ExtendedRecord, DateTime>(
        id: '1RM',
        colorFn: (_, __) => charts.MaterialPalette.cyan.shadeDefault,
        domainFn: (ExtendedRecord record, _) => record.timestamp,
        measureFn: (ExtendedRecord record, _) => record.rm,
        data: records,
      )..setAttribute(charts.rendererIdKey, "1RM")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _records,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError){
                print("Error on _ExerciseRecordsViewState FutureBuilder: ${snapshot.error}");
                return UnexpectedErrorWidget();
              } else if (!snapshot.hasData || snapshot.data.length == 0) {
                /* If _estimatedRM is null, it means that entered weight/reps is not valid*/
                return Center(
                    child: Text(
                      _exercise==null ? "No exercise selected": "No data available for ${_exercise.name}",
                      style: titleStyleLighterBlack,)
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: charts.TimeSeriesChart(
                          _getChartSeries(snapshot.data),
                          animate: true,
                          customSeriesRenderers: [
                            charts.LineRendererConfig(
                              // ID used to link series to this renderer.
                                customRendererId: '1RM',
                                includeArea: true,
                                stacked: true
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: RecordListItem(record: snapshot.data[index]),
                              ),
                            ),
                          );
                        },
                      )
                    )
                  ],
                );
              }
          }
        }
    );
  }

  @override
  void loadExercise(Exercise exercise, Future<List<Record>> records) {
    setState(() {
      _exercise = exercise;
      _records = records;
    });
  }

}

class RecordListItem extends StatelessWidget{
  final ExtendedRecord record;

  const RecordListItem({Key key, @required this.record}) : super(key: key);

  Widget get basicInfo => Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              "${record.rm} kg",
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Text(
            "${record.weight}x${record.reps}",
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black54
            ),
          ),
        ],
      ),
      Text(
        DateFormat.yMMMMd('en_US').format(record.timestamp),
        style: const TextStyle(
            fontSize: 15,
            color: Colors.black45
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 12.0, bottom: 12.0, right: 16.0),
          child: record.description==null ? basicInfo :
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  basicInfo,
                  Divider(),
                  Text(
                    "\"${record.description}\"",
                    style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54
                    ),
                  )
                ],
              )
        ),
      ),
    );
  }

}

class TextInputCard extends StatefulWidget{
  final String cardTitle;
  final String hintText;
  final bool decimal;
  final ValueChanged<String> onChanged;
  final String text;

  TextInputCard({
    @required this.cardTitle,
    @required this.decimal,
    @required this.onChanged,
    this.text,
    this.hintText,
    Key key
  }) : super(key: key);

  @override
  _TextInputCardState createState() => _TextInputCardState();

}

class _TextInputCardState extends State<TextInputCard>
    with SingleTickerProviderStateMixin{
  TextEditingController _controller;
  FocusNode _focus;
  AnimationController _animationController;
  Animation<double> _animationTween;

  static const TextStyle cardTitleStyle = TextStyle(
      color: lightBlueIsh,
      fontWeight: FontWeight.bold,
      fontSize: 16
  );

  @override
  void initState() {
    super.initState();

    /* Init the text controller and set the initial text */
    _controller = TextEditingController(text: widget.text);

    /* Init the animation controllers */
    _animationController = AnimationController(
      duration: Duration(milliseconds: 30),
      vsync: this,
    );
    _animationTween =
        Tween(begin: 10.0, end: 20.0).animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });

    /* Set the listener which controls the animation */
    _focus = FocusNode();
    _focus.addListener((){
      if (_focus.hasFocus){
        _animationController.forward(from: _animationController.value);
      }else{
        _animationController.reverse(from: _animationController.value);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focus.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: widget.cardTitle,
      elevation: _animationTween.value,
      child: TextField(
        autofocus: false,
        maxLines: 1,
        textAlign: TextAlign.center,
        controller: _controller,
        focusNode: _focus,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText ?? "",
        ),
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: widget.decimal),
        inputFormatters: [DecimalTextInputFormatter(decimalRange: widget.decimal ? 2 : 0, signed: false)],
        onChanged: (val) => widget.onChanged(val),
      ),
    );
  }

}

class CustomCard extends StatelessWidget{
  final Widget child;
  final String title;
  final double elevation;

  static const TextStyle cardTitleStyle = TextStyle(
      color: lightBlueIsh,
      fontWeight: FontWeight.bold,
      fontSize: 18
  );

  static const RoundedRectangleBorder cardShape =  RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20))
  );

  const CustomCard({
    @required this.title,
    @required this.child,
    this.elevation: 10,
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: cardShape,
      elevation: elevation,
      child: Padding(
        padding: EdgeInsets.all(screenAwareSize(16.0, context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(this.title, style: cardTitleStyle),
            child
          ],
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget{
  final double weight;
  final int reps;

  const ResultCard({@required this.weight, @required this.reps, Key key}): super(key: key);

  static const TextStyle repsTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: lightBlueIsh,
  );

  static const TextStyle weightTextStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(this.reps.toString()+"RM", style: repsTextStyle),
        Text(this.weight.roundToDouble().toString(), style: weightTextStyle),
        Text("kg")
      ],
    );
  }

}
