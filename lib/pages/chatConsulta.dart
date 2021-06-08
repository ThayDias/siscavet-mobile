import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'meusAnimais.dart';
import 'perfil.dart';
import 'mapaClinicas.dart';
import 'minhasConsultas.dart';


class ChatConsultaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Pagina
              Container(
                color: Color(0xFF1EC772),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [

                    //Barra Superior
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      //height: MediaQuery.of(context).size.height*0.225,
                      child: Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              //Perfil
                              Container(
                                margin: EdgeInsets.fromLTRB(12, 25, 0, 0),
                                child: SizedBox(
                                  width: 34,
                                  height: 31,
                                  child: GestureDetector(
                                    onTap:() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => PerfilPage()
                                      ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/Perfil.png'),
                                          fit: BoxFit.fitHeight  
                                        )
                                      )
                                    )
                                  ),
                                ),
                              ),

                              //Logo
                              Container(
                                child: SizedBox(
                                  width: 66,
                                  height: 72,
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/LogoMobileEscrito.png'),
                                    fit: BoxFit.fitHeight                                      
                                  ),
                                ),
                                height: 72,  
                              ),

                              //Animais
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 25, 12, 0),
                                child: SizedBox(
                                  width: 34,
                                  height: 31,
                                  child: GestureDetector(
                                    onTap:() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => MeusAnimaisPage()
                                      ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/Animal.png'),
                                          fit: BoxFit.fitHeight  
                                        )
                                      )
                                    )
                                  ),
                                ),
                              ),

                            ]
                          ),

                          //Barra de "navegação"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              //Chat
                              Container(
                                margin: EdgeInsets.fromLTRB(8, 23, 0, 0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  height: 81,
                                  child: GestureDetector(
                                    onTap:() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ChatConsultaPage()
                                      ));
                                    },
                                    child: Column(
                                      children: [
                                        
                                        //Icone
                                        Container(
                                          width: 45,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/Chat.png'),
                                              fit: BoxFit.fitHeight  
                                            )
                                          )
                                        ),

                                        //Escrito Chat
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text("Emergencial",
                                            style: TextStyle(
                                              fontSize: 11.77,
                                              fontFamily: 'Times New Roman',
                                              color: Color(0xFFFFFFFF),                                                                     
                                            ),
                                          ),
                                        )
                                      ]
                                    )
                                  ),
                                )
                              ),

                              //Consultas
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 23, 0, 0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  height: 81,
                                  child: GestureDetector(
                                    onTap:() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => MinhasConsultasPage()
                                      ));
                                    },
                                    child: Column(
                                      children: [
                                        
                                        //Icone
                                        Container(
                                          width: 45,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/Consulta.png'),
                                              fit: BoxFit.fitHeight  
                                            )
                                          )
                                        ),

                                        //Escrito Consultas
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text("Minhas Consultas",
                                            style: TextStyle(
                                              fontSize: 11.77,
                                              fontFamily: 'Times New Roman',
                                              color: Color(0xFFFFFFFF),                                                                     
                                            ),
                                          ),
                                        )
                                      ]
                                    )
                                  ),
                                )
                              ),

                              //Clinicas
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 23, 8, 0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  height: 81,
                                  child: GestureDetector(
                                    onTap:() {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => MapaClinicasPage()
                                      ));
                                    },
                                    child: Column(
                                      children: [
                                        
                                        //Icone
                                        Container(
                                          width: 45,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/Mapa.png'),
                                              fit: BoxFit.fitHeight  
                                            )
                                          )
                                        ),

                                        //Escrito Consultas
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text("Mapa de Clínicas",
                                            style: TextStyle(
                                              fontSize: 11.77,
                                              fontFamily: 'Times New Roman',
                                              color: Color(0xFFFFFFFF),                                                                      
                                            ),
                                          ),
                                        )
                                      ]
                                    )
                                  ),
                                )
                              ),

                            ],
                          )

                        ]
                      )

                      
                    ),


                  ]
                )
              )
            ]
          )
        )
      )


    );
  }
}