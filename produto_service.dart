import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produto.dart';

class ProdutoService {
  final CollectionReference _produtosCollection = FirebaseFirestore.instance.collection('produtos');

  // Adicionar um novo produto
  Future<void> addProduto(Produto produto) async {
    try {
      await _produtosCollection.add(produto.toFirestore());
    } catch (e) {
      print('Erro ao adicionar produto: $e');
      rethrow;
    }
  }

  // Obter todos os produtos
  Stream<List<Produto>> getProdutos() {
    return _produtosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Produto.fromFirestore(doc)).toList();
    });
  }

  // Atualizar um produto existente
  Future<void> updateProduto(Produto produto) async {
    try {
      await _produtosCollection.doc(produto.id).update(produto.toFirestore());
    } catch (e) {
      print('Erro ao atualizar produto: $e');
      rethrow;
    }
  }

  // Excluir um produto
  Future<void> deleteProduto(String produtoId) async {
    try {
      await _produtosCollection.doc(produtoId).delete();
    } catch (e) {
      print('Erro ao excluir produto: $e');
      rethrow;
    }
  }

  // Atualizar a quantidade de um produto (entrada/saída de estoque)
  Future<void> updateQuantidadeProduto(String produtoId, int quantidadeAlteracao) async {
    final DocumentReference produtoRef = _produtosCollection.doc(produtoId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final DocumentSnapshot snapshot = await transaction.get(produtoRef);

      if (!snapshot.exists) {
        throw Exception("Produto não encontrado!");
      }

      int newQuantidade = (snapshot.get('quantidade') as int) + quantidadeAlteracao;
      if (newQuantidade < 0) {
        throw Exception("Quantidade em estoque insuficiente!");
      }

      transaction.update(produtoRef, {'quantidade': newQuantidade, 'ultimaAtualizacao': Timestamp.now()});
    }).catchError((e) {
      print('Erro na transação de atualização de quantidade: $e');
      rethrow;
    });
  }
}

