//业务函数
unit uOperationFunc;

interface

uses uDataStructure, Forms, SysUtils, Windows, Classes, IniFiles, uBasalMethod, uTransformFunc,
     ShellAPI, uStringConst, XWComponentType, xwgtypedefine, OleCtl,
     uExtImage, XwTable, ExtCtrls, Controls, Generics.Collections;

procedure RunHelp(const aFlage: string);
procedure DeleteGridUserSet(ModuleNo: Integer);
procedure DeleteSection(const ASection : string);
procedure SetConfig(const szItem, szNewValue: string);
procedure SetConfigIni(szSection, szItem, szNewValue: string);
procedure ExecHelp(szItem: string; const Root: string = ''; const index: string = '');

function GetConfig(const szItem: string; const Default: string = ''): string;
procedure SetPrintConfig(szItem, szNewValue: string); //设置打印管理器配置文件
function GetPrintConfig(szItem: string): string; //读取打印管理器配置文件
function CheckIniValueExists(szSection, szItem: string): Boolean;
function GetConfigIni(szSection, szItem: string; const ADefault: string = ''): string;
function CheckIniSectionExists(szSection: string): Boolean;
function GetMessageBoxCaptions(mbt : Integer): string;
function GetStringsFromStringNo(StringNO: Integer): string;
function GetDataTypeFromBasic(BasicType: TCMBasicType): TgpBasicTypeAttr;
function GetBtnType(BtnType: TCMBtnType): TgpButtonType;
function GetBtntypeFromTag(nTag: Integer): TCMBtnType;
function GetParentID(CurrentID: string): string;
function GetParentIDNew(CurrentID: string): string;
function GetSystemDecimal: string;
function GetSystemDeclimalZero: Double;
function SelectAtypeData(szSearchString: string; var temp: TCMBaseArray;
  SubjectType: TCMSubjectType; SelectClass, CanAddNew: Boolean): Boolean;
function BillSelectAtypeData(szSearchString: string; var temp: TCMBaseArray;
  SubjectType: TCMSubjectType; SelectClass, CanAddNew, IsForceView: Boolean): Boolean;
function BaseInfoTypeToBasicType(ABaseInfoType: TCMBaseInfoType): TBasicType;
function GetDrvMod(szUnit1, szUnit2: string; qty1, Scale: double): string;  //计算辅助数量2
//function CalcCost(ptypeid: String = ''): Boolean;  //全月一次加权平均法计算成本
function AnsiCopy(szTemp: string; index, Len: Integer): string;
function ShowBaseOption():Boolean;

const
  ID_LEVEL_LENGTH = 5;

implementation

uses uDllDataBaseIntf, uDllDBService, uDllMessageIntf, uDllComm, uDllBaseSelect, uDllSystemIntf{, uCostCalculate};

procedure SetConfig(const szItem, szNewValue: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetSystemPath + '\CONFIG.INI');
  try
    IniFile.WriteString('SERVER', szItem, szNewValue);
  finally
    IniFile.Free;
  end;
end;

function GetConfig(const szItem: string; const Default: string = ''): string;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(GetSystemPath + '\CONFIG.INI');
  try
    Result := IniFile.ReadString('SERVER', szItem, Default);
  finally
    IniFile.Free;
  end;
end;

//////////////////// SetPrintConfig /////////////////////////////
//函数功能：写值到Config.cfg中                                 //
//传入参数：szItem :栏目名称 szNewValue :栏目的值              //
//返回参数：                                                   //
//说明：如 ：SetConfig（'PRINTQUICKENTER','YES')               //
/////////////////////////////////////////////////////////////////
procedure SetPrintConfig(szItem, szNewValue: string);
var
  i, j: Integer;
  szFilePath: string; //文件路径
  StrList: TStringList; //存储文件列表
  szStr: string;
begin
  SzItem := UpperCase(szItem);
  szFilePath := ExtractFileDir(Application.ExeName) + '\CONFIG.CFG';
  strList := TStringList.Create;
  try
    strlist.LoadFromFile(szFilePath);
    for i := Strlist.Count - 1 downto 0 do //这样就快多了，不用管前面的哪些无用的东西了。
    begin
      j := pos('=', StrList.Strings[i]);
      if j <> -1 then
        szstr := copy(strList.Strings[i], 1, j - 1);
      if CompareStr(szstr, SzItem) = 0 then
      begin
        StrList.Strings[i] := szItem + '=' + UpperCase(szNewValue);
        Break;
      end;
    end;
    strlist.SaveToFile(szFilePath);
  finally
    StrList.Free;
  end;
end;

//////////////////// GetPrintConfig /////////////////////////////
//函数功能：从config.cfg中取出指定标志栏目的值                 //
//传入参数：szItem : 栏目名称 如:STATION                       //
//返回参数：对应栏目的取值                                     //
//说明： 如果指定的栏目不存在，程序会自动创建                  //
/////////////////////////////////////////////////////////////////
function GetPrintConfig(szItem: string): string;
var
  nHandle: Integer;
  i: Integer;
  m: integer;
  buffer: array[1..255] of PAnsiChar;
  szTemp: AnsiString;
  cTemp: PAnsiChar;
  bFail: Boolean;
  strlist: Tstringlist;
  szFilePath: string; //Config 文件路径
begin
  Result := '';
  szFilePath := ExtractFileDir(Application.ExeName) + '\CONFIG.CFG';
  szItem := UpperCase(szItem);
  nHandle := FileOpen(szFilePath, OF_READ); //bactq modify
  if nHandle <= 0 then
  begin
    MessageBox(0, Pchar('配置文件' + szFilePath + '打开错误'), '提示信息', MB_ICONERROR);
    Exit;
  end;
  bFail := False;
  FileSeek(nHandle, 0, 0);

  while True do
  begin
    i := 0;
    while True do
    begin
      m := FileRead(nHandle, cTemp, 1);
      if m <= 0 then
      begin
        bFail := True;
        Break;
      end;
      Inc(i);
      buffer[i] := cTemp;
      if cTemp = #10 then
      begin
        buffer[i - 1] := #0;
        Break;
      end;
    end;
    szTemp := StrPas(PAnsiChar(@buffer)); //将Buffer的值赋给字符串
    if (UpperCase(Copy(string(szTemp), 1, Length(szItem))) = szItem) then
      Break;
    if bFail then //读到最后都没有读到数据.
    begin
      FileClose(nHandle);
      strlist := TStringList.Create;
      try
        strlist.LoadFromFile(szFilePath);
        i := strlist.IndexOf('END'); //ADD 2003-04-30
        if i <> -1 then
          Strlist.Delete(i); //ADD 2003-04-30
        strlist.Insert(strlist.count, szitem + '=');
        strlist.add('END'); //add 2003-04-30
        strlist.SaveToFile(szFilePath);
      finally
        strlist.Free;
      end;
      Break;
    end;
  end;
  if not bfail then
  begin
    for i := 1 to Length(szTemp) do
    begin
      if szTemp[i] = '=' then
        Break; //计算＝号前面有多少个字符
    end;
    Delete(szTemp, 1, i); //删除等号前面的无用字符
    Result := TrimRight(string(szTemp));
    FileClose(nHandle);
  end;
end;

//帮助接口
procedure ExecHelp(szItem: string; const Root: string = ''; const index: string = '');
begin
  if StringEmpty(szItem) then
    szItem := 'welcome';

  RunHelp(GetSystemPath + '\help.chm::/' + szItem + '.htm');
end;

procedure RunHelp(const aFlage: string);
begin
  ShellExecute(Application.Handle
    , 'open'
    , 'hh.exe'
    , pchar('mk:@MSITStore:' + aFlage)
    , nil
    , SW_SHOW);
end;

function CheckIniValueExists(szSection, szItem: string): Boolean;
begin
  with TIniFile.Create(GetSystemPath + '\Config.Ini') do
  begin
    Result := ValueExists(szSection, szItem);
    Free;
  end;
end;

function GetConfigIni(szSection, szItem: string; const ADefault: string = ''): string;
begin
  with TIniFile.Create(GetSystemPath + '\Config.Ini') do
  begin
    Result := ReadString(szSection, szItem, ADefault);
    Free;
  end;
end;

procedure SetConfigIni(szSection, szItem, szNewValue: string);
begin
  with TIniFile.Create(GetSystemPath + '\Config.Ini') do
  begin
    WriteString(szSection, szItem, szNewValue);
    Free;
  end;
end;

function CheckIniSectionExists(szSection: string): Boolean;
begin
  with TIniFile.Create(GetSystemPath + '\Config.Ini') do
  begin
    Result := SectionExists(szSection);
    Free;
  end;
end;

procedure DeleteSection(const ASection : string);
begin
  with TIniFile.Create(GetSystemPath + '\Config.Ini') do
  begin
    try
      EraseSection(ASection);
    finally
      Free;
    end;
  end;
end;

function GetMessageBoxCaptions(mbt : Integer): string;
const  //修改要注意顺序
  Captions: array[0..4] of Integer = (
    LANG_TITLE_WARNING, LANG_TITLE_ERROR, LANG_TITLE_INFORMATION, LANG_TITLE_CONFIRM, 0);
begin
  Result := GetStringsFromStringNo(Captions[mbt]);
end;

function GetStringsFromStringNo(StringNO: Integer): string;
begin
//  Result := '';
//  if StringNO = 0 then Exit;
//  Result := Global_Strings[StringNo];

  Result := GetStrings(StringNO);
end;

function GetDataTypeFromBasic(BasicType: TCMBasicType): TgpBasicTypeAttr;
begin
  Result := GetGlobalDataType(BasicType);
end;

function GetBtnType(BtnType: TCMBtnType): TgpButtonType;
begin
  Result := GetGlobalButtonType(BtnType);
end;

function GetBtntypeFromTag(nTag: Integer): TCMBtnType;
var
  i : TCMBtnType;
begin
  for i := Low(TCMBtnType) to High(TCMBtnType) do
  begin
    if Ord(i) = nTag then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := gbtNone;
end;

function GetParentID(CurrentID: string): string;
begin
  if Length(Trim(CurrentID)) <= ID_LEVEL_LENGTH then
    Result := ''
  else if Length(Trim(CurrentID)) = ID_LEVEL_LENGTH * 2 then
    Result := '00000'
  else
    Result := Copy(CurrentID, 1, Length(Trim(CurrentID)) - 10);
end;

function GetParentIDNew(CurrentID: string): string;
begin
  if Length(Trim(CurrentID)) < ID_LEVEL_LENGTH then
    Result := ''
  else if Length(Trim(CurrentID)) = ID_LEVEL_LENGTH then
    Result := '00000'
  else
    Result := Copy(CurrentID, 1, Length(Trim(CurrentID)) - 5);
end;

function GetSystemDecimal: string;
begin
  case GetPubDefaultDecimal of
    5:  Result :=  PRICE5_FMT;
    6:  Result :=  PRICE6_FMT;
    7:  Result :=  PRICE7_FMT;
    8:  Result :=  PRICE8_FMT;
    else
     Result :=  PRICE6_FMT;
  end;
end;

function GetSystemDeclimalZero: Double;
begin
  case GetPubDefaultDecimal of
    5: Result := 0.000001;
    6: Result := 0.0000001;
    7: Result := 0.00000001;
    8: Result := 0.000000001;
    else
      Result := 0.00001;
  end;
end;

function SelectAtypeData(szSearchString: string; var temp: TCMBaseArray;
  SubjectType: TCMSubjectType; SelectClass, CanAddNew: Boolean): Boolean;
var
  szParID: string;
  szAssistant: string;
  tempAtype: TAtypeBase;
  tempRecord: TCMBaseRecord;
begin
  szParID := '';
  szAssistant := '0000000000';
  if not Assigned(temp) then
    temp := TList<TCMBaseRecord>.Create();

  Result := SelectAtype(szParID, szSearchString, tempAtype, Ord(SubjectType),
    SelectClass, CanAddNew, szAssistant, True, False);
  if Result then
  begin
    tempRecord.szTypeID := tempAtype.TypeID;
    tempRecord.FullName := tempAtype.FullName;
    tempRecord.SonNum := tempAtype.SonNum;
    tempRecord.UserCode := tempAtype.UserCode;
    temp.Add(tempRecord);
  end;
end;

function BillSelectAtypeData(szSearchString: string; var temp: TCMBaseArray;
  SubjectType: TCMSubjectType; SelectClass, CanAddNew, IsForceView: Boolean): Boolean;
var
  szParID: string;
  szAssistant: string;
  tempAtype: TAtypeBase;
  tempRecord: TCMBaseRecord;
begin
  szParID := '';
  szAssistant := '0000000000';
  if not Assigned(temp) then
    temp := TList<TCMBaseRecord>.Create();
  Result := SelectAtype(szParID, szSearchString, tempAtype, Ord(SubjectType),
    SelectClass, CanAddNew, szAssistant, IsForceView);
  if Result then
  begin
    tempRecord.szTypeID := tempAtype.TypeID;
    tempRecord.FullName := tempAtype.FullName;
    tempRecord.SonNum := tempAtype.SonNum;
    tempRecord.UserCode := tempAtype.UserCode;
    temp.Add(tempRecord);
  end;
end;

function BaseInfoTypeToBasicType(ABaseInfoType: TCMBaseInfoType): TBasicType;
begin
  case ABaseInfoType of
    tbtAType: result := btAtype;
    tbtPType: result := btPtype;
    tbtBType: result := btBtype;
    tbtCBType: result := btBCtype;
    tbtSBType: result := btBVtype;
    tbtArea: result := btRtype;
    tbtKType: result := btKtype;
    tbtEType: result := btEtype;
    tbtDType: result := btDtype;
    tbtJType: result := btJtype;
    tbtMType: result := btMtype;
    tbtVchtype: result := btVchtype;
    tbtOType: result := btOtype;
    tbtGPType: result := btItype;
    tbtATypeCW: result := btAtype;
    tbtBrand: result := btTtype;
    tbtCustom1: result := btZFtype;
    tbtCustom2: result := btZStype;
    tbtWType: Result := btWType; //车间
    tbtWBtype: Result := btWBType; //委外加工单位
    tbtGXtype:Result:=btGXtype;
    tbtGZtype:Result:=btGZtype;
    tbtGjtype:Result:=btGJtype;
    tbtGXtype2:Result:=btGXtype2;
    tbtPSType:Result:=btPSType;
    tbtPSType2:Result := btPSType2;
  else
    result := btAll;
  end;
end;

procedure DeleteGridUserSet(ModuleNo: Integer);
var
  SQL: string;
begin
  SQL := 'Delete From XW_GridFieldConfig Where ModuleNo = ' + IntToStr(ModuleNo) + '';
  ExecuteSQL(SQL);
end;

function GetDrvMod(szUnit1, szUnit2: string; qty1,Scale: double): string;
var
  nDd: Integer;
  dDx, liinteger: Double;
  szTemp: string;
begin
  if (Scale <> 0) and (Scale <> 1) then
  begin
    szTemp := '';
    if Qty1 < 0 then szTemp := '-';
    Qty1 := Abs(qty1);

    if Scale > 1 then
    begin
      liinteger := Qty1 / scale;
      nDd := trunc(StringToDouble(doubleTostring(liinteger)));
      dDx := Qty1 - nDd * scale;
      if nDd > DOUBLE_ZERO then szTemp := szTemp + IntToStr(nDd) + szUnit2;
      if dDx > DOUBLE_ZERO then szTemp := szTemp + DoubleToString(dDx) + szUnit1;
    end
    else
    begin
      nDd := Trunc(Qty1);
      dDx := (Qty1 - nDd) / scale;
      if nDd > DOUBLE_ZERO then szTemp := szTemp + IntToStr(nDd) + szUnit1;
      if dDx > DOUBLE_ZERO then szTemp := szTemp + DoubleToString(dDx) + szUnit2;

    end;
    Result := szTemp;
  end else
  begin
    if Abs(Qty1) < DOUBLE_ZERO then
      Result := ''
    else
      Result := DoubleToString(Qty1) + szUnit1;
  end;
end;

//全月一次加权平均法计算成本
//function CalcCost(ptypeid: String = ''): Boolean;
//begin
//  CheckError(not GetLimit(2110), '你没有成本计算的权限。');
//  ShowCostCalculate(ptypeid);
//  Result := True;
//end;

function AnsiCopy(szTemp: string; index, Len: Integer): string;
var
  sRet: string;
begin
  sRet := Copy(szTemp, index, Len);

  if ByteType(sRet, Len) = mbLeadByte then
    sRet := Copy(sRet, 1, Length(sRet) - 1);

  Result := sRet;
end;

function ShowBaseOption(): Boolean;
var
  SQL: string;
begin
  if FDllParams.PubVersion2 < 3680 then
    result:=False
  else
  begin
    SQL:='IF EXISTS(SELECT * FROM dbo.T_GBL_SysCon WHERE Stats = 1 AND ConID BETWEEN 134 AND 138 AND Stats = 1) SELECT 1 ELSE SELECT 0';
    if Int(GetValueFromSQL(SQL)) = 1 then
      Result := True
    else
      Result := False
  end;
end;

end.
