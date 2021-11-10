import 'package:eburtis/screen/loarder.dart';
import 'package:eburtis/screen/search.dart';
import 'package:eburtis/screen/updatPage.dart';
import 'package:eburtis/state/maq.dart';
import 'package:eburtis/state/puissanc.dart';
import 'package:eburtis/state/transform.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'fadeAnimated.dart';
import 'firstPage.dart';
import '../model/model.dart';
import 'dart:convert' show utf8;



class ViewPage extends StatefulWidget {
  static const routeName = '/viewpage';

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  bool chargement = false;
  bool _init = true;
  TextEditingController _searchController = TextEditingController();
  FocusNode searchNode;
  bool isCategory = false;
  bool _isLoding = false;

  @override
  void didChangeDependencies() async {
    if (_init) {
      Provider.of<MaqState>(context, listen: false).getMarq();
      Provider.of<PuisState>(context, listen: false).getPuiss();
      Provider.of<TransState>(context, listen: false).getTrans();
      // _isLoding = await Provider.of<TransState>(context, listen: false).getPostData();
      setState(() {});
    }
    _init = false;
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {

    final ordis = Provider.of<TransState>(context).listTrans;

    if (ordis == null)
      return Scaffold(
        body: Center(
          child: Chargement(),
        ),
      );
    else
    return   Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            //ordis.length == 0 ? IconButton(icon: Icon(Icons.refresh, color: Colors.blue,), onPressed: () {
           //  Provider.of<TransState>(context).getTrans();
           // }) : SizedBox(width: 0,),
           // SizedBox(width: 10,)
          ],
          centerTitle: true,
          title: Text("Liste des transformateurs", style: TextStyle(color: Colors.blue),),
          elevation: 10,
          brightness: Brightness.light,
          backgroundColor: Colors.white,),


        body: RefreshIndicator(
          onRefresh: () async{
            Provider.of<TransState>(context, listen: false).getTrans();
                },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 15,),
               InkWell(
                 onTap: (){
                   showSearch(context: context, delegate: SearchUser());
                 },
                 child: Container(
                   height: 50,
                     decoration: BoxDecoration(
                         border: Border.all(color: Colors.grey)
                     ),
                   child: Row(
                  children: [
                    Text("     "),
                    Icon(Icons.search),
                    Text("Rechercher un transformateur ...")
              ],
            )
                 ),
               ),
               // ordis.length == 0
                //    ?  Column(
                //  children: [
                  //  SizedBox(height: 200,),
                  //  Center(
                   //   child: Text("Aucun transformateur disponible",style: TextStyle(fontSize: 30),),
                  //  ),
                //  ],
             //   )

                Expanded(
                    child: ListView.builder(

                        itemCount: ordis.length,
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
                              bool toto = await Provider.of<TransState>(context, listen: false).transDele(ordis[index].id);
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
                                              text: " ${ordis[index].identification} ?",
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
                                                  image: NetworkImage("http://192.168.1.12:8000${ordis[index].image}"), fit: BoxFit.fill),
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
                                                    "Identifiant : ${ordis[index].identification}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    maxLines: 4,
                                                  ),
                                                  Text(
                                                    "Status : ${ordis[index].status}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xff8a8989),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Marque : ${ordis[index].marque}",
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
                                                                return SignTranss( toto: ordis[index]);
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
                                                        showAlertDialog(context, ordis[index]);
                                                      },
                                                      icon: Icon(Icons.delete,
                                                        color: Colors.red,),
                                                    ),

                                                    IconButton(
                                                      onPressed: () {
                                                        showAlertDialog1(context, ordis[index]);
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
                    )),
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {

          Navigator.push(
              context,
              PageRouteBuilder(pageBuilder: (context, animations, animationTime,) {
                return SignTrans();
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
        child: const Icon(Icons.add,size: 30, color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
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