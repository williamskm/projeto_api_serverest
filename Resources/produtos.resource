*** Settings ***
Resource          ../Resources/usuario.resource
Resource          ../Resources/produtos.resource
Resource          ../Resources/variaveis.resource

Library           RequestsLibrary
Library           String
Library           OperatingSystem
Library           Collections
Library           json


*** Keywords ***

Criar Body Produto
    [Arguments]    ${nome}=    ${preco}=    ${descricao}=    ${quantidade}=

    ${body}=    Create Dictionary
        ...     nome=${nome}
        ...     preco=${preco}
        ...     descricao=${descricao}
        ...     quantidade=${quantidade}
   
    RETURN    ${body}

Cadastrar Produto
    ${body}=      Criar Body Produto     ${nome_produto}    ${preco}    ${descricao}    ${quantidade}
    ${header}=    Criar Header           ${TOKEN}
    ${response}=  Criar Response Post    /produtos    201    ${header}    ${body}

    Validar Resposta Completa Através da Mensagem    ${response}    201    Cadastro realizado com sucesso

    ${id}    Set Variable        ${response.json()['_id']}

    Create File    ${EXECDIR}/TempFiles/id_produto.txt    ${id}

    Set Suite Variable    ${ID_PRODUTO}    ${id}
    

Buscar Produto por ID
    ${ID_PRODUTO}=    Pega INFO em TempFiles    id_produto.txt
    ${response}=      Criar Response Get    /produtos/${ID_PRODUTO}    200    ${header}

    Validar Resposta Completa Através da Key    ${response}    200    _id

    ${json}         Evaluate    json.dumps(${response.json()}, indent=4)    json
    Create File     ${EXECDIR}/Json/produto_cadastrado.json    ${json}


Editar Produto
    ${ID_PRODUTO}=    Pega INFO em TempFiles    id_produto.txt
    
    ${body}=          Criar Body Produto    Logitech PRO MAX    1200    Mouse Gamer    110
    ${header}=        Criar Header    ${TOKEN}
    ${response}=      Criar Response Put    /produtos/${ID_PRODUTO}   200    ${header}    ${body}

    Validar Resposta Completa Através da Mensagem    ${response}    200    Registro alterado com sucesso

Deletar Produto
    ${ID_PRODUTO}=    Pega INFO em TempFiles   id_produto.txt
    
    ${header}=        Criar Header    ${TOKEN}
    ${response}=      Criar Response DELETE    /produtos/${ID_PRODUTO}    200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}   200    Registro excluído com sucesso

Listar Produtos   
    ${header}=       Criar Header
    ${response}=     Criar Response Get    /produtos    200   ${header}

    Validar Resposta Completa Através da Key    ${response}    200    quantidade

    ${json}         Evaluate    json.dumps(${response.json()}, indent=4)    json
    Create File     ${EXECDIR}/Json/produtos_cadastrados.json    ${json}

Cadastrar Produto Sem Nome
    ${body}=        Criar Body Produto    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    ${header}=      Criar Header    ${TOKEN}
    ${response}=    Criar Response Post    /produtos    400    ${header}    ${body}

    Validar Resposta por Keys e Mensagens
    ...    ${response}    
    ...    400
    ...    nome=nome não pode ficar em branco


Cadastrar Produto Sem Preço
    ${body}=        Criar Body Produto    nome=${nome}    descricao=${descricao}    quantidade=${quantidade}
    ${header}=      Criar Header    ${TOKEN}
    ${response}=    Criar Response Post    /produtos    400    ${header}    ${body}

    Validar Resposta por Keys e Mensagens
    ...    ${response}    
    ...    400
    ...    preco=preco deve ser um número

Cadastrar Produto Sem Quantidade
    ${body}=        Criar Body Produto    nome=${nome}    preco=${preco}    descricao=${descricao}
    ${header}=      Criar Header    ${TOKEN}
    ${response}=    Criar Response Post    /produtos    400    ${header}    ${body}
    
    Validar Resposta por Keys e Mensagens
    ...    ${response}    
    ...    400
    ...    quantidade=quantidade deve ser um número

Buscar Produto Com ID Inexistente

    ${ID_PRODUTO}=    Generate Random String    16    [LETTERS][NUMBERS]
    ${response}=      Criar Response Get    /produtos/${ID_PRODUTO}    400    ${header}

    log    ${response.json()}
    
    Validar Resposta Completa Através da Mensagem    ${response}   400   Produto não encontrado

Buscar Produto Com ID Malformado
    ${ID_PRODUTO}=    Generate Random String    18   [LETTERS][NUMBERS]
    ${response}=      Criar Response Get    /produtos/${ID_PRODUTO}    400    ${header}

    Validar Resposta por Keys e Mensagens
    ...    ${response}    
    ...    400
    ...    id=id deve ter exatamente 16 caracteres alfanuméricos


Editar Produto Sem Dados

    Cadastrar Produto
    
    ${body}=       Criar Body Produto
    ${header}=     Criar Header    ${TOKEN}
    ${response}=   Criar Response Put    /produtos/${ID_PRODUTO}   400    ${header}    ${body}

    Validar Resposta por Keys e Mensagens    
    ...    ${response}   
    ...    400
    ...    nome=nome não pode ficar em branco
    ...    preco=preco deve ser um número
    ...    descricao=descricao não pode ficar em branco
    ...    quantidade=quantidade deve ser um número
    
    Deletar Produto

Deletar Produto Inexistente
    ${ID_PRODUTO}=    Generate Random String    16    [LETTERS][NUMBERS]
    
    ${header}=        Criar Header    ${TOKEN}
    ${response}=      Criar Response DELETE    /produtos/${ID_PRODUTO}    200    ${header}

    Validar Resposta Completa Através da Mensagem  ${response}      200    Nenhum registro excluído
    
