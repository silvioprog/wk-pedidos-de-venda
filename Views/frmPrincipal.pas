unit frmPrincipal;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Math,
  System.Rtti,
  System.Actions,
  FMX.Types,
  FMX.Objects,
  FMX.Graphics,
  FMX.ActnList,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls,
  FMX.Grid.Style,
  FMX.Grid,
  FMX.ScrollBox,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  Mensagens,
  Utilidades,
  Cliente,
  Produto,
  ClienteStore,
  ProdutoStore,
  PedidoStore,
  frmCarregarPedido;

type
  TfrPrincipal = class(TForm)
    StyleBook: TStyleBook;
    ActionList: TActionList;
    acCarregarPedido: TAction;
    gbCliente: TGroupBox;
    edCodigoCliente: TEdit;
    gbProduto: TGroupBox;
    pnCabecalho: TPanel;
    imLogo: TImage;
    pnTitulo: TPanel;
    lbTitulo: TLabel;
    acGravarPedido: TAction;
    gbProdutos: TGroupBox;
    gbPedido: TGroupBox;
    edCodigoProduto: TEdit;
    edQuantidadeProdutos: TEdit;
    edPrecoProduto: TEdit;
    grProdutos: TGrid;
    lbTotalPedido: TLabel;
    btGravarPedido: TButton;
    colCodigoProduto: TIntegerColumn;
    colDescricaoProduto: TStringColumn;
    colQuantidadeProdutos: TIntegerColumn;
    colPrecoProduto: TCurrencyColumn;
    colPrecoTotalProdutos: TCurrencyColumn;
    btAdicionarProduto: TButton;
    acConfirmarProduto: TAction;
    acApagarProduto: TAction;
    lbDescricaoProduto: TLabel;
    lbNomeCliente: TLabel;
    btCarregarPedido: TButton;
    acEditarProduto: TAction;
    btCancelarPedido: TButton;
    acCancelarPedido: TAction;
    procedure acCarregarPedidoExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure acConfirmarProdutoExecute(Sender: TObject);
    procedure acGravarPedidoExecute(Sender: TObject);
    procedure acApagarProdutoExecute(Sender: TObject);
    procedure grProdutosGetValue(Sender: TObject; const ACol, ARow: Integer;
      var Value: TValue);
    procedure edCodigoClienteKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure grProdutosSelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure acEditarProdutoExecute(Sender: TObject);
    procedure grProdutosCellDblClick(const Column: TColumn; const Row: Integer);
    procedure edPrecoProdutoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edCodigoClienteValidate(Sender: TObject; var Text: string);
    procedure edCodigoProdutoValidate(Sender: TObject; var Text: string);
    procedure acCancelarPedidoExecute(Sender: TObject);
    procedure edCodigoClienteValidating(Sender: TObject; var Text: string);
    procedure grProdutosCellClick(const Column: TColumn; const Row: Integer);
  private
    FPedidoStore: TPedidoStore;
    FClienteStore: TClienteStore;
    FProdutoStore: TProdutoStore;
    FProdutoSelecionado: TProduto;
  public
    procedure LimparCamposCliente;
    procedure LimparCamposProduto;
    procedure LimparTudo;
    procedure AtualizarJanela;
  end;

var
  frPrincipal: TfrPrincipal;

implementation

{$R *.fmx}

procedure TfrPrincipal.FormCreate(Sender: TObject);
begin
  FClienteStore := TClienteStore.Create(Self);
  FProdutoStore := TProdutoStore.Create(Self);
  FPedidoStore := TPedidoStore.Create(Self);
  ActiveControl := edCodigoCliente;
end;

procedure TfrPrincipal.edCodigoClienteKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  FiltraInteiros(KeyChar);
end;

procedure TfrPrincipal.edPrecoProdutoKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  FiltraFlutuantes(edPrecoProduto.Text, KeyChar);
end;

procedure TfrPrincipal.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  acCarregarPedido.Visible := string.IsNullOrWhiteSpace(edCodigoCliente.Text) and
    (not FPedidoStore.Cancelavel);
  acCancelarPedido.Visible := FPedidoStore.Cancelavel;
  acGravarPedido.Enabled := (not acCarregarPedido.Visible) and
    FPedidoStore.PodeGravar and (not FPedidoStore.Cancelavel);
  acApagarProduto.Enabled := (grProdutos.Selected > -1) and
    (not FPedidoStore.Cancelavel);
  acEditarProduto.Enabled := acApagarProduto.Enabled and
    (ActiveControl = grProdutos);
  acConfirmarProduto.Enabled := not (
    string.IsNullOrWhiteSpace(edCodigoProduto.Text) or
    string.IsNullOrWhiteSpace(edQuantidadeProdutos.Text) or
    string.IsNullOrWhiteSpace(edPrecoProduto.Text));
  gbProduto.Enabled := not FPedidoStore.Cancelavel;
end;

procedure TfrPrincipal.grProdutosCellClick(const Column: TColumn;
  const Row: Integer);
begin
  LimparCamposProduto;
end;

procedure TfrPrincipal.grProdutosCellDblClick(const Column: TColumn;
  const Row: Integer);
begin
  acEditarProduto.Execute;
end;

procedure TfrPrincipal.grProdutosGetValue(Sender: TObject; const ACol,
  ARow: Integer; var Value: TValue);
begin
  if (ARow < 0) or (not Assigned(FPedidoStore)) or
    (FPedidoStore.Pedido.Produtos.Count = 0) then
    Exit;
  var VProduto := FPedidoStore.Pedido.Produtos[ARow];
  case ACol of
    0: Value := VProduto.ID;
    1: Value := VProduto.Descricao;
    2: Value := VProduto.Quantidade;
    3: Value := VProduto.Preco;
    4: Value := VProduto.Total;
  end;
end;

procedure TfrPrincipal.grProdutosSelectCell(Sender: TObject; const ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow > -1) and (FPedidoStore.Pedido.Produtos.Count > 0) then
    FProdutoSelecionado := FPedidoStore.Pedido.Produtos[ARow]
  else
    FProdutoSelecionado := nil;
end;

procedure TfrPrincipal.LimparCamposCliente;
begin
  edCodigoCliente.Text := '';
  lbNomeCliente.Text := '';
end;

procedure TfrPrincipal.LimparCamposProduto;
begin
  edCodigoProduto.Text := '';
  lbDescricaoProduto.Text := '';
  edQuantidadeProdutos.Text := '';
  edPrecoProduto.Text := '';
end;

procedure TfrPrincipal.LimparTudo;
begin
  LimparCamposCliente;
  LimparCamposProduto;
  FPedidoStore.Limpar;
  AtualizarJanela;
end;

procedure TfrPrincipal.AtualizarJanela;
begin
  grProdutos.RowCount := 0;
  grProdutos.RowCount := FPedidoStore.Pedido.Produtos.Count;
  grProdutos.Selected := -1;
  lbTotalPedido.Text := FPedidoStore.Pedido.Total.ToString(ffCurrency, 10, 2);
end;

procedure TfrPrincipal.acConfirmarProdutoExecute(Sender: TObject);
begin
  var VProduto := FProdutoSelecionado;
  if not Assigned(VProduto) then
  begin
    VProduto := TProduto.Create;
    FPedidoStore.Pedido.Produtos.Add(VProduto);
  end;
  VProduto.ID := edCodigoProduto.Text.ToInt64;
  VProduto.Descricao := FProdutoStore.Produto.Descricao;
  VProduto.Quantidade := edQuantidadeProdutos.Text.ToInteger;
  VProduto.Preco := edPrecoProduto.Text.ToDouble;
  LimparCamposProduto;
  AtualizarJanela;
  ActiveControl := edCodigoProduto;
end;

procedure TfrPrincipal.acEditarProdutoExecute(Sender: TObject);
begin
  if not Assigned(FProdutoSelecionado) then Exit;
  edCodigoProduto.Text := FProdutoSelecionado.ID.ToString;
  lbDescricaoProduto.Text := FProdutoSelecionado.Descricao;
  edQuantidadeProdutos.Text := FProdutoSelecionado.Quantidade.ToString;
  edPrecoProduto.Text := FProdutoSelecionado.Preco.ToString;
  ActiveControl := edQuantidadeProdutos;
end;

procedure TfrPrincipal.edCodigoClienteValidate(Sender: TObject;
  var Text: string);
begin
  if Text.IsEmpty then
  begin
    LimparCamposCliente;
    Exit;
  end;
  edCodigoCliente.SelectAll;
  FPedidoStore.Pedido.Cliente.ID := edCodigoCliente.Text.ToInt64;
  if FClienteStore.CarregarPorCodigo(FPedidoStore.Pedido.Cliente) then
    lbNomeCliente.Text := FormataCodigoNome(FPedidoStore.Pedido.Cliente.ID,
      FPedidoStore.Pedido.Cliente.Nome)
  else
    lbNomeCliente.Text := SMsgClienteNaoEncontrado;
end;

procedure TfrPrincipal.edCodigoClienteValidating(Sender: TObject;
  var Text: string);
begin
  if (not Text.IsEmpty) and FPedidoStore.Cancelavel then
    LimparTudo;
end;

procedure TfrPrincipal.edCodigoProdutoValidate(Sender: TObject;
  var Text: string);
begin
  if Text.IsEmpty then
  begin
    LimparCamposProduto;
    Exit;
  end;
  edCodigoProduto.SelectAll;
  FProdutoStore.Produto.ID := edCodigoProduto.Text.ToInt64;
  if FProdutoStore.CarregarPorCodigo(FProdutoStore.Produto) then
  begin
    lbDescricaoProduto.Text := FormataCodigoNome(FProdutoStore.Produto.ID,
      FProdutoStore.Produto.Descricao);
    edQuantidadeProdutos.Text :=
      Max(FProdutoStore.Produto.Quantidade, 1).ToString;
    edPrecoProduto.Text := FProdutoStore.Produto.Preco.ToString;
  end
  else
    lbDescricaoProduto.Text := SMsgProdutoNaoEncontrado;
end;

procedure TfrPrincipal.acApagarProdutoExecute(Sender: TObject);
begin
  Confirmar(SMsgApagarProdutoFmt, [FProdutoSelecionado.Descricao.QuotedString],
    procedure
    begin
      FPedidoStore.Pedido.Produtos.Remove(FProdutoSelecionado);
      LimparCamposProduto;
      AtualizarJanela;
      FProdutoSelecionado := nil;
    end);
end;

procedure TfrPrincipal.acGravarPedidoExecute(Sender: TObject);
begin
  if not FPedidoStore.Gravar then Exit;
  var VMensagem := Format(SMsgPedidoGravado, [FPedidoStore.Pedido.ID]);
  LimparTudo;
  ShowMessage(VMensagem);
  ActiveControl := edCodigoCliente;
end;

procedure TfrPrincipal.acCarregarPedidoExecute(Sender: TObject);
begin
  LimparTudo;
  TfrCarregarPedido.Execute(
    procedure(ACodigoPedido: UInt64)
    begin
      if not FPedidoStore.Carregar(ACodigoPedido) then
      begin
        ShowMessageFmt(SMsgPedidoNaoEncontrado, [ACodigoPedido]);
        Exit;
      end;
      lbNomeCliente.Text := Format(SMsgPedidoClienteFmt, [
        FPedidoStore.Pedido.ID,
        FormataCodigoNome(
          FPedidoStore.Pedido.Cliente.ID,
          FPedidoStore.Pedido.Cliente.Nome)]
        );
      AtualizarJanela;
    end);
end;

procedure TfrPrincipal.acCancelarPedidoExecute(Sender: TObject);
begin
  Confirmar(SMsgApagarPedidoFmt, [FPedidoStore.Pedido.ID],
    procedure
    begin
      var VMensagem := Format(IfThen(FPedidoStore.Apagar,
        SMsgPedidoApagado, SMsgPedidoNaoApagado), [FPedidoStore.Pedido.ID]);
      LimparTudo;
      ShowMessage(VMensagem);
    end,
    procedure
    begin
      LimparTudo;
    end);
end;

end.
