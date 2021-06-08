import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siscavet/pages/alterarSenha.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'login.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() {
    return _PerfilPageState();
  }
}

class _PerfilPageState extends State<PerfilPage> {
  FirebaseUser usuarioCarregado;

  String errorTextNome = '';
  String errorTextEmail = '';
  bool redUnderLineNome = false;
  bool redUnderLineEmail = false;
  bool validacao = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _nome;
  String _email;
  String _telefone;
  String _netImage;
  var _formKey = GlobalKey<FormState>();

  File _image;
  var picker = ImagePicker();

  bool editarNome = false;
  bool editarEmail = false;
  bool editarTelefone = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  // Pegando uma imagem da galeria
  Future _getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    File file = File(image.path);

    if (file == null) return;

    Directory docDir = await getApplicationDocumentsDirectory();
    String path = docDir.path;

    File localImage = await file.copy('$path/image1.png');

    setState(() {
      _image = localImage;
      print('Image Path $_image');
    });
  }

  //subindo a imagem para o banco
  Future<String> _uploadPic(String uid) async {
    if (_image != null) {
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(uid);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      var urlImagem = await firebaseStorageRef.getDownloadURL();
      return urlImagem;
    } else {
      return null;
    }
  }

  //carregar dados do usuario
  Future _carregarUsuario() {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() async {
        this.usuarioCarregado = user;

        DocumentSnapshot usuario = await Firestore.instance
            .collection('Usuarios')
            .document(usuarioCarregado.uid)
            .get();
        _nomeController.text = usuario.data['nome'];
        _emailController.text = usuario.data['email'];
        _telefoneController.text = usuario.data['telefone'];
        // usuario.data['imagem']
        //     .getDownloadURL()
        // .then((loc) => setState(() => _netImage = loc));

       // return _netImage;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  //registrar no banco o formulário
  void _salvarDadosAlterados(context) async {
    //_formKey.currentState.save();

    var url = await _uploadPic(usuarioCarregado.uid);

    //usuarioCarregado.updateEmail(_email);

    await Firestore.instance
        .collection('Usuarios')
        .document(usuarioCarregado.uid)
        .updateData({
      "nome": _nomeController.value.text,
      "email": _emailController.value.text,
      "telefone": _telefoneController.value.text,
      "imagem": url,
    }).then((value) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Color(0xFF1EC772),
        content: new Text('Sucesso!'),
        duration: new Duration(seconds: 2),
      ));

      // new Timer(const Duration(seconds: 2), () {
      //   setState(() {
      //     Navigator.of(context).pushReplacementNamed('/Perfil');
      //   });
      // });
    }).catchError((onError) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Color(0xFFFA8072),
        content: new Text('Erro!'),
        duration: new Duration(seconds: 5),
      ));
    });
  }

  //validar campos de cadastro
  void _validarCampos(context) async {
    //validar nome
    if (_nomeController.value.text.isEmpty) {
      setState(() => redUnderLineNome = true);
      setState(() => errorTextNome = "Campo Obrigatório!");
      validacao = true;
    } else {
      setState(() => redUnderLineNome = false);
      setState(() => errorTextNome = "");
    }

    // // validar Email
    // if (_emailController.value.text.isEmpty) {
    //   setState(() => redUnderLineEmail = true);
    //   setState(() => errorTextEmail = "Campo Obrigatório!");
    //   validacao = true;
    // } else {
    //   //se formatação do email é incorreta
    //   bool emailValido = RegExp(
    //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //       .hasMatch(_emailController.value.text);
    //   if (!emailValido) {
    //     setState(() => redUnderLineEmail = true);
    //     setState(() => errorTextEmail = "E-mail Inválido!");
    //     validacao = true;
    //   } else {
    //     setState(() => redUnderLineEmail = false);
    //     setState(() => errorTextEmail = "");
    //   }
    // }

    if (validacao == false) {
      _salvarDadosAlterados(context);
    }

    validacao = false;
  }

  //tempo que mensagem de erro é exibida na tela
  void _tempoExibicaoMensagemErro(context) async {
    new Timer(const Duration(seconds: 3), () {
      setState(() {
        errorTextNome = '';
        errorTextEmail = '';

        redUnderLineNome = false;
        redUnderLineEmail = false;
      });
    });
  }

  void _signOut(context) async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      //Navigator.of(context).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
      Navigator.of(context).pushReplacementNamed('/Login');
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

                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //imagem usuario
                          FutureBuilder(
                              future: _carregarUsuario(),
                              builder: (_, snapshot) {
                                return GestureDetector(
                                    onTap: _getImage,
                                    child: _image == null &&
                                            snapshot.data == null
                                        ? Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                                IconData(0xe853,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                size: 100,
                                                color: Color(0xFF648365)))
                                        : _image == null
                                            ? Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        //NetworkImage(_image)
                                                        image: NetworkImage(
                                                            snapshot.data),
                                                        fit: BoxFit.cover)),
                                              )
                                            : Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image:
                                                            FileImage(_image),
                                                        fit: BoxFit.cover)),
                                              ));
                              }),

                          //selecionar imagem usuario
                          GestureDetector(
                            onTap: _getImage,
                            child: Text(
                                'Selecione uma foto de perfil (Opcional)',
                                style: TextStyle(
                                    color: Color(0xFF648365),
                                    decoration: TextDecoration.underline,
                                    fontSize: 14)),
                          ),

                          //Nome de Usuario
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(25, 25, 15, 0),
                                child: SizedBox(
                                    width: 250,
                                    child: Material(
                                        elevation:
                                            editarNome == false ? 0 : 2.0,
                                        shadowColor: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        child: TextFormField(
                                          enabled: editarNome == false
                                              ? false
                                              : true,
                                          //onSaved: (value) => _nome = value,
                                          controller: _nomeController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              border: InputBorder.none,
                                              hintText: 'Nome',
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF6F6D6D),
                                                  height: 1.42),
                                              labelText: 'Nome',
                                              labelStyle: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF969696),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 2),
                                              )),                                          
                                        ))),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 25, 5, 0),
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.black,
                                  iconSize: 24.0,
                                  onPressed: () {
                                    setState(() {
                                      editarNome = !editarNome;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),

                          // //Email
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          //     Container(
                          //       margin: EdgeInsets.fromLTRB(25, 25, 15, 0),
                          //       child: SizedBox(
                          //           width: 250,
                          //           child: Material(
                          //               elevation:
                          //                   editarEmail == false ? 0 : 2.0,
                          //               shadowColor: Colors.grey,
                          //               borderRadius: BorderRadius.all(
                          //                   Radius.circular(30.0)),
                          //               child: TextFormField(
                          //                 enabled: editarEmail == false
                          //                     ? false
                          //                     : true,
                          //                 controller: _emailController,
                          //                 decoration: InputDecoration(
                          //                     contentPadding:
                          //                         EdgeInsets.all(10.0),
                          //                     border: InputBorder.none,
                          //                     hintText: 'E-mail',
                          //                     hintStyle: TextStyle(
                          //                         fontSize: 14,
                          //                         color: Color(0xFF6F6D6D),
                          //                         height: 1.42),
                          //                     labelText: 'E-mail',
                          //                     labelStyle: TextStyle(
                          //                       fontSize: 14,
                          //                       color: Color(0xFF969696),
                          //                     ),
                          //                     enabledBorder: OutlineInputBorder(
                          //                       borderRadius: BorderRadius.all(
                          //                           Radius.circular(30.0)),
                          //                       borderSide: BorderSide(
                          //                           color: Colors.transparent,
                          //                           width: 2),
                          //                     )),
                          //                 onSaved: (value) => _email = value,
                          //                 onChanged: (value){
                          //                     _email = value;
                          //                 },
                          //               ))),
                          //     ),
                          //     Container(
                          //       margin: EdgeInsets.fromLTRB(0, 25, 5, 0),
                          //       child: IconButton(
                          //         icon: Icon(Icons.edit),
                          //         color: Colors.black,
                          //         iconSize: 24.0,
                          //         onPressed: () {
                          //           setState(() {
                          //             editarEmail = !editarEmail;
                          //           });
                          //         },
                          //       ),
                          //     )
                          //   ],
                          // ),

                          //Telefone
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(25, 25, 15, 0),
                                child: SizedBox(
                                    width: 250,
                                    child: Material(
                                        elevation:
                                            editarTelefone == false ? 0 : 2.0,
                                        shadowColor: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        child: TextFormField(
                                          enabled: editarTelefone == false
                                              ? false
                                              : true,
                                          controller: _telefoneController,
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                                mask: "(##)#########")
                                          ],
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              border: InputBorder.none,
                                              hintText: 'Telefone',
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF6F6D6D),
                                                  height: 1.42),
                                              labelText: 'Telefone',
                                              labelStyle: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF969696),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 2),
                                              )),
                                          //onSaved: (value) => _telefone = value,
                                        ))),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 25, 5, 0),
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.black,
                                  iconSize: 24.0,
                                  onPressed: () {
                                    setState(() {
                                      editarTelefone = !editarTelefone;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(25, 50, 25, 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                                margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
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

                    // Sair
                    GestureDetector(
                      onTap: () {
                        _signOut(context);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: Text('Encerrar Sessão',
                            style: TextStyle(
                                color: Color(0xFF648365),
                                decoration: TextDecoration.underline,
                                fontSize: 16)),
                      ),
                    ),

                    // alterar senha
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AlterarSenhaPage()));
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(25, 20, 25, 20),
                        child: Text('Alterar Senha',
                            style: TextStyle(
                                color: Color(0xFF648365),
                                decoration: TextDecoration.underline,
                                fontSize: 16)),
                      ),
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
