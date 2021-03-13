unit ProdutoStore;

interface

uses
  System.Classes,
  FireDAC.Stan.Param,
  Produto,
  QueryBuilder;

type
  TProdutoStore = class(TComponent)
  private
    FQueryCarregar: TQuery;
    FProduto: TProduto;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CarregarPorCodigo(AProduto: TProduto): Boolean;
    property Produto: TProduto read FProduto;
  end;

implementation

const
  SQL_CARREGAR_PRODUTO_POR_CODIGO = Concat(
    'SELECT * FROM wk_pedidos.produtos ',
    'WHERE id = :id'
  );

constructor TProdutoStore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProduto := TProduto.Create;
  FQueryCarregar := TQueryBuilder.Create(SQL_CARREGAR_PRODUTO_POR_CODIGO).Build(Self);
end;

destructor TProdutoStore.Destroy;
begin
  FProduto.Free;
  inherited Destroy;
end;

function TProdutoStore.CarregarPorCodigo(AProduto: TProduto): Boolean;
begin
  FQueryCarregar.Start;
  try
    FQueryCarregar.ParamByName('id').AsLargeInt := AProduto.ID;
    FQueryCarregar.Open;
    AProduto.Descricao := FQueryCarregar.FieldByName('descricao').AsString;
    AProduto.Preco := FQueryCarregar.FieldByName('preco').AsFloat;
    Result := FQueryCarregar.RecordCount > 0;
    FQueryCarregar.Done;
  except
    FQueryCarregar.Undo;
    raise;
  end;
end;

end.
