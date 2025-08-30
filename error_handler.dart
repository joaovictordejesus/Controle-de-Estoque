import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ErrorHandler {
  /// Trata erros do Firebase e retorna uma mensagem amigável ao usuário
  static String getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Você não tem permissão para realizar esta operação';
        case 'unavailable':
          return 'Serviço temporariamente indisponível. Tente novamente mais tarde';
        case 'network-request-failed':
          return 'Erro de conexão. Verifique sua internet e tente novamente';
        case 'timeout':
          return 'Operação expirou. Tente novamente';
        default:
          return 'Erro no Firebase: ${error.message ?? 'Erro desconhecido'}';
      }
    }
    
    if (error.toString().contains('Quantidade em estoque insuficiente')) {
      return 'Quantidade em estoque insuficiente para esta operação';
    }
    
    if (error.toString().contains('Produto não encontrado')) {
      return 'Produto não encontrado';
    }
    
    return 'Erro inesperado: ${error.toString()}';
  }

  /// Exibe um SnackBar com mensagem de erro
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final message = getFirebaseErrorMessage(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Exibe um SnackBar com mensagem de sucesso
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Exibe um dialog de confirmação
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(confirmText, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
}

