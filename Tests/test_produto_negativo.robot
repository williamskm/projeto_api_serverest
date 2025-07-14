*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource

Suite Setup       Cadastrar e Logar
Suite Teardown    Deletar Usuario


*** Test Cases ***

Deve Retornar Erro 400 ao Cadastrar Produto Sem Nome e Validar Resposta
    Cadastrar Produto Sem Nome

Deve Retornar Erro 400 ao Cadastrar Produto Sem Preço e Validar Resposta
    Cadastrar Produto Sem Preço

Deve Retornar Erro 400 ao Cadastrar Produto Sem Quantidade e Validar Resposta
    Cadastrar Produto Sem Quantidade

Deve Retornar Erro 400 ao Buscar Produto Com ID Inexistente e Validar Resposta
    Buscar Produto Com ID Inexistente

Deve Retornar Erro 400 ao Buscar Produto Com ID Malformado e Validar Resposta
    Buscar Produto Com ID Malformado

Deve Retornar Erro 400 ao Editar Produto Sem Dados e Validar Resposta
    Editar Produto Sem Dados

Deve Retornar Erro 200 ao Deletar Produto Inexistente e Validar Resposta
    Deletar Produto Inexistente
