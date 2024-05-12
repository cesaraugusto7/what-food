import 'dart:convert';
import 'dart:io';

class FoodModel {
  final String? idFood;
  final String prato;
  final String descricao;
  final String? urlImagem;
  final File? arquivoImagem;
  final String? idImage;
  final List<String> ingredientes;
  final List<String> instrucoes;
  final List<String> dicas;
  final bool saved;

  FoodModel({
    required this.idFood,
    required this.prato,
    required this.descricao,
    required this.urlImagem,
    required this.arquivoImagem,
    required this.idImage,
    required this.ingredientes,
    required this.instrucoes,
    required this.dicas,
    required this.saved,
  });

  FoodModel copyWith({
    String? idFood,
    String? prato,
    String? descricao,
    String? urlImagem,
    File? arquivoImagem,
    String? idImage,
    List<String>? ingredientes,
    List<String>? instrucoes,
    List<String>? dicas,
    bool? saved,
  }) {
    return FoodModel(
        idFood: idFood ?? this.idFood,
        prato: prato ?? this.prato,
        descricao: descricao ?? this.descricao,
        urlImagem: urlImagem ?? this.urlImagem,
        arquivoImagem: arquivoImagem ?? this.arquivoImagem,
        idImage: idImage ?? this.idImage,
        ingredientes: ingredientes ?? this.ingredientes,
        instrucoes: instrucoes ?? this.instrucoes,
        dicas: dicas ?? this.dicas,
        saved: saved ?? this.saved);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prato': prato,
      'descricao': descricao,
      'id_imagem': idImage,
      'ingredientes': ingredientes,
      'instrucoes': instrucoes,
      'dicas': dicas,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    List<String> listaIgredientes = [];
    List<String> listaInstrucoes = [];
    List<String> listaDicas = [];
    for (dynamic item in (map['ingredientes'] as List<dynamic>)) {
      listaIgredientes.add(item.toString());
    }

    for (dynamic item in (map['instrucoes'] as List<dynamic>)) {
      listaInstrucoes.add(item.toString());
    }

    for (dynamic item in (map['dicas'] as List<dynamic>)) {
      listaDicas.add(item.toString());
    }

    return FoodModel(
      idFood: map['idFood'],
      prato: map['prato'] as String,
      descricao: map['descricao'] as String,
      urlImagem: map['urlImagem'] != null ? map['urlImagem'] as String : null,
      arquivoImagem: null,
      idImage: map['id_imagem'],
      ingredientes: listaIgredientes,
      instrucoes: listaInstrucoes,
      dicas: listaDicas,
      saved: map['saved'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
