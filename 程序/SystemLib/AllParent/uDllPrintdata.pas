//打印接口
unit uDllPrintdata;

interface

uses Forms, SysUtils, Controls, DB, DBClient, uDllDataBaseIntf, uDllDBService, uBasalMethod, StdCtrls,
     XwGjpBasicCom, XWComponentType, crReportIntf, uDllMessageIntf, XwGGeneralGrid, XwGGeneralWGrid,
     XwTable, Math, ugpStdGrids, ugpDbDefines, Classes, uTransformFunc, xwbasicinfoclassdefine_c,
     xwGTypeDefine, uCMEventHander, Variants, uDllExistIntf, uDataStructure, jpeg, Generics.Collections,
     CMFenBuBiaoGrid, StrUtils;

const
  cHideTotal = '****';  //Add By Guiyun 2008-03-27
  cRowCaption = '行号';
  cTotalCaption = '合 计';
  //打印管理器限制在31个英文字符
  cMaxLen = 31;  //导出数据到Excel时,字段名的最大长度(超过52,TClientDataSet.CreateDataSet会报错"Invalid Filed Size")
  cNumLen = 3;   //导出数据到Excel时,字段名相同时,添加序号的最大长度


function GetFieldSize(StrGrd: TCMXwAlignGrid; Col: integer): integer; overload;
function GetFieldSize(StrGrd: TXwGGeneralGrid; AColumn: TgpCustomStdColumn; IncludeTotalRow: Boolean = False): integer; overload;
function GetFieldSize(StrGrd: TXwGGeneralWGrid; AColumn: TgpCustomStdColumn; IncludeTotalRow: Boolean = False): integer; overload;
function StandardLoadData(f: TForm; NewSysInfo: Boolean; szRwxFile: string = ''; OnlyVisibleCol: Boolean = False): Boolean;
function FindRealGridColByPrint(aGrid : TXwGGeneralWGrid; aszPrint : string) : integer;
function FindTitleRepeat(nFieldNum: Integer; Fields: array of TTable_b): Boolean;

//调打印管理器
procedure RunPrintManage(szRwxFile: string = '');
//调打印管理器，但不显示打印管理器
procedure RunPrintManageAtOnce(szRwxFile: string = '');
//打印预览
procedure RunPrintPrive(szRwxFile: string = '');
//直接打印
function RunPrintNoManage(szRwxFile: string = ''): Boolean;
//导出到Excel
procedure RunPrintExportToExcel(OwnerForm: TComponent; szRwxFile: string = '');
//打印设置
procedure RunPrintSetUp(szRwxFile: string = '');
//受立即打印配置影响的打印接口
procedure RunPrintByConfig(szRwxFile: string = '');

//以下用于自动创建模版，并打印
procedure AddTemplatePageHeader(szRwxFile: string; var TemplateIntf: IcrTemplateIntf);
procedure AddPageDetail(var TemplateIntf: IcrTemplateIntf);
procedure RunAutoTemplatePrint(szRwxFile: string = '');

procedure StandardPrint(f: TForm; szRwxFile: string = ''; acMode : Char = 'P');
procedure StandardExportToExcel(f: TForm; szRwxFile: string = '');

procedure GetTableB(nFieldCount: Integer; Fields: array of TTable_b; AImageDataSet: TClientDataSet = nil);
procedure GetTableM(mygrid: TXwGGeneralGrid; BYesCount: Boolean = False); overload;
procedure GetTableM(mygrid: TXwGGeneralWGrid; BYesCount: Boolean = False); overload;
procedure GetTableM(mygrid: TCMFenbubiaoGrid; BYesCount: Boolean = False); overload;
procedure GetTableM(mygrid: TXwGGeneralWGrid; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>; szKtypeID: string); overload;
procedure GetTableM(mygrid1, mygrid2: TXwGGeneralWGrid; Separator: String); overload;
procedure GetTableM(mygrid: TCMXwAlignGrid); overload;
procedure GetTableM(MyGrid: TCMXwAlignGrid; BYesCount: Boolean); overload;
procedure GetTableM(mygrid: TXwGGeneralWGrid; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>; BYesCount: Boolean = False); overload;
procedure GetTableM(mygrid1, mygrid2: TXwGGeneralWGrid; Separator: String; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>); overload;
procedure CreateFieldDefs(myGrid1, myGrid2: TXwGGeneralWGrid; UniteSameCol: array of string; var anFieldCount :integer;
    var anLength: array of integer; var aszField: array of string; var FMainPrintColumn, FOtherPrintColumn: TStrings);
procedure CreateGridHeaderData(mygrid: TXwGGeneralGrid; RowIndex:Integer; var ArrHeader: TPrintHeaderList);

//新打印功能
procedure GetPtypeQRCode(mygrid: TXwGGeneralWGrid; ARow: Integer; var AStream: TMemoryStream);
function GetGridTable(mygrid: TXwGGeneralGrid; BYesCount: Boolean = False): OleVariant; overload;
function GetGridTable(mygrid: TXwGGeneralWGrid; BYesCount: Boolean = False): OleVariant; overload;
function GetGridTable(mygrid: TXwGGeneralWGrid; RowIndex:Integer ;BYesCount: Boolean = False): OleVariant; overload;
function GetGridTable(mygrid: TCMFenbubiaoGrid; BYesCount: Boolean = False): OleVariant; overload;
function GetGridTable(mygrid: TXwGGeneralWGrid; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>; szKtypeID: string): OleVariant; overload;
function GetGridTable(mygrid: TCMXwAlignGrid; BYesCount: Boolean = False): OleVariant; overload;
function GetGridTable(mygrid: TXwGGeneralWGrid; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>; BYesCount: Boolean = False): OleVariant; overload;
function GetHeaderData(AForm: TForm; ATitle: string; AImageDataSet: TClientDataSet; FAfterLoadPrintHeader: TAfterLoadPrintHeaderEvent = nil): OleVariant;
function GetPtypeImageDataSet(PtypeId: string): TClientDataSet;
//序列号
function GetSerialNoStr(sGuid: string; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>): string;

//function CheckOldPrint: Boolean;

var
  cdsHeader, cdsDetail: TClientDataSet;

implementation

uses uDllComm, uDllSystemIntf, uCMQRCodeBox;


function StandardLoadData(f: TForm; NewSysInfo: Boolean; szRwxFile: string = ''; OnlyVisibleCol: Boolean = False): Boolean;
var
  i, j: Integer;
  TitleArray: array[0..1000] of TTable_b;
begin
  j := -1;

  if NewSysInfo then
  begin
    Inc(j);
    TitleArray[j].szFieldName := '系统日期';
    TitleArray[j].nLength := 10;
    TitleArray[j].szValue := FormatDateTime('yyyy-mm-dd', Date);

    Inc(j);
    TitleArray[j].szFieldName := '系统时间';
    TitleArray[j].nLength := 10;
    TitleArray[j].szValue := FormatDateTime('hh:nn:ss', Time);

    Inc(j);
    TitleArray[j].szFieldName := '登录日期';
    TitleArray[j].nLength := 10;
    TitleArray[j].szValue := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);

    Inc(j);
    TitleArray[j].szFieldName := '操作员';
    TitleArray[j].nLength := Length(AnsiString(GetCurrentOperatorName));
    TitleArray[j].szValue := GetCurrentOperatorName;

    Inc(j);
    TitleArray[j].szFieldName := '公司名称';
    TitleArray[j].szValue     := GetSysValue('companyfullname');
    TitleArray[j].nLength     := Length(AnsiString(TitleArray[j].szValue));

    Inc(j);
    TitleArray[j].szFieldName := '公司地址';
    TitleArray[j].szValue     := GetSysValue('address');
    TitleArray[j].nLength     := Length(AnsiString(TitleArray[j].szValue));

    Inc(j);
    TitleArray[j].szFieldName := '公司电话';
    TitleArray[j].szValue     := GetSysValue('tel');
    TitleArray[j].nLength     := Length(AnsiString(TitleArray[j].szValue));

    Inc(j);
    TitleArray[j].szFieldName := '会计年度';
    TitleArray[j].szValue     := GetCurrentYear;
    TitleArray[j].nLength     := 4;
  end;

  for i := 0 to f.ComponentCount - 1 do
  begin
    if not (f.Components[i] is TControl) then Continue;

    case StringIndex(f.Components[i].ClassName, C_CLASS_NAMES) of //
      -1: Continue;
      Ord(cnTLabelLabel):
        with TCMGXwLabelLabel(f.Components[i]) do
        begin
          if ((FrameWork <> fwConcatInfo) and (not Visible)) or CMNotPrint then
            Continue
          else
          begin
            Inc(j);
            TitleArray[j].szFieldName := LabelCaption;
            TitleArray[j].nLength := Length(AnsiString(LabelText));
            TitleArray[j].szValue := LabelText;
          end;
        end;
      Ord(cnTLabelMemo):
        with TCMGLabelMemo(f.Components[i]) do
        begin
          Inc(j);
          TitleArray[j].szFieldName := Caption;
          TitleArray[j].nLength := Length(AnsiString(Text));
          TitleArray[j].szValue := Text;
        end;
      Ord(cnTLabelComboBox):
        with TCMGLabelComBox(f.Components[i]) do
        begin
          Inc(j);
          TitleArray[j].szFieldName := Caption;
          TitleArray[j].nLength := Length(AnsiString(Text));
          TitleArray[j].szValue := Text;
        end;
      Ord(cnTLabelValueComboBox):
        with TCMGLabelValueComBox(f.Components[i]) do
        begin
          Inc(j);
          TitleArray[j].szFieldName := Caption;
          TitleArray[j].nLength := Length(AnsiString(Text));
          TitleArray[j].szValue := Text;
        end;
      Ord(cnTLabelBtnEdit):
        with TCMGLabelBtnEdit(f.Components[i]) do
        begin
          if Trim(Caption) = '' then Continue;
          Inc(j);
          TitleArray[j].szFieldName := Caption;
          TitleArray[j].nLength := Length(AnsiString(Text));
          TitleArray[j].szValue := Text;
        end;
      Ord(cnTLabelEmptyDate):
        with TCMGLabelEmptyDate(f.Components[i]) do
        begin
          Inc(j);
          TitleArray[j].szFieldName := Caption;
          TitleArray[j].nLength := 10;
          if Checked then
            TitleArray[j].szValue := FormatDateTime('yyyy-mm-dd', Date)
          else
            TitleArray[j].szValue := '';
        end;
      Ord(cnTLabelClearDate):
        with TCMGLabelClearDate(f.Components[I]) do
        begin
          Inc(j);
          TitleArray[j].szFieldName := Caption;
          TitleArray[j].nLength := 10;
          TitleArray[j].szValue := DateStr;
        end; // with
      Ord(cnTGeneralGrid):
        begin
          if TXwGGeneralGrid(f.Components[i]).Visible then
            GetTableM(TXwGGeneralGrid(f.Components[i]));
        end;
      Ord(cnTGeneralWGrid):
        begin
          if TXwGGeneralWGrid(f.Components[i]).Visible then
            GetTableM(TXwGGeneralWGrid(f.Components[i]));
        end;
      Ord(cnTCMXwAlignGrid):
        begin
          if TCMXwAlignGrid(f.Components[i]).Visible then
          begin
            if OnlyVisibleCol then
              GetTableM(TCMXwAlignGrid(f.Components[i]), OnlyVisibleCol)
            else
              GetTableM(TCMXwAlignGrid(f.Components[i]));
          end;
        end;
    end; // case
  end;

  GetTableB(J, TitleArray, nil);

  Result := True;
end;

procedure RunPrintManage(szRwxFile: string = '');
var
  ReportIntf: IcrReport;
begin
  try
    ReportIntf := crReportIntf.CreateReport;

    with ReportIntf do
    begin
      OwnerAppHandle := Application.Handle;
      MasterData := cdsHeader.Data;
      SetDetailDataByIndex(cdsDetail.Data, 0);
      TemplateName := ShortString(szRwxFile);
      ShowPrintDialog := True;
      Execute;
    end;
  finally
    ReportIntf := nil;
  end;
end;

procedure RunPrintManageAtOnce(szRwxFile: string = '');
var
  ReportIntf: IcrReport;
begin
  try
    ReportIntf := crReportIntf.CreateReport;

    with ReportIntf do
    begin
      OwnerAppHandle := Application.Handle;
      MasterData := cdsHeader.Data;
      SetDetailDataByIndex(cdsDetail.Data, 0);
      TemplateName := ShortString(szRwxFile);
      ShowPrintDialog := False;
      Print;
    end;
  finally
    ReportIntf := nil;
  end;
end;

procedure RunPrintPrive(szRwxFile: string = '');
var
  ReportIntf: IcrReport;
begin
  try
    ReportIntf := crReportIntf.CreateReport;

    with ReportIntf do
    begin
      OwnerAppHandle := Application.Handle;
      MasterData := cdsHeader.Data;
      SetDetailDataByIndex(cdsDetail.Data, 0);
      TemplateName := ShortString(szRwxFile);
      Preview;
    end;
  finally
    ReportIntf := nil;
  end;
end;

function RunPrintNoManage(szRwxFile: string = ''): Boolean;
var
  ReportIntf: IcrReport;
begin
  try
    Result := False;
    ReportIntf := crReportIntf.CreateReport;

    with ReportIntf do
    begin
      OwnerAppHandle := Application.Handle;
      MasterData := cdsHeader.Data;
      SetDetailDataByIndex(cdsDetail.Data, 0);
      TemplateName := ShortString(szRwxFile);
      Print;

      Result := (LastErrorCode >= 0) and   // <0 返回值说明打印失败
                (PrintedPageCount > 0);    // 打印页数=0说明打印被取消
    end;
  finally
    ReportIntf := nil;
  end;
end;

procedure RunPrintExportToExcel(OwnerForm: TComponent; szRwxFile: string = '');
var
  btnPrint: TCMXwPrintBtn;
begin
  btnPrint := TCMXwPrintBtn.Create(OwnerForm);
  try
    btnPrint.Header := cdsHeader.Data;
    btnPrint.DetailDataList.Clear;
    btnPrint.DetailDataList.Add(cdsDetail.Data);
    btnPrint.TemplateName := szRwxFile;

    btnPrint.ExportXLS;
  finally
    btnPrint.Free;
  end;
end;

procedure RunPrintSetUp(szRwxFile: string = '');
var
  ReportIntf: IcrReport;
begin
  try
    ReportIntf := crReportIntf.CreateReport;

    with ReportIntf do
    begin
      OwnerAppHandle := Application.Handle;
      MasterData := cdsHeader.Data;
      SetDetailDataByIndex(cdsDetail.Data, 0);
      TemplateName := ShortString(szRwxFile);
      Design;
    end;
  finally
    ReportIntf := nil;
  end;
end;

procedure RunPrintByConfig(szRwxFile: string = '');
begin
  //立即打印
  if CheckSysCon(69) then
    RunPrintManageAtOnce(szRwxFile)
  else
    RunPrintManage(szRwxFile);
end;


procedure StandardPrint(f: TForm; szRwxFile: string = ''; acMode : Char = 'P');
begin
  StandardLoadData(f, True, szRwxFile);
  RunPrintManage(szRwxFile);
end;

procedure StandardExportToExcel(f: TForm; szRwxFile: string = '');
begin
  StandardLoadData(f, True, szRwxFile);
  RunPrintExportToExcel(f, szRwxFile);
end;

function FindTitleRepeat(nFieldNum: Integer; Fields: array of TTable_b): Boolean;
var
  i: Integer;
begin
  Result := False;

  for i := 0 to nFieldNum - 1 do
  begin
    if AnsiCompareText(Fields[nFieldNum].szFieldName, Fields[i].szFieldName) = 0 then //不区分大小写
    begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure GetTableB(nFieldCount: Integer; Fields: array of TTable_b; AImageDataSet: TClientDataSet = nil);
var
  szTemp: string;
  nTemp, n, i, nCount: Integer;
begin
  cdsHeader.Close;
  cdsHeader.FieldDefs.Clear;
  if nFieldCount <= 0 then Exit;

  for i := 0 to nFieldCount do
  begin
    nCount := 1;

    while FindTitleRepeat(i, Fields) do
    begin
      Fields[i].szFieldName := Fields[i].szFieldName + IntToStr(nCount);
      Inc(nCount);
    end;
  end;

  try
    try
      for n := 0 to nFieldCount do
      begin
        szTemp := fields[n].szFieldName;
        if szTemp = '' then Continue;
        nTemp := Length(AnsiString(Fields[n].szValue)) + 1; //fields[n].nLength + 1;
        cdsHeader.FieldDefs.Add(szTemp, ftWideString, nTemp);
      end;

      if Assigned(AImageDataSet) then
      begin
        for I := 0 to AImageDataSet.FieldDefs.Count - 1 do
        begin
          cdsHeader.FieldDefs.Add(AImageDataSet.FieldDefs[i].Name, ftBlob);
        end;
      end;

      try
        cdsHeader.CreateDataSet;
      except
        ShowWarningMsg('生成表头字段失败。');
        cdsHeader.FieldDefs.Clear;
        Exit;
      end;

      cdsHeader.Append;
      for n := 0 to nFieldCount do
      begin
        szTemp := fields[n].szValue;
        if fields[n].szFieldName = '' then Continue;
        cdsHeader.Fields.FieldByName(fields[n].szFieldName).Value := szTemp;
      end;

      if Assigned(AImageDataSet) then
      begin
        for I := 0 to  AImageDataSet.FieldDefs.Count - 1 do
        begin
          cdsHeader.FieldByName(AImageDataSet.FieldDefs[i].Name).Value := AImageDataSet.FieldByName(AImageDataSet.FieldDefs[i].Name).Value;
        end;
      end;

      cdsHeader.Post;
    except
      ShowWarningMsg('生成表头打印数据失败。');
      cdsHeader.Close;
      cdsHeader.FieldDefs.Clear;
    end;
  finally
  end;
end;

procedure GetTableM(mygrid: TXwGGeneralGrid; BYesCount: Boolean = False);
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, printVisible: boolean;
  lEndRow: Integer;
  FPrintColumn: TStrings;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
begin
  cdsDetail.Close;
  cdsDetail.FieldDefs.Clear;
  FillChar(szFields, sizeof(szFields), 0);
  printVisible := CheckSysCon(118);

  FPrintColumn := TStringList.Create;
  try
    with mygrid do
    begin
      try
        nField := 0;

        //加一个行号列
        FPrintColumn.Add('-100');
        cdsDetail.FieldDefs.Add(cRowCaption, ftWideString, 30);

        for i := 0 to ColumnsCount - 1 do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        begin
          if Columns[i].Expanded then
            Continue;

          if printVisible and (not Columns[i].Visible) then
            Continue;

          if (Columns[i].ValueExpression = '') and (not IsFieldCanPrint(Columns[i].FieldName)) then
            Continue;

          szTemp := CMPrintName(Columns[i]); //TrimRight(CMColumnFieldType(Columns[i]).Caption);

          if Trim(szTemp) = '' then
            Continue;

          Inc(nField);
          if nField >= 254 then
            Break;

          if szTemp = '' then
            szTemp := 'Rwx';
          if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
          begin
            Flag := False;
            for k := 1 to (cMaxLen - cNumLen) do
            begin
              if Ord(szTemp[k]) >= 127 then
                Flag := not Flag;
            end;
            if Flag then
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen + 1)
            else
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
          end;

          szTemp1 := szTemp;
          nEnd := 1;
          while True do
          begin
            bFlag := True;
            for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
            begin
              if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
              begin
                bFlag := False;
                szTemp1 := szTemp + IntToStr(nEnd);
                inc(nEnd);
                Break;
              end;
            end; //End for M
            if bFlag then
              Break;
          end;

          szFields[nField] := ShortString(szTemp1);
          FPrintColumn.Add(IntToStr(i));
          nWidth := GetFieldSize(mygrid, Columns[i]) + 1;
          cdsDetail.FieldDefs.Add(szTemp1, ftWideString, nWidth);
        end;

        try
          cdsDetail.CreateDataSet;
        except
          ShowWarningMsg('生成表体字段失败。');
          cdsDetail.FieldDefs.Clear;
          Exit;
        end;

        Screen.Cursor := TCursor(-11);
        lEndRow := -1;
        for i := DataRowCount - 1 downto 0 do
        begin
          if not CMRowIsBlank(i) then
          begin
            lEndRow := i;
            Break;
          end;
        end;

        for i := 0 to lEndRow do
        begin
          cdsDetail.Append;

          for j := 0 to FPrintColumn.Count - 1 do
          begin
            if j = 0 then
              cdsDetail.Fields[j].AsString := IntToStr(i + 1)
            else
            begin
              if Columns[StringToInt(FPrintColumn.Strings[j])].ValueExpression <> '' then
                cdsDetail.Fields[j].AsString := GetCellText(Columns[StringToInt(FPrintColumn.Strings[j])], i)
              else
                cdsDetail.Fields[j].AsString := CMGetCellPrintByDBName(Columns[StringToInt(FPrintColumn.Strings[j])].FieldName, i);
            end;
          end;

          cdsDetail.Post;
        end;

        if BYesCount then
        begin
          if Footer { and mygrid.PrintTotal} then
          begin
            cdsDetail.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cdsDetail.Fields[0].AsString := cTotalCaption
              else
              begin
                if gcoHideContent in Columns[StringToInt(FPrintColumn.Strings[j])].ColumnOptions then
                  cdsDetail.Fields[j].AsString := cHideTotal
                else
                begin
                  if StringToDouble(Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue, TotalFormatStr) = 0 then
                    cdsDetail.Fields[j].AsString := ''
                  else
                    cdsDetail.Fields[j].AsString := Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue;
                end;
              end;
            end;
            cdsDetail.Post;
          end;
        end;

      except
        ShowWarningMsg('生成表体打印数据失败。');
        cdsDetail.Close;
        cdsDetail.FieldDefs.Clear;
      end;
    end;
  finally
    FreeAndNil(FPrintColumn);
    Screen.Cursor := crDefault;
  end;
end;

procedure GetTableM(mygrid: TXwGGeneralWGrid; BYesCount: Boolean = False); overload;
begin
  cdsDetail.Data := GetGridTable(mygrid, BYesCount);
end;

procedure GetTableM(mygrid: TCMFenbubiaoGrid; BYesCount: Boolean = False); overload;
begin
  try
    Screen.Cursor := TCursor(-11);
    cdsDetail := mygrid.CMGetPrintData(True, True);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure GetTableM(mygrid: TXwGGeneralWGrid; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>; szKtypeID: string);
begin
  cdsDetail.Data := GetGridTable(mygrid, FBillSerialNo, szKtypeID);
end;

procedure GetTableM(mygrid1, mygrid2: TXwGGeneralWGrid; Separator: String); overload;
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag: boolean;
  lEndRow: Integer;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  szFieldsfhying : array of string;
  {OneEnd,} SperatorCol : integer;
  nIndex : integer;
  nReturnLength : array of Integer;
  nReturnCount : integer;
  szPrint : string;
  FMainPrintColumn, FOtherPrintColumn: TStrings;
begin
  cdsDetail.Close;
  cdsDetail.FieldDefs.Clear;
  FillChar(szFields, sizeof(szFields), 0);
  SetLength(szFieldsfhying, 255);
  SetLength(nReturnLength, 255);

  SperatorCol := 0;
  FMainPrintColumn := TStringList.Create;
  FOtherPrintColumn := TStringList.Create;
  try
    CreateFieldDefs(mygrid1, mygrid2, ['存货全名'], nReturnCount, nReturnLength, szFieldsfhying, FMainPrintColumn, FOtherPrintColumn);

    try
      nField := 0;

      for i := 0 to min(254, nReturnCount - 1) do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
      begin
        szTemp  := szFieldsfhying[i];

        if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
        begin
          Flag := False;
          for k := 1 to (cMaxLen - cNumLen) do
          begin
            if Ord(szTemp[k]) >= 127 then
              Flag := not Flag;
          end;

          if Flag then
            szTemp := Copy(szTemp, 1, cMaxLen - cNumLen+1)
          else
            szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
        end;

        szTemp1 := szTemp;
        nWidth  := nReturnLength[nField];

        Inc(nField);
        nEnd := 1;
        while True do
        begin
          bFlag := True;
          for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
          begin
            if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
            begin
              bFlag := False;
              szTemp1 := szTemp + IntToStr(nEnd);
              inc(nEnd);
              Break;
            end;
          end; //End for M

          if bFlag then
            Break;
        end;

        szFields[nField] := ShortString(szTemp1);
        cdsDetail.FieldDefs.Add(szTemp1, ftWideString, nWidth);
      end;

      try
        cdsDetail.CreateDataSet;
      except
        ShowWarningMsg('生成表体字段失败。');
        cdsDetail.FieldDefs.Clear;
        Exit;
      end;

      Screen.Cursor := crHourglass;
      lEndRow := -1;
      for i := mygrid1.DataRowCount - 1 downto 0 do
      begin
        if not mygrid1.CMRowIsBlank(i) then
        begin
          lEndRow := i;
          Break;
        end;
      end;

      for i := 0 to lEndRow do
      begin
        cdsDetail.Append;

        for j := 0 to Min(cdsDetail.Fields.Count - 1, FMainPrintColumn.Count - 1) do
        begin
          if cdsDetail.Fields[j].FieldName = GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flPFullName].Caption then
            SperatorCol := j;

          if mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])].ValueExpression <> '' then
            cdsDetail.Fields[j].AsString := mygrid1.GetCellText(mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])], i)
          else
            cdsDetail.Fields[j].AsString := mygrid1.CMGetCellPrintByDBName(mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])].FieldName, i);
        end;

        cdsDetail.Post;
      end;

//      OneEnd := lEndRow + 1;

      //表格1加合计行
      if mygrid1.Footer then
      begin
        cdsDetail.Append;

        for j := 0 to Min(cdsDetail.Fields.Count - 1, FMainPrintColumn.Count - 1) do
        begin
          if cdsDetail.Fields[j].FieldName = GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flPFullName].Caption then
          begin
            cdsDetail.Fields[j].AsString := cTotalCaption;
            Continue;
          end;

          if gcoHideContent in mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])].ColumnOptions then
            cdsDetail.Fields[j].AsString := cHideTotal
          else
            cdsDetail.Fields[j].AsString := mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])].FooterValue;
        end;

        cdsDetail.Post;
      end;

//      Inc(OneEnd);

      ///////////////////////////////////////////////////////////
      lEndRow := -1;
      for i := mygrid2.DataRowCount - 1 downto 0 do
      begin
        if not mygrid2.CMRowIsBlank(i) then
        begin
          lEndRow := i;
          Break;
        end;
      end;

      // 空行
      if lEndRow >= 0 then
      begin
        cdsDetail.Append;
        cdsDetail.Fields[SperatorCol].AsString := Separator;
        cdsDetail.Post;
      end;

      for i := 0 to lEndRow do
      begin
        cdsDetail.Append;

        for j := 0 to Min(cdsDetail.Fields.Count - 1, FOtherPrintColumn.Count - 1) do
        begin
          if StrToIntDef(FOtherPrintColumn.Strings[j], 0) < 0 then
            Continue;

          szPrint := myGrid2.CMColumnFieldType(myGrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])]).Caption;
          nIndex  := cdsDetail.FieldDefs.IndexOf(szPrint);

          if nIndex = -1 then
            Continue;

          if mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])].ValueExpression <> '' then
            cdsDetail.Fields[j].AsString := mygrid2.GetCellText(mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])], i)
          else
            cdsDetail.Fields[j].AsString := mygrid2.CMGetCellPrintByDBName(mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])].FieldName, i);
        end;

        cdsDetail.Post;
      end;

      //表格2加合计行
      if mygrid2.Footer then
      begin
        cdsDetail.Append;

        for j := 0 to Min(cdsDetail.Fields.Count - 1, FOtherPrintColumn.Count - 1) do
        begin
          if StrToIntDef(FOtherPrintColumn.Strings[j], 0) < 0 then
            Continue;

          if cdsDetail.Fields[j].FieldName = GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flPFullName].Caption then
          begin
            cdsDetail.Fields[j].AsString := cTotalCaption;
            Continue;
          end;

          szPrint := myGrid2.CMColumnFieldType(myGrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])]).Caption;
          nIndex  := cdsDetail.FieldDefs.IndexOf(szPrint);

          if nIndex = -1 then
            Continue;

          if gcoHideContent in mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])].ColumnOptions then
            cdsDetail.Fields[nIndex].AsString := cHideTotal
          else
            cdsDetail.Fields[nIndex].AsString := mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])].FooterValue;
        end;
        cdsDetail.Post;
      end;

    except
      ShowWarningMsg('生成表体打印数据失败。');
      cdsDetail.Close;
      cdsDetail.FieldDefs.Clear;
    end;
  finally
    FreeAndNil(FMainPrintColumn);
    FreeAndNil(FOtherPrintColumn);
    SetLength(szFieldsfhying, 0);
    SetLength(nReturnLength, 0);
    Screen.Cursor := crDefault;
  end;
end;


procedure GetTableM(mygrid: TCMXwAlignGrid);
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag: boolean;
  lEndRow: Integer;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  sValue: string;
begin
  cdsDetail.Close;
  cdsDetail.FieldDefs.Clear;
  FillChar(szFields, sizeof(szFields), 0);
  try
    try
      nField := 0;
      for i := 0 to Min(254, mygrid.ColCount - 1) do //解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
      begin
        szTemp := TrimRight(mygrid.Cells[i, 0]);
        szTemp := LeftString(szTemp, 30);
        if szTemp = '' then
          szTemp := 'Rwx';
        if Length(szTemp) > (cMaxLen-cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
        begin
          Flag := False;
          for k := 1 to (cMaxLen-cNumLen) do
          begin
            if Ord(szTemp[k]) >= 127 then
              Flag := not Flag;
          end;
          if Flag then
            szTemp := Copy(szTemp, 1, cMaxLen-cNumLen+1)
          else
            szTemp := Copy(szTemp, 1, cMaxLen-cNumLen);
        end;

        szTemp1 := szTemp;
        Inc(nField);
        nEnd := 1;
        while True do
        begin
          bFlag := True;
          for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
          begin
            if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
            begin
              bFlag := False;
              szTemp1 := szTemp + IntToStr(nEnd);
              inc(nEnd);
              Break;
            end;
          end; //End for M
          if bFlag then
            Break;
        end;
        szFields[nField] := ShortString(szTemp1);
        nWidth := GetFieldSize(MyGrid, i);
        cdsDetail.FieldDefs.Add(szTemp1, ftWideString, nWidth);
      end;

      try
        cdsDetail.CreateDataSet;
      except
        ShowWarningMsg('生成表体字段失败。');
        cdsDetail.FieldDefs.Clear;
        Exit;
      end;

      Screen.Cursor := crHourglass;
      Flag := False;
      lEndRow := 0;
      for i := mygrid.RowCount - 1 downto 0 do
      begin
        for j := 1 to mygrid.ColCount - 1 do
        begin
          if not StringEmpty(mygrid.Cells[j, i]) then
          begin
            Flag := True;
            break;
          end;
        end;

        if Flag then
        begin
          lEndRow := i;
          break;
        end;
      end;

      for i := 1 to lEndRow do
      begin
        cdsDetail.Append;
        for j := 0 to Min(cdsDetail.Fields.Count-1,mygrid.ColCount-1) do
        begin
          sValue := mygrid.Cells[j, i];
          if not SameText(sValue, '') and CheckPrintSpecialChar(sValue) then
            sValue := '♂♀♂' + sValue;
          cdsDetail.Fields[j].AsString := sValue;
        end;
        cdsDetail.Post;
      end;
    except
      ShowWarningMsg('生成表体打印数据失败。');
      cdsDetail.Close;
      cdsDetail.FieldDefs.Clear;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

//////////////////// GetTableM /////////////////////////////
//函数功能：将传入的StringGrid中的数据转存到Table_m1.dbf中     //
//传入参数：myGrid : 装有数据的表格 BYesCount  ：最后一行是否有总计   //
//返回参数：                                //
// 说明：如果 ByesCount 为 True 哪 StringGrid的最后一行将被勿略，不处理
// 在函数申明时请注意procedure GetTableM(MyGrid: TgpStringGrid; BYesCount: Boolean); overload;
//////////////////////////////////////////////////////////////////////

procedure GetTableM(MyGrid: TCMXwAlignGrid; BYesCount: Boolean);
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag: boolean;
  lEndRow: Integer;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  sValue: string;
begin
  cdsDetail.Close;
  cdsDetail.FieldDefs.Clear;
  FillChar(szFields, sizeof(szFields), 0);
  try
    try
      nField := 0;
      for i := 0 to min(254, mygrid.ColCount - 1) do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
      begin
        szTemp := TrimRight(mygrid.Cells[i, 0]);
        szTemp := LeftString(szTemp, 30);
        if szTemp = '' then
          szTemp := 'Rwx';
        if Length(szTemp) > (cMaxLen-cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
        begin
          Flag := False;
          for k := 1 to (cMaxLen-cNumLen) do
          begin
            if Ord(szTemp[k]) >= 127 then
              Flag := not Flag;
          end;
          if Flag then
            szTemp := Copy(szTemp, 1, cMaxLen-cNumLen+1)
          else
            szTemp := Copy(szTemp, 1, cMaxLen-cNumLen);
        end;

        szTemp1 := szTemp;
        Inc(nField);
        nEnd := 1;
        while True do
        begin
          bFlag := True;
          for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
          begin
            if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
            begin
              bFlag := False;
              szTemp1 := szTemp + IntToStr(nEnd);
              inc(nEnd);
              Break;
            end;
          end; //End for M
          if bFlag then
            Break;
        end;
        szFields[nField] := ShortString(szTemp1);
        nWidth := GetFieldSize(mygrid, i);
        cdsDetail.FieldDefs.Add(szTemp1, ftWideString, nWidth);
      end;
      try
        cdsDetail.CreateDataSet;
      except
        ShowWarningMsg( '生成表体字段失败。');
        cdsDetail.FieldDefs.Clear;
        Exit;
      end;

      Screen.Cursor := TCursor(-11);
      Flag := False;
      lEndRow := 0;
      for i := mygrid.RowCount - 1 downto 0 do
      begin
        for j := 1 to mygrid.ColCount - 1 do
        begin
          if not StringEmpty(mygrid.Cells[j, i]) then
          begin
            Flag := True;
            break;
          end;
        end;

        if Flag then
        begin
          if BYesCount then
            lEndRow := i
          else
            lEndRow := i - 1;

          break;
        end;
      end;

      for i := 1 to lEndRow do
      begin
        cdsDetail.Append;
        //解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        for j := 0 to Min(cdsDetail.Fields.Count-1,mygrid.ColCount-1) do
        begin
          sValue := mygrid.Cells[j, i];
          if not SameText(sValue, '') and CheckPrintSpecialChar(sValue) then
            sValue := '♂♀♂' + sValue;
          cdsDetail.Fields[j].AsString := sValue;
        end;
        cdsDetail.Post;
      end;

    except
      ShowWarningMsg('生成表体打印数据失败。');
      cdsDetail.Close;
      cdsDetail.FieldDefs.Clear;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure GetTableM(mygrid: TXwGGeneralWGrid; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>; BYesCount: Boolean = False);
var
  i, j, nWidth, k, m, nMaxCount: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, printVisible, hasSerialNo: boolean;
  lEndRow: Integer;
  FPrintColumn: TStrings;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
begin
  cdsDetail.Data := GetGridTable(mygrid, FBillSerialNo, BYesCount);
  Exit;

  cdsDetail.Close;
  cdsDetail.FieldDefs.Clear;
  FillChar(szFields, sizeof(szFields), 0);
  printVisible := CheckSysCon(118);

  hasSerialNo := False;
  FPrintColumn := TStringList.Create;
  try
    with mygrid do
    begin
      try
        nField := 0;

        //加一个行号列
        FPrintColumn.Add('-100');
        cdsDetail.FieldDefs.Add(cRowCaption, ftWideString, 30);

        nMaxCount := 254;
        if (FDllParams.PubVersion2 > 2680) and (Trim(CMVchNumbers[CMVcfSerialGuid].szDataBaseName) <> '') then
        begin
          nMaxCount := 253;
          hasSerialNo := True;
        end;

        for i := 0 to ColumnsCount - 1 do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        begin
          if Columns[i].Expanded then
            Continue;

          if printVisible and (not Columns[i].Visible) then
            Continue;

          if (Columns[i].ValueExpression = '') and (not IsFieldCanPrint(Columns[i].FieldName)) then
            Continue;

          szTemp := CMPrintName(Columns[i]); //TrimRight(CMColumnFieldType(Columns[i]).Caption);

          if Trim(szTemp) = '' then
            Continue;

          Inc(nField);
          if nField >= nMaxCount then
            Break;

          if szTemp = '' then
            szTemp := 'Rwx';

          if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
          begin
            Flag := False;
            for k := 1 to (cMaxLen - cNumLen) do
            begin
              if Ord(szTemp[k]) >= 127 then
                Flag := not Flag;
            end;
            if Flag then
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen + 1)
            else
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
          end;

          szTemp1 := szTemp;
          nEnd := 1;
          while True do
          begin
            bFlag := True;
            for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
            begin
              if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
              begin
                bFlag := False;
                szTemp1 := szTemp + IntToStr(nEnd);
                inc(nEnd);
                Break;
              end;
            end; //End for M
            if bFlag then
              Break;
          end;

          szFields[nField] := ShortString(szTemp1);
          FPrintColumn.Add(IntToStr(i));
          nWidth := GetFieldSize(mygrid, Columns[i]);
          cdsDetail.FieldDefs.Add(szTemp1, ftWideString, nWidth);
        end;

        if hasSerialNo then
        begin
          nWidth := 4000;
          cdsDetail.FieldDefs.Add('序列号', ftWideString, nWidth);
        end;

        try
          cdsDetail.CreateDataSet;
        except
          ShowWarningMsg('生成表体字段失败。');
          cdsDetail.FieldDefs.Clear;
          Exit;
        end;

        Screen.Cursor := TCursor(-11);
        lEndRow := -1;
        for i := DataRowCount - 1 downto 0 do
        begin
          if not CMRowIsBlank(i) then
          begin
            lEndRow := i;
            Break;
          end;
        end;

        for i := 0 to lEndRow do
        begin
          cdsDetail.Append;

          for j := 0 to FPrintColumn.Count - 1 do
          begin
            if j = 0 then
              cdsDetail.Fields[j].AsString := IntToStr(i + 1)
            else
            begin
              if Columns[StringToInt(FPrintColumn.Strings[j])].ValueExpression <> '' then
                cdsDetail.Fields[j].AsString := GetCellText(Columns[StringToInt(FPrintColumn.Strings[j])], i)
              else
                cdsDetail.Fields[j].AsString := CMGetCellPrintByDBName(Columns[StringToInt(FPrintColumn.Strings[j])].FieldName, i);
            end;
          end;

          if hasSerialNo then
            cdsDetail.Fields[FPrintColumn.Count].AsString := GetSerialNoStr(CMGetCellTextByDBName(CMVchNumbers[CMVcfSerialGuid].szDataBaseName, i), FBillSerialNo);

          cdsDetail.Post;
        end;

        if BYesCount then
        begin
          if Footer then
          begin
            cdsDetail.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cdsDetail.Fields[0].AsString := cTotalCaption
              else
              begin
                if gcoHideContent in Columns[StringToInt(FPrintColumn.Strings[j])].ColumnOptions then
                  cdsDetail.Fields[j].AsString := cHideTotal
                else
                begin
                  if StringToDouble(Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue, TotalFormatStr) = 0 then
                    cdsDetail.Fields[j].AsString := ''
                  else
                    cdsDetail.Fields[j].AsString := Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue;
                end;
              end;
            end;

            cdsDetail.Post;
          end;
        end;
      except
        ShowWarningMsg('生成表体打印数据失败。');
        cdsDetail.Close;
        cdsDetail.FieldDefs.Clear;
      end;
    end;
  finally
    FreeAndNil(FPrintColumn);
    Screen.Cursor := crDefault;
  end;
end;

procedure GetTableM(mygrid1, mygrid2: TXwGGeneralWGrid; Separator: String; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>);
var
  i, j, nWidth, k, m, nMaxCount: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, hasSerialNo: boolean;
  lEndRow: Integer;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  szFieldsfhying: array of string;
  SperatorCol: integer;
  nIndex: integer;
  nReturnLength: array of Integer;
  nReturnCount: integer;
  szPrint: string;
  FMainPrintColumn, FOtherPrintColumn: TStrings;
begin
  cdsDetail.Close;
  cdsDetail.FieldDefs.Clear;
  FillChar(szFields, sizeof(szFields), 0);
  SetLength(szFieldsfhying, 255);
  SetLength(nReturnLength, 255);

  SperatorCol := 0;
  hasSerialNo := False;
  FMainPrintColumn := TStringList.Create;
  FOtherPrintColumn := TStringList.Create;
  try
    CreateFieldDefs(mygrid1, mygrid2, ['存货全名'], nReturnCount, nReturnLength, szFieldsfhying, FMainPrintColumn, FOtherPrintColumn);

    try
      nField := 0;

      nMaxCount := 254;
      if (FDllParams.PubVersion2 > 2680) then
      begin
        if (Trim(mygrid1.CMVchNumbers[CMVcfSerialGuid].szDataBaseName) <> '') or
           (Trim(mygrid2.CMVchNumbers[CMVcfSerialGuid].szDataBaseName) <> '') then
        begin
          nMaxCount := 253;
          hasSerialNo := True;
        end;
      end;

      for i := 0 to min(nMaxCount, nReturnCount - 1) do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
      begin
        szTemp  := szFieldsfhying[i];

        if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
        begin
          Flag := False;
          for k := 1 to (cMaxLen - cNumLen) do
          begin
            if Ord(szTemp[k]) >= 127 then
              Flag := not Flag;
          end;

          if Flag then
            szTemp := Copy(szTemp, 1, cMaxLen - cNumLen+1)
          else
            szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
        end;

        szTemp1 := szTemp;
        nWidth  := nReturnLength[nField];

        Inc(nField);
        nEnd := 1;
        while True do
        begin
          bFlag := True;
          for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
          begin
            if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
            begin
              bFlag := False;
              szTemp1 := szTemp + IntToStr(nEnd);
              inc(nEnd);
              Break;
            end;
          end; //End for M

          if bFlag then
            Break;
        end;

        szFields[nField] := ShortString(szTemp1);
        cdsDetail.FieldDefs.Add(szTemp1, ftWideString, nWidth);
      end;

      if hasSerialNo then
      begin
        nWidth := 4000;
        cdsDetail.FieldDefs.Add('序列号', ftWideString, nWidth);
      end;

      try
        cdsDetail.CreateDataSet;
      except
        ShowWarningMsg('生成表体字段失败。');
        cdsDetail.FieldDefs.Clear;
        Exit;
      end;

      Screen.Cursor := crHourglass;
      lEndRow := -1;
      for i := mygrid1.DataRowCount - 1 downto 0 do
      begin
        if not mygrid1.CMRowIsBlank(i) then
        begin
          lEndRow := i;
          Break;
        end;
      end;

      for i := 0 to lEndRow do
      begin
        cdsDetail.Append;

        for j := 0 to Min(cdsDetail.Fields.Count - 1, FMainPrintColumn.Count - 1) do
        begin
          if cdsDetail.Fields[j].FieldName = GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flPFullName].Caption then
            SperatorCol := j;

          if mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])].ValueExpression <> '' then
            cdsDetail.Fields[j].AsString := mygrid1.GetCellText(mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])], i)
          else
            cdsDetail.Fields[j].AsString := mygrid1.CMGetCellPrintByDBName(mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])].FieldName, i);
        end;

        if hasSerialNo then
          cdsDetail.Fields[cdsDetail.Fields.Count - 1].AsString := GetSerialNoStr(mygrid1.CMGetCellTextByDBName(mygrid1.CMVchNumbers[CMVcfSerialGuid].szDataBaseName, i), FBillSerialNo);

        cdsDetail.Post;
      end;

//      OneEnd := lEndRow + 1;

      //表格1加合计行
      if mygrid1.Footer then
      begin
        cdsDetail.Append;

        for j := 0 to Min(cdsDetail.Fields.Count - 1, FMainPrintColumn.Count - 1) do
        begin
          if cdsDetail.Fields[j].FieldName = GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flPFullName].Caption then
          begin
            cdsDetail.Fields[j].AsString := cTotalCaption;
            Continue;
          end;

          if gcoHideContent in mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])].ColumnOptions then
            cdsDetail.Fields[j].AsString := cHideTotal
          else
            cdsDetail.Fields[j].AsString := mygrid1.Columns[StringToInt(FMainPrintColumn.Strings[j])].FooterValue;
        end;

        cdsDetail.Post;
      end;

//      Inc(OneEnd);

      ///////////////////////////////////////////////////////////
      lEndRow := -1;
      for i := mygrid2.DataRowCount - 1 downto 0 do
      begin
        if not mygrid2.CMRowIsBlank(i) then
        begin
          lEndRow := i;
          Break;
        end;
      end;

      // 空行
      if lEndRow >= 0 then
      begin
        cdsDetail.Append;
        cdsDetail.Fields[SperatorCol].AsString := Separator;
        cdsDetail.Post;
      end;

      for i := 0 to lEndRow do
      begin
        cdsDetail.Append;

        for j := 0 to Min(cdsDetail.Fields.Count - 1, FOtherPrintColumn.Count - 1) do
        begin
          szPrint := myGrid2.CMColumnFieldType(myGrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])]).Caption;
          nIndex  := cdsDetail.FieldDefs.IndexOf(szPrint);

          if nIndex = -1 then
            Continue;

          if mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])].ValueExpression <> '' then
            cdsDetail.Fields[j].AsString := mygrid2.GetCellText(mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])], i)
          else
            cdsDetail.Fields[j].AsString := mygrid2.CMGetCellPrintByDBName(mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])].FieldName, i);
        end;

        if hasSerialNo then
          cdsDetail.Fields[cdsDetail.Fields.Count - 1].AsString := GetSerialNoStr(mygrid2.CMGetCellTextByDBName(mygrid2.CMVchNumbers[CMVcfSerialGuid].szDataBaseName, i), FBillSerialNo);

        cdsDetail.Post;
      end;

      //表格2加合计行
      if mygrid2.Footer then
      begin
        cdsDetail.Append;

        for j := 0 to Min(cdsDetail.Fields.Count - 1, FOtherPrintColumn.Count - 1) do
        begin
          if cdsDetail.Fields[j].FieldName = GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flPFullName].Caption then
          begin
            cdsDetail.Fields[j].AsString := cTotalCaption;
            Continue;
          end;

          szPrint := myGrid2.CMColumnFieldType(myGrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])]).Caption;
          nIndex  := cdsDetail.FieldDefs.IndexOf(szPrint);

          if nIndex = -1 then
            Continue;

          if gcoHideContent in mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])].ColumnOptions then
            cdsDetail.Fields[nIndex].AsString := cHideTotal
          else
            cdsDetail.Fields[nIndex].AsString := mygrid2.Columns[StringToInt(FOtherPrintColumn.Strings[j])].FooterValue;
        end;
        cdsDetail.Post;
      end;

    except
      ShowWarningMsg('生成表体打印数据失败。');
      cdsDetail.Close;
      cdsDetail.FieldDefs.Clear;
    end;
  finally
    FreeAndNil(FMainPrintColumn);
    FreeAndNil(FOtherPrintColumn);
    SetLength(szFieldsfhying, 0);
    SetLength(nReturnLength, 0);
    Screen.Cursor := crDefault;
  end;
end;

function GetFieldSize(StrGrd: TCMXwAlignGrid; Col: integer): integer;
var
  i, nWidth: integer;
begin
  Result := 2;
  for i := 0 to StrGrd.RowCount - 1 do
  begin
    nWidth := Length(StrGrd.Cells[Col, i]) * 2;
    if nWidth > Result then
      Result := nWidth;
  end;
end;

function GetFieldSize(StrGrd: TXwGGeneralGrid; AColumn: TgpCustomStdColumn; IncludeTotalRow: Boolean = False): integer;
var
  i, nWidth: integer;
begin
  Result := 10;
  for i := 0 to StrGrd.DataRowCount - 1 do
  begin
    if AColumn.ValueExpression <> '' then
    begin
      nWidth := Length(StrGrd.GetCellText(AColumn, i)) * 2;
      if nWidth > Result then
        Result := nWidth;
    end
    else
    begin
      nWidth := Length(StrGrd.CMGetCellPrintByDBName(AColumn.FieldName, i)) * 2;
      if nWidth > Result then
        Result := nWidth;
    end;
  end;

  if IncludeTotalRow and StrGrd.Footer then
    if Length(AColumn.FooterValue) > Result then
      Result := Length(AColumn.FooterValue);
end;

function GetFieldSize(StrGrd: TXwGGeneralWGrid; AColumn: TgpCustomStdColumn; IncludeTotalRow: Boolean = False): integer;
var
  i, nWidth: integer;
begin
  Result := 100;

  for i := 0 to StrGrd.DataRowCount - 1 do
  begin
    if AColumn.ValueExpression <> '' then
    begin
      nWidth := Length(StrGrd.GetCellText(AColumn, i)) * 2;
      if nWidth > Result then
        Result := nWidth;
    end
    else
    begin
      nWidth := Length(StrGrd.CMGetCellPrintByDBName(AColumn.FieldName, i)) * 2;
      if nWidth > Result then
        Result := nWidth;
    end;
  end;

  if IncludeTotalRow and StrGrd.Footer then
    if Length(AColumn.FooterValue) > Result then
      Result := Length(AColumn.FooterValue);
end;

procedure CreateFieldDefs(myGrid1, myGrid2: TXwGGeneralWGrid; UniteSameCol: array of string; var anFieldCount: integer;
    var anLength: array of integer; var aszField: array of string; var FMainPrintColumn, FOtherPrintColumn: TStrings);

  function  FindItemFromStrArray(aszArray : array of string; aszItem : string) : integer;
  var
    nCount : integer;
    i : integer;
  begin
    Result := -1;

    nCount  := Length(aszArray);
    for i := 0 to nCount -1 do
    begin
      if aszItem = aszArray[i] then
      begin
        Result  := i;
        Break;
      end;
    end;
  end;

  function  FindColumnIndexFromGrid(AGrid: TXwGGeneralWGrid; aszItem : string) : integer;
  var
    i : integer;
  begin
    Result := -1;

    if SameText(aszItem, '') then
      Exit;

    for i := 0 to AGrid.ColumnsCount - 1 do
    begin
      if AGrid.CMColumnFieldType(AGrid.Columns[i]).Caption = aszItem then
      begin
        Result := i;
        Break;
      end;
    end;
  end;

  function GetUniteSameCol(aszField : string; var szSameColName: string): Boolean;
  var i: Integer;
  begin
    szSameColName := aszField;
    Result := False;
    for i := Low(UniteSameCol) to High(UniteSameCol) do
    begin
      if Pos(UniteSameCol[i], aszField) > 0 then
      begin
        Result := True;
        szSameColName := UniteSameCol[i];
        Break;
      end;
    end;
  end;
var
  i, j : integer;
  nFieldCount : integer;
  szMain, szOther : string;
  nMainLength, nOtherLength : integer;
  nReturn : integer;
  szTempName: string;
begin
  FMainPrintColumn.Clear;
  FOtherPrintColumn.Clear;

  nFieldCount := -1;
  try
    // 先把主表格的字段填写进去。
    for i := 0 to myGrid1.ColumnsCount - 1 do
    begin
      if myGrid1.Columns[i].Expanded then
        Continue;

      if (myGrid1.Columns[i].ValueExpression = '') and (not myGrid1.IsFieldCanPrint(myGrid1.Columns[i].FieldName)) then
        Continue;

      szMain := myGrid1.CMPrintName(myGrid1.Columns[i]); //myGrid1.CMColumnFieldType(myGrid1.Columns[i]).Caption;

      if GetUniteSameCol(szMain, szTempName) then
        szMain := szTempName;

      if Trim(szMain) = '' then
        Continue;

      Inc(nFieldCount);
      aszField[nFieldCount] := szMain;

      FMainPrintColumn.Add(IntToStr(i));
      nMainLength := GetFieldSize(myGrid1, myGrid1.Columns[i]);
      anLength[nFieldCount] := nMainLength;
    end;

    for j := 0 to Length(aszField) - 1 do
    begin
      if SameStr(aszField[j], '') then
        Continue;

      nReturn := FindColumnIndexFromGrid(myGrid2, aszField[j]);
      FOtherPrintColumn.Add(IntToStr(nReturn));
    end;

    // 将次表格和主表格比较，没有的字段也填进去。
    for j := 0 to myGrid2.ColumnsCount -1 do
    begin
      if myGrid2.Columns[j].Expanded then
        Continue;

      if (myGrid2.Columns[j].ValueExpression = '') and (not myGrid2.IsFieldCanPrint(myGrid2.Columns[j].FieldName)) then
        Continue;

      szOther := myGrid2.CMPrintName(myGrid2.Columns[j]); //myGrid2.CMColumnFieldType(myGrid2.Columns[j]).Caption;

      if GetUniteSameCol(szOther, szTempName) then
        szOther := szTempName;

      if Trim(szOther) = '' then
        Continue;

      nReturn := FindItemFromStrArray(aszField, szOther);

      if nReturn <> -1 then
      begin
        nOtherLength  := GetFieldSize(myGrid2, myGrid2.Columns[j]);
        anLength[nReturn] := Max(anLength[nReturn], nOtherLength);
      end
      else
      begin
        Inc(nFieldCount);
        aszField[nFieldCount] := szOther;
        FOtherPrintColumn.Add(IntToStr(j));
        anLength[nFieldCount] := GetFieldSize(myGrid2, myGrid2.Columns[j]);
      end;
    end;

    // 合并后的字段数
    anFieldCount  := nFieldCount + 1;
  finally
  end;
end;

function FindRealGridColByPrint(aGrid: TXwGGeneralWGrid; aszPrint: string): integer;
var
  i : integer;
begin
  Result  := -1;

  for i := 0 to aGrid.ColumnsCount - 1 do
  begin
    if aGrid.CMColumnFieldType(aGrid.Columns[i]).Caption = aszPrint then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure AddHeaderFooterCell(ALineIntf: IcrLineIntf; const AText: string; const AFontSize: Integer);
begin
  with ALineIntf.AddCellIntf do  // 往行中添加一个单元格
  begin
    CellText := ShortString(AText);
    CellWidth := 65536; // 65536 会自动转为整页可用宽度
    FontSize := AFontSize;
    HorzAlign := 1;  // 水平对齐方式 0 左对齐 1 水平居中 2 对右对齐
    LeftLine := False;
    RightLine := False;
    TopLine := False;
    BottomLine := False;
  end;
end;

procedure AddCell(ALineIntf: IcrLineIntf; const AText: string; const AWidth: Integer;
    const AHorzAlign: Integer = 0; const ADecimal: Integer = -1);
begin
  with ALineIntf.AddCellIntf do
  begin
    CellText := ShortString(AText);
    CellWidth := AWidth;
    CellWordWrap := False; // 不折行
    FontSize := 9;
    HorzAlign := AHorzAlign;  // 水平对齐方式 0 左对齐 1 水平居中 2 对右对齐
    Decimal := ADecimal;
  end;
end;

procedure AddTemplatePageHeader(szRwxFile: string; var TemplateIntf: IcrTemplateIntf);
var
  LineIntf: IcrLineIntf;
begin
  LineIntf := TemplateIntf.AddLineIntf; //添加一行
  AddHeaderFooterCell(LineIntf, '', 10);
  LineIntf := TemplateIntf.AddLineIntf; //添加一行
  AddHeaderFooterCell(LineIntf, szRwxFile, 20);
end;

procedure AddPageDetail(var TemplateIntf: IcrTemplateIntf);
var
  i, iCount: Integer;
  LineIntf: IcrLineIntf;
begin
  LineIntf := TemplateIntf.AddLineIntf; // 添加一行：标签
  iCount := Min(8, cdsDetail.Fields.Count); // 最多5个明细单元格

  for i := 0 to iCount - 1 do // 循环添加单元格
    AddCell(LineIntf, cdsDetail.Fields[i].FieldName, Length(cdsDetail.Fields[i].FieldName) * 8); // 指定标签

  LineIntf := TemplateIntf.AddLineIntf; // 添加一行：数据

  for i := 0 to iCount - 1 do  // 循环添加单元格
    AddCell(LineIntf, '#' + cdsDetail.Fields[i].FieldName, Length(cdsDetail.Fields[i].FieldName) * 8); // 指定使用明细字段
end;

procedure DoAddPageFooter(var TemplateIntf: IcrTemplateIntf);
var
  LineIntf: IcrLineIntf;
begin
  LineIntf := TemplateIntf.AddLineIntf; // 添加一行
  AddHeaderFooterCell(LineIntf, '`总页码'{'`页码 / `总页'}, 9);
end;

procedure RunAutoTemplatePrint(szRwxFile: string = '');
var
  ReportIntf: IcrReport;
  TemplateIntf: IcrTemplateIntf;
begin
  ReportIntf := crReportIntf.CreateReport;
  TemplateIntf := ReportIntf.CreateTemplate;
  try
    TemplateIntf := ReportIntf.CreateTemplate;
    with TemplateIntf do
    begin
      TemplateName := ShortString(szRwxFile);
      Orientation := 0; // 纵向打印
      // 设置边距，单位为 毫米
      LeftMargin := 20;
      RightMargin := 10;
      TopMargin := 10;
      BottomMargin := 20;
    end;

    AddTemplatePageHeader(szRwxFile, TemplateIntf); // 添加表头
    AddPageDetail(TemplateIntf); // 添加表体
    DoAddPageFooter(TemplateIntf); // 添加表尾
    ReportIntf.SaveTemplate(TemplateIntf); // 保存自动创建的报表，已有的会被覆盖

    with ReportIntf do
    begin
      OwnerAppHandle := Application.Handle; // 本行可选
      MasterData := cdsHeader.Data; // 传入主表数据
      DetailData := cdsDetail.Data; // 传入明细数据
      TemplateName := ShortString(szRwxFile);

      if CheckSysCon(69) then
      begin
        ShowPrintDialog := False;
        Print;
      end
      else
      begin
        ShowPrintDialog := True;
        Execute;
      end;
    end;
    // 如果需要返回值，可以取属性 LastErrorCode
  finally
    TemplateIntf := nil;
    ReportIntf := nil;
  end;
end;

procedure GetPtypeQRCode(mygrid: TXwGGeneralWGrid; ARow: Integer; var AStream: TMemoryStream);
var
  FData, FPtypeId: string;
begin
  if Trim(mygrid.PrintPtypeColumnField) <> '' then
    FPtypeId := mygrid.CMGetCellTextByDBName(Trim(mygrid.PrintPtypeColumnField), ARow)
  else
    FPtypeId := mygrid.TypeId[btPtype, ARow];

  AStream.Clear;
  FData := Format('{"serverid":"%s","dbname":"%s","functype"="ptype","typeid"="%s"}', [FDllParams.gjpSvr.GetServerUniqueCode, GetPubZtName, FPtypeId]);
  with TCMQRCodeBox.Create(nil) do
  try
    //Logo := FLogo;
    Data := FData;
    Width := 160;
    Height := 160;
    SaveToStream(AStream);
  finally
    Free;
  end;
end;

function GetGridTable(mygrid: TXwGGeneralGrid; BYesCount: Boolean = False): OleVariant;
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, printVisible: boolean;
  lEndRow: Integer;
  FPrintColumn: TStrings;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  cds: TClientDataSet;
  Sql: string;
  nBeginImageColumnIndex: Integer;
  cdsImage: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  cdsImage := TClientDataSet.Create(nil);
  FPrintColumn := TStringList.Create;
  try
    cds.Close;
    cds.FieldDefs.Clear;
    FillChar(szFields, sizeof(szFields), 0);
    printVisible := CheckSysCon(118);
    with mygrid do
    begin
      try
        nField := 0;

        //加一个行号列
        FPrintColumn.Add('-100');
        cds.FieldDefs.Add(cRowCaption, ftWideString, 30);

        for i := 0 to ColumnsCount - 1 do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        begin
          if Columns[i].Expanded then
            Continue;

          if printVisible and (not Columns[i].Visible) then
            Continue;

          if CMCanNotPrintFields.IndexOf(Columns[i].FieldName) >= 0 then
            Continue;

          if (Columns[i].ValueExpression = '') and (not IsFieldCanPrint(Columns[i].FieldName)) then
            Continue;

          szTemp := CMPrintName(Columns[i]); //TrimRight(CMColumnFieldType(Columns[i]).Caption);

          if Trim(szTemp) = '' then
            Continue;

          Inc(nField);
          if nField >= 254 then
            Break;

          if szTemp = '' then
            szTemp := 'Rwx';
          if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
          begin
            Flag := False;
            for k := 1 to (cMaxLen - cNumLen) do
            begin
              if Ord(szTemp[k]) >= 127 then
                Flag := not Flag;
            end;
            if Flag then
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen)
            else
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen - 1);
          end;

          szTemp1 := szTemp;
          nEnd := 1;
          while True do
          begin
            bFlag := True;
            for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
            begin
              if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
              begin
                bFlag := False;
                szTemp1 := szTemp + IntToStr(nEnd);
                inc(nEnd);
                Break;
              end;
            end; //End for M
            if bFlag then
              Break;
          end;

          szFields[nField] := ShortString(szTemp1);
          FPrintColumn.Add(IntToStr(i));
          nWidth := GetFieldSize(mygrid, Columns[i]) + 1;
          cds.FieldDefs.Add(szTemp1, ftWideString, nWidth);
        end;

        if mygrid.PrintPtypeImage then
        begin
          cds.FieldDefs.Add('存货图片1', ftBlob);
          cds.FieldDefs.Add('存货图片2', ftBlob);
          cds.FieldDefs.Add('存货图片3', ftBlob);
        end;

        try
          cds.CreateDataSet;
        except
          ShowWarningMsg('生成表体字段失败。');
          cds.FieldDefs.Clear;
          Exit;
        end;

        Screen.Cursor := TCursor(-11);
        lEndRow := -1;
        for i := DataRowCount - 1 downto 0 do
        begin
          if not CMRowIsBlank(i) then
          begin
            lEndRow := i;
            Break;
          end;
        end;

        for i := 0 to lEndRow do
        begin
          cds.Append;

          for j := 0 to FPrintColumn.Count - 1 do
          begin
            if j = 0 then
              cds.Fields[j].AsString := IntToStr(i + 1)
            else
            begin
              if Columns[StringToInt(FPrintColumn.Strings[j])].ValueExpression <> '' then
                cds.Fields[j].AsString := GetCellText(Columns[StringToInt(FPrintColumn.Strings[j])], i)
              else
                cds.Fields[j].AsString := CMGetCellPrintByDBName(Columns[StringToInt(FPrintColumn.Strings[j])].FieldName, i);
            end;
          end;

          nBeginImageColumnIndex := FPrintColumn.Count;
          if mygrid.PrintPtypeImage then
          begin
            Sql := 'Select p.GraphOrder, i.img From PtypeGraph p Left Join Xw_Image i On p.xwImageOrder = i.ord Where Ptypeid = ''%0:s'' Order By p.GraphOrder';
            if Trim(mygrid.PrintPtypeColumnField) <> '' then
              Sql := Format(Sql, [mygrid.CMGetCellTextByDBName(Trim(mygrid.PrintPtypeColumnField), i)])
            else
              Sql := Format(Sql, [mygrid.TypeId[btPtype, i]]);

            OpenSQL(Sql, cdsImage);
            cdsImage.First;
            while not cdsImage.Eof do
            begin
              cds.Fields[nBeginImageColumnIndex + cdsImage.FieldByName('GraphOrder').AsInteger].Value := cdsImage.FieldByName('Img').Value;
              cdsImage.Next;
            end;
          end;

          cds.Post;
        end;

        if BYesCount then
        begin
          if Footer { and mygrid.PrintTotal} then
          begin
            cds.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cds.Fields[0].AsString := cTotalCaption
              else
              begin
                if gcoHideContent in Columns[StringToInt(FPrintColumn.Strings[j])].ColumnOptions then
                  cds.Fields[j].AsString := cHideTotal
                else
                begin
                  if StringToDouble(Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue, TotalFormatStr) = 0 then
                    cds.Fields[j].AsString := ''
                  else
                    cds.Fields[j].AsString := Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue;
                end;
              end;
            end;
            cds.Post;
          end;
        end;

      except
        ShowWarningMsg('生成表体打印数据失败。');
        cds.Close;
        cds.FieldDefs.Clear;
      end;

      Result := cds.Data;
    end;
  finally
    FreeAndNil(FPrintColumn);
    FreeAndNil(cds);
    FreeAndNil(cdsImage);
    Screen.Cursor := crDefault;
  end;
end;

function GetGridTable(mygrid: TXwGGeneralWGrid; BYesCount: Boolean = False): OleVariant;
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, printVisible: boolean;
  lEndRow: Integer;
  FPrintColumn: TStrings;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  cds: TClientDataSet;
  Sql: string;
  nBeginImageColumnIndex: Integer;
  cdsImage: TClientDataSet;
  FStream: TMemoryStream;
begin
  cds := TClientDataSet.Create(nil);
  cdsImage := TClientDataSet.Create(nil);
  FPrintColumn := TStringList.Create;
  try
    cds.Close;
    cds.FieldDefs.Clear;
    FillChar(szFields, sizeof(szFields), 0);
    printVisible := CheckSysCon(118);
    with mygrid do
    begin
      try
        nField := 0;

        //加一个行号列
        FPrintColumn.Add('-100');
        cds.FieldDefs.Add(cRowCaption, ftWideString, 30);

        for i := 0 to ColumnsCount - 1 do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        begin
          if Columns[i].Expanded then
            Continue;

          if printVisible and (not Columns[i].Visible) then
            Continue;

          if {(Columns[i].ValueExpression = '') and }(not IsFieldCanPrint(Columns[i].FieldName)) then
            Continue;

          if CMCanNotPrintFields.IndexOf(Columns[i].FieldName) >= 0 then
            Continue;

          szTemp := CMPrintName(Columns[i]); //TrimRight(CMColumnFieldType(Columns[i]).Caption);

          if Trim(szTemp) = '' then
            Continue;

          Inc(nField);
          if nField >= 254 then
            Break;

          if szTemp = '' then
            szTemp := 'Rwx';

          if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
          begin
            Flag := False;
            for k := 1 to (cMaxLen - cNumLen) do
            begin
              if Ord(szTemp[k]) >= 127 then
                Flag := not Flag;
            end;
            if Flag then
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen + 1)
            else
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
          end;

          szTemp1 := szTemp;
          nEnd := 1;
          while True do
          begin
            bFlag := True;
            for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
            begin
              if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
              begin
                bFlag := False;
                szTemp1 := szTemp + IntToStr(nEnd);
                inc(nEnd);
                Break;
              end;
            end; //End for M
            if bFlag then
              Break;
          end;

          szFields[nField] := ShortString(szTemp1);
          FPrintColumn.Add(IntToStr(i));
          nWidth := GetFieldSize(mygrid, Columns[i]);
          cds.FieldDefs.Add(szTemp1, ftWideString, nWidth);
        end;

        if mygrid.PrintPtypeImage then
        begin
          cds.FieldDefs.Add('存货图片1', ftBlob);
          cds.FieldDefs.Add('存货图片2', ftBlob);
          cds.FieldDefs.Add('存货图片3', ftBlob);
          cds.FieldDefs.Add('存货二维码', ftBlob);
        end;

        try
          cds.CreateDataSet;
        except
          ShowWarningMsg('生成表体字段失败。');
          cds.FieldDefs.Clear;
          Exit;
        end;

        Screen.Cursor := TCursor(-11);
        lEndRow := -1;
        for i := DataRowCount - 1 downto 0 do
        begin
          if not CMRowIsBlank(i) then
          begin
            lEndRow := i;
            Break;
          end;
        end;

        FStream := TMemoryStream.Create;
        try
          for i := 0 to lEndRow do
          begin
            cds.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cds.Fields[j].AsString := IntToStr(i + 1)
              else
              begin
                if Columns[StringToInt(FPrintColumn.Strings[j])].ValueExpression <> '' then
                  cds.Fields[j].AsString := GetCellText(Columns[StringToInt(FPrintColumn.Strings[j])], i)
                else
                  cds.Fields[j].AsString := CMGetCellPrintByDBName(Columns[StringToInt(FPrintColumn.Strings[j])].FieldName, i);
              end;
            end;

            nBeginImageColumnIndex := FPrintColumn.Count;
            if mygrid.PrintPtypeImage then
            begin
              Sql := 'Select p.GraphOrder, i.img From PtypeGraph p Left Join Xw_Image i On p.xwImageOrder = i.ord Where Ptypeid = ''%0:s'' Order By p.GraphOrder';
              if Trim(mygrid.PrintPtypeColumnField) <> '' then
                Sql := Format(Sql, [mygrid.CMGetCellTextByDBName(Trim(mygrid.PrintPtypeColumnField), i)])
              else
                Sql := Format(Sql, [mygrid.TypeId[btPtype, i]]);

              OpenSQL(Sql, cdsImage);
              cdsImage.First;
              while not cdsImage.Eof do
              begin
                cds.Fields[nBeginImageColumnIndex + cdsImage.FieldByName('GraphOrder').AsInteger].Value := cdsImage.FieldByName('Img').Value;
                cdsImage.Next;
              end;

              //二维码
              GetPtypeQRCode(mygrid, i, FStream);
              TBlobField(cds.Fields[nBeginImageColumnIndex + 3]).LoadFromStream(FStream);
            end;

            cds.Post;
          end;
        finally
          FreeAndNil(FStream);
        end;

        if BYesCount then
        begin
          if Footer then
          begin
            cds.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cds.Fields[0].AsString := cTotalCaption
              else
              begin
                if gcoHideContent in Columns[StringToInt(FPrintColumn.Strings[j])].ColumnOptions then
                  cds.Fields[j].AsString := cHideTotal
                else
                begin
                  if StringToDouble(Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue, TotalFormatStr) = 0 then
                    cds.Fields[j].AsString := ''
                  else
                    cds.Fields[j].AsString := Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue;
                end;
              end;
            end;

            cds.Post;
          end;
        end;
      except
        ShowWarningMsg('生成表体打印数据失败。');
        cds.Close;
        cds.FieldDefs.Clear;
      end;
    end;

    Result := cds.Data;
  finally
    FreeAndNil(FPrintColumn);
    FreeAndNil(cds);
    FreeAndNil(cdsImage);
    Screen.Cursor := crDefault;
  end;
end;


function GetGridTable(mygrid: TXwGGeneralWGrid;RowIndex:Integer; BYesCount: Boolean = False): OleVariant;
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, printVisible: boolean;
  lEndRow: Integer;
  FPrintColumn: TStrings;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  cds: TClientDataSet;
  Sql: string;
  nBeginImageColumnIndex: Integer;
  cdsImage: TClientDataSet;
  FStream: TMemoryStream;
begin
  cds := TClientDataSet.Create(nil);
  cdsImage := TClientDataSet.Create(nil);
  FPrintColumn := TStringList.Create;
  try
    cds.Close;
    cds.FieldDefs.Clear;
    FillChar(szFields, sizeof(szFields), 0);
    printVisible := CheckSysCon(118);
    with mygrid do
    begin
      try
        nField := 0;

        //加一个行号列
        FPrintColumn.Add('-100');
        cds.FieldDefs.Add(cRowCaption, ftWideString, 30);

        for i := 0 to ColumnsCount - 1 do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        begin
          if Columns[i].Expanded then
            Continue;

          if printVisible and (not Columns[i].Visible) then
            Continue;

          if {(Columns[i].ValueExpression = '') and }(not IsFieldCanPrint(Columns[i].FieldName)) then
            Continue;

          if CMCanNotPrintFields.IndexOf(Columns[i].FieldName) >= 0 then
            Continue;

          szTemp := CMPrintName(Columns[i]); //TrimRight(CMColumnFieldType(Columns[i]).Caption);

          if Trim(szTemp) = '' then
            Continue;

          Inc(nField);
          if nField >= 254 then
            Break;

          if szTemp = '' then
            szTemp := 'Rwx';

          if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
          begin
            Flag := False;
            for k := 1 to (cMaxLen - cNumLen) do
            begin
              if Ord(szTemp[k]) >= 127 then
                Flag := not Flag;
            end;
            if Flag then
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen + 1)
            else
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
          end;

          szTemp1 := szTemp;
          nEnd := 1;
          while True do
          begin
            bFlag := True;
            for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
            begin
              if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
              begin
                bFlag := False;
                szTemp1 := szTemp + IntToStr(nEnd);
                inc(nEnd);
                Break;
              end;
            end; //End for M
            if bFlag then
              Break;
          end;

          szFields[nField] := ShortString(szTemp1);
          FPrintColumn.Add(IntToStr(i));
          nWidth := GetFieldSize(mygrid, Columns[i]);
          cds.FieldDefs.Add(szTemp1, ftWideString, nWidth);
        end;

        if mygrid.PrintPtypeImage then
        begin
          cds.FieldDefs.Add('存货图片1', ftBlob);
          cds.FieldDefs.Add('存货图片2', ftBlob);
          cds.FieldDefs.Add('存货图片3', ftBlob);
          cds.FieldDefs.Add('存货二维码', ftBlob);
        end;

        try
          cds.CreateDataSet;
        except
          ShowWarningMsg('生成表体字段失败。');
          cds.FieldDefs.Clear;
          Exit;
        end;

        Screen.Cursor := TCursor(-11);
        lEndRow := -1;

        if not CMRowIsBlank(RowIndex) then
           lEndRow :=  RowIndex;

        FStream := TMemoryStream.Create;
        try
          if lEndRow <> -1 then
          begin
            cds.Append;
            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cds.Fields[j].AsString := IntToStr(lEndRow + 1)
              else
              begin
                if Columns[StringToInt(FPrintColumn.Strings[j])].ValueExpression <> '' then
                  cds.Fields[j].AsString := GetCellText(Columns[StringToInt(FPrintColumn.Strings[j])], lEndRow)
                else
                  cds.Fields[j].AsString := CMGetCellPrintByDBName(Columns[StringToInt(FPrintColumn.Strings[j])].FieldName, lEndRow);
              end;
            end;

            nBeginImageColumnIndex := FPrintColumn.Count;
            if mygrid.PrintPtypeImage then
            begin
              Sql := 'Select p.GraphOrder, i.img From PtypeGraph p Left Join Xw_Image i On p.xwImageOrder = i.ord Where Ptypeid = ''%0:s'' Order By p.GraphOrder';
              if Trim(mygrid.PrintPtypeColumnField) <> '' then
                Sql := Format(Sql, [mygrid.CMGetCellTextByDBName(Trim(mygrid.PrintPtypeColumnField), lEndRow)])
              else
                Sql := Format(Sql, [mygrid.TypeId[btPtype, lEndRow]]);

              OpenSQL(Sql, cdsImage);
              cdsImage.First;
              while not cdsImage.Eof do
              begin
                cds.Fields[nBeginImageColumnIndex + cdsImage.FieldByName('GraphOrder').AsInteger].Value := cdsImage.FieldByName('Img').Value;
                cdsImage.Next;
              end;

              //二维码
              GetPtypeQRCode(mygrid, i, FStream);
              TBlobField(cds.Fields[nBeginImageColumnIndex + 3]).LoadFromStream(FStream);
            end;

            cds.Post;
          end;
        finally
          FreeAndNil(FStream);
        end;

        if BYesCount then
        begin
          if Footer then
          begin
            cds.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cds.Fields[0].AsString := cTotalCaption
              else
              begin
                if gcoHideContent in Columns[StringToInt(FPrintColumn.Strings[j])].ColumnOptions then
                  cds.Fields[j].AsString := cHideTotal
                else
                begin
                  if StringToDouble(Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue, TotalFormatStr) = 0 then
                    cds.Fields[j].AsString := ''
                  else
                    cds.Fields[j].AsString := Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue;
                end;
              end;
            end;

            cds.Post;
          end;
        end;
      except
        ShowWarningMsg('生成表体打印数据失败。');
        cds.Close;
        cds.FieldDefs.Clear;
      end;
    end;

    Result := cds.Data;
  finally
    FreeAndNil(FPrintColumn);
    FreeAndNil(cds);
    FreeAndNil(cdsImage);
    Screen.Cursor := crDefault;
  end;
end;

function GetGridTable(mygrid: TCMFenbubiaoGrid; BYesCount: Boolean = False): OleVariant;
var cds:TClientDataSet;
begin
  try
    Screen.Cursor := TCursor(-11);
    cds := TClientDataSet.Create(nil);
    cds.Close;
    cds.FieldDefs.Clear;
    cds := mygrid.CMGetPrintData(True, BYesCount);
    Result := cds.Data;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function GetGridTable(mygrid: TXwGGeneralWGrid; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>; szKtypeID: string): OleVariant;
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, printVisible, hasSerialNo: boolean;
  lEndRow, nMaxCount: Integer;
  FPrintColumn: TStrings;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  cds: TClientDataSet;
  Sql: string;
  nBeginImageColumnIndex: Integer;
  cdsImage: TClientDataSet;
  FStream: TMemoryStream;
begin
  cds := TClientDataSet.Create(nil);
  cdsImage := TClientDataSet.Create(nil);
  FPrintColumn := TStringList.Create;
  try
    cds.Close;
    cds.FieldDefs.Clear;
    FillChar(szFields, sizeof(szFields), 0);
    printVisible := CheckSysCon(118);
    hasSerialNo := False;
    with mygrid do
    begin
      try
        nField := 0;

        //加一个行号列
        FPrintColumn.Add('-100');
        cds.FieldDefs.Add(cRowCaption, ftWideString, 30);

        nMaxCount := 254;
        if (FDllParams.PubVersion2 > 2680) and (Trim(CMVchNumbers[CMVcfSerialGuid].szDataBaseName) <> '') then
        begin
          nMaxCount := 253;
          hasSerialNo := True;
        end;

        for i := 0 to ColumnsCount - 1 do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        begin
          if Columns[i].Expanded then
            Continue;

          if printVisible and (not Columns[i].Visible) then
            Continue;

          if (Columns[i].ValueExpression = '') and (not IsFieldCanPrint(Columns[i].FieldName)) then
            Continue;

          if CMCanNotPrintFields.IndexOf(Columns[i].FieldName) >= 0 then
            Continue;

          szTemp := CMPrintName(Columns[i]); //TrimRight(CMColumnFieldType(Columns[i]).Caption);

          if Trim(szTemp) = '' then
            Continue;

          Inc(nField);
          if nField >= nMaxCount then
            Break;

          if szTemp = '' then
            szTemp := 'Rwx';

          if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
          begin
            Flag := False;
            for k := 1 to (cMaxLen - cNumLen) do
            begin
              if Ord(szTemp[k]) >= 127 then
                Flag := not Flag;
            end;
            if Flag then
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen + 1)
            else
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
          end;

          szTemp1 := szTemp;
          nEnd := 1;
          while True do
          begin
            bFlag := True;
            for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
            begin
              if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
              begin
                bFlag := False;
                szTemp1 := szTemp + IntToStr(nEnd);
                inc(nEnd);
                Break;
              end;
            end; //End for M
            if bFlag then
              Break;
          end;

          szFields[nField] := ShortString(szTemp1);
          FPrintColumn.Add(IntToStr(i));
          nWidth := GetFieldSize(mygrid, Columns[i]);
          cds.FieldDefs.Add(szTemp1, ftWideString, nWidth);
        end;

        if hasSerialNo then
        begin
          nWidth := 4000;
          cds.FieldDefs.Add('序列号', ftWideString, nWidth);
        end;

        if mygrid.PrintPtypeImage then
        begin
          cds.FieldDefs.Add('存货图片1', ftBlob);
          cds.FieldDefs.Add('存货图片2', ftBlob);
          cds.FieldDefs.Add('存货图片3', ftBlob);
          cds.FieldDefs.Add('存货二维码', ftBlob);
        end;

        try
          cds.CreateDataSet;
        except
          ShowWarningMsg('生成表体字段失败。');
          cds.FieldDefs.Clear;
          Exit;
        end;

        Screen.Cursor := TCursor(-11);
        lEndRow := -1;
        for i := DataRowCount - 1 downto 0 do
        begin
          if not CMRowIsBlank(i) then
          begin
            lEndRow := i;
            Break;
          end;
        end;

        FStream := TMemoryStream.Create;
        try
          for i := 0 to lEndRow do
          begin
            if szKtypeID <> Trim(mygrid.TypeId[btKType, i]) then
              Continue;

            cds.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cds.Fields[j].AsString := IntToStr(i + 1)
              else
              begin
                if Columns[StringToInt(FPrintColumn.Strings[j])].ValueExpression <> '' then
                  cds.Fields[j].AsString := GetCellText(Columns[StringToInt(FPrintColumn.Strings[j])], i)
                else
                  cds.Fields[j].AsString := CMGetCellPrintByDBName(Columns[StringToInt(FPrintColumn.Strings[j])].FieldName, i);
              end;
            end;

            nBeginImageColumnIndex := FPrintColumn.Count;
            if hasSerialNo then
            begin
              cds.Fields[FPrintColumn.Count].AsString := GetSerialNoStr(CMGetCellTextByDBName(CMVchNumbers[CMVcfSerialGuid].szDataBaseName, i), FBillSerialNo);
              Inc(nBeginImageColumnIndex);
            end;

            if mygrid.PrintPtypeImage then
            begin
              Sql := 'Select p.GraphOrder, i.img From PtypeGraph p Left Join Xw_Image i On p.xwImageOrder = i.ord Where Ptypeid = ''%0:s'' Order By p.GraphOrder';
              if Trim(mygrid.PrintPtypeColumnField) <> '' then
                Sql := Format(Sql, [mygrid.CMGetCellTextByDBName(Trim(mygrid.PrintPtypeColumnField), i)])
              else
                Sql := Format(Sql, [mygrid.TypeId[btPtype, i]]);

              OpenSQL(Sql, cdsImage);
              cdsImage.First;
              while not cdsImage.Eof do
              begin
                cds.Fields[nBeginImageColumnIndex + cdsImage.FieldByName('GraphOrder').AsInteger].Value := cdsImage.FieldByName('Img').Value;
                cdsImage.Next;
              end;

              //二维码
              GetPtypeQRCode(mygrid, i, FStream);
              TBlobField(cds.Fields[nBeginImageColumnIndex + 3]).LoadFromStream(FStream);
            end;

            cds.Post;
          end;
        finally
          FreeAndNil(FStream);
        end;
      except
        ShowWarningMsg('生成表体打印数据失败。');
        cds.Close;
        cds.FieldDefs.Clear;
      end;
    end;

    Result := cds.Data;
  finally
    FreeAndNil(FPrintColumn);
    FreeAndNil(cds);
    FreeAndNil(cdsImage);
    Screen.Cursor := crDefault;
  end;
end;

function GetGridTable(mygrid: TCMXwAlignGrid; BYesCount: Boolean = False): OleVariant;
var
  i, j, nWidth, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag: boolean;
  lEndRow: Integer;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  cds: TClientDataSet;
  sValue: string;
begin
  cds := TClientDataSet.Create(nil);
  try
    cds.Close;
    cds.FieldDefs.Clear;
    FillChar(szFields, sizeof(szFields), 0);
    try
      nField := 0;
      for i := 0 to Min(254, mygrid.ColCount - 1) do //解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
      begin
        szTemp := TrimRight(mygrid.Cells[i, 0]);
        szTemp := LeftString(szTemp, 30);
        if szTemp = '' then
          szTemp := 'Rwx';
        if Length(szTemp) > (cMaxLen-cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
        begin
          Flag := False;
          for k := 1 to (cMaxLen-cNumLen) do
          begin
            if Ord(szTemp[k]) >= 127 then
              Flag := not Flag;
          end;
          if Flag then
            szTemp := Copy(szTemp, 1, cMaxLen-cNumLen+1)
          else
            szTemp := Copy(szTemp, 1, cMaxLen-cNumLen);
        end;

        szTemp1 := szTemp;
        Inc(nField);
        nEnd := 1;
        while True do
        begin
          bFlag := True;
          for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
          begin
            if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
            begin
              bFlag := False;
              szTemp1 := szTemp + IntToStr(nEnd);
              inc(nEnd);
              Break;
            end;
          end; //End for M
          if bFlag then
            Break;
        end;
        szFields[nField] := ShortString(szTemp1);
        nWidth := GetFieldSize(MyGrid, i);
        cds.FieldDefs.Add(szTemp1, ftWideString, nWidth);
      end;

      try
        cds.CreateDataSet;
      except
        ShowWarningMsg('生成表体字段失败。');
        cds.FieldDefs.Clear;
        Exit;
      end;

      Screen.Cursor := crHourglass;
      Flag := False;
      lEndRow := 0;
      for i := mygrid.RowCount - 1 downto 0 do
      begin
        for j := 1 to mygrid.ColCount - 1 do
        begin
          if not StringEmpty(mygrid.Cells[j, i]) then
          begin
            Flag := True;
            break;
          end;
        end;

        if Flag then
        begin
          if BYesCount then
            lEndRow := i - 1
          else
            lEndRow := i;

          break;
        end;

      end;

      for i := 1 to lEndRow do
      begin
        cds.Append;
        for j := 0 to Min(cds.Fields.Count-1,mygrid.ColCount-1) do
        begin
          sValue := mygrid.Cells[j, i];
          if not SameText(sValue, '') and CheckPrintSpecialChar(sValue) then
            sValue := '♂♀♂' + sValue;
          cds.Fields[j].AsString := sValue;
        end;
        cds.Post;
      end;
    except
      ShowWarningMsg('生成表体打印数据失败。');
      cds.Close;
      cds.FieldDefs.Clear;
    end;

    Result := cds.Data;
  finally
    FreeAndNil(cds);
    Screen.Cursor := crDefault;
  end;
end;

function GetGridTable(mygrid: TXwGGeneralWGrid; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>; BYesCount: Boolean = False): OleVariant;
var
  i, j, nWidth, k, m, nMaxCount: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, printVisible, hasSerialNo: boolean;
  lEndRow: Integer;
  FPrintColumn: TStrings;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  cds: TClientDataSet;
  Sql: string;
  nBeginImageColumnIndex: Integer;
  cdsImage: TClientDataSet;
  FStream: TMemoryStream;
begin
  cds := TClientDataSet.Create(nil);
  cdsImage := TClientDataSet.Create(nil);
  FPrintColumn := TStringList.Create;
  try
    cds.Close;
    cds.FieldDefs.Clear;
    FillChar(szFields, sizeof(szFields), 0);
    printVisible := CheckSysCon(118);
    hasSerialNo := False;
    with mygrid do
    begin
      try
        nField := 0;

        //加一个行号列
        FPrintColumn.Add('-100');
        cds.FieldDefs.Add(cRowCaption, ftWideString, 30);

        nMaxCount := 254;
        if (FDllParams.PubVersion2 > 2680) and (Trim(CMVchNumbers[CMVcfSerialGuid].szDataBaseName) <> '') then
        begin
          nMaxCount := 253;
          hasSerialNo := True;
        end;

        for i := 0 to ColumnsCount - 1 do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        begin
          if Columns[i].Expanded then
            Continue;

          if printVisible and (not Columns[i].Visible) then
            Continue;

          if {(Columns[i].ValueExpression = '') and }(not IsFieldCanPrint(Columns[i].FieldName)) then
            Continue;

          if CMCanNotPrintFields.IndexOf(Columns[i].FieldName) >= 0 then
            Continue;

          szTemp := CMPrintName(Columns[i]); //TrimRight(CMColumnFieldType(Columns[i]).Caption);

          if Trim(szTemp) = '' then
            Continue;

          Inc(nField);
          if nField >= nMaxCount then
            Break;

          if szTemp = '' then
            szTemp := 'Rwx';

          if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
          begin
            Flag := False;
            for k := 1 to (cMaxLen - cNumLen) do
            begin
              if Ord(szTemp[k]) >= 127 then
                Flag := not Flag;
            end;
            if Flag then
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen + 1)
            else
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
          end;

          szTemp1 := szTemp;
          nEnd := 1;
          while True do
          begin
            bFlag := True;
            for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
            begin
              if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
              begin
                bFlag := False;
                szTemp1 := szTemp + IntToStr(nEnd);
                inc(nEnd);
                Break;
              end;
            end; //End for M
            if bFlag then
              Break;
          end;

          szFields[nField] := ShortString(szTemp1);
          FPrintColumn.Add(IntToStr(i));
          nWidth := GetFieldSize(mygrid, Columns[i]);
          cds.FieldDefs.Add(szTemp1, ftWideString, nWidth);
        end;

        if hasSerialNo then
        begin
          nWidth := 4000;
          cds.FieldDefs.Add('序列号', ftWideString, nWidth);
        end;

        if mygrid.PrintPtypeImage then
        begin
          cds.FieldDefs.Add('存货图片1', ftBlob);
          cds.FieldDefs.Add('存货图片2', ftBlob);
          cds.FieldDefs.Add('存货图片3', ftBlob);
          cds.FieldDefs.Add('存货二维码', ftBlob);
        end;

        try
          cds.CreateDataSet;
        except
          ShowWarningMsg('生成表体字段失败。');
          cds.FieldDefs.Clear;
          Exit;
        end;

        Screen.Cursor := TCursor(-11);
        lEndRow := -1;
        for i := DataRowCount - 1 downto 0 do
        begin
          if not CMRowIsBlank(i) then
          begin
            lEndRow := i;
            Break;
          end;
        end;

        FStream := TMemoryStream.Create;
        try
          for i := 0 to lEndRow do
          begin
            cds.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cds.Fields[j].AsString := IntToStr(i + 1)
              else
              begin
                if Columns[StringToInt(FPrintColumn.Strings[j])].ValueExpression <> '' then
                  cds.Fields[j].AsString := GetCellText(Columns[StringToInt(FPrintColumn.Strings[j])], i)
                else
                  cds.Fields[j].AsString := CMGetCellPrintByDBName(Columns[StringToInt(FPrintColumn.Strings[j])].FieldName, i);
              end;
            end;

            nBeginImageColumnIndex := FPrintColumn.Count;
            if hasSerialNo then
            begin
              cds.Fields[FPrintColumn.Count].AsString := GetSerialNoStr(CMGetCellTextByDBName(CMVchNumbers[CMVcfSerialGuid].szDataBaseName, i), FBillSerialNo);
              Inc(nBeginImageColumnIndex);
            end;

            if mygrid.PrintPtypeImage then
            begin
              Sql := 'Select p.GraphOrder, i.img From PtypeGraph p Left Join Xw_Image i On p.xwImageOrder = i.ord Where Ptypeid = ''%0:s'' Order By p.GraphOrder';
              if Trim(mygrid.PrintPtypeColumnField) <> '' then
                Sql := Format(Sql, [mygrid.CMGetCellTextByDBName(Trim(mygrid.PrintPtypeColumnField), i)])
              else
                Sql := Format(Sql, [mygrid.TypeId[btPtype, i]]);

              OpenSQL(Sql, cdsImage);
              cdsImage.First;
              while not cdsImage.Eof do
              begin
                cds.Fields[nBeginImageColumnIndex + cdsImage.FieldByName('GraphOrder').AsInteger].Value := cdsImage.FieldByName('Img').Value;
                cdsImage.Next;
              end;

              //二维码
              GetPtypeQRCode(mygrid, i, FStream);
              TBlobField(cds.Fields[nBeginImageColumnIndex + 3]).LoadFromStream(FStream);
            end;

            cds.Post;
          end;
        finally
          FreeAndNil(FStream);
        end;

        if BYesCount then
        begin
          if Footer then
          begin
            cds.Append;

            for j := 0 to FPrintColumn.Count - 1 do
            begin
              if j = 0 then
                cds.Fields[0].AsString := cTotalCaption
              else
              begin
                if gcoHideContent in Columns[StringToInt(FPrintColumn.Strings[j])].ColumnOptions then
                  cds.Fields[j].AsString := cHideTotal
                else
                begin
                  if StringToDouble(Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue, TotalFormatStr) = 0 then
                    cds.Fields[j].AsString := ''
                  else
                    cds.Fields[j].AsString := Columns[StringToInt(FPrintColumn.Strings[j])].FooterValue;
                end;
              end;
            end;

            cds.Post;
          end;
        end;
      except
        ShowWarningMsg('生成表体打印数据失败。');
        cds.Close;
        cds.FieldDefs.Clear;
      end;
    end;

    Result := cds.Data;
  finally
    FreeAndNil(FPrintColumn);
    FreeAndNil(cds);
    FreeAndNil(cdsImage);
    Screen.Cursor := crDefault;
  end;
end;

function GetHeaderData(AForm: TForm; ATitle: string; AImageDataSet: TClientDataSet; FAfterLoadPrintHeader: TAfterLoadPrintHeaderEvent = nil): OleVariant;
var
  i: Integer;
  FPrintHeader: TPrintHeader;
  ArrHeader: TPrintHeaderList;

  procedure AddSystemField;
  begin
    FPrintHeader.FieldName := '产品信息';
    FPrintHeader.Length    := Length(AnsiString(FDllParams.PUBLIC_APPNAME));
    FPrintHeader.Value     := FDllParams.PUBLIC_APPNAME;
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '表名';
    FPrintHeader.Length    := Length(AnsiString(ATitle));
    FPrintHeader.Value     := ATitle;
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '系统日期';
    FPrintHeader.Length    := 10;
    FPrintHeader.Value     := FormatDateTime('yyyy-mm-dd', Date);
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '系统时间';
    FPrintHeader.Length    := 10;
    FPrintHeader.Value     := FormatDateTime('hh:nn:ss', Time);
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '登录日期';
    FPrintHeader.Length    := 10;
    FPrintHeader.Value     := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '操作员';
    FPrintHeader.Length    := Length(AnsiString(GetCurrentOperatorName));
    FPrintHeader.Value     := GetCurrentOperatorName;
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '公司名称';
    FPrintHeader.Value     := GetSysValue('companyfullname');
    FPrintHeader.Length    := Length(AnsiString(FPrintHeader.Value));
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '公司地址';
    FPrintHeader.Value     := GetSysValue('address');
    FPrintHeader.Length    := Length(AnsiString(FPrintHeader.Value));
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '公司电话';
    FPrintHeader.Value     := GetSysValue('tel');
    FPrintHeader.Length    := Length(AnsiString(FPrintHeader.Value));
    ArrHeader.HeaderList.Add(FPrintHeader);

    FPrintHeader.FieldName := '会计年度';
    FPrintHeader.Value     := GetCurrentYear;
    FPrintHeader.Length    := 4;
    ArrHeader.HeaderList.Add(FPrintHeader);
  end;

  procedure AddLabelField(ALabel: TCMGXwLabelLabel);
  begin
    with ALabel do
    begin
      if ((FrameWork <> fwConcatInfo) and (not Visible)) or CMNotPrint then
        Exit;

      FPrintHeader.FieldName := LabelCaption;
      FPrintHeader.Value := LabelText;
      FPrintHeader.Length := Length(AnsiString(LabelText));
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;
  procedure AddMemoField(AMemo: TCMGLabelMemo);
  begin
    with AMemo do
    begin
      if not Visible then
        Exit;

      FPrintHeader.FieldName := ReplaceSpecialChar(Caption);
      FPrintHeader.Value := Text;
      FPrintHeader.Length := Length(AnsiString(Text));
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;
  procedure AddComboBoxField(AComboBox: TCMGLabelComBox);
  begin
    with AComboBox do
    begin
      if not Visible then
        Exit;

      FPrintHeader.FieldName := ReplaceSpecialChar(Caption);
      FPrintHeader.Value := Text;
      FPrintHeader.Length := Length(AnsiString(Text));
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;
  procedure AddValueComboBoxField(AValueComboBox: TCMGLabelValueComBox);
  begin
    with AValueComboBox do
    begin
      if not Visible then
        Exit;

      FPrintHeader.FieldName := ReplaceSpecialChar(Caption);
      FPrintHeader.Value := Text;
      FPrintHeader.Length := Length(AnsiString(Text));
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;
  procedure AddEditField(AEdit: TCMGLabelBtnEdit);
  begin
    with AEdit do
    begin
      if SameText(Trim(Caption), EmptyStr) or (not Visible) then
        Exit;

      FPrintHeader.FieldName := ReplaceSpecialChar(Caption);
      FPrintHeader.Value := Text;
      FPrintHeader.Length := Length(AnsiString(Text));
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;
  procedure AddEmptyDateField(AEmptyDate: TCMGLabelEmptyDate);
  begin
    with AEmptyDate do
    begin
      if not Visible then
        Exit;

      FPrintHeader.FieldName := ReplaceSpecialChar(Caption);
      FPrintHeader.Value := FormatDateTime('yyyy-mm-dd', Date);
      FPrintHeader.Length := 10;
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;
  procedure AddClearDateField(AClearDate: TCMGLabelClearDate);
  begin
    with AClearDate do
    begin
      if not Visible then
        Exit;

      FPrintHeader.FieldName := ReplaceSpecialChar(Caption);
      FPrintHeader.Value := DateStr;
      FPrintHeader.Length := 10;
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;

  procedure AddCheckBoxField(ACheckBox: TCheckBox);
  begin
    with ACheckBox do
    begin
      if not Visible then
        Exit;
      FPrintHeader.FieldName := ReplaceSpecialChar(Caption);
      if Checked then
        FPrintHeader.Value := '是'
      else
        FPrintHeader.Value := '否';
      FPrintHeader.Length := 2;
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;

  procedure AddCMCheckBoxField(ACheckBox: TCMGXwChcekBox);
  begin
    with ACheckBox do
    begin
      if not Visible then
        Exit;
      FPrintHeader.FieldName := ReplaceSpecialChar(Caption);
      if Checked then
        FPrintHeader.Value := '是'
      else
        FPrintHeader.Value := '否';
      FPrintHeader.Length := 2;
      ArrHeader.HeaderList.Add(FPrintHeader);
    end;
  end;

  function FindFieldName(AFieldIndex: Integer; Fields: TPrintHeaderList): Boolean;
  var
    i: Integer;
  begin
    Result := False;

    for i := 0 to AFieldIndex - 1 do
    begin
      if AnsiCompareText(Fields.HeaderList.Items[AFieldIndex].FieldName, Fields.HeaderList.Items[i].FieldName) = 0 then //不区分大小写
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  function GetDataFromArray(AHeaders: TPrintHeaderList): OleVariant;
  var
    i, iCount: Integer;
    sTemp: string;
    cds: TClientDataSet;
  begin
    if AHeaders.HeaderList.Count <= 0 then
      Exit(Null);

    for i := 0 to AHeaders.HeaderList.Count - 1 do
    begin
      iCount := 1;

      if Trim(AHeaders.HeaderList.Items[i].FieldName) = '' then
        Continue;

      while FindFieldName(i, AHeaders) do
      begin
        FPrintHeader := AHeaders.HeaderList.Items[i];
        FPrintHeader.FieldName := FPrintHeader.FieldName + IntToStr(iCount);
        AHeaders.HeaderList.Items[i] := FPrintHeader;
        Inc(iCount);
      end;
    end;

    cds := TClientDataSet.Create(nil);
    try
      for i := 0 to AHeaders.HeaderList.Count - 1 do
      begin
        sTemp := AHeaders.HeaderList.Items[i].FieldName;
        if sTemp = '' then
          Continue;

        cds.FieldDefs.Add(sTemp, ftWideString, AHeaders.HeaderList.Items[i].Length + 1);
      end;

      if Assigned(AImageDataSet) then
      begin
        for I := 0 to AImageDataSet.FieldDefs.Count - 1 do
        begin
          cds.FieldDefs.Add(AImageDataSet.FieldDefs[i].Name, ftBlob);
        end;
      end;

      try
        cds.CreateDataSet;
      except
        ShowWarningMsg('生成表头字段失败。');
        cds.FieldDefs.Clear;
        Exit;
      end;

      cds.Append;
      for i := 0 to AHeaders.HeaderList.Count - 1 do
      begin
          sTemp := AHeaders.HeaderList.Items[i].Value;
          if SameText(AHeaders.HeaderList.Items[i].FieldName, EmptyStr) then
            Continue;
          cds.FieldByName(AHeaders.HeaderList.Items[i].FieldName).Asstring := sTemp;
      end;

      if Assigned(AImageDataSet) then
      begin
        for I := 0 to  AImageDataSet.FieldDefs.Count - 1 do
        begin
          cds.FieldByName(AImageDataSet.FieldDefs[i].Name).Value := AImageDataSet.FieldByName(AImageDataSet.FieldDefs[i].Name).Value;
        end;
      end;
      cds.Post;
      Result := cds.Data;
    finally
      FreeAndNil(cds);
    end;
  end;

begin
  if not Assigned(AForm) then
    Exit;

  ArrHeader := TPrintHeaderList.Create;
  try
    AddSystemField;

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      if not (AForm.Components[i] is TControl) then
        Continue;

      if AForm.Components[i] is TCMGXwLabelLabel then
        AddLabelField(TCMGXwLabelLabel(AForm.Components[i]))
      else if AForm.Components[i] is TCMGLabelMemo then
        AddMemoField(TCMGLabelMemo(AForm.Components[i]))
      else if AForm.Components[i] is TCMGLabelComBox then
        AddComboBoxField(TCMGLabelComBox(AForm.Components[i]))
      else if AForm.Components[i] is TCMGLabelValueComBox then
        AddValueComboBoxField(TCMGLabelValueComBox(AForm.Components[i]))
      else if AForm.Components[i] is TCMGLabelBtnEdit then
        AddEditField(TCMGLabelBtnEdit(AForm.Components[i]))
      else if AForm.Components[i] is TCMGLabelEmptyDate then
        AddEmptyDateField(TCMGLabelEmptyDate(AForm.Components[i]))
      else if AForm.Components[i] is TCMGLabelClearDate then
        AddClearDateField(TCMGLabelClearDate(AForm.Components[I]))
      else if AForm.Components[i] is TCheckBox then
        AddCheckBoxField(TCheckBox(AForm.Components[I]))
      else if AForm.Components[i] is TCMGXwChcekBox then
        AddCMCheckBoxField(TCMGXwChcekBox(AForm.Components[I]));
    end;

    if Assigned(FAfterLoadPrintHeader) then
      FAfterLoadPrintHeader(ArrHeader);

    Result := GetDataFromArray(ArrHeader);
  finally
    ArrHeader.HeaderList.Clear;
    ArrHeader.Destroy;
  end;
end;

procedure CreateGridHeaderData(mygrid: TXwGGeneralGrid; RowIndex:Integer; var ArrHeader: TPrintHeaderList);
var
  i, k, m: Integer;
  nEnd: integer;
  nField: integer; //总共有多少个字段
  bFlag, Flag, printVisible: boolean;
  lEndRow: Integer;
  szTemp, szTemp1: string;
  szFields: array[1..255] of string[cMaxLen]; //字段名最长不大于四个汉字＋3位数字。
  FPrintHeader: TPrintHeader;
begin
  try
    FillChar(szFields, sizeof(szFields), 0);
    printVisible := False;
    with mygrid do
    begin
      try
        nField := 0;

        lEndRow := -1;
        if RowIndex < 0 then
          lEndRow := 0
        else if not CMRowIsBlank(RowIndex) then
           lEndRow :=  RowIndex;

        for i := 0 to min(254, ColumnsCount - 1) do//解决给szFields数组赋值时越界问题 Modified By Guiyun 2007-11-28
        begin
          if Columns[i].Expanded then
            Continue;

          if printVisible and (not Columns[i].Visible) then
            Continue;

          if (Columns[i].ValueExpression = '') and (not IsFieldCanPrint(Columns[i].FieldName)) then
            Continue;

          if CMCanNotPrintFields.IndexOf(Columns[i].FieldName) >= 0 then
            Continue;

          szTemp := CMPrintName(Columns[i]); //TrimRight(CMColumnFieldType(Columns[i]).Caption);

          if Trim(szTemp) = '' then
            Continue;

          if szTemp = '' then
            szTemp := 'Rwx';

          if Length(szTemp) > (cMaxLen - cNumLen) then //解决导出数据到Excel时科目名称不全的问题 Modified By Guiyun 2009-04-02
          begin
            Flag := False;
            for k := 1 to (cMaxLen - cNumLen) do
            begin
              if Ord(szTemp[k]) >= 127 then
                Flag := not Flag;
            end;
            if Flag then
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen + 1)
            else
              szTemp := Copy(szTemp, 1, cMaxLen - cNumLen);
          end;

          szTemp1 := szTemp;
          Inc(nField);
          nEnd := 1;
          while True do
          begin
            bFlag := True;
            for m := 1 to nField do //处理是否有相同名字的字段名 有就在后面＋序号
            begin
              if AnsiCompareText(szTemp1, string(szFields[m])) = 0 then //不区分大小写
              begin
                bFlag := False;
                szTemp1 := szTemp + IntToStr(nEnd);
                inc(nEnd);
                Break;
              end;
            end; //End for M
            if bFlag then
              Break;
          end;
          szFields[nField] := ShortString(szTemp1);
          FPrintHeader.FieldName := szTemp1;
          if lEndRow <> -1 then
          begin
            if Columns[i].ValueExpression <> '' then
              FPrintHeader.Value := GetCellText(Columns[i], lEndRow)
            else
              FPrintHeader.Value := CMGetCellPrintByDBName(Columns[i].FieldName, lEndRow)
          end;
          FPrintHeader.Length := Length(AnsiString(FPrintHeader.Value));
          ArrHeader.HeaderList.Add(FPrintHeader);
        end;
      except
        ShowWarningMsg('生成表体打印数据失败。');

      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function GetPtypeImageDataSet(PtypeId: string): TClientDataSet;
var
  ResultDataSet, tempDataSet: TClientDataSet;
  stream: TMemoryStream;
  sql: string;
begin
  ResultDataSet := TClientDataSet.Create(nil);
  tempDataSet := TClientDataSet.Create(nil);
  stream := TMemoryStream.Create;
  ResultDataSet.FieldDefs.Add('存货图片1', ftBlob);
  ResultDataSet.FieldDefs.Add('存货图片2', ftBlob);
  ResultDataSet.FieldDefs.Add('存货图片3', ftBlob);

  ResultDataSet.CreateDataSet;
//  ResultDataSet.FieldByName('').as
  ResultDataSet.Append;
  sql := 'Select g.Ptypeid, i.Img from PtypeGraph g '+
          'inner JOIN xw_image i ON g.xwImageOrder = i.ord '+
          'where GraphOrder = %d and ptypeid = ''%s'' ';
  OpenSQL(Format(sql, [0, PtypeId]), tempDataSet);
  if tempDataSet.RecordCount > 0 then
  begin
    stream.Clear;
    TBlobField(tempDataSet.FieldByName('Img')).SaveToStream(stream);
    TBlobField(ResultDataSet.FieldByName('存货图片1')).LoadFromStream(stream);
  end;

  OpenSQL(Format(sql, [1, PtypeId]), tempDataSet);
  if tempDataSet.RecordCount > 0 then
  begin
    stream.Clear;
    TBlobField(tempDataSet.FieldByName('Img')).SaveToStream(stream);
    TBlobField(ResultDataSet.FieldByName('存货图片2')).LoadFromStream(stream);
  end;

  OpenSQL(Format(sql, [2, PtypeId]), tempDataSet);
  if tempDataSet.RecordCount > 0 then
  begin
    stream.Clear;
    TBlobField(tempDataSet.FieldByName('Img')).SaveToStream(stream);
    TBlobField(ResultDataSet.FieldByName('存货图片3')).LoadFromStream(stream);
  end;

  ResultDataSet.Post;
  tempDataSet.Free;
  stream.Free;
  Result := ResultDataSet;
end;

//序列号
function GetSerialNoStr(sGuid: string; FBillSerialNo: TDictionary<string, TList<TBillSerialNo>>): string;
var
  I: Integer;
  retStr: string;
  bSerialNoNewLine: Boolean;
  FSerialNoList: TList<TBillSerialNo>;
begin
  retStr := '';
  if SameStr(sGuid, '') or (FBillSerialNo = nil) or (FBillSerialNo.Count <= 0) then
    Result := retStr
  else
  begin
    if FBillSerialNo.TryGetValue(sGuid, FSerialNoList) then
    begin
      bSerialNoNewLine := CheckSysCon(168);

      for I := 0 to FSerialNoList.Count - 1 do
      begin
        if SameStr(retStr, '') then
          retStr := FSerialNoList.Items[I].SerialNo
        else
        begin
          if bSerialNoNewLine then
            retStr := retStr + Char(13) + FSerialNoList.Items[I].SerialNo
          else
            retStr := retStr + ',' + FSerialNoList.Items[I].SerialNo;
        end;
      end;
    end;

    Result := retStr;
  end;
end;

//function CheckOldPrint: Boolean;
//const
//  VersionKeyNames: array[0..9] of string = ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright', 'LegalTrademarks', 'OriginalFilename', 'ProductName', 'ProductVersion', 'Comments');
//
//var
//  ThisInfo: Integer;
//  InfoLength: UINT;
//  Len: DWORD;
//  Handle: DWORD;
//  PCharset: PLongInt;
//begin
//  if ThisSourceFile = '' then
//    ThisSourceFile := ModuleFullFileName;
//  Len := GetFileVersionInfoSize(PChar(ThisSourceFile), Handle);
//  SetLength(VersionInfo, Len + 1); if GetFileVersionInfo(PChar(ThisSourceFile), Handle, Len, Pointer(VersionInfo)) then
//  begin
//    if VerQueryValue(Pointer(VersionInfo), '\VarFileInfo\Translation', Pointer(PCharset), InfoLength) then
//    begin
//      LangCharset := Format('%.4x%.4x', [LoWord(PCharset^), HiWord(PCharset^)]);
//      InfoAvailable := True;
//      for ThisInfo := 0 to MaxVersionKeys do
//        StandardKeys[ThisInfo] := GetKey(VersionKeyNames[ThisInfo]);
//      SplitFileVersion;  // 分解出版本号
//    end;
//  end;
//end;

//constructor TcpVersionInfo.Create(ThisSourceFile: string = '');
//const
//  VersionKeyNames: array[0..MaxVersionKeys] of string = ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright', 'LegalTrademarks', 'OriginalFilename', 'ProductName', 'ProductVersion', 'Comments');
//var
//  ThisInfo: Integer;
//  InfoLength: UINT;
//  Len: DWORD;
//  Handle: DWORD;
//  PCharset: PLongInt;
//begin
//  inherited Create;
//  if ThisSourceFile = '' then
//    ThisSourceFile := ModuleFullFileName;
//  // Get size of version info
//  Len := GetFileVersionInfoSize(PChar(ThisSourceFile), Handle);
//  // Allocate VersionInfo buffer size
//  SetLength(VersionInfo, Len + 1); if GetFileVersionInfo(PChar(ThisSourceFile), Handle, Len, Pointer(VersionInfo)) then
//  begin
//    // Get translation info for Language / CharSet IDs
//    if VerQueryValue(Pointer(VersionInfo), '\VarFileInfo\Translation', Pointer(PCharset), InfoLength) then
//    begin
//      LangCharset := Format('%.4x%.4x', [LoWord(PCharset^), HiWord(PCharset^)]);
//      InfoAvailable := True;
//      // Get standard version information
//      for ThisInfo := 0 to MaxVersionKeys do
//        StandardKeys[ThisInfo] := GetKey(VersionKeyNames[ThisInfo]);
//      SplitFileVersion;  // 分解出版本号
//    end;
//  end;
//end;

initialization
  begin
    cdsHeader := TClientDataSet.Create(nil);
    cdsDetail := TClientDataSet.Create(nil);
  end;

finalization
  begin
    cdsHeader.Free;
    cdsDetail.Free;
  end;

end.
