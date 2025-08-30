# Controle de Estoque - Aplicativo Flutter

## Descrição do Projeto

O **Controle de Estoque** é um aplicativo móvel desenvolvido em Flutter que permite gerenciar produtos e suas movimentações de estoque de forma eficiente e intuitiva. O aplicativo utiliza o Firebase Firestore como banco de dados em nuvem, garantindo sincronização em tempo real e acesso aos dados de qualquer dispositivo.

## Funcionalidades Principais

### 📦 Gestão de Produtos
- **Cadastro de Produtos**: Adicione novos produtos com informações detalhadas (nome, descrição, preço, quantidade inicial, unidade de medida)
- **Atualização de Produtos**: Edite informações de produtos existentes
- **Exclusão de Produtos**: Remova produtos do sistema com confirmação de segurança
- **Consulta de Produtos**: Visualize lista completa de produtos com informações resumidas

### 📊 Controle de Estoque
- **Entrada de Estoque**: Registre entradas de produtos no estoque
- **Saída de Estoque**: Registre saídas de produtos do estoque
- **Validação de Quantidade**: Impede saídas que resultem em estoque negativo
- **Atualização Automática**: Quantidade em estoque é atualizada automaticamente após cada movimentação

### 📈 Histórico e Relatórios
- **Histórico de Movimentações**: Visualize todas as movimentações de estoque ordenadas por data
- **Histórico por Produto**: Consulte movimentações específicas de cada produto
- **Sincronização em Tempo Real**: Dados atualizados instantaneamente em todos os dispositivos

## Arquitetura do Projeto

### Estrutura de Pastas

```
lib/
├── main.dart                    # Ponto de entrada do aplicativo
├── models/                      # Modelos de dados
│   ├── produto.dart            # Modelo do Produto
│   └── movimentacao_estoque.dart # Modelo da Movimentação
├── services/                    # Serviços de integração com Firebase
│   ├── produto_service.dart    # Serviços CRUD de produtos
│   └── movimentacao_estoque_service.dart # Serviços de movimentação
├── screens/                     # Telas do aplicativo
│   ├── home_screen.dart        # Tela principal
│   ├── produtos_screen.dart    # Lista de produtos
│   ├── produto_form_screen.dart # Formulário de produto
│   ├── produto_detalhes_screen.dart # Detalhes do produto
│   └── historico_screen.dart   # Histórico de movimentações
└── utils/                       # Utilitários
    ├── validators.dart         # Validações de formulário
    └── error_handler.dart      # Tratamento de erros
```

### Padrões de Arquitetura

O projeto segue os seguintes padrões:

- **Separação de Responsabilidades**: Modelos, serviços, telas e utilitários em pastas separadas
- **Service Layer Pattern**: Camada de serviços para abstração do acesso aos dados
- **Repository Pattern**: Serviços atuam como repositórios para operações CRUD
- **Error Handling Centralizado**: Tratamento de erros padronizado em toda a aplicação

## Tecnologias Utilizadas

### Frontend
- **Flutter**: Framework de desenvolvimento multiplataforma
- **Dart**: Linguagem de programação
- **Material Design**: Sistema de design para interface consistente

### Backend
- **Firebase Firestore**: Banco de dados NoSQL em nuvem
- **Firebase Core**: Configuração base do Firebase

### Dependências Principais
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^4.0.0
  cloud_firestore: ^5.0.0
```

## Modelos de Dados

### Produto
```dart
class Produto {
  String? id;                    // ID único (gerado pelo Firestore)
  String nome;                   // Nome do produto
  String descricao;              // Descrição detalhada
  double preco;                  // Preço unitário
  int quantidade;                // Quantidade em estoque
  String unidadeMedida;          // Unidade de medida (ex: "unidade", "kg")
  Timestamp dataCadastro;        // Data de cadastro
  Timestamp ultimaAtualizacao;   // Data da última atualização
}
```

### MovimentacaoEstoque
```dart
class MovimentacaoEstoque {
  String? id;                    // ID único (gerado pelo Firestore)
  String produtoId;              // Referência ao produto
  String tipo;                   // "entrada" ou "saida"
  int quantidade;                // Quantidade movimentada
  Timestamp dataMovimentacao;    // Data e hora da movimentação
  String? observacoes;           // Observações opcionais
}
```

## Estrutura do Banco de Dados (Firestore)

### Coleção `produtos`
```json
{
  "id": "produto_001",
  "nome": "Camiseta Branca",
  "descricao": "Camiseta 100% algodão, tamanho M",
  "preco": 29.99,
  "quantidade": 150,
  "unidadeMedida": "unidade",
  "dataCadastro": "2025-08-30T10:00:00Z",
  "ultimaAtualizacao": "2025-08-30T14:30:00Z"
}
```

### Coleção `movimentacoes`
```json
{
  "id": "mov_001",
  "produtoId": "produto_001",
  "tipo": "entrada",
  "quantidade": 50,
  "dataMovimentacao": "2025-08-30T11:00:00Z",
  "observacoes": "Recebimento de novo lote"
}
```

## Validações Implementadas

### Validação de Produtos
- **Nome**: Obrigatório, mínimo 2 caracteres
- **Descrição**: Obrigatória
- **Preço**: Número válido, não negativo
- **Quantidade**: Número inteiro, não negativo
- **Unidade de Medida**: Obrigatória

### Validação de Movimentações
- **Quantidade**: Número inteiro positivo
- **Estoque Suficiente**: Impede saídas que resultem em estoque negativo

## Tratamento de Erros

### Tipos de Erro Tratados
- **Erros de Conexão**: Problemas de rede
- **Erros de Permissão**: Acesso negado ao Firebase
- **Erros de Validação**: Dados inválidos nos formulários
- **Erros de Negócio**: Estoque insuficiente, produto não encontrado

### Mensagens de Erro Amigáveis
O sistema converte erros técnicos em mensagens compreensíveis para o usuário:
- `permission-denied` → "Você não tem permissão para realizar esta operação"
- `network-request-failed` → "Erro de conexão. Verifique sua internet"
- `Quantidade em estoque insuficiente` → Mensagem específica do negócio

## Configuração do Firebase

### Configuração no main.dart
```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: "AIzaSyD3jR71dEWvb-f_at37EVFKAAKJi876rm0",
    authDomain: "controle-estoque-1b8c4.firebaseapp.com",
    databaseURL: "https://controle-estoque-1b8c4-default-rtdb.firebaseio.com",
    projectId: "controle-estoque-1b8c4",
    storageBucket: "controle-estoque-1b8c4.firebasestorage.app",
    messagingSenderId: "228138986569",
    appId: "1:228138986569:web:271675fcdb0140cf212398",
    measurementId: "G-K7DLBQ8DPN",
  ),
);
```

## Como Executar o Projeto

### Pré-requisitos
1. **Flutter SDK** instalado (versão 3.9.0 ou superior)
2. **Dart SDK** (incluído com Flutter)
3. **Android Studio** ou **VS Code** com extensões Flutter
4. **Dispositivo Android** ou **Emulador** configurado

### Passos para Execução

1. **Clone ou baixe o projeto**
2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```
3. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

### Geração do APK

Para gerar o APK de distribuição:

```bash
# APK de debug
flutter build apk

# APK de release (otimizado)
flutter build apk --release

# APK dividido por arquitetura (menor tamanho)
flutter build apk --split-per-abi
```

O APK será gerado em: `build/app/outputs/flutter-apk/`

## Funcionalidades das Telas

### Tela Principal (HomeScreen)
- Menu principal com acesso às funcionalidades
- Cards visuais para "Produtos" e "Histórico"
- Design responsivo e intuitivo

### Tela de Produtos (ProdutosScreen)
- Lista de todos os produtos cadastrados
- Informações resumidas: nome, quantidade, preço
- Botão flutuante para adicionar novo produto
- Navegação para detalhes ao tocar no produto

### Formulário de Produto (ProdutoFormScreen)
- Campos para todas as informações do produto
- Validação em tempo real
- Suporte para criação e edição
- Feedback visual de carregamento

### Detalhes do Produto (ProdutoDetalhesScreen)
- Informações completas do produto
- Botões para entrada e saída de estoque
- Histórico de movimentações do produto
- Opções para editar e excluir

### Histórico (HistoricoScreen)
- Lista completa de movimentações
- Ordenação por data (mais recente primeiro)
- Identificação visual de entradas e saídas
- Informações detalhadas de cada movimentação

## Segurança e Boas Práticas

### Transações Atômicas
- Operações de movimentação usam transações do Firestore
- Garante consistência entre atualização de estoque e registro de movimentação

### Validação Dupla
- Validação no frontend (UX) e backend (segurança)
- Prevenção de dados inconsistentes

### Tratamento de Estados
- Verificação de `mounted` antes de operações assíncronas
- Prevenção de vazamentos de memória

### Feedback ao Usuário
- Indicadores de carregamento
- Mensagens de sucesso e erro
- Confirmações para operações críticas

## Possíveis Melhorias Futuras

### Funcionalidades
- **Autenticação de Usuários**: Login e controle de acesso
- **Categorias de Produtos**: Organização por categorias
- **Código de Barras**: Leitura e geração de códigos
- **Relatórios Avançados**: Gráficos e estatísticas
- **Backup Local**: Cache offline para funcionamento sem internet
- **Notificações**: Alertas de estoque baixo

### Técnicas
- **Testes Unitários**: Cobertura de testes automatizados
- **CI/CD**: Pipeline de integração contínua
- **Monitoramento**: Analytics e crash reporting
- **Performance**: Otimizações de carregamento e memória

## Suporte e Manutenção

### Logs e Debug
- Logs detalhados para operações críticas
- Tratamento de exceções com contexto
- Debug mode para desenvolvimento

### Versionamento
- Controle de versão semântico
- Changelog documentado
- Migração de dados quando necessário

---

**Desenvolvido com Flutter e Firebase**  
**Versão**: 1.0.0  
**Data**: Agosto 2025

