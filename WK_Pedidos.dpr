program WK_Pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  frmPrincipal in 'Views\frmPrincipal.pas' {frPrincipal},
  frmCarregarPedido in 'Views\frmCarregarPedido.pas' {frCarregarPedido},
  QueryBuilder in 'DB\QueryBuilder.pas',
  Cliente in 'Models\Cliente.pas',
  Produto in 'Models\Produto.pas',
  Pedido in 'Models\Pedido.pas',
  ClienteStore in 'Stores\ClienteStore.pas',
  ProdutoStore in 'Stores\ProdutoStore.pas',
  PedidoStore in 'Stores\PedidoStore.pas',
  Utilidades in 'Utils\Utilidades.pas',
  Mensagens in 'Utils\Mensagens.pas';

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TfrPrincipal, frPrincipal);
  Application.Run;
end.
