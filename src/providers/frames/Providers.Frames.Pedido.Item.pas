unit Providers.Frames.Pedido.Item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base, FMX.Objects, FMX.Controls.Presentation;

type
  TFramePedidoItem = class(TFrameBase)
    retContent: TRectangle;
    LineSeparatorHeader: TLine;
    txtQtd: TLabel;
    txtDescricao: TLabel;
    txtValor: TLabel;
    btnEditar: TButton;
    imgEditar: TPath;
    btnExcluir: TButton;
    imgExcluir: TPath;
  private
    FIdentify: String;
    FIdProduto: String;
  public
    property Identify: String read FIdentify write FIdentify;
    property IdProduto: String read FIdProduto write FIdProduto;
  end;

implementation

{$R *.fmx}

end.
