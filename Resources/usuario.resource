*** Settings ***
Resource     ../Resources/variaveis.resource
Resource     ../Resources/api_session.resource
Resource     ../Resources/carrinho.resource

Library      RequestsLibrary
Library      String
Library      OperatingSystem
Library      Collections
Library      json

*** Keywords ***

Cadastrar Usuário
    [Documentation]     Realiza o cadastro do usuário, verifica se o cadastro foi realizado 
    ...                 com sucesso e guarda o ID para uso em testes subsequentes.
    [Tags]              positivo

    ${body}=        Criar Body    ${nome}    ${email}    ${senha}    ${admin}
    ${response}=    Criar Response POST    /usuarios    201    ${header}    ${body}

    Validar Resposta Completa Através da Mensagem   ${response}    201   Cadastro realizado com sucesso 

    ${id}=   Set Variable    ${response.json()['_id']}

    Set Suite Variable   ${ID_USUARIO}    ${id}

    Create File    ${EXECDIR}/TempFiles/id_usuario.txt    ${id}

Logar Usuário
    [Documentation]    Realiza login com usuário válido, verifica se o loguin foi 
    ...                realizado com sucesso e guarda o token de autorização para uso em testes subsequentes.
    [Tags]             positivo
    ${body}         Create Dictionary    email=${email}    password=${senha}
    ${response}=    Criar Response Post   /login    200    ${header}    ${body} 

    Validar Resposta Completa Através da Mensagem   ${response}    200    Login realizado com sucesso 

    ${authorization}        Set Variable    ${response.json()['authorization']}

    Set Global Variable    ${TOKEN}    ${authorization}

    Create File    ${EXECDIR}/TempFiles/token.txt    ${authorization}

Buscar Usuário
    [Documentation]    Realiza a busca com ID válido, verifica se a busca foi 
    ...                realizada com sucesso e guarda as informações obtidas do Usuário
    [Tags]             positivo
    ${ID_USUARIO}=    Pega INFO em TempFiles    id_usuario.txt

    ${response}=      Criar Response Get   /usuarios/${ID_USUARIO}    200    ${header}

    Validar Resposta Completa Através da Key    ${response}    200    _id
    
    ${json}           Evaluate    json.dumps(${response.json()}, indent=4)    json
    Create File       ${EXECDIR}/Json/usuario_cadastrado.json    ${json}

Editar Usuário
    [Documentation]    Altera informações de um usuário através do ID e verifica se a alteração
    ...                foi realizada com sucesso
    [Tags]             positivo

    ${ID_USUARIO}=     Pega INFO em TempFiles     id_usuario.txt

    ${body}=           Criar Body    WilliamTesteUpdate    william@teste.com.br    teste123456   true
    ${response}=       Criar Response Put  /usuarios/${ID_USUARIO}   200    ${header}    ${body} 

    Validar Resposta Completa Através da Mensagem    ${response}    200    Registro alterado com sucesso

Deletar Usuário Pelo ID em Arquivo
    [Documentation]    Exclui um usuário através do ID obtivo pelo arquivo .txt e verifica se a exclusão
    ...                foi realizada com sucesso
    [Tags]             positivo

    ${ID_USUARIO}=     Pega INFO em TempFiles    id_usuario.txt
    ${response}=       Criar Response DELETE  /usuarios/${ID_USUARIO}  200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    200   Registro excluído com sucesso

Deletar Usuário Pelo ID Informado
    [Documentation]    Exclui um usuário através do ID informado e verifica se a exclusão
    ...                foi realizada com sucesso
    [Tags]             positivo
    [Arguments]        ${ID_USUARIO}

    ${response}=       Criar Response DELETE  /usuarios/${ID_USUARIO}  200    ${header}

    Validar Resposta Completa Através da Mensagem    ${response}    200   Registro excluído com sucesso

Listar Usuários
    [Documentation]    Realiza a busca de todos os usuários cadastrados, verifica se a busca foi 
    ...                realizada com sucesso e guarda as informações obtidas dos Usuários
    [Tags]             positivo

    ${response}=       Criar Response Get  /usuarios   200    ${header}
     
    Validar Resposta Completa Através da Key    ${response}    200    quantidade

    ${json}         Evaluate    json.dumps(${response.json()}, indent=4)    json
    Create File     ${EXECDIR}/Json/usuarios_cadastrados.json    ${json} 

Cadastro Com E-mail Já Existente
    [Documentation]    Tenta cadastrar usuário com e-mail já usado e valida erro 400 e mensagem
    [Tags]             negativo

    Cadastrar Usuário

    ${body}=        Criar Body    ${nome}     ${email}    ${senha}   ${admin}
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}
    
    Validar Resposta Completa Através da Mensagem    ${response}    400    Este email já está sendo usado

    Deletar Usuário Pelo ID em Arquivo

Cadastro Com Senha Vazia
    [Documentation]    Tenta cadastrar usuário com senha vazia e valida erro 400 e mensagem
    [Tags]             negativo
    
    ${body}=        Criar Body    ${nome}    ${email}    administrador=${admin}
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}

    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    password=password não pode ficar em branco


Cadastro Com Nome Vazio
    [Documentation]    Tenta cadastrar usuário com nome vazio e valida erro 400 e mensagem
    [Tags]             negativo

    ${body}=        Criar Body    email=${email}   password=${senha}    administrador=${admin}
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}

    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    nome=nome não pode ficar em branco
    

Cadastro Com E-mail Inválido
    [Documentation]    Tenta cadastrar usuário com e-mail inválido e valida erro 400 e mensagem
    [Tags]             negativo

    ${body}=        Criar Body    ${nome}    email=william$$teste.com.br   password=${senha}   administrador=${admin} 
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}

    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    email=email deve ser um email válido

Cadastro Sem Campo Email
    [Documentation]    Tenta cadastrar usuário sem campo email e valida erro 400 e mensagem
    [Tags]             negativo

    ${body}=        Criar Body    nome=${nome}    password=${senha}   administrador=${admin}
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}

    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    email=email não pode ficar em branco

Logar Com Senha Incorreta
    [Documentation]    Tenta login com senha incorreta e valida erro 401 e mensagem
    [Tags]             negativo

    ${body}=        Create Dictionary    email=${email}    password=senhaerrada123
    ${response}=    Criar Response Post   /login    401    ${header}    ${body}   

    Validar Resposta Completa Através da Mensagem    ${response}    401    Email e/ou senha inválidos
    
Logar Com Campos Vazios
    [Documentation]    Tenta login com campos vazios e valida erro 400 e mensagens
    [Tags]             negativo

    ${body}         Create Dictionary    email=   password=
    ${response}=    Criar Response Post   /login    400    ${header}    ${body}   
    Log    ${response.json()}

    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    email=email não pode ficar em branco
    ...    password=password não pode ficar em branco

Logar Sem Body
    [Documentation]    Tenta login sem corpo e valida erro 400 e mensagens
    [Tags]             negativo

    ${body}=        Set Variable      ${None}
    ${response}=    Criar Response Post   /login    400    ${header}    ${body}   
    Log    ${response}

    Validar Resposta por Keys e Mensagens
    ...    ${response}
    ...    400
    ...    email=email é obrigatório
    ...    password=password é obrigatório

Logar Com Tipo Incorreto
    [Documentation]    Tenta login com tipo incorreto no email e valida erro 400 e mensagem
    [Tags]             negativo

    ${body}         Create Dictionary    email=124435345   password=${senha}
    ${response}=    Criar Response Post   /login    400    ${header}    ${body} 

    Validar Resposta por Keys e Mensagens
    ...    ${response}
    ...    400
    ...    email=email deve ser um email válido

Buscar Usuário Com ID Inexistente
    [Documentation]    Busca usuário com ID inexistente e valida erro 400 e mensagem
    [Tags]             negativo

    ${id_aleatorio}=    Generate Random String    16    [LETTERS][NUMBERS]
 
    ${response}=    Criar Response Get   /usuarios/${id_aleatorio}    400    ${header}    
   
    Validar Resposta Completa Através da Mensagem    ${response}    400    Usuário não encontrado

Buscar Usuário Com ID Malformado
    [Documentation]    Busca usuário com ID malformado e valida erro 400 e mensagem
    [Tags]             negativo

    ${id_aleatorio_malformado}=    Generate Random String    18    [LETTERS][NUMBERS]

    ${response}=    Criar Response Get   /usuarios/${id_aleatorio_malformado}    400    ${header}

    Validar Resposta por Keys e Mensagens
    ...    ${response}
    ...    400
    ...    id=id deve ter exatamente 16 caracteres alfanuméricos


Editar Com Email Já Utilizado
    [Documentation]    Edita usuário com email já utilizado e valida erro 400 e mensagem
    [Tags]             negativo
    
    #Cadastrando Primeiro Usuário
    Cadastrar Usuário

    #Cadastrando Segunduo Usuário
    ${body}=        Criar Body    ${nome}    ${email_2}    ${senha}    ${admin}
    ${response}=    Criar Response POST    /usuarios    201    ${header}    ${body}

    Validar Resposta Completa Através da Mensagem    ${response}    201   Cadastro realizado com sucesso

    ${id_2}=          Set Variable    ${response.json()['_id']}

    #Editando email para um email já existente esperando falha.
    ${body}=        Criar Body    ${nome}    email=${email_2}   password=${senha}   administrador=${admin}
    ${response}=    Criar Response Put  /usuarios/${ID_USUARIO}    400    ${header}    ${body} 

    Validar Resposta Completa Através da Mensagem    ${response}    400    Este email já está sendo usado

    Deletar Usuário Pelo ID em Arquivo
    Deletar Usuário Pelo ID Informado    ${id_2}

Editar Sem Dados
    [Documentation]    Edita usuário sem dados e valida erro 400 e mensagens
    [Tags]             negativo

    Cadastrar Usuário

    ${body}=        Criar Body    
    ${header}=      Criar Header
    ${response}=    Criar Response Put  /usuarios/${ID_USUARIO}    400    ${header}    ${body}  

    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    nome=nome não pode ficar em branco
    ...    email=email não pode ficar em branco
    ...    password=password não pode ficar em branco
    ...    administrador=administrador deve ser 'true' ou 'false'

    Deletar Usuário Pelo ID em Arquivo
    
Editar Com Campos Inválidos
    [Documentation]    Edita usuário com campos inválidos e valida erro 400 e mensagens
    [Tags]             negativo
    Cadastrar Usuário

    ${body}=        Criar Body    email=124124124124    administrador=teste 
    ${header}=      Criar Header
    ${response}=    Criar Response Put  /usuarios/${ID_USUARIO}    400    ${header}    ${body}
     
    Validar Resposta por Keys e Mensagens    
    ...    ${response}    
    ...    400
    ...    nome=nome não pode ficar em branco
    ...    email=email deve ser um email válido
    ...    password=password não pode ficar em branco
    ...    administrador=administrador deve ser 'true' ou 'false'

    Deletar Usuário Pelo ID em Arquivo

Deletar Usuário Inexistente
    [Documentation]    Tenta deletar usuário inexistente e valida resposta 200 com mensagem de nenhum registro excluído
    [Tags]             negativo

    ${id_aleatorio}=    Generate Random String    16    [LETTERS][NUMBERS]

    ${header}=      Criar Header
    ${response}=    Criar Response DELETE  /usuarios/${id_aleatorio}    200    ${header}
     
    Validar Resposta Completa Através da Mensagem    ${response}    200    Nenhum registro excluído
