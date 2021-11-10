import 'package:eburtis/model/modelmaq.dart';
import 'package:eburtis/screen/firstPage.dart';
import 'package:eburtis/screen/secondPage.dart';
import 'package:eburtis/state/maq.dart';
import 'package:eburtis/state/puissanc.dart';
import 'package:eburtis/state/transform.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => TransState()),
        ChangeNotifierProvider(create: (ctx) => PuisState()),
        ChangeNotifierProvider(create: (ctx) => MaqState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Transformateurs',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ViewPage(),

        routes: {
          ViewPage.routeName : (ctx) => ViewPage(),
        },
      ),
    );
  }
}

