import 'package:flutter/material.dart';
import 'package:siscavet/pages/chatConsulta.dart';
import 'package:siscavet/pages/mapaClinicas.dart';
import 'package:siscavet/pages/meusAnimais.dart';
import 'package:siscavet/pages/cadastrarAnimal.dart';
import 'package:siscavet/pages/login.dart';
import 'package:siscavet/pages/alterarSenha.dart';
import 'package:siscavet/pages/cadastrar.dart';
import 'package:siscavet/pages/minhasConsultas.dart';
import 'package:siscavet/pages/alterarConsulta.dart';
import 'package:siscavet/pages/perfil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/cadastrarConsulta.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = {
      //'/' : (context) => MinhasConsultasPage(),
      '/Perfil': (context) => PerfilPage(),
      '/CadastrarAnimal': (context) => CadastrarAnimalPage(),
      '/CadastrarConsulta': (context) => CadastrarConsultaPage(),
      '/Cadastrar': (context) => CadastrarPage(),
      '/AlterarSenha': (context) => AlterarSenhaPage(),
      '/MeusAnimais': (context) => MeusAnimaisPage(),
      '/Login': (context) => LoginPage(),
      '/ChatConsulta': (context) => ChatConsultaPage(),
      '/MapaClinicas': (context) => MapaClinicasPage(),
      '/MinhasConsultas': (context) => MinhasConsultasPage(),
    };

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      title: 'Siscavet',
      theme: ThemeData(
          backgroundColor: Color(0xFFFFFFFF), fontFamily: 'Times New Roman'),
      home: LoginPage(),
      routes: routes,
    );
  }
}
