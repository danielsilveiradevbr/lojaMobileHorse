unit Services.Consulta.Cliente;

interface

uses
  System.SysUtils, System.Classes, Services.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TServiceConsultaCliente = class(TServiceBase)
    mtClientes: TFDMemTable;
    mtClientesid: TLargeintField;
    mtClientesnome: TWideStringField;
    mtClientesstatus: TSmallintField;
  private
    { Private declarations }
  public
    procedure ListarClientes(const ANome: String);
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Providers.Request, DataSet.Serialize, System.JSON;

{$R *.dfm}

{ TServiceConsultaCliente }

procedure TServiceConsultaCliente.ListarClientes(const ANome: String);
begin
  if not mtClientes.active then
    mtClientes.Open;
  var LResponse := TRequest
                   .New
                   .BaseURL('http://localhost:9000')
                   .Resource('clientes')
                   .AddParam('nome', Anome)
                   .Get;
  if LResponse.StatusCode <> 200 then
    raise Exception.Create(LResponse.Content);
  mtClientes.EmptyDataSet;
  mtClientes.LoadFromJSON(LResponse.JSONValue.GetValue<TJSONArray>('data'), false);
end;

end.
