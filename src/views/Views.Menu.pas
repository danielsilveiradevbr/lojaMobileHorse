unit Views.Menu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, FMX.MultiView;

type
  TFrmMenu = class(TFrameBaseView)
    retHeader: TRectangle;
    btnMenu: TButton;
    imgMenu: TPath;
    lytActiveForm: TLayout;
    MultiView: TMultiView;
    retContentMultView: TRectangle;
    btnHome: TButton;
    imgHome: TPath;
    lblHome: TLabel;
    btnLogout: TButton;
    imgLogout: TPath;
    lblLogout: TLabel;
    btnPedido: TButton;
    imgPedido: TPath;
    lblPedido: TLabel;
    btnPerfil: TButton;
    imgPerfil: TPath;
    lblPerfil: TLabel;
    lineSeparator: TLine;
    procedure btnPerfilClick(Sender: TObject);
    procedure btnPedidoClick(Sender: TObject);
  private
    FActiveFrame: TFrameBaseView;
    procedure changeFrame<T: TFrameBaseView>;
    procedure GoHome;
    procedure GoPerfil;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.fmx}

uses Views.Home, Views.Perfil, Views.Pedido;

{ TFrmMenu }

procedure TFrmMenu.btnPedidoClick(Sender: TObject);
begin
  inherited;
  changeFrame<TFrmPedido>;
end;

procedure TFrmMenu.btnPerfilClick(Sender: TObject);
begin
  inherited;
  goPerfil;
end;

procedure TFrmMenu.changeFrame<T>;
begin
  if FActiveFrame <> nil then
  begin
    lytActiveForm.RemoveObject(FActiveFrame);
    FActiveFrame.DisposeOf;
  end;
  FActiveFrame := T.create(lytActiveForm);
  FActiveFrame.align := TAlignLayout.Contents;
  lytActiveForm.addObject(FActiveFrame);
  FActiveFrame.DoAfterShow;
  if MultiView.IsShowed then
    MultiView.HideMaster;
end;

constructor TFrmMenu.create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FActiveFrame := nil;
  goHome;
end;

destructor TFrmMenu.destroy;
begin
  if FActiveFrame <> nil then
  begin
    lytActiveForm.RemoveObject(FActiveFrame);
    FActiveFrame.DisposeOf;
  end;
  inherited;
end;

procedure TFrmMenu.GoHome;
begin
  changeFrame<TFrmHome>;
end;

procedure TFrmMenu.GoPerfil;
begin
  changeFrame<TFrmPerfil>;
end;

end.
