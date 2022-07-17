unit Views.Perfil;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, Services.Perfil, FMX.MultiView;

type
  TfrmPerfil = class(TFrameBaseView)
    retContent: TRectangle;
    LytHeader: TLayout;
    lytNome: TLayout;
    lytTelefone: TLayout;
    lblUsuario: TLabel;
    txtUsuario: TLabel;
    txtTelefone: TLabel;
    lblTelefone: TLabel;
    imgPerfil: TCircle;
    txtNome: TLabel;
    txtSexo: TLabel;
    imgMenu: TPath;
    MultiView: TMultiView;
    retContentMultView: TRectangle;
    btnCamera: TButton;
    imgCamera: TPath;
    lblCâmera: TLabel;
    btnGaleria: TButton;
    imgGaleria: TPath;
    lblGaleria: TLabel;
    btnTrocarFoto: TButton;
    procedure btnTrocarFotoClick(Sender: TObject);
  private
    FService: TServicePerfil;
    procedure carregarFotoUsuario();
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

{ TfrmPerfil }

procedure TfrmPerfil.btnTrocarFotoClick(Sender: TObject);
begin
  inherited;
  ShowMessage('op');
end;

procedure TfrmPerfil.carregarFotoUsuario;
begin
  var LFoto := FService.DonwloadFoto;
  try
    if LFoto.size > 0 then
      imgPerfil.fill.bitmap.bitmap.loadFromStream(LFoto);
  finally
    LFoto.free;
  end;
end;

constructor TfrmPerfil.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  txtNome.text := Session.User.Nome;
  txtTelefone.text := Session.User.telefone;
  txtUsuario.text := Session.User.login;
  txtSexo.text := Session.User.GetSexoAsString;
  FService := TServicePerfil.create(self);
  MultiView.Height := 100;
  carregarFotoUsuario;
end;

end.
