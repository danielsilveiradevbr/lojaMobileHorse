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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
