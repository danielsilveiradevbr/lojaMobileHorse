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
    mtCadastro: TFDMemTable;
    mtItens: TFDMemTable;
    mtCadastroid: TLargeintField;
    mtCadastroid_cliente: TLargeintField;
    mtCadastrodata: TSQLTimeStampField;
    mtCadastroid_usuario: TLargeintField;
    mtCadastronome_cliente: TWideStringField;
    mtItensid: TLargeintField;
    mtItensid_pedido: TLargeintField;
    mtItensid_produto: TLargeintField;
    mtItensvalor: TFMTBCDField;
    mtItensquantidade: TFMTBCDField;
    mtItensnome_produto: TWideStringField;
    mtCadastrototal: TCurrencyField;
    mtItenstotal: TCurrencyField;
    mtPedidostotal: TCurrencyField;
    procedure DataModuleCreate(Sender: TObject);
    procedure mtItensBeforePost(DataSet: TDataSet);
  private
    procedure AtualizarTotal();
    procedure CarregarItensPedido(const AId: String);
  public
    procedure ListarPedidosUsuario;
    procedure InicializatVenda(const AIDCliente: String);
    procedure AdicionarProduto(const ADataSet: TDataSet);
    procedure DeletarItem(const AId: String);
    procedure DeletarPedido(const AId: String);
    procedure AlterarQuantidadeItem(const AQuantidade, AId: String);
    procedure NovaVenda;
    procedure CarregarPedido(const AId: String);
  end;


implementation

uses DataSet.Serialize, System.JSON, Providers.Constants;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TServicePedido.AdicionarProduto(const ADataSet: TDataSet);
var
  LResponse: IResponse;
begin
  if mtItens.locate('id_produto', ADataset.FieldByName('id').asString, []) then
    mtItens.edit
  else
    mtItens.append;
  mtItensid_pedido.AsLargeInt := mtCadastroid.AsLargeInt;
  mtItensid_produto.AsLargeInt := ADataSet.fieldbyName('id').AsLargeInt;
  mtItensvalor.AsCurrency := ADataSet.FieldByName('valor').AsCurrency;
  mtItensquantidade.AsInteger := mtItensquantidade.AsInteger + 1;
  mtItensnome_produto.AsString := ADataSet.FieldByName('nome').AsString;
  //
  mtItens.post;
  var LRequest := TRequest
                  .new
                  .BaseURL(SERVER_PRINCIPAL)
                  .Resource('pedidos/' + mtCadastroid.asString + '/itens')
                  .AddBody(mtItens.tojsonobject);
  if mtItensid.AsLargeInt > 0 then
  begin
    LResponse := LRequest.ResourceSuffix(mtItensid.asString).put;
    if LResponse.StatusCode <> 204 then
      raise Exception.create(LResponse.Content);
  end
  else
  begin
    LResponse := LRequest.post;
    if LResponse.StatusCode <> 201 then
      raise Exception.create(LResponse.Content);
    mtItens.MergeFromJSONObject(TJSonObject(LResponse.JsonValue), false);
  end;
  AtualizarTotal;
end;

procedure TServicePedido.AlterarQuantidadeItem(const AQuantidade, AId: String);
begin
  if not mtItens.locate('ID', AId, []) then
    exit;
  mtItens.edit;
  mtItensquantidade.AsInteger := AQuantidade.ToInteger;
  mtItens.Post;
  //
  var LResponse := TRequest
                  .new
                  .BaseURL(SERVER_PRINCIPAL)
                  .Resource('pedidos/' + mtCadastroid.asString + '/itens')
                  .ResourceSuffix(AId)
                  .AddBody(mtItens.TOJSonObject)
                  .Put;
  if LResponse.StatusCode <> 204 then
    raise Exception.Create(LResponse.Content);
  AtualizarTotal;
end;

procedure TServicePedido.AtualizarTotal;
begin
  var Lid := mtItensId.AsLargeInt;
  try
    mtCadastro.Edit;
    mtCadastrototal.asCurrency := 0.00;
    mtItens.First;
    while not mtItens.eof do
    begin
      mtCadastrototal.asCurrency := mtCadastrototal.asCurrency + mtItenstotal.asCurrency;
      mtItens.next;
    end;
    mtCadastro.post;
  finally
    mtItens.locate('id', Lid, []);
  end;
end;

procedure TServicePedido.CarregarPedido(const AId: String);
begin
  var LResponse := TRequest
                   .new
                   .baseUrl(SERVER_PRINCIPAL)
                   .resource('pedidos')
                   .ResourceSuffix(AId)
                   .Get;
  if LResponse.StatusCode <> 200 then
    raise Exception.Create(LResponse.Content);
  if not mtCadastro.Active then
    mtCadastro.Open;
  mtCadastro.EmptyDataSet;
  mtCadastro.LoadFromJSON(TJSONObject(LResponse.JSONValue), false); //quem vai dest o json é o lresp
  CarregarItensPedido(AID);
  AtualizarTotal;
end;

procedure TServicePedido.CarregarItensPedido(const AId: String);
begin
  var LResponse := TRequest
                   .new
                   .baseUrl(SERVER_PRINCIPAL)
                   .resource('pedidos/' + AId + '/itens')
                   .Get;
  if LResponse.StatusCode <> 200 then
    raise Exception.Create(LResponse.Content);
  if not mtItens.Active then
    mtItens.Open;
  mtItens.EmptyDataSet;
  mtItens.LoadFromJSON(LResponse.JSONValue.GetValue<TJSONArray>('data'), false); //quem vai dest o json é o lresp
end;

procedure TServicePedido.DataModuleCreate(Sender: TObject);
begin
  inherited;
  mtPedidos.open;
end;

procedure TServicePedido.DeletarItem(const AId: String);
begin
  if not mtItens.Locate('id', AId, []) then
    raise Exception.Create('Item não localizado');
  var LResponse := TRequest
               .new
                .BaseURL(SERVER_PRINCIPAL)
                .Resource('pedidos/' + mtCadastroid.asString + '/itens')
                .ResourceSuffix(AId)
                .Delete;
  if LResponse.StatusCode <> 204 then
    raise Exception.Create(LResponse.Content);
  mtItens.delete;
  AtualizarTotal;
end;

procedure TServicePedido.DeletarPedido(const AId: String);
begin
  if mtPedidos.Locate('id', AId, []) then
  begin
    var LResponse := TRequest
                  .new
                  .BaseURL(SERVER_PRINCIPAL)
                  .Resource('pedidos')
                  .ResourceSuffix(AId)
                  .Delete;
    if LResponse.StatusCode <> 204 then
      raise Exception.Create(LResponse.Content);
    mtPedidos.delete;
  end;
end;

procedure TServicePedido.InicializatVenda(const AIDCliente: String);
var
  LResponse: IResponse;
begin
  if not mtCadastro.active then
  begin
    mtCadastro.Open;
    mtCadastro.append;
    mtCadastrodata.AsDateTime := now;
    mtCadastroid_usuario.AsLargeInt := Session.User.Id;
    mtItens.Open;
  end
  else
    mtCadastro.Edit;
  mtCadastroid_cliente.AsString := AIDCliente;
  mtCadastro.Post;
  var LRequest := TRequest
                   .New
                   .BaseURL(SERVER_PRINCIPAL)
                   .Resource('pedidos')
                   .AddBody(mtCadastro.TOJSonObject);
  if (mtCadastroid.AsLargeInt > 0 ) then
  begin
    LResponse := LRequest.ResourceSuffix(mtCadastroid.AsString).Post;
    if LResponse.StatusCode <> 204 then
      raise Exception.Create(LResponse.Content);
  end
  else
  begin
    LResponse := LRequest.Post;
    if LResponse.StatusCode <> 201 then
      raise Exception.Create(LResponse.Content);
    mtCadastro.MergeFromJSONObject(TJSONObject(LResponse.JSONValue), false);
  end;
end;

procedure TServicePedido.ListarPedidosUsuario;
begin
  var LResponse := TRequest
                   .New
                   .BaseURL(SERVER_PRINCIPAL)
                   .Resource('pedidos')
                   .AddParam('idUsuario', Session.User.Id.ToString)
                   .AddParam('limit', '25')
                   .AddParam('offset', self.offset.toString)
                   .Get;
  if LResponse.StatusCode <> 200 then
    raise Exception.Create(LResponse.Content);
  mtPedidos.EmptyDataSet;
  mtPedidos.LoadFromJSON(LResponse.JSONValue.GetValue<TJSONArray>('data'), false);
  self.recordcount := Lresponse.JSONValue.GetValue<integer>('records', 0);
end;

procedure TServicePedido.mtItensBeforePost(DataSet: TDataSet);
begin
  inherited;
  mtItenstotal.AsCurrency := mtItensvalor.AsCurrency * mtItensquantidade.AsInteger;
end;

procedure TServicePedido.NovaVenda;
begin
  mtItens.Close;
  mtCadastro.close;
end;

end.
