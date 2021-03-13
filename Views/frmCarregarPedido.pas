unit frmCarregarPedido;

interface

uses
  System.RTLConsts,
  System.SysUtils,
  System.Classes,
  System.UITypes,
  FMX.Types,
  FMX.StdCtrls,
  FMX.Controls,
  FMX.Edit,
  FMX.Forms,
  FMX.Controls.Presentation,
  Utilidades;

type
  TfrCarregarPedido = class(TForm)
    pnTitulo: TPanel;
    lbTitulo: TLabel;
    pnDados: TPanel;
    edCodigoPedido: TEdit;
    btCarregar: TButton;
    btVoltar: TButton;
    procedure edCodigoPedidoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  public
    class procedure Execute(AProc: TProc<UInt64>);
  end;

implementation

{$R *.fmx}

procedure TfrCarregarPedido.FormCreate(Sender: TObject);
begin
  ActiveControl := edCodigoPedido;
end;

procedure TfrCarregarPedido.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult <> mrCancel then
    CanClose := not string.IsNullOrWhiteSpace(edCodigoPedido.Text);
end;

procedure TfrCarregarPedido.edCodigoPedidoKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  FiltraInteiros(KeyChar);
end;

class procedure TfrCarregarPedido.Execute(AProc: TProc<UInt64>);
begin
  if not Assigned(AProc) then
    raise EArgumentNilException.CreateFmt(SParamIsNil, ['AProc']);
  with Create(nil) do
  try
    if ShowModal = mrOk then
      AProc(edCodigoPedido.Text.ToInt64);
  finally
    Free;
  end;
end;

end.
