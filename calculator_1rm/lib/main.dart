import 'package:calculator_1rm/fabBottomNavigationBar.dart';
import 'package:calculator_1rm/settingsPage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:calculator_1rm/decimalTextInputFormatter.dart';
import 'package:calculator_1rm/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/calculator.dart';

void main() => runApp(RMCalculator());

class RMCalculator extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1RM Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
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

class _MainPageState extends State<MainPage> {
  double enteredWeight;
  int enteredReps;
  Future<Map<int, double>> _estimations;
  int _currentTabIndex = 0;

  static const Duration animatePageDuration = Duration(milliseconds: 300);
  static const Widget _noDataAvailableWidget =  Center(child: Text("No data available", style: titleStyleLighterBlack,));
  static const Widget _noFormulaSelectedWidget =  Center(child: Text("No formula selected", style: titleStyleLighterBlack,));

  bool get validEntry{
    return enteredWeight != null && enteredReps != null && enteredWeight != 0 && enteredReps != 0;
  }

  calculateReps(){
    if (validEntry){
       _estimations = Calculator.estimateReps(this.enteredWeight, this.enteredReps, 12);
    }

    setState(() {});
  }

  void onWeightChanged(String weight){
    this.enteredWeight = double.tryParse(weight);
    calculateReps();
  }

  void onRepsChanged(String reps){
    this.enteredReps = int.tryParse(reps);
    calculateReps();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = 4;
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                AnimatedContainer(
                  duration: animatePageDuration,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: _currentTabIndex==0 ? 40:10),
                  constraints: BoxConstraints.expand(height: _currentTabIndex==0 ? 225:100),
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
                    padding: EdgeInsets.only(top: _currentTabIndex==0 ? 50:34),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('1RM Calculator', style: titleStyleWhite,)
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,  //StatusBar Height + 10
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.settings, size: 28, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => SettingsPage()),
                      ).then((value) {
                        calculateReps();
                      });
                    },
                  )
                ),
                AnimatedOpacity(
                  duration: animatePageDuration,
                  opacity: _currentTabIndex==0 ? 1.0:0.0,
                  child: AnimatedContainer(
                    duration: animatePageDuration,
                    margin: EdgeInsets.only(left: 10, right: 10, top:_currentTabIndex==0 ? 170:0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child: TextInputCard(cardTitle: "Weight", hintText: "Required", decimal: true, onChanged: onWeightChanged,)),
                        Expanded(child: TextInputCard(cardTitle: "Reps", hintText: "Required" ,decimal: false, onChanged: onRepsChanged)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: FutureBuilder(
                    future: _estimations,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      switch (snapshot.connectionState){
                        case ConnectionState.waiting:
                          return Container();
                        default:
                          if (snapshot.hasError && snapshot.error is NoFormulaSelectedException) {
                            return _noFormulaSelectedWidget;
                          } else if(snapshot.hasError){
                            return Center(child: Text("Unexpected error: $snapshot.error"));
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
                ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {

          });
        },
        backgroundColor: lightBlueIsh,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FABBottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: lightBlueIsh,
        unselectedItemColor: Colors.black45,
        onTap: this._onTabTapped,
        notchedShape: CircularNotchedRectangle(),
        currentIndex: this._currentTabIndex,
        // TODO: Add items text, animations, double tap to just refresh, etc
        items: [
          new FABBottomNavigationBarItem(
            icon: Icons.access_time,
            title: 'Alarms',
          ),
          new FABBottomNavigationBarItem(
            icon: Icons.calendar_today,
            title: 'Calendar',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index){
    setState(() => this._currentTabIndex = index);
  }
}

class TextInputCard extends StatelessWidget{
  final String cardTitle;
  final String hintText;
  final bool decimal;
  final ValueChanged<String> onChanged;

  const TextInputCard({
    @required this.cardTitle,
    @required this.decimal,
    @required this.onChanged,
    this.hintText,
    Key key
  }) : super(key: key);

  static const TextStyle cardTitleStyle = TextStyle(
      color: lightBlueIsh,
      fontWeight: FontWeight.bold,
      fontSize: 16
  );


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(this.cardTitle, style: cardTitleStyle),
            TextField(
              autofocus: false,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.hintText ?? "",
              ),
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: this.decimal),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: this.decimal ? 2 : 0, signed: false)],
              onChanged: (val) => this.onChanged(val),
            ),
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
