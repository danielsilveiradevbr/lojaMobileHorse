unit Views.Login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects, FMX.Ani, FMX.Edit,
  FMXLabelEdit, FMX.Controls.Presentation, FMX.Effects;

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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
