unit Services.Base;

interface

uses
  System.SysUtils, System.Classes, Providers.Session;

type
  TServiceBase = class(TDataModule)
  protected
    function Session: TSession;
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TServiceBase }

function TServiceBase.Session: TSession;
begin
  result := TSession.getInstance();
end;

end.
