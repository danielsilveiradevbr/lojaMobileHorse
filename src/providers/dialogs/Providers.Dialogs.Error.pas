unit Providers.Dialogs.Error;

interface

type
  TDialogError = class
    public
     class procedure Show(const AMensagem: String);
  end;

implementation

{ TDialogError }

uses Providers.Dialogs.Views.Error, FMX.Forms, FMX.Types;

class procedure TDialogError.Show(const AMensagem: String);
begin
  var LFrame := TfrmDialogError.create(screen.activeForm);
  LFrame.Align := TAlignLayout.client;
  LFrame.parent := screen.activeForm;
  LFrame.txtMensagem.text := AMensagem;
end;

end.
