unit Services.Consulta.Produto;

interface

uses
  System.SysUtils, System.Classes, Services.Base, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TServiceConsultaProduto = class(TServiceBase)
    mtProdutos: TFDMemTable;
    mtProdutosid: TLargeintField;
    mtProdutosnome: TWideStringField;
    mtProdutosvalor: TFMTBCDField;
    mtProdutosstatus: TSmallintField;
    mtProdutosestoque: TFMTBCDField;
  private

  public
    procedure listarProdutos(const ADescricao: String);
  end;

var
  ServiceConsultaProduto: TServiceConsultaProduto;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Providers.Request, System.Json, DataSet.serialize;

{$R *.dfm}

{ TServiceConsultaProduto }

procedure TServiceConsultaProduto.listarProdutos(const ADescricao: String);
begin
  if not mtProdutos.active then
    mtProdutos.Open;
  var LResponse := TRequest
                   .New
                   .BaseURL('http://localhost:9000')
                   .Resource('produtos')
                   .AddParam('nome', ADescricao)
                   .AddParam('limit', '25')
                   .AddParam('offset', self.offset.toString)
                   .Get;
  if LResponse.StatusCode <> 200 then
    raise Exception.Create(LResponse.Content);
  mtProdutos.EmptyDataSet;
  mtProdutos.LoadFromJSON(LResponse.JSONValue.GetValue<TJSONArray>('data'), false);
  self.recordcount := Lresponse.JSONValue.GetValue<integer>('records', 0);
end;

end.
