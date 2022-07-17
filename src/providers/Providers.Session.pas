unit Providers.Session;

interface

uses
  Providers.Models.Token, Providers.Models.User;

type
  TSession = class
  private
    FToken: TToken;
    FUsuario: TUser;
    procedure inicializar();
  public
    property Token: TToken read FToken write FToken;
    property User: TUser read FUsuario write FUsuario;
    class function getInstance: TSession;
    class function NewInstance: TObject; override;
    destructor Destroy; override;
  end;

var
  Session: TSession;

implementation

{ TSession }

destructor TSession.destroy;
begin
  FToken.free;
  FUsuario.free;
  inherited;
end;

class function TSession.getInstance: TSession;
begin
  result := TSession.create();
end;

procedure TSession.inicializar;
begin
  FToken := TToken.create();
  FUsuario := TUser.create();
end;

class function TSession.NewInstance: TObject;
begin
  if not assigned(Session) then
  begin
    Session := TSession(inherited NewInstance);
    session.inicializar();
  end;
  result := Session;
end;

initialization

finalization
  if assigned(Session) then
    Session.free;

end.
