unit PedidoStore;

interface

uses
  System.Classes,
  FireDAC.Stan.Param,
  QueryBuilder,
  Produto,
  Pedido;

type
  TPedidoStore = class(TComponent)
  private
    FQueryGravarPedido: TQuery;
    FQueryGravarProdutos: TQuery;
    FQueryCarregarPedido: TQuery;
    FQueryCarregarProdutos: TQuery;
    FQueryApagarPedido: TQuery;
    FPedido: TPedido;
    FCancelavel: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function PodeGravar: Boolean;
    function Gravar: Boolean;
    function Carregar(ACodigoPedido: UInt64): Boolean;
    function Apagar: Boolean;
    procedure Limpar;
    property Cancelavel: Boolean read FCancelavel;
    property Pedido: TPedido read FPedido;
  end;

implementation

const
  SQL_GRAVAR_PEDIDO = Concat(
    'INSERT INTO `wk_pedidos`.`pedidos` (`cliente_id`, `total`) ',
    'VALUES (:cliente_id, :total);'
  );
  SQL_GRAVAR_PEDIDO_PRODUTOS = Concat(
    'INSERT INTO `wk_pedidos`.`pedidos_produtos` (`pedido_id`, `produto_id`, `quantidade`, `preco`, `total`) ',
    'VALUES (:pedido_id, :produto_id, :quantidade, :preco, :total);'
  );
  SQL_CARREGAR_PEDIDO = Concat(
    'SELECT p.id, p.cliente_id, c.nome AS cliente_nome, p.total, p.emissao FROM wk_pedidos.pedidos p ',
    'LEFT JOIN wk_pedidos.clientes c ON c.id = p.cliente_id ',
    'WHERE p.id = :id'
  );
  SQL_CARREGAR_PEDIDO_PRODUTOS = Concat(
    'SELECT `pp`.`id`, `pp`.`pedido_id`, `pp`.`produto_id`, `p`.`descricao`, `pp`.`quantidade`, `pp`.`preco`, `pp`.`total` ',
    'FROM `wk_pedidos`.`pedidos_produtos` `pp` ',
    'LEFT JOIN `wk_pedidos`.`produtos` `p` ON `p`.`id` = `pp`.`produto_id` ',
    'WHERE `pp`.`pedido_id` = :pedido_id'
  );
  SQL_APAGAR_PEDIDO = Concat(
    'DELETE FROM `wk_pedidos`.`pedidos` ',
    'WHERE (`id` = :id);'
  );

constructor TPedidoStore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPedido := TPedido.Create;
  FQueryGravarPedido := TQueryBuilder.Create(SQL_GRAVAR_PEDIDO).Build(Self);
  FQueryGravarProdutos := TQueryBuilder.Create(SQL_GRAVAR_PEDIDO_PRODUTOS).Build(Self);
  FQueryCarregarPedido := TQueryBuilder.Create(SQL_CARREGAR_PEDIDO).Build(Self);
  FQueryCarregarProdutos := TQueryBuilder.Create(SQL_CARREGAR_PEDIDO_PRODUTOS).Build(Self);
  FQueryApagarPedido := TQueryBuilder.Create(SQL_APAGAR_PEDIDO).Build(Self);
end;

destructor TPedidoStore.Destroy;
begin
  FPedido.Free;
  inherited Destroy;
end;

function TPedidoStore.PodeGravar: Boolean;
begin
  Result := (FPedido.Produtos.Count > 0) and (FPedido.Cliente.ID > 0);
end;

function TPedidoStore.Gravar: Boolean;
begin
  FQueryGravarPedido.Start;
  try
    FQueryGravarPedido.ParamByName('cliente_id').AsLargeInt := FPedido.Cliente.ID;
    FQueryGravarPedido.ParamByName('total').AsFloat := FPedido.Total;
    FQueryGravarPedido.ExecSQL;
    FPedido.ID := FQueryGravarPedido.LastID;
    for var VProduto in FPedido.Produtos do
    begin
      FQueryGravarProdutos.ParamByName('pedido_id').AsLargeInt := FPedido.ID;
      FQueryGravarProdutos.ParamByName('produto_id').AsLargeInt := VProduto.ID;
      FQueryGravarProdutos.ParamByName('quantidade').AsLargeInt := VProduto.Quantidade;
      FQueryGravarProdutos.ParamByName('preco').AsFloat := VProduto.Preco;
      FQueryGravarProdutos.ParamByName('total').AsFloat := VProduto.Total;
      FQueryGravarProdutos.ExecSQL;
    end;
    Result := FQueryGravarPedido.RowsAffected > 0;
    FQueryGravarPedido.Done;
    FCancelavel := False;
  except
    FQueryGravarPedido.Undo;
    raise;
  end;
end;

function TPedidoStore.Carregar(ACodigoPedido: UInt64): Boolean;
begin
  FQueryCarregarPedido.Start;
  try
    // pedido
    FQueryCarregarPedido.ParamByName('id').AsLongword := ACodigoPedido;
    FQueryCarregarPedido.Open;
    FPedido.ID := FQueryCarregarPedido.FieldByName('id').AsLargeInt;
    FPedido.Cliente.ID := FQueryCarregarPedido.FieldByName('cliente_id').AsLargeInt;
    FPedido.Cliente.Nome := FQueryCarregarPedido.FieldByName('cliente_nome').AsString;
    // produtos
    FPedido.Produtos.Clear;
    FQueryCarregarProdutos.ParamByName('pedido_id').AsLargeInt := FPedido.ID;
    FQueryCarregarProdutos.Open;
    while not FQueryCarregarProdutos.Eof do
    begin
      var VProduto := TProduto.Create;
      VProduto.ID := FQueryCarregarProdutos.FieldByName('id').AsLargeInt;
      VProduto.Descricao := FQueryCarregarProdutos.FieldByName('descricao').AsString;
      VProduto.Quantidade := FQueryCarregarProdutos.FieldByName('quantidade').AsInteger;
      VProduto.Preco := FQueryCarregarProdutos.FieldByName('preco').AsFloat;
      FPedido.Produtos.Add(VProduto);
      FQueryCarregarProdutos.Next;
    end;
    Result := FQueryCarregarPedido.RecordCount > 0;
    FCancelavel := Result;
    FQueryCarregarProdutos.Close;
    FQueryCarregarPedido.Done;
  except
    FQueryCarregarPedido.Undo;
    raise;
  end;
end;

function TPedidoStore.Apagar: Boolean;
begin
  FQueryApagarPedido.Start;
  try
    FQueryApagarPedido.ParamByName('id').AsLongword := FPedido.ID;
    FQueryApagarPedido.ExecSQL;
    Result := FQueryApagarPedido.RowsAffected > 0;
    FQueryApagarPedido.Done;
    FCancelavel := False;
  except
    FQueryApagarPedido.Undo;
    raise;
  end;
end;

procedure TPedidoStore.Limpar;
begin
  FPedido.ID := 0;
  FPedido.Produtos.Clear;
  FCancelavel := False;
end;

end.
