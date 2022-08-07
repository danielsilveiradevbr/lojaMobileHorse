unit Views.Consulta.Cliente;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Providers.Frames.Base.View, FMX.Layouts, FMX.Effects, FMX.Edit, FMX.Objects,
  FMX.Controls.Presentation, Services.Consulta.Cliente, Data.Db;

type
  TFrameConsutaCliente = class(TFrameBaseView)
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
  private
    FService: TServiceConsultaCliente;
    procedure DesignClientes;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.fmx}

uses Providers.Aguarde;

{ TFrameConsutaCliente }

procedure TFrameConsutaCliente.btnBuscaClienteClick(Sender: TObject);
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

constructor TFrameConsutaCliente.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FService := TServiceConsultaCliente.create(self);
end;

procedure TFrameConsutaCliente.DesignClientes;
begin
  lytBuscaVazia.Visible := FService.mtClientes.isEmpty;
  vsbClientes.Visible := not FService.mtClientes.isEmpty;
  if FService.mtClientes.isEmpty then
    exit;
  vsbClientes.beginUpdate;
  FService.mtClientes.first;
  try
    for var ind := Pred(vsbClientes.Content.controlsCount) downto 0 do
      vsbClientes.Controls.items[ind].disposeOf;
    while not FService.mtClientes.eof do
    begin
      FService.mtClientes.next;
    end;
  finally
    vsbClientes.endUpdate;
  end;
end;

destructor TFrameConsutaCliente.Destroy;
begin
  FService.free;
  inherited;
end;

end.
