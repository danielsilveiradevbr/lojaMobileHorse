unit Services.Pedido;

interface

uses
  System.SysUtils, System.Classes, Services.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Providers.Request;

type
  TServicePedido = class(TServiceBase)
    mtPedidos: TFDMemTable;
    mtPedidosid: TLargeintField;
    mtPedidosid_cliente: TLargeintField;
    mtPedidosdata: TSQLTimeStampField;
    mtPedidosid_usuario: TLargeintField;
    mtPedidosnome_cliente: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ListarPedidosUsuario;
  end;


implementation

uses DataSet.Serialize, System.JSON;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TServicePedido.DataModuleCreate(Sender: TObject);
begin
  inherited;
  mtPedidos.open;
end;

procedure TServicePedido.ListarPedidosUsuario;
begin
  var LResponse := TRequest
                   .New
                   .BaseURL('http://localhost:9000')
                   .Resource('pedidos')
                   .AddParam('idUsuario', Session.User.Id.ToString)
                   .Get;
  if LResponse.StatusCode <> 200 then
    raise Exception.Create(LResponse.Content);
  mtPedidos.EmptyDataSet;
  mtPedidos.LoadFromJSON(LResponse.JSONValue.GetValue<TJSONArray>('data'), false);

end;

end.
