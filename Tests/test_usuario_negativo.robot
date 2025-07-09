*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/usuario.resource

Suite Setup       Criar Sessão
Suite Teardown    Encerrar Sessão

*** Test Cases ***

Cadastro Com E-mail Já Existente Deve Retornar Erro 400
    Cadastro Com E-mail Já Existente

Cadastro Com Senha Vazia Deve Retornar Erro 400
    Cadastro Com Senha Vazia

Cadastro Com Nome Vazio Deve Retornar Erro 400
    Cadastro Com Nome Vazio

Cadastro Com E-mail Inválido Deve Retornar Erro 400
    Cadastro Com E-mail Inválido

Cadastro Sem Campo Obrigatório Email Deve Retornar Erro 400
    Cadastro Sem Campo Email

Logar Com Senha Incorreta Deve Retornar Erro 401
    Logar Com Senha Incorreta

Logar Com Campos Vazios Deve Retornar Erro 400
    Logar Com Campos Vazios

Logar Sem Corpo Deve Retornar Erro 400
    Logar Sem Body

Logar Com Tipo Incorreto Deve Retornar Erro 400
    Logar Com Tipo Incorreto

Buscar Usuário Com ID Inexistente Deve Retornar Erro 400
    Buscar Usuário Com ID Inexistente

Buscar Usuário Com ID Malformado Deve Retornar Erro 400
    Buscar Usuário Com ID Malformado

Editar Com E-mail Já Utilizado Deve Retornar Erro 400
    Editar Com Email Já Utilizado

Editar Sem Dados Deve Retornar Erro 400
    Editar Sem Dados

Editar Com Campos Inválidos Deve Retornar Erro 400
    Editar Com Campos Inválidos

Deletar Usuário Inexistente Deve Retornar Erro 200
    Deletar Usuário InexistentE
