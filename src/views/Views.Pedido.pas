unit Views.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, FMX.TabControl;

type
  TFrmPedido = class(TFrameBaseView)
    retContent: TRectangle;
    TabControlPedido: TTabControl;
    TabItemConsulta: TTabItem;
    TabItemCadastro: TTabItem;
    retContentCadastro: TRectangle;
    retContentConsulta: TRectangle;
    btnTrocarFoto: TButton;
    imgMenu: TPath;
    vsbPedidos: TVertScrollBox;
    lytNenhumaVenda: TLayout;
    lblTelefone: TLabel;
    Path1: TPath;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
