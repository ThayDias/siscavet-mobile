
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CadastrarAnimalPage extends StatefulWidget {
  @override
  _CadastrarAnimalPageState createState() {
    return _CadastrarAnimalPageState();
  }
}

class _CadastrarAnimalPageState extends State<CadastrarAnimalPage> {
  
  String _nomeAnimal;
  String _especie;
  String _raca;
  String _idade;
  String _descricao;
  bool _validate = false;
  var _formKey = GlobalKey<FormState>();  
  File _image;
  File _image2;

  final picker = ImagePicker();  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool validacao = false;  

  String errorTextNomeAnimal = '';
  String errorTextEspecie = '';
  String errorTextRaca = ''; 
  String errorTextIdade = ''; 

  bool redUnderLineNomeAnimal = false;   
  bool redUnderLineEspecie = false;
  bool redUnderLineRaca = false;
  bool redUnderLineIdade = false;


  final _nomeAnimalController = TextEditingController();
  final _especieController = TextEditingController();
  final _racaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _descricaoController = TextEditingController();

  // Pegando uma imagem da galeria
  Future _getImage2() async{
    final image2 = await picker.getImage(source: ImageSource.gallery);
    final File file2 = File(image2.path);

    if (file2 == null) return;


    final Directory docDir = await getApplicationDocumentsDirectory();
    final String path = docDir.path;

    final File localImage2 = await file2.copy('$path/image2.png');

      setState(() {
          _image2 = localImage2;
          print('Image Path $_image2');
      });
    }

// Pegando uma imagem da galeria
  Future _getImage() async
  {
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

//validar campos de cadastro
  void _validarCampos() async {

    //validar nome animal
    if(_nomeAnimalController.value.text.isEmpty){
      setState(() => redUnderLineNomeAnimal = true);
      setState(() => errorTextNomeAnimal = "Campo Obrigatório!");
      validacao = true;
    }else{
      setState(() => redUnderLineNomeAnimal = false);
      setState(() => errorTextNomeAnimal = "");      
    } 

    // validar especie
    if(_especieController.value.text.isEmpty){
      setState(() => redUnderLineEspecie = true);                            
      setState(() => errorTextEspecie = "Campo Obrigatório!");
      validacao = true;                                   
    }else{
        setState(() => redUnderLineEspecie = false);                            
        setState(() => errorTextEspecie = "");             
      }

    //validar raca
    if(_racaController.value.text.isEmpty){
      setState(() => redUnderLineRaca = true);
      setState(() => errorTextRaca = "Campo Obrigatório!");
      validacao = true;
    } else{
        setState(() => redUnderLineRaca = false);
        setState(() => errorTextRaca = "");
    }  

    //validar idade
    if(_idadeController.value.text.isEmpty){
      setState(() => redUnderLineIdade = true);
      setState(() => errorTextIdade = "Campo Obrigatório!");
      validacao = true;
    }else{
        setState(() => redUnderLineIdade = false);
        setState(() => errorTextIdade = "");
    }  

    if(validacao == false){
      _registrar();                          
    } 
  }

  //tempo que mensagem de erro é exibida na tela
  void _tempoExibicaoMensagemErro(context) async {
    new Timer(const Duration(seconds: 3), () {
      setState(() {
        errorTextNomeAnimal = '';
        errorTextEspecie = '';
        errorTextRaca = '';
        errorTextIdade = '';      

        redUnderLineNomeAnimal = false;
        redUnderLineEspecie = false;
        redUnderLineRaca = false;
        redUnderLineIdade = false;
      });
    });
  }

  //subindo a imagem animal
  Future<String> _uploadPicImagemAnimal(String uid) async { 
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

  //subindo a imagem carteirinha de vacinação
  Future<String> _uploadPicCarteirinhaVacinacao(String uid) async { 
      if(_image != null){
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(uid);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image2);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        var urlImagem = await firebaseStorageRef.getDownloadURL();      
        return urlImagem;  
      }else{
        return null;  
      }           
    }  

  void _registrar() async {  
    _formKey.currentState.save(); 
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    
    var animal = await Firestore.instance.collection('Animais').add(
      {        
        "idUsuario": user.uid,
        "nomeAnimal": _nomeAnimalController.text,
        "especie": _especieController.text,
        "raca": _racaController.text,
        "idade": _idadeController.text,       
        "descricao": _descricaoController.text   
      }); 

      var urlImagemAnimal = await _uploadPicImagemAnimal(animal.documentID);
      var urlCarteirinhaVacinacao = await _uploadPicCarteirinhaVacinacao(animal.documentID);

      await Firestore.instance.collection('Animais').document(animal.documentID).updateData({
        "imagemAnimal": urlImagemAnimal,
        "carteirinhaVacinacao": urlCarteirinhaVacinacao
      }).then((value){
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:  Color(0xFF1EC772),
            content: new Text('Sucesso!'),
            duration: new Duration(seconds: 2),
          )
        );  

      new Timer(const Duration(seconds: 2), () {
      setState(() {
        Navigator.of(context).pushReplacementNamed('/MeusAnimais');   
        });
      });

      }).catchError((onError){
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:  Color(0xFFFA8072),
            content: new Text('Erro!'),
            duration: new Duration(seconds: 5),
          ));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Color(0xFFFFFFFF),
                //height: MediaQuery.of(context).size.height*0.97,
                child: Column(
                  children: [
                    //Logo
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        image: DecorationImage(
                          image: AssetImage('assets/images/LogoMobile2.png'),
                          fit: BoxFit.fitHeight                                      
                        ),
                      ),
                      height: MediaQuery.of(context).size.height*0.2,  
                    ),
                    
                    //Siscavet
                    Container(
                      color: Color(0xFFFFFFFF),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(100, 10, 100, 5),
                            child: Text("SisCaVet",
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Times New Roman',
                                color: Color(0xFF1EC772)                        
                              ),
                            ),
                          )
                        ]
                      )
                    ),
                    
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget> [
                          
                          //imagem animal 
                          GestureDetector(
                              onTap: _getImage,
                              child: _image == null ? Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(IconData(0xe853, fontFamily: 'MaterialIcons'), size: 100, color: Color(0xFF648365))
                              )
                              : Container(
                                height: 100,
                                width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                              image: DecorationImage(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover
                              )
                            ),
                              )
                            ),

                          //selecionar imagem de animal
                          GestureDetector(
                              onTap: _getImage,
                              child: Text('Adicionar Foto (Opcional)', 
                              style: TextStyle(
                                color: Color(0xFF648365),
                                decoration: TextDecoration.underline,
                                fontSize: 14
                              )
                              ),
                            ), 


                          //Nome do Animal
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
                                    controller: _nomeAnimalController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(100),
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      hintText:'Nome Animal',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6F6D6D),
                                        height: 1.42
                                      ),
                                      labelText: 'Nome Animal',
                                      labelStyle: TextStyle(
                                        fontSize: 14, 
                                        color: Color(0xFF969696),                              
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: redUnderLineNomeAnimal ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2),                                    )
                                    ),
                                  )
                                )
                              )
                            ),
                          ),
                          
                          //mensagem de erro
                          Text(errorTextNomeAnimal, style: TextStyle(color: Colors.red)),
                                
                          //Especie
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
                                    onSaved: (value) => _especie = value, 
                                    controller: _especieController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(100),
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      hintText:'Espécie',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6F6D6D),
                                        height: 1.42
                                      ),
                                      labelText: 'Espécie',
                                      labelStyle: TextStyle(
                                        fontSize: 14, 
                                        color: Color(0xFF969696),                              
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: redUnderLineEspecie ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2),                                    )
                                    )
                                  )
                                )
                              )
                            ),
                          ),
                          
                          //mensagem de erro
                          Text(errorTextEspecie, style: TextStyle(color: Colors.red)),
                                
                          //raca
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
                                    onSaved: (value) => _raca = value, 
                                    controller: _racaController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(100),
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      hintText:'Raça',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6F6D6D),
                                        height: 1.42
                                      ),
                                      labelText: 'Raça',
                                      labelStyle: TextStyle(
                                        fontSize: 14, 
                                        color: Color(0xFF969696),                              
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: redUnderLineRaca ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2),                                    )
                                    )
                                  )
                                )
                              )
                            ),
                          ),
                          
                          //mensagem de erro
                          Text(errorTextRaca, style: TextStyle(color: Colors.red)),
                                
                          //idade
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
                                    onSaved: (value) => _idade = value, 
                                    controller: _idadeController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      hintText:'Idade',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6F6D6D),
                                        height: 1.42
                                      ),
                                      labelText: 'Idade',
                                      labelStyle: TextStyle(
                                        fontSize: 14, 
                                        color: Color(0xFF969696),                              
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: redUnderLineIdade ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2),                                    )
                                    )
                                  )
                                )
                              )
                            ),
                          ), 
                          
                          //mensagem de erro
                          Text(errorTextIdade, style: TextStyle(color: Colors.red)),
                                
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
                                                    
                          //carteirinha de vacinação texto
                          Container(
                            margin: EdgeInsets.fromLTRB(25, 25, 25, 5),
                            child: Text('Carteirinha de vacinação', 
                            style: TextStyle(
                              color: Color(0xFF000000),
                              //decoration: TextDecoration.underline,
                              fontSize: 14
                            )
                            ),
                          ), 


                          //imagem carteirinha de vacinação
                          GestureDetector(
                              onTap: _getImage2,
                              child: _image2 == null ? Container(
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
                                    image: FileImage(_image2),
                                    fit: BoxFit.cover
                              )
                            ),
                              )
                            ),

                          //adicionar carteirinha de vacinação link
                          GestureDetector(
                              onTap: _getImage2,
                              child: Text('Adicionar Carteirinha de vacinação (Opcional)', 
                              style: TextStyle(
                                color: Color(0xFF648365),
                                decoration: TextDecoration.underline,
                                fontSize: 14
                              )
                              ),
                            ), 

                        ]
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
                              onTap: (){  
                                setState(() {
                                  Navigator.of(context).pushReplacementNamed('/MeusAnimais');   
                                });       
                              },
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(25, 0, 25, 50),
                                    child: Material(
                                      elevation: 2.0,
                                      shadowColor: Colors.grey,
                                      color: Color(0xFFFA8072),
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                      child: OutlineButton(
                                        child: Text('Voltar', style: TextStyle(
                                          color: Colors.white
                                        ),
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
                              onTap: (){  
                                _validarCampos(); 
                                _tempoExibicaoMensagemErro(context);          
                              },
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(25, 0, 25, 50),
                                    child: Material(
                                      elevation: 2.0,
                                      shadowColor: Colors.grey,
                                      color: Color(0xFF1EC772),
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                      child: OutlineButton(
                                        child: Text('Salvar', style: TextStyle(
                                          color: Colors.white
                                        ),
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
                  ]
                )
              )
            ],
          ),          
        ),
      ),
    );
  }
  
}
