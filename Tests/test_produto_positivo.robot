*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource

Suite Setup       Cadastrar e Logar
Suite Teardown    Deletar Usuario


*** Test Cases ***

Deve Cadastrar Produto Com Dados Válidos, Validar Resposta e Guardar ID Produto
    Cadastrar Produto

Deve Buscar Produto Por ID Válido, Validar Resposta e Guardar Informações do Produto
    Buscar Produto por ID

Deve Editar Produto Com Dados Válidos e Validar Resposta
    Editar Produto

Deve Deletar Produto Existente e Validar Resposta
    Deletar Produto

Deve Listar Produtos Existentes, Validar Resposta e Guardar Informações dos Produtos
    Listar Produtos
    