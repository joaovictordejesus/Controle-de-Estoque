import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';
import '../utils/validators.dart';
import '../utils/error_handler.dart';

class ProdutoFormScreen extends StatefulWidget {
  final Produto? produto;

  const ProdutoFormScreen({super.key, this.produto});

  @override
  State<ProdutoFormScreen> createState() => _ProdutoFormScreenState();
}

class _ProdutoFormScreenState extends State<ProdutoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _unidadeMedidaController = TextEditingController();

  final ProdutoService _produtoService = ProdutoService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      _nomeController.text = widget.produto!.nome;
      _descricaoController.text = widget.produto!.descricao;
      _precoController.text = widget.produto!.preco.toString();
      _quantidadeController.text = widget.produto!.quantidade.toString();
      _unidadeMedidaController.text = widget.produto!.unidadeMedida;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    _unidadeMedidaController.dispose();
    super.dispose();
  }

  Future<void> _salvarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final produto = Produto(
        id: widget.produto?.id,
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        preco: double.parse(_precoController.text),
        quantidade: int.parse(_quantidadeController.text),
        unidadeMedida: _unidadeMedidaController.text,
        dataCadastro: widget.produto?.dataCadastro ?? Timestamp.now(),
        ultimaAtualizacao: Timestamp.now(),
      );

      if (widget.produto == null) {
        await _produtoService.addProduto(produto);
      } else {
        await _produtoService.updateProduto(produto);
      }

      if (mounted) {
        Navigator.pop(context);
        ErrorHandler.showSuccessSnackBar(
          context,
          widget.produto == null ? 'Produto cadastrado com sucesso!' : 'Produto atualizado com sucesso!',
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto == null ? 'Novo Produto' : 'Editar Produto'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateNomeProduto,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: Validators.validateDescricao,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _precoController,
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                        border: OutlineInputBorder(),
                        prefixText: 'R\$ ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.validatePreco,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _quantidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.validateQuantidade,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unidadeMedidaController,
                decoration: const InputDecoration(
                  labelText: 'Unidade de Medida',
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateUnidadeMedida,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvarProduto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.produto == null ? 'Cadastrar Produto' : 'Atualizar Produto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

