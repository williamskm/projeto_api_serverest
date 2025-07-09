*** Settings ***
Resource          ../Resources/produtos.resource
Resource          ../Resources/usuario.resource

Library    RequestsLibrary
Library    String
Library    OperatingSystem
Library    Collections

*** Variables ***
${nome}     WilliamTeste
${email}    william@teste.com.br
${senha}    teste123456
${admin}    true


*** Keywords ***

Criar Sessão
    Create Session    alias=ServeRest    url=https://serverest.dev

Encerrar Sessão
    Delete All Sessions

Criar Sessão e Cadastrar/Logar
    Criar Sessão
    Cadastrar Usuário
    Logar Usuário

Encerrar Sessão e Deletar Usuario
    Deletar Usuário
    Encerrar Sessão

Encerrar Sessão e Deletar Usuario e Produto
    Deletar Produto
    Deletar Usuário
    Encerrar Sessão

Criar Sessão e Cadastrar/Logar/CadastrarProduto
    Criar Sessão
    Cadastrar Usuário
    Logar Usuário
    Cadastrar Produto

Limpar Pasta TempFiles
    Remove Directory    ${EXECDIR}/tempfiles    recursive=True
    Create Directory    ${EXECDIR}/tempfiles

Verifica se Usúario possui Carrinho e Deleta
    ${TOKEN}    Buscar Info em Temp Files    token.txt

    ${header}=          Criar Header    ${TOKEN}
    ${response_get}=    Criar Response Get    /carrinhos    200    ${header}
    ${carrinho}=        Set Variable    ${response_get.json()}

    
    ${verifica_carrinho}=    Get From Dictionary    ${carrinho}    quantidade

    Run Keyword If    ${verifica_carrinho} > 0
    ...               Cancelar Compra Com Carrinho

Buscar Info em Temp Files
    [Arguments]    ${nome_do_arquivo}

    ${valor}    Get File    path=${EXECDIR}/TempFiles/${nome_do_arquivo}

    RETURN    ${valor}

Criar Body
    [Arguments]    ${nome}=    ${email}=    ${password}=    ${administrador}=

    ${body}=    Create Dictionary
        ...     nome=${nome}
        ...     email=${email}
        ...     password=${password}
        ...     administrador=${administrador}
    RETURN    ${body}

Criar Header
    [Arguments]    ${token}=
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=${token}

    RETURN    ${header}

Criar Response Post
    [Arguments]    ${pagina}    ${expected_status}   ${header}    ${body}

    ${response}=    POST On Session
    ...             alias=ServeRest
    ...             url=${pagina}
    ...             headers=${header}
    ...             json=${body}
    ...             expected_status=${expected_status}
    
    RETURN    ${response}

Criar Response Get
    [Arguments]    ${pagina}    ${expected_status}   ${header}
    ${response}=    GET On Session
    ...             alias=ServeRest
    ...             url=${pagina}
    ...             headers=${header}
    ...             expected_status=${expected_status}
    
    RETURN    ${response}
    
Criar Response Put
    [Arguments]    ${pagina}    ${expected_status}   ${header}    ${body}
    
    ${response}=    PUT On Session
    ...             alias=ServeRest
    ...             url=${pagina}
    ...             headers=${header}
    ...             json=${body}
    ...             expected_status=${expected_status}
    
    RETURN    ${response}

Criar Response DELETE
    [Arguments]    ${pagina}   ${expected_status}   ${header}

    ${response}=    DELETE On Session
    ...             alias=ServeRest
    ...             url=${pagina}
    ...             headers=${header}
    ...             expected_status=${expected_status}
    
    RETURN    ${response}
