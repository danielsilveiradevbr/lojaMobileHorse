unit Views.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, FMX.TabControl, Services.Pedido, Data.Db,
  Views.Consulta.Produto;

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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoAfterShow; override;
  end;

implementation

{$R *.fmx}

uses Providers.Frames.Pedido, Providers.Aguarde, Views.Consulta.Cliente;

{ TFrmPedido }

procedure TFrmPedido.btnAdicionarProdutoClick(Sender: TObject);
begin
  inherited;
  var LFrame := TFrameConsultaProduto.create(self);
  LFrame.align := TAlignLayout.Contents;
 // LFrame.callBack := OnSelectProduto;
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
    for var ind := Pred(vsbPedidos.Content.controlsCount) downto 0 do
      vsbPedidos.Controls.items[ind].disposeOf;
    FSErvice.mtPedidos.first;
    while not FSErvice.mtPedidos.eof do
    begin
      LFramePedido := TFramePedido.create(vsbPedidos);
      LFramePedido.name := LFramePedido.className + '_' + FService.mtPedidosid.asString;
      LFramePedido.align := TAlignLayout.top;
      LFramePedido.txtNumero.text := FService.mtPedidosid.asString;
      LFramePedido.txtDataVenda.text := formatDateTime('dd/mm/yyyy', FService.mtPedidosData.asDateTime);
 //     LFramePedido.txtValorVenda.text := formatFloat('R$ ,0.00;', FService.mtPedidostotal.asFloat);
      LFramePedido.txtNomeCliente.text := FService.mtPedidosnome_cliente.asString;
      LFramePedido.parent := vsbPedidos;
      FSErvice.mtPedidos.next;
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

procedure TFrmPedido.OnSelectCliente(const ADataSet: TDataSet);
begin
  FService.InicializatVenda(ADataSet.FieldByName('ID').AsString);
  txtNomeCliente.text := ADataset.fieldByName('nome').asString;
  btnAdicionarProduto.Visible := true;
  btnConfirmar.Visible := true;
end;

procedure TFrmPedido.OnSelectProduto(const ADataSet: TDataSet);
begin

end;

end.
