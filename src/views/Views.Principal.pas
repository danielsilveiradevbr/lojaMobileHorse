unit Views.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMXLabelEdit, FMX.Layouts;

type
  TfrmPrincipal = class(TForm)
    StyleBook: TStyleBook;
    lylContent: TLayout;
    procedure FormActivate(Sender: TObject);
  private
    FActivate: boolean;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

uses Views.Login;

procedure TfrmPrincipal.FormActivate(Sender: TObject);
var
  LFrmLogin: TFrmLogin;
begin
  if FActivate then
    exit;
  LFrmLogin := TFrmLogin.create(lylContent);
  LFrmLogin.Align := TAlignLayout.Client;
  lylContent.AddObject(LFrmLogin);
  FActivate := true;
end;

end.
