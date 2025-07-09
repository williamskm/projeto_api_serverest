*** Settings ***
Library           RequestsLibrary
Library           String
Library           OperatingSystem
Library           Collections
Library           json

Resource          api_session.resource
Resource    carrinho.resource


*** Variables ***
${nome}     WilliamTeste
${email}    william@teste.com.br
${senha}    teste123456
${admin}    true


*** Keywords ***

Cadastrar Usuário
    ${body}=        Criar Body    ${nome}    ${email}    ${senha}    ${admin}
    ${header}=      Criar Header
    ${response}=    Criar Response Post    /usuarios    201    ${header}    ${body}

    ${id}=   Set Variable    ${response.json()['_id']}

    Create File    ${EXECDIR}/TempFiles/id_usuario.txt    ${id}

    Set Global Variable    ${ID_USUARIO}    ${id}

    Dictionary Should Contain Value    ${response.json()}    Cadastro realizado com sucesso

Logar Usuário
    ${body}         Create Dictionary    email=${email}    password=${senha}
    ${header}=      Criar Header 
    ${response}=    Criar Response Post   /login    200    ${header}    ${body}   

    ${authorization}        Set Variable    ${response.json()['authorization']}

    Create File    ${EXECDIR}/TempFiles/token.txt    ${authorization}

    Set Global Variable    ${TOKEN}    ${authorization}

    Dictionary Should Contain Value    ${response.json()}    Login realizado com sucesso

Buscar Usuário
    ${ID_USUARIO}=    Buscar Info em Temp Files    id_usuario.txt

    ${header}=        Criar Header
    ${response}=      Criar Response Get   /usuarios/${ID_USUARIO}    200    ${header}
    
    ${json}           Evaluate    json.dumps(${response.json()}, indent=4)    json
    Create File       ${EXECDIR}/Json/usuario_cadastrado.json    ${json}

Editar Usuário
    ${ID_USUARIO}=    Buscar Info em Temp Files    id_usuario.txt
    ${body}=          Criar Body    WilliamTesteUpdate    william@teste.com.br    teste123456   true
    ${header}=        Criar Header
    ${response}=      Criar Response Put  /usuarios/${ID_USUARIO}   200    ${header}    ${body} 

    Dictionary Should Contain Value    ${response.json()}    value=Registro alterado com sucesso

Deletar Usuário
    ${ID_USUARIO}=      Buscar Info em Temp Files    id_usuario.txt

    ${header}=    Criar Header
    ${response}=        Criar Response DELETE  /usuarios/${ID_USUARIO}  200    ${header}

    
    Dictionary Should Contain Value    ${response.json()}    Registro excluído com sucesso

Listar Usuários
    ${header}=      Criar Header
    ${response}=    Criar Response Get  /usuarios   200    ${header}

    ${json}         Evaluate    json.dumps(${response.json()}, indent=4)    json
    Create File     ${EXECDIR}/Json/usuarios_cadastrados.json    ${json} 

Cadastro Com E-mail Já Existente
    Cadastrar Usuário

    ${body}=        Criar Body    ${nome}     ${email}    ${senha}   ${admin}
    ${header}=      Criar Header
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}

    Should Be Equal As Strings    ${response.json()['message']}    Este email já está sendo usado

    Deletar Usuário

Cadastro Com Senha Vazia
    ${body}=        Criar Body    ${nome}    ${email}    administrador=${admin}
    ${header}=      Criar Header
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}
    
    Should Be Equal As Strings    ${response.json()['password']}    password não pode ficar em branco

Cadastro Com Nome Vazio
    ${body}=        Criar Body    email=${email}   password=${senha}    administrador=${admin}
    ${header}=      Criar Header
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}
    
    Should Be Equal As Strings    ${response.json()['nome']}    nome não pode ficar em branco

Cadastro Com E-mail Inválido
    ${body}=        Criar Body    ${nome}    email=william$$teste.com.br   password=${senha}   administrador=${admin} 
    ${header}=      Criar Header
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}
    
    Should Be Equal As Strings    ${response.json()['email']}    email deve ser um email válido

Cadastro Sem Campo Email
    ${body}=        Criar Body    nome=${nome}    password=${senha}   administrador=${admin}
    ${header}=      Criar Header
    ${response}=    Criar Response Post    /usuarios    400    ${header}    ${body}
    
    Should Be Equal As Strings    ${response.json()['email']}    email não pode ficar em branco

Logar Com Senha Incorreta
    ${body}=        Create Dictionary    email=${email}    password=senhaerrada123
    ${header}=      Criar Header 
    ${response}=    Criar Response Post   /login    401    ${header}    ${body}   

    Should Be Equal As Strings    ${response.json()['message']}    Email e/ou senha inválidos
    
Logar Com Campos Vazios
    ${body}         Create Dictionary    email=   password=
    ${header}=      Criar Header 
    ${response}=    Criar Response Post   /login    400    ${header}    ${body}   

    Should Be Equal As Strings    ${response.json()['email']}    email não pode ficar em branco
    Should Be Equal As Strings    ${response.json()['password']}    password não pode ficar em branco

Logar Sem Body
    ${body}=        Set Variable      ${None}
    ${header}=      Criar Header 
    ${response}=    Criar Response Post   /login    400    ${header}    ${body}   

    Should Be Equal As Strings    ${response.json()['email']}    email é obrigatório
    Should Be Equal As Strings    ${response.json()['password']}    password é obrigatório

Logar Com Tipo Incorreto
    ${body}         Create Dictionary    email=124435345   password=${senha}
    ${header}=      Criar Header 
    ${response}=    Criar Response Post   /login    400    ${header}    ${body}   

    Should Be Equal As Strings    ${response.json()['email']}    email deve ser um email válido   

Buscar Usuário Com ID Inexistente
    ${id_invalido}=          Set Variable    0uxuPY0cbmQhpEzx
    ${header}=      Criar Header
    ${response}=    Criar Response Get   /usuarios/${id_invalido}    400    ${header}    
    
    Should Be Equal As Strings    ${response.json()['message']}    Usuário não encontrado

Buscar Usuário Com ID Malformado
    ${id}=          Set Variable    0uxuPY0cbmQhpEzxxxxx
    ${header}=      Criar Header
    ${response}=    Criar Response Get   /usuarios/${id}    400    ${header}    
    
    Should Be Equal As Strings    ${response.json()['id']}    id deve ter exatamente 16 caracteres alfanuméricos

Editar Com Email Já Utilizado
    Cadastrar Usuário

    ${body}=        Criar Body    ${nome}    email=fulano@qa.com   password=${senha}   administrador=${admin}
    ${header}=      Criar Header
    ${response}=    Criar Response Put  /usuarios/${ID_USUARIO}    400    ${header}    ${body}  

    Should Be Equal As Strings    ${response.json()['message']}    Este email já está sendo usado

    Deletar Usuário

Editar Sem Dados
    Cadastrar Usuário

    ${body}=        Criar Body    
    ${header}=      Criar Header
    ${response}=    Criar Response Put  /usuarios/${ID_USUARIO}    400    ${header}    ${body}  

    Should Be Equal As Strings    ${response.json()['nome']}             nome não pode ficar em branco
    Should Be Equal As Strings    ${response.json()['email']}            email não pode ficar em branco
    Should Be Equal As Strings    ${response.json()['password']}         password não pode ficar em branco
    Should Be Equal As Strings    ${response.json()['administrador']}    administrador deve ser 'true' ou 'false'

    Deletar Usuário
    
Editar Com Campos Inválidos
    Cadastrar Usuário

    ${body}=        Criar Body    email=124124124124    administrador=teste 
    ${header}=      Criar Header
    ${response}=    Criar Response Put  /usuarios/${ID_USUARIO}    400    ${header}    ${body}  

    Should Be Equal As Strings    ${response.json()['email']}            email deve ser um email válido
    Should Be Equal As Strings    ${response.json()['administrador']}    administrador deve ser 'true' ou 'false'

    Deletar Usuário

Deletar Usuário Inexistente
    ${id}=    Set Variable    teste123415
    ${header}=      Criar Header
    ${response}=    Criar Response DELETE  /usuarios/${id}    200    ${header}
      
    Should Be Equal As Strings    ${response.json()['message']}    Nenhum registro excluído