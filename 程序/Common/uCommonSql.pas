unit uCommonSql;

interface

uses  uDllDBService,SysUtils,DBClient,Classes, XWComponentType, uDllSystemIntf, DB;

function  GetSysValue(const Name: string): string;
function  GetPeriod: Integer;

function GetVchTable(ADraft, AVchtype : Integer) : string;
function GetVchName(nVchType: string): string;
function CurrJxcPeriodToDate(var szStartDate, szEndDate: string): Boolean;

implementation

//以下为业务函数
function GetSysValue(const Name: string): string;
var
  Sql: string;
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  try
    Sql := 'IF NOT EXISTS(SELECT 1 FROM T_GBL_SysdataCW WHERE subname = ''' + Name + ''')' +
           '    INSERT INTO T_GBL_SysdataCW (subname, subvalue) VALUES (''' + Name + ''', '''')' +
           ' SELECT SubValue FROM T_GBL_SysdataCW WHERE subname = ''' + Name + '''';
    OpenSQL(Sql, cds);
    cds.First;
    if not cds.Eof then
      Result := cds.Fields[0].AsString
    else
      Result := '';
  finally
    FreeAndNil(cds);
  end;
end;

function GetPeriod: Integer;
begin
  Result := StrToInt(GetSysValue('Period'));
end;

function GetVchTable(ADraft, AVchtype : Integer) : string;
begin
  Result := '';
  if ADraft <> 2 then
  begin
    Result := 'bakdly';
    Exit;
  end;
  if AVchtype in [6,34] then
    Result := 'dlybuy'
  else if AVchtype in [11,26,45,140,141] then
    Result := 'dlysale'
  else if AVchtype in [9,14,25,30,50] then
    Result := 'dlyother'
  else if AVchtype in [150,151] then
    Result := 'bakdlyorder';
end;

function GetVchName(nVchType: string): string;
begin
  Result := GetValueFromSQL('Select name from T_GBL_Vchtype where VchType= ' + nVchType);
end;

function CurrJxcPeriodToDate(var szStartDate, szEndDate: string): Boolean;
var
  vParams: TParams;
begin
  Result := False;
  vParams := TParams.Create;
  try
    ExecuteProcByName('p_gbl_GetJxcPeriodOrDate;1',
      ['@lMode', '@lPeriod', '@szBeginDate', '@szEndDate'],
      [1, 0, '', ''], vParams);
    if vParams.Count > 0 then
    begin
      szStartDate := vParams.ParamByName('@szBeginDate').AsString;
      szEndDate := vParams.ParamByName('@szEndDate').AsString;
      Result := True;
    end;
  finally
    vParams.Free;
  end;
end;

end.
