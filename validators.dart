class Validators {
  /// Valida se o nome do produto não está vazio e tem pelo menos 2 caracteres
  static String? validateNomeProduto(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o nome do produto';
    }
    if (value.trim().length < 2) {
      return 'O nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  /// Valida se a descrição não está vazia
  static String? validateDescricao(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira a descrição do produto';
    }
    return null;
  }

  /// Valida se o preço é um número válido e positivo
  static String? validatePreco(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o preço';
    }
    
    final preco = double.tryParse(value.trim());
    if (preco == null) {
      return 'Por favor, insira um preço válido';
    }
    
    if (preco < 0) {
      return 'O preço não pode ser negativo';
    }
    
    return null;
  }

  /// Valida se a quantidade é um número inteiro válido e não negativo
  static String? validateQuantidade(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira a quantidade';
    }
    
    final quantidade = int.tryParse(value.trim());
    if (quantidade == null) {
      return 'Por favor, insira uma quantidade válida';
    }
    
    if (quantidade < 0) {
      return 'A quantidade não pode ser negativa';
    }
    
    return null;
  }

  /// Valida se a unidade de medida não está vazia
  static String? validateUnidadeMedida(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira a unidade de medida';
    }
    return null;
  }

  /// Valida quantidade para movimentação de estoque
  static String? validateQuantidadeMovimentacao(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira a quantidade';
    }
    
    final quantidade = int.tryParse(value.trim());
    if (quantidade == null) {
      return 'Por favor, insira uma quantidade válida';
    }
    
    if (quantidade <= 0) {
      return 'A quantidade deve ser maior que zero';
    }
    
    return null;
  }
}

