*** Settings ***
Resource          ../Resources/usuario.resource
Resource          ../Resources/produtos.resource

Library           RequestsLibrary
Library           String
Library           OperatingSystem
Library           Collections
Library           json

*** Variables ***
${nome_produto}              Logitech G402 Hero
${preco}                     402
${descricao}                 Mouse    
${quantidade}                12



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

    ${id}    Set Variable        ${response.json()['_id']}

    Create File    ${EXECDIR}/TempFiles/id_produto.txt    ${id} 

    Set Suite Variable    ${ID_PRODUTO}    ${id}
    

Buscar Produto por ID
    ${ID_PRODUTO}=    Buscar Info em Temp Files    id_produto.txt
    ${header}=        Criar Header
    ${response}=      Criar Response Get    /produtos/${ID_PRODUTO}    200    ${header}

    ${json}         Evaluate    json.dumps(${response.json()}, indent=4)    json
    Create File     ${EXECDIR}/Json/produto_cadastrado.json    ${json}


Editar Produto
    ${ID_PRODUTO}=    Buscar Info em Temp Files    id_produto.txt
    
    ${body}=    Criar Body Produto    Logitech PRO MAX    1200    Mouse Gamer    110
    ${header}=    Criar Header    ${TOKEN}
    ${response}=      Criar Response Put    /produtos/${ID_PRODUTO}   200    ${header}    ${body}

    Dictionary Should Contain Value    ${response.json()}    value=Registro alterado com sucesso


Deletar Produto
    ${ID_PRODUTO}=    Buscar Info em Temp Files    id_produto.txt
    
    ${header}=        Criar Header    ${TOKEN}
    ${response}=      Criar Response DELETE    /produtos/${ID_PRODUTO}    200    ${header}

    Log    ${response.json()}

    Should Be Equal As Strings   ${response.json()['message']}    Registro excluído com sucesso

Listar Produtos   
    ${header}=    Criar Header
    ${response}=     Criar Response Get    /produtos    200   ${header}

    ${json}         Evaluate    json.dumps(${response.json()}, indent=4)    json
    Create File     ${EXECDIR}/Json/produtos_cadastrados.json    ${json} 

Cadastrar Produto Sem Nome
    ${body}=        Criar Body Produto    preco=${preco}    descricao=${descricao}    quantidade=${quantidade}
    ${header}=      Criar Header    ${TOKEN}
    ${response}=    Criar Response Post    /produtos    400    ${header}    ${body}
    
    Should Be Equal As Strings    ${response.json()['nome']}    nome não pode ficar em branco

Cadastrar Produto Sem Preço
    ${body}=        Criar Body Produto    nome=${nome}    descricao=${descricao}    quantidade=${quantidade}
    ${header}=      Criar Header    ${TOKEN}
    ${response}=    Criar Response Post    /produtos    400    ${header}    ${body}
    
    Should Be Equal As Strings    ${response.json()['preco']}    preco deve ser um número

Cadastrar Produto Sem Quantidade
    ${body}=        Criar Body Produto    nome=${nome}    preco=${preco}    descricao=${descricao}
    ${header}=      Criar Header    ${TOKEN}
    ${response}=    Criar Response Post    /produtos    400    ${header}    ${body}

    log    ${response.json()}
    
    Should Be Equal As Strings    ${response.json()['quantidade']}    quantidade deve ser um número

Buscar Produto Com ID Inexistente
    ${ID_PRODUTO}=    Set Variable    BeeJh5lz3k6kSXXX
    ${header}=      Criar Header
    ${response}=    Criar Response Get    /produtos/${ID_PRODUTO}    400    ${header}

    log    ${response.json()}
    
    Should Be Equal As Strings    ${response.json()['message']}    Produto não encontrado

Buscar Produto Com ID Malformado
    ${ID_PRODUTO}=    Set Variable    BeeJh5lz3k6kSIzBxx
    ${header}=      Criar Header
    ${response}=    Criar Response Get    /produtos/${ID_PRODUTO}    400    ${header}

    log    ${response.json()}
    
    Should Be Equal As Strings    ${response.json()['id']}    id deve ter exatamente 16 caracteres alfanuméricos

Editar Produto Sem Dados
    Cadastrar Produto
    
    ${body}=    Criar Body Produto
    ${header}=    Criar Header    ${TOKEN}
    ${response}=      Criar Response Put    /produtos/${ID_PRODUTO}   400    ${header}    ${body}

    Should Be Equal As Strings    ${response.json()['nome']}          nome não pode ficar em branco
    Should Be Equal As Strings    ${response.json()['preco']}         preco deve ser um número
    Should Be Equal As Strings    ${response.json()['descricao']}     descricao não pode ficar em branco
    Should Be Equal As Strings    ${response.json()['quantidade']}    quantidade deve ser um número

    Deletar Produto

Deletar Produto Inexistente
    ${ID_PRODUTO}=    Set Variable    1234566778123452
    
    ${header}=        Criar Header    ${TOKEN}
    ${response}=      Criar Response DELETE    /produtos/${ID_PRODUTO}    200    ${header}

    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['message']}    Nenhum registro excluído
    