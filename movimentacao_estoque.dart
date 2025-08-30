import 'package:cloud_firestore/cloud_firestore.dart';

class MovimentacaoEstoque {
  String? id;
  String produtoId;
  String tipo;
  int quantidade;
  Timestamp dataMovimentacao;
  String? observacoes;

  MovimentacaoEstoque({
    this.id,
    required this.produtoId,
    required this.tipo,
    required this.quantidade,
    required this.dataMovimentacao,
    this.observacoes,
  });

  // Converte um DocumentSnapshot do Firestore em um objeto MovimentacaoEstoque
  factory MovimentacaoEstoque.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MovimentacaoEstoque(
      id: doc.id,
      produtoId: data['produtoId'] ?? '',
      tipo: data['tipo'] ?? '',
      quantidade: (data['quantidade'] ?? 0).toInt(),
      dataMovimentacao: data['dataMovimentacao'] ?? Timestamp.now(),
      observacoes: data['observacoes'],
    );
  }

  // Converte um objeto MovimentacaoEstoque em um Map para ser salvo no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'produtoId': produtoId,
      'tipo': tipo,
      'quantidade': quantidade,
      'dataMovimentacao': dataMovimentacao,
      'observacoes': observacoes,
    };
  }

  @override
  String toString() {
    return 'MovimentacaoEstoque{id: $id, produtoId: $produtoId, tipo: $tipo, quantidade: $quantidade}';
  }
}

