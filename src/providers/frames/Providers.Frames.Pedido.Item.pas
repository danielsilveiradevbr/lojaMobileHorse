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
    procedure btnExcluirClick(Sender: TObject);
  private
    FIdentify: String;
    FIdProduto: String;
    FOnDeleteItem: TNotifyEvent;
  public
    property Identify: String read FIdentify write FIdentify;
    property IdProduto: String read FIdProduto write FIdProduto;
    property OnDeleteItem: TNotifyEvent read FOnDeleteItem write FOnDeleteItem;
  end;

implementation

{$R *.fmx}

procedure TFramePedidoItem.btnExcluirClick(Sender: TObject);
begin
  inherited;
  if Assigned(FOnDeleteItem) then
    FOnDeleteItem(self);
end;

end.
