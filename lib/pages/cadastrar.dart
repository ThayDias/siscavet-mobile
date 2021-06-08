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

class CadastrarPage extends StatefulWidget {
  @override
  _CadastrarPageState createState() {
    return _CadastrarPageState();
  }
}

class _CadastrarPageState extends State<CadastrarPage> {

  String _nome;
  String _email;
  String _senha;
  String _confirmarSenha;
  bool _validate = false;
  var _formKey = GlobalKey<FormState>();  
  File _image;
  final picker = ImagePicker();  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool validacao = false;  

  String errorTextEmail = '';
  String errorTextSenha = '';
  String errorTextNome = ''; 
  String errorTextConfirmacaoSenha = ''; 

  bool redUnderLineNome = false;   
  bool redUnderLineEmail = false;
  bool redUnderLineSenha = false;
  bool redUnderLineConfirmacaoSenha = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoSenhaController = TextEditingController();

  // Pegando uma imagem da galeria
  Future _getImage() async{
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

    //subindo a imagem para o banco
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

  //registrar no banco o formulário
  void _registrar(context) async {
    _formKey.currentState.save(); 
    var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _senha);
    var url = await _uploadPic(result.user.uid);

    await Firestore.instance.collection('Usuarios').document(result.user.uid).setData(
      {
        "nome": _nome,
        "email": _email,
        "senha": _senha,
        "telefone": null,
        "imagem": url,              
      }).then((value)
      {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:  Color(0xFF1EC772),
            content: new Text('Sucesso!'),
            duration: new Duration(seconds: 2),
          )
        );  

      new Timer(const Duration(seconds: 2), () {
      setState(() {
        Navigator.of(context).pushReplacementNamed('/MinhasConsultas');   
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

  //validar campos de cadastro
  void _validarCampos(context) async {

    //validar nome
    if(_nomeController.value.text.isEmpty){
      setState(() => redUnderLineNome = true);
      setState(() => errorTextNome = "Campo Obrigatório!");
      validacao = true;
    }else{
      setState(() => redUnderLineNome = false);
      setState(() => errorTextNome = "");      
    } 

    // validar Email
    if(_emailController.value.text.isEmpty){
      setState(() => redUnderLineEmail = true);                            
      setState(() => errorTextEmail = "Campo Obrigatório!");
      validacao = true;                                   
    }else {
      //se formatação do email é incorreta
      bool emailValido = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.value.text);
      if(!emailValido){                              
        setState(() => redUnderLineEmail = true);                            
        setState(() => errorTextEmail = "E-mail Inválido!");  
        validacao = true;
      }else{
        setState(() => redUnderLineEmail = false);                            
        setState(() => errorTextEmail = "");             
      }                                                    
    }

    //validar senha
    if(_senhaController.value.text.isEmpty){
      setState(() => redUnderLineSenha = true);
      setState(() => errorTextSenha = "Campo Obrigatório!");
      validacao = true;
    }else{
      // se senha menor que 6 caracteres
      if(_senhaController.value.text.length < 6){
        setState(() => redUnderLineSenha = true);
        setState(() => errorTextSenha = "Necessário 6 caracteres no mínimo!");
        validacao = true;
      }else{
        setState(() => redUnderLineSenha = false);
        setState(() => errorTextSenha = "");
      }              
    } 

    //validar confirmacao senha
    if(_confirmacaoSenhaController.value.text.isEmpty){
      setState(() => redUnderLineConfirmacaoSenha = true);
      setState(() => errorTextConfirmacaoSenha = "Campo Obrigatório!");
      validacao = true;
    }else{
      //se senha é diferente de confirmação senha
      if(_confirmacaoSenhaController.value.text != _senhaController.value.text){
        setState(() => redUnderLineConfirmacaoSenha = true);
        setState(() => errorTextConfirmacaoSenha = "Senhas Incompatíveis!");
        validacao = true;
      }else{
        setState(() => redUnderLineConfirmacaoSenha = false);
        setState(() => errorTextConfirmacaoSenha = "");
      }                
    }

    if(validacao == false)
    {
      _registrar(context);                          
    } 

    validacao = false;
  }

  //tempo que mensagem de erro é exibida na tela
  void _tempoExibicaoMensagemErro(context) async {
     new Timer(const Duration(seconds: 3), () {
      setState(() {
        errorTextNome = '';
        errorTextEmail = '';
        errorTextSenha = '';
        errorTextConfirmacaoSenha = '';

        redUnderLineNome = false;
        redUnderLineEmail = false;
        redUnderLineSenha = false;
        redUnderLineConfirmacaoSenha = false;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
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
                    
                    //titulo da tela
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 10, 25, 20),
                      child: Text('Cadastrar Novo Usuário', 
                      style: TextStyle(
                        color: Color(0xFF6F6D6D),                        
                        fontSize: 16
                      )
                      ),
                    ),

                    Form(
                      key: _formKey,
                      autovalidate: _validate,
                      child: Column(
                        children: 
                        <Widget>[

                            //imagem usuario 
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

                            //selecionar imagem usuario
                            GestureDetector(
                              onTap: _getImage,
                              child: Text('Selecione uma foto de perfil (Opcional)', 
                              style: TextStyle(
                                color: Color(0xFF648365),
                                decoration: TextDecoration.underline,
                                fontSize: 14
                              )
                              ),
                            ), 

                           //Nome de Usuario
                            Container(
                              margin: EdgeInsets.fromLTRB(25, 30, 25, 10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Material (
                                      elevation: 2.0,
                                      shadowColor: Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                      child: TextFormField(
                                        controller: _nomeController,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(100),
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: InputBorder.none,
                                          hintText:'Nome',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6F6D6D),
                                            height: 1.42
                                          ),
                                          labelText: 'Nome',
                                          labelStyle: TextStyle(
                                            fontSize: 14, 
                                            color: Color(0xFF969696),                              
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            borderSide: redUnderLineNome ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2),
                                          )
                                        ),
                                        onSaved: (value) => _nome = value,                                          
                                      )
                                    )   
                                  )
                                ]
                              )
                            ),
                            
                            //mensagem de erro
                            Text(errorTextNome, style: TextStyle(color: Colors.red)),
                          
                            //email
                            Container(
                              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                                child: Material (
                                  elevation: 2.0,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  child: TextFormField(
                                    controller: _emailController,
                                    onSaved: (value) => _email = value,                                                                        
                                    decoration: InputDecoration(                                      
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: InputBorder.none,
                                      hintText:'E-mail',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6F6D6D),
                                        height: 1.42
                                    ),
                                    labelText: 'E-mail',
                                    labelStyle: TextStyle(
                                      fontSize: 14, 
                                      color: Color(0xFF969696),                              
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: redUnderLineEmail ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2),
                                    )
                                  ), 
                                ),
                                )
                              ),//mensagem de erro
                              
                            //mensagem de erro
                            Text(errorTextEmail, style: TextStyle(color: Colors.red)),
                          
                            //Senha
                            Container(
                              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Material (
                                      elevation: 2.0,
                                      shadowColor: Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                      child: TextFormField(
                                        controller: _senhaController,
                                        obscureText: true,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(6),
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: InputBorder.none,
                                          hintText:'Senha',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6F6D6D),
                                            height: 1.42
                                          ),
                                          labelText: 'Senha',
                                          labelStyle: TextStyle(
                                            fontSize: 14, 
                                            color: Color(0xFF969696),                              
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            borderSide: redUnderLineSenha ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2),
                                          )
                                        ),
                                        onSaved: (value) => _senha = value,                                          
                                      )
                                    )
                                  )
                                ]
                              )
                            ),

                            //mensagem de erro
                            Text(errorTextSenha, style: TextStyle(color: Colors.red)),
                          
                            //Confirmar Senha
                            Container(
                              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                              child: Column(
                                children: [
                                  Container(
                                    child: Material (
                                      elevation: 2.0,
                                      shadowColor: Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                      child: TextFormField(
                                        controller: _confirmacaoSenhaController,
                                        obscureText: true,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(6),
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: InputBorder.none,
                                          hintText:'Confirmar Senha',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6F6D6D),
                                            height: 1.42
                                          ),
                                          labelText: 'Confirme sua Senha',
                                          labelStyle: TextStyle(
                                            fontSize: 14, 
                                            color: Color(0xFF969696),                              
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: redUnderLineConfirmacaoSenha ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2),
                                          )
                                        ),
                                        onSaved: (value) => _confirmarSenha = value,                                          
                                      )
                                    )
                                  )
                                ]
                              )
                            ),

                            //mensagem de erro
                            Text(errorTextConfirmacaoSenha, style: TextStyle(color: Colors.red)),
                          
                        ],
                      ),
                    ),
                    
                    // botao Salvar
                    GestureDetector(
                      onTap: (){  
                       // _registrar(context);
                        _validarCampos(context); 
                        _tempoExibicaoMensagemErro(context);          
                      },
                        child: Container(
                            margin: EdgeInsets.fromLTRB(25, 50, 25, 50),
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
                      ]),
                    ),
                  ]),
        )
      )
    );
  }
}