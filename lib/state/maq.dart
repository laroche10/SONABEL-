import 'dart:convert';
import 'package:eburtis/model/modelmaq.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

class   MaqState with ChangeNotifier {

  List<Marq> _trans;


  // OBTENIR TRANSFORMATEUR
  Future<void> getMarq() async {
    try {
      String url = 'http://192.168.1.12:8000/api/status/';
      http.Response response = await http.get(url);
      var data =json.decode(response.body) as List;
      List<Marq> temp = [];
      data.forEach((element) {
        Marq post = Marq.fromJson(element);
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
  List<Marq> get listMarq {
    if (_trans != null) {
      return  [..._trans.reversed];
    }
    return null;
  }



}