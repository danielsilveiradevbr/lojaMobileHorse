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
    OpenDialog: TOpenDialog;
    procedure btnGaleriaClick(Sender: TObject);
  private
    FService: TServicePerfil;
    procedure carregarFotoUsuario();
    procedure OnChangeProfileImage(const ABitmap: TBitmap);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

{ TfrmPerfil }

procedure TfrmPerfil.btnGaleriaClick(Sender: TObject);
begin
  inherited;
{$IFDEF MSWINDOWS}
  if openDialog.execute then
    OnChangeProfileImage(TBitmap.CreateFromFile(OpenDialog.FileName));
{$ENDIF}
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

procedure TfrmPerfil.OnChangeProfileImage(const ABitmap: TBitmap);
begin
  var LFoto := TMemoryStream.Create;
  try
    ABitmap.SaveToStream(LFoto);
    LFoto.Position := 0;
    if LFoto.size > 0 then
      imgPerfil.fill.bitmap.bitmap.loadFromStream(LFoto);
    LFoto.Position := 0;
    FService.UploadFoto(LFoto);
  finally
    Lfoto.Free;
  end;
  MultiView.HideMaster;
end;

end.
