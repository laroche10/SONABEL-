
import 'dart:ffi';
import 'package:eburtis/model/model.dart';
import 'package:eburtis/state/maq.dart';
import 'package:eburtis/state/puissanc.dart';
import 'package:eburtis/state/transform.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'loarder.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

class SignTranss extends StatefulWidget {

  final Transformateur toto;
  SignTranss({
    this.toto,
  });

  @override
  _SignTranssState createState() => _SignTranssState();
}

class _SignTranssState extends State<SignTranss> {


  String identifiant = '';
  String puissance = '';
  String numeroseri = '';
  String poids_huil ="";
  String poids_to ="";

  File _fichierSelectionE;
  bool _enProcessus = false;
  bool chargement = false;
  final _formKey = GlobalKey<FormState>();

  obtenirImage(ImageSource source) async {

    setState(() {
      _enProcessus = true;
    });

    File image = await ImagePicker.pickImage(source: source);
    if(image != null){
      File croppE = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.png,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.white,
            toolbarTitle: 'Rognez l\'image',
            statusBarColor: Colors.amber,
            backgroundColor: Colors.black,
          ));
      this.setState((){
        _fichierSelectionE = croppE;
        _enProcessus = false;
      });
    }else{
      this.setState((){
        _enProcessus = false;
      });
    }
  }

  var _currencies = [
    "Privé",
    "Public",
  ];

  var _currencies1 = [
    "France transfo",
    "France transfo2",

  ];


  var _currencies2 = [
    "court-circuit 1",
    "court-circuit 2",
  ];

  String _currentSelectedValue;
  String _currentSelectedValue1;
  String _currentSelectedValue2;


  Future<bool> asynnnb() async{

    final uri = Uri.parse("http://192.168.1.12:8000/api/transformateur/");
    var request = http.MultipartRequest('POST', uri);
    request.fields['identification'] = identifiant;
    request.fields['numero_serie'] = numeroseri;
    request.fields['poids_huile'] = poids_huil;
    request.fields['poids_total'] = poids_to;
    request.fields['status'] = _currentSelectedValue;
    request.fields['marque'] = _currentSelectedValue1;
    request.fields['puissance'] = _currentSelectedValue2;
    var pic = await http.MultipartFile.fromPath("image", _fichierSelectionE.path);
    request.files.add(pic);

    var response = await request.send();
    if(response.statusCode == 201){
      return true;
    }else
    {
      return false;
    }
  }




  Future<bool> asynnnbb(int id) async{
    final uri = Uri.parse("http://192.168.1.12:8000/api/detailtransformateur/${id}/");
    var request = http.MultipartRequest('PUT', uri);
    request.fields['identification'] = identifiant;
    request.fields['numero_serie'] = numeroseri;
    request.fields['poids_huile'] = poids_huil;
    request.fields['poids_total'] = poids_to;
    request.fields['status'] = _currentSelectedValue;
    request.fields['marque'] = _currentSelectedValue1;
    request.fields['puissance'] = _currentSelectedValue2;
    var pic = await http.MultipartFile.fromPath("image", _fichierSelectionE.path);
    request.files.add(pic);

    var response = await request.send();
    if(response.statusCode == 201){
      return true;
    }else
    {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final marq = Provider.of<MaqState>(context).listMarq;
    final pui = Provider.of<PuisState>(context).listPui;

    return chargement ? Chargement() : Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Modifier un transformateur", style: TextStyle(color: Colors.blue),),
        elevation: 10,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,),
        ),
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)
                    ),
                    child:  _fichierSelectionE != null ? CircleAvatar(
                        radius: 40.0,
                        backgroundImage: FileImage(_fichierSelectionE)
                    ) :
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        obtenirImage(ImageSource.camera);
                      },
                      icon: Icon(Icons.camera_alt_outlined,
                        size: 50,
                        color: Colors.blue,),
                    ),

                  ),
                  SizedBox(width: 20,),
                  _fichierSelectionE != null ? SizedBox(width: 0,) :
                   CircleAvatar(
                      radius: 100.0,
                      backgroundImage: NetworkImage("http://192.168.1.12:8000${widget.toto.image}")
                  ),
                    SizedBox(width: 20,),
                ],),

                SizedBox(height: 50,),
                TextFormField(
                    initialValue: widget.toto.identification,
                  decoration: InputDecoration(
                      labelText: 'identifiant',
                      border: OutlineInputBorder()
                  ),

                  validator: (val) => val.isEmpty ? "Entrez l'identifiant " : null,
                  onChanged: (val) => identifiant = val,
                ),
                SizedBox(height: 30,),
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black) ,
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'selectionner le status',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                      isEmpty: _currentSelectedValue != null ? false : true,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSelectedValue,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _currentSelectedValue = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30,),
                TextFormField(
                    initialValue: widget.toto.numeroSerie,
                  decoration: InputDecoration(
                      labelText: 'numero serie',
                      border: OutlineInputBorder()
                  ),
                  validator: (val) => val.isEmpty ? "Entrez le numero de serie " : null,
                  onChanged: (val) => numeroseri = val,

                ),
                SizedBox(height: 30,),
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black) ,
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'selectionner la marque',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                      isEmpty: _currentSelectedValue1 != null ? false : true,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSelectedValue1,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _currentSelectedValue1 = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: _currencies1.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30,),
                FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black) ,
                          errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                          hintText: 'selectionner la puissance',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                      isEmpty: _currentSelectedValue2 != null ? false : true,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _currentSelectedValue2,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              _currentSelectedValue2 = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: _currencies2.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30,),
                TextFormField(
                    initialValue: widget.toto.poidsHuile,
                  decoration: InputDecoration(
                      labelText: 'poids huile',
                      border: OutlineInputBorder()
                  ),

                  validator: (val) => val.isEmpty ? "Entrez le poids de l'huile " : null,
                  onChanged: (val) => poids_huil = val,
                ),
                SizedBox(height: 30,),
                TextFormField(
                  initialValue: widget.toto.poidsTotal,
                  decoration: InputDecoration(
                      labelText: 'poids total',
                      border: OutlineInputBorder()
                  ),
                  validator: (val ) => val.isEmpty ? "Entrez le poids total " : null,
                  onChanged: (val) =>  poids_to = val,
                ),
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration:
                  BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border(
                        bottom: BorderSide(color: Colors.white),
                        top: BorderSide(color: Colors.white),
                        left: BorderSide(color: Colors.white),
                        right: BorderSide(color: Colors.white),

                      )

                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async{
                      if(_formKey.currentState.validate()){

                        setState(() => chargement = true);
                        bool toto =await asynnnbb(widget.toto.id);
                        toto ? Fluttertoast.showToast(msg: "Modifier avec succes",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 10) : Fluttertoast.showToast(msg: "echec veuillez réessayyer svp",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 10);
                        Provider.of<TransState>(context, listen: false).getTrans();

                      }
                      Navigator.pop(context);
                    },
                    color: Color(0xff0095FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),

                    ),
                    child: Text(
                      "Modifier", style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// we will be creating a widget for text field
Widget inputFile({ test}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[

      SizedBox(
        height: 5,
      ),
      TextField(
        decoration: InputDecoration(
            labelText : test,
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[400]
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            )
        ),
      ),
      SizedBox(height: 10,)
    ],
  );
}
Widget inputFile1({  test}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[

      SizedBox(
        height: 5,
      ),
      TextField(

        decoration: InputDecoration(
            labelText: test,
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[400]
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            )
        ),
      ),
      SizedBox(height: 10,)
    ],
  );
}
Widget inputFile2({test}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[

      SizedBox(
        height: 5,
      ),
      TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: test,
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[400]
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            )
        ),
      ),
      SizedBox(height: 10,)
    ],
  );
}
Widget inputFile3({test}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[

      SizedBox(
        height: 5,
      ),
      TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: test,
            contentPadding: EdgeInsets.symmetric(vertical: 0,
                horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey[400]
              ),

            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            )
        ),
      ),
      SizedBox(height: 10,)
    ],
  );
}


