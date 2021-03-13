unit ClienteStore;

interface

uses
  System.Classes,
  FireDAC.Stan.Param,
  Cliente,
  QueryBuilder;

type
  TClienteStore = class(TComponent)
  private
    FQueryCarregar: TQuery;
  public
    constructor Create(AOwner: TComponent); override;
    function CarregarPorCodigo(ACliente: TCliente): Boolean;
  end;

implementation

const
  SQL_CARREGAR_CLIENTE_POR_CODIGO = Concat(
    'SELECT * FROM wk_pedidos.clientes ',
    'WHERE id = :id'
  );

constructor TClienteStore.Create(AOwner: TComponent);
begin
  inherited;
  FQueryCarregar := TQueryBuilder.Create(SQL_CARREGAR_CLIENTE_POR_CODIGO).Build(Self);
end;

function TClienteStore.CarregarPorCodigo(ACliente: TCliente): Boolean;
begin
  FQueryCarregar.Start;
  try
    FQueryCarregar.ParamByName('id').AsLargeInt := ACliente.ID;
    FQueryCarregar.Open;
    ACliente.Nome := FQueryCarregar.FieldByName('nome').AsString;
    ACliente.Cidade := FQueryCarregar.FieldByName('cidade').AsString;
    ACliente.UF := FQueryCarregar.FieldByName('uf').AsString;
    Result := FQueryCarregar.RecordCount > 0;
    FQueryCarregar.Done;
  except
    FQueryCarregar.Undo;
    raise;
  end;
end;

end.
