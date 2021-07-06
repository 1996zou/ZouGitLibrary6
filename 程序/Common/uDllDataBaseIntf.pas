unit uDllDataBaseIntf;

interface

uses SysUtils, Windows, ShellAPI, Forms, DB, DBClient, Variants, uDllDBService, uDataStructure,
     XWComponentType, xwCalcFieldsDefine;

//����Ϊҵ����
function GetSysValue(const Name: string): string;
procedure SetSysValue(const Name, Value: string);

function GetSysCon(const AConId: Integer): Boolean;
procedure SetSysCon(const AConId: Integer; const AValue: Boolean);

function GetCurrentYear: string;
//���ϵͳ����
function CheckSysCon(nSysCon: Integer): Boolean;

function CheckLimitNo(FunctionNo: Integer): string;
procedure GetFunctionDetailLimitNo(FunctionNo: Integer; var DetailLimit: array of Boolean);

//ȡ�õ��ݱ��
function ProcessVchNumber(nWork, nVchType: Integer; const szDate, szNumberIn: string; var szNumber: string): Boolean;
//ȡ�õ��ݱ��
function GetVchNumber(nVchType: Integer; const szDate: string; var szNumber: string): Boolean;
//��鵥�ݱ���Ƿ��ظ���������ظ��򷵻�һ���º���
function CheckVchNumber(nVchcode, nVchtype: Integer; const szNumberIn: string; var szNumber: string): Boolean;
//��ǰ���ݱ�ż�������һ
function IncVchNumber(nVchtype: Integer; const szDate: string): Boolean;

function GetMessage(nMsgNo: Integer): string;
procedure GetAFieldValueFromTable(var RValue: Variant; aszTable, aszField: string; aszFilter: string = '');

function CheckFunction(FunctionName: string): Boolean;
function GetLimit(nFunction: Integer): Boolean;
function CheckLimit(FunctionName: string): string;
//��鵥�ݵ�������ϸȨ��
function CheckVchDetailRight(Vchtype: Integer; DetailRight: string): Boolean;
//����Ƿ��д�ӡ��ϸȨ��
function CheckPrintNo(FunctionNo: Integer): Boolean;
//����Ƿ���ĳģ���ĳ��ϸȨ��
function CheckListNoRight(FunctionNo: Integer; DetailNo: TCMBtnType): Boolean;

//��ѯ�Ƿ��н����ϸȨ�ޣ�������ģ������ or FunctionNo
function CheckViewCost(FFunctionName: string): Boolean;
function CheckViewCostNo(FunctionNo: Integer): Boolean;

function CheckModifyTotalNo(FunctionNo: Integer): Boolean;
//�жϵ��ݵ���ϸȨ��
function CheckBillRelation(nVchtype, nRelation: Integer): Boolean;
function CheckDetailRight(aFunctionNo: Integer; aLimitNo: Integer): Boolean;

//ȡ�ý������Ӧ��Ŀ
function GetATypeID(ATypeIDNo: Integer): string; overload;
function GetATypeID(AProjectNameEn: string): string; overload;

// ���ݻ�����Ϣ��IDȡ��ȫ��
function GetBaseFullNameByID(ABasicType: TCMBasicType; szTypeID: string; IsCostLoad: Boolean = False): string;
//����TypeIDȡ����ļ۸���Ϣ
function GetPtypePrice(asPtypeID: string; asPrice: string): Double;

//�Ƿ�ͻ�
function GetIsClient(const szBTypeID: string): Integer;
//���м�����
procedure RunCalc;

//����Ƿ���������
function CheckHasProduceVch(AVchcode: Integer; szDate: string; var szPTypeID: string): Boolean;
//�����Ƿ��ڱ�����
function CheckDateInCurYear(szDate: string): Boolean;

//�������ں�
function DateToPeriod(szDate: string): Integer;
//�ں������ڷ�Χ
function PeriodToDate(lPeriod: Integer; var szStartDate, szEndDate: string): Boolean;
//�ں���ʼ����
function PeriodToStartDate(lPeriod: Integer): string;
//�ں����������
function PeriodToEndDate(lPeriod: Integer): string;
//��ǰ�ں�
function GetPeriod: Integer;
//��ǰ�������ں�
function GetJxcPeriod: Integer;
//��ǰ�ں������ڷ�Χ
function CurrPeriodToDate(var szStartDate, szEndDate: string): Boolean;
//��ǰ�������ں������ڷ�Χ
function CurrJxcPeriodToDate(var szStartDate, szEndDate: string): Boolean;
//��ǰ�ں���ʼ����
function CurrPeriodToStartDate: string;
//��ǰ�������ں���ʼ����
function CurrJxcPeriodToStartDate: string;
//��ǰ�ں����������
function CurrPeriodToEndDate: string;
//��ǰ�ں����������
function CurrJxcPeriodToEndDate: string;
//��ǰ�ڼ������
function GetPeriodYear(lPeriod: Integer): Integer;
//�����Ƿ��ڱ�����ڼ���
function CheckDateInCurPeriod(szDate: string): Boolean;
//�����Ƿ���ĳһ������ڼ���
function CheckDateInPeriod(szDate: string; lPeriod: Integer): Boolean;

// ȡ��������λ��Ԥ���ۼ�����
function GetBTypePrePriceConfig(szBTypeID: string): Integer;

function GetAtypePropertyFirstLeafID(nPropertyID: Integer): string;
//��ȡ��ƶ�Ӧ��Ŀ
function GetSubjectA(ProjectName: string): string;
//�жϿ�ĿID�Ƿ������ĸ����szPropertyID 1�ֽ�2���С�
function CheckSetAtype(szAtypeID, szPropertyID: string): Boolean;
//�õ���Ŀ���������
function GetSubProperty(szAtypeID: string): Integer;
// ��Params���鸳ֵ����aParams2��ֵ����aParams1��
procedure CopyParamsToParams(var aParams1, aParams2 : Variant);
function AccountExportString(szInput1, szInput2, FSign: String; Bit: Integer = 4): String;
function GetUserDefined(pTypeID:string; var custom1: string; var custom2: string):Boolean;
function IsInit: Boolean;
//�Ƿ������ĩ״̬
function IsEndState: Boolean;
//�жϳ����Ƿ����ڳ� True = �ڳ�  False = �ѿ���
function IsRPInit: Boolean;
//��ͳһ���������Զ����ݵ��ļ��� Add By Guiyun 2007-08-16
function GenerateBackupFileName(const AccountName: string): string;
//function GetTradeReportPath: string;
    //�ж��Ƿ��ǲ��԰汾
function TestVersion: Boolean;

implementation

uses uDllComm, {uTransformFunc, uBasalMethod, }uDllMessageIntf, uDllSystemIntf;

//����Ϊҵ����
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

procedure SetSysValue(const Name, Value: string);
var
  Sql: string;
begin
  Sql := 'IF NOT EXISTS(SELECT 1 FROM T_GBL_SysDataCW WHERE subname = ''' + Name + ''') ' +
         '  INSERT INTO T_GBL_SysDataCW(subname) VALUES(''' + Name + ''') ' +
         '  if (''' + Name + ''' = ''iniover'') and (''' + Value + ''' = ''0'') ' +
         '  BEGIN ' +
         '    IF EXISTS(SELECT 1 FROM T_CW_Dly) ' +
         '      RETURN ' +
         '  END ' +
         ' UPDATE T_GBL_SysDataCW SET SubValue = ''' + Value + ''' WHERE SubName = ''' + Name + '''';
  ExecuteSQL(Sql);
end;

function GetSysCon(const AConId: Integer): Boolean;
const
  cSelectCon = 'if exists(Select 1 From dbo.T_Gbl_SysCon Where ConId = %d and Stats = 1) Select 1 Else Select 0';
begin
  Result := GetValueFromSQL(Format(cSelectCon, [AConId])) = 1;
end;

procedure SetSysCon(const AConId: Integer; const AValue: Boolean);
const
  cUpdateCon = 'Update dbo.T_Gbl_SysCon SET Stats = %1:d Where ConId = %0:d';
begin
  ExecuteSQL(Format(cUpdateCon, [AConId, Ord(AValue)]));
end;

//ȡ�õ�ǰ���
function GetCurrentYear: string;
begin
  Result := GetSysValue('CurrentYear');
end;

function CheckSysCon(nSysCon: Integer): Boolean;
begin
  Result := uDllSystemIntf.CheckSysCon(nSysCon);
end;

function CheckLimitNo(FunctionNo: Integer): string;
var
  cds, cdsNo: TClientDataSet;
  szSQL, szDetial: string;
  i: Integer;
  ch: string;
  arr: array[Ord(Low(TCMBtnType))..Ord(High(TCMBtnType))] of string;
begin
  Result := '';
  if GetCurrIsManager then
  begin
    for i := Ord(Low(TCMBtnType)) to Ord(High(TCMBtnType)) do
      Result := Result + '1';
    Exit;
  end
  else
    for i := Ord(Low(TCMBtnType)) to Ord(High(TCMBtnType)) do
      arr[i] := '1';

  cds := TClientDataSet.Create(nil);
  cdsNo := TClientDataSet.Create(nil);

  szSQL := 'select LIMITPOWER from t_gbl_userpower  as u ,UserToGroup as p ';
  szSQL := szSQL + ' Where u.LIMITNO = ' + IntToStr(FunctionNo) + ' and u.GroupID = p.GroupId and p.UserID = ';
  szSQl := szSQL + char(39) + GetCurrentOperatorId + char(39);
  OpenSQL(szSQL, cds);

  szSQl := 'select Detailno from t_gbl_PowerRelation where LimitNo = ' + IntToStr(FunctionNo) + '';

  OpenSQL(szSQL, cdsNo);
  //Add by lkang 2010-08-04 16:32:24 �Ƚ���ϸȨ�����0
  while not cdsNo.Eof do
  begin
    arr[cdsNo.FieldByName('DetailNo').asInteger] := '0';
    cdsNo.Next;
  end;
  //end
  while not cds.Eof do
  begin
    szDetial := cds.FieldByName('LimitPower').AsString;
    cdsNo.First;
    while not cdsNo.Eof do
    begin
      ch := copy(szDetial, cdsNo.FieldByName('DetailNo').asInteger, 1);
      if ch = '1' then
        arr[cdsNo.FieldByName('DetailNo').asInteger] := '1';
      cdsNo.next;
    end;
    cds.next;
  end;

  for i := Ord(Low(TCMBtnType)) + 1 to Ord(High(TCMBtnType)) do
    Result := Result + arr[i];

  cds.Close;
  cds.Free;
  cdsNo.Close;
  cdsNo.Free;
end;

procedure GetFunctionDetailLimitNo(FunctionNo: Integer; var DetailLimit: array of Boolean);
var
  cds: TClientDataSet;
  szSQL: string;
begin

  cds := TClientDataSet.Create(nil);
  szSQL := 'select tp.detailno from t_gbl_functionlist t1 inner join T_GBL_PowerRelation tp on t1.functionno = tp.limitno ' +
    '  where t1.functionno = ' + IntToStr(FunctionNo) + '';
  OpenSQL(szSQL, cds);

  if not cds.IsEmpty then
    while not cds.Eof do
    begin
      DetailLimit[cds.FieldByName('DetailNo').AsInteger] := True;
      cds.Next;
    end;

  cds.Close;
  cds.Free;
end;

function ProcessVchNumber(nWork, nVchType: Integer; const szDate, szNumberIn: string; var szNumber: string): Boolean;
var
  szTemp: WideString;
  OutParam: TParams;
begin
  OutParam := TParams.Create(nil);
  try
    Result := ExecuteProcByName('p_jxc_GetVchNumber', ['@nWork', '@nVchType', '@szDate', '@szNumberIn', '@szNumber'],
        [nWork, nVchtype, szDate, szNumberIn, szTemp], OutParam) = 0;
    szNumber := OutParam.ParamByName('@szNumber').Value;
  finally
    FreeAndNil(OutParam);
  end;
end;

//ȡ�õ��ݱ��
function GetVchNumber(nVchType: Integer; const szDate: string; var szNumber: string): Boolean;
var
  szNumberIn: WideString;
begin
  szNumberIn := szNumber;
  Result := ProcessVchNumber(ckGet, nVchType, szDate, szNumberIn, szNumber);
end;

//��鵥�ݱ���Ƿ��ظ���������ظ��򷵻�һ���º���
function CheckVchNumber(nVchcode, nVchtype: Integer; const szNumberIn: string; var szNumber: string): Boolean;
begin
  Result := ProcessVchNumber(ckCheck, nVchtype, IntToStr(nVchcode), szNumberIn, szNumber);
end;

//��ǰ���ݱ�ż�������һ
function IncVchNumber(nVchtype: Integer; const szDate: string): Boolean;
var
  szTemp: string;
begin
  Result := ProcessVchNumber(ckSet, nVchtype, szDate, '', szTemp);
end;

function GetMessage(nMsgNo: Integer): string;
var
  Sql: string;
begin
  Sql := 'Select DisPlayName From T_Gbl_MessageList Where MessageNo = %d';
  Result := GetValueFromSQL(Format(Sql, [nMsgNo]));
end;

procedure GetAFieldValueFromTable(var RValue: Variant; aszTable, aszField: string; aszFilter: string = '');
var
  szSQL: string;
  cdsOpenSQL: TClientDataSet;
begin
  cdsOpenSQL := TClientDataSet.Create(nil);
  try
    szSQL := ' SELECT %s AS RValue FROM %s ';
    if aszFilter <> '' then
      szSQL := szSQL + ' WHERE ' + aszFilter;
    if (aszTable <> '') and (aszField <> '') then
      szSQL := Format(szSQL, [aszField, aszTable])
    else
      Exit;

    try
      OpenSQL(szSQL, cdsOpenSQL);
    except
      RValue := -1;
    end;

    RValue := cdsOpenSQL.FieldByName('RValue').AsVariant;
  finally
    FreeAndNil(cdsOpenSQL);
  end;
end;

function CheckFunction(FunctionName: string): Boolean;
var
  Sql: string;
begin
  Sql := 'if exists(select 1 from T_Gbl_UserPower t inner Join T_Gbl_FunctionList f On t.LimitNo = f.FunctionNo ' +
         '         inner join UserToGroup u On t.GroupId = u.GroupId ' +
         '         Where f.Version in (''e'', ''em'') and f.OnClick = ''%s'' and u.UserId = ''%s'') ' +
         '     Select 1 ' +
         ' Else ' +
         '     Select 0 ';
  Result := GetValueFromSQL(Format(Sql, [FunctionName, GetCurrentOperatorId])) = 1;
end;

function GetLimit(nFunction: Integer): Boolean;
var
  SQL: String;
begin
  //������ܾ�ֱ�ӷ�����
  if GetCurrIsManager then
  begin
    Result := True;
    Exit;
  end;

  SQL := 'if exists(Select 1 From T_Gbl_UserPower t inner Join UserToGroup u On t.GroupId = u.GroupId Where t.LimitNo = %d and u.UserId = ''%s'') ' +
         '   Select 1 ' +
         ' Else ' +
         '   Select 0';

  Result := GetValueFromSQL(Format(SQL, [nFunction, GetCurrentOperatorId])) = 1;
end;

function CheckLimit(FunctionName: string): string;
var
  cds, cdsNo: TClientDataSet;
  szSQL, szDetial: string;
  i: Integer;
  ch: string;
  arr: array[Ord(Low(TCMBtnType))..Ord(High(TCMBtnType))] of string;
begin
  Result := '';
  if GetCurrIsManager then
  begin
    for i := Ord(Low(TCMBtnType)) to Ord(High(TCMBtnType)) do
      Result := Result + '1';
    Exit;
  end
  else
    for i := Ord(Low(TCMBtnType)) to Ord(High(TCMBtnType)) do
      arr[i] := '0';

  cds := TClientDataSet.Create(nil);
  cdsNo := TClientDataSet.Create(nil);
  try
    szSQL := 'select LimitPower from t_gbl_functionlist,t_gbl_userpower ' +
      ' where FunctionNo = LimitNo and EtypeID=''' + GetCurrentOperatorId +
      ''' and SonNum=0 and Caption = ''' + FunctionName + '''';
    szSQL := 'select LIMITPOWER from  t_gbl_functionlist  as  f,t_gbl_userpower  as u ,UserToGroup as p ';
    szSQL := szSQL + '  where f.FunctionNo = u.LIMITNO and u.GroupID = p.GroupId and p.UserID = ';
    szSQl := szSQL + char(39) + GetCurrentOperatorId + char(39) + ' And f.Caption=' + char(39) + FunctionName + char(39);
    szSQL := szSQL + ' And IsInitFun = 0';//Add By ���� 2008-08-08
    OpenSQL(szSQL, cds);

    szSQl := 'select Detailno from  t_gbl_functionlist  as  f,t_gbl_PowerRelation  as p  where  ';
    szSQL := szSQL + 'f.FunctionNo=p.LIMITNO  and ';
    szSQL := szSQL + '  f.Caption=' + char(39) + FunctionName + char(39);

    OpenSQL(szSQL, cdsNo);
    while not cds.Eof do
    begin
      szDetial := cds.FieldByName('LimitPower').AsString;
      cdsNo.First;
      while not cdsNo.Eof do
      begin
        ch := copy(szDetial, cdsNo.FieldByName('DetailNo').asInteger, 1);
        if ch = '1' then
          arr[cdsNo.FieldByName('DetailNo').asInteger] := '1';
        cdsNo.next;
      end;
      cds.next;
    end;

    for i := Ord(Low(TCMBtnType)) + 1 to Ord(High(TCMBtnType)) do
      Result := Result + arr[i];
  finally
    cds.Close;
    cds.Free;
    cdsNo.Close;
    cdsNo.Free;
  end;
end;

//��鵥�ݵ�������ϸȨ��
function CheckVchDetailRight(Vchtype: Integer;DetailRight: string): Boolean;
var
  nFunctionNo: integer;
  FLimitList: string;
begin
  Result := False;
  nFunctionNo := 0;
  //1���õ���Ӧ��functionno
  if Vchtype = 150 then
    nFunctionNo := 1089
  else if Vchtype = 34 then
    nFunctionNo := 1091
  else if Vchtype = 6 then
    nFunctionNo := 1092
  else if Vchtype = 161 then
    nFunctionNo := 1668
  else if Vchtype = 66 then
    nFunctionNo := 1093
  else if Vchtype = 151 then
    nFunctionNo := 1152
  else if Vchtype = 11 then
    nFunctionNo := 1155
  else if Vchtype = 45 then
    nFunctionNo := 1156
  else if Vchtype = 4 then
    nFunctionNo := 1157
  else if Vchtype = 21 then
    nFunctionNo := 1168
  else if Vchtype = 16 then
    nFunctionNo := 1170
  else if Vchtype = 57 then
    nFunctionNo := 1169
  else if Vchtype = 9 then
    nFunctionNo := 1171
  else if Vchtype = 14 then
    nFunctionNo := 1172
  else if Vchtype = 140 then
    nFunctionNo := 1618
  else if Vchtype = 141 then
    nFunctionNo := 1619
  else if Vchtype = 36 then
    nFunctionNo := 1620
  else if Vchtype = 93 then
    nFunctionNo := 1621
  else if Vchtype = 77 then
    nFunctionNo := 1622
  else if Vchtype = 25 then
    nFunctionNo := 1164
  else if Vchtype = 26 then
    nFunctionNo := 1165
  else if Vchtype = 30 then
    nFunctionNo := 1166
  else if Vchtype = 50 then
    nFunctionNo := 1453
  else if Vchtype = 37 then
    nFunctionNo := 1966   //     1965	1993		�������õ�	 ->1966
  else if Vchtype = 38 then
    nFunctionNo := 1967     //    1966	1993		�������÷��䵥 ->1967
  else if Vchtype = 46 then
    nFunctionNo := 1980
  else if Vchtype = 47 then
    nFunctionNo := 1981
  else if Vchtype = 48 then
    nFunctionNo := 1982
  else if Vchtype = 83 then
    nFunctionNo := 1999;  // 1974	1996		����������	-> 1999

  //2���õ���ϸȨ��
  FLimitList := CheckLimitNo(nFunctionNo);

  //3�����û��ģ��Ȩ�ޣ���û��������ϸȨ��
  if not GetLimit(nFunctionNo) then
    Result := False
  else
  begin
    //4���ж���ϸȨ��
    DetailRight := trim(DetailRight);

    if DetailRight = '��ӡ' then
      Result := FLimitList[Ord(gbtPrint)] = '1'
    else if DetailRight = 'ɾ��' then
      Result := FLimitList[Ord(gbtDelete)] = '1'
    else if DetailRight = '����' then
      Result := FLimitList[Ord(gbtSave)] = '1'
    else if DetailRight = '���' then
      Result := FLimitList[Ord(gbtAuditing)] = '1'
    else if DetailRight = '�����' then
      Result := FLimitList[Ord(gbtUnAuditing)] = '1'
    else if DetailRight = '�޸ĵ���' then
      Result := FLimitList[Ord(gbtModifyBill)] = '1'
    else if DetailRight = '�޸Ĳݸ�' then
      Result := FLimitList[Ord(gbtModifyDraft)] = '1'
    else if DetailRight = '���' then
      Result := FLimitList[Ord(gbtViewCost)] = '1';
  end;
end;

function CheckPrintNo(FunctionNo: Integer): Boolean;
var
  FLimitList: string;
begin
  FLimitList := CheckLimitNo(FunctionNo);

  Result := FLimitList[Ord(gbtPrint)] = '1';
end;

function CheckListNoRight(FunctionNo: Integer; DetailNo: TCMBtnType): Boolean;
var
  FLimitList: string;
begin
  FLimitList := CheckLimitNo(FunctionNo);

  Result := FLimitList[Ord(DetailNo)] = '1';
end;

//��ѯ�Ƿ��в鿴�����ϸȨ��
function CheckViewCost(FFunctionName: string): Boolean;
var
  FLimitList: string;
begin
  FLimitList := CheckLimit(FFunctionName);

  Result := FLimitList[Ord(gbtViewCost)] = '1';
end;

function CheckViewCostNo(FunctionNo: Integer): Boolean;
var
  FLimitList: string;
begin
  FLimitList := CheckLimitNo(FunctionNo);

  Result := FLimitList[Ord(gbtViewCost)] = '1';
end;

function CheckModifyTotalNo(FunctionNo: Integer): Boolean;
var
  FLimitList: string;
begin
  FLimitList := CheckLimitNo(FunctionNo);

  Result := FLimitList[Ord(gbtModifyTotal)] = '1';
end;

//�жϵ��ݵ���ϸȨ��
function CheckBillRelation(nVchtype, nRelation: Integer): Boolean;
const
  szFunNo: array[0..55] of Integer = (1157,1092,1171,1155,1172,1170,1168,1164,1165,1096,1097,1166,1098,1091,
  1620,1156,1453,1463,1169,1093,1622,1621,1618,1619,1089,1152,1668,
  1868,1869,1870,1871,1872,1873,1920,1921,1912,1913,1914,1915,1916,1917,1918,1919,1966,1967,1980,1981,1982,1999,
  2008,2009,2021,2022,2071,2072,2073);

  szVchType: array[0..55] of Integer = (4,6,9,11,14,16,21,25,26,27,28,30,31,34,
  36,45,50,51,57,66,77,93,140,141,150,151,161,
  170,171,172,173,174,175,176,177,180,181,182,183,184,185,186,187,37,38,46,47,48,83,144,145,142,143,190,192,191);

var
  i: Integer;
begin

  Result := False;

  for i := Low(szVchtype) to High(szVchtype) do
  begin
    if nVchtype = szVchType[i] then
      Break;
  end;

  if nVchtype < 1000 then
  begin
    if CheckDetailRight(szFunNo[i], nRelation) then
      Result := True;
  end;
end;

function CheckDetailRight(aFunctionNo: Integer; aLimitNo: Integer): Boolean;
var
  sLimit: string;
  sOperator: string;
  sSQl: string;
  cds: TClientDataSet;
begin
  result := False;
  //step1:ȡ�õ�ǰ����Ա��typeid
  sOperator := GetCurrentOperatorId;

  //step2:����aFunctionNo�Ͳ���Ա��Ӧ��Ȩ���飬�õ���ϸȨ��
  cds := TClientDataSet.Create(nil);
  try
    sSQl := 'select isnull(a.limitpower,'''') as limitpower from t_gbl_userpower a,[group] b where a.[groupid] = b.[id]';
    sSQL := sSQL + ' and limitno = ' + inttostr(aFunctionNo);
    sSQL := sSQL + ' and a.[groupid] in (select GroupId from usertogroup where userid = ''' + GetCurrentOperatorId + ''')';
    OpenSQL(sSQL, cds);
    if cds.IsEmpty then
      Exit;

    with cds do
    begin
      First;
      sLimit := FieldByName('limitpower').asstring;
    end;

    if Trim(sLimit) = '' then
      Exit;
    if sLimit[aLimitNo] = '0' then
      Result := False
    else
      Result := True;
  finally
    FreeAndNil(cds);
  end;
end;

function GetATypeID(ATypeIDNo: Integer): string;
var
  Sql: string;
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  try
    Sql := 'SELECT atypeid FROM T_CW_SubjectContrast WHERE subjectid = %d';
    OpenSQL(Format(Sql, [ATypeIDNo]), cds);
    cds.First;
    if not cds.Eof then
      Result := cds.Fields[0].AsString
    else
      Result := '';
  finally
    FreeAndNil(cds);
  end;
end;

function GetATypeID(AProjectNameEn: string): string;
const
  cSql = 'SELECT atypeID FROM T_CW_SubjectContrast WHERE ProjectNameEn = ''%s''';
begin
  Result := GetValueFromSQL(Format(cSql, [AProjectNameEn]));
end;

function GetBaseFullNameByID(ABasicType: TCMBasicType; szTypeID: string; IsCostLoad: Boolean = False): string;
var
  SQL, Pusercode, szTableName, szParamName: String;
  cds: TClientDataSet;
begin
  Result := szTypeID;
  if Trim(szTypeID) = '' then Exit;
  if ABasicType in [CMbtAtype, CMbtPtype, CMbtBtype, CMbtStype, CMbtCType, CMbtOType,
      CMbtEtype, CMbtKtype, CMbtDtype, CMbtArea, CMbtOperator, CMbtKType2, CMbtEType2,
      CMbtDWtype, CMbtGPType, CMbtZType, CMbtCBObject, CMbtATypeCW, CMbtCustom1, CMbtCustom2] then
  begin
    szTableName := '';
    szParamName := GetGlobalDataType(ABasicType).ParamName;

    if (UpperCase(szParamName) = '@SZKTYPEID') and (szTypeID = '9999900001') then
      Result  := '����ҵ��ֿ�'
    else
    begin
      szTableName := GetBaseTableName(ABasicType);
      if Trim(szTableName) <> '' then
      begin
        cds := TClientDataSet.Create(nil);
        try
          if ABasicType = CMbtOType then
            SQL := 'Select IsNull(Memo, ''%s'') From DifaType Where Atype = ''%s'''
          else
            SQL := 'Select IsNull(FullName, ''%s'') From ' + szTableName + ' Where TypeId = ''%s''';
          OpenSQL(Format(SQL, [szTypeID, szTypeID]), cds);
          if not cds.Eof then
            Result := cds.Fields[0].AsString;
        finally
          FreeAndNil(cds);
        end;
      end
      else
        Result := '';
    end;

    if (Result <> '') and (IsCostLoad) then
    begin
      SQL := 'Select IsNull(UserCode, '''') as UserCode From Ptype Where Typeid = ''' + szTypeID + '''';
      Pusercode := GetValueFromSQL(SQL);
      if Trim(Pusercode) <> '' then
        Result := Trim(Pusercode) + '��' + Trim(Result);
    end;

    if Result = '' then Result := Trim(szTypeID);
  end;
end;

function GetIsClient(const szBTypeID: string): Integer;
var
  cds: TClientDataSet;
begin
  Result := -1;
  cds := TClientDataSet.Create(nil);
  try
    OpenSQL(Format('select isclient from btype where typeid = ''%s''', [szBTypeID]), cds);
    if cds.RecordCount > 0 then
      Result := cds.FieldByName('isclient').AsInteger;
  finally
    FreeAndNil(cds);
  end;
end;

procedure RunCalc;
var
  hwd: THandle;
begin
  hwd := FindWindow('SciCalc', nil);
  if hwd = 0 then
  begin
    if ShellExecute(Application.Handle, nil, 'Calc', nil, nil, SW_Normal) <= 32 then
      ShowErrorMsg('���С�������������ϵͳ��Դ������Windows��װ��ȫ��');
  end
  else
  begin
    ShowWindow(hwd, SW_Hide);
    ShowWindow(hwd, SW_RESTORE);
  end;
end;

function CheckHasProduceVch(AVchcode: Integer; szDate: string; var szPTypeID: string): Boolean;
var
  lRet: Integer;
  vParams: TParams;
begin
  vparams := TParams.Create;
  try
    lRet := ExecuteProcByName('p_jxc_AffectCost;1', ['@nVchcode', '@szDate',	'@szPTypeID'],
      [AVchcode, szDate, szPTypeID], vParams);
    szPtypeID := vParams.ParamByName('@szPTypeID').AsString;
    Result := lRet < 0;
  finally
    FreeAndNil(vparams);
  end;
end;

function CheckDateInCurYear(szDate: string): Boolean;
var
  szperiodDate: string;
begin
  szperiodDate := PeriodToStartDate(1);
  if szDate < szPeriodDate then
  begin
    Result := False;
    Exit;
  end;
  szperiodDate := PeriodToEndDate(12);
  if szDate > szperiodDate then
  begin
    Result := False;
    Exit;
  end;
  Result := True;
end;

function DateToPeriod(szDate: string): Integer;
var
  vParams: TParams;
begin
  Result := 1;
  vParams := TParams.Create;
  try
    ExecuteProcByName('p_gbl_GetPeriodOrDate;1',
      ['@lMode', '@lPeriod', '@szBeginDate', '@szEndDate'], [2, 0, szDate, ''], vParams);
    if vParams.Count > 0 then
      Result := vParams.ParamByName('@lPeriod').AsInteger;
  finally
    vParams.Free;
  end;
end;

function PeriodToDate(lPeriod: Integer; var szStartDate, szEndDate: string): Boolean;
var
  vParams: TParams;
begin
  Result := False;
  vParams := TParams.Create;
  try
    ExecuteProcByName('p_gbl_GetPeriodOrDate;1',
      ['@lMode', '@lPeriod', '@szBeginDate', '@szEndDate'],
      [3, lPeriod, '', ''], vParams);
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

function PeriodToStartDate(lPeriod: Integer): string;
var
  AStartDate, AEndDate: string;
begin
  Result := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
  if PeriodToDate(lPeriod, AStartDate, AEndDate) then
    Result := AStartDate
end;

function PeriodToEndDate(lPeriod: Integer): string;
var
  AStartDate, AEndDate: string;
begin
  Result := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
  if PeriodToDate(lPeriod, AStartDate, AEndDate) then
    Result := AEndDate
end;

function GetPeriod: Integer;
begin
  Result := StrToInt(GetSysValue('Period'));
end;

function GetJxcPeriod: Integer;
var
  nPeriod: integer;
begin
  nPeriod := StrToInt(GetSysValue('JxcPeriod'));
  if nPeriod > 12 then
    nPeriod := 12;
  Result := nPeriod;
end;

function CurrPeriodToDate(var szStartDate, szEndDate: string): Boolean;
var
  vParams: TParams;
begin
  Result := False;
  vParams := TParams.Create;
  try
    ExecuteProcByName('p_gbl_GetPeriodOrDate;1',
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

//����TypeIDȡ����ļ۸���Ϣ
function GetPtypePrice(asPtypeID: string; asPrice: string): Double;
var
  cds: TClientDataSet;
  szSQL: string;
begin
  Result := 0;

  cds := TClientDataSet.Create(nil);
  try
    szSQL := 'select isnull(%s, 0) Price from ptype where typeid = ''' + '%s' + '''';
    szSQL := Format(szSQL, [asPrice, asPtypeID]);

    OpenSQL(szSQL, cds);

    if not cds.IsEmpty then
    begin
      cds.First;
      Result := cds.FieldByName('Price').Asfloat;
    end;
  finally
    FreeAndNil(cds);
  end;
end;

function CurrPeriodToStartDate: string;
var
  AStartDate, AEndDate: string;
begin
  Result := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
  if CurrPeriodToDate(AStartDate, AEndDate) then
    if AStartDate <> '' then
      Result := AStartDate
end;

function CurrJxcPeriodToStartDate: string;
var
  AStartDate, AEndDate: string;
begin
  Result := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
  if CurrJxcPeriodToDate(AStartDate, AEndDate) then
    if AStartDate <> '' then
      Result := AStartDate
end;

function CurrPeriodToEndDate: string;
var
  AStartDate, AEndDate: string;
begin
  Result := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
  if CurrPeriodToDate(AStartDate, AEndDate) then
    if AEndDate <> '' then
      Result := AEndDate;
end;

function CurrJxcPeriodToEndDate: string;
var
  AStartDate, AEndDate: string;
begin
  Result := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
  if CurrJxcPeriodToDate(AStartDate, AEndDate) then
    if AEndDate <> '' then
      Result := AEndDate;
end;

function GetPeriodYear(lPeriod: Integer): Integer;
var
  Sql: string;
  cds: TClientDataSet;
begin
  Result := 0;
  cds := TClientDataSet.Create(nil);
  try
    Sql := Format('Select Year From T_Gbl_MonthProc Where Period = %d', [lPeriod]);
    OpenSQL(Sql, cds);
    if not cds.Eof then
      Result := cds.Fields[0].AsInteger;
  finally
    FreeAndNil(cds);
  end;
end;

function CheckDateInCurPeriod(szDate: string): Boolean;
begin
  Result := DateToPeriod(szDate) = GetPeriod;
end;

function CheckDateInPeriod(szDate: string; lPeriod: Integer): Boolean;
var
  AStartDate, AEndDate: string;
begin
  Result := False;
  PeriodToDate(lPeriod, AStartDate, AEndDate);
  if (szDate >= AStartDate) and (szDate <= AEndDate) then
    Result := True;
end;

function GetBTypePrePriceConfig(szBTypeID: string): Integer;
var
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  Result := -1;
  OpenSQL(Format('select isnull(preprice, -1) preprice from btype where typeid = ''%s''', [szBTypeID]), cds);
  if (cds.Active) then
  begin
    cds.First;
    if not cds.Eof then
      Result := cds.FieldByName('preprice').AsInteger;
  end;
  cds.Free;
end;

function GetAtypePropertyFirstLeafID(nPropertyID: Integer): string;
var
  cds: TClientDataSet;
  vParam: TParams;
begin
  Result := '';
  cds := TClientDataSet.Create(nil);
  vParam := TParams.Create;
  try
    ExecuteProcByName('P_CW_GetAtypePropertyFirstLeaf;1', ['@nPropertyID', '@szAtypeID'], [nPropertyID, ''], vParam);
    if vParam.Count > 0 then
      Result := vParam.ParamByName('@szAtypeID').Asstring;
  finally
    FreeAndNil(vParam);
    FreeAndNil(cds);
  end;
end;

function GetSubjectA(ProjectName: string): string;
var
  cds: TClientDataset;
begin
  cds := TClientDataset.Create(nil);
  try
    OpenProcByName('P_CW_GetSubject;1', ['@ProjectID', '@ProjectName'],
      ['00000', ProjectName], cds);

    Result := cds.fieldbyname('aTypeID').AsString;
  finally
    FreeAndNil(cds);
  end;
end;

function GetSubProperty(szAtypeID: string): Integer;
begin
  Result := ExecuteProcByName('P_CW_GetAtypeProperty;1', ['@AtypeId'], [szAtypeID], nil);
end;

function CheckSetAtype(szAtypeID, szPropertyID: string): Boolean;
var
  lResult: Integer;
begin
  lResult := ExecuteProcByName('P_CW_CheckSetAtype;1', ['@AtypeId', '@PropertyID'],
    [szAtypeID, szPropertyID], nil);
  if lResult = 0 then
    Result := True
  else
    Result := False;
end;

procedure CopyParamsToParams(var aParams1, aParams2 : Variant);
var
  i: Integer;
begin
  for i := Ord(Low(TCMBasicType)) to Ord(High(TCMBasicType)) do
  begin
    aParams1[i] := aParams2[i];
  end;
end;

function AccountExportString(szInput1, szInput2, FSign: String; Bit: Integer = 4): String;
var
  SQL, ReStr: String;
begin
  if Pos('.', szInput1) = 0 then
    szInput1 := szInput1 + '.0000';

  SQL := 'Select Cast(Cast(' + szInput1 + ' ' + FSign + ' ' + szInput2 + ' as Numeric(38, ' + IntToStr(Bit) + ')) as VarChar(100)) as Result';
  ReStr := GetValueFromSQL(SQL);

  While Copy(ReStr, Length(ReStr), 1) = '0' do
  begin
    ReStr := Copy(ReStr, 1, Length(ReStr) - 1);
  end;

  if Copy(ReStr, Length(ReStr), 1) = '.' then
    ReStr := Copy(ReStr, 1, Length(ReStr) - 1);

  Result := ReStr;
end;

function GetUserDefined(pTypeID:string; var custom1: string; var custom2: string):Boolean;
var cdsDataSet: TClientDataSet;
  sSql : string;
begin
  custom1 := '';
  custom2 := '';
  cdsDataSet := TClientDataSet.Create(nil);
  try
    sSql := Format('select custom1, custom2 from ptype where typeid = ''%s''', [pTypeID]);
    OpenSQL(sSql, cdsDataSet);
    with cdsDataSet do
    begin
      First;
      Result := True;
      custom1 := Fields[0].AsString;
      custom2 := Fields[1].AsString;
    end;
  finally
    FreeAndNil(cdsDataSet);
  end;
end;

function IsInit: Boolean;
begin
  Result := not (GetSysValue('iniover') = '1');
end;

//�Ƿ������ĩ״̬
function IsEndState: Boolean;
begin
  //if GetSystemCostMode in [0, 4] then //������Ȩƽ���¿���
   // Result := (LowerCase(GetSysValue('EndState')) = 'in')
  //else
    Result := False;
end;

function IsRPInit: Boolean;
begin
  Result := not (GetSysValue('RPInitOver') = '1');
end;

//��ͳһ���������Զ����ݵ��ļ��� Add By Guiyun 2007-08-16
function GenerateBackupFileName(const AccountName: string): string;
var
  BackupDate: TDateTime;
begin
  //�Զ������ļ����Ƹ�ʽ�޸�Ϊ��"��������" + "��-��-��" + "@" + "ʱ-����-����"(����ȡ��λ)
  BackupDate := Now;
  Result  := Format('%s%s-%s',[AccountName,
                               FormatDatetime('yyyy/mm/dd@hh/mm/ss', BackupDate),
                               Copy(FormatDatetime('zzz', BackupDate),1,2)]);
end;

{function GetTradeReportPath: string;
var
  szTradePath: string;
begin
  szTradePath := Trim(GetSysValue('TradeAtype'));
  if not (CharInSet(szTradePath[1], ['0'..'8'])) then
    szTradePath := '0';

  Result := GetModulePath + 'gcp\' + szTradePath + '\';
end;  }

function TestVersion: Boolean;
begin
  Result := GetSysValue('TestVersion') = 'True';
end;

end.
