import 'package:eburtis/model/model.dart';
import 'package:eburtis/screen/updatPage.dart';
import 'package:eburtis/state/transform.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'fadeAnimated.dart';


class FetchUserList {

  var data = [];
  List<Transformateur> results = [];
  String urlList = 'http://192.168.1.12:8000/api/transformateur/';

  Future<List<Transformateur>> getuserList({String query}) async {
    var url = Uri.parse(urlList);
    try {;
      var response =  await http.get(url);
      if (response.statusCode == 200) {

        data = json.decode(response.body);
        results = data.map((e) => Transformateur.fromJson(e)).toList();
        if (query!= null){
          results = results.where((element) => element.identification.toLowerCase().contains((query.toLowerCase()))).toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}








class SearchUser extends SearchDelegate {
  FetchUserList _userList = FetchUserList();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return FutureBuilder<List<Transformateur>>(
        future: _userList.getuserList(query: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Transformateur> data = snapshot.data;
          return ListView.builder(

                        itemCount: data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          // var s = ordis[index].status.status;
                          // var encoded = s.substring(4, s.indexOf('Ã©'));
                          return  Dismissible(
                            key:  UniqueKey(),
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Supprimer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ),


                            onDismissed: (d) async{
                              bool toto = await Provider.of<TransState>(context, listen: false).transDele(data[index].id);
                              toto ?Fluttertoast.showToast(msg: "Supprimer avec succes",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 10) : Fluttertoast.showToast(msg: "Echec de suppression, veuillez réessayer svp!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 10);
                            },

                            confirmDismiss: (dir) async{
                              bool b = await showDialog(context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      content:  RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: " voulez-vous supprimer le transformateur ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,

                                              ),
                                            ),
                                            TextSpan(
                                              text: " ${data[index].identification} ?",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,

                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                      actions: [
                                        IconButton(icon: Icon(Icons.delete, color: Colors.redAccent,), onPressed: () {
                                          Navigator.of(context).pop(true);
                                        }),

                                        IconButton(icon: Icon(Icons.close), onPressed: () {
                                          Navigator.of(context).pop(false);
                                        }),
                                      ],
                                    );
                                  });

                              return b;
                            },


                            child: FadeAnimation2(
                              0.5,
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                                child: Card(
                                  elevation: 2.0,
                                  child: Container(
                                      height: 106,
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 105,
                                            width: 155,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              image: DecorationImage(
                                                  image: NetworkImage("http://192.168.1.12:8000${data[index].image}"), fit: BoxFit.fill),
                                            ),
                                          ),
                                          SizedBox(width: 6,),
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Text(
                                                    "Identifiant : ${data[index].identification}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 4,
                                                  ),
                                                  Text(
                                                    "Status : ${data[index].status}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xff8a8989),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Marque : ${data[index].marque}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xff8a8989),
                                                    ),
                                                  ),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (
                                                                    context,
                                                                    animations,
                                                                    animationTime,
                                                                    ) {
                                                                  return SignTranss( toto: data[index]);
                                                                },
                                                                transitionDuration: Duration(seconds: 1),
                                                                transitionsBuilder:
                                                                    (context, animations, animationTime, child) {
                                                                  animations = CurvedAnimation(
                                                                      parent: animations, curve: Curves.easeIn);
                                                                  return ScaleTransition(
                                                                      alignment: Alignment.center,
                                                                      child: child,
                                                                      scale: animations);
                                                                },
                                                              ));
                                                        },
                                                        icon: Icon(Icons.edit_location_outlined,
                                                          color: Colors.blue,),
                                                      ),

                                                      IconButton(
                                                        onPressed: () {
                                                          showAlertDialog(context, data[index]);
                                                        },
                                                        icon: Icon(Icons.delete,
                                                          color: Colors.red,),
                                                      ),

                                                      IconButton(
                                                        onPressed: () {
                                                          showAlertDialog1(context, data[index]);
                                                        },
                                                        icon: Icon(Icons.remove_red_eye,
                                                          color: Colors.blue,),
                                                      ),
                                                    ],)

                                                ],
                                              )),
                                        ],
                                      )
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                    );

          });}


  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Recherche transformateur'),
    );
  }
}






showAlertDialog(BuildContext context, Transformateur id) {

  // set up the buttons
  Widget cancelButton = RaisedButton(
    elevation: 10,
    color: Colors.blue,
    child: Text("annuler"),
    onPressed:  () {

      Navigator.pop(context);
    },
  );
  Widget continueButton = RaisedButton(
    color: Colors.blue,
    elevation: 10,
    child: Text("supprimer"),
    onPressed:  () async{
      bool toto = await Provider.of<TransState>(context, listen: false).transDele(id.id);
      toto ?Fluttertoast.showToast(msg: "Supprimer avec succes",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 10) : Fluttertoast.showToast(msg: "Echec de suppression, veuillez réessayer svp!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10);
      Provider.of<TransState>(context, listen: false).transDele(id.id);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

    title: Text("Suppression"),
    content: Text("voulez-vous supprimer le transformateur ${id.identification} ? "),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



showAlertDialog1(BuildContext context, Transformateur toto) {

  // set up the button
  Widget okButton = RaisedButton(
    color: Colors.blue,
    elevation: 10,
    child: Text("Fermer"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Detail du transformateur", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
    content:SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 150),
        child: Center(
          child: Column(
            children: [
              Card(
                elevation: 20,
                child: Container(
                  child: Image.network("http://192.168.1.12:8000${toto.image}", fit: BoxFit.cover,),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(height: 30,),
              RichText(
                text: TextSpan(
                  text: ' ',
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(text: 'Identification transformateur :                                                                               ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${toto.identification}", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

              SizedBox(height: 30,),

              RichText(
                text: TextSpan(
                  text: ' ',
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(text: 'Status transformateur :                                                                               ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${toto.status}", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

              SizedBox(height: 30,),


              RichText(
                text: TextSpan(
                  text: ' ',
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(text: 'Numero de serie transformateur :                                                                               ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${toto.numeroSerie}", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

              SizedBox(height: 30,),

              RichText(
                text: TextSpan(
                  text: ' ',
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(text: 'Maque transformateur :                                                                               ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${toto.marque}", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

              SizedBox(height: 30,),

              RichText(
                text: TextSpan(
                  text: ' ',
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(text: 'Puissance de court-circuit :                                                                               ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${toto.puissance}", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

              SizedBox(height: 30,),

              RichText(
                text: TextSpan(
                  text: ' ',
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(text: "Poids de l'huile transformateur :                                                                               ", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${toto.poidsHuile}", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),


              SizedBox(height: 30,),

              RichText(
                text: TextSpan(
                  text: ' ',
                  style: DefaultTextStyle.of(context).style,
                  children:  <TextSpan>[
                    TextSpan(text: "Poids total transformateur :                                                                               ", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: " ${toto.poidsTotal}", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

            ],),
        ),
      ),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}