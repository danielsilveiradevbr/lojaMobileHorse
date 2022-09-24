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
    procedure btnEditarClick(Sender: TObject);
  private
    FIdentify: String;
    FIdProduto: String;
    FOnDeleteItem, FOnEditItem: TNotifyEvent;
  public
    property Identify: String read FIdentify write FIdentify;
    property IdProduto: String read FIdProduto write FIdProduto;
    property OnDeleteItem: TNotifyEvent read FOnDeleteItem write FOnDeleteItem;
    property OnEditItem: TNotifyEvent read FOnEditItem write FOnEditItem;
  end;

implementation

{$R *.fmx}

uses Providers.Dialogs.Input;

procedure TFramePedidoItem.btnEditarClick(Sender: TObject);
begin
  inherited;
  TDialogInput.show('Quantidade', txtQtd.text,
     procedure(const AResponse: string)
     begin
       if AResponse.trim.isEmpty or (strToIntDef(AResponse, 0) <= 0) then
         exit;
       txtQtd.text := AResponse;
       if assigned(FOnEditItem) then
         FOnEditItem(self);
     end
  );
  if Assigned(FOnEditItem) then
    FOnEditItem(self);
end;

procedure TFramePedidoItem.btnExcluirClick(Sender: TObject);
begin
  inherited;
  if Assigned(FOnDeleteItem) then
    FOnDeleteItem(self);
end;

end.
