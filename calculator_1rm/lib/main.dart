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
  double estimated1RM;

  calculateReps(){
    setState(() {
      if (enteredWeight == null || enteredReps == null){
        estimated1RM = null;
      }else{
        estimated1RM = Calculator.estimateRM(this.enteredWeight, this.enteredReps)
            .roundToDouble();
      }
    });
  }

  void onWeightChanged(String weight){
    this.enteredWeight = double.tryParse(weight);
    calculateReps();
  }

  void onRepsChanged(String reps){
    this.enteredReps = int.tryParse(reps);
    calculateReps();
  }

  Widget getResultsGrid(){
    return GridView.count(
      crossAxisCount: 4,
      children: List.generate(12, (int index) {
        double weight = Calculator.estimateWeight(this.estimated1RM, index+1);
        return Center(
            child: ResultCard(weight: weight, reps: index+1)
        );
      }),
    );
  }

  @override
  Widget build2(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: TextInputCard(cardTitle: "Weight", decimal: true, onChanged: onWeightChanged,)),
                Expanded(child: TextInputCard(cardTitle: "Reps", decimal: false, onChanged: onRepsChanged)),
              ],
            ),
            Expanded(
                child: this.estimated1RM == null ? Text("No data available"): getResultsGrid()
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(40),
                  constraints: BoxConstraints.expand(height: 225),
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
                    padding: EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('1RM Calculator', style: titleStyleWhite,)
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 170, left: 10, right: 10),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(child: TextInputCard(cardTitle: "Weight", hintText: "Required", decimal: true, onChanged: onWeightChanged,)),
                      Expanded(child: TextInputCard(cardTitle: "Reps", hintText: "Required" ,decimal: false, onChanged: onRepsChanged)),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: this.estimated1RM != null ? getResultsGrid()
                    : Center(child: Text("No data available", style: titileStyleLighterBlack,)),
            )
          ],
        ),
      ),
    );
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
              autofocus: true,
              maxLines: 1,
              textAlign: TextAlign.center,
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
