import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:siscavet/widgets/consulta.dart';

class MinhasConsultasPage extends StatefulWidget {
  @override
  _MinhasConsultasPageState createState() {
    return _MinhasConsultasPageState();
  }
}

class _MinhasConsultasPageState extends State<MinhasConsultasPage> {
  // _carregarConsultas(userSnapshot) {
  //   var consulta = Firestore.instance
  //       .collection('Consultas')
  //       .where("idUsuario", isEqualTo: userSnapshot.data)
  //       .snapshots();

  //   return consulta;
  // }

  Future<String> _getUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  _getClinica(idClinica) async {
    var clinica = await Firestore.instance
        .collection('Clinicas')
        .document(idClinica)
        .get();

    var nomeClinica = clinica.data["nomeclinica"].toString();

    return nomeClinica;
  }

  _getAnimal(idAnimal) async {
    var animal =
        await Firestore.instance.collection('Animais').document(idAnimal).get();

    var nomeAnimal = animal.data["nomeAnimal"].toString();

    return nomeAnimal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1EC772),

        //adicionar Consulta
        floatingActionButton: Container(
          height: 75,
          width: 75,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed('/CadastrarConsulta');
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/AdicionarConsulta.png',
                      height: 31.02,
                      width: 35,
                    )
                  ]),
              backgroundColor: Color(0xFF1EC772),
            ),
          ),
        ),
        body: SafeArea(
            child: Container(
                color: Colors.white,
                //height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  //Barra Superior
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      color: Color(0xFF1EC772),
                      //height: MediaQuery.of(context).size.height*0.225,
                      child: Column(children: [
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
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed('/Perfil');
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/Perfil.png'),
                                                  fit: BoxFit.fitHeight)))),
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
                                      image: AssetImage(
                                          'assets/images/LogoMobileEscrito.png'),
                                      fit: BoxFit.fitHeight),
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
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                '/MeusAnimais');
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/Animal.png'),
                                                  fit: BoxFit.fitHeight)))),
                                ),
                              ),
                            ]),

                        //Barra de "navegação"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Chat
                            Container(
                                margin: EdgeInsets.fromLTRB(8, 23, 0, 0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 81,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                '/ChatConsulta');
                                      },
                                      child: Column(children: [
                                        //Icone
                                        Container(
                                            width: 45,
                                            height: 42,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/Chat.png'),
                                                    fit: BoxFit.fitHeight))),

                                        //Escrito Chat
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Emergencial",
                                            style: TextStyle(
                                              fontSize: 11.77,
                                              fontFamily: 'Times New Roman',
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        )
                                      ])),
                                )),

                            //Consultas
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 23, 0, 0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 81,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MinhasConsultasPage()));
                                      },
                                      child: Column(children: [
                                        //Icone
                                        Container(
                                            width: 45,
                                            height: 42,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/Consulta.png'),
                                                    fit: BoxFit.fitHeight))),

                                        //Escrito Consultas
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Minhas Consultas",
                                            style: TextStyle(
                                              fontSize: 11.77,
                                              fontFamily: 'Times New Roman',
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),

                                        //Seleção
                                        Container(
                                          height: 3,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.29,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 7, 0, 0),
                                          decoration: BoxDecoration(
                                              color: Colors.white70,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 4),
                                                    blurRadius: 4,
                                                    color: Color.fromARGB(
                                                        100, 0, 0, 0))
                                              ]),
                                        ),
                                      ])),
                                )),

                            //Clinicas
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 23, 8, 0),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height: 81,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                '/MapaClinicas');
                                      },
                                      child: Column(children: [
                                        //Icone
                                        Container(
                                            width: 45,
                                            height: 42,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/Mapa.png'),
                                                    fit: BoxFit.fitHeight))),

                                        //Escrito Consultas
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Mapa de Clínicas",
                                            style: TextStyle(
                                              fontSize: 11.77,
                                              fontFamily: 'Times New Roman',
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        )
                                      ])),
                                )),
                          ],
                        ),
                      ])),

                  //Lista
                  Container(
                    color: Color(0xFF1EC772),
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 4,
                              color: Color.fromARGB(255, 255, 255, 255))
                        ],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _getUser(),
                      builder: (_, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return Container(
                            child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator()),
                          );
                        } else {
                          return StreamBuilder(
                            stream: Firestore.instance
                                .collection('Consultas')
                                .where("idUsuario",
                                    isEqualTo: userSnapshot.data)
                                .orderBy("dataConsultaDateTime")
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Text("Carregando...");
                              //expanded
                              return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (_, indice) {
                                  String idConsulta = snapshot.data.documents[indice].documentID;

                                  String data = snapshot
                                      .data.documents[indice]['dataConsulta']
                                      .toString();

                                  var nomeClinica = snapshot
                                      .data.documents[indice]['clinicaNome'];


                                  var nomeAnimal = snapshot
                                      .data.documents[indice]['animalNome'];

                                  return Consulta(idConsulta,
                                      data, nomeClinica, nomeAnimal);
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  //Consulta1
                  // Consulta("30/03/2020", "PetShop", "Ragnar")
                ]))));
  }
}
