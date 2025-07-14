*** Settings ***
Resource          ../Resources/usuario.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/api_session.resource

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

    ${body}=         Criar Body Carrinho    ${ID_PRODUTO}    1
    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response Post    /carrinhos    201    ${header}    ${body}

    Validar Resposta Completa Através da Mensagem    ${response}   201   Cadastro realizado com sucesso

    ${id}=   Set Variable    ${response.json()['_id']}

    Set Suite Variable    ${ID_CARRINHO}    ${id}  

    Create File    ${EXECDIR}/TempFiles/id_carrinho.txt    ${id}

Buscar Carrinho Por ID

    Cadastrar Carrinho Com Produto Válido

    ${response}=    Criar Response Get    /carrinhos/${ID_CARRINHO}    200    ${header}
    
    Validar Resposta Completa Através da Key    ${response}    200    _id

    Verifica se Usúario possui Carrinho e Deleta

Cancelar Compra Com Carrinho
    
    ${header}        Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    200   Registro excluído com sucesso. Estoque dos produtos reabastecido


Concluir Compra Com Carrinho
    Cadastrar Carrinho Com Produto Válido
    
    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/concluir-compra    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}   200   Registro excluído com sucesso


Cadastrar Carrinho Sem Produtos
    ${body}=         Set Variable    ${None}
    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response Post    /carrinhos    400    ${header}    ${body}
    
    Validar Resposta por Keys e Mensagens    
    ...    ${response}   
    ...    400
    ...    produtos=produtos é obrigatório

Buscar Carrinho Com ID Inexistente

    ${ID_CARRINHO}=   Generate Random String    16   [LETTERS][NUMBERS]
    ${response}=      Criar Response Get    /carrinhos/${ID_CARRINHO}    400    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    400    Carrinho não encontrado
    
Buscar Carrinho Com ID Malformado

    ${ID_CARRINHO}=   Generate Random String    18   [LETTERS][NUMBERS]
    ${response}=      Criar Response Get     /carrinhos/${ID_CARRINHO}    400    ${header}

    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    id=id deve ter exatamente 16 caracteres alfanuméricos

Concluir Compra Sem Carrinho
    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    200    Não foi encontrado carrinho para esse usuário

Cancelar Compra Sem Carrinho

    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    200    Não foi encontrado carrinho para esse usuário

    