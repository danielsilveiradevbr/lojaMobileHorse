unit Providers.Aguarde;

interface

uses System.SysUtils, System.Classes, Providers.Aguarde.Frame, FMX.Forms,
     FMX.Types;

type

  TAguarde = class
  public
    class procedure Aguardar(const AProc: TProc);
  end;

implementation

{ TAguarde }

class procedure TAguarde.Aguardar(const AProc: TProc);
var
  LFrame: TFrameAguarde;
begin
  LFrame := TFrameAguarde.create(Screen.activeForm);
  LFrame.align := TAlignLayout.client;
  LFrame.parent := Screen.activeForm;
  Screen.activeForm.addObject(LFrame);
  LFrame.bringToFront;
  TThread.CreateAnonymousThread(
    procedure
    begin
      try
        AProc;
      finally
        TThread.synchronize(TThread.current,
          procedure
          begin
            LFrame.owner.removeComponent(LFrame);
            LFrame.disposeOf;
          end);
      end;
    end).start;
end;

end.
