*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource

Suite Setup       Criar Sessão e Cadastrar/Logar/CadastrarProduto
Suite Teardown    Encerrar Sessão e Deletar Usuario e Produto


*** Test Cases ***

Cadastrar Carrinho Sem Produtos Deve Retornar Erro 400
    Cadastrar Carrinho Sem Produtos

Buscar Carrinho Com ID Inexistente Deve Retornar Erro 400
    Buscar Carrinho Com ID Inexistente

Buscar Carrinho Com ID Malformado Deve Retornar Erro 400
    Buscar Carrinho Com ID Malformado

Concluir Compra Sem Carrinho Deve Retornar Erro 400
    Concluir Compra Sem Carrinho

Cancelar Compra Sem Carrinho Deve Retornar Erro 400
    Cancelar Compra Sem Carrinho
