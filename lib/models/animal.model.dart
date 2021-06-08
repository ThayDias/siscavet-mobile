import 'dart:html';

class AnimalModel
{
  String idAnimal;
  String nomeAnimal;
  String especie;
  String raca;
  String idade;
  String descricao;
  File imagem;
  File carteirinhaVacinacao;
  String sexo;

  AnimalModel(this.idAnimal,this.nomeAnimal, this.especie, this.raca, this.idade, this.descricao, this.sexo);

  AnimalModel.fromJson(Map<String, dynamic> json) {
    this.idAnimal = json["documentID"];
    this.nomeAnimal = json['nomeAnimal'];
    this.especie = json['especie'];
    this.raca = json['raca'];
    this.idade = json['idade'];
    this.descricao = json['descricao'];
    this.sexo = json['sexo'];  
  }
}