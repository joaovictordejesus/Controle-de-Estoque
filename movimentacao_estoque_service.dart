import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movimentacao_estoque.dart';

class MovimentacaoEstoqueService {
  final CollectionReference _movimentacoesCollection = FirebaseFirestore.instance.collection('movimentacoes');

  // Adicionar uma nova movimentação de estoque
  Future<void> addMovimentacao(MovimentacaoEstoque movimentacao) async {
    try {
      await _movimentacoesCollection.add(movimentacao.toFirestore());
    } catch (e) {
      print('Erro ao adicionar movimentação: $e');
      rethrow;
    }
  }

  // Obter todas as movimentações de um produto específico
  Stream<List<MovimentacaoEstoque>> getMovimentacoesPorProduto(String produtoId) {
    return _movimentacoesCollection
        .where('produtoId', isEqualTo: produtoId)
        .orderBy('dataMovimentacao', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MovimentacaoEstoque.fromFirestore(doc)).toList();
    });
  }

  // Obter o histórico completo de movimentações (opcional, pode ser filtrado por data, tipo, etc.)
  Stream<List<MovimentacaoEstoque>> getHistoricoMovimentacoes() {
    return _movimentacoesCollection
        .orderBy('dataMovimentacao', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MovimentacaoEstoque.fromFirestore(doc)).toList();
    });
  }
}

