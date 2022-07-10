program Mobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  Views.Principal in 'src\views\Views.Principal.pas' {frmPrincipal},
  Providers.Models.Token in 'src\providers\Models\Providers.Models.Token.pas',
  Providers.Request.intf in 'src\providers\request\Providers.Request.intf.pas',
  Providers.Request in 'src\providers\request\Providers.Request.pas',
  Providers.Session in 'src\providers\Providers.Session.pas',
  Providers.Frames.Base in 'src\providers\frames\Providers.Frames.Base.pas' {FrameBase: TFrame},
  Providers.Frames.Base.View in 'src\providers\frames\Providers.Frames.Base.View.pas' {FrameBaseView: TFrame},
  Views.Login in 'src\views\Views.Login.pas' {frmLogin: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
