unit Utilidades;

interface

uses
  System.RTLConsts,
  System.SysUtils,
  System.Character,
  System.UITypes,
  FMX.Dialogs,
  FMX.DialogService,
  Mensagens;

function FormataCodigoNome(ACodigo: Int64; const ANome: string): string;

procedure FiltraInteiros(var ADigito: Char);

procedure FiltraFlutuantes(const ADigitos: string; var ADigito: Char);

procedure Confirmar(const ATexto: string; const AArgs: array of const;
  const ASimProc: TProc; const ANaoProc: TProc = nil);

implementation

function FormataCodigoNome(ACodigo: Int64; const ANome: string): string;
begin
  Result := Format(SMsgCodigoNomeFmt, [ACodigo, ANome]);
end;

procedure FiltraInteiros(var ADigito: Char);
begin
  if not ADigito.IsDigit then
    ADigito := #0;
end;

procedure FiltraFlutuantes(const ADigitos: string; var ADigito: Char);
begin
  var D: Double;
  if (not ADigitos.IsEmpty) and (not Double.TryParse(ADigitos + ADigito, D)) then
    ADigito := #0;
end;

procedure Confirmar(const ATexto: string; const AArgs: array of const;
  const ASimProc: TProc; const ANaoProc: TProc = nil);
begin
  if not Assigned(ASimProc) then
    raise EArgumentNilException.CreateFmt(SParamIsNil, ['ASimProc']);
  TDialogService.MessageDialog(Format(ATexto, AArgs),
    TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
        ASimProc()
      else if Assigned(ANaoProc) then
        ANaoProc();
    end);
end;

initialization
  FormatSettings.DecimalSeparator := ',';
  FormatSettings.ThousandSeparator := '.';

end.
