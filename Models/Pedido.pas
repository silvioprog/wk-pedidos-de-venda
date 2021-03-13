unit Pedido;

interface

uses
  Cliente,
  Produto;

type
  TPedido = class
  private
    FCliente: TCliente;
    FProdutos: TProdutos;
    FID: UInt64;
    function GetTotal: Double;
  public
    constructor Create;
    destructor Destroy; override;
    property ID: UInt64 read FID write FID;
    property Cliente: TCliente read FCliente;
    property Produtos: TProdutos read FProdutos;
    property Total: Double read GetTotal;
  end;

implementation

constructor TPedido.Create;
begin
  inherited Create;
  FCliente := TCliente.Create;
  FProdutos := TProdutos.Create;
end;

destructor TPedido.Destroy;
begin
  FProdutos.Free;
  FCliente.Free;
  inherited;
end;

function TPedido.GetTotal: Double;
begin
  Result := FProdutos.Total;
end;

end.
