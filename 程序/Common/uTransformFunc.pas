unit uTransformFunc;

interface

uses SysUtils, Windows, Forms;

const
  DOUBLE_ZERO = 0.00001;
  QTY_ZERO = 0.00005;
  EIGHTDOUBLE_ZERO = 0.000000001;
  TOTAL_FMT: string = '0.00';
  QTY_FMT: string = '0.0000';
  PRICE5_FMT: string = '0.00000';
  PRICE6_FMT: string = '0.000000';
  PRICE7_FMT: string = '0.0000000';
  PRICE8_FMT: string = '0.00000000';

type
  TDateOrder = (doMDY, doDMY, doYMD);

function StringToInt(szInString: string): Longint;
function StringEmpty(lpszInString: string): Boolean;
function LMax(lVal1, lVal2: Longint): Longint;
function DMax(dVal1, dVal2: Double): Double;
function LMin(lVal1, lVal2: Longint): Longint;
function DMin(dVal1, dVal2: Double): Double;
function StrToInteger(const S: string): Integer;
function StringToDoubleF(szInString: string): Extended;
function FormatFloat2(AFormat: string; Source: Double): string;
function StringToQty(szInString: string): Double;
function DoubleToString(dIn: Double): string;
function FormatFour(dTemp: Double): Double;
function StringToDateTime(const S: string; DefaultDate: TDateTime = 0): TDateTime;
function ScanDate(const S: string; var Pos: Integer; var Date: TDateTime): Boolean;
function GetDateOrder(const DateFormat: string): TDateOrder;
procedure ScanToNumber(const S: string; var Pos: Integer);
function GetEraYearOffset(const Name: string): Integer;
function ScanNumber(const S: string; var Pos: Integer; var Number: Word; var CharCount: Byte): Boolean;
function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
procedure ScanBlanks(const S: string; var Pos: Integer);
function DoEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
function StringToDouble(szInString: string; sFormat: String='0.0000'): Double;
function StringToTotal(szInString: string): Extended;
function StringToTaxPrice(szInString: string): Double;
function FormatTwo(dTemp: Double): Double;
function DoubletoStringFMT(FMT: string; dIn: Double): string;
function FloatToInt(dTemp: double): longint;
//delphit自带的Floor有问题
function FloatToInt2(dTemp: double):Integer;
function GetSystemDecimal: string;
function StringIndex(AText: string; AStrings: array of string): Integer;
function GetSystemPath: string;
function DoFileNameStr(FileName: string): string;
function RefToCell(ROwID,ColID:Integer):string;

implementation

uses uCommonSql;


function StringToInt(szInString: string): Longint;
var
  i, nBegin, nEnd: Integer;
  szTemp, c: string;

begin
  { check string empty }
  if StringEmpty(szInString) then
  begin
    StringToInt := 0;
    Exit;
  end;

  { check ' ' in first, get nBegin }
  szTemp := szInString + '!';
  for i := 1 to Length(szTemp) do
  begin
    if Copy(szTemp, i, 1) <> ' ' then break;
  end;
  nBegin := i;

  { check not 0..9, get nEnd }
  for i := nBegin to Length(szTemp) do
  begin
    c := Copy(szTemp, i, 1);
    if (c < '0') or (c > '9') then break;
  end;
  nEnd := i;

  if nBegin >= nEnd then
    StringToInt := 0
  else
  begin
    try
      StringToInt := StrToInt(Copy(szTemp, nBegin, nEnd - nBegin));
    except // wrap up
      StringToInt := 0;
    end;    // try/finally
  end
end;

function StringEmpty(lpszInString: string): Boolean;
var
  i: Integer;
begin
  if Length(lpszInString) = 0 then
  begin
    StringEmpty := True;
    exit;
  end;

  for i := 1 to Length(lpszInString) do
  begin
    if Copy(lpszInString, i, 1) <> ' ' then
    begin
      StringEmpty := False;
      exit;
    end;
  end;
  StringEmpty := True;
end;

function LMax(lVal1, lVal2: Longint): Longint;
begin
  if (lVal1 > lVal2) then
    LMax := lVal1
  else
    LMax := lVal2;
end;

function DMax(dVal1, dVal2: Double): Double;
begin
  if (dVal1 > dVal2) then
    DMax := dVal1
  else
    DMax := dVal2;
end;

function LMin(lVal1, lVal2: Longint): Longint;
begin
  if (lVal1 > lVal2) then
    LMin := lVal2
  else
    LMin := lVal1;
end;

function DMin(dVal1, dVal2: Double): Double;
begin
  if (dVal1 > dVal2) then
    DMin := dVal2
  else
    DMin := dVal1;
end;

function StrToInteger(const S: string): Integer;
var
  E: Integer;
begin
  Val(S, Result, E);
  if E <> 0 then Result := 0;
end;

function StringToDoubleF(szInString: string): Extended;
var
  i, nStart, nBegin, nEnd, nBiao : Integer;
  szTemp, c, cTemp: string;
  dTemp: Double;
begin
  { check string empty }
  if StringEmpty(szInString) then
  begin
    StringToDoubleF := 0.0;
    Exit;
  end;

  { check ' ' in first, get nBegin }
  szTemp := szInString + '!';
  for i := 1 to Length(szTemp) do
  begin
    if Copy(szTemp, i, 1) <> ' ' then break;
  end;
  nBegin := i;

  { check not 0..9, get nEnd }
  nBiao := 0;
  nStart := nBegin;
  if Copy(szTemp, nBegin, 1) = '-' then nBegin := nBegin + 1;
  i := nBegin;
  while i <= Length(szTemp) do
  begin
    c := Copy(szTemp, i, 1);
    if (c = 'E') or (c = 'e') then
    begin
      if i = Length(szTemp) then Break;
      cTemp := Copy(szTemp, i + 1, 1);
      if (cTemp <> '+') and (cTemp <> '-') and ((cTemp < '0') or (cTemp > '9'))
        then Break;
      i := i + 2;
      Continue;
    end;
    if ((c < '0') or (c > '9')) and (c <> '.') then break;
    if (c = '.') and (nBiao = 1) then break;
    if c = '.' then nBiao := 1;
    i := i + 1;
  end;
  nEnd := i;

  if nBegin >= nEnd then
    dTemp := 0.0
  else
  begin
    c := Copy(szTemp, nStart, 1);
    try
      if (c = 'E') or (c = 'e') then dTemp := 0.0
      else dTemp := StrToFloat(Copy(szTemp, nStart, nEnd - nStart));
    except
      dTemp := 0.0;
    end;
  end;
  StringToDoubleF := StrToFloat(FormatFloat2(QTY_FMT, dTemp));
end;

function FormatFloat2(AFormat: string; Source: Double): string;
var
  efTemp: extended;
begin
  efTemp := StrToFloat(FloatToStr(Source));
  Result := FormatFloat(AFormat, efTemp);
end;

function StringToQty(szInString: string): Double;
var
  i, nStart, nBegin, nEnd, nBiao: Integer;
  szTemp, c, cTemp: string;
  dTemp: Double;
begin
  { check string empty }
  if StringEmpty(szInString) then
  begin
    StringToQty := 0.0;
    Exit;
  end;

  { check ' ' in first, get nBegin }
  szTemp := szInString + '!';
  for i := 1 to Length(szTemp) do
  begin
    if Copy(szTemp, i, 1) <> ' ' then break;
  end;
  nBegin := i;

  { check not 0..9, get nEnd }
  nBiao := 0;
  nStart := nBegin;
  if Copy(szTemp, nBegin, 1) = '-' then nBegin := nBegin + 1;
  i := nBegin;
  while i <= Length(szTemp) do
  begin
    c := Copy(szTemp, i, 1);
    if (c = 'E') or (c = 'e') then
    begin
      if i = Length(szTemp) then Break;
      cTemp := Copy(szTemp, i + 1, 1);
      if (cTemp <> '+') and (cTemp <> '-') and ((cTemp < '0') or (cTemp > '9'))
        then Break;
      i := i + 2;
      Continue;
    end;
    if ((c < '0') or (c > '9')) and (c <> '.') then break;
    if (c = '.') and (nBiao = 1) then break;
    if c = '.' then nBiao := 1;
    i := i + 1;
  end;
  nEnd := i;

  if nBegin >= nEnd then
    dTemp := 0.0
  else
  begin
    c := Copy(szTemp, nStart, 1);
    try
      if (c = 'E') or (c = 'e') then dTemp := 0.0
      else dTemp := StrToFloat(Copy(szTemp, nStart, nEnd - nStart));
    except
      dTemp := 0.0;
    end;
  end;
  StringToQty := StrToFloat(FormatFloat2(QTY_FMT, dTemp));
end;

function DoubleToString(dIn: Double): string;
begin
  Result := FloatToStr(StrToFloat(FormatFloat2(QTY_FMT, dIn)));
end;

function FormatFour(dTemp: Double): Double;
begin
  Result := StringToDoubleF(FormatFloat2(QTY_FMT, dTemp));
end;

function StringToDateTime(const S: string; DefaultDate: TDateTime = 0): TDateTime;
var
  Pos: Integer;
begin
  Pos := 1;
  if not ScanDate(Trim(S), Pos, Result) or (Pos <= Length(Trim(S))) then
    Result := DefaultDate;
end;

function ScanDate(const S: string; var Pos: Integer;
  var Date: TDateTime): Boolean;
var
  DateOrder: TDateOrder;
  N1, N2, N3, Y, M, D: Word;
  L1, L2, L3, YearLen: Byte;
  EraName : string;
  EraYearOffset: Integer;
  CenturyBase: Integer;

  function EraToYear(Year: Integer): Integer;
  begin
    if SysLocale.PriLangID = LANG_KOREAN then
    begin
      if Year <= 99 then
        Inc(Year, (CurrentYear + Abs(EraYearOffset)) div 100 * 100);
      if EraYearOffset > 0 then
        EraYearOffset := -EraYearOffset;
    end
    else
      Dec(EraYearOffset);
    Result := Year + EraYearOffset;
  end;

begin
  Y := 0;
  M := 0;
  D := 0;
  YearLen := 0;
  Result := False;
  DateOrder := GetDateOrder(FormatSettings.ShortDateFormat);
  EraYearOffset := 0;
  if FormatSettings.ShortDateFormat[1] = 'g' then  // skip over prefix text
  begin
    ScanToNumber(S, Pos);
    EraName := Trim(Copy(S, 1, Pos-1));
    EraYearOffset := GetEraYearOffset(EraName);
  end
  else
    if AnsiPos('e', FormatSettings.ShortDateFormat) > 0 then
      EraYearOffset := EraYearOffsets[1];
  if not (ScanNumber(S, Pos, N1, L1) and ScanChar(S, Pos, FormatSettings.DateSeparator) and
    ScanNumber(S, Pos, N2, L2)) then Exit;
  if ScanChar(S, Pos, FormatSettings.DateSeparator) then
  begin
    if not ScanNumber(S, Pos, N3, L3) then Exit;
    case DateOrder of
      doMDY: begin Y := N3; YearLen := L3; M := N1; D := N2; end;
      doDMY: begin Y := N3; YearLen := L3; M := N2; D := N1; end;
      doYMD: begin Y := N1; YearLen := L1; M := N2; D := N3; end;
    end;
    if EraYearOffset > 0 then
      Y := EraToYear(Y)
    else if (YearLen <= 2) then
    begin
      CenturyBase := CurrentYear - FormatSettings.TwoDigitYearCenturyWindow;
      Inc(Y, CenturyBase div 100 * 100);
      if (FormatSettings.TwoDigitYearCenturyWindow > 0) and (Y < CenturyBase) then
        Inc(Y, 100);
    end;
  end else
  begin
    Y := CurrentYear;
    if DateOrder = doDMY then
    begin
      D := N1; M := N2;
    end else
    begin
      M := N1; D := N2;
    end;
  end;
  ScanChar(S, Pos, FormatSettings.DateSeparator);
  ScanBlanks(S, Pos);
  if SysLocale.FarEast and (System.Pos('ddd', FormatSettings.ShortDateFormat) <> 0) then
  begin     // ignore trailing text
    if CharInSet(FormatSettings.ShortTimeFormat[1], ['0'..'9']) then  // stop at time digit
      ScanToNumber(S, Pos)
    else  // stop at time prefix
      repeat
        while (Pos <= Length(S)) and (S[Pos] <> ' ') do Inc(Pos);
        ScanBlanks(S, Pos);
      until (Pos > Length(S)) or
        (AnsiCompareText(FormatSettings.TimeAMString, Copy(S, Pos, Length(FormatSettings.TimeAMString))) = 0) or
        (AnsiCompareText(FormatSettings.TimePMString, Copy(S, Pos, Length(FormatSettings.TimePMString))) = 0);
  end;
  Result := DoEncodeDate(Y, M, D, Date);
end;

function GetDateOrder(const DateFormat: string): TDateOrder;
var
  I: Integer;
begin
  Result := doMDY;
  I := 1;
  while I <= Length(DateFormat) do
  begin
    case Chr(Ord(DateFormat[I]) and $DF) of
      'E': Result := doYMD;
      'Y': Result := doYMD;
      'M': Result := doMDY;
      'D': Result := doDMY;
    else
      Inc(I);
      Continue;
    end;
    Exit;
  end;
  Result := doMDY;
end;

procedure ScanToNumber(const S: string; var Pos: Integer);
begin
  while (Pos <= Length(S)) and not (CharInSet(S[Pos], ['0'..'9'])) do
  begin
    if CharInSet(S[Pos], LeadBytes) then Inc(Pos);
    Inc(Pos);
  end;
end;

function GetEraYearOffset(const Name: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(EraNames) to High(EraNames) do
  begin
    if EraNames[I] = '' then Break;
    if AnsiStrPos(PChar(EraNames[I]), PChar(Name)) <> nil then
    begin
      Result := EraYearOffsets[I];
      Exit;
    end;
  end;
end;

function ScanNumber(const S: string; var Pos: Integer;
  var Number: Word; var CharCount: Byte): Boolean;
var
  I: Integer;
  N: Word;
begin
  Result := False;
  CharCount := 0;
  ScanBlanks(S, Pos);
  I := Pos;
  N := 0;
  while (I <= Length(S)) and (CharInSet(S[I], ['0'..'9'])) and (N < 1000) do
  begin
    N := N * 10 + (Ord(S[I]) - Ord('0'));
    Inc(I);
  end;
  if I > Pos then
  begin
    CharCount := I - Pos;
    Pos := I;
    Number := N;
    Result := True;
  end;
end;

function ScanChar(const S: string; var Pos: Integer; Ch: Char): Boolean;
begin
  Result := False;
  ScanBlanks(S, Pos);
  if (Pos <= Length(S)) and (S[Pos] = Ch) then
  begin
    Inc(Pos);
    Result := True;
  end;
end;

procedure ScanBlanks(const S: string; var Pos: Integer);
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(S)) and (S[I] = ' ') do Inc(I);
  Pos := I;
end;

function DoEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
var
  I: Integer;
  DayTable: PDayTable;
begin
  Result := False;
  DayTable := @MonthDays[IsLeapYear(Year)];
  if (Year >= 1) and (Year <= 9999) and (Month >= 1) and (Month <= 12) and
    (Day >= 1) and (Day <= DayTable^[Month]) then
  begin
    for I := 1 to Month - 1 do Inc(Day, DayTable^[I]);
    I := Year - 1;
    Date := I * 365 + I div 4 - I div 100 + I div 400 + Day - DateDelta;
    Result := True;
  end;
end;

function StringToDouble(szInString: string; sFormat: String='0.0000'): Double;
var
  i, nStart, nBegin, nEnd, nBiao: Integer;
  szTemp, c, cTemp: string;
  dTemp : Double;
begin
  dTemp := 0;

  { check string empty }
  if StringEmpty (szInString) then
  begin
    Result := 0.0;
    Exit;
  end;

  { check ' ' in first, get nBegin }
  szTemp := szInString + '!';
  for i := 1 to Length (szTemp) do
  begin
    if Copy (szTemp, i, 1) <> ' ' then break;
  end;
  nBegin := i;

  { check not 0..9, get nEnd }
  nBiao := 0;
  nStart := nBegin;
  if Copy (szTemp, nBegin, 1) = '-' then nBegin := nBegin + 1;
  i := nBegin;
  while i <= Length (szTemp) do
  begin
    c := Copy (szTemp, i, 1);
    if (c = 'E') or (c = 'e') then
    begin
      if i = Length (szTemp) then
        Break;
      cTemp := Copy (szTemp, i+1, 1);
      if (cTemp <> '+') and (cTemp <> '-') and ((cTemp < '0') or (cTemp > '9')) then
        Break;
      i := i + 2;
      Continue;
    end;
    if ((c < '0') or (c > '9')) and (c <> '.') then break;
    if (c = '.') and (nBiao = 1) then break;
    if c = '.' then nBiao := 1;
    i := i + 1;
  end;
  nEnd := i;

  if not (nBegin >= nEnd) then
  begin
    c := Copy (szTemp, nStart, 1);
    if (c = 'E') or (c = 'e') then dTemp := 0.0
    else dTemp := StrToFloat (Copy (szTemp, nStart, nEnd-nStart));
  end;

  Result := StrToFloat(FormatFloat(sFormat,dTemp));
end;

function StringToTotal(szInString: string): Extended;
var
  i, nStart, nBegin, nEnd, nBiao: Integer;
  szTemp, c, cTemp: string;
  dTemp: Double;
begin
  { check string empty }
  if StringEmpty(szInString) then
  begin
    StringToTotal := 0.0;
    Exit;
  end;

  { check ' ' in first, get nBegin }
  szTemp := szInString + '!';
  for i := 1 to Length(szTemp) do
  begin
    if Copy(szTemp, i, 1) <> ' ' then break;
  end;
  nBegin := i;

  { check not 0..9, get nEnd }
  nBiao := 0;
  nStart := nBegin;
  if Copy(szTemp, nBegin, 1) = '-' then nBegin := nBegin + 1;
  i := nBegin;
  while i <= Length(szTemp) do
  begin
    c := Copy(szTemp, i, 1);
    if (c = 'E') or (c = 'e') then
    begin
      if i = Length(szTemp) then Break;
      cTemp := Copy(szTemp, i + 1, 1);
      if (cTemp <> '+') and (cTemp <> '-') and ((cTemp < '0') or (cTemp > '9'))
        then Break;
      i := i + 2;
      Continue;
    end;
    if ((c < '0') or (c > '9')) and (c <> '.') then break;
    if (c = '.') and (nBiao = 1) then break;
    if c = '.' then nBiao := 1;
    i := i + 1;
  end;
  nEnd := i;

  if nBegin >= nEnd then
    dTemp := 0.0
  else
  begin
    c := Copy(szTemp, nStart, 1);
    try
      if (c = 'E') or (c = 'e') then dTemp := 0.0
      else dTemp := StrToFloat(Copy(szTemp, nStart, nEnd - nStart));
    except
      dTemp := 0.0;
    end;
  end;
  StringToTotal := StrToFloat(FormatFloat2(TOTAL_FMT, dTemp));
end;

function StringToTaxPrice(szInString: string): Double;
var
  i, nStart, nBegin, nEnd, nBiao: Integer;
  szTemp, c, cTemp: string;
  dTemp: Double;
begin
  { check string empty }
  if StringEmpty(szInString) then
  begin
    StringToTaxPrice := 0.0;
    Exit;
  end;

  { check ' ' in first, get nBegin }
  szTemp := szInString + '!';
  for i := 1 to Length(szTemp) do
  begin
    if Copy(szTemp, i, 1) <> ' ' then break;
  end;
  nBegin := i;

  { check not 0..9, get nEnd }
  nBiao := 0;
  nStart := nBegin;
  if Copy(szTemp, nBegin, 1) = '-' then nBegin := nBegin + 1;
  i := nBegin;
  while i <= Length(szTemp) do
  begin
    c := Copy(szTemp, i, 1);
    if (c = 'E') or (c = 'e') then
    begin
      if i = Length(szTemp) then Break;
      cTemp := Copy(szTemp, i + 1, 1);
      if (cTemp <> '+') and (cTemp <> '-') and ((cTemp < '0') or (cTemp > '9'))
        then Break;
      i := i + 2;
      Continue;
    end;
    if ((c < '0') or (c > '9')) and (c <> '.') then break;
    if (c = '.') and (nBiao = 1) then break;
    if c = '.' then nBiao := 1;
    i := i + 1;
  end;
  nEnd := i;

  if nBegin >= nEnd then
    dTemp := 0.0
  else
  begin
    c := Copy(szTemp, nStart, 1);
    if (c = 'E') or (c = 'e') then dTemp := 0.0
    else dTemp := StrToFloat(Copy(szTemp, nStart, nEnd - nStart));
  end;

  StringToTaxPrice := StrToFloat(FormatFloat2(GetSystemDecimal, dTemp));
end;

function TaxPriceDoubleToString(dIn: Double): string;
begin
  Result := FormatFloat2(GetSystemDecimal, dIn);
end;

function FormatTwo(dTemp: Double): Double;
begin
  Result := StringToDoubleF(FormatFloat2(TOTAL_FMT, dTemp));
end;

function DoubletoStringFMT(FMT: string; dIn: Double): string;
var
  sResult: string;
  iPos, iDecimal, iCount: Integer;
begin
  if dIn = 0 then
    Result := '0'
  else
  begin
    sResult := FormatFloat2(FMT, dIn);

    iPos := Pos('.',sResult);
    if iPos <= 0 then //如果没有小数了，就直接返回了
    begin
      Result := sResult;
    end
    else
    begin
      iCount := iPos + 1;
      iDecimal := iPos;
      while (iCount <= Length(sResult)) do
      begin
        if sResult[iCount] <> '0' then
          iDecimal := iCount;
        Inc(iCount);
      end;

      if iDecimal >= iPos+1 then
        Result := Copy(sResult,1,iDecimal)
      else
        Result := Copy(sResult,1,iPos-1);
    end;
  end;
end;

function FloatToInt(dTemp: double): longint;
var
  szTemp: string;
  i: integer;
  Flag: boolean;
begin
  szTemp := FloatToStr(dTemp);
  Flag := False;
  for i := 1 to Length(szTEmp) do
    if Copy(szTemp, i, 1) = '.' then
    begin
      break;
      Flag := True;
    end;
  if Flag then szTemp := Copy(szTemp, 1, i - 1)
  else szTemp := Copy(szTemp, 1, i);
  Result := StringToInt(szTemp);
end;

function FloatToInt2(dTemp: double):longint;
begin
  if dTemp >= 0 then
    Result := FloatToInt(dTemp)
  else if -FloatToInt(-dTemp) = dTemp then
    Result := -FloatToInt(-dTemp)
  else
    Result := -FloatToInt(-dTemp) - 1;
end;

function GetSystemDecimal: string;
begin
  case StrtoIntDef(GetSysValue('Numeric'), 6) of
    5:  Result :=  PRICE5_FMT;
    6:  Result :=  PRICE6_FMT;
    7:  Result :=  PRICE7_FMT;
    8:  Result :=  PRICE8_FMT;
    else
     Result :=  PRICE6_FMT;
  end;
end;

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

//处理文件路径为文件名
function DoFileNameStr(FileName: string): string;
var
  fFileName : string;
  index : Integer;
begin
  fFileName := FileName;
  index := Pos('\', fFileName);
  while index <> 0 do
  begin
    fFileName := Copy(fFileName, index + 1, Length(fFileName) - index);
    index := Pos('\', fFileName);
  end;
  Result := fFileName;
end;

function RefToCell(ROwID: Integer; ColID: Integer):string;
var
  ACount,APos:Integer;
begin
  ACount:=ColID div 26;
  APos:=ColID mod 26;
  if APos = 0 then
  begin
    ACount:=ACount-1;
    APos:=26;
  end;
  if ACount = 0 then
    Result:=Chr(Ord('A')+ColID-1) +IntToStr(ROwID);
  if ACount = 1 then
    Result:='A'+Chr(Ord('A')+APos-1) +IntToStr(ROwID);
  if ACount >1 then
    Result:=Chr(Ord('A')+ACount-1)+Chr(Ord('A')+APos-1) +IntToStr(ROwID);
end;
end.
