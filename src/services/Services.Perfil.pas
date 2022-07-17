unit Services.Perfil;

interface

uses
  System.SysUtils, System.Classes, Services.Base, Providers.Request;

type
  TServicePerfil = class(TServiceBase)
  private
    { Private declarations }
  public
    function DonwloadFoto(): TMemoryStream;
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TServiceBase1 }

function TServicePerfil.DonwloadFoto: TMemoryStream;
begin
  result := TMemorySTream.create;
  var LResponse := TRequest
                   .new
                   .BaseUrl('http://localhost:9000')
                   .resource('usuarios/' + Session.User.ID.toString + '/foto')
                   .contentType('application/octet-stream')
                   .get;
  if LResponse.statusCode = 200 then
  begin
    if length(LResponse.rawBytes) > 0 then
    begin
      result.WriteBuffer(LResponse.rawBytes[0], length(LResponse.rawBytes));
      result.position := 0;
    end;
  end;
end;

end.
