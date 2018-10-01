import 'package:flutter/material.dart';
import 'package:tab_maker/screens/main_screen.dart';
import 'package:tab_maker/blocs/provider.dart';
import 'package:device_id/device_id.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      child: MaterialApp(
        title: 'Tab Maker Demo',
        theme: _buildThemeData(),
        home: FutureBuilder<String>(
          future: DeviceId.getID,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot){
            print(snapshot.connectionState);
            print(snapshot.hasData);
            if(snapshot.hasError) print("Has Error");
            if(snapshot.hasData){
              return MainScreen(deviceId: snapshot.data);
            }
            return Center(child: CircularProgressIndicator(),);
          }
        ),
      ),
    );
  }

  ThemeData _buildThemeData() {
    final baseTheme = ThemeData.light();

    return baseTheme.copyWith(
      primaryColor: Color.fromRGBO(115,15,0,1.0),
      primaryColorLight: Color.fromRGBO(115,15,0,0.5),
      accentColor: Colors.orangeAccent,
      scaffoldBackgroundColor: Color.fromRGBO(235, 235, 235, 1.0),
      bottomAppBarColor: Colors.white,
      buttonColor: Colors.orangeAccent,
      indicatorColor: Colors.orangeAccent,
      hintColor: Color.fromRGBO(192,192,192,1.0),
      textTheme: TextTheme(
        display1: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(192, 192, 192, 1.0)),
        display2: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(192, 192, 192, 1.0)),
        display3: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(192, 192, 192, 1.0)),
        display4: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(192, 192, 192, 1.0)),
        headline: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(88, 88, 88, 1.0)),
        title: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(88, 88, 88, 1.0)),
        subhead: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(88, 88, 88, 1.0)),
        body1: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(88, 88, 88, 1.0)),
        body2: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(88, 88, 88, 1.0)),
        caption: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(192, 192, 192, 1.0)),
        button: TextStyle(fontFamily: "Archivo",color: Color.fromRGBO(88, 88, 88, 1.0), fontWeight: FontWeight.w600),
      ),
    );
  }
}
