//基础函数、与业务无关的一些函数
unit uBasalMethod;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, WinTypes, Forms, Db, WinSock, uDataStructure, uTransformFunc, Classes,
  OleCtl, nb30, ComObj;

type
  TASTAT = record
    adapter : TAdapterStatus;
    name_buf : TNameBuffer;
  end;

const
  cLocalHostIP = '127.0.0.1';
  cLocalHost = 'LocalHost';

function StringIndex(AText: string; AStrings: array of string): Integer;
function IsEmpty(Source: string; ADefault: string): string;
function IsZero(Source: Integer; ADefault: Integer): Integer; overload;
function IsZero(Source: Double; ADefault: Double): Double; overload;

procedure FileVersion(FileName: string; var MajorMinor, ReleaseBuild: Longword);
function GetVersionFullString(AppName: string): string;
function GetVersionString(AppName: string): string;
function GetSystemPath: string;
function GetSysDataPath: string;
function GetComputerNameSelf: String;
function GetModulePath: string;
function GetszGUID: WideString;
function GetVolumeInfo(const RootName: string; var Value: TVolumeInfo): Boolean;
function GetComputerIP:String;
function CheckFileAttr(const AFileName: string; var ErrMsg: string): Boolean;
function JudgeDateFormat(lpszDate: string): Boolean;
function DeleSpace(szSt: string): string;
function FullChar(OldStr: string; StrLeng: Integer; SChar: string): string;
function CheckStringtoDate(const S: string; var ResultDate: TDateTime): Boolean;
function DateDecToDay(sDate1, sDate2: string): Integer; //两个日期间的天数
function DateCheckString(lpszDate: string): Boolean; //检查日期
function StrToDate2(S: string): Longint; //字符串转换为日期
function StringToDate(lpszInString: string): Longint;
function StringToDateTime(lpszInString: string): TDateTime;
function IncNumStr(s: string): string;
//检查是否包含所给字符集中字符
function CheckSpecialChar(const ASpecialList: string; ACustomName: WideString; CheckFaitStr: Boolean = True): Boolean;
//得到文件的大小
function GetFileSizeSelf(szFileName: string): Longint;
//是否IP
function IsIP(szIP: string): Boolean;

function ComputerName: string;
function HostEntryToIP(HostEnt: PHostEnt): string;
function ResolveHost(const AHost: AnsiString): string;

function GetNetwork(const AIP: string): string;
function IsLANIP(const AServerIP: string): Boolean;
function IsLANHost(const AServerName: AnsiString): Boolean;

//比较两个字符串是否相同，全部转换为小写比较
function SameStr(Str1, Str2: string): Boolean;

var DOUBLE_DELTA : Double = 0.000000001;
//add by cxh 2012-1-18
//等于=
function IsEqual(ANumber1,ANumber2 : Double) : Boolean;
//大于>
function GreaterThan(ANumber1,ANumber2 : Double) : Boolean;
//大于等于>=
function GreaterThanOrEqual(ANumber1,ANumber2 : Double) : Boolean;
//小于<
function LessThan(ANumber1,ANumber2 : Double) : Boolean;
//小于等于<=
function LessThanOrEqual(ANumber1,ANumber2 : Double) : Boolean;
//add by cxh
function ReplaceSpecialChar(ATitle: string): string;
function ReplaceAll(ASubStr: string; AOldStr: string; ANewStr: string): string;
procedure RegisterMidas;
//Cpu
procedure SetCPU(h: THandle; CpuNo: Integer);
function GetCnCPUID: string;
//网卡
function NBGetAdapterAddress(a: Integer): WideString;
function Getmac: WideString;
//Guid
function GetNewGuid: string;

implementation

uses uDllMessageIntf, uDllDataBaseIntf, uDllDBService, uDllComm, uDllSystemIntf;

//从一个字符串数组中取得一个字符串的索引号
function StringIndex(AText: string; AStrings: array of string): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := Low(AStrings) to High(AStrings) do // Iterate
  begin
    if UpperCase(AText) = UpperCase(AStrings[I]) then
    begin
      Result := I;
      Exit;
    end;
  end; // for
end;

function IsEmpty(Source: string; ADefault: string): string;
begin
  if Trim(Source) = '' then
    Result := ADefault
  else
    Result := Trim(Source);
end;

function IsZero(Source: Integer; ADefault: Integer): Integer; overload;
begin
  if Source = 0 then
    Result := ADefault
  else
    Result := Source;
end;

function IsZero(Source: Double; ADefault: Double): Double; overload;
begin
  if Abs(Source) < 0.00001 then
    Result := ADefault
  else
    Result := Source;
end;

procedure FileVersion(FileName: string; var MajorMinor, ReleaseBuild: Longword);
var
  InfoSize, Wnd: DWORD;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
begin
  MajorMinor := 0;
  ReleaseBuild := 0;
  InfoSize := GetFileVersionInfoSize(PChar(FileName), Wnd);
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(PChar(FileName), Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
        begin
          MajorMinor := FI.dwFileVersionMS;
          ReleaseBuild := FI.dwFileVersionLS;
        end;
    finally
      FreeMem(VerBuf);
    end;
  end;
end;

function GetVersionFullString(AppName: string): string;
var
  MajorMinor, ReleaseBuild: Longword;
  szTemp: string;
begin
  FileVersion(AppName, MajorMinor, ReleaseBuild);
  szTemp := 'Build ' + IntToStr(MajorMinor shr 16) + '.' + IntToStr(MajorMinor and $FFFF) + '.' + IntToStr(ReleaseBuild shr 16) + '.' + IntToStr(ReleaseBuild and $FFFF) + '';
  Result := szTemp;
end;

function GetVersionString(AppName: string): string;
var
  MajorMinor, ReleaseBuild: Longword;
  szTemp: string;
begin
  FileVersion(AppName, MajorMinor, ReleaseBuild);
  
  szTemp := 'Build ' + IntToStr(MajorMinor shr 16) + '.' +
    IntToStr(MajorMinor and $FFFF) + '.' +
    IntToStr(ReleaseBuild shr 16) + '.' +
    IntToStr(ReleaseBuild and $FFFF) + '';
  Result := szTemp;
end;

function GetSystemPath: string;
var
  i: Integer;
begin
  for i := Length(Application.ExeName) downto 1 do
  begin
    if Copy(Application.ExeName, i, 1) <> '\' then continue;
    break;
  end;
  GetSystemPath := Copy(Application.ExeName, 1, i - 1);
end;

function GetSysDataPath: string;
begin
  Result := GetSystemPath + '\data';
end;

function GetComputerNameSelf: String;
var
  buf : array[1..255] of char;
  nTemp :  DWord;
begin
  nTemp := 200;
  GetComputerName(@buf, nTemp);
  Result := StrPas(PWideChar(@buf));
end;

function GetModulePath: string;
var
  ar: array[0..MAX_PATH] of char;
  str: string;
begin
  GetModuleFileName(hInstance, ar, MAX_PATH);
  str := ExtractFileDir(string(ar));
  if not (CharInSet(str[Length(str)], ['\', '/'])) then
    str := str + '\';
  Result := str;
end;

function GetszGUID: WideString;
var
  CSerias: TVolumeInfo;
  szClientGUID, {AdapterAddress,} szCPUID: string;
begin
  GetVolumeInfo('C:\', CSerias);
  szClientGUID := GetComputerNameSelf + IntToHex(CSerias.SerialNumber, 8);
//  AdapterAddress := NBGetAdapterAddress(0);
  SetCPU(GetCurrentProcess, 1);
  szCPUID := GetCnCPUID;
  szClientGUID := szClientGUID + {AdapterAddress +} szCPUID;
  //增加客户端应用程序ID Add By Guiyun 2008-02-26
  szClientGUID := Format('%0:s,%1d',[szClientGUID, Application.Handle]);
  Result := szClientGUID;
end;

{ /*************************************************
   * 说明： 获取指定卷的信息                       *
   * 参数： RootName [ in]卷的根路径，例如：'C:\'  *
   *        Value    [out]卷的信息                 *
   * 返回： True-获取信息成功； False-获取信息失败 *
   * 注意： 对于光驱，返回值也可以代表是否有光盘   *
   ************************************************/ }

function GetVolumeInfo(const RootName: string; var Value: TVolumeInfo): Boolean;
const
  CC_LENGHT_ROOTPATHNAME = 3;
var
  lpRootPathName: PChar;
  lpVolumeNameBuffer: PChar;
  nVolumeNameSize: Cardinal;
  lpVolumeSerialNumber: PDWORD;
  lpMaxinumComponentLength: Cardinal;
  lpFileSystemFlags: Cardinal;
  lpFileSystemNameNuffer: PChar;
  nFileSystemNameSize: Cardinal;
begin
  nVolumeNameSize := MAX_PATH + 1;
  nFileSystemNameSize := MAX_PATH + 1;
  GetMem(lpRootPathName, CC_LENGHT_ROOTPATHNAME + 1);
  GetMem(lpVolumeNameBuffer, MAX_PATH + 1);
  GetMem(lpFileSystemNameNuffer, MAX_PATH + 1);
  GetMem(lpVolumeSerialNumber, SizeOf(PDWORD));
  try
    StrPCopy(lpRootPathName, RootName);
    Result := GetVolumeInformation(lpRootPathName, lpVolumeNameBuffer,
      nVolumeNameSize, lpVolumeSerialNumber, lpMaxinumComponentLength,
      lpFileSystemFlags, lpFileSystemNameNuffer, nFileSystemNameSize);
    if Result then
    begin
      with Value do
      begin
        Name := StrPas(lpVolumeNameBuffer);
        SerialNumber := lpVolumeSerialNumber^;
        MaxLength := lpMaxinumComponentLength;
        FSName := StrPas(lpFileSystemNameNuffer);
        FSFlag_CASE_IS_PRESERVED := ((lpFileSystemFlags and
          FS_CASE_IS_PRESERVED) = FS_CASE_IS_PRESERVED);
        FSFlag_CASE_SENSITIVE := ((lpFileSystemFlags and
          FS_CASE_SENSITIVE) = FS_CASE_SENSITIVE);
        FSFlag_UNICODE_STORED_ON_DISK := ((lpFileSystemFlags and
          FS_UNICODE_STORED_ON_DISK) = FS_UNICODE_STORED_ON_DISK);
        FSFlag_PERSISTENT_ACLS := ((lpFileSystemFlags and
          FS_PERSISTENT_ACLS) = FS_PERSISTENT_ACLS);
        FSFlag_FILE_COMPRESSION := ((lpFileSystemFlags and
          FS_FILE_COMPRESSION) = FS_FILE_COMPRESSION);
        FSFlag_VOL_IS_COMPRESSED := ((lpFileSystemFlags and
          FS_VOL_IS_COMPRESSED) = FS_VOL_IS_COMPRESSED);
      end;
    end;
  finally
    FreeMem(lpRootPathName);
    FreeMem(lpVolumeNameBuffer);
    FreeMem(lpVolumeSerialNumber);
    FreeMem(lpFileSystemNameNuffer);
  end;
end;

function GetComputerIP:String;
var
  wsdata: TWSAData;
  hostName: array[0..255] of AnsiChar;
  hostEnt: PHostEnt;
  addr: PAnsiChar;
  sIP: string;
begin
  hostName := '';
  WSAStartup($0101, wsdata);
  try
    gethostname(hostName, sizeof(hostName));
    StrPCopy(hostName, AnsiString(GetComputerNameSelf));
    hostEnt := gethostbyname(hostName);
    if Assigned(hostEnt) then
      if Assigned(hostEnt^.h_addr_list) then
      begin
        addr := hostEnt^.h_addr_list^;
        if Assigned(addr) then
        begin
          sIP := Format('%d.%d.%d.%d', [byte(addr[0]),
            byte(addr[1]), byte(addr[2]), byte(addr[3])]);
          Result := sIP;
        end
        else
          Result := '';
      end
      else
        Result := ''
    else
    begin
      Result := '';
    end;
  finally
    WSACleanup;
  end
end;

function CheckFileAttr(const AFileName: string; var ErrMsg: string): Boolean;
var
  FileAttr: Integer;
begin
  ErrMsg := '';
  Result := False;
  if not FileExists(AFileName) then //仅检查已存在的文件属性
  begin
    Result := True;
    Exit;
  end;
  FileAttr := FileGetAttr(AFileName);

  if (FileAttr and SysUtils.faSysFile) = SysUtils.faSysFile then //所选文件为系统文件不能操作
  begin
    ErrMsg := '文件是系统文件';
    Exit;
  end;
  if (FileAttr and SysUtils.faHidden) = SysUtils.faHidden then //所选文件为系统文件不能操作
  begin
    ErrMsg := '文件是隐藏文件';
    Exit;
  end;
  if (FileAttr and SysUtils.faReadOnly) = SysUtils.faReadOnly then //去掉文件只读属性
    SysUtils.FileSetAttr(AFileName, FileAttr-SysUtils.faReadOnly);
  Result := True;
end;

{判断日期格式的合法性}

function JudgeDateFormat(lpszDate: string): Boolean;
var
  i, nLimite, nYear: Integer;
begin
  nLimite := 0;
  Result := True;
  i := StringToInt(Copy(lpszDate, 1, 4));
  nYear := i;
  if (i > 9999) or (i < 1) then
  begin
//    DateCheckString := False;
    Exit;
  end;
  i := StringToInt (Copy (lpszDate, 6, 2));
  if (i > 12) or (i < 1) then
  begin
//    DateCheckString := True;
    Exit;
  end;

  if (i>=1) and (i<=9) then
  begin
    if Copy (lpszDate, 6, 1)<>'0' then
    begin
//      DateCheckString := True;
      Exit;
    end;
  end
  else
  begin
    if Copy (lpszDate, 6, 1)<>'1' then
    begin
//      DateCheckString := True;
      Exit;
    end;
  end;


  case i of
    1: nLimite := 31;
    3: nLimite := 31;
    4: nLimite := 30;
    5: nLimite := 31;
    6: nLimite := 30;
    7: nLimite := 31;
    8: nLimite := 31;
    9: nLimite := 30;
    10: nLimite := 31;
    11: nLimite := 30;
    12: nLimite := 31;
    2:
    begin
      if ((nYear mod 4) = 0) and ((nYear mod 100) <> 0) or
        ((nYear mod 100) = 0) and ((nYear mod 400) = 0) then
        nLimite := 29
      else nLimite := 28;
    end;
  end;
  i := StringToInt (Copy (lpszDate, 9, 2));
  if (i<1) or (i>nLimite) then
  begin
//    DateCheckString := True;
    Exit;
  end;
  if (i>=1) and (i<=9) then
  begin
    if Copy (lpszDate, 9, 1)<>'0' then
    begin
//      DateCheckString := True;
      Exit;
    end;
  end;

  if Copy(lpszDate,5,1) <> '-' then
    Exit;
  if Copy(lpszDate,8,1) <> '-' then
    Exit;

  JudgeDateFormat := False;
end;

function DeleSpace(szSt: string): string;
var
  i : integer;
begin
  i := 1;
  while (i <= Length(szSt)) do
  begin
    if (szSt[i] = ' ') then
    begin
      delete(szst, i, 1);
      Dec(i);
    end;
    Inc(i);
  end;
  Result := Szst;
end;

function FullChar(OldStr: string; StrLeng: Integer; SChar: string): string;
var
  lForNum: Integer; //循环变量
  lFullStr: string; //结果字符串
begin
  lFullStr := '';
  if StrLeng < 1 then
  begin
    ShowWarningMsg('填充次数不能小于一次。');
    Exit;
  end;

  try
    for lForNum := 1 to StrLeng do
      lFullStr := lFullStr + SChar;
    Result := OldStr + lFullStr;
  except
    ShowErrorMsg('无法填充该字符串。');
    raise;
  end;
end;

function CheckStringtoDate(const S: string; var ResultDate: TDateTime): Boolean;
var
  Pos: Integer;
begin
  Pos := 1;
  if not ScanDate(S, Pos, ResultDate) or (Pos <= Length(S)) then
    Result := False
  else
    Result := True;
end;

//两个日期间的天数
function DateDecToDay(sDate1, sDate2: string): Integer;
var
  lDay: Integer;
begin
  Result := 0;
  if (not DateCheckString(sDate1)) and (not DateCheckString(sDate2)) then
  begin
    lDay := StrToDate2(sDate1) - StrToDate2(sDate2);
    if lDay > 0 then Result := lDay + 1;
  end;
end;

//检查日期
function DateCheckString(lpszDate: string): Boolean;
var
  i, nLimite, nYear: Integer;
begin
  nLimite := 0;
  i := StringToInt(Copy(lpszDate, 1, 4));
  nYear := i;
  if (i > 9999) or (i < 1) then
  begin
    DateCheckString := True;
    Exit;
  end;
  i := StringToInt(Copy(lpszDate, 6, 2));
  if (i > 12) or (i < 1) then
  begin
    DateCheckString := True;
    Exit;
  end;

  if (i >= 1) and (i <= 9) then
  begin
    if Copy(lpszDate, 6, 1) <> '0' then
    begin
      DateCheckString := True;
      Exit;
    end;
  end
  else
  begin
    if Copy(lpszDate, 6, 1) <> '1' then
    begin
      DateCheckString := True;
      Exit;
    end;
  end;


  case i of
    1: nLimite := 31;
    3: nLimite := 31;
    4: nLimite := 30;
    5: nLimite := 31;
    6: nLimite := 30;
    7: nLimite := 31;
    8: nLimite := 31;
    9: nLimite := 30;
    10: nLimite := 31;
    11: nLimite := 30;
    12: nLimite := 31;
    2:
      begin
        if ((nYear mod 4) = 0) and ((nYear mod 100) <> 0) or
          ((nYear mod 100) = 0) and ((nYear mod 400) = 0) then
          nLimite := 29
        else nLimite := 28;
      end;
  end;
  i := StringToInt(Copy(lpszDate, 9, 2));
  if (i < 1) or (i > nLimite) then
  begin
    DateCheckString := True;
    Exit;
  end;
  if (i >= 1) and (i <= 9) then
  begin
    if Copy(lpszDate, 9, 1) <> '0' then
    begin
      DateCheckString := True;
      Exit;
    end;
  end;

  DateCheckString := False;
end;

//改字符串为日期型
function StrToDate2(S: string): Longint;
begin
  if StringEmpty(S) then
    Result := Trunc(GetLogOnDateTime)
  else
    Result := StringToDate(S);
end;

//字符串为日期
function StringToDate(lpszInString: string): Longint;
var
  szBuffer, szTemp: string;
begin
  Result := 0;
  if StringEmpty(lpszInString) then
    ShowErrorMsg('ERROR EMPTY DATESTRING!');

  szTemp := Copy(FormatDateTime('yyyy/mm/dd', Date), 5, 1);
  szBuffer := Copy(lpszInString, 1, 4) + szTemp + Copy(lpszInString, 6, 2) + szTemp + Copy(lpszInString, 9, 2);
  try
    StringToDate := StringToInt(FloatToStr(StrToDate(szBuffer)));
  except
  end;
end;

function StringToDateTime(lpszInString: string): TDateTime;
var
  szBuffer, szTemp: string;
begin
  Result := 0;
  if StringEmpty(lpszInString) then
    ShowErrorMsg('ERROR EMPTY DATESTRING!');

  szTemp := Copy(FormatDateTime('yyyy/mm/dd', Date), 5, 1);
  szBuffer := Copy(lpszInString, 1, 4) + szTemp + Copy(lpszInString, 6, 2) + szTemp + Copy(lpszInString, 9, 2);
  try
    Result := StrToDateTime(szBuffer);
  except
  end;
end;

function IncNumStr(s: string): string;
var
  i, j: integer;
  tempStr: string;
begin
  j := length(s);
  if j < 2 then
  begin
    result := inttostr(strtoint(s[1]) + 1);
    exit;
  end;
  i := strtoint(s[j]) + 1;
  if i < 10 then
  begin
    s := copy(s, 1, j - 1) + inttostr(i);
    result := s;
  end
  else
    for i := j - 1 downto 1 do
    begin
      s[j] := '0';
      if strtoint(s[i]) < 9 then
      begin
        tempstr := inttostr(strtoint(s[i]) + 1);
        s[i] := tempStr[1];
        result := s;
        exit;
      end
      else
        s[i] := '0';
      if i = 1 then
      begin
        Result := inttostr(strtoint(s[i]) + 1) + copy(s, 2, j - 1) + '0';
      end;
    end;
end;

function CheckSpecialChar(const ASpecialList: string; ACustomName: WideString; CheckFaitStr: Boolean = True): Boolean;
var
  SpecLst: TStringList;
  i, iIndex: Integer;
begin
  Result := False;

  if CheckFaitStr then
  begin
    if Pos('"', ACustomName) > 0 then
    begin
      Result := True;
      Exit;
    end;
  end;

  if Pos('<', ASpecialList) > 0 then
  begin
    if Pos('<', ACustomName) > 0 then
    begin
      Result := True;
      Exit;
    end;
  end;

  try
    SpecLst := TStringList.Create;

    SpecLst.CommaText := ASpecialList;

    for i := 1 to Length(ACustomName) do
    begin
      iIndex := SpecLst.IndexOf(ACustomName[i]);
      
      if iIndex >= 0 then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    FreeAndNil(SpecLst);
  end;
end;

function GetFileSizeSelf(szFileName: string): Longint;
var
  Sec: TSearchRec;
  lTemp: Longint;
begin
  if FindFirst(szFileName, faanyfile, Sec) = 0 then lTemp := Sec.Size
  else lTemp := 0;
  GetFileSizeSelf := lTemp;
  SysUtils.FindClose(Sec);
end;

function IsIP(szIP: string): Boolean;
var
  p: Pchar;
  C: Integer;
begin
  Result := False;
  p := PChar(szIP);
  C := 0;
  while p^ <> #0 do
  begin
    if p^ = '.' then
      Inc(C)
    else if (p^ < '0') or (p^ > '9') then
      Exit;
    Inc(p);
  end;
  Result := C = 3;
end;

function ComputerName: string;
var
  pHostName: array[0..MAX_COMPUTERNAME_LENGTH] of Char;
  s: DWord;
begin
  s := SizeOf(pHostName);
  GetComputerName(pHostName, s);  //Found a unknown bug when using GetHostName(pHostName, SizeOf(pHostName)): return the Logon UserName!
  Result := UpperCase(StrPas(pHostName));
end;

function HostEntryToIP(HostEnt: PHostEnt): string;
begin
  with HostEnt^ do
    if HostEnt = nil then Result := ''
    else Result := Format('%d.%d.%d.%d',[Byte(h_addr^[0]), Byte(h_addr^[1]), Byte(h_addr^[2]), Byte(h_addr^[3])]);
end;

function ResolveHost(const AHost: AnsiString): string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
begin
  if WSAStartup($0101, WSAData) <> 0 then  //Looking To Use Version 1.1 Of WinSock
    raise Exception.Create('WSAStartup: 不能初始化WinSock 1.1');
  //HostEnt := GetHostByName(PChar(AHost));  //Get Server IP setting in Hosts
  HostEnt := GetHostByName(PAnsiChar(AHost));  //Get Server IP setting in Hosts
  if HostEnt = nil then
    raise Exception.CreateFmt('解析域名“%s”失败', [AHost]);  //Fatal
  Result := HostEntryToIP(HostEnt);
  WSACleanup;
end;

function GetNetwork(const AIP: string): string;
var
  iPos,iPosTemp: Integer;
begin
  iPos := Pos('.', AIP);
  Assert(iPos > 0);
  iPosTemp := iPos;
  Result := Copy(AIP, 1, iPos);
  iPos := Pos('.', Result);
  Assert(iPos > 0);
  iPos := iPos + iPosTemp;
  Result := Copy(AIP, 1, iPos - 1);
end;

function IsLANIP(const AServerIP: string): Boolean;
var
  sLocalIP: string;
begin
  sLocalIP := ResolveHost(AnsiString(ComputerName));
  // 继续判断是否本机
  Result := SameText(AServerIP, cLocalHostIP) or
    SameText(AServerIP, sLocalIP);
  if not Result then  // 前两个相同认为是局域网，如 192.168.0.33、192.168.8.16
    Result := SameText(GetNetwork(AServerIP), GetNetwork(sLocalIP));
end;

function IsLANHost(const AServerName: AnsiString): Boolean;
begin
  // 判断是否本机
  Result := SameText(string(AServerName), cLocalHost) or
    SameText(string(AServerName), cLocalHostIP) or
    SameText(UpperCase(ComputerName), UpperCase(string(AServerName)));
  if not Result then
    Result := IsLANIP(ResolveHost(AServerName));
end;

function SameStr(Str1, Str2: string): Boolean;
begin
  if LowerCase(Str1) = LowerCase(Str2) then
    Result := True
  else
    Result := False;
end;

//等于=
function IsEqual(ANumber1,ANumber2 : Double) : Boolean;
begin
  Result := (ANumber1 = ANumber2) or (Abs(ANumber1 - ANumber2) < DOUBLE_DELTA);
end;

//大于>
function GreaterThan(ANumber1,ANumber2 : Double) : Boolean;
begin
  Result := (ANumber1 > ANumber2) and (not IsEqual(ANumber1,ANumber2));
end;

//大于等于>=
function GreaterThanOrEqual(ANumber1,ANumber2 : Double) : Boolean;
begin
  Result := (ANumber1 > ANumber2) or IsEqual(ANumber1,ANumber2);
end;

//小于<
function LessThan(ANumber1,ANumber2 : Double) : Boolean;
begin
  Result := (ANumber1 < ANumber2) and (not IsEqual(ANumber1,ANumber2));
end;

//小于等于<=
function LessThanOrEqual(ANumber1,ANumber2 : Double) : Boolean;
begin
  Result := (ANumber1 < ANumber2) or IsEqual(ANumber1,ANumber2);
end;

function ReplaceSpecialChar(ATitle: string): string;
begin
  Result := ReplaceAll(ATitle, ':', '');
  Result := ReplaceAll(Result, '：', '');
  Result := Trim(Result);
end;

function ReplaceAll(ASubStr: string; AOldStr: string; ANewStr: string): string;
begin
  Result := StringReplace(ASubStr, AOldStr, ANewStr, [rfReplaceAll]);
end;

procedure RegisterMidas;
var
  comm: AnsiString;
  MidasHandle: THandle;
  RegFunc: TDllRegisterServer;
begin
  MidasHandle := LoadLibrary(PChar('midas.dll'));
  if MidasHandle > 0 then
  begin
    RegFunc := GetProcAddress(MidasHandle, PChar('DllRegisterServer'));
    RegFunc;
    FreeLibrary(MidasHandle);
  end
  else
  begin
    comm := 'cmd /c regsvr32 /s "' + AnsiString(GetSystemPath) + '\midas.dll"';
    WinExec(PAnsiChar(comm), 0);
  end;
end;

//Cup函数
procedure SetCPU(h: THandle; CpuNo: Integer);
//CpuNo：决定了获得第几个CPU内核的第几个序列号。
var
  ProcessAffinity: Cardinal;
  _SystemAffinity: Cardinal;
begin
  GetProcessAffinityMask(h, ProcessAffinity, _SystemAffinity);
  ProcessAffinity := CpuNo; //this sets the process to only run on CPU 0
                               //for CPU 1 only use 2 and for CPUs 1 & 2 use 3
  SetProcessAffinityMask(h, ProcessAffinity)
end;

function GetCnCPUID: string;
const
  CPUINFO = '%.8x-%.8x-%.8x-%.8x';
var
  iEax: Integer;
  iEbx: Integer;
  iEcx: Integer;
  iEdx: Integer;
begin
  asm
     push ebx
     push ecx
     push edx
     mov   eax, 1
     DW $A20F//cpuid
     mov   iEax, eax
     mov   iEbx, ebx
     mov   iEcx, ecx
     mov   iEdx, edx
     pop edx
     pop ecx
     pop ebx
  end;
  Result := Format(CPUINFO, [iEax, iEbx, iEcx, iEdx]);
end;

//网卡
function NBGetAdapterAddress(a: Integer): WideString;
var
  NCB: TNCB; // Netbios control block //NetBios控制块
  ADAPTER: TADAPTERSTATUS; // Netbios adapter status//取网卡状态
  LANAENUM: TLANAENUM; // Netbios lana
  intIdx: Integer; // Temporary work value//临时变量
  cRC: AnsiChar; // Netbios return code//NetBios返回值
  strTemp: string; // Temporary string//临时变量
begin
  // Initialize
  Result := '';
  try
    // Zero control blocl
    ZeroMemory(@NCB, SizeOf(NCB));
    // Issue enum command
    NCB.ncb_command := AnsiChar(NCBENUM);
    //cRC := NetBios(@NCB);
    // Reissue enum command
    NCB.ncb_buffer := @LANAENUM;
    NCB.ncb_length := SizeOf(LANAENUM);
    cRC := NetBios(@NCB);
    if ord(cRC) <> 0 then
      exit;
    // Reset adapter
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := AnsiChar(NCBRESET);
    NCB.ncb_lana_num := LANAENUM.lana[a];
    cRC := NetBios(@NCB);
    if ord(cRC) <> 0 then
      Exit;
    // Get adapter address
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := AnsiChar(NCBASTAT);
    NCB.ncb_lana_num := LANAENUM.lana[a];
    StrPCopy(NCB.ncb_callname, '*');
    NCB.ncb_buffer := @ADAPTER;
    NCB.ncb_length := SizeOf(ADAPTER);

    strTemp := '';
    for intIdx := 0 to 5 do
      strTemp := strTemp + InttoHex(Integer(ADAPTER.adapter_address[intIdx]), 2);
    Result := strTemp;
  finally
  end;
end;

function Getmac: WideString;
var
  ncb: TNCB;
  s: AnsiString;
  adapt: TASTAT;
  lanaEnum: TLanaEnum;
  i, j, m: integer;
  strPart, strMac: string;
begin
  FillChar(ncb, SizeOf(TNCB), 0);
  ncb.ncb_command := Char(NCBEnum);
  ncb.ncb_buffer := PAnsiChar(@lanaEnum);
  ncb.ncb_length := SizeOf(TLanaEnum);
  s := Netbios(@ncb);
  for i := 0 to integer(lanaEnum.length) - 1 do
  begin
    FillChar(ncb, SizeOf(TNCB), 0);
    ncb.ncb_command := Char(NCBReset);
    ncb.ncb_lana_num := lanaEnum.lana[i];
    Netbios(@ncb);
    Netbios(@ncb);
    FillChar(ncb, SizeOf(TNCB), 0);
    ncb.ncb_command := Chr(NCBAstat);
    ncb.ncb_lana_num := lanaEnum.lana[i];
    ncb.ncb_callname := '*               ';
    ncb.ncb_buffer := PAnsiChar(@adapt);
    ncb.ncb_length := SizeOf(TASTAT);
    m := 0;

    if (Win32Platform = VER_PLATFORM_WIN32_NT) then
      m := 1;

    if m = 1 then
    begin
      if Netbios(@ncb) = Chr(0) then
        strMac := '';

      for j := 0 to 5 do
      begin
        strPart := IntToHex(integer(adapt.adapter.adapter_address[j]), 2);
        strMac := strMac + strPart + '-';
      end;

      SetLength(strMac, Length(strMac) - 1);
    end;

    if m = 0 then
    begin
      if Netbios(@ncb) <> Chr(0) then
      begin
        strMac := '';
        for j := 0 to 5 do
        begin
          strPart := IntToHex(integer(adapt.adapter.adapter_address[j]), 2);
          strMac := strMac + strPart + '-';
        end;

        SetLength(strMac, Length(strMac) - 1);
      end;
    end;
  end;;
  result := strmac;
end;

//Guid
function GetNewGuid: string;
begin
  Result := ComObj.CreateClassID;
end;

end.
