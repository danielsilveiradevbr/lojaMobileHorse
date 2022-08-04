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
  Views.Login in 'src\views\Views.Login.pas' {frmLogin: TFrame},
  Services.Base in 'src\services\Services.Base.pas' {ServiceBase: TDataModule},
  Services.Login in 'src\services\Services.Login.pas' {ServiceLogin: TDataModule},
  Views.Menu in 'src\views\Views.Menu.pas' {FrmMenu: TFrame},
  Views.Home in 'src\views\Views.Home.pas' {frmHome: TFrame},
  Views.Perfil in 'src\views\Views.Perfil.pas' {frmPerfil: TFrame},
  Providers.Models.User in 'src\providers\Models\Providers.Models.User.pas',
  Services.Perfil in 'src\services\Services.Perfil.pas' {ServicePerfil: TDataModule},
  Views.Pedido in 'src\views\Views.Pedido.pas' {FrmPedido: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
