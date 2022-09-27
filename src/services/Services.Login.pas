unit Services.Login;

interface

uses
  System.SysUtils, System.Classes, Services.Base, Providers.Request.intf, Providers.Request,
  System.Generics.Collections;

type
  TServiceLogin = class(TServiceBase)
  private
    procedure carregarDadosUsuario(const AUsername: String);
  public
    procedure Login(const AUserName, APassword: String);
  end;

implementation

uses
  System.Json, Providers.Session, Providers.Constants;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TServiceLogin }

procedure TServiceLogin.Login(const AUsername, APassword: String);
begin
  if AUsername.trim().isEmpty or APassword.trim().isEmpty then
    raise Exception.Create('Informe usuário e senha!');
  var LUsuario := TJSONObject.create;
  LUsuario.addPair('username', AUsername);
  LUsuario.addPair('senha', APassword);
  var LResponse := TRequest
                   .new
                   .baseUrl(SERVER_AUTH)
                   .resource('login')
                   .addBody(LUsuario)
                   .post;
  if LResponse.StatusCode <> 200 then
    raise exception.Create(LResponse.JSONValue.getValue<string>('error'));
  TSession.getInstance().Token.Access := LResponse.JSONValue.getValue<string>('access');
  TSession.getInstance().Token.Refresh := LResponse.JSONValue.getValue<string>('refresh');
  carregarDadosUsuario(AUsername);
end;

procedure TServiceLogin.carregarDadosUsuario(const AUsername: String);
begin
  var LResponse := TRequest
                   .new
                   .baseUrl(SERVER_PRINCIPAL)
                   .resource('usuarios')
                   .addParam('login', AUsername)
                   .get;
  if LResponse.StatusCode <> 200 then
    raise exception.Create(LResponse.JSONValue.getValue<string>('error'));
  //
  var LUser := TJSONObject(LResponse.JSONValue.getValue<TJSONArray>('data').items[0]);
  TSession.getInstance().User.Id := LUser.getValue<integer>('id');
  TSession.getInstance().User.nome := LUser.getValue<string>('nome');
  TSession.getInstance().User.telefone := LUser.getValue<string>('telefone');
  TSession.getInstance().User.login := LUser.getValue<string>('login');
  TSession.getInstance().User.sexo := LUser.getValue<integer>('sexo');
end;

end.
