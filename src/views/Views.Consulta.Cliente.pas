unit Views.Consulta.Cliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Effects, FMX.Edit, FMX.Objects,
  FMX.Controls.Presentation, Services.Consulta.Cliente, Data.Db,
  System.generics.collections, Providers.Frames.List, Providers.Callback;

type
  TFrameConsultaCliente = class(TFrameBaseView)
    retHeaderCliente: TRectangle;
    btnVoltar: TButton;
    imgVoltar: TPath;
    LineSeparatorHeader: TLine;
    btnBuscaCliente: TButton;
    imgBuscaCliente: TPath;
    edtPesquisa: TEdit;
    ShadowEffect1: TShadowEffect;
    retContent: TRectangle;
    lytBuscaVazia: TLayout;
    txtBuscaVazia: TLabel;
    imgBuscaVazia: TPath;
    vsbClientes: TVertScrollBox;
    procedure btnBuscaClienteClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
  private
    FService: TServiceConsultaCliente;
    FListaFrames: TObjectList<TFrameList>;
    FCallBack: TCallBackDataSet;
    procedure DesignClientes;
    procedure OnSelectCleint(const AValue: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CallBack: TCallBackDataSet read FCallBack write FCallBack;
  end;

implementation

{$R *.fmx}

uses Providers.Aguarde;

{ TFrameConsutaCliente }

procedure TFrameConsultaCliente.btnBuscaClienteClick(Sender: TObject);
begin
  inherited;
  TAguarde.Aguardar(
    procedure
    begin
      FService.listarClientes(edtPesquisa.text);
      TThread.Synchronize(TThread.current,
        procedure
        begin
          DesignClientes;
        end
      )
    end
  );
end;

procedure TFrameConsultaCliente.btnVoltarClick(Sender: TObject);
begin
  inherited;
  self.owner.removecomponent(self);
  self.disposeOf;
end;

constructor TFrameConsultaCliente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FService := TServiceConsultaCliente.create(self);
  FListaFrames := TObjectList<TFrameList>.create;
end;

procedure TFrameConsultaCliente.DesignClientes;
begin
  lytBuscaVazia.Visible := FService.mtClientes.isEmpty;
  vsbClientes.Visible := not FService.mtClientes.isEmpty;
  if FService.mtClientes.isEmpty then
    exit;
  vsbClientes.beginUpdate;
  FService.mtClientes.first;
  try
    FListaFrames.clear;
    while not FService.mtClientes.eof do
    begin
      var LFrame := TFrameList.create(vsbClientes);
      LFrame.align := TAlignLayout.top;
      LFrame.identify := FService.mtClientesid.asString;
      LFrame.lblDescricao.text := FService.mtClientesnome.AsString;
      LFrame.Name := LFrame.classname + vsbClientes.content.controlsCount.toString;
      LFrame.parent := vsbClientes;
      LFrame.CallBack := OnSelectCleint;
      FListaFrames.add(LFrame);
      FService.mtClientes.next;
    end;
  finally
    vsbClientes.endUpdate;
  end;
end;

destructor TFrameConsultaCliente.Destroy;
begin
  FService.free;
  FListaFrames.free;
  inherited;
end;

procedure TFrameConsultaCliente.OnSelectCleint(const AValue: String);
begin
  FService.mtClientes.Locate('id', AValue, []);
  if assigned(FCallBack) then
    FCallBack(FService.mtClientes);
  self.owner.removecomponent(self);
  self.disposeOf;
end;

end.
