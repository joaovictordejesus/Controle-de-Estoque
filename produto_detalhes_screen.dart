import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produto.dart';
import '../models/movimentacao_estoque.dart';
import '../services/produto_service.dart';
import '../services/movimentacao_estoque_service.dart';
import '../utils/validators.dart';
import '../utils/error_handler.dart';
import 'produto_form_screen.dart';

class ProdutoDetalhesScreen extends StatefulWidget {
  final Produto produto;

  const ProdutoDetalhesScreen({super.key, required this.produto});

  @override
  State<ProdutoDetalhesScreen> createState() => _ProdutoDetalhesScreenState();
}

class _ProdutoDetalhesScreenState extends State<ProdutoDetalhesScreen> {
  final ProdutoService _produtoService = ProdutoService();
  final MovimentacaoEstoqueService _movimentacaoService = MovimentacaoEstoqueService();
  final _quantidadeController = TextEditingController();

  Future<void> _movimentarEstoque(String tipo) async {
    final validationError = Validators.validateQuantidadeMovimentacao(_quantidadeController.text);
    if (validationError != null) {
      ErrorHandler.showErrorSnackBar(context, Exception(validationError));
      return;
    }

    final quantidade = int.parse(_quantidadeController.text);

    try {
      final quantidadeAlteracao = tipo == 'entrada' ? quantidade : -quantidade;
      
      // Atualizar a quantidade do produto
      await _produtoService.updateQuantidadeProduto(widget.produto.id!, quantidadeAlteracao);
      
      // Registrar a movimentação
      final movimentacao = MovimentacaoEstoque(
        produtoId: widget.produto.id!,
        tipo: tipo,
        quantidade: quantidade,
        dataMovimentacao: Timestamp.now(),
      );
      
      await _movimentacaoService.addMovimentacao(movimentacao);

      if (mounted) {
        _quantidadeController.clear();
        Navigator.pop(context);
        ErrorHandler.showSuccessSnackBar(
          context,
          '${tipo == 'entrada' ? 'Entrada' : 'Saída'} registrada com sucesso!',
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, e);
      }
    }
  }

  void _showMovimentacaoDialog(String tipo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${tipo == 'entrada' ? 'Entrada' : 'Saída'} de Estoque'),
        content: TextField(
          controller: _quantidadeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantidade',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _movimentarEstoque(tipo),
            style: ElevatedButton.styleFrom(
              backgroundColor: tipo == 'entrada' ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Future<void> _excluirProduto() async {
    final confirmacao = await ErrorHandler.showConfirmationDialog(
      context,
      title: 'Confirmar Exclusão',
      content: 'Tem certeza que deseja excluir este produto?',
      confirmText: 'Excluir',
    );

    if (confirmacao) {
      try {
        await _produtoService.deleteProduto(widget.produto.id!);
        if (mounted) {
          Navigator.pop(context);
          ErrorHandler.showSuccessSnackBar(context, 'Produto excluído com sucesso!');
        }
      } catch (e) {
        if (mounted) {
          ErrorHandler.showErrorSnackBar(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto.nome),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdutoFormScreen(produto: widget.produto),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _excluirProduto,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.produto.nome,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.produto.descricao,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Preço: R\$ ${widget.produto.preco.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Estoque: ${widget.produto.quantidade} ${widget.produto.unidadeMedida}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showMovimentacaoDialog('entrada'),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Entrada', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showMovimentacaoDialog('saida'),
                    icon: const Icon(Icons.remove, color: Colors.white),
                    label: const Text('Saída', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Histórico de Movimentações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<MovimentacaoEstoque>>(
                stream: _movimentacaoService.getMovimentacoesPorProduto(widget.produto.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final movimentacoes = snapshot.data ?? [];

                  if (movimentacoes.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma movimentação registrada'),
                    );
                  }

                  return ListView.builder(
                    itemCount: movimentacoes.length,
                    itemBuilder: (context, index) {
                      final movimentacao = movimentacoes[index];
                      final isEntrada = movimentacao.tipo == 'entrada';
                      
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            isEntrada ? Icons.add_circle : Icons.remove_circle,
                            color: isEntrada ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            '${isEntrada ? 'Entrada' : 'Saída'}: ${movimentacao.quantidade} ${widget.produto.unidadeMedida}',
                          ),
                          subtitle: Text(
                            movimentacao.dataMovimentacao.toDate().toString().substring(0, 16),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quantidadeController.dispose();
    super.dispose();
  }
}

