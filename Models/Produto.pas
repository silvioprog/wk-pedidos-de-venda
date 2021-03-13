unit Produto;

interface

uses
  System.Generics.Collections;

type
  TProduto = class
  private
    FID: UInt64;
    FDescricao: string;
    FPreco: Double;
    FQuantidade: Integer;
    function GetTotal: Double;
  public
    property ID: UInt64 read FID write FID;
    property Descricao: string read FDescricao write FDescricao;
    property Preco: Double read FPreco write FPreco;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property Total: Double read GetTotal;
  end;

  TProdutos = class(TObjectList<TProduto>)
  private
    function GetTotal: Double;
  public
    property Total: Double read GetTotal;
  end;

implementation

{ TProduto }

function TProduto.GetTotal: Double;
begin
  Result := FQuantidade * FPreco;
end;

{ TProdutos }

function TProdutos.GetTotal: Double;
begin
  Result := 0;
  for var VProduto in Self do
    Result := Result + VProduto.Total;
end;

end.
