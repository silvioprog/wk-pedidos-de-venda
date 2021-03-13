unit Cliente;

interface

type
  TCliente = class
  private
    FID: UInt64;
    FNome: string;
    FCidade: string;
    FUF: string;
  public
    property ID: UInt64 read FID write FID;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
  end;

implementation

end.
