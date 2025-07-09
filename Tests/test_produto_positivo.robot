*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource

Suite Setup       Criar Sessão e Cadastrar/Logar
Suite Teardown    Encerrar Sessão e Deletar Usuario


*** Test Cases ***

Cadastrar Produto Com Dados Válidos
    Cadastrar Produto

Buscar Produto Por ID Válido
    Buscar Produto por ID

Editar Produto Com Dados Válidos
    Editar Produto

Deletar Produto Existente
    Deletar Produto

Listar Produtos Existentes
    Listar Produtos
    