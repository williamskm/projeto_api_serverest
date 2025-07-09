*** Settings ***
Resource    ../Resources/api_session.resource
Resource    ../Resources/usuario.resource

Suite Setup       Criar Sessão
Suite Teardown    Encerrar Sessão

*** Test Cases ***

Cadastrar Usuário Com Dados Válidos
    Cadastrar Usuário

Logar Usuário Com Dados Válido
    Logar Usuário

Buscar Usuário Por ID Válido
    Buscar Usuário

Editar Usuário Com Dados Válidos
    Editar Usuário

Deletar Usuário Existente
    Deletar Usuário

Listar Usuários Existentes
    Listar Usuários
