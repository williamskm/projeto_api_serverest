*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource

Suite Setup       Cadastrar, Logar e Cadastrar Produto
Suite Teardown    Deletar Usuario e Produto


*** Test Cases ***

Deve Retornar Erro 400 ao Cadastrar Carrinho Sem Produtos e Validar Resposta
    Cadastrar Carrinho Sem Produtos

Deve Retornar Erro 400 ao Buscar Carrinho Com ID Inexistente e Validar Resposta
    Buscar Carrinho Com ID Inexistente

Deve Retornar Erro 400 ao Buscar Carrinho Com ID Malformado e Validar Resposta
    Buscar Carrinho Com ID Malformado

Deve Retornar Erro 400 ao Concluir Compra Sem Carrinho e Validar Resposta
    Concluir Compra Sem Carrinho

Deve Retornar Erro 400 ao Cancelar Compra Sem Carrinho e Validar Resposta
    Cancelar Compra Sem Carrinho

