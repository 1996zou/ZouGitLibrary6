unit uBillFunction;

//与单据相关的功能函数 :主要为查询数据
//拆分自Billparent zle @2006-2-17
interface
uses
  XWComponentType, Classes, Controls, SysUtils, Windows, Graphics, DB, ADODB, Variants,
  uBillCommon, DBClient, xwgtypedefine, uTransformFunc,uOperationFunc, XwGGeneralWGrid,
  GjpSvrE2_TLB, xwCalcFieldsDefine, DateUtils, uDataStructure, ZLib, uBillMessageComm;

const
  cBillSpecial = ''',~,`,!,@,#,$,%,^,&,*,"'; //自定义字段名称不能包含这些特殊字符


// 取得单据格式配置
function GetVchtypeConfig(var ABills: TBills): Integer;
// 根据单据编号格式生成单据号
function GetVchSN(ABills: TBills; dtDate: TDateTime): string;
//调阅单据
function LoadBillData(AVchcode, AVchtype: Integer;
  TitleData, DetailData: TClientDataSet; IsDraft: Boolean = False; AMode: Integer = 0): Integer;overload;
function LoadBillData(AVchcode, AVchtype, AMode: Integer;
  TitleData, DetailData: TClientDataSet; bt: TBillType): Integer;overload;
function LoadBillOtherData(AVchCode, AVchType: Integer; OtherData: TClientDataSet): Integer;

//删除单据
function DeleteDraft(AVchCode, AVchType: Integer): Boolean;
function ExecPlugProcAfterDeleteDraft(AVchCode, AVchType: Integer): Boolean;

//单据保存
function ProcessBill(pm: TBillProcessMode; FBillProcessParam: TBillProcessParam; ShowMsgModaless: Boolean): TBillProcessRet;

// 复制草稿
function bi_CopyDraftToDraft(AVchcode, AVchtype, BVchtype: Integer; AOp: string; var sErrMsg: string): Integer;
function bi_CopyToDraft(AVchcode, AVchtype: Integer; var sErrMsg: string): Integer;

function GetBillTypeEnum(bt: TBillType): enBillType;

// 取得存货的价格跟踪
function GetProductPriceTrack(const szBTypeID, szPTypeID, szKTypeID: string): TProductPrice;

function GetBillModifyLockValue(AVchtype, AVchcode: Integer; AValue: Integer): Integer;

function CompareVchFormat(nVchtype1, nVchtype2: Integer): Boolean;
function CheckRARPJieSuanSavetoDB(AVchcode: Integer): Boolean;

function GetBillNumberByVchcode(nVchcode: Integer): string;

function CheckBillCanModify(AVchcode, AVchType: Integer): Boolean;

function GetBtypeCurrentARAP(szBtypeID: string): Double;
function GetBtypeRARPDateLimit(nVchType: Integer; szBtypeID, szDefaultDate: string): string;

  //转换了单位后的单价数量
//ResultUnit  1返回基本单位，2返回辅助单位， 0当前是什么单位就返回什么
function ConvertValueforUnit(AValue, dUnitRate: Double; nCurUnit, ResultUnit: Integer): Double;

function GetPtypeTrackPriceAndPrePrice(szPtypeID, szBtypeID: string): TProductPrice;

function DoubleValueSameDirection(AValue1, AValue2: Double): Boolean;
function CheckDataBeyond(AValue: Double; IsCW: Boolean = False): Boolean;

function GetBillType(Vchtype: Integer): TBilltype;
function GetBillIsInoviceUse(AVchtpe, AVchcode: Integer): Boolean;

function GetBillJxcPeriod: Integer;

function GetProduceVchCode(AMode, AVchcode, AVchtype: Integer; APeriod, BillTypeMode: Integer): Integer;
function GetXunJiaVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetGxVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetInvoiceVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer; AInvoiceMode: Integer): Integer;
function GetIniGoodsStockVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetIniFactStockVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetIniCommissionVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetIniArApVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetIniProduceVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetIniConsignVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetCheckVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
function GetJxcVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;

function CheckSameBlockNo(ABlockNo, APtypeid, KTypeid: String; goodsNo: Integer): Boolean;
function CheckBlockNoInOldBill(BillType, AVchcode: Integer; ABlockNo, APtypeid, KTypeid: String): Boolean;
function CheckBillIsGathering(AVchCode: Integer): Boolean;
function CheckAtypeIsYINGSYUS(Atypeid: String): Integer;
function CheckBillIsUseOther(AVchType, AVchCode: Integer): Boolean;
function GetBlockNoFromGoodsStocks(Ptypeid, GoodsNo: String;Vchcode:Integer;KtypeID: STring; var BlockNo: string; var ProDate: string): Boolean;
function SourceBillIsRedDelete(AVchCode: Integer): Boolean;
function SourceBillIsModifyOrRedDelete(AVchCode: Integer; BTypeID: string): Boolean;
function GetOutGoodsNo(Ptypeid: String; Vchcode, VchType: Integer): String;

function CheckOrderisSelect(AVchtype, AVchCode: Integer): Boolean;
function CheckPlanIsSelect(AVchtype, AVchCode: Integer):Boolean;
function CheckCostModified(AVchtype, AVchCode: Integer; cbSetCost: Boolean): Boolean;
function CheckBillCanOpen(AVchtype, AVchCode: Integer; showMsg: Boolean = True): Boolean;
function CheckAuditBill(AVchtype, AVchCode: Integer; IsDraft: Boolean): Boolean;
function CheckBillUseOther(AVchtype, AVchCode: Integer; IsAuditing: Boolean): Boolean;

function CheckRightDraft(ABtnType: TCMBtnType): Boolean;
function CheckSpecialCharAndLength(sDest, sCaption: string; nIndex, maxLength: integer): Boolean;
function CheckDateFormat(sDest, sCaption: string; nIndex: integer): Boolean;
function CheckMaxMinValue(dValue, dMaxValue, dMinValue: Extended; iRow: Integer; sCaption:String):Boolean;
function CheckGoodsHave(Ptypeid: string; GoodsNo, VchCode: Integer): Boolean;
function CheckOtherViewCost: Boolean;
function GetChineseFuZhuUnitDis(aszUnit1, aszUnit2: string; adQty, adRate: double; const UnitType: Integer): string;
function CheckOrderRowExists(sDlyOrder: Integer): Boolean;

function CheckBillHasBasicRights(AVchtype, AVchCode: Integer; IsDraft: Boolean; showMessage: Boolean = True): Boolean;
function GetAuditLeveal(AVchType, AVchCode: Integer): Integer;

procedure CheckBillHasKRights(AVchtype, AVchCode: Integer; var Draft: Integer; var HasAllRights: Boolean);
procedure CheckBillHasDRights(AVchtype, AVchCode: Integer; var Draft: Integer; var HasAllRights: Boolean);
procedure CheckBillHasPRights(AVchtype, AVchCode: Integer; var Draft: Integer; var HasAllRights: Boolean);

function GetProduceBOM(nMode: Integer; szPtypeID: string; cdsBOM: TClientDataset): Integer;
function CheckPCyc(szPtypeID, szParID: String): Boolean;
function GetProduceCostPrice(AVchtype: Integer; szPtypeID: string):  Double;
function GetProduceSourceBill(AVchtype, AVchcode: Integer): TBillTitleData;
function GetProduceCostPriceHand(AVchtype, GoodsNo: Integer; szPtypeID: string):  Double;
function GetBlockNoFromGoodsStocksSC(Ptypeid: String; GoodsNo, Vchcode: Integer; WtypeID: STring; var BlockNo: string; var ProDate: string): Boolean;
function GetBlockNoFromGoodsStocksWeiWai(Ptypeid: String; GoodsNo, Vchcode: Integer; BtypeID: STring; var BlockNo: string; var ProDate: string): Boolean;
function GetConsignBtypeInfo(Btypeid: string): TConsignBType;
function CheckBillHasLoadByWLHX(AVchType, AVchCode: Integer): Boolean;

function CheckPrintPass(AVchType, AVchCode: Integer; IsDraft, needAddPrintCount: Boolean): Boolean;
function GetPrintCount(AVchType, AVchCode: Integer): Integer;
function BillSquare(cMode: string; nVchType, nVchCode: Integer; var oParams: Variant): Boolean;
function CheckDateInAcceptRange(sDate: string): Boolean;
function CheckBasic(FVchType, FVchCode: Integer; MainControl, OtherControl: TControl): Boolean;
function CheckBasicExists(BasicTable, TypeId: string): Boolean;
function CheckUserBRights(BtypeID: string): Boolean;

// 取得上一张单据号码
function GetPrevVchCode(AVchcode, AVchtype: Integer; APeriod: Integer; IsOrder: Boolean): Integer;
// 取得下一张单据号码
function GetNextVchCode(AVchcode, AVchtype: Integer; APeriod: Integer; IsOrder: Boolean): Integer;
// 取得首张单据号码
function GetFirstVchCode(AVchcode, AVchtype: Integer; APeriod: Integer; IsOrder: Boolean): Integer;
// 取得末张单据号码
function GetLastVchCode(AVchcode, AVchtype: Integer; APeriod: Integer; IsOrder: Boolean): Integer;

// 返回0表示没有完成，1为自动完成，2为手工强制完成，-1表示没找到订单。
function CheckIsFinishedOrder(aVchCode: Integer): Integer;
// 通过Vchcode取得单据类型
function GetVchTypeFromVchcode(AVchcode: Integer; IsDraft: Boolean; bt: TBillType): Integer;

//获取询价表的价格
function GetInquirePrice(APtypeID,ABtypeID: string; AQty: Double; ACustom01,ACustom02,ACustom03,ACustom04,ADate: string;
 var APrice,ATax,ATaxPrice: Double): Boolean;
function GetBtypePrePrice(ABtypeId: string): Integer;
//取存货最新进价
function GetPtypeNewestBuyPrice(PTypeID: string): Double;
//取价格
function GetBillPtypePrice(FBillPtypePriceParam: TBillPtypePriceParam): TBillPtypePriceInfo;
//检测销售订单是否设置
function CheckOrderHasSetBOM(AVchType, AVchCode: Integer; actionStr: string = '删除'; billName: string = ''): Boolean;
//获取开账前的最后一天
function GetIniDate: string;
//获取单据所在期间，如果是单据日期在期初，则为0
function GetBillPeriod(billDate: string): Integer;
//检查辅助数量是否可编辑
function CheckQtyFuZhuCanModify(dUnitRate: Double): Boolean;
//获取某单位的结算单位信息
function GetSettleBtype(ABtypeId: string): TSettleBtype;
//取多编码
function GetBtypeOtherCode(APtypeID,ABtypeID: string): string;

implementation

uses uDllDataBaseIntf, uDllDBService, uDllMessageIntf, uStringConst, uBillBasicConfig, uBasalMethod,
  uInputPrintPass, uDllCondBox, uDllComm, uMessageComm, uDllBillConfig,
  uDllSystemIntf;


function GetVchtypeConfig(var ABills: TBills): Integer;
var
  Sql, szVchType, szDataArea, szDisplayName: string;
  cdsDataSet: TClientDataSet;
  i, nDataType, nDataArea, cmXwColumnNo: Integer;
  bt: ^TBillTitle;
  bi: ^TCMVchNumType;//^TBillColumn;
begin
  cdsDataSet := TClientDataSet.Create(nil);

  try
    szVchType := IntToStr(ABills.Vchtype);

    OpenSQL(
      Format(
      'select maingridtype, othergridtype, processgridtype, mainsubjecttype, othersubjecttype, processsubjecttype, summaryno, ' +
      ' SNFormat, NumberHead, DataAreas ' +
      '  from T_GBL_Vchtype where vchtype = %d', [ABills.Vchtype]),
      cdsDataSet);

    with cdsDataSet do
    begin
      First;
      ABills.MainGridType := TCMBasicType(Fields[0].AsInteger); // FieldByName('maingridtype').AsInteger);
      ABills.OtherGridType := TCMBasicType(Fields[1].AsInteger); // FieldByName('othergridtype').AsInteger);
      ABills.ProcessGridType := TCMBasicType(Fields[2].AsInteger); // FieldByName('processgridtype').AsInteger);
      ABills.MainGridSubjectType := TCMSubjectType(Fields[3].AsInteger); // FieldByName('mainsubjecttype').AsInteger);
      ABills.OtherGridSubjectType := TCMSubjectType(Fields[4].AsInteger); // FieldByName('othersubjecttype').AsInteger);
      ABills.ProcessGridSubjectType := TCMSubjectType(Fields[5].AsInteger); // FieldByName('processsubjecttype').AsInteger);
      ABills.SummaryNo := Fields[6].AsInteger; // FieldByName('summaryno').AsInteger;
      ABills.SNFormat := Fields[7].AsString;
      ABills.NumberHead := Fields[8].AsString;
      szDataArea := Fields[9].AsString;
      Close;
    end;

    for i := 1 to 5 do
    begin
      if szDataArea[i] = '1' then
        ABills.DataAreas := ABills.DataAreas + [TDataArea(i - 1)];
    end;

    Sql := 'SELECT 	vchtype, titleorder, datatype, stringno, ' +
           ' CASE WHEN ISNULL(fieldnameo, '''') = '''' THEN ISNULL(TitleName, '''') ELSE fieldnameo END AS displayname, ' +
           ' visible, enabled, readonly, required, btnvisible ' +
           ' into #t_jxc_vchtitle ' +
           ' FROM t_jxc_vchtitle ' +
           ' where vchtype = ' + szVchType +
           ' if (' + szVchType + ' <> 150) and (EXISTS (SELECT subvalue FROM T_GBL_SYSDATACW WHERE upper(lTrim(rTrim(SubName))) = ''VERSION2'' and subvalue in (''2680'', ''880''))) ' +
           '    Update #t_jxc_vchtitle Set Visible = 0 Where DataType in (62, 63, 64) ' +
           ' Select titleorder, displayname, stringno, ' +
           '    visible, enabled, readonly, required, datatype, btnvisible From #t_jxc_vchtitle order by vchtype, titleorder ' +
           ' Drop Table #t_jxc_vchtitle';
    OpenSQL(Sql, cdsDataSet);
    cdsDataSet.First;
    if cdsDataSet.RecordCount <= 0 then
    begin
      Result := -1;
      Exit;
    end;

    with cdsDataSet do
    begin
      while not Eof do
      begin
        nDataType := Fields[7].AsInteger;

//        if (ABills.Vchtype = 45) and (not FDllParams.IsCMSQ) and (nDataType = 99) then
//        begin
//          cdsDataSet.Next;
//          Continue;
//        end;

        bt := @ABills.BillTitles[TBillTitleProperty(Fields[0].AsInteger)];
        bt.Caption := Fields[1].AsString; //FieldByName('DisplayName').AsString;
        bt.CaptionNo := Fields[2].AsInteger; //FieldByName('StringNo').AsInteger;
        bt.Visible := Fields[3].AsBoolean; //FieldByName('Visible').AsBoolean;
        bt.Enabled := Fields[4].AsBoolean; //FieldByName('Enabled').AsBoolean;
        bt.Readonly := Fields[5].AsBoolean; //FieldByName('Readonly').AsBoolean;
        bt.Required := Fields[6].AsBoolean; //FieldByName('Required').AsBoolean;
        bt.CMBasicType := TCMBasicType(nDataType); //TCMBasicType(FieldByName('DataType').AsInteger);
        bt.BtnVisible := Fields[8].AsBoolean; //FieldByName('BtnVisible').AsBoolean;

        if (ABills.Vchtype <> 142) and (not CheckSysCon(SYS_EDIT_EMPLOY)) then
        begin
          if (bt.CMBasicType = CMbtetype) or (nDataType = 7) then
            bt.Required := False;
        end;

        cdsDataSet.Next;
      end;
    end;

    Sql := 'SELECT columnorder, 0 as columnno, columnname, ' +
           ' CASE WHEN ISNULL(FieldNameo, '''') = '''' Then IsNull(FieldName, '''') Else FieldNameo End as displayname, ' +
           ' FieldName As PrintName, ' +
           ' fieldname, stringno, visible, enabled, readonly, required, dataarea, CMxwColumnNo, CanSet, CanNotPrint ' +
           ' into #t_jxc_vchcolumn ' +
           ' FROM t_jxc_vchcolumn ' +
           ' where vchtype = ' + szVchType +
           ' if exists (SELECT subvalue FROM T_GBL_SYSDATACW WHERE upper(lTrim(rTrim(SubName))) = ''VERSION2'' AND subvalue in (''880'')) ' +
           '   Update #t_jxc_vchcolumn Set Visible = 0 Where CMXwColumnNo in (41, 42, 43, 44, 45) ' +
           ' if exists (SELECT subvalue FROM T_GBL_SYSDATACW WHERE upper(lTrim(rTrim(SubName))) = ''VERSION2'' AND subvalue in (''880'', ''2680'')) ' +
           '   Update #t_jxc_vchcolumn Set Visible = 0 Where CMXwColumnNo in (8, 13, 14) ' +
           ' Select columnorder, columnname, displayname, PrintName, fieldname, visible, ' +
           '    enabled, readonly, required, dataarea, CMxwColumnNo, CanSet, CanNotPrint ' +
           ' From #t_jxc_vchcolumn order by dataarea, columnorder' +
           ' Drop Table #t_jxc_vchcolumn';
    OpenSQL(Sql, cdsDataSet);
    cdsDataSet.First;
    if cdsDataSet.RecordCount <= 0 then
    begin
      Result := -2;
      Exit;
    end;

    with cdsDataSet do
    begin
      while not Eof do
      begin
        nDataArea := Fields[9].AsInteger;
        cmXwColumnNo := Fields[10].AsInteger;

        if (TDataArea(nDataArea) = daMainGrid) then
          bi := @ABills.MainGridNumTypes[TCMVchNumField(cmXwColumnNo)]
        else if (TDataArea(nDataArea) = daOtherGrid) then
          bi := @ABills.OtherGridNumTypes[TCMVchNumField(cmXwColumnNo)]
        else
          bi := @ABills.ProcessGridNumTypes[TCMVchNumField(cmXwColumnNo)];

        szDisplayName := Fields[2].AsString;
        if Trim(szDisplayName) <> '' then
          bi.Caption := szDisplayName
        else
          bi.Caption := Fields[4].AsString; //FieldByName('FieldName').AsString;

        bi.SysCaption := Fields[3].AsString; //FieldByName('PrintName').AsString;
        bi.CMNumField := TCMVchNumField(cmXwColumnNo);

        if bi.CMNumField in [CMvcfFreeDom01, CMvcfFreeDom02, CMvcfFreeDom03, CMvcfFreeDom04, CMvcfFreeDom05,
           CMvcfFreeDom06, CMvcfFreeDom07, CMvcfFreeDom08, CMvcfFreeDom09, CMvcfFreeDom10, CMvcfDateFreeDom11,
           CMvcfDateFreeDom12, CMvcfDateFreeDom13, CMvcfNumFreeDom14, CMvcfNumFreeDom15, CMvcfNumFreeDom16] then
           bi.PrintName := bi.Caption
        else
          bi.PrintName := bi.SysCaption;

        bi.Enabled := Fields[6].AsBoolean; //FieldByName('Enabled').AsBoolean;
        bi.Visible := Fields[5].AsBoolean; //FieldByName('Visible').AsBoolean;
        bi.ReadOnly := Fields[7].AsBoolean; //FieldByName('Readonly').AsBoolean;
        bi.Required := Fields[8].AsBoolean; //FieldByName('Required').AsBoolean;
        bi.szDataBaseName := Fields[1].AsString; //FieldByName('ColumnName').AsString;
        bi.DataArea := TDataArea(FieldByName('DataArea').AsInteger);
        bi.FField := GetCMBillVchFieldsList(bi.CMNumField);
        bi.NumField := GetBillNumField(bi.CMNumField);
        bi.IsBasical := GetBasicNumField(bi.CMNumField);
        if bi.IsBasical then
          bi.Visible := True;
        bi.CanNotPrint := Fields[12].AsBoolean; //FieldByName('CanNotPrint').AsBoolean;
        bi.IsCalc := bi.NumField <> vcfNull;
        bi.CanSet := Fields[11].AsBoolean; //FieldByName('CanSet').AsBoolean;
        bi.ColumnOrder := Fields[0].AsInteger; //FieldByName('ColumnOrder').AsInteger;

        Next;
      end;
    end;

    Result := 1;
  finally
    FreeAndNil(cdsDataSet);
  end;
end;

function GetVchSN(ABills: TBills; dtDate: TDateTime): string;
var
  i: Integer;
  l: Word;
  s: ShortString;
  szMaxNo, szFMT: string;
  nMaxNo: Integer;
begin
  s := '';
  Result := '';
  GetVchNumber(ABills.Vchtype, FormatDateTime('yyyy-mm-dd', dtDate), szMaxNo);
  nMaxNo := StringToInt(szMaxNo);
  szFMT := StringReplace(ABills.SNFormat, #13, '', [rfReplaceAll]);
  if szFMT = '' then
    Exit;
  Result := FormatDateTime(szFMT, dtDate);

  if Pos('机器名', Result) > 0 then
    Result := StringReplace(
      Result, '机器名', GetComputerNameSelf, [rfReplaceAll]);
  if Pos('单据前缀', Result) > 0 then
    Result := StringReplace(
      Result, '单据前缀', ABills.NumberHead, [rfReplaceAll]);
  if Pos('操作员', Result) > 0 then
    Result := StringReplace(
      Result, '操作员', GetCurrentOperatorName, [rfReplaceAll]);

  l := Pos('[', Result);
  if l > 0 then
  begin
    i := Pos(']', Result);
    if i > l then
    begin
      Inc(nMaxNo);
      Result := Copy(Result, 1, l - 1) + FormatFloat(Copy(Result, l + 1, i - l -
        1), nMaxNo) + Copy(Result, i + 1, Length(Result) - i);
    end;
  end;
end;

function LoadBillData(AVchcode, AVchtype: Integer;
  TitleData, DetailData: TClientDataSet; IsDraft: Boolean = False; AMode: Integer = 0): Integer; overload;
var
  iDraft: Integer;
  Sql, ANdxTableName, ADlyProcName: string;
begin
  Result := -6052;

  if AVchtype = 190 then
  begin
    Sql := 'SELECT  ndx.*, sc.number AS scbillnumber, dly.WorkPlanName AS gxbillnumber, CAST(ndx.pubufts AS INT) AS TimeStamp, ' +
           ' Cast(sc.pubufts as int) as SourceTimeStamp, dly.DlyOrder as SourceDlyOrder ' +
           ' FROM DlyNdxGX ndx ' +
           '  LEFT JOIN dlyndxsc sc ON sc.Vchtype = 171 AND sc.Vchcode = ndx.SourceVchcode ' +
           '  LEFT JOIN dlysc dly ON sc.Vchcode = dly.Vchcode AND dly.Usedtype = 1 ' +
           ' WHERE ndx.Vchtype = 190 AND ndx.Vchcode = %0:d ';
    Sql := Format(Sql, [AVchCode]);
  end
  else
  begin
    ANdxTableName := GetBillNdxTableName(AVchtype);
    Sql := Format('select *, CAST(pubufts AS INT) AS TimeStamp from %0:s where vchcode = %1:d', [ANdxTableName, AVchCode]);
  end;

  OpenSQL(Sql, TitleData);
  if TitleData.RecordCount <= 0 then
    Exit;

  TitleData.First;
  if Assigned(TitleData.Fields.FindField('Draft')) then
    iDraft := TitleData.FieldByName('Draft').AsInteger
  else
    iDraft := 2;

  if iDraft = 1 then
  begin
    ADlyProcName := GetBillDraftProcName(AVchtype);
    Result := OpenProcByName(ADlyProcName, ['@nMode', '@Vchcode', '@VchType', '@operatorid'],
              [AMode, AVchcode, AVchtype, GetCurrentOperatorId], DetailData, nil);
  end
  else
  begin
    ADlyProcName := GetBillDlyProcName(AVchtype);
    Result := OpenProcByName(ADlyProcName, ['@nMode', '@Vchcode', '@operatorid'],
              [AMode, AVchcode, GetCurrentOperatorId], DetailData, nil);
  end;

  if Result < 0 then
    Exit;

  Result := 0;
end;

function LoadBillData(AVchcode, AVchtype, AMode: Integer;
  TitleData, DetailData: TClientDataSet; bt: TBillType): Integer;overload;
begin
  Result := -6052;

  if bt = bbmtInvoice then
  begin
    OpenSQL(Format('Select *, CAST(pubufts AS INT) AS TimeStamp from T_jxc_InvoiceDlyndx Where Vchcode = %d And Draft = 2', [Avchcode]), TitleData);
    with TitleData do
    begin
      First;
      if Eof then Exit;
    end;

    Result := OpenProcByName('dbo.P_jxc_InvoiceLoadDly;1',
      ['@vchcode', '@Vchtype', '@nMode'], [AVchcode, AVchtype, AMode], DetailData, nil);
    if Result < 0 then Exit;

  end;
  Result := 0;
end;

//取单据除表头、表格的其他数据
function LoadBillOtherData(AVchCode, AVchType: Integer; OtherData: TClientDataSet): Integer;
begin
  Result := OpenProcByName('dbo.P_XIWA_JXCLoadOther;1', ['@VchCode', '@VchType'],
        [AVchcode, AVchtype], OtherData, nil);

  if Result < 0 then Exit;

  Result := 0;
end;

function DeleteDraft(AVchCode, AVchType: Integer): Boolean;
var
  Sql: string;
  ANdxTableName: string;
begin
  Result := False;
  BeginTrans;
  ANdxTableName := GetBillNdxTableName(AVchtype);

  Sql := 'Delete From %0:s Where VchCode = %1:d     Delete From BakDly Where VchCode = %1:d and VchType = %2:d';
  Sql := Format(Sql, [ANdxTableName, AVchCode, AVchType]);
  ExecuteSQL(Sql);

  if not ExecPlugProcAfterDeleteDraft(AVchCode, AVchType) then
  begin
    RollBackTrans;
    Exit;
  end;

  CommitTrans;
  Result := True;
end;

//草稿删除后执行插件存储过程
function ExecPlugProcAfterDeleteDraft(AVchCode, AVchType: Integer): Boolean;
var
  nOk: Integer;
  Sql, AProcName, AErrMsg: string;
  cds: TClientDataSet;
  prOutParams: TParams;
begin
  Result := False;

  prOutParams := TParams.Create(nil);
  cds := TClientDataSet.Create(nil);
  try
    Sql := 'Select ProcName From T_Inf_PlugIn_BillDeleteDraftProc Where VchType = %0:d';
    Sql := Format(Sql, [AVchType]);
    OpenSQL(Sql, cds);

    cds.First;
    while not cds.Eof do
    begin
      AProcName := cds.FieldByName('ProcName').AsString;
      prOutParams.Clear;
      nOk := ExecuteProcByName(AProcName, ['@nVchType', '@nVchCode', '@ErrMsg'],
        [AVchType, AVchCode, ''], prOutParams);
      AErrMsg := prOutParams.ParamByName('@ErrMsg').AsString;
      if nOk < 0 then
      begin
        ShowErrorMsg(AErrMsg);
        Exit;
      end;

      cds.Next;
    end;

    Result := True;
  finally
    FreeAndNil(cds);
    FreeAndNil(prOutParams);
  end;
end;

function ProcessBill(pm: TBillProcessMode; FBillProcessParam: TBillProcessParam; ShowMsgModaless: Boolean): TBillProcessRet;
var
  errMsg: WideString;
  errData: OleVariant;
  AOtherData: OleVariant;
  AOwnerData: OleVariant;
  AProcessData: OleVariant;
  Apm: enProcessMode;
  //错误提示
  FBatchErrorMsg: TBillBatchMessage;
  //需用户确认的提示
  FBatchConfirmMsg: TBillBatchMessage;
  bContinue: Boolean;
  cds: TClientDataSet;
  procedure FormatDbMsg;
  var
    AQtyMsgType: Integer;
    MsgTypeIndex, QtyMsgTypeIndex,
    PUserCodeIndex, PFullNameIndex, PStandardIndex, PTypeIndex,
    KFullNameIndex, BFullNameIndex, PSFullNameIndex, WFullNameIndex,
    ct1FullNameIndex, ct2FullNameIndex, ct3FullNameIndex, ct4FullNameIndex, BlockNoIndex, ProDateIndex,
    StockQtyIndex, ChangeQtyIndex, QtyIndex, ErrMsgIndex, SerialNoIndex: Integer;
    FBillMessageInfo: TBillMessageInfo;
  begin
    if cds.RecordCount > 0 then
    begin
      MsgTypeIndex := cds.FieldList.IndexOf('MsgType');
      QtyMsgTypeIndex := cds.FieldList.IndexOf('QtyMsgType');
      PUserCodeIndex := cds.FieldList.IndexOf('PUserCode');
      PFullNameIndex := cds.FieldList.IndexOf('PFullName');
      PStandardIndex := cds.FieldList.IndexOf('PStandard');
      PTypeIndex := cds.FieldList.IndexOf('PType');
      KFullNameIndex := cds.FieldList.IndexOf('KFullName');
      BFullNameIndex := cds.FieldList.IndexOf('BFullName');
      PSFullNameIndex := cds.FieldList.IndexOf('PSFullName');
      WFullNameIndex := cds.FieldList.IndexOf('WFullName');
      ct1FullNameIndex := cds.FieldList.IndexOf('ct1FullName');
      ct2FullNameIndex := cds.FieldList.IndexOf('ct2FullName');
      ct3FullNameIndex := cds.FieldList.IndexOf('ct3FullName');
      ct4FullNameIndex := cds.FieldList.IndexOf('ct4FullName');
      BlockNoIndex := cds.FieldList.IndexOf('BlockNo');
      ProDateIndex := cds.FieldList.IndexOf('ProDate');
      SerialNoIndex := cds.FieldList.IndexOf('SerialNo');
      StockQtyIndex := cds.FieldList.IndexOf('StockQty');
      ChangeQtyIndex := cds.FieldList.IndexOf('ChangeQty');
      QtyIndex := cds.FieldList.IndexOf('Qty');
      ErrMsgIndex := cds.FieldList.IndexOf('ErrMsg');

      cds.First;
      while not cds.Eof do
      begin
        if cds.Fields[MsgTypeIndex].AsInteger = 0 then
        begin
          AQtyMsgType := cds.Fields[QtyMsgTypeIndex].AsInteger;

          if AQtyMsgType = 0 then
            FBatchErrorMsg.AddMsg(cds.Fields[ErrMsgIndex].AsString)
          else
          begin
            FBillMessageInfo.PUserCode := cds.Fields[PUserCodeIndex].AsString;
            FBillMessageInfo.PFullName := cds.Fields[PFullNameIndex].AsString;
            FBillMessageInfo.PStandard := cds.Fields[PStandardIndex].AsString;
            FBillMessageInfo.PType := cds.Fields[PTypeIndex].AsString;
            FBillMessageInfo.KFullName := cds.Fields[KFullNameIndex].AsString;
            FBillMessageInfo.BFullName := cds.Fields[BFullNameIndex].AsString;
            FBillMessageInfo.PSFullName := cds.Fields[PSFullNameIndex].AsString;
            FBillMessageInfo.WFullName := cds.Fields[WFullNameIndex].AsString;
            FBillMessageInfo.ct1FullName := cds.Fields[ct1FullNameIndex].AsString;
            FBillMessageInfo.ct2FullName := cds.Fields[ct2FullNameIndex].AsString;
            FBillMessageInfo.ct3FullName := cds.Fields[ct3FullNameIndex].AsString;
            FBillMessageInfo.ct4FullName := cds.Fields[ct4FullNameIndex].AsString;
            FBillMessageInfo.BlockNo := cds.Fields[BlockNoIndex].AsString;
            FBillMessageInfo.ProDate := cds.Fields[ProDateIndex].AsString;
            FBillMessageInfo.SerialNo := cds.Fields[SerialNoIndex].AsString;
            FBillMessageInfo.StockQty := cds.Fields[StockQtyIndex].AsFloat;
            FBillMessageInfo.ChangeQty := cds.Fields[ChangeQtyIndex].AsFloat;
            FBillMessageInfo.Qty := cds.Fields[QtyIndex].AsFloat;
            FBillMessageInfo.ErrMsg := cds.Fields[ErrMsgIndex].AsString;

            if AQtyMsgType = 1 then
              FBatchErrorMsg.AddStockMsg(FBillMessageInfo)
            else if AQtyMsgType = 2 then
              FBatchErrorMsg.AddCommissionMsg(FBillMessageInfo)
            else if AQtyMsgType = 3 then
              FBatchErrorMsg.AddFactStockMsg(FBillMessageInfo)
            else if AQtyMsgType = 4 then
              FBatchErrorMsg.AddWorkShopMsg(FBillMessageInfo)
            else if AQtyMsgType = 5 then
              FBatchErrorMsg.AddSerialNoMsg(FBillMessageInfo)
            else if AQtyMsgType = 6 then
              FBatchErrorMsg.AddFactSerialNoMsg(FBillMessageInfo)
            else if AQtyMsgType = 7 then
              FBatchErrorMsg.AddProduceStockMsg(FBillMessageInfo)
            else if AQtyMsgType = 8 then
              FBatchErrorMsg.AddConsignStockMsg(FBillMessageInfo);
          end;
        end
        else
        begin
          AQtyMsgType := cds.Fields[QtyMsgTypeIndex].AsInteger;

          if AQtyMsgType = 0 then
            FBatchConfirmMsg.AddMsg(cds.Fields[ErrMsgIndex].AsString)
          else
          begin
            FBillMessageInfo.PUserCode := cds.Fields[PUserCodeIndex].AsString;
            FBillMessageInfo.PFullName := cds.Fields[PFullNameIndex].AsString;
            FBillMessageInfo.PStandard := cds.Fields[PStandardIndex].AsString;
            FBillMessageInfo.PType := cds.Fields[PTypeIndex].AsString;
            FBillMessageInfo.KFullName := cds.Fields[KFullNameIndex].AsString;
            FBillMessageInfo.BFullName := cds.Fields[BFullNameIndex].AsString;
            FBillMessageInfo.PSFullName := cds.Fields[PSFullNameIndex].AsString;
            FBillMessageInfo.WFullName := cds.Fields[WFullNameIndex].AsString;
            FBillMessageInfo.ct1FullName := cds.Fields[ct1FullNameIndex].AsString;
            FBillMessageInfo.ct2FullName := cds.Fields[ct2FullNameIndex].AsString;
            FBillMessageInfo.ct3FullName := cds.Fields[ct3FullNameIndex].AsString;
            FBillMessageInfo.ct4FullName := cds.Fields[ct4FullNameIndex].AsString;
            FBillMessageInfo.BlockNo := cds.Fields[BlockNoIndex].AsString;
            FBillMessageInfo.ProDate := cds.Fields[ProDateIndex].AsString;
            FBillMessageInfo.SerialNo := cds.Fields[SerialNoIndex].AsString;
            FBillMessageInfo.StockQty := cds.Fields[StockQtyIndex].AsFloat;
            FBillMessageInfo.ChangeQty := cds.Fields[ChangeQtyIndex].AsFloat;
            FBillMessageInfo.Qty := cds.Fields[QtyIndex].AsFloat;
            FBillMessageInfo.ErrMsg := cds.Fields[ErrMsgIndex].AsString;

            if AQtyMsgType = 1 then
              FBatchConfirmMsg.AddStockMsg(FBillMessageInfo)
            else if AQtyMsgType = 2 then
              FBatchConfirmMsg.AddCommissionMsg(FBillMessageInfo)
            else if AQtyMsgType = 3 then
              FBatchConfirmMsg.AddFactStockMsg(FBillMessageInfo)
            else if AQtyMsgType = 4 then
              FBatchConfirmMsg.AddWorkShopMsg(FBillMessageInfo)
            else if AQtyMsgType = 5 then
              FBatchConfirmMsg.AddSerialNoMsg(FBillMessageInfo)
            else if AQtyMsgType = 6 then
              FBatchConfirmMsg.AddFactSerialNoMsg(FBillMessageInfo)
            else if AQtyMsgType = 7 then
              FBatchConfirmMsg.AddProduceStockMsg(FBillMessageInfo)
            else if AQtyMsgType = 8 then
              FBatchConfirmMsg.AddConsignStockMsg(FBillMessageInfo);
          end;
        end;
        cds.Next;
      end;
    end;
  end;
begin
  errMsg := '';

  AOwnerData := VarArrayCreate([0, 15], varVariant);
  AOwnerData[0] := VarArrayOf(['@TitleXml@', FBillProcessParam.TitleXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[1] := VarArrayOf(['@DetailXml@', ZCompressStr(FBillProcessParam.DetailXml), Ord(ftBytes), Ord(ptInput)]);
  AOwnerData[2] := VarArrayOf(['@JsXml@', FBillProcessParam.JsXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[3] := VarArrayOf(['@ArApXml@', FBillProcessParam.ArApXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[4] := VarArrayOf(['@ArCancelXml@', FBillProcessParam.ArCancelXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[5] := VarArrayOf(['@ApCancelXml@', FBillProcessParam.ApCancelXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[6] := VarArrayOf(['@FeeAllotXml@', FBillProcessParam.FeeAllotXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[7] := VarArrayOf(['@ExpenseAllotXml@', FBillProcessParam.ExpenseAllotXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[8] := VarArrayOf(['@ToQtyXml@', FBillProcessParam.ToQtyXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[9] := VarArrayOf(['@ToQtyXml2@', FBillProcessParam.ToQtyXml2, Ord(ftString), Ord(ptInput)]);
  AOwnerData[10] := VarArrayOf(['@CorrespondXml@', FBillProcessParam.CorrespondXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[11] := VarArrayOf(['@GoodsStocksXml@', FBillProcessParam.GoodsStocksXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[12] := VarArrayOf(['@CommissionXml@', FBillProcessParam.CommissionXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[13] := VarArrayOf(['@ProduceStockXml@', FBillProcessParam.ProduceStockXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[14] := VarArrayOf(['@ConsignStockXml@', FBillProcessParam.ConsignStockXml, Ord(ftString), Ord(ptInput)]);
  AOwnerData[15] := VarArrayOf(['@SerialNoDetailXml@', ZCompressStr(FBillProcessParam.SerialNoDetailXml), Ord(ftBytes), Ord(ptInput)]);

  AOtherData := VarArrayCreate([0, 13], varVariant);
  AOtherData[0] := FBillProcessParam.Appoint;
  AOtherData[1] := FBillProcessParam.dTotalZero;
  AOtherData[2] := FBillProcessParam.CancelType;
  AOtherData[3] := FBillProcessParam.arSettleType;
  AOtherData[4] := FBillProcessParam.apSettleType;
  AOtherData[5] := FBillProcessParam.Draft;
  AOtherData[6] := GetCurrentOperatorId;
  AOtherData[7] := FBillProcessParam.isClient;
  AOtherData[8] := GetLogOnDate;
  AOtherData[9] := FBillProcessParam.Number;
  AOtherData[10] := FBillProcessParam.Period;
  AOtherData[11] := FBillProcessParam.AuditOpinion;
  AOtherData[12] := FBillProcessParam.TimeStamp;
  if pm <> bpmDraft then
    AOtherData[13] := 'True'
  else
    AOtherData[13] := 'False';

  AProcessData := VarArrayCreate([0, 1], varVariant);
  AProcessData[0] := AOwnerData;
  AProcessData[1] := AOtherData;

  case pm of
    bpmSave: Apm := pmSave;
    bpmSaveAs: Apm := pmSaveAs;
    bpmDraft: Apm := pmDraft;
    bpmUpdate: Apm := pmUpdate;
    bpmDelete: Apm := pmDelete;
    bpmRed: Apm := pmRed;
    bpmAuditing: Apm := pmAuditing;
    bpmUnAuditing: Apm := pmUnAuditing;
    bpmTurn: Apm := pmTurn;
    bpmReAuditing: Apm := pmReAuditing;
    bpmSaveAndAudit: Apm := pmSaveAndAudit;
    bpmReSettle: Apm := pmReSettle;
  else
    Apm := pmSave;
  end;

  Result.nRetCode := FDllParams.gjpSvr.ProcessBill(Apm, FBillProcessParam.VchType, FBillProcessParam.VchCode, AProcessData, errMsg, errData);
  Result.errMsg := errMsg;

  if Result.nRetCode = -10 then
  begin
    cds := TClientDataSet.Create(nil);
    cds.Data := errData;
    FBatchErrorMsg := TBillBatchMessage.Create;
    FBatchConfirmMsg := TBillBatchMessage.Create;
    FormatDbMsg;
    try
      if FBatchErrorMsg.HasMsg then
      begin
        if ShowMsgModaless then
          FBatchErrorMsg.ShowErrorBatchMsgModaless
        else
          FBatchErrorMsg.ShowErrorBatchMsg;
        Exit;
      end;

      if FBatchConfirmMsg.HasMsg then
      begin
        if ShowMsgModaless then
          bContinue := FBatchConfirmMsg.ConfirmYesNoBatchMsgModaless
        else
          bContinue := FBatchConfirmMsg.ConfirmYesNoBatchMsg;

        if bContinue then
        begin
          AOtherData[13] := 'False';
          AProcessData[1] := AOtherData;
          errData := Null;
          Result.nRetCode := FDllParams.gjpSvr.ProcessBill(Apm, FBillProcessParam.VchType, FBillProcessParam.VchCode, AProcessData, errMsg, errData);
          Result.errMsg := errMsg;
        end;
      end;
    finally
      FreeAndNil(FBatchErrorMsg);
      FreeAndNil(FBatchConfirmMsg);
      FreeAndNil(cds);
    end;
  end;
end;

// 复制草稿
function bi_CopyDraftToDraft(AVchcode, AVchtype, BVchtype: Integer; AOp: string; var sErrMsg: string): Integer;
var
  FBills: TBills;
  vParam: TParams;
  procName: string;
begin
  FBills.Vchtype := BVchtype;

  vParam := TParams.Create(nil);
  try
    procName := GetBillCopyDraftToDraftProcName(AVchtype);
    if procName = '' then
    begin
      sErrMsg := '没有相应存储过程';
      Result := -1;
      Exit;
    end;
    Result := ExecuteProcByName(procName, ['@nSVchcode', '@nSVchtype', '@nDVchtype', '@szNumber', '@szEtypeid'],
            [AVchcode, AVchtype, BVchtype, '', AOp], vParam);
    if Result < 0 then
      sErrMsg := '源单不存在或被删除';
  finally
    FreeAndNil(vParam);
  end;
  //更新szNumber的计数
end;

function GetBillTypeEnum(bt: TBillType): enBillType;
begin
  Result := enBillType(Ord(bt));
end;

function GetProductPriceTrack(const szBTypeID, szPTypeID, szKTypeID: string): TProductPrice;
var
  vPrice: OleVariant;
begin
  FillChar(Result, SizeOf(TProductPrice), 0);
  if FDllParams.gjpSvr.GetPriceTrack(szBTypeID, szPTypeID, szKTypeID, vPrice) then
    UnpackProductPrice(vPrice, Result);
end;

function GetBillModifyLockValue(AVchtype, AVchcode: Integer; AValue: Integer): Integer;
var lReturn: Integer;
  Param: TParams;
  cMode: char;
begin
  if AValue = 0 then
    cMode := 'U'
  else
    cMode := 'S';
  try
      Param := TParams.Create;
      lReturn := ExecuteProcByName('P_Jxc_BillUpdateStats;1', ['@cMode', '@nVchcode', '@nVchtype', '@nLockValue'],
        [cMode, AVchcode, AVchtype, 0], Param);
    if lReturn = 0 then
      Result := Param.ParamByName('@nLockValue').AsInteger
    else
      Result := 0;

  finally
    FreeAndNil(Param);
  end;
end;

function CompareVchFormat(nVchtype1, nVchtype2: Integer): Boolean;

  function CompareCol(nDataArea, nColNo: Integer): Boolean;
  var nRet: Integer;
  begin
    nRet := ExecuteProcByName('p_jxc_CompareVchFormat;1',
      ['@nVchType1', '@nVchType2', '@nColNo', '@nDataArea'],
      [nVchtype1, nVchtype2,  nColNo, nDataArea],nil);
    Result := nRet = 0;
  end;
begin
  if CompareCol(0, 25) then
    Result := CompareCol(0, 28)
  else
    Result := False;

  if not Result then Exit;

  Result := CompareCol(0, 46);
end;

function CheckRARPJieSuanSavetoDB(AVchcode: Integer): Boolean;
var lReturn: Integer;
begin
  lReturn := ExecuteProcByName('sy_CheckGatheringDly;1', ['@nGatheringVchCode'], [Avchcode], nil);
  Result := lReturn = 0;
end;

function  CheckBillCanModify(AVchcode, AVchType: Integer): Boolean;
var lReturn: Integer;
begin
  Result := False;
  try
    lReturn := ExecuteProcByName('p_jxc_CheckBillCanModify;1', ['@nVchcode', '@nVchType'], [Avchcode, AVchType], nil);
    case lReturn of
      0: Result := True;
      else
        ShowWarningMsg(GetMessage(lReturn));
    end;
  except
  end;
end;

function GetBillNumberByVchcode(nVchcode: Integer): string;
var szSQL: string;
  cdSQL: TClientDataset;
begin
  Result := '';
  szSQL := Format('select Number from DlyNdx where Vchcode = %d', [nVchcode]);
  try
    cdSQL := TClientDataSet.Create(nil);
    if OpenSQL(szSQL, cdSQL) then
      Result := cdSQL.FieldByName('Number').AsString;
  finally
    FreeAndNil(cdSQL);
  end;

end;

function GetBtypeCurrentARAP(szBtypeID: string): Double;
var 
  szSQL: string;
  cdSQL:  TClientDataset;
begin
  Result := 0.00;
  if szBtypeID = '' then
    Exit;

  //ybo 应收－预收    应付－预付
  szSQL := Format('select (ArTotal - PreArTotal) as ArTotal, (APTotal - PreAPTotal) as ApTotal, IsClient from btype where TypeID = ''%s'' ', [szBtypeID]);
  try
    cdSQL := TClientDataSet.Create(nil);
    if OpenSQL(szSQL, cdSQL) then
    begin
      if cdSQL.FieldByName('IsClient').AsInteger = 1 then
        Result := cdSQL.FieldByName('ArTotal').AsFloat
      else
        Result := cdSQL.FieldByName('ApTotal').AsFloat;
    end;
  finally
    FreeAndNil(cdSQL);
  end;
end;

function GetBtypeRARPDateLimit(nVchType: Integer; szBtypeID, szDefaultDate: string): string;
var
  nDay: Extended;
  Sql, szNewDate: string;
  nRDate: Integer;//Variant;
  My_TempDate: TDatetime;
begin
  Result := '';
  if szBtypeID = '' then
    Exit;

  Sql := 'Select RDate From BType Where TypeId = ''%0:s''';
  nRDate := GetValueFromSQL(Format(Sql, [szBtypeID]));
  if nRDate < 0 then
    nRDate := 0;

  nDay := nRDate;
  //Bug 59 lkun 没得客户收款期限的时候，直接把收款日期刷掉
  if (nDay <= 0) and (nVchType in [11, 26, 34, 37]) then
    szNewDate := ''
  else
  begin
    My_TempDate := GetLogOnDateTime + nDay;
    if My_TempDate > StrToDateTime('9999-12-31') then
      szNewDate := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime)
    else
      szNewDate := FormatDateTime('yyyy-mm-dd', My_TempDate);
  end;

//  if Trim(szNewDate) = '' then
//    szNewDate := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);

  Result :=  szNewDate;
end;

function ConvertValueforUnit(AValue, dUnitRate: Double; nCurUnit, ResultUnit: Integer): Double;
var
  tmpValue: Double;
begin
  if dUnitRate < 0.000000001 then dUnitRate := 1;

  case ResultUnit of
    0: Result := AValue;
    1:
      begin
        if nCurUnit = 1 then //基本单位
          tmpValue := AValue
        else      //辅助单位->基本单位
          tmpValue := AValue / dUnitRate;

        Result := tmpValue;
      end;
    2:
      begin
        if nCurUnit = 1 then
          tmpValue := AValue * dUnitRate //基本单位->辅助单位
        else
          tmpValue := AValue;  //辅助单位

        Result := tmpValue;
      end;
    else
      Result := AValue;
  end;

end;

function GetPtypeTrackPriceAndPrePrice(szPtypeID, szBtypeID: string): TProductPrice;
var
  //szSQL,
  szSQL1: string;
  cds: TClientDataSet;
begin
//屏蔽，最近进价报警不判断往来单位了
//  szSQL := 'select costprice, saleprice, discount from Price where ptypeId = ''%s'' and btypeid = ''%s''';
//  szSQL := Format(szSQL, [szPtypeID, szBtypeID]);
  szSQL1 := 'select usercode, fullname, PrePrice1, PrePrice2, PrePrice3, Preprice4, PrePrice5, PrePrice6, RecPrice, DisRecPrice, '
            +' Price7, Price8, Price9, Price10, Price90, OtherPrice, minsaleprice from ptype '
            +' where typeId = ''%s''';
  szSQL1 := Format(szSQL1, [szPtypeID]);

  cds := TClientDataSet.Create(nil);
  with cds do
  try
//    OpenSQL(szSQL, cds);
//    if not Eof then
//    begin
//      Result.dBuyPrice := FieldByName('costprice').AsFloat;
//      Result.dSalePrice := FieldByName('saleprice').AsFloat;
//      Result.dSaleDiscount := FieldByName('discount').AsFloat;
//      Result.dBuyDiscount := Result.dSaleDiscount;
//    end
//    else
//    begin
//      Result.dBuyPrice := 0;
//      Result.dSalePrice := 0;
//      Result.dSaleDiscount := 0;
//      Result.dBuyDiscount := 0;
//    end;
//    cds.Close;
    OpenSQL(szSQL1, cds);
    First;
    if not Eof then
    begin
      Result.szTypeID := szPTypeID;
      Result.szUserCode := FieldByName('usercode').AsString;
      Result.szFullName := FieldByName('fullname').AsString;
      Result.dPrePrice1 := FieldByName('PrePrice1').AsFloat;
      Result.dPrePrice2 := FieldByName('PrePrice2').AsFloat;
      Result.dPrePrice3 := FieldByName('PrePrice3').AsFloat;
      Result.dPrePrice4 := FieldByName('PrePrice4').AsFloat;
      Result.dPrePrice5 := FieldByName('PrePrice5').AsFloat;
      Result.dPrePrice6 := FieldByName('PrePrice6').AsFloat;
      Result.dPrePrice7 := FieldByName('Price7').AsFloat;
      Result.dPrePrice8 := FieldByName('Price8').AsFloat;
      Result.dPrePrice9 := FieldByName('Price9').AsFloat;
      Result.dRecPrice := FieldByName('RecPrice').AsFloat;
      Result.dDisRecPrice := FieldByName('DisRecPrice').AsFloat;
      Result.dNewSalePrice := FieldByName('Price90').AsFloat;
      Result.dOtherNewPrice := FieldByName('OtherPrice').AsFloat;
      Result.dCostPrice := FieldByName('minsaleprice').AsFloat;   //最低售价
      Result.dBuyPrice := Result.dRecPrice;
      Result.dSalePrice := Result.dNewSalePrice;
      Result.dSaleDiscount := 0;
      Result.dBuyDiscount := 0;
    end
    else
    begin
      Result.szTypeID := szPTypeID;
      Result.szUserCode := '';
      Result.szFullName := '';
      Result.dPrePrice1 := 0;
      Result.dPrePrice2 := 0;
      Result.dPrePrice3 := 0;
      Result.dPrePrice4 := 0;
      Result.dPrePrice5 := 0;
      Result.dPrePrice6 := 0;
      Result.dPrePrice7 := 0;
      Result.dPrePrice8 := 0;
      Result.dPrePrice9 := 0;
      Result.dRecPrice := 0;
      Result.dDisRecPrice := 0;
      Result.dNewSalePrice := 0;
      Result.dOtherNewPrice := 0;
      Result.dCostPrice := 0;   //最低售价
      Result.dBuyPrice := 0;
      Result.dSalePrice := 0;
      Result.dSaleDiscount := 0;
      Result.dBuyDiscount := 0;
    end;
  finally
    FreeAndNil(cds);
  end;
end;

function DoubleValueSameDirection(AValue1, AValue2: Double): Boolean;
begin
  if (AValue1 > 0) and (AValue2 > 0) then
    Result := True
  else if (AValue1 < 0) and (AValue2 < 0) then
    Result := True
  else
    Result := False;
end;

function CheckDataBeyond(AValue: Double; IsCW: Boolean = False): Boolean;
var MaxValue, MinValue: Double;
begin
  Result := True;
  if IsCW then
  begin
    MaxValue := 100000000;
    MinValue := -100000000;
  end
  else
  begin
    MaxValue := 10000000000;
    MinValue := -10000000000;
  end;

  if Trunc(AValue) > MaxValue then
    Result := False
  else
  if Trunc(AValue) < MinValue then
    Result := False;

end;

function GetBillIsInoviceUse(AVchtpe, AVchcode: Integer): Boolean;
var
  szSQL: string;
  cds: TClientDataset;
begin
  Result := False;

  if not (AVchtpe in [6, 11, 34, 26, 45, 37]) then
    Exit;
  try
    cds := TClientDataSet.Create(nil);
    szSQL := Format('select InvoiceType from dlyndx where vchcode = %d', [AVchcode]);
    OpenSQL(szSQL, cds);
    if cds.RecordCount > 0 then
      Result := cds.FieldByName('InvoiceType').AsInteger <> 0
    else
      Result := False;    //ybo 2007-08-21 这里改为false，防止单据被删除之后还报已经开票的错误提示
  finally
    FreeAndNil(cds);
  end;
end;

function GetBillJxcPeriod: Integer;
begin
  Result := StringToInt(GetSysValue('JxcPeriod'));
end;

function GetProduceVchCode(AMode, AVchcode, AVchtype: Integer; APeriod, BillTypeMode: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
begin
  HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then  //有查看其他操作员录入单据的权限
  begin
    Result := ExecuteProcByName('p_sc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo', '@BillType'],
      [AMode, 'A', AVchtype, AVchcode, APeriod, GetCurrentOperatorId, BillTypeMode], nil);
  end
  else
  begin
    Result := ExecuteProcByName('p_sc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo', '@BillType'],
      [AMode, 'F', AVchtype, AVchcode, APeriod, GetCurrentOperatorId, BillTypeMode], nil);
  end;

  if Result = 0 then Result := AVchcode;
end;

function GetXunJiaVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_XunJia_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetCheckVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_Bill_GetCheckLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetIniGoodsStockVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_Bill_GetLastNextVch_IniGoodsStock;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetIniFactStockVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_Bill_GetLastNextVch_IniFactStock;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetIniCommissionVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_Bill_GetLastNextVch_IniCommission;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetIniArApVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_Bill_GetLastNextVch_IniArAp;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetIniProduceVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_Bill_GetLastNextVch_IniProduce;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetIniConsignVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_Bill_GetLastNextVch_IniConsign;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetGxVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
  cMode:string;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then
    cMode := 'A'
  else
    cMode := 'F';
   Result := ExecuteProcByName('P_Gx_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod',  '@InuptNo'],
      [AMode, cMode, AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  if Result = 0 then Result := AVchcode;
end;

function GetInvoiceVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer; AInvoiceMode: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then  //有查看其他操作员录入单据的权限
  begin
    Result := ExecuteProcByName('p_sc_GetLastNextInvoiceVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@lMode', '@InuptNo'],
      [AMode, 'A', AVchtype, AVchcode, APeriod, AInvoiceMode, GetCurrentOperatorId], nil);
  end
  else
  begin
    Result := ExecuteProcByName('p_sc_GetLastNextInvoiceVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@lMode', '@InuptNo'],
      [AMode, 'F', AVchtype, AVchcode, APeriod, AInvoiceMode, GetCurrentOperatorId], nil);
  end;

  if Result = 0 then Result := AVchcode;
end;

function GetBillType(Vchtype: Integer): TBilltype;
begin
  if Vchtype in ORDER_VCHTYPES then
    Result := bbmtOrder
  else if Vchtype in INVOICE_VCHTYPES then
    Result := bbmtInvoice
  else if Vchtype in PRODUCEOTHER_VCHTYPES then
    Result := bbmtProduce
  else if Vchtype in [WLHX_VCHTYPE] then
    Result := bbmtWLHX
  else if Vchtype in [Buy_Requisition_VchType,Sale_Offer_VchType] then
    Result := bbmtXunJia
  else if Vchtype in [WORK_ORDER_VCHTYPE, WORK_HAND_OVER_VCHTYPE, WORK_TICKET_VCHTYPE] then
    Result := bbmtGX
  else
    Result := bbmtStandard;
end;

function CheckSameBlockNo(ABlockNo, APtypeid, KTypeid: String; goodsNo: Integer): Boolean;
var
  SQL: String;
  cds: TClientDataSet;
Begin
  cds := TClientDataSet.Create(nil);
  try
    if (KTypeid = '') or (KTypeid = '00000') then
      SQL := 'if exists(Select 1 from GoodsStocksCost Where JobNumber = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''' and goodsorder <> ' + IntToStr(goodsNo) + ')' +
             '    Select 1 ' +
             ' Else ' +
             '    Select 0 '
    else
    begin
      SQL := 'if exists(Select 1 From GoodsStocks g inner join GoodsStocksCost gc On g.GoodsOrder = gc.GoodsOrder ' +
             '              Where gc.JobNumber = ''%0:s'' and gc.Ptypeid = ''%1:s'' and g.KTypeid = ''%2:s'' and g.Ptypeid = ''%1:s'' and g.goodsorder <> %3:d) ' +
             '    Select 1 ' +
             ' Else ' +
             '    Select 0';
      SQL := Format(SQL, [ABlockNo, APtypeid, KTypeid, goodsNo]);

//      SQL := 'if exists(Select 1 from GoodsStocks Where GoodsOrder in (Select GoodsOrder From GoodsStocksCost Where JobNumber = ''' + ABlockNo + '''' +
//             ' and Ptypeid = ''' + APtypeid + ''') and KTypeid = ''' + KTypeid + ''' and Ptypeid = ''' + APtypeid + ''' and goodsorder <> ' + IntToStr(goodsNo) + ')' +
//             '    Select 1 ' +
//             ' Else ' +
//             '    Select 0 ';
    end;

    OpenSQL(SQL, cds);
    cds.First;
    Result := cds.Fields[0].AsInteger = 1;
  finally
    FreeAndNil(cds);
  end;
End;

function CheckBlockNoInOldBill(BillType, AVchcode: Integer; ABlockNo, APtypeid, KTypeid: String): Boolean;
var
  SQL: String;
  cds: TClientDataSet;
Begin
  cds := TClientDataSet.Create(nil);
  try
    if (KTypeid = '') or (KTypeid = '00000') then
    begin
      Case BillType of
        BUY_VCHTYPE:
          SQL := 'if exists(Select 1 from DlyBuy Where RedOld = ''F'' and Vchcode = ' + IntToStr(AVchcode) + ' and BlockNo = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';
        INLIB_VCHTYPE,
        GET_VCHTYPE:
          SQL := 'if exists(Select 1 from DlyOther Where RedOld = ''F'' and Vchcode = ' + IntToStr(AVchcode) + ' and BlockNo = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';
        PRODUCE_VCHTYPE:
          SQL := 'if exists(Select 1 from DlyOther Where RedOld = ''F'' and UsedType = 2 and Vchcode = ' + IntToStr(AVchcode) + ' and BlockNo = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';
        PRODUCE_CHECKACCEPT_VCHTYPE,
        CONSIGN_CHECKACCEPT_VCHTYPE:
          SQL := 'if exists(Select 1 from DlyOther Where RedOld = ''F'' and UsedType = 1 and Vchcode = ' + IntToStr(AVchcode) + ' and BlockNo = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';
      End;
    end
    else
    begin
      Case BillType of
        BUY_VCHTYPE:
          SQL := 'if exists(Select 1 from DlyBuy Where RedOld = ''F'' and Vchcode = ' + IntToStr(AVchcode) + ' and BlockNo = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''' and KTypeid = ''' + KTypeid + ''')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';
        INLIB_VCHTYPE,
        GET_VCHTYPE:
          SQL := 'if exists(Select 1 from DlyOther Where RedOld = ''F'' and Vchcode = ' + IntToStr(AVchcode) + ' and BlockNo = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''' and KTypeid = ''' + KTypeid + ''')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';
        PRODUCE_VCHTYPE:
          SQL := 'if exists(Select 1 from DlyOther Where RedOld = ''F'' and UsedType = 2 and Vchcode = ' + IntToStr(AVchcode) + ' and BlockNo = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''' and KTypeid = ''' + KTypeid + ''')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';
        PRODUCE_CHECKACCEPT_VCHTYPE,
        CONSIGN_CHECKACCEPT_VCHTYPE:
          SQL := 'if exists(Select 1 from DlyOther Where RedOld = ''F'' and UsedType = 1 and Vchcode = ' + IntToStr(AVchcode) + ' and BlockNo = ''' + ABlockNo + ''' and Ptypeid = ''' + APtypeid + ''' and KTypeid = ''' + KTypeid + ''')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';
      End;
    end;

    OpenSQL(SQL, cds);
    Result := cds.Fields[0].AsInteger = 0;
  finally
    FreeAndNil(cds);
  end;
end;

function CheckBillIsGathering(AVchCode: Integer): Boolean;
var
  lReturn: Integer;
begin
  lReturn := ExecuteProcByName('P_JXC_CheckBillIsGathering;1', ['@nVchCode'], [AVchCode], nil);
  Result := lReturn = 0;
end;

function CheckAtypeIsYINGSYUS(Atypeid: String): Integer;
const
  cCodeLength = 10;
var
  sATypePrefix, sContrastATypeID: string;
begin
  Result := 0;
  if Length(Atypeid) >= cCodeLength then
  begin
    sContrastATypeID := Copy(GetATypeID('AR_ID'), 1, cCodeLength);
    sATypePrefix := Copy(Atypeid, 1, cCodeLength);
    if SameText(sATypePrefix, sContrastATypeID) then
      Result := 1
    else begin
      sContrastATypeID := Copy(GetATypeID('PRE_AR_ID'), 1, cCodeLength);
      sATypePrefix := Copy(Atypeid, 1, cCodeLength);
      if SameText(sATypePrefix, sContrastATypeID) then
        Result := 2;
    end;
  end;
end;

function CheckBillIsUseOther(AVchType, AVchCode: Integer): Boolean;
var
  SQL: String;
begin
  SQL := 'Select SourceVchcode from DlyNdx Where Vchcode = ' + IntToStr(AVchCode) + '';
  Result := GetValueFromSQL(SQL) <> 0;
end;

//批号、日期
function GetBlockNoFromGoodsStocks(Ptypeid, GoodsNo: String; Vchcode:Integer;ktypeid:String;var BlockNo: string; var ProDate: string): Boolean;
var
  SQL: String;
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  BlockNo := '';
  ProDate := '';
  Result := False;

  try
    SQL := 'Select BlockNo, ProDate From ';
    SQL := SQL + '(Select IsNull(JobNumber,'''') as BlockNo,IsNull(OutFactoryDate,'''') as ProDate From GoodsStocksCost Where Ptypeid = ''' + Ptypeid + ''' and GoodsOrder = ' + GoodsNo + '';
    SQL := SQL + ' Union All ';
    SQL := SQL + ' Select IsNull(BlockNo,'''') as BlockNo,IsNull(ProDate,'''') as ProDate From DlyBuy Where Ptypeid = ''' + Ptypeid + ''' and GoodsNo = ' + GoodsNo + ' ' + ' and vchcode <> ' + inttostr(Vchcode) + ' AND Qty > 0 AND redword = ''F''' + ' AND KtypeID = ''' + KtypeID + '''';
    SQL := SQL + ' Union All ';
    SQL := SQL + ' Select IsNull(BlockNo,'''') as BlockNo,IsNull(ProDate,'''') as ProDate From DlySale Where Ptypeid = ''' + Ptypeid + ''' and GoodsNo = ' + GoodsNo + ' ' + ' and vchcode <> ' + inttostr(Vchcode) + ' AND Qty > 0 AND redword = ''F''' + ' AND KtypeID = ''' + KtypeID + '''';
    SQL := SQL + ' Union All ';
    SQL := SQL + ' Select IsNull(BlockNo,'''') as BlockNo,IsNull(ProDate,'''') as ProDate From DlyOther Where Ptypeid = ''' + Ptypeid + ''' and GoodsNo = ' + GoodsNo + ' '  + ' and vchcode <> ' + inttostr(Vchcode) + ' AND Qty > 0 AND Pdetail <> 2 AND redword = ''F''' + ' AND KtypeID = ''' + KtypeID + '''' + ') a ';

    OpenSQL(SQL,cds);

    cds.First;
    if not cds.Eof then
    begin
      BlockNo := cds.FieldByName('BlockNo').AsString;
      ProDate := cds.FieldByName('ProDate').AsString;
      Result := True;
    end;
  finally
    cds.Free;
  end;
end;

function SourceBillIsRedDelete(AVchCode: Integer): Boolean;
var
  SQL: String;
begin
  SQL := 'if exists(Select 1 from dlyndx Where RedOld = ''F'' and VchCode = ' + IntToStr(AVchCode) + ')' +
         '    Select 1 ' +
         ' Else ' +
         '    Select 0 ';
  Result := GetValueFromSQL(SQL) = 0;
end;

function SourceBillIsModifyOrRedDelete(AVchCode: Integer; BTypeID: string): Boolean;
var
  SQL: String;
begin
  SQL := 'if exists(Select 1 From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + ')' +
         '    Select 1 ' +
         ' Else ' +
         '    Select 0 ' ;
  if GetValueFromSQL(SQL) = 0 then
  begin
    Result := True;
    Exit;
  end;

  SQL := 'Select VchType From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + '';
  if GetValueFromSQL(SQL) = 83 then
    SQL := 'if exists(Select 1 from dlyndx Where RedOld = ''F'' and VchCode = ' + IntToStr(AVchCode) + ' and BTypeID2 = ''' + BTypeID + ''')' +
           '    Select 1 ' +
           ' Else ' +
           '    Select 0 '
  else
    SQL := 'if exists(Select 1 from dlyndx Where RedOld = ''F'' and VchCode = ' + IntToStr(AVchCode) + ' and BTypeID = ''' + BTypeID + ''')' +
           '    Select 1 ' +
           ' Else ' +
           '    Select 0 ';
  Result := GetValueFromSQL(SQL) = 0;
end;

//重新取批次号，暂时用于调拨单存草稿
function GetOutGoodsNo(Ptypeid: String; Vchcode, VchType: Integer): String;
var
  SQL: String;
  Draft: Integer;
begin
  SQL := 'if exists(Select 1 From DlyNdx Where Vchcode = ' + IntToStr(Vchcode) + ')' +
         '    Select 1 ' +
         ' Else ' +
         '    Select 0 ';
  if GetValueFromSQL(SQL) = 0 then
  begin
    Result := '0';
    Exit;
  end;

  SQL := 'Select Draft From DlyNdx Where Vchcode = ' + IntToStr(Vchcode) + '';
  Draft := GetValueFromSQL(SQL);
  If Draft = 1 then
    SQL := 'Select GoodsNo From BakDly Where Vchcode = ' + IntToStr(Vchcode) + ' and Ptypeid = ''' + Ptypeid + ''''
  else if Draft = 2 then
    SQL := 'Select GoodsNo From DlyOther Where Vchcode = ' + IntToStr(Vchcode) + ' and Ptypeid = ''' + Ptypeid + ''' and usedtype <> 1'
  else
    SQL := 'Select GoodsNo From DlyAudit Where Vchcode = ' + IntToStr(Vchcode) + ' and VchType = ' + IntToStr(VchType) + ' and Ptypeid = ''' + Ptypeid + ''' and UsedType = 1';
  Result := GetValueFromSQL(SQL);
end;

function CheckOrderisSelect(AVchtype, AVchCode: Integer): Boolean;
var
  SQL, SQLO: String;
begin
  Result := False;
  if AVchtype = 150 then
  begin
    SQL := 'if exists(Select 1 From BakDlyOrder b inner Join DlyBuy d inner join DlyNdx ndx On d.VchCode = ndx.VchCode ' +
           '                 On b.DlyOrder = abs(d.SourceDlyOrder) ' +
           '             Where b.VchType = 150 and b.VchCode = %d and ndx.VchType in (34, 161) and ' +
           '                 ndx.RedWord = ''F'' and ndx.RedOld = ''F'' and ndx.Draft = 2) ' +
           '   Select 1 ' +
           ' Else ' +
           '   Select 0 ';
    SQLO := 'if exists(Select 1 From BakDlyOrder b inner Join DlyBuy d inner join DlyNdx ndx On d.VchCode = ndx.SourceVchCode ' +
            '        On b.DlyOrder = abs(d.SourceDlyOrder) ' +
            '    Where b.VchType = 150 and b.VchCode = %d and d.VchType = 161 and ndx.VchType = 34 and ' +
            '        ndx.RedWord = ''F'' and ndx.RedOld = ''F'' and ndx.Draft = 2) ' +
            '   Select 1 ' +
            ' Else ' +
            '   Select 0 ';

    SQL := Format(SQL, [AVchCode]);
    SQLO := Format(SQLO, [AVchCode]);
    Result := (GetValueFromSQL(SQL) = 1) or (GetValueFromSQL(SQLO) = 1);
  end
  else if AVchtype = 151 then
  begin
    SQL := 'if exists(Select 1 From BakDlyOrder b inner Join DlySale d inner join DlyNdx ndx On d.VchCode = ndx.VchCode ' +
           '                 On b.DlyOrder = abs(d.SourceDlyOrder) ' +
           '             Where b.VchType = 151 and b.VchCode = %d and ndx.VchType in (11, 25) and ' +
           '                 ndx.RedWord = ''F'' and ndx.RedOld = ''F'' and ndx.Draft = 2) ' +
           '   Select 1 ' +
           ' Else ' +
           '   Select 0 ';
    SQLO := 'if exists(Select 1 from BatchRoleDetail where SourceVchtype = 151 and SourceVchCode = %d) ' +
            '    Select 1 ' +
            ' Else ' +
            '    Select 0 ';

    SQL := Format(SQL, [AVchCode]);
    SQLO := Format(SQLO, [AVchCode]);
    Result := (GetValueFromSQL(SQL) = 1) or (GetValueFromSQL(SQLO) = 1);
  end;
end;

function CheckPlanIsSelect(AVchtype, AVchCode: Integer):Boolean;
var
  SQL:String;
begin
  Result := False;
  if AVchtype = 170 then
  begin
    SQL := 'if exists(Select 1 from BatchRoleDetail where SourceVchtype = 170 and SourceVchCode = '+ IntToStr(AVchCode) + ')' +
           '    Select 1 ' +
           ' Else ' +
           '    Select 0 ' ;
    Result := (GetValueFromSQL(SQL) = 1);
  end;
end;

function CheckCostModified(AVchtype, AVchCode: Integer; cbSetCost: Boolean): Boolean;
var
  SQL: String;
  nSetCost: Integer;
begin
  SQL := 'if exists(select 1 from dlyndx where vchcode = ' + IntToStr(AVchCode) + ' and Draft = 2)' +
         '    Select 1 ' +
         ' Else ' +
         '    Select 0 ' ;
  if GetValueFromSQL(SQL) = 0 then
  begin
    ShowWarningMsg('该单据已经被删除。');
    Result := True;
    Exit;
  end;
  
  SQL := 'Select CashOver From DlyNdx Where VchType = ' + IntToStr(AVchtype) + ' and VchCode = ' + IntToStr(AVchCode) + '';
  nSetCost := GetValueFromSQL(SQL);
  if ((nSetCost = 1) and cbSetCost) or ((nSetCost = 0) and (not cbSetCost)) then
    Result := False
  else
  begin
    ShowWarningMsg('你没有金额明细权限，不能使用指定成本功能。');
    Result := True;
  end;
end;

function CheckBillCanOpen(AVchtype, AVchCode: Integer; showMsg: Boolean = True): Boolean;
var
  Sql, tableName: String;
  HasVisibleAllBill: Boolean;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  Result := False;

  tableName := Trim(GetBillNdxTableName(AVchtype));
  if HasVisibleAllBill or (tableName = '') then  //有查看其他操作员录入单据的权限
  begin
    Result := True;
    Exit;
  end;

  Sql := 'if exists(Select 1 From %0:s Where VchCode = %1:d)' +
         '    Select 1 ' +
         ' Else ' +
         '    Select 0 ';
  Sql := Format(Sql, [tableName, AVchCode]);
  if GetValueFromSQL(Sql) = 0 then
  begin
    Result := True;
    Exit;
  end;

  Sql := 'Select InputNo From %0:s Where VchCode = %1:d';
  Sql := Format(Sql, [tableName, AVchCode]);
  if GetCurrentOperatorId <> GetValueFromSQL(Sql) then
  begin
    if showMsg then
      ShowWarningMsg('您没有查看其他操作员录入单据的权限，不能打开单据。')
  end
  else
    Result := True;
end;

function CheckAuditBill(AVchtype, AVchCode: Integer; IsDraft: Boolean): Boolean;
var
  Sql, tableName: String;
begin
  tableName := GetBillNdxTableName(AVchtype);
  if Trim(tableName) = '' then
  begin
    Result := True;
    Exit;
  end;

  Sql := 'if exists(select 1 from %0:s where vchcode = %1:d)' +
         '    Select Draft From %0:s Where VchCode = %1:d ' +
         ' Else ' +
         '    Select 4 ';
  Sql := Format(Sql, [tableName, AVchCode]);
  Result := GetValueFromSQL(Sql) = 4;
end;

function CheckBillUseOther(AVchtype, AVchCode: Integer; IsAuditing: Boolean): Boolean;
var
  SQL: string;
begin
  if (AVchtype in [34, 161]) then
  begin
    if IsAuditing then
      SQL := 'if exists(Select 1 From DlyAudit Where VchCode = ' + IntToStr(AVchCode) + ' and SourceDlyOrder in (Select -1 * DlyOrder From BakDlyOrder))' +
             '    Select 1 ' +
             ' Else ' +
             '    Select 0 '
    else
      SQL := 'if exists(Select 1 From DlyBuy Where VchCode = ' + IntToStr(AVchCode) + ' and SourceDlyOrder <> 0)' +
             '    Select 1 ' +
             ' Else ' +
             '    Select 0 ';
  end
  else if (AVchtype in [11, 25]) then
  begin
    if IsAuditing then
      SQL := 'if exists(Select 1 From DlyAudit Where VchCode = ' + IntToStr(AVchCode) + ' and SourceDlyOrder in (Select -1 * DlyOrder From BakDlyOrder))' +
             '    Select 1 ' +
             ' Else ' +
             '    Select 0 '
    else
      SQL := 'if exists(Select 1 From DlySale Where VchCode = ' + IntToStr(AVchCode) + ' and SourceDlyOrder <> 0)' +
             '    Select 1 ' +
             ' Else ' +
             '    Select 0 ';
  end
  else
  begin
    Result := False;
    Exit;
  end;

  Result := GetValueFromSQL(SQL) = 1;
end;

function CheckRightDraft(ABtnType: TCMBtnType): Boolean;
var
  FLimitList: string;
begin
  FLimitList := CheckLimit('草稿查询');

  Result := FLimitList[Ord(ABtnType)] = '1';
end;

function CheckSpecialCharAndLength(sDest, sCaption: string; nIndex, maxLength: integer): Boolean;
begin
  Result := True;
  if Pos('''', sDest) > 0 then
  begin
    Result := False;
    ShowWarningMsg(Format('第%d行[%s]不允许有特殊字符单引号“''”。', [nIndex, sCaption]));
    Exit;
  end;
  if Pos('"', sDest) > 0 then
  begin
    Result := False;
    ShowWarningMsg(Format('第%d行[%s]不允许有特殊字符双引号“"”。', [nIndex, sCaption]));
    Exit;
  end;
  if (maxLength>0) and (Length(Trim(sDest))>maxLength) then
  begin
    Result := False;
    ShowWarningMsg(Format('第%d行[%s]录入太长，不能超过[%d]个字符。', [nIndex, sCaption, maxLength]));
    Exit;
  end;
end;

function CheckDateFormat(sDest, sCaption: string; nIndex: integer): Boolean;
begin
  Result := True;
  if DateCheckString(sDest) or (Copy(sDest, 5, 1) <> '-') or (Copy(sDest, 8, 1) <> '-') or (Length(sDest) > 10) then
  begin
    ShowWarningMsg(Format('第%d行的[%s]输入错误，正确格式应该是：2010-01-01', [nIndex, sCaption]));
    Result := False;
    Exit;
  end;

  if StringToDate(sDest) < StringToDate('1989-12-30') then
  begin
    ShowWarningMsg(Format('第%d行的[%s]录入有误，不能录入1989-12-30前的日期。', [nIndex, sCaption]));
    Result := False;
    Exit;
  end;
end;

function CheckMaxMinValue(dValue, dMaxValue, dMinValue: Extended; iRow: Integer; sCaption:String): Boolean;
begin
  Result := True;
  if (Trunc(dValue) > dMaxValue) or
     (Trunc(dValue) < dMinValue) then
  begin
    ShowWarningMsg(Format('第%d行[%s]超过系统允许的值，不能继续。', [iRow, sCaption]));
    Result := False;
  end;
end;

function CheckGoodsHave(Ptypeid: string; GoodsNo, VchCode: Integer): Boolean;
var
  SQL1, SQL2, SQL3, SQL4, SQL5, SQL6: String;
begin
  SQL1 := 'if exists(Select 1 from inigoodsstockscost where ptypeid = ''' + Ptypeid + ''' and GoodsOrder = ' + IntToStr(GoodsNo) + ')' +
          '    Select 1 ' +
          ' Else ' +
          '    Select 0 ';
  SQL2 := 'if exists(Select 1 from DlyBuy where ptypeid = ''' + Ptypeid + ''' and goodsno = ' + IntToStr(GoodsNo) + ' and VchCode <> ' + IntToStr(VchCode) + ')' +
          '    Select 1 ' +
          ' Else ' +
          '    Select 0 ';
  SQL3 := 'if exists(Select 1 from DlySale where vchtype <> 26 and ptypeid = ''' + Ptypeid + ''' and goodsno = ' + IntToStr(GoodsNo) + ' and VchCode <> ' + IntToStr(VchCode) + ')' +
          '    Select 1 ' +
          ' Else ' +
          '    Select 0 ';
  SQL4 := 'if exists(Select 1 from DlyOther where vchtype <> 50 and ptypeid = ''' + Ptypeid + ''' and goodsno = ' + IntToStr(GoodsNo) + ' and VchCode <> ' + IntToStr(VchCode) + ')' +
          '    Select 1 ' +
          ' Else ' +
          '    Select 0 ';

  SQL5 := 'if exists(Select 1 from inigoodsstockscostsc where ptypeid = ''' + Ptypeid + ''' and GoodsOrder = ' + IntToStr(GoodsNo) + ')' +
          '    Select 1 ' +
          ' Else ' +
          '    Select 0 ';
  SQL6 := 'if exists(Select 1 from inigoodsstockscostweiwai where ptypeid = ''' + Ptypeid + ''' and GoodsOrder = ' + IntToStr(GoodsNo) + ')' +
          '    Select 1 ' +
          ' Else ' +
          '    Select 0 ';

  if not FDllParams.IsCMSQ then
    Result := (GetValueFromSQL(SQL1) = 1 ) or
              (GetValueFromSQL(SQL2) = 1 ) or
              (GetValueFromSQL(SQL3) = 1 ) or
              (GetValueFromSQL(SQL4) = 1 ) or
              (GetValueFromSQL(SQL5) = 1 ) or
              (GetValueFromSQL(SQL6) = 1 )
  else
    Result := (GetValueFromSQL(SQL1) = 1 ) or
              (GetValueFromSQL(SQL2) = 1 ) or
              (GetValueFromSQL(SQL3) = 1 ) or
              (GetValueFromSQL(SQL4) = 1 );
end;

function CheckOtherViewCost: Boolean;
begin
  if not CheckVchDetailRight(BUY_VCHTYPE, '金额') then
  begin
    Result := False;
    Exit;
  end;

  if not CheckVchDetailRight(INSTOCK_VALUE_VCHTYPE, '金额') then
  begin
    Result := False;
    Exit;
  end;

  Result := True;
end;

function GetChineseFuZhuUnitDis(aszUnit1, aszUnit2: string; adQty, adRate: double; const UnitType: Integer): string;
var
  nDd, dDx, liinteger: Double;
  szTemp: string;
begin
  nDd := 0;

  if (adRate <> 0) and (adRate <> 1) then
  begin
    szTemp := '';
    if adQty < 0 then szTemp := '-';
    adQty := Abs(adQty);

    //单位关系>1
    if adRate > 1 then
    begin
      liinteger := adQty / adRate;
      try
        nDd := trunc(StringToDoubleF(DoubleToStringDigitBit(liinteger, 4)));
      except
        ShowWarningMsg('您录入的数量值过大，无法进行计算。');
      end;

      dDx := StringToDoubleF(DoubleToStringDigitBit(adQty - nDd * adRate, 4));
      if nDd > 0 then szTemp := szTemp + DoubleToStringDigitBit(nDd, 0) + aszUnit2;
      if dDx > 0 then szTemp := szTemp + DoubleToStringDigitBit(dDx, 4) + aszUnit1;
    end
    else
    begin
      try
        nDd := trunc(adQty);
      except
        ShowWarningMsg('您录入的数量值过大，无法进行计算。');
      end;

      dDx := StringToDoubleF(DoubleToStringDigitBit((adQty - nDd) / adRate, 4));
      if nDd > 0 then szTemp := szTemp + DoubleToStringDigitBit(nDd, 0) + aszUnit1;
      if dDx > 0 then szTemp := szTemp + DoubleToStringDigitBit(dDx, 4) + aszUnit2;

    end;
    
    Result := szTemp;
  end
  else
  begin
    if UnitType = 1 then //UnitType:1-基本单位;2-辅助单位
      Result := DoubleToStringDigitBit(adQty, 4) + aszUnit1
    else
      Result := DoubleToStringDigitBit(adQty, 4) + aszUnit2;
  end;

  if Abs(adQty) < EIGHTDOUBLE_ZERO then
    Result := '';
end;

function CheckOrderRowExists(sDlyOrder: Integer): Boolean;
var
  SQL: string;
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  try
    SQL := 'if exists (Select 1 From BakDlyOrder Where DlyOrder = ' + IntToStr(Abs(sDlyOrder)) + ')' +
           '    Select 1 ' +
           ' Else ' +
           '    Select 0 ';

    OpenSQL(SQL, cds);
    cds.First;
    Result := cds.Fields[0].AsInteger = 1;
  finally
    FreeAndNil(cds);
  end;
end;

function CheckBillHasBasicRights(AVchtype, AVchCode: Integer; IsDraft: Boolean; showMessage: Boolean = True): Boolean;
var
  Draft: Integer;
  SQL, tableName: String;
  HasAllRights: Boolean;
begin
  HasAllRights := True;
  Draft := 2;

  tableName := GetBillNdxTableName(AVchtype);
  if Trim(tableName) = '' then
  begin
    Result := True;
    Exit;
  end;

  if (AVchtype in AllBillCheckBrightsVchTypes) or
     (AVchtype in AllBillCheckKrightsVchTypes) or
     (AVchtype in AllBillCheckDrightsVchTypes) or
     (AVchtype in AllBillCheckPrightsVchTypes) then
  begin
    SQL := 'if exists(Select 1 From %s Where VchCode = %d)' +
           '    Select 1 ' +
           ' Else ' +
           '    Select 0 ';
    if GetValueFromSQL(Format(SQL, [tableName, AVchCode])) = 0 then
    begin
      Result := True;
      Exit;
    end;
  end
  else
  begin
    Result := True;
    Exit;
  end;

  if AVchtype in AllBillCheckBrightsVchTypes then
  begin
    if AVchtype = 83 then
      SQL := 'if exists(Select 1 From GetUserNotBrights(''%0:s'') b inner Join ' +
            '            ( ' +
            '              Select BtypeId From %2:s Where VchCode = %1:d ' +
            '              Union All ' +
            '              Select BtypeId2 as BtypeId From %2:s Where VchCode = %1:d ' +
            '            ) d On b.BtypeId = d.BtypeId ) ' +
            '     Select 1 ' +
            ' Else ' +
            '     Select 0'
//    else if AVchtype in [11, 26, 45] then
//      SQL := 'if exists(Select 1 From GetUserNotBrights(''%0:s'') b inner Join ' +
//            '            ( ' +
//            '              Select BtypeId From %2:s Where VchCode = %1:d ' +
//            '              Union All ' +
//            '              Select SettleBtypeId as BtypeId From %2:s Where VchCode = %1:d ' +
//            '            ) d On b.BtypeId = d.BtypeId ) ' +
//            '     Select 1 ' +
//            ' Else ' +
//            '     Select 0'
    else
      SQL := 'if exists(Select 1 From GetUserNotBrights(''%0:s'') b inner Join %2:s d On b.BtypeId = d.BtypeId Where d.VchCode = %1:d) ' +
             '     Select 1 ' +
             ' Else ' +
             '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode, tableName]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end;

  if not (AVchtype in AllNoDraftVchTypes) then
  begin
    SQL := 'Select Draft From %0:s Where VchCode = ' + IntToStr(AVchCode) + '';
    Draft := GetValueFromSQL(Format(SQL, [tableName]));
  end;

  CheckBillHasKRights(AVchtype, AVchCode, Draft, HasAllRights);
  CheckBillHasDRights(AVchtype, AVchCode, Draft, HasAllRights);
  CheckBillHasPRights(AVchtype, AVchCode, Draft, HasAllRights);

  if not HasAllRights then
  begin
    if showMessage then
      ShowWarningMsg('您没有单据上所涉及基本信息的权限，不能打开。');
    Result := False;
  end
  else
    Result := True;
end;

procedure CheckBillHasKRights(AVchtype, AVchCode: Integer; var Draft: Integer; var HasAllRights: Boolean);
var
  SQL, SQLDetail: String;
begin
  if AVchtype in AllBillCheckKrightsVchTypes then
  begin
    case AVchtype of
      BUY_VCHTYPE,
      BUYBACK_VCHTYPE:
        begin
          SQL := 'Select Draft From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + '';
          Draft := GetValueFromSQL(SQL);

          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdx d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          if Draft = 1 then
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join BakDly d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 '
          else
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyBuy d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      SALE_VCHTYPE,
      SALEBACK_VCHTYPE:
        begin
          SQL := 'Select Draft From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + '';
          Draft := GetValueFromSQL(SQL);

          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdx d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          if Draft = 1 then
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join BakDly d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 '
          else
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlySale d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      PRODUCE_VCHTYPE:
        begin
          SQL := 'Select Draft From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + '';
          Draft := GetValueFromSQL(SQL);

          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner Join ' +
								 '    ( ' +
                 '      Select KTypeId as KtypeId From DlyNdx Where VchCode = %1:d ' +
                 '      Union ' +
                 '      Select KTypeID2 as KtypeId From DlyNdx Where VchCode = %1:d ' +
                 '    ) d On k.KtypeId = d.KtypeId ) ' +
                 '         Select 1 ' +
                 '     Else ' +
                 '         Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          if Draft = 1 then
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join BakDly d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 '
          else
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyOther d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      INLIB_VCHTYPE,
      OUTLIB_VCHTYPE:
        begin
          SQL := 'Select Draft From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + '';
          Draft := GetValueFromSQL(SQL);

          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdx d On k.KtypeId = d.KtypeId Where d.VchCode = %d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          if Draft = 1 then
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join BakDly d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 '
          else
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyOther d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      PRICE_ALLOT_VCHTYPE,
      FACTSTOCK_ALLOT_VCHTYPE:
        begin
          SQL := 'Select Draft From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + '';
          Draft := GetValueFromSQL(SQL);

          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner Join ' +
								 '    (Select KTypeID2 as KtypeId From DlyNdx Where VchCode = %1:d) d On k.KtypeId = d.KtypeId ) ' +
                 '         Select 1 ' +
                 '     Else ' +
                 '         Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
        end;
      FACTSTOCK_INLIB_VCHTYPE,
      FACTSTOCK_OUTLIB_VCHTYPE:
        begin
          SQL := 'Select Draft From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + '';
          Draft := GetValueFromSQL(SQL);

           SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdx d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          if Draft = 1 then
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join BakDly d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 '
          else
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyStock d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      ORDER_SALE_VCHTYPE,
      ORDER_BUY_VCHTYPE:
        begin
          SQL := 'Select Draft From DlyNdxOrder Where VchCode = ' + IntToStr(AVchCode) + '';
          Draft := GetValueFromSQL(SQL);

          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdxOrder d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
        end;
      PRODUCE_DRAW_VCHTYPE,
      PRODUCE_DRAW_BACK_VCHTYPE,
      CONSIGN_DRAW_VCHTYPE,
      CONSIGN_DRAW_BACK_VCHTYPE,
      SIMPLE_CONSIGN_DRAW_VCHTYPE,
      SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE:
        begin
          SQL := 'if not exists(Select 1 From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + ')' +
                 '    Select 1 ' +
                 ' Else ' +
                 '    Select 0 ';

          if GetValueFromSQL(SQL) = 1 then
          begin
            SQL := 'Select Draft From DlyNdx Where VchCode = ' + IntToStr(AVchCode) + '';
            Draft := GetValueFromSQL(SQL);
          end;

           SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdx d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          if Draft = 1 then
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join BakDly d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 '
          else
            SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyOther d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                         '       Select 1 ' +
                         '   Else ' +
                         '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      Ini_GoodsStock_VCHTYPE:
        begin
          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdxIni d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyIni d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d and d.VchType = %2:d) ' +
                       '       Select 1 ' +
                       '   Else ' +
                       '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      Ini_FactStock_VCHTYPE:
        begin
          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdxIniFact d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyIniFact d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d and d.VchType = %2:d) ' +
                       '       Select 1 ' +
                       '   Else ' +
                       '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      Ini_Settle_VCHTYPE:
        begin
          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdxArApIni d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyArApIni d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d and d.VchType = %2:d) ' +
                       '       Select 1 ' +
                       '   Else ' +
                       '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
        end;
      CHANGE_PRICE_VCHTYPE:
        begin
          SQLDetail := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyOther d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d and d.VchType = %2:d) ' +
                       '       Select 1 ' +
                       '   Else ' +
                       '       Select 0 ';

          SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQLDetail) = 0);
        end;
      else
        begin
          SQL := 'if exists(Select 1 From GetUserNotKrights(''%0:s'') k inner join DlyNdx d On k.KtypeId = d.KtypeId Where d.VchCode = %1:d) ' +
                 '       Select 1 ' +
                 '   Else ' +
                 '       Select 0 ';

          SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);

          HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
        end;
    end;
  end;
end;

procedure CheckBillHasDRights(AVchtype, AVchCode: Integer; var Draft: Integer; var HasAllRights: Boolean);
var
  SQL, SQLDetail, tableName: String;
begin
  if not (AVchtype in AllBillCheckDrightsVchTypes) then
    Exit;

  tableName := GetBillNdxTableName(AVchtype);
  if Trim(tableName) = '' then
    Exit;

  if AVchtype = Buy_Requisition_VchType then
  begin
    SQL := 'if exists(Select 1 From GetUserNotDrights(''%0:s'') b inner Join ' +
           '         ( ' +
           '           Select ProjectId From T_XunJia_DlyNdx Where VchCode = %1:d ' +
           '           Union All ' +
           '           Select ProjectId2 as ProjectId From T_XunJia_DlyNdx Where VchCode = %1:d ' +
           '         ) d On b.DtypeId = d.ProjectId) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = EXPENSEWIPEOUT_VCHTYPE then
  begin
    SQL := 'if exists(Select 1 From GetUserNotDrights(''%0:s'') b inner Join DlyNdx d On b.DtypeId = d.ProjectId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    if Draft = 1 then
      SQLDetail := 'if exists(Select 1 From GetUserNotDrights(''%0:s'') b inner Join BakDly d On b.DtypeId = d.ProjectId ' +
                   '     Where d.VchCode = %1:d and VchType = %2:d) ' +
                   '     Select 1 ' +
                   ' Else ' +
                   '     Select 0'
    else
      SQLDetail := 'if exists(Select 1 From GetUserNotDrights(''%0:s'') b inner Join DlyA d On b.DtypeId = d.ProjectId ' +
                   '     Where d.VchCode = %1:d and VchType = %2:d) ' +
                   '     Select 1 ' +
                   ' Else ' +
                   '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    SQLDetail := Format(SQLDetail, [GetCurrentOperatorId, AVchCode, AVchtype]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0) and (GetValueFromSQL(SQLDetail) = 0);
  end
  else
  begin
    SQL := 'if exists(Select 1 From GetUserNotDrights(''%0:s'') b inner Join %2:s d On b.DtypeId = d.ProjectId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode, tableName]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end;
end;

procedure CheckBillHasPRights(AVchtype, AVchCode: Integer; var Draft: Integer; var HasAllRights: Boolean);
var
  SQL: String;
begin
  if not (AVchtype in AllBillCheckPrightsVchTypes) then
    Exit;

  if Draft = 1 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join BakDly d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d and d.VchType = %2:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode, AVchtype]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
    Exit;
  end;

  if AVchtype in [6, 34, 161] then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyBuy d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype in [11, 45, 26] then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlySale d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype in [142, 143] then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join T_XunJia_Dly d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype in [150, 151] then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join BakDlyOrder d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype in [46, 47, 48] then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyStock d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 201 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyIni d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 202 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyIniFact d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 203 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyIniCom d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 204 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyArApIni d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 206 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyIniProduce d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 207 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyIniConsign d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype in [170, 171, 180, 181] then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlySc d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 190 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlySc d On p.PtypeId = d.PtypeId ' +
           ' inner Join DlyGx gx On d.VchCode = gx.SourceVchCode Where gx.VchCode = %1:d and d.UsedType = 1) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 191 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlySc d On p.PtypeId = d.PtypeId ' +
           ' inner Join DlyNdxGx ndx On d.VchCode = ndx.SourceVchCode ' +
           ' inner Join DlyGx gx On gx.SourceVchCode = ndx.VchCode Where gx.VchCode = %1:d and d.UsedType = 1) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 192 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlySc d On p.PtypeId = d.PtypeId ' +
           ' inner Join DlyGx gx On d.VchCode = gx.SourceVchCode Where gx.VchCode = %1:d and d.UsedType = 1 and gx.SourceVchType = 171) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);

    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlySc d On p.PtypeId = d.PtypeId ' +
           ' inner Join DlyNdxGx ndx On d.VchCode = ndx.SourceVchCode ' +
           ' inner Join DlyGx gx On gx.SourceVchCode = ndx.VchCode Where gx.VchCode = %1:d and d.UsedType = 1 and gx.SourceVchType = 190) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype in [172, 182] then
  begin

    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlySc d On p.PtypeId = d.PtypeId ' +
           ' inner Join T_Sc_LLDDYRWD t On t.SourceVchCode = d.VchCode and t.SourceVchType = d.VchType Where t.VchCode = %1:d and d.UsedType = 1) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);

    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyOther d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 175 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyOther d On p.PtypeId = d.PtypeId ' +
           ' inner Join SCGatheringDly s On d.VchCode = s.VchCode and d.DlyOrder = s.SourceDlyOrder Where s.GatheringVchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype = 187 then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyOther d On p.PtypeId = d.PtypeId ' +
           ' inner Join GatheringDlyWeiWai2 s On d.VchCode = s.VchCode and d.DlyOrder = s.SourceDlyOrder Where s.GatheringVchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else if AVchtype in [146, 147] then
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyCheck d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end
  else
  begin
    SQL := 'if exists(Select 1 From GetUserNotPrights(''%0:s'') p inner Join DlyOther d On p.PtypeId = d.PtypeId Where d.VchCode = %1:d) ' +
           '     Select 1 ' +
           ' Else ' +
           '     Select 0';

    SQL := Format(SQL, [GetCurrentOperatorId, AVchCode]);
    HasAllRights := HasAllRights and (GetValueFromSQL(SQL) = 0);
  end;
end;

function GetAuditLeveal(AVchType, AVchCode: Integer): Integer;
var
  Sql, tableName: String;
begin
  tableName := GetBillNdxTableName(AVchType);

  if (AVchCode = 0) or (AVchType in [81, 82]) or (Trim(tableName) = '') then
  begin
    Result := 0;
    Exit;
  end;

  Sql := 'if exists(Select 1 from %0:s where VchCode = %1:d)' +
         '    Select IsNull(AuditLeveal, 0) as AuditLeveal From %0:s Where VchCode = %1:d ' +
         ' Else ' +
         '    Select 0 ';
  Sql := Format(Sql, [tableName, AVchCode]);
  Result := GetValueFromSQL(Sql);
end;

function GetProduceBOM(nMode: Integer; szPtypeID: string; cdsBOM: TClientDataset): Integer;
begin
  Result := OpenProcByName('p_sc_GetBOMdetail;1', ['@lMode', '@szPTypeID'], [nMode, szPtypeID], cdsBOM);
end;

function CheckPCyc(szPtypeID, szParID: String): Boolean;
var
  nRet: Integer;
  vParam: TParams;
begin
  Result := True;
  vParam := TParams.Create(nil);
  try
    nRet := ExecuteProcByName('p_sc_PCyc', ['@szPtypeID', '@szParPtypeID', '@ErrorMessage'],
            [Trim(szPtypeID), Trim(szParID),  ''], vParam);
    if nRet < 0 then
    begin
      ShowWarningMsg(vParam.ParamByName('@ErrorMessage').AsString);
      Result := False;
    end;
  finally
    FreeAndNil(vParam);
  end;
end;

function GetProduceCostPrice(AVchtype: Integer; szPtypeID: string): Double;
var szSQL, szTableName: string;
  cds: TClientDataset;
begin
  cds := TClientDataset.Create(nil);
  try
    if (AVchtype = PRODUCE_DRAW_VCHTYPE) or (AVchtype = CONSIGN_DRAW_VCHTYPE) then
      szTableName := 'GoodsStocksCost'
    else if AVchtype in [PRODUCE_DRAW_BACK_VCHTYPE, PRODUCE_LOSE_VCHTYPE, PRODUCE_CHECKACCEPT_VCHTYPE] then
      szTableName := 'GoodsStocksSCCost'
    else if (AVchtype = CONSIGN_DRAW_BACK_VCHTYPE) or (AVchtype = CONSIGN_CHECKACCEPT_VCHTYPE) then
      szTableName := 'GoodsStocksCostWeiWai'
    else
      szTableName := '';

    Result := 0;
    if (szTableName<>'') then
    begin
      szSQL := ' select top 1 (case when qty <> 0 then CONVERT(numeric(18,4), total / qty) else Price end) as price '+
               ' from ' + szTableName +
               ' where ptypeID = ''%s''' +
               ' and (qty <> 0 or total <> 0)';
      OpenSQL(Format(szSQL, [szPtypeID]), cds);
      if not cds.Eof then
        Result := cds.FieldByName('price').AsFloat;
    end;
  finally
    FreeAndnil(cds);
  end;
end;

function GetProduceSourceBill(AVchtype, AVchcode: Integer): TBillTitleData;
var
  cdsSource: TClientDataSet;
begin
  try
    cdsSource := TClientDataSet.Create(nil);
    OpenProcByName('p_sc_GetDlyNdx;1', ['@Vchtype', '@Vchcode'], [AVchtype, AVchcode], cdsSource);
    with cdsSource do
    begin
      if not Eof then
      begin
        Result.Vchcode := AVchcode;
        Result.VchType := AVchcode;
        Result.Date := FieldByName('Date').AsString;
        Result.Number := FieldByName('Number').AsString;
        Result.ETypeID := FieldByName('EtypeID').AsString;
        Result.WTypeID := FieldByName('WTypeID').AsString;
        Result.BTypeID := FieldByName('BTypeID').AsString;
        Result.PTypeID := FieldByName('PTypeID').AsString;
        Result.CustomID1 := FieldByName('PUserCode').AsString;
        Result.CustomID2 := FieldByName('PFullName').AsString;
        Result.SourceVchcode := FieldByName('SourceVchcode').AsInteger;
        Result.MatchQty := FieldByName('Qty').AsFloat;
        Result.UnitOther := FieldByName('UnitOther').AsString;
      end;
    end;
  finally
    FreeAndNil(cdsSource);
  end;
end;

//批号、日期
function GetBlockNoFromGoodsStocksSC(Ptypeid: String; GoodsNo, Vchcode: Integer; Wtypeid: String; var BlockNo: string; var ProDate: string): Boolean;
var
  SQL: String;
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  BlockNo := '';
  ProDate := '';
  Result := False;

  try
    SQL := 'Select BlockNo, ProDate From ';
    SQL := SQL + '(Select IsNull(JobNumber,'''') as BlockNo,IsNull(OutFactoryDate,'''') as ProDate From GoodsStocksSCCost Where Ptypeid = ''' + Ptypeid + ''' and GoodsOrder = ' + IntToStr(GoodsNo) + '';
    SQL := SQL + ' Union All ';
    SQL := SQL + ' Select IsNull(BlockNo,'''') as BlockNo,IsNull(ProDate,'''') as ProDate From DlyOther Where Ptypeid = ''' + Ptypeid + ''' and GoodsNo = ' + IntToStr(GoodsNo) + ' '  + ' and vchcode <> ' + inttostr(Vchcode) + ' AND Qty > 0 AND Pdetail <> 2 AND redword = ''F''' + ' AND WtypeID = ''' + WtypeID + ''' and VchType in (172, 173, 176, 177)) a ';

    OpenSQL(SQL,cds);

    cds.First;
    if not cds.Eof then
    begin
      BlockNo := cds.FieldByName('BlockNo').AsString;
      ProDate := cds.FieldByName('ProDate').AsString;
      Result := True;
    end;
  finally
    cds.Free;
  end;
end;

//批号、日期
function GetBlockNoFromGoodsStocksWeiWai(Ptypeid: String; GoodsNo, Vchcode: Integer; Btypeid: String; var BlockNo: string; var ProDate: string): Boolean;
var
  SQL: String;
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  BlockNo := '';
  ProDate := '';
  Result := False;

  try
    SQL := 'Select BlockNo, ProDate From ';
    SQL := SQL + '(Select IsNull(JobNumber,'''') as BlockNo,IsNull(OutFactoryDate,'''') as ProDate From GoodsStocksCostWeiWai Where Ptypeid = ''' + Ptypeid + ''' and GoodsOrder = ' + IntToStr(GoodsNo) + '';
    SQL := SQL + ' Union All ';
    SQL := SQL + ' Select IsNull(BlockNo,'''') as BlockNo,IsNull(ProDate,'''') as ProDate From DlyOther Where Ptypeid = ''' + Ptypeid + ''' and GoodsNo = ' + IntToStr(GoodsNo) + ' '  + ' and vchcode <> ' + inttostr(Vchcode) + ' AND Qty > 0 AND Pdetail <> 2 AND redword = ''F''' + ' AND BtypeID = ''' + BtypeID + ''' and VchType in (182, 183)) a ';

    OpenSQL(SQL,cds);

    cds.First;
    if not cds.Eof then
    begin
      BlockNo := cds.FieldByName('BlockNo').AsString;
      ProDate := cds.FieldByName('ProDate').AsString;
      Result := True;
    end;
  finally
    cds.Free;
  end;
end;

function GetConsignBtypeInfo(Btypeid: string): TConsignBType;
var
  sql: string;
  cds: TClientDataSet;
  FConsignBtypeInfo: TConsignBType;
begin
  cds := TClientDataSet.Create(nil);
  sql := 'Select UserCode, FullName, Area, TelAndAddress, Fax, Person From BType Where TypeID = ''' + Trim(Btypeid) + '''';
  OpenSQL(sql, cds);
  cds.First;

  FConsignBtypeInfo.szTypeID := Btypeid;
  FConsignBtypeInfo.szUserCode := '';
  FConsignBtypeInfo.szFullName := '';
  FConsignBtypeInfo.telNo := '';
  FConsignBtypeInfo.Address := '';
  FConsignBtypeInfo.Fax := '';
  FConsignBtypeInfo.LinkMan := '';

  if not cds.Eof then
  begin
    FConsignBtypeInfo.szTypeID := Btypeid;
    FConsignBtypeInfo.szUserCode := cds.FieldByName('UserCode').AsString;
    FConsignBtypeInfo.szFullName := cds.FieldByName('FullName').AsString;
    FConsignBtypeInfo.telNo := cds.FieldByName('Area').AsString;
    FConsignBtypeInfo.Address := cds.FieldByName('TelAndAddress').AsString;
    FConsignBtypeInfo.Fax := cds.FieldByName('Fax').AsString;
    FConsignBtypeInfo.LinkMan := cds.FieldByName('PerSon').AsString;
  end;

  Result := FConsignBtypeInfo;
end;

//返回成本for个别
function GetProduceCostPriceHand(AVchtype, GoodsNo: Integer; szPtypeID: string): Double;
var
  szSQL, szTableName: string;
  cds: TClientDataset;
begin
  cds := TClientDataset.Create(nil);
  try
    if (AVchtype = PRODUCE_DRAW_VCHTYPE) or (AVchtype = CONSIGN_DRAW_VCHTYPE) then
      szTableName := 'GoodsStocksCost'
    else if AVchtype in [PRODUCE_DRAW_BACK_VCHTYPE, PRODUCE_LOSE_VCHTYPE, PRODUCE_GET_VCHTYPE, PRODUCE_CHECKACCEPT_VCHTYPE] then
      szTableName := 'GoodsStocksSCCost'
    else if (AVchtype = CONSIGN_DRAW_BACK_VCHTYPE) or (AVchtype = CONSIGN_CHECKACCEPT_VCHTYPE) then
      szTableName := 'GoodsStocksCostWeiWai'
    else
      szTableName := '';

    Result := 0;
    if (szTableName<>'') then
    begin
      szSQL := ' select top 1 (case when qty <> 0 then CONVERT(numeric(18,4), total / qty) else Price end) as price '+
               ' from ' + szTableName +
               ' where ptypeID = ''%s''' +
               ' and GoodsOrder = ' + IntToStr(GoodsNo) + '';
      OpenSQL(Format(szSQL, [szPtypeID]), cds);
      if not cds.Eof then
        Result := cds.FieldByName('price').AsFloat;
    end;
  finally
    FreeAndnil(cds);
  end;
end;

function CheckBillHasLoadByWLHX(AVchType, AVchCode: Integer): Boolean;
var
  SQL: string;
begin
  Result := False;

  if AVchType in [ORDER_BUY_VCHTYPE, ORDER_SALE_VCHTYPE, INVOICE_SALEBILL, INVOICE_BUYBILL, PRODUCE_PLAN_VCHTYPE,Buy_Requisition_VchType,Sale_Offer_VchType,
                  PRODUCE_ROLE_VCHTYPE, CONSIGN_PLAN_VCHTYPE, CONSIGN_TASK_VCHTYPE, WORK_ORDER_VCHTYPE, WORK_HAND_OVER_VCHTYPE, WORK_TICKET_VCHTYPE] then
  begin
    Result := True;
    Exit;
  end;

  SQL := 'if exists(Select 1 From DlyAudit Where VchType = 83 and VchCode2 = ' + IntToStr(AVchCode) + ')' +
         '    Select 1 ' +
         ' Else ' +
         '    Select 0 ';
  if GetValueFromSQL(SQL) = 1 then
  begin
    ShowWarningMsg('单据已被往来核销单选用，不能继续。');
    Exit;
  end;

  //SQL := 'if exists(Select 1 From GatheringDly Where VchCode = ' + IntToStr(AVchCode) + ' and GatheringVchCode in (Select Distinct(VchCode) From DlyNdx Where VchType = 83))' +
  SQL := 'if exists(Select 1 From GatheringDly g inner join DlyNdx d On g.GatheringVchCode = d.VchCode Where g.VchCode = %d and d.VchType = 83)' +
         '    Select 1 ' +
         ' Else ' +
         '    Select 0 ';
  SQL := Format(Sql, [AVchCode]);
  if GetValueFromSQL(SQL) = 1 then
  begin
    ShowWarningMsg('单据已被往来核销单选用，不能继续。');
    Exit;
  end;

  Result := True;
end;

function CheckPrintPass(AVchType, AVchCode: Integer; IsDraft, needAddPrintCount: Boolean): Boolean;
var
  SQL, SQLFind, SQLUP, tableName: string;
  nCheckResult, PrintCount: Integer;
  cds: TClientDataSet;
begin
  Result := False;

  nCheckResult := ExecuteProcByName('P_GBL_PrintPassword', ['@cMode', '@Password', '@NewPassword'], ['E', '', ''], nil);

  cds := TClientDataSet.Create(nil);
  try
    tableName := GetBillNdxTableName(AVchType);
    if Trim(tableName) = '' then
    begin
      Result := True;
      Exit;
    end;

    SQL := 'Select PrintCount From T_Bill_PrintCount Where VchCode = %0:d and VchType = %1:d';
    SQLFind := 'if exists(Select 1 From %0:s Where VchCode = %1:d)' +
               '  Select 1 ' +
               'Else ' +
               '  Select 0 ';
    SQLUP := 'if exists(Select 1 From T_Bill_PrintCount Where VchCode = %0:d and VchType = %1:d) ' +
             '    Update T_Bill_PrintCount Set PrintCount = PrintCount + 1 Where VchCode = %0:d and VchType = %1:d ' +
             ' Else ' +
             '    Insert Into T_Bill_PrintCount(VchCode, VchType, PrintCount) Values(%0:d, %1:d, 1)';
    SQL := Format(SQL, [AVchCode, AVchType]);
    SQLFind := Format(SQLFind, [tableName, AVchCode]);
    SQLUP := Format(SQLUP, [AVchCode, AVchType]);

    PrintCount := StrToIntDef(GetValueFromSQL(SQL), 0);
    if PrintCount > 0 then
    begin
      if (nCheckResult > 0) then
      begin
        if (not InputPrintPass) then
          Exit;
      end;
    end;

    OpenSQL(SQLFind, cds);
    cds.First;
    if needAddPrintCount and (cds.Fields[0].AsInteger = 1) then
      ExecuteSQL(SQLUP);

    Result := True;
  finally
    FreeAndNil(cds);
  end;
end;

function GetPrintCount(AVchType, AVchCode: Integer): Integer;
var
  SQL: string;
begin
  SQL := 'Select PrintCount From T_Bill_PrintCount Where VchCode = %0:d and VchType = %1:d';
  SQL := Format(SQL, [AVchCode, AVchType]);

  Result := StrToIntDef(GetValueFromSQL(SQL), 0);
end;

function BillSquare(cMode: string; nVchType, nVchCode: Integer; var oParams: Variant): Boolean;
var
  nResult: Integer;
  CondSquareMode: TCondition;
  outParams: TParams;
begin
  Result := False;

  with CondSquareMode do
  begin
    SetLength(ConditionSet, 1);

    ConditionSet[0].ConditionType := CMbtCustom05;
    ConditionSet[0].ControlType := ctValueComBoBox;
    ConditionSet[0].Caption := '付讫方式';
    ConditionSet[0].DisplayValue := TStringList.Create;
    ConditionSet[0].ReturnValue := TStringList.Create;
    ConditionSet[0].DisplayValue.Add('现金付讫');
    ConditionSet[0].ReturnValue.Add('00001');
    ConditionSet[0].DisplayValue.Add('银行存款付讫');
    ConditionSet[0].ReturnValue.Add('00002');

    Title := '请选择付讫方式';
  end;

  outParams := TParams.Create;

  if cMode = 'A' then
  begin
    if not GetCondition(oParams, CondSquareMode) then
      Exit;
  end;

  
  nResult := ExecuteProcByName('P_FY_Square', ['@cMode', '@VchType', '@VchCode', '@ETypeId', '@SquareDate', '@SquareMode', '@Comment', '@outMode'],
            [cMode, nVchType, nVchCode, GetCurrentOperatorId, Now, oParams[Ord(CMbtCustom05)], '', ''], outParams);

  case nResult of
    -1:
      begin
        ShowErrorMsg('数据库操作失败，请重新操作。');
        Exit;
      end;
    -100:
      begin
        ShowErrorMsg('单据已被付讫，不能再次付讫。');
        Exit;
      end;
    -200:
      begin
        ShowErrorMsg('单据被删除或反审核，不能付讫。');
        Exit;
      end;
    -300:
      begin
        ShowErrorMsg('单据还没有付讫，不能反付讫。');
        Exit;
      end;
    else
      begin
        if cMode = 'A' then
          ShowInfoMessage('单据付讫成功。')
        else
          ShowInfoMessage('单据反付讫成功。');
      end;
  end;

  Result := True;
end;

function CheckDateInAcceptRange(sDate: string): Boolean;
var
  Sql: string;
begin
  //Sql := 'if exists(Select 1 From T_Gbl_MonthProc Where isjxc = 0 and (StartDate <= ''' + sDate + ''' and EndDate >= ''' + sDate + '''))' +
  Sql := 'if exists(Select 1 From T_Gbl_SysDatacw Where SubName = ''iniDate'' and SubValue <= ''' + sDate + ''')' +
         '    Select 1 ' +
         ' Else ' +
	       '    Select 0 ';
  Result := GetValueFromSQL(Sql) = 1;
end;

function CheckBasic(FVchType, FVchCode: Integer; MainControl, OtherControl: TControl): Boolean;
var
  nRow: Integer;
  Xml: TStringList;
  FBatchMessage: TBatchMessage;
  cds: TClientDataSet;
begin
  Result := False;

  Xml := TStringList.Create;
  FBatchMessage := TBatchMessage.Create;
  cds := TClientDataSet.Create(nil);
  try
    Xml.Clear;
    Xml.Delimiter := ' ' ;
    Xml.QuoteChar := ' ' ;
    Xml.Add('<Root>');

    if MainControl <> nil then
    begin
      with TXwGGeneralWGrid(MainControl) do
      begin
        for nRow := 0 to DataRowCount - 1 do
        begin
          if Trim(TypeId[basictype, nRow]) = '' then
            Continue;

          Xml.Append('<Record');
          Xml.Append('AtypeId=""');
          Xml.Append('EtypeId=""');
          Xml.Append('UserDefined01="' + Trim(TypeId[btZFType, nRow]) + '"');
          Xml.Append('UserDefined02="' + Trim(TypeId[btZSType, nRow]) + '"');
          Xml.Append('UserDefined03="' + Trim(TypeId[btCustom3, nRow]) + '"');
          Xml.Append('UserDefined04="' + Trim(TypeId[btCustom4, nRow]) + '"');
          Xml.Append('/>');
        end;
      end;
    end;

    if OtherControl <> nil then
    begin
      with TXwGGeneralWGrid(OtherControl) do
      begin
        for nRow := 0 to DataRowCount - 1 do
        begin
          if Trim(TypeId[basictype, nRow]) = '' then
            Continue;

          Xml.Append('<Record');
          Xml.Append('AtypeId=""');
          Xml.Append('EtypeId=""');
          Xml.Append('UserDefined01="' + Trim(TypeId[btZFType, nRow]) + '"');
          Xml.Append('UserDefined02="' + Trim(TypeId[btZSType, nRow]) + '"');
          Xml.Append('UserDefined03="' + Trim(TypeId[btCustom3, nRow]) + '"');
          Xml.Append('UserDefined04="' + Trim(TypeId[btCustom4, nRow]) + '"');
          Xml.Append('/>');
        end;
      end;
    end;

    Xml.Add('</Root>');

    FBatchMessage.ClearMsg;
    OpenProcByName('P_Bill_CheckBillBasic', ['@iVchType', '@iVchCode', '@cDetailXML'],
                   [FVchType, FVchcode, Xml.DelimitedText], cds, nil);
    cds.First;
    while not cds.Eof do
    begin
      FBatchMessage.AddMsg(cds.Fields[0].AsString);
      cds.Next;
    end;

    if FBatchMessage.HasMsg then
    begin
      FBatchMessage.ShowWarningBatchMsg;
      Exit;
    end;

    Result := True;
  finally
    FreeAndNil(Xml);
    FreeAndNil(cds);
    FBatchMessage.Destroy;
  end;
end;

function CheckBasicExists(BasicTable, TypeId: string): Boolean;
var
  Sql: string;
begin
  if SameStr(TypeId, '') then
  begin
    Result := True;
    Exit;
  end;

  Sql := 'if exists(Select 1 From ' + BasicTable + ' Where TypeId = ''' + TypeId + ''')' +
         '    Select 1 ' +
         '  Else ' +
         '    Select 0 ';
  Result := GetValueFromSQL(Sql) = 1;
end;

function CheckUserBRights(BtypeID: string): Boolean;
var
  Sql: string;
begin
  if SameStr(BtypeID, '') or SameStr(BtypeID, '00000') then
  begin
    Result := True;
    Exit;
  end;
  Sql := 'if exists(Select 1 From dbo.GetUserBrights('''+GetCurrentOperatorId+''') Where BTypeID = ''' + BtypeID + ''')' +
         '    Select 1 ' +
         '  Else ' +
         '    Select 0 ';
  Result := GetValueFromSQL(Sql) = 1;
end;

function GetJxcVchCode(AMode, AVchcode, AVchtype: Integer; APeriod: Integer): Integer;
var
  HasVisibleAllBill: Boolean;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then  //有查看其他操作员录入单据的权限
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [AMode, 'A', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end
  else
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [AMode, 'F', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end;

  if Result = 0 then Result := AVchcode;
end;

// 取得上一张单据号码
function GetPrevVchCode(AVchcode, AVchtype: Integer; APeriod: Integer; IsOrder: Boolean): Integer;
var
  HasVisibleAllBill: Boolean;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then  //有查看其他操作员录入单据的权限
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [1, 'A', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end
  else
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [1, 'F', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end;

  if Result = 0 then Result := AVchcode;
end;

// 取得下一张单据号码
function GetNextVchCode(AVchcode, AVchtype: Integer; APeriod: Integer; IsOrder: Boolean): Integer;
var
  HasVisibleAllBill: Boolean;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then  //有查看其他操作员录入单据的权限
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [2, 'A', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end
  else
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [2, 'F', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end;

  if Result = 0 then Result := AVchcode;
end;

// 取得首张单据号码
function GetFirstVchCode(AVchcode, AVchtype: Integer; APeriod: Integer; IsOrder: Boolean): Integer;
var
  HasVisibleAllBill: Boolean;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then  //有查看其他操作员录入单据的权限
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [0, 'A', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end
  else
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [0, 'F', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end;

  if Result = 0 then Result := AVchcode;
end;

// 取得末张单据号码
function GetLastVchCode(AVchcode, AVchtype: Integer; APeriod: Integer; IsOrder: Boolean): Integer;
var
  HasVisibleAllBill: Boolean;
begin
  if FDllParams.PubVersion2 = 880 then
    HasVisibleAllBill := True
  else
    HasVisibleAllBill := GetLimit(1984);

  if HasVisibleAllBill then  //有查看其他操作员录入单据的权限
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [3, 'A', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end
  else
  begin
    Result := ExecuteProcByName('p_jxc_GetLastNextVch;1',
      ['@nMode', '@cMode', '@nVchtype', '@nVchcode', '@nPeriod', '@InuptNo'],
      [3, 'F', AVchtype, AVchcode, APeriod, GetCurrentOperatorId], nil);
  end;

  if Result = 0 then Result := AVchcode;
end;

function CheckIsFinishedOrder(aVchCode: Integer): Integer;
var
  cdsOpenSQL: TClientDataSet;
  szSQL: string;
  nOrderOver, nUserOver: Integer;
begin
  Result := -1;
  cdsOpenSQL := TClientDataSet.Create(nil);
  try
    szSQL := 'SELECT VCHTYPE, ORDEROVER, USEROVER FROM DLYNDXORDER WHERE VCHCODE = ''%d'' ';
    szSQL := Format(szSQL, [aVchCode]);

    if not OpenSQL(szSQL, cdsOpenSQL) then
      Exit;

    nOrderOver := cdsOpenSQL.FieldByName('ORDEROVER').AsInteger;
    nUserOver := cdsOpenSQL.FieldByName('USEROVER').AsInteger;
    if (nOrderOver = 0) and (nUserOver = 0) then
      Result := 0
    else if nOrderOver = 1 then
      Result := 1
    else if nUserOver = 1 then
      Result := 2;
  finally
    FreeAndNil(cdsOpenSQL);
  end;
end;

// 通过Vchcode取得单据类型
function GetVchTypeFromVchcode(AVchcode: Integer; IsDraft: Boolean; bt: TBillType): Integer;
var
  cds: TClientDataSet;
begin
  Result := 0;
  cds := TClientDataSet.Create(nil);
  try
    case bt of
      bbmtStandard:
        begin
          OpenSQL(Format('select vchtype from DlyNdx where vchcode = %d', [AVchcode]), cds);
        end;
      bbmtOrder:
        begin
          OpenSQL(Format('select vchtype from DlyNdxOrder where vchcode = %d', [AVchcode]), cds);
        end;
      bbmtInvoice:
        begin
          OpenSQL(Format('select vchtype from T_JXC_InvoiceDlyNdx where vchcode = %d', [AVchcode]), cds);
        end;
      bbmtProduce:
        begin
          OpenSQL(Format('select vchtype from DlyNdxSC where vchcode = %d', [AVchcode]), cds);
        end;
      bbmtXunJia:
        begin
          OpenSQL(Format('select vchtype from T_XunJia_DlyNdx where vchcode = %d', [AVchcode]), cds);
        end;
      bbmtGX:
        OpenSQL(Format('select vchtype from DlyNdxGX where vchcode = %d', [AVchcode]), cds);
    else
      OpenSQL(Format('select vchtype from dlyndx where vchcode = %d', [AVchcode]), cds);
    end;

    cds.First;
    if not cds.Eof then
      Result := cds.FieldByName('vchtype').AsInteger;
  finally
    cds.Free;
  end;
end;

function GetInquirePrice(APtypeID,ABtypeID: string; AQty: Double; ACustom01,ACustom02,ACustom03,ACustom04,ADate: string;
 var APrice,ATax,ATaxPrice: Double): Boolean;
var
  cdsGetRecordSet: TClientDataSet;
  szSQL: string;
begin
  Result := False;
  cdsGetRecordSet :=TClientDataSet.Create(nil);

  szSQL :='select dly.VchCode,dly.Dlyorder,dly.Price,dly.Tax,dly.TaxPrice ' +
    ' from T_XunJia_AskDly dly  LEFT JOIN T_XunJia_AskNdx n on dly.vchcode=n.vchcode '+
    ' where n.ptypeid = ''%0:s'' AND  n.btypeid = ''%1:s''  AND '+
    ' (n.UserDefined01 = '''' OR n.UserDefined01 = ''%2:s'') AND ' +
    ' (n.UserDefined02 = '''' OR n.UserDefined02 = ''%3:s'') AND '+
    ' (n.UserDefined03 = '''' OR n.UserDefined03 = ''%6:s'') AND '+
    ' (n.UserDefined04 = '''' OR n.UserDefined04 = ''%7:s'') AND '+
    ' (n.effectdate='''' OR n.effectdate>=''%4:s'') AND (n.invadate='''' OR n.invadate<=''%4:s'') AND '+
    ' (dly.QtyDown < %5:f) AND (dly.QtyUp = 0 OR dly.QtyUp > %5:f)  ';
  szSQL := Format(szSQL, [APtypeID,ABtypeID,ACustom01,ACustom02,ADate,AQty,ACustom03,ACustom04]);
  OpenSQL(szSQL, cdsGetRecordSet);

  if cdsGetRecordSet.RecordCount <= 0 then
  begin
    FreeAndNil(cdsGetRecordSet);
    Exit;
  end;

  cdsGetRecordSet.First;

  APrice := cdsGetRecordSet.FieldByName('Price').AsFloat;
  ATax := cdsGetRecordSet.FieldByName('Tax').AsFloat;
  ATaxPrice := cdsGetRecordSet.FieldByName('TaxPrice').AsFloat;

  FreeAndNil(cdsGetRecordSet);

  Result :=True;

 //GetInquirePrice('00001','00004',2,'','','2012-06-25',nPrice,nTax,nTaxPrice);
end;

function GetBtypePrePrice(ABtypeId: string): Integer;
var
  Sql: string;
begin
  Result := 0;
  if (ABtypeId = '') or (ABtypeId = '00000') then
    Exit;

  Sql := 'Select IsNull((Select PrePrice From Btype Where TypeId = ''' + ABtypeId + '''), 0) as PrePrice';
  Result := GetValueFromSQL(Sql);
end;

//取存货最新进价
function GetPtypeNewestBuyPrice(PTypeID: string): Double;
var
  cds: TClientDataSet;
begin
  Result := 0;
  try
    cds := TClientDataSet.Create(nil);
    OpenSQL('select BuyPrice from recprice where ptypeid = '''+PTypeID+'''', cds);
    if not cds.IsEmpty then
    begin
      if cds.Fields[0].IsNull then
        Result := 0
      else
        Result := cds.Fields[0].AsFloat;
    end;
  finally
    FreeAndNil(cds);
  end;
end;

//取价格
function GetBillPtypePrice(FBillPtypePriceParam: TBillPtypePriceParam): TBillPtypePriceInfo;
var
  prOutParams: TParams;
  Sql, AProcName: string;
  cds: TClientDataSet;
  FBillPtypePriceInfo: TBillPtypePriceInfo;
begin
  FBillPtypePriceInfo.Discount := 1;
  FBillPtypePriceInfo.Price := 0;

  prOutParams := TParams.Create(nil);
  cds := TClientDataSet.Create(nil);
  try
    Sql := 'Select ProcName From T_Inf_GetBillPtypePrice Where IsUse = 1 and VchType = %0:d';
    Sql := Format(Sql, [FBillPtypePriceParam.VchType]);
    OpenSQL(Sql, cds);
    cds.First;
    if not cds.Eof then
    begin
      AProcName := cds.FieldByName('ProcName').AsString;
      prOutParams.Clear;
      ExecuteProcByName(AProcName,
        ['@VchType', '@BillDate', '@BtypeId', '@KtypeId', '@PtypeId', '@Custom1',
         '@Custom2', '@BlockNo', '@ProDate', '@Qty', '@BillUnit', '@DisCount', '@TaxRate', '@Price'],
         [FBillPtypePriceParam.VchType, FBillPtypePriceParam.BillDate, FBillPtypePriceParam.BtypeId,
          FBillPtypePriceParam.KtypeId, FBillPtypePriceParam.PtypeId, FBillPtypePriceParam.Custom1,
          FBillPtypePriceParam.Custom2, FBillPtypePriceParam.BlockNo, FBillPtypePriceParam.ProDate,
          FBillPtypePriceParam.Qty, FBillPtypePriceParam.BillUnit, FBillPtypePriceParam.Discount, FBillPtypePriceParam.TaxRate, 0.0], prOutParams);

      FBillPtypePriceInfo.Discount := prOutParams.ParamByName('@DisCount').AsFloat;
      FBillPtypePriceInfo.TaxRate := prOutParams.ParamByName('@TaxRate').AsFloat;
      FBillPtypePriceInfo.Price := prOutParams.ParamByName('@Price').AsFloat;
    end
    else
    begin
      FBillPtypePriceInfo.TaxRate := FBillPtypePriceParam.TaxRate;
      if Abs(FBillPtypePriceParam.Discount) > DOUBLE_ZERO then
        FBillPtypePriceInfo.Discount := FBillPtypePriceParam.Discount;
    end;
  finally
    FreeAndNil(cds);
    FreeAndNil(prOutParams);
  end;

  Result := FBillPtypePriceInfo;
end;

//检测销售订单是否设置
function CheckOrderHasSetBOM(AVchType, AVchCode: Integer; actionStr: string = '删除'; billName: string = ''): Boolean;
var
  Sql: string;
  cds: TClientDataSet;
  FBatchMessage: TBatchMessage;
begin
  if AVchType <> 151 then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  cds := TClientDataSet.Create(nil);
  FBatchMessage := TBatchMessage.Create;
  try
    Sql := 'Select p.fullname + ''存货已经设置了订单BOM，' + actionStr + '单据' + billName + '将同时删除对应的订单BOM，是否继续？''' +
           ' From BakDlyOrder d Inner Join T_SC_BOM_Order t On d.VchCode = t.SourceVchcode and d.DlyOrder = t.SourceDlyOrder ' +
           ' Left Join Ptype p On d.PtypeId = p.TypeId ' +
           ' Where d.VchCode = %0:d and d.BomType = ''订单BOM''';
    Sql := Format(Sql, [AVchCode]);
    OpenSQL(Sql, cds);

    while not cds.Eof do
    begin
      FBatchMessage.AddDistinctMsg(cds.Fields[0].AsString);
      cds.Next;
    end;

    if FBatchMessage.HasMsg then
    begin
      if not FBatchMessage.ConfirmYesNoBatchMsg then
        Exit;
    end;
  finally
    FreeAndNil(cds);
    FBatchMessage.Destroy;
  end;

  Result := True;
end;

function bi_CopyToDraft(AVchcode, AVchtype: Integer; var sErrMsg: string): Integer;
var
  FBills: TBills;
  vParam: TParams;
  szNumber, szTmpNumber, procName: string;
begin
  FBills.Vchtype := AVchtype;
  Result := -1;
  case GetVchtypeConfig(FBills) of
    -1:
      begin
        sErrMsg := '没有找到该单据类型的表头配置数据';
        Exit;
      end;
    -2:
      begin
        sErrMsg := '没有找到该单据类型的表格配置数据';
        Exit;
      end;
  end;

  szNumber := '';
  if CheckSysCon(SYS_AUTO_NUMBER) then
  begin

    szNumber := GetVchSN(FBills, Int(GetLogOnDateTime) + Frac(GetLogOnDateTime));

    if CheckSysCon(SYS_DONTSAME_VCHNUMBER) then
    begin
      CheckVchNumber(AVchcode, FBills.VchType, szNumber, szTmpNumber);
      if UpperCase(szTmpNumber) = 'YES' then
        szNumber := GetVchSN(FBills, Int(GetLogOnDateTime) + Frac(GetLogOnDateTime));
    end;
  end;

  vParam := TParams.Create(nil);
  try
    procName := GetBillCopyToDraftProcName(AVchtype);
    if procName = '' then
    begin
      sErrMsg := '没有相应存储过程';
      Result := -1;
      Exit;
    end;
    Result := ExecuteProcByName(procName, ['@nVchcode', '@nVchtype', '@szNumber', '@ErrorMessage'],
            [AVchcode, AVchtype, szNumber, ''], vParam);
    if Result < 0 then
      sErrMsg := vParam.ParamByName('@ErrorMessage').AsString
    else
    begin
      if CheckSysCon(SYS_AUTO_NUMBER) and CheckSysCon(SYS_DRAFT_NO_VALID) and (GetSysValue('SNLex2') = '0') then
        IncVchNumber(AVchtype, FormatDateTime('yyyy-mm-dd', Now));
    end;
  finally
    FreeAndNil(vParam);
  end;
  //更新szNumber的计数
end;

//获取开账前的最后一天
function GetIniDate: string;
var
  Sql: string;
  startDate: string;
  cds: TClientDataSet;
begin
  try
    cds := TClientDataSet.Create(nil);
    try
      Sql := 'Select StartDate From T_Gbl_MonthProc t Inner Join T_Gbl_SysDataCw g On t.Period = Cast(IsNull(g.SubValue, 0) as int) Where g.SubName = ''OpenPeriod''';
      OpenSQL(Sql, cds);
      cds.First;
      if not cds.Eof then
      begin
        startDate := cds.Fields[0].AsString;
        Result := FormatDateTime('yyyy-MM-dd', DateUtils.IncDay(StringToDateTime(startDate), -1));
      end
      else
        Result := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
    finally
      FreeAndNil(cds);
    end;
  except
    Result := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
  end;
end;

//获取单据所在期间，如果是单据日期在期初，则为0
function GetBillPeriod(billDate: string): Integer;
var
  Sql: string;
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  try
    Sql := 'Select t.Period From T_Gbl_MonthProc t Inner Join T_Gbl_SysDataCw g ' +
           ' On t.Period >= Cast(IsNull(g.SubValue, 0) as int) ' +
           ' Where g.SubName = ''OpenPeriod'' and ''%0:s'' Between t.StartDate and t.EndDate';
    Sql := Format(Sql, [billDate]);
    OpenSQL(Sql, cds);
    cds.First;
    if not cds.Eof then
      Result := cds.FieldByName('Period').AsInteger
    else
      Result := 0;
  finally
    FreeAndNil(cds);
  end;
end;

//检查辅助数量是否可编辑
function CheckQtyFuZhuCanModify(dUnitRate: Double): Boolean;
begin
  Result := True;

  if (dUnitRate = 0) or (dUnitRate = 1) then
    Result := CheckSysCon(144);
end;

//获取某单位的结算单位信息
function GetSettleBtype(ABtypeId: string): TSettleBtype;
var
  Sql: string;
  FSettleBtype: TSettleBtype;
begin
  FSettleBtype.TypeId := '';
  if FDllParams.PubVersion2 >= 3680 then
  begin
    Sql := 'if exists(Select 1 From Btype Where TypeId = ''%0:s'' and SettleBtypeId <> '''') ' +
           '     Select SettleBtypeId From Btype Where TypeId = ''%0:s'' ' +
           ' Else ' +
           '     Select '''' as SettleBtypeId';
    FSettleBtype.TypeId := GetValueFromSQL(Format(Sql, [ABtypeId]));
  end;

  if FSettleBtype.TypeId = '' then
    FSettleBtype.TypeId := ABtypeId;
  FSettleBtype.FullName := GetBaseFullNameByID(CMbtBtype, FSettleBtype.TypeId);
  Result := FSettleBtype;
end;

//取多编码
function GetBtypeOtherCode(APtypeID,ABtypeID: string): string;
var
  cds: TClientDataSet;
begin
  Result := '';
  if (ABtypeID = '') or (ABtypeID = '00000') then
    Exit;
  try
    cds := TClientDataSet.Create(nil);
    OpenSQL('SELECT d.Ptypeid, d.UserCode FROM dbo.BtypeOtherCodeNdx n '+
            ' LEFT JOIN dbo.BtypeOtherCodeDetail d ON n.Rec = d.Rec '+
            ' WHERE n.Btypeid = '''+ABtypeID+''' and d.ptypeid = '''+APtypeID+'''', cds);
    if cds.RecordCount > 0 then
    begin
      Result := cds.FieldByName('UserCode').AsString;
    end;
  finally
    FreeAndNil(cds);
  end;
end;

end.
