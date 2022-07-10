program Mobile;

uses
  System.StartUpCopy,
  FMX.Forms,
  Views.Principal in 'src\views\Views.Principal.pas' {frmPrincipal},
  Providers.Models.Token in 'src\providers\Models\Providers.Models.Token.pas',
  Providers.Request.intf in 'src\providers\request\Providers.Request.intf.pas',
  Providers.Request in 'src\providers\request\Providers.Request.pas',
  Providers.Session in 'src\providers\Providers.Session.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
