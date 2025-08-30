import 'package:cloud_firestore/cloud_firestore.dart';

class Produto {
  String? id;
  String nome;
  String descricao;
  double preco;
  int quantidade;
  String unidadeMedida;
  Timestamp dataCadastro;
  Timestamp ultimaAtualizacao;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.quantidade,
    required this.unidadeMedida,
    required this.dataCadastro,
    required this.ultimaAtualizacao,
  });

  // Converte um DocumentSnapshot do Firestore em um objeto Produto
  factory Produto.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Produto(
      id: doc.id,
      nome: data['nome'] ?? '',
      descricao: data['descricao'] ?? '',
      preco: (data['preco'] ?? 0.0).toDouble(),
      quantidade: (data['quantidade'] ?? 0).toInt(),
      unidadeMedida: data['unidadeMedida'] ?? '',
      dataCadastro: data['dataCadastro'] ?? Timestamp.now(),
      ultimaAtualizacao: data['ultimaAtualizacao'] ?? Timestamp.now(),
    );
  }

  // Converte um objeto Produto em um Map para ser salvo no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'quantidade': quantidade,
      'unidadeMedida': unidadeMedida,
      'dataCadastro': dataCadastro,
      'ultimaAtualizacao': ultimaAtualizacao,
    };
  }

  @override
  String toString() {
    return 'Produto{id: $id, nome: $nome, preco: $preco, quantidade: $quantidade}';
  }
}

