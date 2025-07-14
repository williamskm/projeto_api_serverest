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
    [Documentation]     Realiza o cadastro de um carrinho com produto válido, verifica se o cadastro foi realizado 
    ...                 com sucesso e guarda o ID para uso em testes subsequentes.
    [Tags]              carrinho    positivo

    ${body}=         Criar Body Carrinho    ${ID_PRODUTO}    1
    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response Post    /carrinhos    201    ${header}    ${body}

    Validar Resposta Completa Através da Mensagem    ${response}   201   Cadastro realizado com sucesso

    ${id}=   Set Variable    ${response.json()['_id']}

    Set Suite Variable    ${ID_CARRINHO}    ${id}  

    Create File    ${EXECDIR}/TempFiles/id_carrinho.txt    ${id}

Buscar Carrinho Por ID
    [Documentation]    Cadastra carrinho com produto válido, Realiza a busca com ID válido, verifica se a busca foi 
    ...                realizada com sucesso e deleta o carrinho.
    [Tags]             carrinho    positivo

    Cadastrar Carrinho Com Produto Válido

    ${response}=    Criar Response Get    /carrinhos/${ID_CARRINHO}    200    ${header}
    
    Validar Resposta Completa Através da Key    ${response}    200    _id

    Verifica se Usúario possui Carrinho e Deleta

Cancelar Compra Com Carrinho
    [Documentation]    Cancela uma compra ativa e valida a mensagem de sucesso no retorno.
    [Tags]             carrinho    positivo
    
    ${header}        Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    200   Registro excluído com sucesso. Estoque dos produtos reabastecido


Concluir Compra Com Carrinho
    [Documentation]    Cadastra um carrinho e conclui a compra, validando a mensagem de sucesso.
    [Tags]             carrinho    positivo

    Cadastrar Carrinho Com Produto Válido
    
    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/concluir-compra    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}   200   Registro excluído com sucesso


Cadastrar Carrinho Sem Produtos
    [Documentation]    Tenta cadastrar carrinho sem produto, valida erro 400 e mensagem
    [Tags]             carrinho    negativo

    ${body}=         Set Variable    ${None}
    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response Post    /carrinhos    400    ${header}    ${body}
    
    Validar Resposta por Keys e Mensagens    
    ...    ${response}   
    ...    400
    ...    produtos=produtos é obrigatório

Buscar Carrinho Com ID Inexistente
    [Documentation]    Busca carrinho com ID inexistente, valida erro 400 e mensagem
    [Tags]             carrinho    negativo

    ${ID_CARRINHO}=   Generate Random String    16   [LETTERS][NUMBERS]
    ${response}=      Criar Response Get    /carrinhos/${ID_CARRINHO}    400    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    400    Carrinho não encontrado
    
Buscar Carrinho Com ID Malformado
    [Documentation]    Busca produto com ID malformado, valida erro 400 e mensagem
    [Tags]             carrinho    negativo

    ${ID_CARRINHO}=   Generate Random String    18   [LETTERS][NUMBERS]
    ${response}=      Criar Response Get     /carrinhos/${ID_CARRINHO}    400    ${header}

    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    id=id deve ter exatamente 16 caracteres alfanuméricos

Concluir Compra Sem Carrinho
    [Documentation]    Tenta concluir compra sem carrinho cadastrado. valida erro 200 e mensagem
    [Tags]             carrinho    negativo

    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    200    Não foi encontrado carrinho para esse usuário

Cancelar Compra Sem Carrinho
    [Documentation]    Tenta cancelar compra sem carrinho cadastrado. valida erro 200 e mensagem
    [Tags]             carrinho    negativo

    ${header}=       Criar Header    ${TOKEN}
    ${response}=     Criar Response DELETE    /carrinhos/cancelar-compra    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    200    Não foi encontrado carrinho para esse usuário

    