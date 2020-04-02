import 'package:calculator_1rm/models/settings.dart';
import 'package:calculator_1rm/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPageState createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage>{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<Map<String, bool>> _loadedSettings;


  Future setUserSetting(String setting, bool value) async{
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(setting, value);
    setState(() {
      _loadedSettings.then((Map<String, bool> map) {
        map[setting] = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadedSettings = Settings.loadUserSettings(_prefs);
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
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
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
                                onChanged: (value) {setUserSetting(name, value);},
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

}