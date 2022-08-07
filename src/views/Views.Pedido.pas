unit Views.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, FMX.TabControl, Services.Pedido, Data.Db;

type
  TFrmPedido = class(TFrameBaseView)
    retContent: TRectangle;
    TabControlPedido: TTabControl;
    TabItemConsulta: TTabItem;
    TabItemCadastro: TTabItem;
    retContentCadastro: TRectangle;
    retContentConsulta: TRectangle;
    btnBtnAdicionarVenda: TButton;
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
    txtCliente: TLabel;
    btnBuscaCliente: TButton;
    imgBuscaCliente: TPath;
    vsbProdutos: TVertScrollBox;
    lytTotalVenda: TLayout;
    txtTotal: TLabel;
    btnConfirmar: TButton;
    Line1: TLine;
    procedure btnBtnAdicionarVendaClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
  private
    FService: TServicePedido;
    procedure DesignPedidos;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoAfterShow; override;
  end;

implementation

{$R *.fmx}

uses Providers.Frames.Pedido, Providers.Aguarde;

{ TFrmPedido }

procedure TFrmPedido.btnBtnAdicionarVendaClick(Sender: TObject);
begin
  inherited;
  tabControlPedido.next;
end;

procedure TFrmPedido.btnVoltarClick(Sender: TObject);
begin
  inherited;
  TabControlPedido.ActiveTab := TabItemConsulta;
end;

constructor TFrmPedido.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FService := TServicePedido.Create(self);
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
          end);
    end
  );
end;

end.
