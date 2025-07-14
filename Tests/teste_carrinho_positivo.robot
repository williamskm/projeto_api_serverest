*** Settings ***
Resource          ../Resources/api_session.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource
Resource          ../Resources/carrinho.resource

Suite Setup       Cadastrar, Logar e Cadastrar Produto
Suite Teardown    Deletar Usuario e Produto


*** Test Cases ***

Deve Cadastrar Carrinho Com Produto Válido, Validar Resposta e Deletar Carrinho do Usuário
    Cadastrar Carrinho Com Produto Válido
    Verifica se Usúario possui Carrinho e Deleta

Deve Buscar Carrinho Por ID Válido e Validar Resposta
    Buscar Carrinho Por ID

Deve Concluir Compra Com Carrinho Existente e Validar Resposta
    Concluir Compra Com Carrinho

Deve Cancelar Compra Com Carrinho Existente e Validar Resposta
    Cadastrar Carrinho Com Produto Válido
    Cancelar Compra Com Carrinho
