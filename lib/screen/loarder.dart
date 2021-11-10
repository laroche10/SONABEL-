import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eburtis/state/transform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Chargement extends StatefulWidget {
  @override
  _ChargementState createState() => _ChargementState();
}

class _ChargementState extends State<Chargement> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: TextLiquidFill(
          text: 'EBURTIS',
          loadDuration: Duration(seconds: 4),
          waveColor: Colors.blueAccent,
          boxBackgroundColor: Colors.white,
          textStyle: TextStyle(
            fontSize: 90.0,
            fontWeight: FontWeight.bold,
          ),
          boxHeight: 300.0,
        ),
      )
    );
  }
}







