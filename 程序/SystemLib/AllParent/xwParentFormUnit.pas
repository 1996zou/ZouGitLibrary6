unit xwParentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls,ComCtrls, Grids, StdCtrls, CheckLst, DBClient,
  Dialogs, xwParamObjectUnit, xwBasicInfoComponent, xwGMessage, xwGtypeDefine,
  xwGridsFenbuBiao, xwBasicFun, xwgridsclass, xwVchGrid, xwLimit, //InitFunc,
  xwVchCalcClass, xwCalcFieldsDefine,XwLayout, xwTSele,
  xwMenusSetter, XwColorManiger, xwButtons, xwGridToolsPanel,xwAccessory,
  XwAligrid, xwReport;

type
  TxwParentForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FMoudleNo: Integer;
    FUseClassName:String;
    FPrintItem: string;
    FTitle: string;
    FHelpItem: string;
    FParamList: TGParamObject;
    procedure SetHelpItem(const Value: string);
    procedure SetParamList(const Value: TGParamObject);
    procedure SetPrintItem(const Value: string);
    { Private declarations }
    function GetParamList: TGParamObject;
    procedure SetUseClassName(const Value: String);
  protected
    procedure InitialAllComponent; virtual;
    procedure SetTitle(const Value: string); virtual;
    procedure DoSelectBasic(Sender: TObject; ABasicType: TBasicType;
      ASelectBasicParam: TSelectBasicParam;
      ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
      var ReturnCount: Integer); virtual;

    procedure DoGetMoudleNo(Sender: TObject; var AMoudleNo: Integer;var AUseClassName:String);
    procedure DoGetTitle(Sender: TObject; var ATitle: string);
    procedure DoReturnNextCom(Sender: TObject);virtual;
    procedure DoUpPreviousCom(Sender: TObject);virtual;
    procedure DoGetBtnLimit(Sender : TObject; AMoudleNo,ABtnTypeOrd : Integer;AUseClassName:String;
    var AHaveLimit : Boolean; var ABtnLimitType : TBtnLimitType);virtual;

    procedure DoXWFormShow(Sender : TComponent);

    procedure DoXwLogAdd(AXwLog: TxwChangeLog);
    procedure DoXwLogLoad(AVchcode, AGroupID: Integer; AControlName: string; var ADataSet: TClientDataSet; AUseClassName: String);
  public
    { Public declarations }
    constructor CreateParamList(AOwner: TComponent; AParam: TGParamObject);

    class  procedure DoRefreshFace(Sender : TObject);
    procedure RefreshTitle(var message: TMessage); message REFRESH_MESSAGE;

    procedure RefreshFace(var message: TMessage); message REFRESH_FACE_MESSAGE;

    procedure RefreshGridRelate(var message: TMessage); message REFRESH_GRID_RELATE_MESSAGE;

    procedure RefreshRelateFuncs(var msg: TMessage); message RELATE_FUNC_REFRESH;


    procedure InitParamList; virtual;//产品可以在窗口创建之前先对参数进行处理
    Procedure AfterSetParamList;virtual;//这个是在设置了新的参数后使用的

    procedure SendTreeRefreshMsg(ABasicTypeOrd: Integer);
    procedure SendTreeSortMsg(ABasicTypeOrd: Integer);

    function CheckInput: Boolean; virtual;

    procedure InitGLabelBtnEdit(Comp: TComponent);
    procedure InitGLabelMemo(Comp: TComponent);
    procedure InitGLabelComBox(Comp: TComponent);
    procedure InitGLabelEmptyDate(Comp: TComponent); virtual;
    procedure InitGLabelCheckBox(Comp: TComponent);
    procedure InitFenbubiaoGrid(Comp: TComponent);
    procedure InitVchGridClass(Comp: TComponent);
    //procedure InitCostumeVchGrid(Comp: TComponent);
    procedure InitBandGrid(Comp: TComponent);
    procedure InitReport(Comp: TComponent);
    procedure InitFenBuGridGroup(Comp: TComponent);
    procedure InitGLimitClass(Comp: TComponent);
    procedure InitGBitbtn(Comp: TComponent);
    procedure InitxwPanel(Comp: TComponent);
    procedure InitStatusBar(Comp: TComponent);
    procedure InitLayoutClass(Comp: TComponent);

    class procedure DoPrintGetConfig(APrintID: Integer; var APrintConfig: TPrintConfig);
    class procedure DoPrintSetCongfig(APrintID: Integer; APrintConfig: TPrintConfig);

    procedure InitXwGroupMark(Comp: TComponent);
    class procedure RefreshMenuBtn(Comp: TComponent);
    class procedure InitAlignGrid(Comp: TComponent);virtual;
    class procedure RefreshGrid(Comp: TComponent); virtual;
    class procedure RefreshLabelBtnEdit(Comp: TComponent); virtual;
    class procedure RefreshEmptyDate(Comp: TComponent); virtual;
    class procedure RefreshLabelLabel(Comp: TComponent); virtual;
    class procedure RefreshBitBtn(Comp: TComponent); virtual;
    class procedure RefreshStringGrid(Comp: TComponent); virtual;
    class procedure RefreshPanel(Comp: TComponent); virtual;
    class procedure RefreshCheckBox(Comp: TComponent); virtual;
    class procedure RefreshGroupBox(Comp: TComponent); virtual;
    class procedure RefreshCheckListBox(Comp: TComponent); virtual;
    class procedure RefreshRadioGroup(Comp: TComponent);  virtual;
    class procedure RefreshStatusBar(Comp: TComponent); virtual;
    class procedure RefreshSplitter(Comp: TComponent); virtual;
    class procedure RefreshLabel(Comp: TComponent); virtual;
    class procedure RefreshMemo(Comp: TComponent);  virtual;
    class procedure RefreshPageControl(Comp: TComponent);  virtual;
    class procedure RefreshEdit(Comp: TComponent); virtual;
    property MoudleNo: Integer read FMoudleNo write FMoudleNo;
    property UseClassName:String read FUseClassName write SetUseClassName;
    property Title: string read FTitle write SetTitle;
    property HelpItem: string read FHelpItem write SetHelpItem;
    property PrintItem: string read FPrintItem write SetPrintItem;
    property ParamList: TGParamObject read GetParamList write SetParamList;
  end;

implementation

uses {XwExistUnit,} xwbasiccomponent, uDllExistIntf;

{$R *.dfm}

{ TxwParentForm }

function TxwParentForm.CheckInput: Boolean;
var
  I                           : Integer;
  Btn                         : TGLabelBtnEdit;
  D                           : TGLabelEmptyDate;
  m                           : TGLabelMemo;
begin
  Result := False;
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TGLabelBtnEdit then
    begin
      btn := TGLabelBtnEdit(Components[I]);
      if not btn.AllowBlank then
      begin
        if btn.Blank then SelfMessage('必须输入 ' + btn.Caption + '!', '提示');
        Exit;
      end;
    end;
    if Components[I] is TGLabelEmptyDate then
    begin
      d := TGLabelEmptyDate(Components[I]);
      if not d.AllowBlank then
      begin
        if d.Blank then SelfMessage('必须输入 ' + d.Caption + '!', '提示');
        Exit;
      end;

    end;
    if Components[I] is TGLabelMemo then
    begin
      m := TGLabelMemo(Components[I]);
      if not m.AllowBlank then
      begin
        if m.Blank then SelfMessage('必须输入 ' + m.Caption + '!', '提示');
        Exit;
      end;
    end;
  end;
  Result := True;
end;

constructor TxwParentForm.CreateParamList(AOwner: TComponent;
  AParam: TGParamObject);
begin
  FParamList := TGParamObject.Create;
  InitParamList;
  ParamList := AParam;
  //以后也可以增加把参数拷过来以后让开发人员处理参数
  AfterSetParamList;
  Create(AOwner); //创建窗口实例 MDI一创建就显示，
end;

procedure TxwParentForm.DoGetMoudleNo(Sender: TObject; var AMoudleNo: Integer;var AUseClassName:String);
begin
  AMoudleNo := MoudleNo;
  AUseClassName := UseClassName;
end;

procedure TxwParentForm.DoGetTitle(Sender: TObject; var ATitle: string);
begin
  ATitle := Title;
end;


procedure TxwParentForm.DoReturnNextCom(Sender: TObject);
begin
  SelectNext(ActiveControl as TWinControl, True, True);
end;

procedure TxwParentForm.DoSelectBasic(Sender: TObject;
  ABasicType: TBasicType; ASelectBasicParam: TSelectBasicParam;
  ASelectOptions: TSelectBasicOptions; var ABasicDatas: TSelectBasicDatas;
  var ReturnCount: Integer);
begin

end;

procedure TxwParentForm.InitialAllComponent;
var i : Integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TGLabelBtnEdit) then InitGLabelBtnEdit(Components[i])
    else if (Components[i] is TGLabelMemo) then InitGLabelMemo(Components[i])
    else if (Components[i] is TGLabelComBox) then InitGLabelComBox(Components[i])
    else if (Components[i] is TGLabelEmptyDate) then InitGLabelEmptyDate(Components[i])
    else if (Components[i] is TFenbubiaoGrid) then InitFenbubiaoGrid(Components[i])
    else if (Components[i] is TVchGridClass) then InitVchGridClass(Components[i])
    //else if (Components[i] is TxwCosumeVchGrid) then InitCostumeVchGrid(Components[i])
    else if (Components[i] is TxwBandGrid) then InitBandGrid(Components[i])
    else if (Components[i] is TFenbubiaoGridGroup) then InitFenBuGridGroup(Components[i])
    else if (Components[i] is TGLimitClass) then InitGLimitClass(Components[i])
    else if (Components[i] is TGXwBitbtn) then InitGBitbtn(Components[i])
    else if (Components[i] is TXwPanel) then InitxwPanel(Components[i])
    else if (Components[i] is TXwGroupMark) then InitXwGroupMark(Components[i])
    else if (Components[i] is TXwStatusBar) then InitStatusBar(Components[i])
    else if (Components[i] is TXwLayOutClass) then InitLayoutClass(Components[i])
    else if (Components[i] is TxwReport) then InitReport(Components[i])
    else if (Components[i] is TGCheckBoxInner) then InitGLabelCheckBox(Components[i]);
  end;
  DoRefreshFace(Self);
end;

procedure TxwParentForm.InitParamList;
begin
  //
end;

procedure TxwParentForm.InitReport(Comp: TComponent);
var cp : TxwBandGrid;
  rp : TxwReport;
begin
  rp := TxwReport(Comp);
  cp := rp.Grid;
  cp.BasicDataLocal := GetBasicDataLocalClass; //GetBasicDataLocalClass; //ExistForm.GBasicDataLocalClass1;
  cp.BasicRecordaLL_C := GetBasicRecordAll_C; //GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  cp.GridFieldConfigClass := GetGridFieldConfigClass; //GetGridFieldConfigClass; //ExistForm.GGridFieldConfigClass1;
  cp.LimitData := GetLimitData; //GetLimitData; //ExistForm.LimitData1;
  cp.ProcHandler := GetXwProcHandler; //GetXwProcHandler; //ExistForm.xwProcHandler1;
  cp.VchtypeSelectData := GetSelectVchtypeClass; //GetSelectVchtypeClass; //ExistForm.SelectVchtypeClass1;
  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam>0 then
  begin
    cp.FixedColor := GetSystemColor(GridFixedColBackColor);
    cp.TitleColor := GetSystemColor(GridFixedRowBackColor);
    cp.color := clBlue;
    cp.Font.Color := clRed;
    cp.Font.Charset := GB2312_CHARSET;
    cp.Font.Name := '宋体';
    cp.Font.Size := 9;
    cp.SetTwoColor(clGray,clWhite);
  end;
  cp.DateDBHelper := GetXwDateSubsecDBHelper; //GetXwDateSubsecDBHelper; //ExistForm.FDateDBHelper;
  cp.FavoriteHandler := GetFavoriteStockHandler; //GetFavoriteStockHandler; //ExistForm.FavoriteStockHandler1;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  cp.SelfBasicTypeAccess:= GetXwSelfBasicTypeAccess; //GetXwSelfBasicTypeAccess; //ExistForm.XwSelfBasicTypeAccess1;
  cp.OnXWFormShow := DoRefreshFace;
  cp.ToolsPanelHelper := GetXwGridToolsPanelHelper; //GetXwGridToolsPanelHelper; //ExistForm.xwGridToolsPanelHelper1;
  cp.AssistDataHelper := GetXwAssitDataHelper; //GetXwAssitDataHelper; //ExistForm.xwAssitDataHelper1;
end;

procedure TxwParentForm.SetHelpItem(const Value: string);
begin
  FHelpItem := Value;
end;

procedure TxwParentForm.SetParamList(const Value: TGParamObject);
begin
  if Value = nil then Exit;
  if FParamList <> Value then
  begin
    FParamList.Params := Value.Params;
  end;
end;

procedure TxwParentForm.SetPrintItem(const Value: string);
begin
  FPrintItem := Value;
end;

procedure TxwParentForm.SetTitle(const Value: string);
var i: integer;
  s : string;
begin
  FTitle := Value;
  for i := 0 to ComponentCount - 1 do
  begin
    s := UpperCase(Components[i].ClassParent.ClassName);
    if s = UpperCase('TxwBandGrid') then
      TXwBandGrid(Components[i]).Title := Value
    else if s = UpperCase('TFENBUBIAOGRID') then
      TFenbubiaoGrid(Components[i]).Title := Value
    else if s = UpperCase('TVchGridClass') then
      TVchGridClass(Components[i]).Title := Value;
  end;
end;

procedure TxwParentForm.SetUseClassName(const Value: String);
begin
  FUseClassName := Value;
end;

procedure TxwParentForm.FormCreate(Sender: TObject);
begin
  InitialAllComponent;
end;

procedure TxwParentForm.FormDestroy(Sender: TObject);
begin
  //不知道以前为什么把这句屏蔽掉了，这句没有会导致memory leak
  try
     if  FParamList<>nil then FParamList.Free;
  except
  end;
end;

procedure TxwParentForm.DoGetBtnLimit(Sender: TObject; AMoudleNo,
  ABtnTypeOrd: Integer; AUseClassName:String; var AHaveLimit: Boolean;
  var ABtnLimitType: TBtnLimitType);
begin

end;

procedure TxwParentForm.RefreshTitle(var message: TMessage);
var i: integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TXwBandGrid) then
      TXwBandGrid(Components[i]).RefreshTitle;
  end;
end;

function TxwParentForm.GetParamList: TGParamObject;
begin
  Result := FParamList;
end;

procedure TxwParentForm.InitGLabelBtnEdit(Comp: TComponent);
var cp: TGLabelBtnEdit;
begin
  cp := TGLabelBtnEdit(Comp);
  cp.OnSelectBasic := DoSelectBasic;
  cp.BasicDataLocalClass := GetBasicDataLocalClass; //GetBasicDataLocalClass; //ExistForm.GBasicDataLocalClass1;
  cp.BasicRecord := GetBasicRecordAll_C; //GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  cp.OnReturnNextCom := DoReturnNextCom;
  cp.OnUpPreviousCom := DoUpPreviousCom;
  //if (ExistForm.XwColorManiData1.ColorTeam>0) then
  if (GetXwColorMainData.ColorTeam > 0) then
    cp.FocusColor :=  GetSystemColor(EditInputfocuscolor);
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  cp.SelfBasicTypeAccess := GetXwSelfBasicTypeAccess; //GetXwSelfBasicTypeAccess; //ExistForm.XwSelfBasicTypeAccess1;
  cp.GridFieldConfigClass := GetGridFieldConfigClass; //GetGridFieldConfigClass; //ExistForm.GGridFieldConfigClass1;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  cp.OnxwRefresh := DoRefreshFace;
  cp.VsfLoadLoad := DoXwLogLoad; //ExistForm.XwLogLoad;
  cp.VsfLogAdd := DoXwLogAdd; //ExistForm.XwLogAdd;
end;

procedure TxwParentForm.InitLayoutClass(Comp: TComponent);
var cp : TXwLayoutClass;
begin
  cp := TXwLayoutClass(Comp);
  cp.SelfBasicTypeAccess := GetXwSelfBasicTypeAccess; //GetXwSelfBasicTypeAccess; //ExistForm.XwSelfBasicTypeAccess1;
  cp.BasicRecordAll_C:= GetBasicRecordAll_C; //GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  cp.BasicDataLocalClass := GetBasicDataLocalClass; //GetBasicDataLocalClass; //ExistForm.GBasicDataLocalClass1;
  cp.GridFieldConfigClass:= GetGridFieldConfigClass; //GetGridFieldConfigClass; //ExistForm.GGridFieldConfigClass1;
  cp.LogLoad := DoXwLogLoad; //ExistForm.XwLogLoad;
  cp.LogAdd := DoXwLogAdd; //ExistForm.XwLogAdd;
  cp.OnXWFormShow := DoRefreshFace;
end;

procedure TxwParentForm.InitXwGroupMark(Comp: TComponent);
begin
  TXwGroupMark(Comp).Color := GetSystemColor(SysBackColor);
end;

procedure TxwParentForm.InitGLabelMemo(Comp: TComponent);
var cp : TGLabelMemo;
begin
  cp := TGLabelMemo(Comp);
  cp.BasicRecord := GetBasicRecordAll_C; //GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam>0 then
  begin
    cp.FocusColor :=  GetSystemColor(EditInputfocuscolor);
  end;

  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  cp.SelfBasicTypeAccess := GetXwSelfBasicTypeAccess; //GetXwSelfBasicTypeAccess; //ExistForm.XwSelfBasicTypeAccess1;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
end;

procedure TxwParentForm.InitGLabelComBox(Comp: TComponent);
var cp : TGLabelComBox;
begin
  cp := TGLabelComBox(Comp);
  cp.OnReturnNextCom := DoReturnNextCom;

  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam>0 then
  begin
    cp.FocusColor :=  GetSystemColor(EditInputfocuscolor);
  end;
  cp.BasicRecord := GetBasicRecordAll_C; //GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
end;

procedure TxwParentForm.InitGLabelEmptyDate(Comp: TComponent);
var cp: TGLabelEmptyDate;
begin
  cp := TGLabelEmptyDate(Comp);
  cp.BasicRecord := GetBasicRecordAll_C; //GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam>0 then
  begin
    cp.FocusColor :=  GetSystemColor(EditInputfocuscolor);
  end;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  cp.OnReturnNextCom := DoReturnNextCom;
end;

procedure TxwParentForm.InitFenbubiaoGrid(Comp: TComponent);
var cp:TFenbubiaoGrid;
begin
  cp := TFenbubiaoGrid(Comp);
  cp.BasicDataLocal := GetBasicDataLocalClass; //GetBasicDataLocalClass; //ExistForm.GBasicDataLocalClass1;
  cp.BasicRecordaLL_C := GetBasicRecordAll_C; //GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  cp.GridFieldConfigClass := GetGridFieldConfigClass; //GetGridFieldConfigClass; //ExistForm.GGridFieldConfigClass1;
  cp.OnGetMoudleNo := DoGetMoudleNo;
  cp.OnXWFormShow := DoRefreshFace;
  cp.Title := Title;
  cp.FavoriteHandler := GetFavoriteStockHandler; //GetFavoriteStockHandler; //ExistForm.FavoriteStockHandler1;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  cp.ToolsPanelHelper := GetXwGridToolsPanelHelper; //GetXwGridToolsPanelHelper; //ExistForm.xwGridToolsPanelHelper1;
end;

procedure TxwParentForm.InitVchGridClass(Comp: TComponent);
var cp:TVchGridClass;
begin
  cp := TVchGridClass(Comp);
  cp.BasicDataLocal := GetBasicDataLocalClass; //GetBasicDataLocalClass; //ExistForm.GBasicDataLocalClass1;
  cp.BasicRecordaLL_C := GetBasicRecordAll_C; //GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  cp.GridFieldConfigClass := GetGridFieldConfigClass; //GetGridFieldConfigClass; //ExistForm.GGridFieldConfigClass1;
  cp.OnGetMoudleNo := DoGetMoudleNo;
  cp.OnXWFormShow := DoRefreshFace;  
  cp.FavoriteHandler := GetFavoriteStockHandler; //GetFavoriteStockHandler; //ExistForm.FavoriteStockHandler1;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  cp.SelfBasicTypeAccess := GetXwSelfBasicTypeAccess; //ExistForm.XwSelfBasicTypeAccess1;
  cp.ToolsPanelHelper := GetXwGridToolsPanelHelper; //ExistForm.xwGridToolsPanelHelper1;
  cp.AssistDataHelper := GetXwAssitDataHelper; //ExistForm.xwAssitDataHelper1;
  cp.LimitData := GetLimitData; //ExistForm.LimitData1;
end;

//procedure TxwParentForm.InitCostumeVchGrid(Comp: TComponent);
//var cp: TxwCosumeVchGrid;
//begin
//  cp := TxwCosumeVchGrid(Comp);
//  cp.BasicDataLocal := GetBasicDataLocalClass; //ExistForm.GBasicDataLocalClass1;
//  cp.BasicRecordaLL_C := GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
//  cp.GridFieldConfigClass := GetGridFieldConfigClass; //ExistForm.GGridFieldConfigClass1;
//  cp.OnGetMoudleNo := DoGetMoudleNo;
//  cp.FavoriteHandler := GetFavoriteStockHandler; //ExistForm.FavoriteStockHandler1;
//  cp.FuncRelateHandler := GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
//  cp.SelfBasicTypeAccess:=GetXwSelfBasicTypeAccess; //ExistForm.XwSelfBasicTypeAccess1;
//  cp.ToolsPanelHelper := GetXwGridToolsPanelHelper; //ExistForm.xwGridToolsPanelHelper1;
//  cp.AssistDataHelper := GetXwAssitDataHelper; //ExistForm.xwAssitDataHelper1;
//end;

procedure TxwParentForm.InitBandGrid(Comp: TComponent);
var cp : TxwBandGrid;
begin
  cp := TxwBandGrid(Comp);
  cp.BasicDataLocal := GetBasicDataLocalClass; //ExistForm.GBasicDataLocalClass1;
  cp.BasicRecordaLL_C := GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  cp.GridFieldConfigClass := GetGridFieldConfigClass; //ExistForm.GGridFieldConfigClass1;
  cp.OnGetMoudleNo := DoGetMoudleNo;
  cp.OnGetTitle := DoGetTitle;
  cp.LimitData := GetLimitData; //ExistForm.LimitData1;
  cp.ProcHandler := GetXwProcHandler; //ExistForm.xwProcHandler1;
  cp.VchtypeSelectData := GetSelectVchtypeClass; //ExistForm.SelectVchtypeClass1;
  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam > 0 then
  begin
    cp.FixedColor := GetSystemColor(GridFixedColBackColor);
    cp.TitleColor := GetSystemColor(GridFixedRowBackColor);
    cp.color := clBlue;
    cp.Font.Color := clRed;
    cp.Font.Charset := GB2312_CHARSET;
    cp.Font.Name := '宋体';
    cp.Font.Size := 9;
    cp.SetTwoColor(clGray,clWhite);
  end;
  cp.DateDBHelper := GetXwDateSubsecDBHelper; //ExistForm.FDateDBHelper;
  cp.FavoriteHandler := GetFavoriteStockHandler; //ExistForm.FavoriteStockHandler1;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  cp.SelfBasicTypeAccess:=GetXwSelfBasicTypeAccess; //ExistForm.XwSelfBasicTypeAccess1;
  cp.OnXWFormShow := DoRefreshFace;
  cp.ToolsPanelHelper := GetXwGridToolsPanelHelper; //ExistForm.xwGridToolsPanelHelper1;
  cp.AssistDataHelper := GetXwAssitDataHelper; //ExistForm.xwAssitDataHelper1;
end;


class procedure TxwParentForm.InitAlignGrid(Comp: TComponent);
var cp: TXwAlignGrid;
begin
   cp := TXwAlignGrid(Comp);
  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam > 0 then
  begin
    cp.FixedColor := GetSystemColor(GridFixedColBackColor);
    cp.Font.Charset := GB2312_CHARSET;
    cp.Font.Name := '宋体';
    cp.Font.Size := 9;
  end;
end;

procedure TxwParentForm.InitFenBuGridGroup(Comp: TComponent);
var cp:TFenbubiaoGridGroup;
begin
  cp:=TFenbubiaoGridGroup(Comp);
  cp.FenBuGrid.BasicDataLocal := GetBasicDataLocalClass; //ExistForm.GBasicDataLocalClass1;
  cp.FenBuGrid.BasicRecordaLL_C := GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  TFenbubiaoGridGroup(Comp).FenBuGrid.GridFieldConfigClass := GetGridFieldConfigClass; //ExistForm.GGridFieldConfigClass1;
  TFenbubiaoGridGroup(Comp).FenBuGrid.Title := Title;
  cp.OnXWFormShow := DoRefreshFace;
  TFenbubiaoGridGroup(Comp).FenBuGrid.FuncRelateHandler := GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  TFenbubiaoGridGroup(Comp).FenBuGrid.SelfBasicTypeAccess:=GetXwSelfBasicTypeAccess; //ExistForm.XwSelfBasicTypeAccess1;
  TFenbubiaoGridGroup(Comp).FenBuGrid.ToolsPanelHelper := GetXwGridToolsPanelHelper; //ExistForm.xwGridToolsPanelHelper1;
end;

procedure TxwParentForm.InitGLimitClass(Comp: TComponent);
var cp:TGLimitClass;
    i:integer;
begin
  cp:=TGLimitClass(Comp);
  cp.OnXWFormShow:=DoRefreshFace;
  cp.BasicRecordaLL_C := GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  for i:=1 to cp.PageCount do
  begin
      DoRefreshFace(cp.LimitPage[i]);
      cp.LimitPage[i].OnXWFormShow:=DoRefreshFace;
  end;
end;

procedure TxwParentForm.InitGBitbtn(Comp: TComponent);
begin
  TGXwBitbtn(Comp).OnGetBtnLimit := DoGetBtnLimit;
  TGXwBitbtn(Comp).OnGetMoudleNo := DoGetMoudleNo;
  TGXwBitbtn(Comp).LoadLimit;
  if  TGXwBitbtn(Comp).UseBtnBackJpeg then
  begin
    TGXwBitbtn(Comp).BackGroundBmps[xbsNormal] := GetXwColorMainData.BtnJpeg[xbsNormal]; //ExistForm.XwColorManiData1.BtnJpeg[xbsNormal];
    TGXwBitbtn(Comp).BackGroundBmps[xbsMouseOver] := GetXwColorMainData.BtnJpeg[xbsMouseOver]; //ExistForm.XwColorManiData1.BtnJpeg[xbsMouseOver];
  end;
end;

procedure TxwParentForm.InitxwPanel(Comp: TComponent);
begin
  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam > 0 then
  begin
    TXwPanel(Comp).Color := GetSystemColor(SysBackColor);
  end;
end;

procedure TxwParentForm.InitStatusBar(Comp: TComponent);
begin
  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam > 0 then
  begin
    TXwStatusBar(Comp).Color := GetSystemColor(MainFormToolsBackColor);
  end;
end;

procedure TxwParentForm.RefreshFace(var message: TMessage);
begin
  DoRefreshFace(Self);
end;

class procedure TxwParentForm.DoRefreshFace(Sender : TObject);
var i, j: integer;
  p: TComponent;
begin
  //if ExistForm.XwColorManiData1.ColorTeam<0 then Exit;
  if GetXwColorMainData.ColorTeam < 0 then
    Exit;

  p := TComponent(Sender);
  if (Sender is TForm) then TForm(Sender).Color := GetSystemColor(SysBackColor);
  for i := 0 to p.ComponentCount - 1 do
  begin
    if (p.Components[i] is TXwBandGrid) then
      RefreshGrid(p.Components[i])
    else if (p.Components[i] is TxwReport) then
    begin
      for j := 0 to p.Components[I].ComponentCount - 1 do
      begin
        if (p.Components[i].Components[j] is TXWBitbtn) then
          RefreshBitBtn(p.Components[i].Components[j])
        else if (p.Components[i].Components[j] is TPanel) then
          RefreshPanel(p.Components[i].Components[j])
        else if (p.Components[i].Components[j] is TXwBandGrid) then
          RefreshGrid(p.Components[i].Components[j]);
      end;
    end
    else if (p.Components[i] is TXWLabelBtnEdit) then
      RefreshLabelBtnEdit(p.Components[i])
    else if (p.Components[i] is TXWEmptyDate) then
      RefreshEmptyDate(p.Components[i])
    else if (p.Components[i] is TXWLabelLabel) then
      RefreshLabelLabel(p.Components[i])
    else if (p.Components[i] is TXWBitbtn) then
      RefreshBitBtn(p.Components[i])
    else if (p.Components[i] is TXwMenuBtn) then
      RefreshMenuBtn(p.Components[i])
    else if (p.Components[i] is TStatusBar) then
      RefreshStatusBar(p.Components[i])
    else if (p.Components[i] is TPanel) then
      RefreshPanel(p.Components[i])
    else if (p.Components[I] is TStringGrid) then
      RefreshStringGrid(p.Components[I])
    else if (p.Components[i] is TCheckBox) then
      RefreshCheckBox(p.Components[I])
    else if (p.Components[i] is TCheckListBox) then
      RefreshCheckListBox(p.Components[I])
    else if (p.Components[i] is TRadioGroup) then
      RefreshRadioGroup(p.Components[I])
    else if (p.Components[i] is TGroupBox) then
      RefreshGroupBox(p.Components[i])
    else if (p.Components[i] is TSplitter) then
      RefreshSplitter(p.Components[i])
    else if (p.Components[i] is TMemo) then
      RefreshMemo(p.Components[i])
    else if (p.Components[i] is TPageControl) then
      RefreshPageControl(p.Components[i])
    else if (p.Components[i] is TEdit) then
      RefreshEdit(p.Components[i])
    else if (p.Components[i] is TXwAlignGrid) then
      InitAlignGrid(p.Components[i])
    else if (p.Components[I] is TxwMenusSetter) then
    begin
      for j := 0 to p.Components[I].ComponentCount - 1 do
      begin
        if (p.Components[i].Components[j] is TXWBitbtn) then
          RefreshBitBtn(p.Components[i].Components[j])
        else if (p.Components[i].Components[j] is TPanel) then
          RefreshPanel(p.Components[i].Components[j]);
      end;
    end
    else if (p.Components[I] is TFenbubiaoGridGroup)
            or (p.Components[i] is  TXwLayoutInterfaceClass)  then
    begin
      for j := 0 to p.Components[I].ComponentCount - 1 do
      begin
        if (p.Components[i].Components[j] is TXWBitbtn) then
          RefreshBitBtn(p.Components[i].Components[j])
        else if (p.Components[i].Components[j] is TPanel) then
          RefreshPanel(p.Components[i].Components[j])
        else if (p.Components[i].Components[j] is TXwBandGrid) then
          RefreshGrid(p.Components[i].Components[j]);
      end;
    end;
  end;
end;

procedure TxwParentForm.DoUpPreviousCom(Sender: TObject);
begin
  SelectNext(Sender as TWinControl, False, True);
end;

class procedure TxwParentForm.RefreshGrid(Comp: TComponent);
var cp : TXwBandGrid;
begin
  cp := TXwBandGrid(Comp);
  cp.ColorSetting.TitleColor := GetSystemColor(GridFixedRowBackColor);
  cp.ColorSetting.FixedColor := GetSystemColor(GridFixedColBackColor);
  cp.ColorSetting.Color := GetSystemColor(GridBackColor);
  cp.ColorSetting.RowDarkColor := GetSystemColor(GridDarkColor);
  cp.ColorSetting.RowLightColor := GetSystemColor(GridLightColor);
  cp.ColorSetting.RowSelectColor := GetSystemColor(GridRowHighLight);
  cp.ColorSetting.RowFocusColor := GetSystemColor(GridRowHighLight);
  cp.ColorSetting.FooterColor := GetSystemColor(GridHeJiRowColor);
  cp.DefaultRowHeight := GetSystemColor(GridRowHeight);
  SetSystemFont(cp.ColorSetting.TitleFont, fmGridHead);
  SetSystemFont(cp.ColorSetting.RowFont, fmGrid);
  SetSystemFont(cp.ColorSetting.FooterFont, fmTotalRow);
end;

class procedure TxwParentForm.RefreshLabelBtnEdit(Comp: TComponent);
var cp : TXWLabelBtnEdit;
begin
  cp := TXWLabelBtnEdit(Comp);
  if not cp.DevSetFace then
    cp.Color := GetSystemColor(SysBackColor);
  cp.FocusColor := GetSystemColor(MainFormToolsBackColor);
  SetSystemFont(cp.Font, fmEditor);
  if (Comp is TGLabelBtnEdit) and (TGLabelBtnEdit(Comp).CanModifyCaption) then
    SetSystemFontExceptColor(cp.EditLabel.Font, fmEditor)
  else
    SetSystemFont(cp.EditLabel.Font, fmEditor);
  cp.FocusColor := GetSystemColor(EditInputfocuscolor);
end;

class procedure TxwParentForm.RefreshMenuBtn(Comp: TComponent);
var
  cp: TXwMenuBtn;
  _Font: TFont;
begin
  cp := TXwMenuBtn(Comp);
  _Font:=cp.Font;
  SetSystemFont(_Font, fmBtn);
  cp.Font:=_Font;

//  if (GetXwColorMainData.BtnJpeg[xbsNormal]<>nil) and
//     (GetXwColorMainData.BtnJpeg[xbsNormal].Width>0) then
//    cp.BackGroundBmps[xbsNormal] := GetXwColorMainData.BtnJpeg[xbsNormal]
//  else if GetXwColorMainData.ColorDatas[BtnBackNoramlBmp]<0 then
//    cp.BackGroundBmps[xbsNormal] := nil
//  else if SysBtnBackNormal<>nil then
//    cp.BackGroundBmps[xbsNormal] := SysBtnBackNormal;
//
//  if (GetXwColorMainData.BtnJpeg[xbsMouseOver]<>nil) and
//     (GetXwColorMainData.BtnJpeg[xbsMouseOver].Width>0) then
//    cp.BackGroundBmps[xbsMouseOver] := GetXwColorMainData.BtnJpeg[xbsMouseOver]
//  else if GetXwColorMainData.ColorDatas[BtnBackMouseBmp]<0 then
//    cp.BackGroundBmps[xbsMouseOver] := nil
//  else if SysBtnBackMouseOver<>nil then
//    cp.BackGroundBmps[xbsMouseOver] := SysBtnBackMouseOver;

  if Comp is TXwPrintBtn then
  begin
    TXwPrintBtn(Comp).OnGetPrintInfo := DoPrintGetConfig; //ExistForm.GetConfig;
    TXwPrintBtn(Comp).OnSetPrintInfo := DoPrintSetCongfig; //ExistForm.SetCongfig;
  end
  else
  begin
//    cp.BackGroundBmps2[xbsNormal]:=cp.BackGroundBmps[xbsNormal];
//    cp.BackGroundBmps2[xbsMouseOver]:=cp.BackGroundBmps[xbsMouseOver];
  end;
end;

class procedure TxwParentForm.RefreshBitBtn(Comp: TComponent);
var
  cp: TXWBitbtn;
begin
  cp := TXWBitbtn(Comp);
  SetSystemFont(cp.Font, fmBtn);
//  if (ExistForm.XwColorManiData1.BtnJpeg[xbsNormal]<>nil) and
//     (ExistForm.XwColorManiData1.BtnJpeg[xbsNormal].Width>0) then
  if (GetXwColorMainData.BtnJpeg[xbsNormal]<>nil) and
     (GetXwColorMainData.BtnJpeg[xbsNormal].Width>0) then
    cp.BackGroundBmps[xbsNormal] := GetXwColorMainData.BtnJpeg[xbsNormal] //ExistForm.XwColorManiData1.BtnJpeg[xbsNormal]
  //else if ExistForm.XwColorManiData1.ColorDatas[BtnBackNoramlBmp]<0 then
  else if GetXwColorMainData.ColorDatas[BtnBackNoramlBmp]<0 then
    cp.BackGroundBmps[xbsNormal] := nil
  else if SysBtnBackNormal<>nil then
    cp.BackGroundBmps[xbsNormal] := SysBtnBackNormal;

//  if (ExistForm.XwColorManiData1.BtnJpeg[xbsMouseOver]<>nil) and
//     (ExistForm.XwColorManiData1.BtnJpeg[xbsMouseOver].Width>0) then
  if (GetXwColorMainData.BtnJpeg[xbsMouseOver]<>nil) and
     (GetXwColorMainData.BtnJpeg[xbsMouseOver].Width>0) then
    cp.BackGroundBmps[xbsMouseOver] := GetXwColorMainData.BtnJpeg[xbsMouseOver] //ExistForm.XwColorManiData1.BtnJpeg[xbsMouseOver]
  //else if ExistForm.XwColorManiData1.ColorDatas[BtnBackMouseBmp]<0 then
  else if GetXwColorMainData.ColorDatas[BtnBackMouseBmp]<0 then
    cp.BackGroundBmps[xbsMouseOver] := nil
  else if SysBtnBackMouseOver<>nil then
    cp.BackGroundBmps[xbsMouseOver] := SysBtnBackMouseOver;
end;

class procedure TxwParentForm.RefreshStringGrid(Comp: TComponent);
var cp: TStringGrid;
begin
  cp := TStringGrid(Comp);
  cp.FixedColor := GetSystemColor(GridFixedColBackColor);
  cp.Color := GetSystemColor(GridBackColor);
  SetSystemFont(cp.Font, fmGrid);
end;

class procedure TxwParentForm.RefreshPanel(Comp: TComponent);
var cp: TPanel;
begin
  cp := TPanel(Comp);
  if comp is TxwGridToolsPanel then Exit;
  if (Comp is TXwPanel) and TXwPanel(Comp).DevSetFace then Exit;
  cp.Color := GetSystemColor(SysBackColor);
  SetSystemFont(cp.Font, fmEditor);
  DoRefreshFace(Comp);
end;

procedure TxwParentForm.DoXWFormShow(Sender: TComponent);
begin

end;

class procedure TxwParentForm.RefreshCheckBox(Comp: TComponent);
var cp: TCheckBox;
begin
  cp := TCheckBox(Comp);
  cp.Color := GetSystemColor(SysBackColor);
  SetSystemFont(cp.Font, fmEditor);
end;

class procedure TxwParentForm.RefreshGroupBox(Comp: TComponent);
var cp: TGroupBox;
begin
  cp := nil;
  if (Comp is TXwGroupBox) and TXwGroupBox(cp).DevSetFace then Exit;
  cp := TGroupBox(Comp);
  cp.Color := GetSystemColor(SysBackColor);
  SetSystemFont(cp.Font, fmEditor);
end;

class procedure TxwParentForm.RefreshCheckListBox(Comp: TComponent);
var cp: TCheckListBox;
begin
  cp := TCheckListBox(Comp);
  cp.Color := GetSystemColor(SysBackColor);
  SetSystemFont(cp.Font, fmEditor);
end;

class procedure TxwParentForm.RefreshRadioGroup(Comp: TComponent);
var cp: TRadioGroup;
begin
  cp := TRadioGroup(Comp);
  cp.Color := GetSystemColor(SysBackColor);
  SetSystemFont(cp.Font, fmEditor);
end;

class procedure TxwParentForm.RefreshEmptyDate(Comp: TComponent);
var cp : TXWLabelEmptyDate;
begin
  cp := TXWLabelEmptyDate(Comp);
  SetSystemFontExceptColor(cp.LabelFont, fmEditor);
  cp.FocusColor := GetSystemColor(GridFixedRowBackColor);
  cp.SetInnerColor(clWhite);
end;

class procedure TxwParentForm.RefreshLabelLabel(Comp: TComponent);
var cp : TXWLabelLabel;
begin
  cp := TXWLabelLabel(Comp);
  if not cp.DevSetFace then
    SetSystemFont(cp.Font, fmEditor);
end;

class procedure TxwParentForm.RefreshStatusBar(Comp: TComponent);
begin
  TXwStatusBar(Comp).Color := GetSystemColor(MainFormToolsBackColor);
end;

class procedure TxwParentForm.RefreshSplitter(Comp: TComponent);
var cp: TSplitter;
begin
  cp := TSplitter(Comp);
  cp.Color := GetSystemColor(SysBackColor);
end;


class procedure TxwParentForm.RefreshLabel(Comp: TComponent);
var cp : TLabel;
begin
  cp := TLabel(Comp);
  SetSystemFont(cp.Font, fmEditor);
end;

class procedure TxwParentForm.RefreshMemo(Comp: TComponent);
var cp : TMemo;
begin
  cp := TMemo(Comp);
  SetSystemFont(cp.Font, fmEditor);
  cp.Color := GetSystemColor(SysBackColor);
end;

class procedure TxwParentForm.RefreshPageControl(Comp: TComponent);
var cp : TPageControl;
    i:integer;
begin
  cp:= TPageControl(Comp);
  SetSystemFont(cp.Font,fmEditor);
//  cp.OwnerDraw:=True;   与TWebBrowser冲突。
  for i:=0 to cp.PageCount -1 do
  begin
    DoRefreshFace(cp.Pages[i]);
  end;
end;

procedure TxwParentForm.RefreshGridRelate(var message: TMessage);
var i : integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TXwBandGrid) then
    begin
      TXwBandGrid(Components[i]).ReloadRelates;
    end;
  end;
end;

procedure TxwParentForm.RefreshRelateFuncs(var msg: TMessage);
var i : integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TGLabelBtnEdit) then
    begin
      if TGLabelBtnEdit(Components[i]).ControlNo<>msg.WParam then Continue;
      SendMessage(TGLabelBtnEdit(Components[i]).Handle, RELATE_FUNC_REFRESH, msg.WParam, 0);
    end;
  end;
end;

class procedure TxwParentForm.RefreshEdit(Comp: TComponent);
var cp : TEdit;
begin
  cp := TEdit(Comp);
  cp.Color := GetSystemColor(SysBackColor);
//  cp.FocusColor := GetSystemColor(MainFormToolsBackColor);
  SetSystemFont(cp.Font, fmEditor);
end;

procedure TxwParentForm.SendTreeRefreshMsg(ABasicTypeOrd: Integer);
var i, nCount: integer;
  hwn : HWND;
begin
  with Application.MainForm do
  begin
    nCount := MDIChildCount;
    for i := 0 to nCount - 1 do
    begin
      hwn := MDIChildren[i].Handle;
      sendmessage(hwn, REFRESH_TREEVIEW_FORM, ABasicTypeOrd, 0);
    end;
  end;
end;

procedure TxwParentForm.SendTreeSortMsg(ABasicTypeOrd: Integer);
var i, nCount: integer;
  hwn : HWND;
begin
  with Application.MainForm do
  begin
    nCount := MDIChildCount;
    for i := 0 to nCount - 1 do
    begin
      hwn := MDIChildren[i].Handle;
      sendmessage(hwn, SORT_TREEVIEW_FORM, ABasicTypeOrd, 0);
    end;
  end;
end;

procedure TxwParentForm.InitGLabelCheckBox(Comp: TComponent);
var cp: TGCheckBoxInner;
begin
  cp := TGCheckBoxInner(Comp);
  cp.BasicRecord := GetBasicRecordAll_C; //ExistForm.BasicRecordAll_C1;
  //if ExistForm.XwColorManiData1.ColorTeam>0 then
  if GetXwColorMainData.ColorTeam > 0 then
  begin
    cp.FocusColor :=  GetSystemColor(EditInputfocuscolor);
  end;
  cp.FuncRelateHandler := GetXwFuncRelateHandler; //ExistForm.xwFuncRelateHandler1;
  //cp.OnReturnNextCom := DoReturnNextCom;
end;


procedure TxwParentForm.AfterSetParamList;
begin

end;

procedure TxwParentForm.DoXwLogAdd(AXwLog: TxwChangeLog);
begin
  XwLogAdd(AXwLog);
end;

procedure TxwParentForm.DoXwLogLoad(AVchcode, AGroupID: Integer; AControlName: string; var ADataSet: TClientDataSet; AUseClassName: String);
begin
  XwLogLoad(AVchcode, AGroupID, AControlName, ADataSet, AUseClassName);
end;

class procedure TxwParentForm.DoPrintGetConfig(APrintID: Integer; var APrintConfig: TPrintConfig);
begin
  GetConfig(APrintID, APrintConfig);
end;

class procedure TxwParentForm.DoPrintSetCongfig(APrintID: Integer; APrintConfig: TPrintConfig);
begin
  SetCongfig(APrintID, APrintConfig);
end;

end.
