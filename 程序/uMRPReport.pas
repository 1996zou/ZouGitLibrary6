unit uMRPReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllMDIQueryParent, uCMEventHander, XPMenu, DB, DBClient, ComCtrls,
  uExtImage, xwbasiccomponent, xwBasicinfoComponent, XwGjpBasicCom, StdCtrls,
  ExtCtrls, ShadowPanel, XwTable, ToolWin, ugpGrids, ugpDbGrids, ugpStdGrids,
  xwgridsclass, XwGGeneralGrid, xwButtons,xwbasicinfoclassdefine_c,uDllCondBox,
  XWComponentType,uDllDataBaseIntf,uDllDBService,xwgtypedefine,uDllSystemIntf,
  uDataStructure,uDllBillInterface,uOperationFunc,uDllMessageIntf;

type
  TfrmBuyStateReport = class(TfrmDllMDIQueryParent)
    MainGrid: TXwGGeneralGrid;
    tbtnQueryCond: TToolButton;
    btnQueryCond: TCMGXwBitbtn;
    tbtnRefresh: TToolButton;
    btnRefresh: TCMGXwBitbtn;
    btnClose: TCMGXwBitbtn;
    lblDateBegin: TCMGXwLabelLabel;
    lblDateEnd: TCMGXwLabelLabel;
    lblPtype: TCMGXwLabelLabel;
    lblBtype: TCMGXwLabelLabel;
    lblEtype: TCMGXwLabelLabel;
    lblKtype: TCMGXwLabelLabel;
    tbtnClose: TToolButton;
    CMGLabelComBox1: TCMGLabelComBox;
    procedure btnCloseClick(Sender: TObject);
    procedure btnQueryCondClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure MainGridDblClick(Sender: TObject);
    procedure CMGLabelComBox1Change(Sender: TObject);

  private
    procedure IniMainGrid;
    procedure IniCondition;
    procedure IniParams;
    procedure MainRun;
    { Private declarations }
  public
    procedure ReadData;
  end;

  function  ShowMRPReport : Boolean;
var
  cndTemp: TCondition;
implementation
{$R *.dfm}

function  ShowMRPReport : Boolean;
begin
  Result := False;
  with TfrmBuyStateReport.Create(nil) do
  begin
    Title := '客户往来按存货结算对账单报表';
    FunctionNo := 25000018;
    MainRun;

    //动态添加下拉框
    //CMGLabelComBox1.Items.Add('显示类型');
    //CMGLabelComBox1.Items.Add('只显示未结算存货');
    //CMGLabelComBox1.Items.Add('只显示已结算存货');

    CMGLabelComBox1.Items.addObject('显示类型',TObject(-1));
    CMGLabelComBox1.Items.addObject('只显示未结算存货',TObject(0));
    CMGLabelComBox1.Items.addObject('只显示已结算存货',TObject(1));
  end;
  Result := True;
end;


procedure TfrmBuyStateReport.IniMainGrid;
begin
  SetGridProperty(MainGrid);
  with MainGrid do
  begin
    ClearAllField;

    //单位全名、经办人全名、合同号、存货编号、存货全名、采购订货数量、采购到货数量、采购未到货数量、配货数量、仓位（表体自定义）、到货百分比、配货百分比
    Moudleno := FunctionNo;
     {
    CMAddField(flPTypeid,'物料');
    CMAddField(flKtypeid);
    CMAddField(flBtypeid);
    CMAddField(flNQty, '当前库存量', 'qty');
    CMAddField(flNQty, '净需求量', 'LastReqQty');
    CMAddField(flNQty, '毛需求量', 'BuyQty');
    CMAddField(flNMemo, '原单编号', 'SourceNumber');
    CMAddField(flNQty, '已下单量', 'BuildQty');
    CMAddField(flNMemo, '已下达单据号', 'BuildNumber');
    CMAddField(flNMemo, '生产订单号', 'ProductNumber');
    CMAddField(flNMemo, '计划单号', 'PlanNumber');
    CMAddField(flNMemo, '外购', 'bPurchase');
    CMAddField(flNMemo, '自制', 'bProduce');
    CMAddField(flNMemo, '委外', 'bConsign');
       }

       //配置【产品名称】, 配置【产品规格】, 配置【张数	,销售表数量,销售表单价, 销售表行摘要
    CMAddField(flNMemo, '日期','DATE');
    CMAddField(flNMemo, '单据编号','NUMBER');
    CMAddField(flNMemo, '单据类型','vchtypename');
    //结算单位
    //收款单位

    CMAddField(flNMemo, '产品名称','FreeDom03');
    CMAddField(flNmemo, '产品规格','FreeDom01');
    CMAddField(flNQty, '张数','FreeDom02');       //flNQty 数量类型 ;  flNMemo 文本类型;  flNTotal 金额类型 (一般使用在合计中比较常见)
    CMAddField(flNQty, '平方数','Qty');
    CMAddField(flNMemo, '单价','price');
    CMAddField(flNTotal, '金额','Total');
    CMAddField(flNMemo, '行摘要','comment');
    CMAddField(flNTotal, '已结算金额 ','AllTotal');
    CMAddField(flNTotal, '未结算金额','NoTotal');
    CMAddField(flNMemo, '单据摘要','summary');

    CMAddField(flPTypeid,'物料');
    CMAddField(flKtypeid,'仓库');
    CMAddField(flBtypeid,'收货单位');
    CMAddField(flBCtypeId,'结算单位');

    MainGrid.Footer:= true;   //默认显示合计

    InitGridData;
  end;
end;

procedure TfrmBuyStateReport.MainGridDblClick(Sender: TObject);
begin
  inherited;
  //btnEditClick(Sender);
end;

procedure TfrmBuyStateReport.MainRun;
begin
  IniCondition;
  IniParams;
  IniMainGrid;
  if not GetCondition(Params, cndTemp) then
  begin
    Close;
    Exit;
  end;
  ReadData;
end;

procedure TfrmBuyStateReport.IniParams;
begin
  Params[Ord(CMbtPType)]:= '00000';
  //Params[Ord(CMbtKType)]:= '00000';
  Params[Ord(CMbtCType)]:= '00000';
  Params[Ord(CMbtDateBegin)] := CurrJxcPeriodToStartDate;
  Params[Ord(CMbtDateEnd)] := CurrJxcPeriodToEndDate;
  Params[Ord(CMbtLMode)] := '0';  //增加一个默认查询参数
end;


procedure TfrmBuyStateReport.btnQueryCondClick(Sender: TObject);
begin
  inherited;
  if GetCondition(Params, cndTemp) then
    ReadData;
end;

procedure TfrmBuyStateReport.btnRefreshClick(Sender: TObject);
begin
  inherited;
  ReadData;
end;



procedure TfrmBuyStateReport.CMGLabelComBox1Change(Sender: TObject);
begin
  inherited;
    {
    Params[Ord(CMbtLMode)] :=CMGLabelComBox1.text;
   Params[Ord(CMbtLMode)] := CMGLabelComBox1.Items[CMGLabelComBox1.itemindex];
   Params[Ord(CMbtLMode)] := Integer(CMGLabelComBox1.Items.Objects[1]);
   }
   //Params[Ord(CMbtLMode)] :=CMGLabelComBox1.Items[CMGLabelComBox1.ItemIndex];
   Params[Ord(CMbtLMode)] :=CMGLabelComBox1.value;
   ReadData;
end;


procedure TfrmBuyStateReport.IniCondition;
begin
    Params[Ord(CMbtDateBegin)] := CurrJxcPeriodToStartDate;
    Params[Ord(CMbtDateEnd)] := CurrJxcPeriodToEndDate;

    with cndTemp do
    begin
      SetLength(ConditionSet,5);

      ConditionSet[0].ConditionType := CMbtDateBegin;
      ConditionSet[0].ControlType := ctDate;

      ConditionSet[1].ConditionType := CMbtDateEnd;
      ConditionSet[1].ControlType := ctDate;

      //带选择按钮的输入框
      ConditionSet[2].ConditionType := CMbtPtype;
      ConditionSet[2].XWBasicType   := btPtype;
      ConditionSet[2].ControlType   := ctButtonEdit;
      ConditionSet[2].SelectOptions := [bopSelectClass,bopAllSelect];
      ConditionSet[2].DataType      := dtString;
      ConditionSet[2].Caption:= '存   货';


      ConditionSet[3].ConditionType := CMbtCType;   //弹出选择页面:CMbtBtype：全部往来单位   CMbtCType：客户
      ConditionSet[3].XWBasicType   := btBCtype;   //查询框默认内容：btBCtype:全部客户 btBtype:全部往来单位
      ConditionSet[3].ControlType   := ctButtonEdit;
      ConditionSet[3].SelectOptions := [bopSelectClass,bopAllSelect];
      ConditionSet[3].DataType      := dtString;
      ConditionSet[3].Caption:= '结算单位';

      //自定义下拉框
    ConditionSet[4].ConditionType   := CMbtLMode;
    ConditionSet[4].ControlType   := ctValueComBoBox;
    ConditionSet[4].Caption       := '显示类型';
    ConditionSet[4].DisplayValue := TStringList.Create;
    ConditionSet[4].DisplayValue.Add('全部显示');
    ConditionSet[4].DisplayValue.Add('只显示未结算存货');
    ConditionSet[4].DisplayValue.Add('只显示已结算存货');
    ConditionSet[4].ReturnValue := TStringList.Create;
    ConditionSet[4].ReturnValue.Add('0');
    ConditionSet[4].ReturnValue.Add('1');
    ConditionSet[4].ReturnValue.Add('2');


      ImageIndex := 0;
      Title := '查询条件';
    end; // with
end;

procedure TfrmBuyStateReport.ReadData;
begin
  //CalcCost(MainGrid, Params[Ord(CMbtPtype)]);
      {
    OpenProcByName('T_Inf_MRPPurchase_DetailedTotal_25000016',
    ['@szBeginDate','@szEndDate','@PTypeID', '@BuildNumber','@SourceNumber'],
    [Params[Ord(CMbtDateBegin)],Params[Ord(CMbtDateEnd)],Params[Ord(CMbtPtype)],'',''],
     cdsGetRecordSet, nil);
      }

    OpenProcByName('p_XIWA_ReaccountQueryPtype_25000018',
    ['@szBTypeID','@szPTypeID','@szBeginDate','@szEndDate','@OperatorID','@showOver','@IsPaging','@PageSize','@PageIndex','@PageFilter','@PageTotal','@showType'],
    [Params[Ord(CMbtCType)],Params[Ord(CMbtPtype)],Params[Ord(CMbtDateBegin)],Params[Ord(CMbtDateEnd)],'00001',0,0,50,0,'',0,Params[Ord(CMbtLMode)]],
    cdsGetRecordSet, nil);
  LoadData;
end;



procedure TfrmBuyStateReport.btnCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
