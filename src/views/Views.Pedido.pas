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
    retFooter: TRectangle;
    btnAnterior: TButton;
    imAnterior: TPath;
    btnProximo: TButton;
    imgProximo: TPath;
    lblPaginas: TLabel;
    procedure btnAdicionarVendaClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure btnBuscaClienteClick(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
  private
    FService: TServicePedido;
    FEInclusao: boolean;
    procedure DesignPedidos;
    procedure NovaVenda;
    procedure OnSelectCliente(const ADataSet: TDataSet);
    procedure OnSelectProduto(const ADataSet: TDataSet);
    function GetFrameProduto(const AIdProduto: String): TFramePedidoItem;
    procedure OnDeleteItem(ASender: TObject);
    procedure OnEditItem(ASender: TObject);
    procedure AtualizarTotal;
    procedure OnDeletePedido(ASender: TObject);
    procedure OnEditPedido(ASender: TObject);
    procedure DoAdicionarItem;
    procedure List(const AOffset: integer);
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

procedure TFrmPedido.btnAnteriorClick(Sender: TObject);
begin
  inherited;
  if (FService.offset > 0) then
    List(Fservice.Offset - 25);
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

procedure TFrmPedido.btnConfirmarClick(Sender: TObject);
begin
  inherited;
  TabControlPedido.Previous();
  List(FService.RecordCount - 25);
end;

procedure TFrmPedido.btnProximoClick(Sender: TObject);
begin
  inherited;
  if (FService.offset + 25) < Fservice.RecordCount then
    List(Fservice.Offset + 25);
end;

procedure TFrmPedido.btnVoltarClick(Sender: TObject);
begin
  inherited;
  if FService.mtCadastro.Active and (FService.mtCadastroid.asLargeInt > 0) and FEInclusao then
    FService.DeletarPedido(FService.mtCadastroid.AsString);
  TabControlPedido.Previous();
end;

constructor TFrmPedido.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FService := TServicePedido.Create(self);
  btnConfirmar.Visible := false;
  retFooter.visible := false;
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
        vsbPedidos.Content.Controls.items[ind].disposeOf;
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
      LFramePedido.OnEditPedido := self.OnEditPedido;
      FSErvice.mtPedidos.next;
    end;
    //retOffSet.Position.x := vsbPedidos.Content.controlsCount * 130 + retOffSet.Height;
    retFooter.Visible := FService.GetPaginas > 1;
    if retFooter.Visible then
    begin
      lblPaginas.text := format('%d de %d', [FService.GetPaginaCorrente, fService.GetPaginas]);
    end;
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
  List(0);
end;

procedure TFrmPedido.List(const AOffset: integer);
begin
  FService.Offset := AOffset;
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
  for var ind := Pred(vsbProdutos.Content.controlsCount) downto 0 do begin
    if vsbProdutos.Content.Controls.items[ind] is TFramePedidoItem then
      vsbProdutos.Content.Controls.items[ind].disposeOf;
  end;
  FEInclusao := true;
  FService.NovaVenda;
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
  lytNenhumaVenda.Visible := FService.mtPedidos.isEmpty;
  vsbPedidos.Visible := not FService.mtPedidos.isEmpty;
end;

procedure TFrmPedido.OnEditItem(ASender: TObject);
begin
  if not ASender.InheritsFrom(TFramePedidoItem) then
    exit;
  FService.AlterarQuantidadeItem(TFramePedidoItem(Asender).txtQtd.Text, TFramePedidoItem(Asender).Identify);
  AtualizarTotal;
end;

procedure TFrmPedido.OnEditPedido(ASender: TObject);
begin
  if not ASender.InheritsFrom(TFramePedido) then
    exit;
  FService.CarregarPedido(TFramePedido(ASender).Identify);
  txtNomeCliente.text := FService.mtCadastroid_cliente.ToString;
  FService.mtItens.first;
  vsbProdutos.BeginUpdate;
  try
    FEInclusao := false;
    for var ind := Pred(vsbProdutos.Content.controlsCount) downto 0 do begin
      if vsbProdutos.Content.Controls.items[ind] is TFramePedidoItem then
        vsbProdutos.Content.Controls.items[ind].disposeOf;
    end;
    //
    while not FService.mtItens.Eof do
    begin
      DoAdicionarItem;
      FService.mtItens.Next;
    end;
  finally
    vsbProdutos.EndUpdate;
  end;
  btnAdicionarProduto.Visible := true;
  btnConfirmar.Visible := true;
  AtualizarTotal;
  TabControlPedido.Next();
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
    DoAdicionarItem;
  finally
    vsbProdutos.EndUpdate;
  end;
  AtualizarTotal;
end;

procedure TFrmPedido.DoAdicionarItem;
begin
  var LFrame := GetFrameProduto(FService.mtItensid_produto.AsString);
  LFrame.Align := TAlignLayout.top;
  LFrame.Identify := FService.mtItensid.AsString;
  LFrame.IdProduto := FService.mtItensid_produto.AsString;
  LFrame.txtQtd.text := Fservice.mtItensquantidade.AsString;
  LFrame.txtDescricao.text := Fservice.mtItensnome_produto.AsString;
  LFrame.txtValor.text := formatFloat('R$ ,0.00', Fservice.mtItensTotal.AsCurrency);
  LFrame.Parent := vsbProdutos;
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
  result.OnEditItem := self.OnEditItem;
end;

end.
