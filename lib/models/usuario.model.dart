import 'dart:html';

class UsuarioModel
{
  String nome;
  String email;
  String senha;
  String telefone;  
  File imagem;
  
  UsuarioModel(this.nome, this.email, this.senha, this.imagem);

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    this.nome = json['nome'];
    this.email = json['email'];
    this.senha = json['senha'];
    this.telefone = json['telefone'];
    this.imagem = json['imagem'];
    
  }
}