import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlterarSenhaPage extends StatefulWidget {
  @override
  _AlterarSenhaPageState createState() {
    return _AlterarSenhaPageState();
  }
}
 
class _AlterarSenhaPageState extends State<AlterarSenhaPage> {

  var _formKey = GlobalKey<FormState>();
  String _email;
  bool validacaoEmail = false;
  bool validacaoSenha = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorTextEmail = '';  
  bool redUnderLineEmail = false;
  bool redUnderLineSenha = false;
  final _emailController = TextEditingController();
  
  void _validarCampos(context) async {
    new Timer(const Duration(seconds: 3), () {
      setState(() {
        errorTextEmail = '';        
        redUnderLineEmail = false;   
      });
    });
  }

  void _validarAlterarSenha(context) async {                            
        _formKey.currentState.save();  
      FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((value){
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:  Color(0xFF1EC772),
            content: new Text('E-mail de Recuperação de Senha Enviado!'),
            duration: new Duration(seconds: 5),
          )
        );  

    new Timer(const Duration(seconds: 3), () {
      setState(() {
        Navigator.of(context).pushReplacementNamed('/Login');   
        });
      });
      }).catchError((e){
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor:  Color(0xFFFA8072),
            content: new Text('Usuário Não Encontrado!'),
            duration: new Duration(seconds: 5),
          )
        );
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
                           
                           Container(
                          margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                          child: Text('Alterar Senha', 
                          style: TextStyle(
                            color: Color(0xFF6F6D6D),
                            //decoration: TextDecoration.underline,
                            fontSize: 16
                          )
                          ),
                        ),
                           
                           //email
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 25, 15, 10),
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

                          if(validacaoEmail == false && validacaoSenha == false){
                            _validarAlterarSenha(context); 
                            setState(() => redUnderLineEmail = false);                            
                            setState(() => errorTextEmail = "");                            
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
                              child: Text('Enviar', style: TextStyle(
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