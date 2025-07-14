# 📜 Changelog

## v1.2 – Documentação e Tags em Testes Automatizados – 14/07/2025

Adição de `[Documentation]` e `[Tags]` em todos os testes automatizados, com foco em clareza, categorização e melhoria da rastreabilidade.

- Descrição detalhada de cada test case com propósito claro.
- Classificação por tags: `positivo`, `negativo`, `usuario`, `produto`, `carrinho`.

---

## v1.1 – Refatoração Geral de Testes (Usuário, Produto e Carrinho) – 14/07/2025

Criação do arquivo variaveis.resource para centralização de dados utilizados em múltiplos testes.

Padronização do uso de Post, Get, Put, Delete com alias de sessão reutilizável.

Separação e reorganização de testes positivos e negativos para facilitar leitura e manutenção.

Refatoração completa dos nomes de testes para padrão uniforme:
- Deve [Ação], Validar Resposta e [Complemento Opcional]

Criação de keywords auxiliares para validação de resposta e deleção de entidades.

Substituição de valores fixos por dados aleatórios com Generate Random String.

Refatoração dos testes de Produto com foco em clareza, reaproveitamento de lógica e validação consistente.

Padronização dos testes de Carrinho, com destaque para cobertura de cenários de compra, cancelamento e erros esperados.

Correção na keyword 'Criar Header' para garantir retorno correto com RETURN, evitando sobrescrita com None
