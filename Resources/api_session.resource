*** Settings ***
Resource     ../Resources/variaveis.resource
Resource     ../Resources/usuario.resource
Resource     ../Resources/produtos.resource

Library      RequestsLibrary
Library      String
Library      OperatingSystem
Library      Collections

*** Keywords ***

Configurar Header Padrão
    Criar Header

Cadastrar e Logar
    Criar Header
    Cadastrar Usuário
    Logar Usuário

Cadastrar, Logar e Cadastrar Produto
    Criar Header
    Cadastrar Usuário
    Logar Usuário
    Cadastrar Produto

Deletar Usuario
    Deletar Usuário Pelo ID em Arquivo

Deletar Usuario e Produto
    Deletar Produto
    Deletar Usuário Pelo ID em Arquivo

Criar Header
    [Arguments]    ${token}=None

    ${header}=    Create Dictionary    Content-Type=application/json

    Run Keyword If    '${token}' != 'None'
    ...    Set To Dictionary    ${header}    Authorization=${token}

    Set Suite Variable   ${header}

    RETURN    ${header}

Pega INFO em TempFiles
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

Criar Response POST
    [Arguments]    ${pagina}    ${expected_status}   ${header}    ${body}

    ${response}=    POST
    ...             url=${BASE_URL}${pagina}
    ...             headers=${header}
    ...             json=${body}
    ...             expected_status=${expected_status}
    
    RETURN    ${response}

Criar Response GET
    [Arguments]    ${pagina}    ${expected_status}   ${header}
    ${response}=    GET
    ...             url=${BASE_URL}${pagina}
    ...             headers=${header}
    ...             expected_status=${expected_status}
    
    RETURN    ${response}
    
Criar Response PUT
    [Arguments]    ${pagina}    ${expected_status}   ${header}    ${body}
    
    ${response}=    PUT
    ...             url=${BASE_URL}${pagina}
    ...             headers=${header}
    ...             json=${body}
    ...             expected_status=${expected_status}
    
    RETURN    ${response}

Criar Response DELETE
    [Arguments]    ${pagina}   ${expected_status}   ${header}

    ${response}=    DELETE
    ...             url=${BASE_URL}${pagina}
    ...             headers=${header}
    ...             expected_status=${expected_status}
    
    RETURN    ${response}

Validar Resposta Completa Através da Mensagem
    [Arguments]    ${response}    ${codigo_esperado}    ${mensagem_esperada}

    Should Be Equal As Integers    ${response.status_code}           ${codigo_esperado}
    Should Be Equal As Strings     ${response.json()['message']}    ${mensagem_esperada}

Validar Resposta Completa Através da Key
    [Arguments]    ${response}    ${codigo_esperado}    ${key_esperada}

    Should Be Equal As Integers    ${response.status_code}           ${codigo_esperado}
    Dictionary Should Contain Key     ${response.json()}    ${key_esperada}

Validar Resposta por Keys e Mensagens
    [Arguments]    ${response}    ${codigo_esperado}    &{mensagens_esperadas}
    #fazendo a verificaçãp
    Should Be Equal As Integers    ${response.status_code}    ${codigo_esperado}
    
    
    FOR    ${campo}    IN    @{mensagens_esperadas.keys()}
        ${esperada}=    Get From Dictionary    ${mensagens_esperadas}    ${campo}
        ${recebida}=    Get From Dictionary    ${response.json()}        ${campo}
        Should Be Equal As Strings    ${recebida}    ${esperada}
    END

Verifica se Usúario possui Carrinho e Deleta
    ${TOKEN}    Pega INFO em TempFiles    id_produto.txt
    ${header}=          Criar Header    ${TOKEN}
    ${response_get}=    Criar Response Get    /carrinhos    200    ${header}
    ${carrinho}=        Set Variable    ${response_get.json()}

    
    ${verifica_carrinho}=    Get From Dictionary    ${carrinho}    quantidade

    Run Keyword If    ${verifica_carrinho} > 0
    ...               Cancelar Compra Com Carrinho        