# Estrutura de Dados do Firebase para Controle de Estoque

## 1. Escolha do Banco de Dados: Firebase Realtime Database vs. Firestore

Para este projeto de controle de estoque, a escolha entre Firebase Realtime Database e Firestore é crucial e depende de diversos fatores, como o tipo de dados, a complexidade das consultas, a escalabilidade e o custo. Ambos são bancos de dados NoSQL oferecidos pelo Firebase, mas com arquiteturas e casos de uso ligeiramente diferentes.

### Firebase Realtime Database

O Firebase Realtime Database é um banco de dados NoSQL baseado em nuvem que armazena dados como um único grande JSON. Ele sincroniza os dados em tempo real com todos os clientes conectados, tornando-o ideal para aplicativos que exigem atualizações instantâneas e colaboração em tempo real. No entanto, sua estrutura de dados JSON pode se tornar complexa para consultas mais elaboradas e para a modelagem de dados relacionais.

**Vantagens:**
*   **Sincronização em Tempo Real:** Extremamente rápido para sincronizar dados entre clientes.
*   **Baixa Latência:** Ideal para aplicativos que exigem respostas rápidas.
*   **Simplicidade:** Fácil de configurar e usar para casos de uso simples.

**Desvantagens:**
*   **Consultas Complexas:** Dificuldade em realizar consultas complexas ou junções de dados.
*   **Escalabilidade:** Pode ser menos escalável para grandes volumes de dados e consultas complexas em comparação com o Firestore.
*   **Segurança:** As regras de segurança podem ser mais complexas de gerenciar para dados aninhados.

### Firestore

O Firestore é a próxima geração do Firebase Realtime Database, oferecendo uma estrutura de dados mais robusta baseada em coleções e documentos. Ele é otimizado para consultas complexas, escalabilidade e flexibilidade na modelagem de dados. O Firestore também oferece sincronização em tempo real, mas com um modelo de dados mais hierárquico e recursos de consulta mais avançados.

**Vantagens:**
*   **Consultas Poderosas:** Suporte a consultas complexas, incluindo filtragem, ordenação e paginação.
*   **Escalabilidade:** Projetado para escalar para milhões de usuários e terabytes de dados.
*   **Modelagem de Dados Flexível:** Estrutura de coleções e documentos facilita a organização de dados.
*   **Offline Support:** Suporte offline robusto para aplicativos móveis e web.

**Desvantagens:**
*   **Custo:** Pode ser mais caro para operações de leitura e escrita em grande escala em comparação com o Realtime Database.
*   **Curva de Aprendizagem:** Um pouco mais complexo de entender e configurar inicialmente.

### Decisão para o Projeto de Controle de Estoque

Considerando as funcionalidades necessárias para um aplicativo de controle de estoque (cadastro, atualização, exclusão, entrada/saída, consulta e histórico de movimentação), o **Firestore** é a escolha mais adequada. A capacidade de realizar consultas complexas, a escalabilidade para um número crescente de produtos e movimentações, e a flexibilidade na modelagem de dados são vantagens significativas que o Firestore oferece para este tipo de aplicação. Além disso, o suporte offline robusto do Firestore é benéfico para garantir a funcionalidade do aplicativo mesmo em condições de rede limitadas.

## 2. Estrutura de Dados Proposta no Firestore

A estrutura de dados no Firestore será organizada em coleções e documentos. Propomos as seguintes coleções principais:

### 2.1. Coleção `produtos`

Esta coleção armazenará informações detalhadas sobre cada produto no estoque. Cada documento nesta coleção representará um único produto.

| Campo         | Tipo    | Descrição                                                              | Exemplo                                   |
| :------------ | :------ | :--------------------------------------------------------------------- | :---------------------------------------- |
| `id`          | String  | ID único do produto (gerado automaticamente pelo Firestore)            | `"abc123xyz"`                             |
| `nome`        | String  | Nome do produto                                                        | `"Camiseta Branca"`                       |
| `descricao`   | String  | Descrição detalhada do produto                                         | `"Camiseta 100% algodão, tamanho M"`      |
| `preco`       | Number  | Preço unitário do produto                                              | `29.99`                                   |
| `quantidade`  | Number  | Quantidade atual em estoque                                            | `150`                                     |
| `unidadeMedida`| String  | Unidade de medida do produto (e.g., "unidade", "kg", "litro")        | `"unidade"`                               |
| `dataCadastro`| Timestamp | Data e hora do cadastro do produto                                     | `Timestamp(2025-08-30 10:00:00)`          |
| `ultimaAtualizacao`| Timestamp | Data e hora da última atualização do produto (nome, preço, etc.) | `Timestamp(2025-08-30 14:30:00)`          |

**Exemplo de Documento `produto`:**

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

### 2.2. Coleção `movimentacoes`

Esta coleção registrará todas as entradas e saídas de estoque para cada produto. Cada documento nesta coleção representará uma única movimentação.

| Campo         | Tipo    | Descrição                                                              | Exemplo                                   |
| :------------ | :------ | :--------------------------------------------------------------------- | :---------------------------------------- |
| `id`          | String  | ID único da movimentação (gerado automaticamente pelo Firestore)       | `"mov_001"`                               |
| `produtoId`   | String  | ID do produto ao qual a movimentação se refere (referência à coleção `produtos`) | `"produto_001"`                           |
| `tipo`        | String  | Tipo de movimentação ("entrada" ou "saida")                          | `"entrada"`                               |
| `quantidade`  | Number  | Quantidade de itens movimentados                                       | `50`                                      |
| `dataMovimentacao`| Timestamp | Data e hora da movimentação                                          | `Timestamp(2025-08-30 11:00:00)`          |
| `observacoes` | String  | Observações adicionais sobre a movimentação (opcional)                 | `"Recebimento de novo lote"`              |

**Exemplo de Documento `movimentacao`:**

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

### 2.3. Considerações Adicionais

*   **Índices:** Para otimizar o desempenho das consultas, será necessário criar índices no Firestore, especialmente para campos como `dataMovimentacao` e `produtoId` na coleção `movimentacoes`.
*   **Regras de Segurança:** As regras de segurança do Firestore serão configuradas para garantir que apenas usuários autenticados e autorizados possam ler e escrever dados nas coleções `produtos` e `movimentacoes`.
*   **Transações:** Para operações que envolvem a atualização da quantidade de estoque de um produto e o registro de uma movimentação (e.g., entrada/saída de estoque), serão utilizadas transações do Firestore para garantir a atomicidade e consistência dos dados.

Esta estrutura de dados fornece uma base sólida para o desenvolvimento do aplicativo de controle de estoque, permitindo o armazenamento e a recuperação eficientes das informações de produtos e suas movimentações. Agora, podemos prosseguir para a criação dos modelos de dados em Dart com base nesta estrutura.

