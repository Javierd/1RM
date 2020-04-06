import 'package:calculator_1rm/contracts/settings_contract.dart';
import 'package:calculator_1rm/presenters/settings_presenter.dart';
import 'package:calculator_1rm/utils/styles.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPageState createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage> implements SettingsPageContract{
  SettingsPresenter _presenter;
  Future<Map<String, bool>> _loadedSettings;

  @override
  void initState() {
    super.initState();
    _presenter = SettingsPresenter();
    _presenter.attachView(this);
    _presenter.loadUserSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
              Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              constraints: BoxConstraints.expand(height: 100),
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
                padding: EdgeInsets.only(top: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('1RM Calculator', style: titleStyleWhite,)
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadedSettings,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        print("Error on _SettingsPageState FutureBuilder: ${snapshot.error}");
                        return UnexpectedErrorWidget();
                      } else {
                        List<String> keys = snapshot.data.keys.toList();
                        return ListView.separated(
                            itemCount: snapshot.data.length,
                            separatorBuilder: (BuildContext context, int index) => const Divider(),
                            itemBuilder: (BuildContext context, int index){
                              String name = keys[index];
                              return CheckboxListTile(
                                value: snapshot.data[name],
                                title: Text(name),
                                onChanged: (value) {_presenter.setUserSetting(name, value);},
                              );
                            }
                        );
                      }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void updateUserSettings(Future<Map<String, bool>> result) {
    setState(() {
      _loadedSettings = result;
    });
  }

  @override
  void updateUserSetting(String name, bool newValue) {
    setState(() {
      _loadedSettings.then((Map<String, bool> map) {
        map[name] = newValue;
      });
    });
  }

}