*** Settings ***
Resource          ../Resources/usuario.resource
Resource          ../Resources/produtos.resource

Library           RequestsLibrary
Library           String
Library           OperatingSystem
Library           Collections
Library           json


*** Keywords ***

Criar Body Carrinho
    [Arguments]    ${ID_PRODUTO}=    ${quantidade}=

    ${item}=    Create Dictionary
        ...     idProduto=${ID_PRODUTO}
        ...     quantidade=${quantidade}
    
    ${produtos_lista}=    Create List    ${item}


    ${body}=    Create Dictionary
        ...     produtos=${produtos_lista}
   
    RETURN    ${body}

Cadastrar Carrinho Com Produto Válido

    ${body}=    Criar Body Carrinho    ${ID_PRODUTO}    1
    ${header}=    Criar Header    ${TOKEN}
    ${response}=     Criar Response Post    /carrinhos    201    ${header}    ${body}

    ${id}=   Set Variable    ${response.json()['_id']}

    Set Suite Variable    ${ID_CARRINHO}    ${id}  

    Create File    ${EXECDIR}/TempFiles/id_carrinho.txt    ${id}

    Dictionary Should Contain Value    ${response.json()}    Cadastro realizado com sucesso

Buscar Carrinho Por ID
    Cadastrar Carrinho Com Produto Válido

    ${header}=    Criar Header
    ${response}=    Criar Response Get    /carrinhos/${ID_CARRINHO}    200    ${header}

    Dictionary Should Contain Key    ${response.json()}    produtos

    Verifica se Usúario possui Carrinho e Deleta

Cancelar Compra Com Carrinho
    
    ${header}    Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['message']}    Registro excluído com sucesso. Estoque dos produtos reabastecido


Concluir Compra Com Carrinho
    Cadastrar Carrinho Com Produto Válido
    
    ${header}=    Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/concluir-compra    200    ${header}

    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['message']}    Registro excluído com sucesso

Cadastrar Carrinho Sem Produtos
    ${body}=    Set Variable    ${None}
    ${header}=    Criar Header    ${TOKEN}
    ${response}=     Criar Response Post    /carrinhos    400    ${header}    ${body}
    
    Log    ${response.json()}

    Dictionary Should Contain Value    ${response.json()}    produtos é obrigatório


Buscar Carrinho Com ID Inexistente
    ${ID_CARRINHO}=    Set Variable    BeeJh5lz3k6kSXXX
    ${header}=      Criar Header
    ${response}=    Criar Response Get    /carrinhos/${ID_CARRINHO}    400    ${header}

    log    ${response.json()}
    
    Should Be Equal As Strings    ${response.json()['message']}    Carrinho não encontrado
Buscar Carrinho Com ID Malformado
    ${ID_CARRINHO}=    Set Variable    BeeJh5lz3k6kSIzBxx
    ${header}=      Criar Header
    ${response}=    Criar Response Get     /carrinhos/${ID_CARRINHO}    400    ${header}

    log    ${response.json()}
    
    Should Be Equal As Strings    ${response.json()['id']}    id deve ter exatamente 16 caracteres alfanuméricos

Concluir Compra Sem Carrinho
    ${header}    Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['message']}    Não foi encontrado carrinho para esse usuário

Cancelar Compra Sem Carrinho

    ${header}    Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['message']}    Não foi encontrado carrinho para esse usuário

    
