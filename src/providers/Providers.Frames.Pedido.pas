unit Providers.Frames.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TFramePedido = class(TFrameBase)
    retDadosPedido: TRectangle;
    retDadosValores: TRectangle;
    retDadosCliente: TRectangle;
    imgLogo: TPath;
    Layout1: TLayout;
    lblNumero: TLabel;
    txtNumero: TLabel;
    btnEditar: TButton;
    imgEditar: TPath;
    btExcluir: TButton;
    Path1: TPath;
    Layout2: TLayout;
    imgCliente: TPath;
    txtNomeCliente: TLabel;
    Layout3: TLayout;
    imgValor: TPath;
    txtDataVenda: TLabel;
    Layout4: TLayout;
    Path2: TPath;
    txtValorVenda: TLabel;
    lineSeparator: TLine;
    procedure btExcluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    FOnDeletePedido, FOnEditPedido: TNotifyEvent;
    FIdentify: String;
  public
    property OnDeletePedido: TNotifyEvent read FOnDeletePedido write FOnDeletePedido;
    property OnEditPedido: TNotifyEvent read FOnEditPedido write FOnEditPedido;
    property Identify: String read FIdentify write FIdentify;
  end;

implementation

{$R *.fmx}

procedure TFramePedido.btExcluirClick(Sender: TObject);
begin
  inherited;
  if Assigned(FOnDeletePedido) then
    FOnDeletePedido(self);
end;

procedure TFramePedido.btnEditarClick(Sender: TObject);
begin
  inherited;
  if Assigned(FOnEditPedido) then
    FOnEditPedido(self);
end;

end.
