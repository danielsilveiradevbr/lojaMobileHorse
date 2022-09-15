unit Views.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, FMX.TabControl, Services.Pedido, Data.Db,
  Views.Consulta.Produto, Providers.Frames.Pedido, Providers.Frames.Pedido.Item;

type
  TFrmPedido = class(TFrameBaseView)
    retContent: TRectangle;
    TabControlPedido: TTabControl;
    TabItemConsulta: TTabItem;
    TabItemCadastro: TTabItem;
    retContentCadastro: TRectangle;
    retContentConsulta: TRectangle;
    btnAdicionarVenda: TButton;
    imgAdicionarVenda: TPath;
    vsbPedidos: TVertScrollBox;
    lytNenhumaVenda: TLayout;
    lblTelefone: TLabel;
    Path1: TPath;
    retHeaderCadastro: TRectangle;
    btnVoltar: TButton;
    imgVoltar: TPath;
    btnAdicionarProduto: TButton;
    imgAdicionarProduto: TPath;
    LineSeparatorHeader: TLine;
    lytContentCliente: TLayout;
    lytCliente: TLayout;
    lblCliente: TLabel;
    txtNomeCliente: TLabel;
    btnBuscaCliente: TButton;
    imgBuscaCliente: TPath;
    vsbProdutos: TVertScrollBox;
    lytTotalVenda: TLayout;
    txtTotal: TLabel;
    btnConfirmar: TButton;
    Line1: TLine;
    retOffSet: TRectangle;
    procedure btnAdicionarVendaClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnBuscaClienteClick(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
  private
    FService: TServicePedido;
    procedure DesignPedidos;
    procedure NovaVenda;
    procedure OnSelectCliente(const ADataSet: TDataSet);
    procedure OnSelectProduto(const ADataSet: TDataSet);
    function GetFrameProduto(const AIdProduto: String): TFramePedidoItem;
    procedure OnDeleteItem(ASender: TObject);
    procedure AtualizarTotal;
    procedure OnDeletePedido(ASender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoAfterShow; override;
  end;

implementation

{$R *.fmx}

uses Providers.Aguarde, Views.Consulta.Cliente;

{ TFrmPedido }

procedure TFrmPedido.AtualizarTotal;
begin
  txtTotal.text := formatFloat('R$ ,0.00', Fservice.mtcadastroTotal.AsCurrency);
end;

procedure TFrmPedido.btnAdicionarProdutoClick(Sender: TObject);
begin
  inherited;
  var LFrame := TFrameConsultaProduto.create(self);
  LFrame.align := TAlignLayout.Contents;
  LFrame.callBack := OnSelectProduto;
  lytContent.addObject(LFrame);
  LFrame.BringToFront;
end;

procedure TFrmPedido.btnAdicionarVendaClick(Sender: TObject);
begin
  inherited;
  NovaVenda;
end;

procedure TFrmPedido.btnBuscaClienteClick(Sender: TObject);
begin
  inherited;
  var LFrame := TFrameConsultaCliente.create(self);
  LFrame.align := TAlignLayout.Contents;
  LFrame.callBack := OnSelectCliente;
  lytContent.addObject(LFrame);
  LFrame.BringToFront;
end;

procedure TFrmPedido.btnVoltarClick(Sender: TObject);
begin
  inherited;
  TabControlPedido.Previous();
end;

constructor TFrmPedido.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FService := TServicePedido.Create(self);
  btnConfirmar.Visible := false;
end;

procedure TFrmPedido.DesignPedidos;
var
  LFramePedido: TFramePedido;
begin
  lytNenhumaVenda.Visible := FService.mtPedidos.isEmpty;
  vsbPedidos.Visible := not FService.mtPedidos.isEmpty;
  if lytNenhumaVenda.Visible then
    exit;
  vsbPedidos.BeginUpdate;
  try
    for var ind := Pred(vsbPedidos.Content.controlsCount) downto 0 do begin
      if vsbPedidos.Content.Controls.items[ind] is TFramePedido then
        vsbPedidos.Controls.items[ind].disposeOf;
    end;
    FSErvice.mtPedidos.first;
    while not FSErvice.mtPedidos.eof do
    begin
      LFramePedido := TFramePedido.create(vsbPedidos);
      LFramePedido.name := LFramePedido.className + '_' + FService.mtPedidosid.asString;
      LFramePedido.Identify := FService.mtPedidosid.asString;
      LFramePedido.align := TAlignLayout.top;
      LFramePedido.txtNumero.text := FService.mtPedidosid.asString;
      LFramePedido.txtDataVenda.text := formatDateTime('dd/mm/yyyy', FService.mtPedidosData.asDateTime);
      LFramePedido.txtValorVenda.text := formatFloat('R$ ,0.00;', FService.mtPedidostotal.asFloat);
      LFramePedido.txtNomeCliente.text := FService.mtPedidosnome_cliente.asString;
      LFramePedido.parent := vsbPedidos;
      LFramePedido.OnDeletePedido := Self.OnDeletePedido;
      FSErvice.mtPedidos.next;
    end;
    retOffSet.Position.x := vsbPedidos.Content.controlsCount * 130 + retOffSet.Height;
  finally

  end;
  vsbPedidos.EndUpdate;
end;

destructor TFrmPedido.Destroy;
begin
  FService.free;
  inherited;
end;

procedure TFrmPedido.DoAfterShow;
begin
  TabControlPedido.ActiveTab := TabItemConsulta;
  TAguarde.Aguardar(
    procedure
    begin
      FService.ListarPedidosUsuario;
      sleep(2000);
      TThread.synchronize(TThread.current,
        procedure
        begin
          DesignPedidos;
        end
      );
    end
  );
end;

procedure TFrmPedido.NovaVenda;
begin
  btnAdicionarProduto.Visible := false;
  txtNomeCliente.text := 'Nenhum cliente selecionado';
  txtTotal.text := formatFloat('R$ ,0.00;', 0);
  TabControlPedido.Next();
end;

procedure TFrmPedido.OnDeleteItem(ASender: TObject);
begin
  if not ASender.InheritsFrom(TFramePedidoItem) then
    exit;
  FService.DeletarItem(TFramePedidoItem(ASender).Identify);
  TFramePedidoItem(ASender).DisposeOf;
  AtualizarTotal;
end;

procedure TFrmPedido.OnDeletePedido(ASender: TObject);
begin
  if not ASender.InheritsFrom(TFramePedido) then
    exit;
  FService.DeletarPedido(TFramePedido(Asender).Identify);
  TFramePedido(Asender).DisposeOf;
end;

procedure TFrmPedido.OnSelectCliente(const ADataSet: TDataSet);
begin
  FService.InicializatVenda(ADataSet.FieldByName('ID').AsString);
  txtNomeCliente.text := ADataset.fieldByName('nome').asString;
  btnAdicionarProduto.Visible := true;
  btnConfirmar.Visible := true;
end;

procedure TFrmPedido.OnSelectProduto(const ADataSet: TDataSet);
begin
  Fservice.AdicionarProduto(ADataSet);
  vsbProdutos.BeginUpdate;
  try
    var LFrame := GetFrameProduto(FService.mtItensid_produto.AsString);
    LFrame.Align := TAlignLayout.top;
    LFrame.Identify := FService.mtItensid.AsString;
    LFrame.IdProduto := FService.mtItensid_produto.AsString;
    LFrame.txtQtd.text := Fservice.mtItensquantidade.AsString;
    LFrame.txtDescricao.text := Fservice.mtItensnome_produto.AsString;
    LFrame.txtValor.text := formatFloat('R$ ,0.00', Fservice.mtItensTotal.AsCurrency);
    LFrame.Parent := vsbProdutos;
  finally
    vsbProdutos.EndUpdate;
  end;
  AtualizarTotal;
end;

function TFrmPedido.GetFrameProduto(const AIdProduto: String): TFramePedidoItem;
begin
  for var Ind := 0 to pred(vsbProdutos.content.controlsCount) do
  begin
    if not vsbProdutos.content.controls[ind].inheritsFrom(TFramePedidoItem) then
      continue;
    if TFramePedidoItem(vsbProdutos.content.controls[ind]).idProduto = AIdProduto then
      exit(TFramePedidoItem(vsbProdutos.content.controls[ind]));
  end;
  result := TFramePedidoItem.create(vsbProdutos);
  result.name := result.Classname + vsbProdutos.Content.controlsCount.ToString;
  result.OnDeleteItem := Self.OnDeleteItem;
end;

end.
