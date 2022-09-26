unit Services.Base;

interface

uses
  System.SysUtils, System.Classes, Providers.Session, System.Math;

type
  TServiceBase = class(TDataModule)
  private
    FOffset, FRecorCount: integer;
  public
    property Offset: Integer read FOffset write FOffset;
    property RecordCount: Integer read FRecorCount write FRecorCount;
     function GetPaginas: integer;
     function GetPaginaCorrente: integer;
     function Session: TSession;
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TServiceBase }

function TServiceBase.GetPaginaCorrente: integer;
begin
  result := ceil((FOffset + 25) / 25);
end;

function TServiceBase.GetPaginas: integer;
begin
  if FRecorCount = 0 then
    result := 1
  else
    result := ceil(FRecorCount / 25);
end;

function TServiceBase.Session: TSession;
begin
  result := TSession.getInstance();
end;

end.
