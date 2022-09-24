unit Providers.Dialogs.Input;

interface

uses Providers.Callback, Providers.Dialogs.Views.Input, FMX.Types, FMX.forms;

type
  TDialogInput = class
  public
    class procedure Show(const APrompt, ADefaultText: String; const ACallback: TCallbackInput);
  end;

implementation

{ TDialogInput }

class procedure TDialogInput.Show(const APrompt, ADefaultText: String;
  const ACallback: TCallbackInput);
begin
  var LFrame := TfrmDialogInput.create(screen.activeForm);
  LFrame.edtInput.textPrompt := APrompt;
  LFrame.edtInput.SetValue(ADefaultText);
  LFrame.callback := ACallback;
  LFrame.Align := TAlignLayout.client;
  LFrame.parent := screen.activeForm;
  LFrame.edtInput.focus;
end;

end.
