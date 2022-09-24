unit Providers.Dialogs.Views.Input;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Controls.Presentation, FMX.Edit,
  FMXLabelEdit, FMX.Objects, Providers.Callback;

type
  TfrmDialogInput = class(TFrameBaseView)
    retContent: TRectangle;
    retMessage: TRectangle;
    edtInput: TLabelEdit;
    btOk: TButton;
    btnCancelar: TButton;
    procedure btOkClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FCallback: TCallbackInput;
  public
    property Callback: TCallbackInput read FCallBack write FCallback;
  end;

implementation

{$R *.fmx}

procedure TfrmDialogInput.btnCancelarClick(Sender: TObject);
begin
  inherited;
  self.visible := false;
  self.owner.removeComponent(self);
  self.DisposeOf;
end;

procedure TfrmDialogInput.btOkClick(Sender: TObject);
begin
  inherited;
  self.visible := false;
  if assigned(FCallback) then
    FCallback(edtInput.text);
  self.owner.removeComponent(self);
  self.DisposeOf;
end;

end.
