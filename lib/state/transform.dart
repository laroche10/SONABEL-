import 'dart:convert';
import 'package:eburtis/model/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;

class   TransState with ChangeNotifier {

  List<Transformateur> _trans;


  // OBTENIR TRANSFORMATEUR
  Future<void> getTrans() async {
    try {

      String url = 'http://192.168.1.12:8000/api/transformateur/';
      http.Response response = await http.get(url);
      var data =json.decode(response.body) as List;
      List<Transformateur> temp = [];
      data.forEach((element) {
        Transformateur post = Transformateur.fromJson(element);
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
  List<Transformateur> get listTrans {
    if (_trans != null) {
      return  [..._trans.reversed];
    }
    return null;
  }



  Future<bool> transDele(int id) async {
    try {

      String url = 'http://192.168.1.12:8000/api/detailtransformateur/${id}/';
      http.Response delete=  await http.delete(url);
      getTrans();
      return true;
    } catch (e) {
      print("==========GET ORROR   TO DELETE TRANSFORMATEUR ================");
      print(e);
      return false;
    }
  }


}