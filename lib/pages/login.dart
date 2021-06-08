import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siscavet/pages/cadastrar.dart';
import 'package:flutter/services.dart';
import 'alterarSenha.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}
 
class _LoginPageState extends State<LoginPage> {

  var _formKey = GlobalKey<FormState>();
  String _email;
  String _senha;
  bool validacaoEmail = false;
  bool validacaoSenha = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorTextEmail = '';
  String errorTextSenha = '';
  bool redUnderLineEmail = false;
  bool redUnderLineSenha = false;
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  
  void _validarCampos(context) async {
     new Timer(const Duration(seconds: 3), () {
      setState(() {
        errorTextEmail = '';
        errorTextSenha = '';
        redUnderLineEmail = false;
        redUnderLineSenha = false;
      });
    });
  }

  void _validarLogin(context) async {
    //if(_formKey.currentState.validate()){                          
        _formKey.currentState.save();  
      FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _senha).then((value){
        Navigator.of(context).pushReplacementNamed('/MinhasConsultas');
      }).catchError((e){
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:  Color(0xFFFA8072),
            content: new Text('Usuário ou Senha inválidos!'),
            duration: new Duration(seconds: 5),
          )
        );
      });   
    //} else{
      //validacao = true;
    //}
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
                height: MediaQuery.of(context).size.height*0.97,
                color: Color(0xFFFFFFFF),                
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
                      height: MediaQuery.of(context).size.height*0.3,  
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
                           //email
                            Container(
                              margin: EdgeInsets.fromLTRB(25, 25, 15, 10),
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
                              ),
                            
                            //mensagem de erro
                            
                            
                            Text(errorTextEmail, style: TextStyle(color: Colors.red)),

                            // senha
                            Container(
                              height: 50,
                              margin: EdgeInsets.fromLTRB(25, 25, 15, 10),
                              child: Material (
                                elevation: 2.0,
                                shadowColor: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                child: 
                                TextFormField(
                                  controller: _senhaController,
                                  onSaved: (value) => _senha = value,                                   
                                  obscureText: true,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(10.0),
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
                                      borderSide: redUnderLineSenha ? BorderSide(color: Colors.red) : BorderSide(color: Colors.transparent, width: 2)
                                  )
                                ), 
                              ),
                              )
                            ),

                            //mensagem de erro
                            Text(errorTextSenha, style: TextStyle(color: Colors.red)),

                        ]
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                         if(_emailController.value.text.isEmpty){
                            setState(() => redUnderLineEmail = true);                            
                            setState(() => errorTextEmail = "Campo Obrigatório!");
                            validacaoEmail = true;                                   
                          }else {
                            bool emailValido = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.value.text);
                            if(!emailValido){                              
                              setState(() => redUnderLineEmail = true);                            
                              setState(() => errorTextEmail = "E-mail Inválido!");  
                              validacaoEmail = true;
                            }else{
                              setState(() => redUnderLineEmail = false);                            
                              setState(() => errorTextEmail = "");  
                              validacaoEmail = false;
                            }                                                    
                          }
                          if(_senhaController.value.text.isEmpty){
                            setState(() => redUnderLineSenha = true);
                            setState(() => errorTextSenha = "Campo Obrigatório!");
                            validacaoSenha = true;
                          }else{
                            setState(() => redUnderLineSenha = false);
                            setState(() => errorTextSenha = "");
                            validacaoSenha = false;
                          } 

                          if(validacaoEmail == false && validacaoSenha == false){
                            _validarLogin(context);                             
                          } 
                          
                          _validarCampos(context);         

                      },
                      child: 
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 20, 25, 50),
                          child: Material(
                            elevation: 2.0,
                            shadowColor: Colors.grey,
                            color: Color(0xFF1EC772),
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            child: OutlineButton(
                              child: Text('Login', style: TextStyle(
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

                    //esqueci a senha       
                    GestureDetector(
                      onTap: (){                         
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AlterarSenhaPage()
                        )); 
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(25, 0, 25, 20),
                        child: Text('Esqueci minha senha', 
                        style: TextStyle(
                          color: Color(0xFF648365),
                          decoration: TextDecoration.underline,
                          fontSize: 16
                        )
                        ),
                      ),
                    ),
                    
                    //nao possui cadastro
                    GestureDetector(
                      onTap: (){                         
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => CadastrarPage()
                          )); 
                      },
                      child:
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 0, 25, 5),
                          child: Text('Não possui cadastro? Clique aqui', 
                          style: TextStyle(
                            color: Color(0xFF648365),
                            decoration: TextDecoration.underline,
                            fontSize: 16
                          )
                          ),
                        ),
                    )
                     
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