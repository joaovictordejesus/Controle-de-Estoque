import 'package:flutter/material.dart';
import '../models/movimentacao_estoque.dart';
import '../services/movimentacao_estoque_service.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  final MovimentacaoEstoqueService _movimentacaoService = MovimentacaoEstoqueService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Movimentações'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<MovimentacaoEstoque>>(
        stream: _movimentacaoService.getHistoricoMovimentacoes(),
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
              child: Text(
                'Nenhuma movimentação registrada',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: movimentacoes.length,
            itemBuilder: (context, index) {
              final movimentacao = movimentacoes[index];
              final isEntrada = movimentacao.tipo == 'entrada';
              
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isEntrada ? Colors.green : Colors.red,
                    child: Icon(
                      isEntrada ? Icons.add : Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    '${isEntrada ? 'Entrada' : 'Saída'}: ${movimentacao.quantidade} unidades',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Produto ID: ${movimentacao.produtoId}'),
                      Text(
                        'Data: ${movimentacao.dataMovimentacao.toDate().toString().substring(0, 16)}',
                      ),
                      if (movimentacao.observacoes != null && movimentacao.observacoes!.isNotEmpty)
                        Text('Obs: ${movimentacao.observacoes}'),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isEntrada ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isEntrada ? 'ENTRADA' : 'SAÍDA',
                      style: TextStyle(
                        color: isEntrada ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

