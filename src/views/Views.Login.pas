unit Views.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects, FMX.Ani, FMX.Edit,
  FMXLabelEdit, FMX.Controls.Presentation, FMX.Effects, Services.Login;

type
  TfrmLogin = class(TFrameBaseView)
    retContent: TRectangle;
    retLogin: TRectangle;
    sdwLogin: TShadowEffect;
    lytLogo: TLayout;
    imgLogo: TPath;
    lytBemVindo: TLayout;
    lblBemVindo: TLabel;
    lytContentLogin: TLayout;
    btnEntrar: TButton;
    edtSenha: TLabelEdit;
    edtUsuario: TLabelEdit;
    lytFooter: TLayout;
    lblSolicitarAcesso: TLabel;
    lblRecuperSenha: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    procedure btnEntrarClick(Sender: TObject);
  private
    FService: TServiceLogin;
    procedure goToMenu;
  public
    Constructor Create(AOnwer: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.fmx}

uses Views.Menu, Providers.Aguarde, Providers.Dialogs.Error;


{ TfrmLogin }

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
begin
  inherited;
  TAguarde.Aguardar(
    procedure
    begin
      try
        FService.login(edtUsuario.text, edtSenha.text);
        sleep(2000);
        TThread.synchronize(TThread.current,
          procedure
          begin
            edtUsuario.SetValue(emptyStr);
            edtSenha.SetValue(emptyStr);
          end);
        goToMenu();
      except
        on E:exception do
           TThread.synchronize(TThread.current,
          procedure
          begin
            TDialogError.Show(E.message);
          end);
      end;
    end
  );
end;

procedure TfrmLogin.goToMenu();
var
  LFrmMenu: TFrmMenu;
begin
  LFrmMenu := TFrmMenu.create(lytContent);
  LFrmMenu.align := TAlignLayout.Contents;
  TLayout(self.owner).addObject(LFrmMenu);
end;

constructor TfrmLogin.create(AOnwer: TComponent);
begin
  inherited create(AOnwer);
  FService := TServiceLogin.create(self);
end;

destructor TfrmLogin.destroy;
begin
  freeAndNil(FService);
  inherited;
end;

end.
