unit Providers.Dialogs.Views.Error;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation;

type
  TfrmDialogError = class(TFrameBaseView)
    Layout1: TLayout;
    retContent: TRectangle;
    retMessage: TRectangle;
    btOk: TButton;
    retHeader: TRectangle;
    txtMensagem: TText;
    Circle1: TCircle;
    imgError: TPath;
    procedure btOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TfrmDialogError.btOkClick(Sender: TObject);
begin
  inherited;
  Self.Visible := false;
  self.owner.RemoveComponent(self);
  self.DisposeOf;
end;

end.
