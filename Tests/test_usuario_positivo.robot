*** Settings ***
Resource       ../Resources/api_session.resource
Resource       ../Resources/usuario.resource

Suite Setup    Configurar Header Padrão

*** Test Cases ***

Deve Cadastrar Usuário Com Dados Válidos, Validar Resposta e Guardar ID Usuário
    Cadastrar Usuário

Deve Logar Usuário Com Dados Válidos, Validar Resposta e Guardar Token de Autorização
    Logar Usuário

Deve Buscar Usuário Por ID Válido, Validar Resposta e Guardar Informações do Usuário
    Buscar Usuário

Deve Editar Usuário Com Dados Válidos e Validar Resposta
    Editar Usuário

Deve Deletar Usuário Existente e Validar Resposta
    Deletar Usuário Pelo ID em Arquivo

Deve Listar Usuários Existentes, Validar Resposta e Guardar Informações dos Usuários
    Listar Usuários
