import 'package:flutter/material.dart';
import 'package:siscavet/pages/alterarConsulta.dart';

class Consulta extends StatelessWidget {
  var data;
  var clinica;
  var nomeAnimal;
  String idConsulta;

  Consulta(this.idConsulta, this.data, this.clinica, this.nomeAnimal);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AlterarConsultaPage(idConsulta)
                ));
          },
          child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Foto
                  Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF648365),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/Galeria.png',
                              height: 40,
                              width: 40,
                            )
                          ])),

                  //Dados
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Data
                        Row(
                          children: [
                            //Fixo
                            Text("Data: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Times New Roman',
                                  color: Color(0xFF50574a),
                                )),

                            //Variavel
                            Text(data.toString() ?? null,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Times New Roman',
                                  color: Color(0xFF50574a),
                                ))
                          ],
                        ),

                        //Clinica
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 6),
                            child: Row(
                              children: [
                                //Fixo
                                Text("Clínica: ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Times New Roman',
                                      color: Color(0xFF50574a),
                                    )),

                                //Variavel
                                Text(clinica.toString() ?? null,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Times New Roman',
                                      color: Color(0xFF50574a),
                                    ))
                              ],
                            )),

                        //Animal
                        Row(
                          children: [
                            //Fixo
                            Text("Animal: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Times New Roman',
                                  color: Color(0xFF50574a),
                                )),

                            //Variavel
                            Text(nomeAnimal.toString() ?? null,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Times New Roman',
                                  color: Color(0xFF50574a),
                                ))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))),

      //Divisoria
      Container(
        height: 1,
        width: MediaQuery.of(context).size.width,
        color: Colors.black12,
        margin: EdgeInsets.fromLTRB(5, 14, 5, 14),
      ),
    ]));
  }
}
