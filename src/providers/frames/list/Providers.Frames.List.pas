unit Providers.Frames.List;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base, FMX.Objects, FMX.Controls.Presentation, Providers.Callback;

type
  TFrameList = class(TFrameBase)
    retContent: TRectangle;
    btnList: TButton;
    lblDescricao: TLabel;
    LineSeparatorHeader: TLine;
    procedure btnListClick(Sender: TObject);
  private
    FIdentify: String;
    FCallBack: TCallBackIdentify;
  public
    property Identify: String read FIdentify write FIdentify;
    property CallBack: TCallBackIdentify read FCallBack write FCallBack;
  end;

implementation

{$R *.fmx}


procedure TFrameList.btnListClick(Sender: TObject);
begin
  inherited;
  if assigned(FCallback) then
    FCallBack(FIdentify);
end;

end.
