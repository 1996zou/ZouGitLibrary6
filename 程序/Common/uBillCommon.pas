unit uBillCommon;

interface

uses
  XWComponentType, Classes, Controls, SysUtils, Windows, Graphics,
  Variants, xwVchCalcClass, xwGtypedefine, xwbasicinfoclassdefine_c, xwCalcFieldsDefine,
  Menus, Generics.Collections, uDataStructure;

type
  TBillClassName = class
  private
    FBillClassName: TDictionary<Integer, string>;
  protected
    procedure InitBillClassName;
  public
    constructor Create;
    destructor Destory;

    function GetBillClassName(nVchType: Integer): string;
    property BillClassName: TDictionary<Integer, string> read FBillClassName;
  end;

  //委外加工单位信息
  TConsignBType = record
    szTypeID: string;
    szUserCode: string;
    szFullName: string;
    telNo: string;
    Address: string;
    Fax: string;
    LinkMan: string;
  end;

  //结算单位信息
  TSettleBtype = record
    TypeId: string;
    FullName: string;
  end;

  TProcessType = record
    ProcessTypeId: string;
    NextProcessTypeId: string;
    CurrentStep: Integer;
  end;

  TBillProcessParam = record
    VchType: Integer;
    VchCode: Integer;
    Draft: Integer;
    BillTypeMode: Integer;
    Appoint: Integer;
    CancelType: Integer;
    arSettleType: Integer;
    apSettleType: Integer;
    isClient: Integer;
    TimeStamp: Integer;
    Period: Integer;
    dTotalZero: Double;
    Number: string;
    AuditOpinion: string;
    TitleXml: string;
    DetailXml: string;
    JsXml: string;
    ArApXml: string;
    ArCancelXml: string;
    ApCancelXml: string;
    FeeAllotXml: string;
    ExpenseAllotXml: string;
    ToQtyXml: string;
    ToQtyXml2: string;
    OutQtyXml: string;
    CorrespondXml: string;
    GoodsStocksXml: string;
    CommissionXml: string;
    ProduceStockXml: string;
    ConsignStockXml: string;
    SerialNoDetailXml: string;
  end;

  TBillProcessRet = record
    nRetCode: Integer;
    errMsg: string;
  end;

  TBillPositionInfo = record
    PtypeId: string;
    KtypeId: string;
    BlockNo: string;
    ProDate: string;
    UserDefined01: string;
    UserDefined02: string;
    UserDefined03: string;
    UserDefined04: string;
  end;

  TBillManagePositionInfo = record
    ManagePosition1: Boolean;
    ManagePosition2: Boolean;
  end;

  TBillArApInfo = record
    BtypeId: string;
    Total: Double;
  end;

  //单据序列号
  TBillSerialNumber = record
    Guid: string;
    VchType: Integer;
    VchCode: Integer;
    DlyOrder: Integer;
    PtypeId: string;
    Qty: Double;
    KtypeId: string;
    BillNumber: string;
    BlockNo: string;
    Date: string;
    FZtypeId: string; //自定义项1
    SZtypeId: string;  //自定义项2
    Custom3: string; //自定义项3
    Custom4: string; //自定义项4
    ManageCustom1: Boolean;
    ManageCustom2: Boolean;
    ManageCustom3: Boolean;
    ManageCustom4: Boolean;
    ManageBlockNo: Boolean;
    PStypeId: string;
    SourceVchType: Integer;
    SourceVchCode: Integer;
    SourceDlyOrder: Integer;
  end;

  TBillPtypePriceParam = record
    VchType: Integer;
    BillDate: string;
    BtypeId: string;
    KtypeId: string;
    PtypeId: string;
    Custom1: string;
    Custom2: string;
    Custom3: string;
    Custom4: string;
    BlockNo: string;
    ProDate: string;
    BillUnit: Integer;
    Discount: Double;
    TaxRate: Double;
    Qty: Double;
  end;

  TBillPtypePriceInfo = record
    Discount: Double;
    TaxRate: Double;
    Price: Double;
  end;

  TBillProcessType = (SaveBill, AuditBill, UnAuditBill, ReAuditBill, DeleteBill, RedBill, SaveDraft, TurnBill, SaveAndAuditBill, ReSettle);

  //只有单据用
  TProductPrice = record
    szTypeID: string;
    szUserCode: string;
    szFullName: string;
    dCostPrice: Double;
    dPrePrice1: Double; //preprice1
    dPrePrice2: Double; //preprice2
    dPrePrice3: Double; //preprice3
    dPrePrice4: Double; //preprice4  零售价
    dPrePrice5: Double; //preprice5
    dPreprice6: Double; //preprice6
    dPreprice7: Double;
    dPreprice8: Double;
    dPreprice9: Double;  // 计划成本价
    dRecPrice: Double; // 最近折后进价
    dDisRecPrice: Double; //最近折前进价
    dBuyPrice: Double; //客户跟踪进价
    dSalePrice: Double; //客户跟踪售价
    dBuyDiscount: Double; //最近进货折扣
    dSaleDiscount: Double; //最近销售折扣
    dNewSalePrice: Double;  //存货最新售价
    dOtherNewPrice: Double; //其它出库单最新价格
    dCostTotal: Double; //当前成本金额
  end;
  TProductPriceArray = array of TProductPrice;

  //打包数据格式
  TOwnerDataStruct = (odsTitleData, odsColumnData, odsSerialData, odsOtherData, odsJSData, odsProductVersion);
//                    表头数据      表体数据       其他零散数据  序列号         结算数据        产品版本

//单据打包数据，零散数据
  TOtherData = (odVchcode, odVchtype, odCurrOperID, odCurrDate, odDraft, odAudit);

//单据打包数据，序列号格式
  TSerialNoFormat = (snfPTypeID, snfKTypeID, snfBTypeID,
    snfETypeID, snfDTypeID, snfSerailNo, snfBlockNo, snfProDate);

  TProcessState = (psSucceed, psFailed, psCancel); // 处理状态

  TBillModifyState = (bmsNone, bmsNew, bmsModify, bmsReadOnly, bmsModified);
  //单据编辑状态                新增    修改      只读         已经修改,

  TBillState = (bsNone, bsgNew, bsDraft, bsSettled, bsSave, bsAuditing, bsReded, bsRedWord, bsCanceled, bsOver, bsUserOver, bsCashSquare, bsBankSquare, bsReadOnly);
  //单据状态           新单据   草稿     已过账     未审核    审核中     已被红冲    红字单据   已作废(或删除三) 已完成
                                            {多级审核用，单级暂未用}
  //单据显示标志Add by zle @2005-05-17
  TBillMark = (bmNone, bmOrderOver, bmUserOver, bmReded, bmRedWord, bmAudit, bmunAudit, bmCashSquare, bmBankSquare);
  TBillMarks = set of TBillMark;

  TBillMarkProp = record
    Visible: Boolean;
    Caption: string;
    Color: TColor;
  end;

  //单据原有信息
  TBillOldBillInfo = record
    obDate: string;
    obNumber: string;
    obInputNo: string;
    obLockValue: Integer;
    obTimeStamp: Integer; //时间戳
    obPeriod: Integer;
  end;

  //保存后操作        //新增   调本单   关闭窗口
  TBillSavedOperate = (bsdNew, bsdLoad, bsdCloseBySaveSucc, bsdCloseByAll);
  //表格信息

  //选单原单信息
  TBillSourceInfo = record
    bsiVchtype: Integer;
    bsiVchCode: Integer;
    bsiDlyOrder: Integer;
//    bsiNumber: string;
    bsiBillDate: string;
    BatchBill: Boolean;
    bsiOldVchType: Integer;
    bsiOldVchCode: Integer;
    bsiReSelectBill: Boolean;
    //加三个字段，用于生产委外选单原单表头信息
    bsiWTypeID: string;
    bsiPTypeID: string;
    bsiBTypeID: string;
    bsiTimeStamp: Integer; //时间戳
  end;

  TBillInputInfo = record
   biiInputNo: string;
   biiInputName: string;   
  end;

  TBillRedInfo = record
    birRedOld: Boolean;
    birRedWord: Boolean;
  end;

  TBillType = (bbmtStandard, bbmtOrder, bbmtProduce, bbmtInvoice, bbmtWLHX, bbmtXunJia, bbmtGX);

  //单据标志显示  不显示 订单完成  被红冲，红字单据
  TBillProcessMode = (bpmSave, bpmSaveAs, bpmDraft, bpmUpdate, bpmDelete,
    bpmRed, bpmAuditing, bpmKeepAccount, bpmUnAuditing, bpmTurn, bpmReAuditing, bpmSaveAndAudit, bpmReSettle);

  TBillTitleProperty = (// 单据表头信息
    btpDate, //录单日期       0
    btpNumber, //单据编号       1
    btpBType, //往来单位       2
    btpKType, //仓库           3
    btpDType, //部门           4
    btpEType, //经手人         5
    btpKType2, //仓库2          6
    btpGatheringDate, //收款日期       7
    btpSummary, //摘要           8
    btpOtherEType, //其他经手人     9
    btpCustom01, //自定义1        10
    btpCustom02, //自定义2        11
    btpCustom03, //自定义3        12
    btpCustom04, //自定义4        13
    btpCustom05, //自定义5        14
    btpSumTotal, //金额合计       15
    btpSumQty, //数量合计       16
    btpSumDiscountTotal, //折后金额合计   17
    btpSumTaxTotal, //含税金额合计   18
    btpTotal, //税额合计       19
    btpSettledTotal, //成本金额合计   20
    btpSumAssignableTotal, //可分配金额合计 21
    btpAccount, //收付款账户     22
    btpAccountTotal, //收付款金额     23
    btpOperatingType, //业务类型       24
    btpRealTotal, //实收金额       25
    btpOddment, //抹零金额       26
    btpSettleBtype,   // 结算单位 27
    btpCustomBillTotal, // 自定义单据金额合计 28
    btpSetCost,          //指定成本 29
    btpUserDefined01,       //用户自定义01   30
    btpUserDefined02,       //用户自定义02   31
    btpUserDefined03,       //用户自定义03   32
    btpBType2,              //往来单位2      33
    btpHXType,              //核销类型       34

    btpWType,             //车间        35
    btpPType,              //存货         36
    btpPTypeUser,           //存货编号      37
    btpCompactID,           //合同号          38
    btpWBType,              //委外单位          39
    btpBlockNo,             //批号               40
    btpQtyOther,            //副单位数量           41
    btpUserCustom01,        //基本信息用户自定义1  42
    btpUserCustom02,        //基本信息用户自定义2  43
    btpRequestEType,        //请购人       44    预留询价系统用
    btpRequestDType,        //请购部门     45
    btpGZType,              //工作组，班组  46   --lkang 2011-11-17
    btpSourceVchName,       //源单类型     47
    btpSourceNumber,        //源单号       48
    btpUserDefined04,       //用户自定义04   49
    btpUserDefined05,       //用户自定义05   50
    btpUserDefined06,       //用户自定义06   51
    btpUserDefined07,       //用户自定义07   52
    btpUserDefined08,       //用户自定义08   53
    btpUserDefined09,       //用户自定义09   54
    btpUserDefined10,       //用户自定义10   55
    btpUserDefined11,       //用户自定义11   56
    btpUserDefined12,       //用户自定义12   57
    btpUserDefined13,       //用户自定义13   58
    btpUserDefined14,       //用户自定义14   59
    btpUserDefined15,       //用户自定义15   60
    btpUserDefined16        //用户自定义16   61
    );

  TBillTitlePropertys = set of TBillTitleProperty;

  TBillTitle = record
    CaptionNo: Integer;
    Caption: string;
    CMBasicType: TCMBasicType;
    Visible: Boolean;
    Enabled: Boolean;
    Readonly: Boolean;
    Required: Boolean;
    BtnVisible: Boolean;
    Controls: TControl;
  end;

  TBillTitles = array[Low(TBillTitleProperty)..High(TBillTitleProperty)] of TBillTitle;

  TBills = record
    Vchtype: Integer;
    Caption: string;
    NumberHead: string;
    SNFormat: string;
    IniDate: string;
    iniOver: Boolean;
    EndState: Boolean;
    ARSettleType: Integer;  //应收
    APSettleType: Integer;  //应付
    BillTitles: TBillTitles;
    DataAreas: TDataAreas;
    MainGridType: TCMBasicType;
    OtherGridType: TCMBasicType;
    ProcessGridType: TCMBasicType;
    MainGridSubjectType: TCMSubjectType;
    OtherGridSubjectType: TCMSubjectType;
    ProcessGridSubjectType: TCMSubjectType;
    SummaryNo: Integer;
    MainGridControl: TControl;
    OtherGridControl: TControl;
    ProcessGridControl: TControl;
    MainGridNumTypes: TCMVchNumTypes;
    OtherGridNumTypes: TCMVchNumTypes;
    ProcessGridNumTypes: TCMVchNumTypes;
  end;

  TBillEvent = procedure(Sender: TObject; Vchcode, vchtype: Integer;
    var ContinueProc: Boolean) of object;

  PBillDetailData = ^TBillDetailData;

  TBillDetailDatas = class(TPersistent)
  private
    FItems: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): PBillDetailData;
    procedure SetItem(Index: Integer; const Value: PBillDetailData);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Add: PBillDetailData;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure ClearDataItem(Index: Integer = -1);
    function Insert(Index: Integer): PBillDetailData;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: PBillDetailData read GetItem write SetItem; default;
  end;

  PBillSerialData = ^TBillSerialData;
  TBillSerialData = record // 不只是批号用，发货结算也使用该结构, 费用分配也要使用
    Vchcode: Integer;
    SVchcode: Integer;
    VchType: Integer;
    PTypeID: string; // 存货ID
    BTypeID: string; // 往来单位ID
    ETypeID: string; // 职员ID
    KTypeID: string; // 仓库ID
    DTypeID: string; // 部门ID
    SerialNo: string;
    ProDate: string; // 生产日期
    BlockNo: string; // 存货批号
    Qty: Double;
    Tag: Integer;
    Vchlineno: Integer; // 行号，用作发货结算时send_dlyorder
    Total: Double;
    TaxRate: Double;
    TaxTotal: Double;
    SendType: Integer;
    Comment: string;
    feeitem_id: Integer;
    UsedType: Integer;
  end;

  TBillSerialDatas = class(TPersistent)
  private
    FItems: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): PBillSerialData;
    procedure SetItem(Index: Integer; const Value: PBillSerialData);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Add: PBillSerialData;
    procedure Clear;
    procedure Delete(Index: Integer);
    function Insert(Index: Integer): PBillSerialData;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: PBillSerialData read GetItem write SetItem; default;
  end;

  //结算数据明细
  PBillJSData = ^TBillJSData;
  TBillJSData = record
    sVchcode: Integer;  //原单据
    sVchType: Integer;
    SourceDlyOrder: Integer;
    jVchCode: Integer;  //结算单据
    jVchtype: Integer;
    BTypeID: string;
    Total: Double;
    nType: Integer;
    Draft: Boolean;
    FeeTypeID: string;  //保存进货费用分配单的fee
    UsedType: Integer;  //核销单上下表格
    WTypeID: string;
    Custom1: string;
  end;

  TBillJSDatas = class(TPersistent)
  private
    FItems: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): PBillJSData;
    procedure SetItem(Index: Integer; const Value: PBillJSData);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Add: PBillJSData;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure ClearDataItem(Index: Integer = -1);
    function Insert(Index: Integer): PBillJSData;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: PBillJSData read GetItem write SetItem; default;
  end;

  TBillSourceInfoList = ^TBillSourceInfomation;
  TBillSourceInfomation = record
    PTypeID: string;
    Number: string;
    SourceVchCode: Integer;
    SourceVchType: Integer;
    SourceDlyOrder: Integer;
    VchCode: Integer;
    DlyOrder: Integer;
    Qty: Double;
    Draft: Integer;
    SourceTimeStamp: Integer;
  end;

  TBillSourceInfomations = class(TPersistent)
  private
    FItems: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TBillSourceInfoList;
    procedure SetItem(Index: Integer; const Value: TBillSourceInfoList);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Add: TBillSourceInfoList;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure ClearDataItem(Index: Integer = -1);
    function Insert(Index: Integer): TBillSourceInfoList;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TBillSourceInfoList read GetItem write SetItem; default;
  end;

  TBillCheckDetailList = ^TBillCheckDetailType;
  TBillCheckDetailType = record
    szPTypeID: string;
    szDlyOrder: string;
    Qty: string;
    drawQty: string;
    UseQty: string;
    UnuseQty: string;
    BillTitles: TBillTitleData;
    SourceInfomation: TBillSourceInfomations;
  end;

  TBillCheckDetails = class(TPersistent)
  private
    FItems: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TBillCheckDetailList;
    procedure SetItem(Index: Integer; const Value: TBillCheckDetailList);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Add: TBillCheckDetailList;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure ClearDataItem(Index: Integer = -1);
    function Insert(Index: Integer): TBillCheckDetailList;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TBillCheckDetailList read GetItem write SetItem; default;
  end;

const
  BILLTITLE_USERDEFINED = [
    btpUserDefined01,
    btpUserDefined02,
    btpUserDefined03,
    btpUserDefined04,
    btpUserDefined05,
    btpUserDefined06,
    btpUserDefined07,
    btpUserDefined08,
    btpUserDefined09,
    btpUserDefined10,
    btpUserDefined11,
    btpUserDefined12,
    btpUserDefined13,
    btpUserDefined14,
    btpUserDefined15,
    btpUserDefined16
  ];

function PackageProductPrice(APrice: TProductPrice): OleVariant;
procedure UnpackProductPrice(vSource: OleVariant; var APrice: TProductPrice);

implementation

uses uBillBasicConfig{, uMessageComm};

function PackageProductPrice(APrice: TProductPrice): OleVariant;
begin
  Result := VarArrayCreate([0, 21], varVariant);
  Result[0] := APrice.szTypeID;
  Result[1] := APrice.szUserCode;
  Result[2] := APrice.szFullName;
  Result[3] := APrice.dCostPrice;
  Result[4] := APrice.dPrePrice1;
  Result[5] := APrice.dPrePrice2;
  Result[6] := APrice.dPrePrice3;
  Result[7] := APrice.dPrePrice4;
  Result[8] := APrice.dPrePrice5;
  Result[9] := APrice.dPreprice6;
  Result[10] := APrice.dPrePrice7;
  Result[11] := APrice.dPrePrice8;
  Result[12] := APrice.dPreprice9;
  Result[13] := APrice.dBuyPrice;
  Result[14] := APrice.dSalePrice;
  Result[15] := APrice.dBuyDiscount;
  Result[16] := APrice.dSaleDiscount;
  Result[17] := APrice.dRecPrice;
  Result[18] := APrice.dDisRecPrice;
  Result[19] := APrice.dNewSalePrice;
  Result[20] := APrice.dOtherNewPrice;
  Result[21] := APrice.dCostTotal;
end;

procedure UnpackProductPrice(vSource: OleVariant; var APrice: TProductPrice);
begin
  APrice.szTypeID := vSource[0];
  APrice.szUserCode := vSource[1];
  APrice.szFullName := vSource[2];
  APrice.dCostPrice := vSource[3];
  APrice.dPrePrice1 := vSource[4];
  APrice.dPrePrice2 := vSource[5];
  APrice.dPrePrice3 := vSource[6];
  APrice.dPrePrice4 := vSource[7];
  APrice.dPrePrice5 := vSource[8];
  APrice.dPreprice6 := vSource[9];
  APrice.dPrePrice7 := vSource[10];
  APrice.dPrePrice8 := vSource[11];
  APrice.dPreprice9 := vSource[12];
  APrice.dBuyPrice := vSource[13];
  APrice.dSalePrice := vSource[14];
  APrice.dBuyDiscount := vSource[15];
  APrice.dSaleDiscount := vSource[16];
  APrice.dRecPrice := vSource[17];
  APrice.dDisRecPrice := vSource[18];
  APrice.dNewSalePrice := vSource[19];
  APrice.dOtherNewPrice := vSource[20];
  APrice.dCostTotal := vSource[21];
end;

{ TBillClassName }
constructor TBillClassName.Create;
begin
  FBillClassName := TDictionary<Integer, string>.Create;
  InitBillClassName;
end;

destructor TBillClassName.Destory;
begin
  FreeAndNil(FBillClassName);
  inherited;
end;

function TBillClassName.GetBillClassName(nVchType: Integer): string;
var
  className: string;
begin
  className := '';

  if FBillClassName.TryGetValue(nVchType, className) and (className <> '') then
    Result := className
  else
    Result := '';
end;

procedure TBillClassName.InitBillClassName;
begin
  FBillClassName.Add(SALE_VCHTYPE, 'TfrmBillSale');
  FBillClassName.Add(SALEBACK_VCHTYPE, 'TfrmBillSaleBack');
  FBillClassName.Add(BUY_VCHTYPE, 'TfrmBillBuy');
  FBillClassName.Add(BUYBACK_VCHTYPE, 'TfrmBillBuyBack');
  FBillClassName.Add(PRICE_ALLOT_VCHTYPE, 'TfrmBillAllot');
  FBillClassName.Add(CHANGE_PRICE_VCHTYPE, 'TfrmBillChangePrice');
  FBillClassName.Add(LOSE_VCHTYPE, 'TfrmBillLose');
  FBillClassName.Add(GET_VCHTYPE, 'TfrmBillGain');
  FBillClassName.Add(INLIB_VCHTYPE, 'TfrmBillInLib');
  FBillClassName.Add(OUTLIB_VCHTYPE, 'TfrmBillOutLib');
  FBillClassName.Add(EXPENSE_VCHTYPE, 'TfrmBillExpense');
  FBillClassName.Add(OTHER_INCOME_VCHTYPE, 'TfrmBillOtherInCome');
  FBillClassName.Add(MONEY_CHANGE_VCHTYPE, 'TfrmBillMoneyChange');
  FBillClassName.Add(GATHERING_VCHTYPE, 'TfrmBillGathering');
  FBillClassName.Add(PAYMENT_VCHTYPE, 'TfrmBillPayMent');
  FBillClassName.Add(COMMISSION_VCHTYPE, 'TfrmBillCommission');
  FBillClassName.Add(COMMISSION_JS_VCHTYPE, 'TfrmBillCommissionJS');
  FBillClassName.Add(COMMISSION_BACK_VCHTYPE, 'TfrmBillCommissionBack');
  FBillClassName.Add(COMMISSION_PRICE_VCHTYPE, 'TfrmBillCommissionPrice');
  FBillClassName.Add(BUY_FEE_VCHTYPE, 'TfrmBillBuyFeeList');
  FBillClassName.Add(BUY_EXPENSESALLOT_VCHTYPE, 'TfrmBillBuyExpenseAllot');
  FBillClassName.Add(INVOICE_SALEBILL, 'TfrmBillSaleInvoice');
  FBillClassName.Add(INVOICE_BUYBILL, 'TfrmBillBuyInvoice');
  FBillClassName.Add(WLHX_VCHTYPE, 'TfrmBillWLHX');
  FBillClassName.Add(PRODUCE_VCHTYPE, 'TfrmBillBuildSplit');
  FBillClassName.Add(Buy_Requisition_VchType, 'TBillBuyRequisition');
  FBillClassName.Add(Sale_Offer_VchType, 'TBillSaleOffer');
  FBillClassName.Add(LOAN_VCHTYPE, 'TfrmBillLoan');
  FBillClassName.Add(EXPENSEWIPEOUT_VCHTYPE, 'TfrmBillExpenseWipeOut');
  FBillClassName.Add(ORDER_BUY_VCHTYPE, 'TfrmBillBuyOrder');
  FBillClassName.Add(ORDER_SALE_VCHTYPE, 'TfrmBillSaleOrder');
  FBillClassName.Add(INSTOCK_VALUE_VCHTYPE, 'TfrmBillInstock');
  FBillClassName.Add(FACTSTOCK_INLIB_VCHTYPE, 'TfrmBillFactStockInLib');
  FBillClassName.Add(FACTSTOCK_OUTLIB_VCHTYPE, 'TfrmBillFactStockOutLib');
  FBillClassName.Add(FACTSTOCK_ALLOT_VCHTYPE, 'TfrmBillFactStockAllot');
  FBillClassName.Add(PRODUCE_PLAN_VCHTYPE, 'TfrmBillPlan');
  FBillClassName.Add(PRODUCE_ROLE_VCHTYPE, 'TfrmBillRole');
  FBillClassName.Add(PRODUCE_DRAW_VCHTYPE, 'TfrmBillDraw');
  FBillClassName.Add(PRODUCE_DRAW_BACK_VCHTYPE, 'TfrmBillDrawBack');
  FBillClassName.Add(PRODUCE_CHECKACCEPT_VCHTYPE, 'TfrmBillCheckAccept');
  FBillClassName.Add(PRODUCE_EXPENSESALLOT_VCHTYPE, 'TfrmBillExpenseAllot');
  FBillClassName.Add(PRODUCE_LOSE_VCHTYPE, 'TfrmBillSCLose');
  FBillClassName.Add(PRODUCE_GET_VCHTYPE, 'TfrmBillSCGain');
  FBillClassName.Add(CONSIGN_PLAN_VCHTYPE, 'TfrmBillConsignPlan');
  FBillClassName.Add(CONSIGN_TASK_VCHTYPE, 'TfrmBillConsignTask');
  FBillClassName.Add(CONSIGN_DRAW_VCHTYPE, 'TfrmBillConsignDraw');
  FBillClassName.Add(CONSIGN_DRAW_BACK_VCHTYPE, 'TfrmBillConsignDrawBack');
  FBillClassName.Add(CONSIGN_CHECKACCEPT_VCHTYPE, 'TfrmBillConsignCheckAccept');
  FBillClassName.Add(CONSIGN_PROCESS_FEE_VCHTYPE, 'TfrmBillConsignFeeList');
  FBillClassName.Add(CONSIGN_SETTLE_VCHTYPE, 'TfrmBillConsignSettle');
  FBillClassName.Add(CONSIGN_EXPENSESALLOT_VCHTYPE, 'TfrmBillConsignExpenseAllot');
  FBillClassName.Add(WORK_ORDER_VCHTYPE, 'TfrmBillWorkOrder');
  FBillClassName.Add(WORK_HAND_OVER_VCHTYPE, 'TfrmBillHandOver');
  FBillClassName.Add(WORK_TICKET_VCHTYPE, 'TfrmBillWorkTicket');
  FBillClassName.Add(Ini_GoodsStock_VCHTYPE, 'TfrmBillIniGoodsStock');
  FBillClassName.Add(Ini_FactStock_VCHTYPE, 'TfrmBillIniFactStock');
  FBillClassName.Add(Ini_Commission_VCHTYPE, 'TfrmBillIniCommission');
  FBillClassName.Add(Ini_Settle_VCHTYPE, 'TfrmBillIniSettle');
  FBillClassName.Add(Ini_ProduceStock_VchType, 'TfrmBillIniProduceStock');
  FBillClassName.Add(Ini_ConsignStock_VchType, 'TfrmBillIniConsignStock');
  FBillClassName.Add(SPLITEXPENSEALLOT_VCHTYPE, 'TfrmBillSplitExpenseAllot');
  FBillClassName.Add(SIMPLE_CONSIGN_TASK_VCHTYPE, 'TfrmBillSimpleConsignTask');
  FBillClassName.Add(SIMPLE_CONSIGN_DRAW_VCHTYPE, 'TfrmBillSimpleConsignDraw');
  FBillClassName.Add(SIMPLE_CONSIGN_DRAW_BACK_VCHTYPE, 'TfrmBillSimpleConsignDrawBack');
  FBillClassName.Add(SIMPLE_CONSIGN_CHECKACCEPT_VCHTYPE, 'TfrmBillSimpleConsignCheckAccept');
  FBillClassName.Add(PRODUCE_CHANGE_PRICE_VCHTYPE, 'TfrmBillProduceChangePrice');
  FBillClassName.Add(BUY_SEND_CHECK, 'TfrmBillBuySendCheck');
  FBillClassName.Add(BUY_QMCHECK, 'TfrmBillBuyQMCheck');
end;


{ TBillDetailDatas }

function TBillDetailDatas.Add: PBillDetailData;
begin
  New(Result);
  FillChar(Result^, SizeOf(TBillDetailData), 0);
  Result^.UsedType := 1;
  FItems.Add(Result);
end;

procedure TBillDetailDatas.Clear;
var
  i : Integer;
begin
  if FItems.Count > 0 then
  begin
    try
      for i:=0 to FItems.Count-1 do
        if Assigned(FItems[i]) then
          Dispose(FItems[i]);
      FItems.Clear;
    finally

    end;
  end;
end;

procedure TBillDetailDatas.ClearDataItem(Index: Integer = -1);
var i: Integer;
begin
  if Index = -1 then //clear all
    for i := 0 to FItems.Count - 1 do
      FItems[i] := nil
  else
    FItems[Index] := nil;
end;

constructor TBillDetailDatas.Create;
begin
  FItems := TList.Create;
end;

procedure TBillDetailDatas.Delete(Index: Integer);
begin
  Dispose(FItems[Index]);
end;

destructor TBillDetailDatas.Destroy;
begin
  if FItems <> nil then
    Clear;
  FItems.Free;
  inherited Destroy;
end;

function TBillDetailDatas.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TBillDetailDatas.GetItem(Index: Integer): PBillDetailData;
begin
  Result := PBillDetailData(FItems[Index]);
end;

function TBillDetailDatas.Insert(Index: Integer): PBillDetailData;
begin
  New(Result);
  FillChar(Result^, SizeOf(PBillDetailData), 0);
  FItems.Insert(Index, Result);
end;

procedure TBillDetailDatas.SetItem(Index: Integer;
  const Value: PBillDetailData);
begin
  FItems[Index] := Value;
end;

{ TBillSerialDatas }

function TBillSerialDatas.Add: PBillSerialData;
begin
  New(Result);
  FillChar(Result^, SizeOf(TBillSerialData), 0);
  Result^.UsedType := 1;
  FItems.Add(Result);
end;

procedure TBillSerialDatas.Clear;
var
  i : Integer;
begin
  if FItems.Count > 0 then
  begin
    try
      for i:=0 to FItems.Count-1 do
         Dispose(FItems[i]);
      FItems.Clear;
    finally

    end;
  end;
end;

constructor TBillSerialDatas.Create;
begin
  FItems := TList.Create;
end;

procedure TBillSerialDatas.Delete(Index: Integer);
begin
  Dispose(FItems[Index]);
end;

destructor TBillSerialDatas.Destroy;
begin
  if FItems <> nil then
    Clear;
  FItems.Free;
  inherited Destroy;
end;

function TBillSerialDatas.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TBillSerialDatas.GetItem(Index: Integer): PBillSerialData;
begin
  Result := PBillSerialData(FItems[Index]);
end;

function TBillSerialDatas.Insert(Index: Integer): PBillSerialData;
begin
  Result := nil;
end;

procedure TBillSerialDatas.SetItem(Index: Integer;
  const Value: PBillSerialData);
begin
  FItems[Index] := Value;
end;

{ TBillJSDatas }

function TBillJSDatas.Add: PBillJSData;
begin
  New(Result);
  FillChar(Result^, SizeOf(PBillJSData), 0);
  FItems.Add(Result);
end;

procedure TBillJSDatas.Clear;
var
  i : Integer;
begin
  if FItems.Count > 0 then
  begin
    try
      for i:=0 to FItems.Count-1 do
         Dispose(FItems[i]);
      FItems.Clear;
    finally

    end;
  end;

end;

procedure TBillJSDatas.ClearDataItem(Index: Integer);
var i: Integer;
begin
  if Index = -1 then //clear all
    for i := 0 to FItems.Count - 1 do
      FItems[i] := nil
  else
    FItems[Index] := nil;
end;

constructor TBillJSDatas.Create;
begin
  FItems := TList.Create;
end;

procedure TBillJSDatas.Delete(Index: Integer);
begin
  Dispose(FItems[Index]);
end;

destructor TBillJSDatas.Destroy;
begin
  if FItems <> nil then
    Clear;
  FItems.Free;
  inherited Destroy;
end;

function TBillJSDatas.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TBillJSDatas.GetItem(Index: Integer): PBillJSData;
begin
  Result := PBillJSData(FItems[Index]);
end;

function TBillJSDatas.Insert(Index: Integer): PBillJSData;
begin
  New(Result);
  FillChar(Result^, SizeOf(PBillJSData), 0);
  FItems.Insert(Index, Result);
end;

procedure TBillJSDatas.SetItem(Index: Integer;
  const Value: PBillJSData);
begin
  FItems[Index] := Value;
end;

{ TBillCheckDetails }

function TBillCheckDetails.Add: TBillCheckDetailList;
begin
  New(Result);
  FillChar(Result^, SizeOf(TBillCheckDetailList), 0);
  FItems.Add(Result);
end;

procedure TBillCheckDetails.Clear;
var
  i : Integer;
begin
  if FItems.Count > 0 then
  begin
    try
      for i:=0 to FItems.Count-1 do
         Dispose(FItems[i]);
      FItems.Clear;
    finally

    end;
  end;

end;

procedure TBillCheckDetails.ClearDataItem(Index: Integer);
var i: Integer;
begin
  if Index = -1 then //clear all
    for i := 0 to FItems.Count - 1 do
      FItems[i] := nil
  else
    FItems[Index] := nil;
end;

constructor TBillCheckDetails.Create;
begin
  FItems := TList.Create;
end;

procedure TBillCheckDetails.Delete(Index: Integer);
begin
  Dispose(FItems[Index]);
end;

destructor TBillCheckDetails.Destroy;
begin
  if FItems <> nil then
    Clear;
  FItems.Free;
  inherited Destroy;
end;

function TBillCheckDetails.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TBillCheckDetails.GetItem(Index: Integer): TBillCheckDetailList;
begin
  Result := TBillCheckDetailList(FItems[Index]);
end;

function TBillCheckDetails.Insert(Index: Integer): TBillCheckDetailList;
begin
  New(Result);
  FillChar(Result^, SizeOf(TBillCheckDetailList), 0);
  FItems.Insert(Index, Result);
end;

procedure TBillCheckDetails.SetItem(Index: Integer;
  const Value: TBillCheckDetailList);
begin
  FItems[Index] := Value;
end;


{ TBillSourceInfomations }

function TBillSourceInfomations.Add: TBillSourceInfoList;
begin
  New(Result);
  FillChar(Result^, SizeOf(TBillSourceInfoList), 0);
  FItems.Add(Result);
end;

procedure TBillSourceInfomations.Clear;
var
  i : Integer;
begin
  if FItems.Count > 0 then
  begin
    try
      for i:=0 to FItems.Count-1 do
         Dispose(FItems[i]);
      FItems.Clear;
    finally
    end;
  end;
end;

procedure TBillSourceInfomations.ClearDataItem(Index: Integer);
var i: Integer;
begin
  if Index = -1 then //clear all
    for i := 0 to FItems.Count - 1 do
      FItems[i] := nil
  else
    FItems[Index] := nil;
end;

constructor TBillSourceInfomations.Create;
begin
  FItems := TList.Create;
end;

procedure TBillSourceInfomations.Delete(Index: Integer);
begin
  Dispose(FItems[Index]);
end;

destructor TBillSourceInfomations.Destroy;
begin
  if FItems <> nil then
    Clear;
  FItems.Free;
  inherited Destroy;
end;

function TBillSourceInfomations.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TBillSourceInfomations.GetItem(Index: Integer): TBillSourceInfoList;
begin
  Result := TBillSourceInfoList(FItems[Index]);
end;

function TBillSourceInfomations.Insert(Index: Integer): TBillSourceInfoList;
begin
  New(Result);
  FillChar(Result^, SizeOf(TBillSourceInfoList), 0);
  FItems.Insert(Index, Result);
end;

procedure TBillSourceInfomations.SetItem(Index: Integer; const Value: TBillSourceInfoList);
begin
  FItems[Index] := Value;
end;

end.
