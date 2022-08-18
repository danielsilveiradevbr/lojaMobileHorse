unit Providers.Frames.List.Produto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.List, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TFrameListProduto = class(TFrameList)
    Layout1: TLayout;
    txtEstoque: TLabel;
    txtValor: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
