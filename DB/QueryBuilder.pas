unit QueryBuilder;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.FMXUI.Wait,
  FireDAC.Comp.Client,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TTransaction = class(TFDTransaction)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TQuery = class(TFDQuery)
  public
    constructor Create(AOwner: TComponent); override;
    procedure Start;
    procedure Done;
    procedure Undo;
    function GetLastIDByName(const AName: string): UInt64;
    function GetLastID: UInt64;
    property LastID: UInt64 read GetLastID;
  end;

  TQueryBuilder = record
  private
    FSQL: string;
  public
    constructor Create(const ASQL: string);
    function Build(AOwner: TComponent): TQuery;
  end;

implementation

var
  GConnection: TFDConnection;

function GetConnection: TFDConnection;
begin
  if GConnection.Params.Count > 0 then
    Exit(GConnection);
  GConnection.Params.AddPair('DriverID', 'MySQL');
  GConnection.Params.AddPair('Database', 'wk_pedidos');
  GConnection.Params.AddPair('User_Name', 'root');
  GConnection.Params.AddPair('Password', 'root');
  GConnection.Params.AddPair('CharacterSet', 'latin1');
  GConnection.LoginPrompt := False;
  Result := GConnection;
end;

{ TTransaction }

constructor TTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Options.Isolation := xiReadCommitted;
end;

{ TQuery }

constructor TQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Transaction := TFDTransaction.Create(Self);
  FetchOptions.Unidirectional := True;
  ResourceOptions.DirectExecute := True;
  ResourceOptions.StoreItems := [siData];
  UpdateOptions.EnableDelete := False;
  UpdateOptions.EnableInsert := False;
  UpdateOptions.EnableUpdate := False;
  UpdateOptions.RequestLive := False;
  UpdateOptions.RefreshDelete := False;
end;

function TQuery.GetLastIDByName(const AName: string): UInt64;
begin
  Result := GConnection.GetLastAutoGenValue(AName);
end;

procedure TQuery.Start;
begin
  Transaction.StartTransaction;
end;

procedure TQuery.Done;
begin
  Transaction.Commit;
  if Active then
    Close;
end;

procedure TQuery.Undo;
begin
  Transaction.Rollback;
end;

function TQuery.GetLastID: UInt64;
begin
  Result := GetLastIDByName('id');
end;

{ TQueryBuilder }

constructor TQueryBuilder.Create(const ASQL: string);
begin
  FSQL := ASQL;
end;

function TQueryBuilder.Build(AOwner: TComponent): TQuery;
begin
  Result := TQuery.Create(AOwner);
  Result.Connection := GetConnection;
  Result.Transaction.Connection := Result.Connection;
  Result.SQL.Text := FSQL;
end;

initialization
  GConnection := TFDConnection.Create(nil);

finalization
  FreeAndNil(GConnection);

end.
