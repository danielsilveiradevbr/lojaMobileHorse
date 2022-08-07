unit Providers.Frames.Base.View;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base, FMX.Layouts, Providers.Session;

type
  TFrameBaseView = class(TFrameBase)
    lytContent: TLayout;
  protected
    function Session: TSession;
  public
    procedure DoAfterShow; virtual;
  end;

implementation

{$R *.fmx}

{ TFrameBaseView }

procedure TFrameBaseView.DoAfterShow;
begin

end;

function TFrameBaseView.Session: TSession;
begin
  result := TSession.getInstance();
end;

end.
