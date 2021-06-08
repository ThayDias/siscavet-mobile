import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
//import 'package:date_format/date_format.dart';

class CadastrarConsultaPage extends StatefulWidget {
  @override
  _CadastrarPageState createState() {
    return _CadastrarPageState();
  }
}

class _CadastrarPageState extends State<CadastrarConsultaPage> {
  
  FirebaseUser usuarioCarregado;
  DateTime dataSelecionada = DateTime.now();
  TimeOfDay _horarioSelecionado = TimeOfDay.now();
  String _dataConsulta;
  String _horario;
  String _clinica;
  String _animal;
  String _descricao;

  bool _validate = false;
  var _formKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool validacao = false;

  String errorTextDataNascimento = '';
  String errorTextHorario = '';
  String errorTextClinica = '';
  String errorTextAnimal = '';

  bool redUnderLineDataNascimento = false;
  bool redUnderLineHorario = false;
  bool redUnderLineClinica = false;
  bool redUnderLineAnimal = false;

  final _dataController = new TextEditingController();
  final _horarioController = new TextEditingController(); 
  final _descricaoController = new TextEditingController(); 
  
    Future<String> _getUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  @override
  void initState() { 
    super.initState();
  }

  void _registrar(context) async {  
    _formKey.currentState.save(); 
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    var animal = await Firestore.instance.collection('Animais').document(_animal).get();

    var clinica = await Firestore.instance.collection('Clinicas').document(_clinica).get();

    Firestore.instance.collection('Consultas')
   .where("dataConsulta", isEqualTo: _dataController.value.text)
   .where("idHorario", isEqualTo: _horario)
   .where("idClinica", isEqualTo: _clinica).getDocuments().then(
     (value) async {

      if(value.documents.length == 0){
      var consulta = await Firestore.instance.collection('Consultas').add(
      {                
        "idUsuario": user.uid,
        "idAnimal": _animal,
        "idClinica": _clinica,
        "dataConsultaDateTime": dataSelecionada,
        "dataConsulta": _dataController.value.text,
        "idHorario": _horario,
        "clinicaNome": clinica.data["nome"],
        "animalNome": animal.data["nomeAnimal"],    
        "descricao": _descricaoController.text   
      }); 

      var urlExame = await _uploadPic(consulta.documentID);

      await Firestore.instance.collection('Consultas').document(consulta.documentID).updateData({
        "imagemExame": urlExame,        
      }).then((value){
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:  Color(0xFF1EC772),
            content: new Text('Sucesso!'),
            duration: new Duration(seconds: 2),
          )
        );
      });

      new Timer(const Duration(seconds: 2), () {
      setState(() {
        Navigator.of(context).pushReplacementNamed('/MinhasConsultas');   
        });
      });

    }else{
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:  Color(0xFFFA8072),
            content: new Text('Horário não disponível! Por favor, escolha outro horário!'),
            duration: new Duration(seconds: 5),
          ));
    }
     });
  
    
  }


  Future _selecionarData(context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dataSelecionada,
      firstDate: new DateTime.now(),
      lastDate: new DateTime.now().add(new Duration(days: 60)),
      locale: Locale('pt'),
      builder: (context, child) {
        return Theme(          
          data: 
          ThemeData(
              primarySwatch: Colors.green            
          ),
          child: child,
        );
      });

    if (picked != null && picked != dataSelecionada)
      setState(() {
        dataSelecionada = picked;
        var teste = picked.day.toString() + " / " + picked.month.toString() + " / " + picked.year.toString();
        _dataController.value = TextEditingValue(text: teste);
      });
      
  }

  // Pegando uma imagem da galeria
  Future _getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    final File file = File(image.path);

    if (file == null) return;

    final Directory docDir = await getApplicationDocumentsDirectory();
    final String path = docDir.path;

    final File localImage = await file.copy('$path/image1.png');

    setState(() {
      _image = localImage;
      print('Image Path $_image');
    });
  }

 //subindo a imagem animal
  Future<String> _uploadPic(String uid) async { 
    if(_image != null){
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(uid);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      var urlImagem = await firebaseStorageRef.getDownloadURL();      
      return urlImagem;  
    }else{
      return null;
    }           
  }  

  //validar campos de cadastro
  void _validarCampos(context) async {
    //validar Data Nascimento
    if (_dataController.value.text.isEmpty) {
      setState(() => redUnderLineDataNascimento = true);
      setState(() => errorTextDataNascimento = "Campo Obrigatório!");
      validacao = true;
    } else {
      setState(() => redUnderLineDataNascimento = false);
      setState(() => errorTextDataNascimento = "");
    }

    // validar Horario
    if (_horario == null) {
      setState(() => redUnderLineHorario = true);
      setState(() => errorTextHorario = "Campo Obrigatório!");
      validacao = true;
    } else {      
      setState(() => redUnderLineHorario = false);
      setState(() => errorTextHorario = "");     
    }

    //validar Clinica
    if (_clinica == null) {
      setState(() => redUnderLineClinica = true);
      setState(() => errorTextClinica = "Campo Obrigatório!");
      validacao = true;
    } else {
        setState(() => redUnderLineClinica = false);
        setState(() => errorTextClinica = "");     
    }    

    //validar Animal
    if (_animal == null) {
      setState(() => redUnderLineAnimal = true);
      setState(() => errorTextAnimal = "Campo Obrigatório!");
      validacao = true;
    } else {
        setState(() => redUnderLineAnimal = false);
        setState(() => errorTextAnimal = "");     
    }    


    if (validacao == false) {
      _registrar(context);
    }

    validacao = false;
  }

  //tempo que mensagem de erro é exibida na tela
  void _tempoExibicaoMensagemErro(context) async {
    new Timer(const Duration(seconds: 3), () {
      setState(() {
        errorTextDataNascimento = '';
        errorTextHorario = '';
        errorTextClinica = '';
        errorTextAnimal = '';
        redUnderLineDataNascimento = false;
        redUnderLineHorario = false;
        redUnderLineClinica = false;
        redUnderLineAnimal = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
            child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              color: Color(0xFFFFFFFF),
              //height: MediaQuery.of(context).size.height*0.97,
              child: Column(children: [
                //Logo
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    image: DecorationImage(
                        image: AssetImage('assets/images/LogoMobile2.png'),
                        fit: BoxFit.fitHeight),
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                ),

                //Siscavet
                Container(
                    color: Color(0xFFFFFFFF),
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(100, 10, 100, 5),
                        child: Text(
                          "SisCaVet",
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Times New Roman',
                              color: Color(0xFF1EC772)),
                        ),
                      )
                    ])),

                //titulo da tela
                Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 20),
                  child: Text('Cadastrar Nova Consulta',
                      style: TextStyle(color: Color(0xFF6F6D6D), fontSize: 16)),
                ),

                Form(
                  key: _formKey,
                  autovalidate: _validate,
                  child: Column(
                    children: <Widget>[
                      //data da consulta
                      GestureDetector(
                        onTap: () {
                          _selecionarData(context);
                        },
                        child: AbsorbPointer(
                          child: Container(
                              margin: EdgeInsets.fromLTRB(25, 30, 25, 10),
                              child: Column(children: [
                                Container(
                                    child: Material(
                                        elevation: 2.0,
                                        shadowColor: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        child: TextFormField(
                                          controller: _dataController,
                                          keyboardType: TextInputType.datetime,
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                  Icons.calendar_today,
                                                  color: Color(0xFF969696)),
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              border: InputBorder.none,
                                              hintText: 'Data da Consulta',
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF6F6D6D),
                                                  height: 1.42),
                                              labelText: 'Data da Consulta',
                                              labelStyle: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF969696),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                                borderSide: redUnderLineDataNascimento
                                                    ? BorderSide(
                                                        color: Colors.red)
                                                    : BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 2),
                                              )),
                                          onSaved: (value) => _dataConsulta = value,
                                        )))
                              ])),
                        ),
                      ),

                      //mensagem de erro
                      Text(errorTextDataNascimento, style: TextStyle(color: Colors.red)),

                       //horarios
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 30, 25, 10),
                        child: Column(children: [
                          Container(
                              child: Material(
                                  elevation: 2.0,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.0)),
                                  child: 
                                  StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection('Horarios').orderBy("ordem").snapshots(),
                                    builder: (context, snapshot){
                                      List<DropdownMenuItem> animaisCarregados = [];
                                      if(!snapshot.hasData){
                                        Text("Carregando");                            
                                      }else{                                                       
                                        for(int i=0; i< snapshot.data.documents.length; i++){
                                          DocumentSnapshot snap = snapshot.data.documents[i];
                                          animaisCarregados.add(
                                            DropdownMenuItem(
                                              child: 
                                              Text(                                    
                                                snap.data['horario'].toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF000000),
                                                  ),
                                              ),
                                              value: "${snap.documentID}",                                      
                                            )
                                          );
                                        }
                                      }

                                      return Container(
                                        child: 
                                        DropdownButtonFormField(                                                                                                                         
                                          items: animaisCarregados, 
                                          value: _horario,                                                
                                          onSaved: (value) => _horario = value, 
                                          decoration: InputDecoration(
                                              hintText: 'Horário',
                                              hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF6F6D6D),
                                              height: 1.42),
                                              labelText: 'Horário',
                                              labelStyle: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF969696),
                                              ),
                                              contentPadding:
                                              EdgeInsets.all(10.0),
                                              border: InputBorder.none,
                                              enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                              borderSide: redUnderLineHorario ? BorderSide( color: Colors.red) : BorderSide( color: Colors.transparent, width: 2),
                                              )
                                            ), onChanged: (value) {
                                                setState(() {
                                                  _horario = value;
                                                });
                                              },
                                        )
                                      );
                                    },
                                  ),
                                  
                                )
                              )
                        ])
                      ),

                      //mensagem de erro
                      Text(errorTextHorario, style: TextStyle(color: Colors.red)),
                      
                      //clinica veterinaria
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 30, 25, 10),
                        child: Column(children: [
                          Container(
                              child: Material(
                                  elevation: 2.0,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.0)),
                                  child: 
                                  StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection('Clinicas').snapshots(),
                                    builder: (context, snapshot){
                                      List<DropdownMenuItem> animaisCarregados = [];
                                      if(!snapshot.hasData){
                                        Text("Carregando");                            
                                      }else{                                                       
                                        for(int i=0; i< snapshot.data.documents.length; i++){
                                          DocumentSnapshot snap = snapshot.data.documents[i];
                                          animaisCarregados.add(
                                            DropdownMenuItem(
                                              child: 
                                              Text(                                    
                                                snap.data['nome'].toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF000000),
                                                  ),
                                              ),
                                              value: "${snap.documentID}",                                      
                                            )
                                          );
                                        }
                                      }

                                      return Container(
                                        child: 
                                        DropdownButtonFormField(                                                                                                                         
                                          items: animaisCarregados, 
                                          value: _clinica,                                                
                                          onSaved: (value) => _clinica = value, 
                                          decoration: InputDecoration(
                                              hintText: 'Clínica Veterinária',
                                              hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF6F6D6D),
                                              height: 1.42),
                                              labelText: 'Clínica Veterinária',
                                              labelStyle: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF969696),
                                              ),
                                              contentPadding:
                                              EdgeInsets.all(10.0),
                                              border: InputBorder.none,
                                              enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                              borderSide: redUnderLineClinica ? BorderSide( color: Colors.red) : BorderSide( color: Colors.transparent, width: 2),
                                              )
                                            ), onChanged: (value) {
                                                setState(() {
                                                  _clinica = value;
                                                });
                                              },
                                        )
                                      );
                                    },
                                  ),
                                  
                                )
                              )
                        ])
                      ),

                      //mensagem de erro
                      Text(errorTextClinica, style: TextStyle(color: Colors.red)),
                      
                      //animais
                       Container(
                        margin: EdgeInsets.fromLTRB(25, 30, 25, 10),
                        child: Column(children: [
                          Container(
                              child: Material(
                                  elevation: 2.0,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.0)),
                                  child: 
                                  FutureBuilder(
                                    future: _getUser(),
                                    builder: (_, snapshot) {
                                      if(!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }else{
                                         return StreamBuilder<QuerySnapshot>(                                        
                                      stream: Firestore.instance.collection('Animais').where('idUsuario', isEqualTo: snapshot.data).snapshots(),                                      
                                      builder: (context, snapshot){                                        
                                        List<DropdownMenuItem> animaisCarregados = [];
                                        if(!snapshot.hasData){
                                          Text("Carregando");                            
                                        }else{                                                       
                                          for(int i=0; i< snapshot.data.documents.length; i++){
                                            DocumentSnapshot snap = snapshot.data.documents[i];
                                            animaisCarregados.add(
                                              DropdownMenuItem(
                                                child: 
                                                Text(                                    
                                                  snap.data['nomeAnimal'].toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFF000000),
                                                    ),
                                                ),
                                                value: "${snap.documentID}",                                      
                                              )
                                            );
                                          }
                                        }

                                        return Container(
                                          child: 
                                          DropdownButtonFormField(                                                                                                                         
                                            items: animaisCarregados,
                                            value: _animal,                                                 
                                            onSaved: (value) => _animal = value, 
                                            decoration: InputDecoration(
                                                hintText: 'Animais',
                                                hintStyle: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF6F6D6D),
                                                height: 1.42),
                                                labelText: 'Animais',
                                                labelStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF969696),
                                                ),
                                                contentPadding:
                                                EdgeInsets.all(10.0),
                                                border: InputBorder.none,
                                                enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                                borderSide: redUnderLineAnimal ? BorderSide( color: Colors.red) : BorderSide( color: Colors.transparent, width: 2),
                                                )
                                              ), onChanged: (value) {
                                                  setState(() {
                                                    _animal = value;
                                                  });
                                                },
                                          )
                                        );
                                      },
                                    );
                                    
                                      }
                                     }
                                  ),
                                    
                                )
                              )
                        ])
                      ),

                      //mensagem de erro
                      Text(errorTextAnimal, style: TextStyle(color: Colors.red)),
                      
                          //Descrição
                          Container(
                            margin: EdgeInsets.fromLTRB(25, 25, 15, 10),
                            child: SizedBox(
                                width: 300,    
                                child: Form(                        
                                child: Material (                          
                                  elevation: 2.0,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  child: TextFormField(
                                    controller: _descricaoController,
                                    onSaved: (value) => _descricao = value, 
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      hintText:'Descrição',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6F6D6D),
                                        height: 1.42
                                      ),
                                      labelText: 'Descrição',
                                      labelStyle: TextStyle(
                                        fontSize: 14, 
                                        color: Color(0xFF969696),                              
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: BorderSide(color: Colors.transparent, width: 2),                                    )
                                    )
                                  )
                                )
                              )
                            ),
                          ),
                                                    
                          //carteirinha exame
                          Container(
                            margin: EdgeInsets.fromLTRB(25, 25, 25, 5),
                            child: Text('Exames', 
                            style: TextStyle(
                              color: Color(0xFF000000),
                              //decoration: TextDecoration.underline,
                              fontSize: 14
                            )
                            ),
                          ), 

                          //imagem exame
                          GestureDetector(
                              onTap: _getImage,
                              child: _image == null ? Container(
                                margin: EdgeInsets.fromLTRB(50, 10, 50, 5),
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Color(0xFFFFFFFF),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/imagemGaleria.png'),
                                    fit: BoxFit.fitHeight  
                                    ),
                                ), 
                              )
                              : Container(
                                height: 100,
                                margin: EdgeInsets.fromLTRB(50, 10, 50, 5),
                                //width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover
                              )
                            ),
                          )
                        ),

                          //adicionar exame
                          GestureDetector(
                              onTap: _getImage,
                              child: Text('Adicionar Exame (Opcional)', 
                              style: TextStyle(
                                color: Color(0xFF648365),
                                decoration: TextDecoration.underline,
                                fontSize: 14
                              )
                              ),
                            ), 

                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(25, 50, 25, 50),
                  child: Row(
                    children: <Widget>[
                      //voltar
                      SizedBox(
                        width: 150,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.of(context)
                                  .pushReplacementNamed('/MinhasConsultas');
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(25, 0, 25, 50),
                            child: Material(
                              elevation: 2.0,
                              shadowColor: Colors.grey,
                              color: Color(0xFFFA8072),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              child: OutlineButton(
                                child: Text(
                                  'Voltar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                disabledBorderColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 150,
                        child: GestureDetector(
                          onTap: () {
                            _validarCampos(context);
                            _tempoExibicaoMensagemErro(context);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(25, 0, 25, 50),
                            child: Material(
                              elevation: 2.0,
                              shadowColor: Colors.grey,
                              color: Color(0xFF1EC772),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              child: OutlineButton(
                                child: Text(
                                  'Salvar',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                disabledBorderColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        )
      )
    );
  }
}
