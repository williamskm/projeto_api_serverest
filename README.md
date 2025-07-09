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

## 🗂️ Estrutura do Projeto

```
qa-serverest-robot/
├── json/                    # Dados gerados para facilitar minha visualização.
│   ├── produto_cadastrado.json
│   ├── produtos_cadastrados.json
│   ├── usuario_cadastrado.json
│   └── usuarios_cadastrados.json

├── Resources/               # Keywords reutilizáveis organizadas por domínio
│   ├── api_session.resource
│   ├── carrinho.resource
│   ├── produtos.resource
│   └── usuario.resource

├── Tests/                   # Casos de teste organizados por funcionalidade
│   ├── test_produto_negativo.robot
│   ├── test_produto_positivo.robot
│   ├── test_usuario_negativo.robot
│   ├── test_usuario_positivo.robot
│   ├── teste_carrinho_negativo.robot
│   └── teste_carrinho_positivo.robot

├── tempfiles/               # Arquivos temporários gerados durante execução
│   ├── id_carrinho.txt
│   ├── id_produto.txt
│   ├── id_usuario.txt
│   └── token.txt

├── results/                 # Relatórios gerados automaticamente pelo Robot Framework
│   ├── log.html
│   ├── report.html
│   └── output.xml

├── Venv/                    # Ambiente virtual Python
├── requirements.txt         # Lista de dependências
└── README.md                # Documentação do projeto
```

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