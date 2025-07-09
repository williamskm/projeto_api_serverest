*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource
Resource          ../Resources/carrinho.resource

Suite Setup       Criar Sessão e Cadastrar/Logar/CadastrarProduto
Suite Teardown    Encerrar Sessão e Deletar Usuario e Produto


*** Test Cases ***

Cadastrar Carrinho Com Produto Válido Deve Retornar Sucesso 201
    Cadastrar Carrinho Com Produto Válido
    Verifica se Usúario possui Carrinho e Deleta

Buscar Carrinho Com ID Válido Deve Retornar Sucesso 200
    Buscar Carrinho Por ID

Concluir Compra Com Carrinho Existente Deve Retornar Sucesso 200
    Concluir Compra Com Carrinho

Cancelar Compra Com Carrinho Existente Deve Retornar Sucesso 200
    Cadastrar Carrinho Com Produto Válido
    Cancelar Compra Com Carrinho