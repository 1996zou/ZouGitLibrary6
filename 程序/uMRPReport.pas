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
    Title := '�ͻ����������������˵�����';
    FunctionNo := 25000018;
    MainRun;

    //��̬���������
    //CMGLabelComBox1.Items.Add('��ʾ����');
    //CMGLabelComBox1.Items.Add('ֻ��ʾδ������');
    //CMGLabelComBox1.Items.Add('ֻ��ʾ�ѽ�����');

    CMGLabelComBox1.Items.addObject('��ʾ����',TObject(-1));
    CMGLabelComBox1.Items.addObject('ֻ��ʾδ������',TObject(0));
    CMGLabelComBox1.Items.addObject('ֻ��ʾ�ѽ�����',TObject(1));
  end;
  Result := True;
end;


procedure TfrmBuyStateReport.IniMainGrid;
begin
  SetGridProperty(MainGrid);
  with MainGrid do
  begin
    ClearAllField;

    //��λȫ����������ȫ������ͬ�š������š����ȫ�����ɹ������������ɹ������������ɹ�δ���������������������λ�������Զ��壩�������ٷֱȡ�����ٷֱ�
    Moudleno := FunctionNo;
     {
    CMAddField(flPTypeid,'����');
    CMAddField(flKtypeid);
    CMAddField(flBtypeid);
    CMAddField(flNQty, '��ǰ�����', 'qty');
    CMAddField(flNQty, '��������', 'LastReqQty');
    CMAddField(flNQty, 'ë������', 'BuyQty');
    CMAddField(flNMemo, 'ԭ�����', 'SourceNumber');
    CMAddField(flNQty, '���µ���', 'BuildQty');
    CMAddField(flNMemo, '���´ﵥ�ݺ�', 'BuildNumber');
    CMAddField(flNMemo, '����������', 'ProductNumber');
    CMAddField(flNMemo, '�ƻ�����', 'PlanNumber');
    CMAddField(flNMemo, '�⹺', 'bPurchase');
    CMAddField(flNMemo, '����', 'bProduce');
    CMAddField(flNMemo, 'ί��', 'bConsign');
       }

       //���á���Ʒ���ơ�, ���á���Ʒ���, ���á�����	,���۱�����,���۱���, ���۱���ժҪ
    CMAddField(flNMemo, '����','DATE');
    CMAddField(flNMemo, '���ݱ��','NUMBER');
    CMAddField(flNMemo, '��������','vchtypename');
    //���㵥λ
    //�տλ

    CMAddField(flNMemo, '��Ʒ����','FreeDom03');
    CMAddField(flNmemo, '��Ʒ���','FreeDom01');
    CMAddField(flNQty, '����','FreeDom02');       //flNQty �������� ;  flNMemo �ı�����;  flNTotal ������� (һ��ʹ���ںϼ��бȽϳ���)
    CMAddField(flNQty, 'ƽ����','Qty');
    CMAddField(flNMemo, '����','price');
    CMAddField(flNTotal, '���','Total');
    CMAddField(flNMemo, '��ժҪ','comment');
    CMAddField(flNTotal, '�ѽ����� ','AllTotal');
    CMAddField(flNTotal, 'δ������','NoTotal');
    CMAddField(flNMemo, '����ժҪ','summary');

    CMAddField(flPTypeid,'����');
    CMAddField(flKtypeid,'�ֿ�');
    CMAddField(flBtypeid,'�ջ���λ');
    CMAddField(flBCtypeId,'���㵥λ');

    MainGrid.Footer:= true;   //Ĭ����ʾ�ϼ�

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
  Params[Ord(CMbtLMode)] := '0';  //����һ��Ĭ�ϲ�ѯ����
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

      //��ѡ��ť�������
      ConditionSet[2].ConditionType := CMbtPtype;
      ConditionSet[2].XWBasicType   := btPtype;
      ConditionSet[2].ControlType   := ctButtonEdit;
      ConditionSet[2].SelectOptions := [bopSelectClass,bopAllSelect];
      ConditionSet[2].DataType      := dtString;
      ConditionSet[2].Caption:= '��   ��';


      ConditionSet[3].ConditionType := CMbtCType;   //����ѡ��ҳ��:CMbtBtype��ȫ��������λ   CMbtCType���ͻ�
      ConditionSet[3].XWBasicType   := btBCtype;   //��ѯ��Ĭ�����ݣ�btBCtype:ȫ���ͻ� btBtype:ȫ��������λ
      ConditionSet[3].ControlType   := ctButtonEdit;
      ConditionSet[3].SelectOptions := [bopSelectClass,bopAllSelect];
      ConditionSet[3].DataType      := dtString;
      ConditionSet[3].Caption:= '���㵥λ';

      //�Զ���������
    ConditionSet[4].ConditionType   := CMbtLMode;
    ConditionSet[4].ControlType   := ctValueComBoBox;
    ConditionSet[4].Caption       := '��ʾ����';
    ConditionSet[4].DisplayValue := TStringList.Create;
    ConditionSet[4].DisplayValue.Add('ȫ����ʾ');
    ConditionSet[4].DisplayValue.Add('ֻ��ʾδ������');
    ConditionSet[4].DisplayValue.Add('ֻ��ʾ�ѽ�����');
    ConditionSet[4].ReturnValue := TStringList.Create;
    ConditionSet[4].ReturnValue.Add('0');
    ConditionSet[4].ReturnValue.Add('1');
    ConditionSet[4].ReturnValue.Add('2');


      ImageIndex := 0;
      Title := '��ѯ����';
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
