*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource

Suite Setup       Criar Sessão e Cadastrar/Logar
Suite Teardown    Encerrar Sessão e Deletar Usuario


*** Test Cases ***

Cadastro Sem Nome Deve Retornar Erro 400
    Cadastrar Produto Sem Nome

Cadastro Sem Preço Deve Retornar Erro 400
    Cadastrar Produto Sem Preço

Cadastro Sem Quantidade Deve Retornar Erro 400
    Cadastrar Produto Sem Quantidade

Buscar Produto Com ID Inexistente Deve Retornar Erro 400
    Buscar Produto Com ID Inexistente

Buscar Produto Com ID Malformado Deve Retornar Erro 400
    Buscar Produto Com ID Malformado

Editar Produto Sem Dados Deve Retornar Erro 400
    Editar Produto Sem Dados

Deletar Produto Inexistente Deve Retornar Erro 200
    Deletar Produto Inexistente
