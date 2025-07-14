# Projeto de Automação de Testes - API Serverest com Robot Framework

## 📋 Descrição

Este projeto automatiza testes para a API RESTful da [Serverest](https://serverest.dev), simulando um ambiente de e-commerce.  
Utiliza Robot Framework com RequestsLibrary para validar funcionalidades essenciais como autenticação, cadastro de usuários, gerenciamento de produtos, carrinho e pedidos.

---

## 🚀 Tecnologias e Ferramentas Utilizadas

- Robot Framework  
- RequestsLibrary  
- Python  
- VS Code  
- Git e GitHub  
---

## ⚙️ Configuração do Ambiente

1. **Clone o repositório:**
```bash
git clone https://github.com/seunome/qa-serverest-robot.git
```

2. **Crie e ative um ambiente virtual (recomendado):**
```bash
python -m venv venv
source venv/bin/activate       # Linux/macOS
venv\Scripts\activate          # Windows
```

3. **Instale as dependências:**
```bash
pip install -r requirements.txt
```

---

## ▶️ Como Executar os Testes

**Executar todos os testes da suíte:**
```bash
robot Tests/
```

**Executar com saída personalizada para a pasta `results/`:**
```bash
robot -d results Tests/
```

---

## 🧪 Funcionalidades Automatizadas

- ✅ Cadastro e login de usuários (administrador)  
- ✅ Criação, edição, listagem e exclusão de produtos  
- ✅ Gerenciamento do carrinho de compras  
- ✅ Finalização e consulta de pedidos  
- ⚠️ Testes negativos cobrindo:
- Dados obrigatórios ausentes
- Tipos inválidos (ex: número em vez de e-mail)

---

## 📊 Relatórios

Após a execução, o Robot Framework gera relatórios automáticos na pasta `results/`:

- `log.html`: detalhes passo a passo da execução  
- `report.html`: resumo geral das execuções  
- `output.xml`: base de dados para integrações ou reprocessamento  

---

## 📬 Contato

Desenvolvido por William Cosme  
🔗 [LinkedIn](https://www.linkedin.com/in/williamz-cosme/)  
🐙 [GitHub](https://github.com/williamskm)

---

## 📄 Licença

Este projeto está licenciado sob a licença MIT.  
Sinta-se à vontade para usar, modificar e distribuir.

---

## 🔄 Alterações Recentes

### v1.2 – Documentação e Tags em Testes Automatizados – 14/07/2025

Adição de `[Documentation]` e `[Tags]` em todos os testes automatizados, com foco em clareza, categorização e melhoria da rastreabilidade.

- Descrição detalhada de cada test case com propósito claro.
- Classificação por tags: `positivo`, `negativo`, `usuario`, `produto`, `carrinho`.

---

### v1.1 – Refatoração Geral de Testes (Usuário, Produto e Carrinho)

Criação do arquivo `variaveis.resource` para centralização de dados utilizados em múltiplos testes.

Padronização do uso de Post, Get, Put, Delete com alias de sessão reutilizável.

Separação e reorganização de testes positivos e negativos para facilitar leitura e manutenção.

Refatoração completa dos nomes de testes para padrão uniforme:
- Deve [Ação], Validar Resposta e [Complemento Opcional]

Criação de keywords auxiliares para validação de resposta e deleção de entidades.

Substituição de valores fixos por dados aleatórios com `Generate Random String`.

Refatoração dos testes de Produto com foco em clareza, reaproveitamento de lógica e validação consistente.

Padronização dos testes de Carrinho, com destaque para cobertura de cenários de compra, cancelamento e erros esperados.

Correção na keyword `Criar Header` para garantir retorno correto com `RETURN`, evitando sobrescrita com `None`.