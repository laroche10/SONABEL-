import 'dart:convert';
import 'package:eburtis/model/model.dart';
import 'package:eburtis/model/modelpuiss.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

class   PuisState with ChangeNotifier {

  List<Puisance> _trans;


  // OBTENIR TRANSFORMATEUR
  Future<void> getPuiss() async {
    try {
      String url = 'http://192.168.1.12:8000/api/puissance/';
      http.Response response = await http.get(url);
      var data =json.decode(response.body) as List;
      List<Puisance> temp = [];
      data.forEach((element) {
        Puisance post = Puisance.fromJson(element);
        temp.add(post);
      });

      _trans = temp;
      print("==========================");
      print(data);
      print("==========================");
      notifyListeners();
    } catch (e) {
      print("==========GET ORROR   TRANSFORMATEUR ================");
      print(e);
    }
  }


// OBTENIR LES LIST service
  List<Puisance> get listPui {
    if (_trans != null) {
      return  [..._trans.reversed];
    }
    return null;
  }



}