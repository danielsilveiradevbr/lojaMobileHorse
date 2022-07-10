unit Providers.Session;

interface

uses
  Providers.Models.Token;

type
  TSession = class
  private
    FToken: TToken;
    procedure inicializar();
  public
    property Token: TToken read FToken write FToken;
    class function getInstance: TSession;
    class function NewInstance: TObject; override;
    destructor destroy; override;
  end;

var
  Session: TSession;

implementation

{ TSession }

destructor TSession.destroy;
begin
  FToken.free;
  inherited;
end;

class function TSession.getInstance: TSession;
begin
  result := TSession.create();
end;

procedure TSession.inicializar;
begin
  FToken := TToken.create();
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
