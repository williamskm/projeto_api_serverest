*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/usuario.resource

Suite Setup       Configurar Header Padrão


*** Test Cases ***
Deve Retornar Erro 400 ao Cadastrar Usuário Com E-mail Já Existente e Validar Resposta
    Cadastro Com E-mail Já Existente

Deve Retornar Erro 400 ao Cadastrar Usuário Com Senha Vazia e Validar Resposta
    Cadastro Com Senha Vazia

Deve Retornar Erro 400 ao Cadastrar Usuário Com Nome Vazio e Validar Resposta
    Cadastro Com Nome Vazio

Deve Retornar Erro 400 ao Cadastrar Usuário Com E-mail Inválido e Validar Resposta
    Cadastro Com E-mail Inválido

Deve Retornar Erro 400 ao Cadastrar Usuário Sem Campo Obrigatório E-mail e Validar Resposta
    Cadastro Sem Campo Email

Deve Retornar Erro 401 ao Logar Usuário Com Senha Incorreta e Validar Resposta
    Logar Com Senha Incorreta

Deve Retornar Erro 400 ao Logar Usuário Com Campos Vazios e Validar Resposta
    Logar Com Campos Vazios

Deve Retornar Erro 400 ao Logar Usuário Sem Corpo e Validar Resposta
    Logar Sem Body

Deve Retornar Erro 400 ao Logar Usuário Com Tipo Incorreto e Validar Resposta
    Logar Com Tipo Incorreto

Deve Retornar Erro 400 ao Buscar Usuário Com ID Inexistente e Validar Resposta
    Buscar Usuário Com ID Inexistente

Deve Retornar Erro 400 ao Buscar Usuário Com ID Malformado e Validar Resposta
    Buscar Usuário Com ID Malformado

Deve Retornar Erro 400 ao Editar Usuário Com E-mail Já Utilizado e Validar Resposta
    Editar Com Email Já Utilizado

Deve Retornar Erro 400 ao Editar Usuário Sem Dados e Validar Resposta
    Editar Sem Dados

Deve Retornar Erro 400 ao Editar Usuário Com Campos Inválidos e Validar Resposta
    Editar Com Campos Inválidos

Deve Retornar Erro 200 ao Deletar Usuário Inexistente e Validar Resposta
    Deletar Usuário Inexistente

