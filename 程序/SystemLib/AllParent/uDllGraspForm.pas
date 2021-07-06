unit uDllGraspForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uBasalMethod, xwbasiccomponent, xwBasicinfoComponent, Generics.Collections,
  xwgridsclass, xwVchGrid, ActnList, Menus, DBClient,
  ComCtrls, XwGjpBasicCom, XWCBasicCom, XwGGeneralWGrid, XwGGeneralGrid, CheckLst,
  XWComponentType, uDllDataBaseIntf, uDllDBService, xwtypedefine, uTransformFunc,
  uOperationFunc, xwgtypedefine, CMFenBuBiaoGrid,
  xwBasicDataLocal, xwbasicinfoclassdefine_c, xwParentFormUnit, ugpDbDefines,
  uExtImage, uCMColorCommon, ExtCtrls, ShadowPanel, XwTable, StdCtrls, XwAligrid,
  xwgridsfenbubiao, XwChart, Chart, XwGClass, XwExpress, Clipbrd, ugpdbgrids,
  Grids, uCMEventHander, uDataStructure, ControlsCommon,
  ugpStdGrids, xwGFunc, uGraspFormIntf;

const
  DisableSkinTag = 99;

type
  // 单元类型
  TUnitType = (utJxc, utCW);

  TDllGraspForm = class(TxwParentForm, IGraspForm)
    CMEventHandler: TCMEventHandler;
    imgPrintButton: TImage;
    imgArrowDown: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
  private
    { Private declarations }
    FVersion: String;
    FActControl: TWinControl;

    FFunctionNo: Integer;
    FFunctionNoDetail: string;

    FPrintName: string;
    FIsFormInit: Boolean;
    FUnitType: TUnitType;
    FCMGridTwoColorType: Integer; // 0：表格使用双色  1：表格使用亮行色  2：表格使用暗行色

    FHelpButtonVisible: Boolean;

    FCMSysColor: TGraspColorTypeConfig;
    function ShowAssistantQty: Boolean;
    procedure SetToolBarOnce;
    procedure ToolBarCustomDrawButton(Sender: TToolBar; Button: TToolButton; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure SetButtonsLimit;
    function GetOnBeforeSelectBaseInfo: TSelectBaseInfoEvent;
    function GetOnAfterSelectBaseInfo: TAfterSelectBaseInfoEvent;
    function GetOnVchAfterSelectBaseInfo: TAfterSelectBaseInfoEvent;
    // procedure DrawControlBorder(WinControl: TWinControl; BorderColor: TColor);
  protected
    { Protected declarations }
    // 字符串,当前模块是否要对某个按钮进行权限控制  位置是按钮类型的下标,1表示本窗口需要对此按钮进行权限控制
    FLimitList: string;
    // 当前模块的按钮是否有权限  位置是按钮类型的下标  是布尔型
    FDetailLimit: array [ Low(TCMBtnType) .. High(TCMBtnType)] of Boolean;
    FFunctionName: string;
    FHelpName: string;

    FParamsLModeStr: String; // 对应btlMode
    FParamsCModeStr: String; // 对应btcMode
    FParamsCTypeStr: String; // 对应btcType

    // imageList
    imgList2: TImageList;
    ilCondBox: TImageList;

    FOnBeforeSelectBaseInfo: TSelectBaseInfoEvent;
    FOnAfterSelectBaseInfo: TAfterSelectBaseInfoEvent;
    FOnVchAfterSelectBaseInfo: TAfterSelectBaseInfoEvent;

    function GetComponentProperty: Boolean;
    function SetComponentProperty: Boolean; virtual;
    function GetBasicFieldName(ABasicType: TBasicType): TFieldsList;
    function GetBasicValue(ABasicType: TCMBasicType; AValue: string): string;
    function GetXIWABasicValue(ABasicType: TBasicType; TypeID: string): string;
    function GetXIWALabelBasicValue(ABasicType: TBasicType; TypeID: string; AField: TFieldsList): string;
    function GetCMBasicLocalValue(ABasicType: TBasicType; flField: TFieldsList; TypeID: string): string;
    function GetCMBasicLocalValueByRec(ABasicType: TBasicType; flField: TFieldsList; nRec: Integer): string;
    function GetCMBasicLocalCaption(flField: TFieldsList): string;
    function GetCMBasicLocalBaseCaption(flField: TFieldsList; DefaultCaption: string = ''): string;
    function GetCMBasicLocalDataBaseName(flField: TFieldsList): string;
    function GetVchTypeName(TypeID: string; ShowAllBill: Boolean): string;
    function GetOTypeName(Rec: string): string;
    function CheckPrintRight: Boolean;
    function GetImageDataSet: TClientDataSet; virtual;
    function GetBaseSelectParam: TBaseSelectParam; virtual;

    // 装入全部数据
    procedure LoadData; virtual; // abstract;
    procedure InitializationForm; virtual;
    procedure RefreshVclSkinControl(AControl: TWinControl = nil);
    // 执行选择基本信息的动作
    procedure SelectBaseInfo(Sender: TObject; szMode: string; var Modifyed: Boolean); virtual; // 提取基本信息

    procedure SetFunctionNo(const Value: Integer); virtual;
    procedure SetPrintName(const Value: string); virtual;
    procedure UserDefinedSelectBasic(Sender: TObject; szMode: String; var Modifyed: Boolean); virtual;
    procedure BillNumberSelectBasic(Sender: TObject; szMode: String; var Modifyed: Boolean); virtual;

    // 执行在FHelpName中的帮助文件内容
    procedure ShowOneHelp(Sender: TObject); virtual;
    // 装入除表格外的其它数据
    procedure LoadTitleData; virtual;
    procedure DoXwFormShow(Sender: TObject); virtual;
    procedure SetComponentsStyleCMSQ(AComponent: TComponent); virtual;
    // 打印接口
//    procedure DoPrint(Sender: TObject); virtual;
//    procedure Print(szRwxFile: string = ''; acMode: Char = 'P'); virtual;
//    procedure PrintLoadSysTitle(var j: Integer; var TitleArray: array of TTable_b); virtual;
//    procedure PrintLoadTitleData(var j: Integer; var TitleArray: array of TTable_b; szRwxFile: string = ''); virtual;
//    procedure PrintLoadGridData; virtual;
    procedure DoGeneralGridFenBuPrint(Sender: TObject); virtual;
    procedure DoGeneralWGridFenBuPrint(Sender: TObject); virtual;
    // 打印设置
    procedure PrinterSetup(szRwxFile: string = ''); virtual;
    property FunctionNoDetail: string read FFunctionNoDetail write FFunctionNoDetail;
    property FunctionNo: Integer read FFunctionNo write SetFunctionNo;
    property FunctionName: string read FFunctionName write FFunctionName;
    procedure SelectNextCom(Sender: TObject); virtual;
    // 定义虚方法，在状态条中显示帮助，其实现在子类中
    procedure GjpHint(Sender: TObject); virtual;
    // 定义虚方法，在状态条中显示帮助，其实现在子类中
    procedure ToolBtnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer); virtual;
    // 定义虚方法，将部分基本信息组合成一条信息显示
    procedure DoFrameWork(Sender: TObject); virtual;
    // 定义Tabcontrol, pagecontrol的tab自画方法
    procedure TabControlDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure PageControlDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure EnterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;

    procedure AfterSelectBaseInfo(Sender: TObject; BaseArray: TCMBaseArray); virtual;
    procedure BeforeSelectBaseInfo(Sender: TObject; var ABaseType: TCMBaseInfoType; var szSearchType: Char;
      var szSearchString, szKTypeID, szAssistant1, szAssistant2: string; var ASubjectType: TCMSubjectType; var ASelectOptions: TCMBaseSelectOptions;
      var ContinueProc: Boolean); virtual;

    procedure BeforeSetDateStr(Sender: TObject);
    procedure AfterSetDateStr(Sender: TObject);
    procedure SetGridRefreshClick(AGrid: TXwBandGrid);
    procedure LoadConfig; virtual;

    // 导出到Excel接口
//    procedure ExporttoExcel(szRwxFile: string = ''); virtual;
//    procedure DoExporttoExcel(Sender: TObject); virtual;
    procedure DoGetGeneralGridExcelData(Sender: TObject; var ADetailData: OLEVariant); virtual;
    procedure DoGetGeneralWGridExcelData(Sender: TObject; var ADetailData: OLEVariant); virtual;
    procedure SetGridProperty(GeneralGrid: TXwGGeneralGrid); virtual;
    procedure SetWGridProperty(GeneralWGrid: TXwGGeneralWGrid); virtual;
    procedure AfterGridSet; virtual;
    procedure AfterGraspCMSetAction; virtual;
    procedure AfterParentLabelSet; virtual;
    procedure AfterToolButtonSet; virtual;
    procedure SetToolMenuButtonPicture(AControl: TControl;ABitmap: TBitmap); virtual;
    procedure SetCMToolMenuBtn(ABtn: TCMToolMenuBtn);

    ///表格默认显示列
    procedure SetDefaultShowColumns(AGrid: TXwGGeneralGrid; AFieldNames: string); overload; virtual;
    procedure SetDefaultShowBaseColumn(AGrid: TXwGGeneralGrid; AFieldNames: string); overload; virtual;
    procedure SetDefaultShowColumns(AGrid: TXwGGeneralWGrid; AFieldNames: string); overload; virtual;
    procedure SetDefaultShowBaseColumn(AGrid: TXwGGeneralWGrid; AFieldNames: string); overload; virtual;

    property CMSysColor: TGraspColorTypeConfig read FCMSysColor write FCMSysColor;
  public
    { Public declarations }
    Params: Variant;
    constructor Create(AOwner: TComponent); override;
    constructor CreateByParams(AOwner: TComponent; AParamType: array of TCMBasicType; AParamValue: array of OLEVariant); virtual;
    destructor Destroy; override;
    class function GetCMBasicLocalValueByString(ABasicType: TBasicType; flField: TFieldsList; TypeID: string): string;
    class function GetCMBasicLocalValueByInt(ABasicType: TBasicType; flField: TFieldsList; TypeID: string): Integer;
    class function GetCMBasicLocalValueByDouble(ABasicType: TBasicType; flField: TFieldsList; TypeID: string): Integer;

    property IsFormInit: Boolean read FIsFormInit;
    property ShowAssistantQtyTotal: Boolean read ShowAssistantQty;
  published
    { Published declarations }
    property OnBeforeSelectBaseInfo: TSelectBaseInfoEvent read FOnBeforeSelectBaseInfo write FOnBeforeSelectBaseInfo;
    property OnAfterSelectBaseInfo: TAfterSelectBaseInfoEvent read FOnAfterSelectBaseInfo write FOnAfterSelectBaseInfo;
    property OnVchAfterSelectBaseInfo: TAfterSelectBaseInfoEvent read FOnVchAfterSelectBaseInfo write FOnVchAfterSelectBaseInfo;
    property AVersion: String read FVersion;
    property UnitType: TUnitType read FUnitType write FUnitType;
    property HelpName: string read FHelpName write FHelpName;
    property PrintName: string read FPrintName write SetPrintName;
    property LimitList: string read FLimitList write FLimitList;
    property CMGridTwoColorType: Integer read FCMGridTwoColorType write FCMGridTwoColorType;
    property HelpButtonVisible: Boolean read FHelpButtonVisible write FHelpButtonVisible;
  end;

  TPrintHandler = class
  private
    FOwnerForm: TDllGraspForm;
    FPrintID: Integer;
    FPrintTemplate: string;
    FPrintButton: TCMXwPrintBtn;
    FBeforePrint, FBeforePrintMenu, FCMBeforePrintMenu: TNotifyEvent;
    FBeforePrintPopmenu: TNotifyEvent;
    FCMBeforePrintPopmenu: TNotifyEvent;
    FCMBeforePrint, FAfterPrint, FCMAfterPrint, FSelfOldPrint: TNotifyEvent;
    FAfterLoadPrintHeader: TAfterLoadPrintHeaderEvent;
    FSelfLoadPrintTitle, FSelfLoadPrintGrid, FSetPrintIdAndTemplateName: TNotifyEvent;
    function GetPrintID: Integer;
    function GetPrintTemplate: string;
    procedure SetPrintID(const Value: Integer);
    procedure SetPrintTemplate(const Value: string);
    procedure DoBeforePrint(Sender: TObject);
    procedure DoBeforePrintPopmenu(Sender: TObject);
    procedure DoBeforePrintMenu(Sender: TObject);
    procedure DoAfterPrint(Sender: TObject);
    procedure LoadPrintHeadData(AForm: TDllGraspForm; var APrintButton: TCMXwPrintBtn);
    procedure LoadPrintGridData(AForm: TDllGraspForm; var APrintButton: TCMXwPrintBtn);
  public
    constructor Create(AOwner: TDllGraspForm; APrintButton: TCMXwPrintBtn);
    property PrintID: Integer read GetPrintID write SetPrintID;
    property PrintTemplate: string read GetPrintTemplate write SetPrintTemplate;
    property CMBeforePrintMenu: TNotifyEvent read FCMBeforePrintMenu write FCMBeforePrintMenu;
    property BeforePrintPopmenu: TNotifyEvent read FBeforePrintPopmenu write FBeforePrintPopmenu;
    property CMBeforePrintPopmenu: TNotifyEvent read FCMBeforePrintPopmenu write FCMBeforePrintPopmenu;
    property CMBeforePrint: TNotifyEvent read FCMBeforePrint write FCMBeforePrint;
    property CMAfterPrint: TNotifyEvent read FCMAfterPrint write FCMAfterPrint;
    property AfterLoadPrintHeader: TAfterLoadPrintHeaderEvent read FAfterLoadPrintHeader write FAfterLoadPrintHeader;
    property SelfLoadPrintTitle: TNotifyEvent read FSelfLoadPrintTitle write FSelfLoadPrintTitle;
    property SelfLoadPrintGrid: TNotifyEvent read FSelfLoadPrintGrid write FSelfLoadPrintGrid;
    property SetPrintIdAndTemplateName: TNotifyEvent read FSetPrintIdAndTemplateName write FSetPrintIdAndTemplateName;
    property SelfOldPrint: TNotifyEvent read FSelfOldPrint write FSelfOldPrint;
  end;

implementation

uses {uBaseSelect,} uDllMessageIntf, uDllPrintdata, {uMain,} // uUserDefinedSet, uBillNumberSet,
  uDllComm, uDllExistIntf, uDllBaseSelect, uDllSystemIntf;

{$R *.dfm}

procedure TDllGraspForm.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  sText: string;
  C: Char;
begin
  inherited;
  if (GetKeyState(VK_CONTROL) < 0) and (Msg.CharCode = Ord('V')) and
    ((ActiveControl is TXwGGeneralWGrid) or ((ActiveControl.Parent <> nil) and (ActiveControl.Parent is TCMGLabelBtnEdit))) then // 按了Ctrl+V建
  begin
    if (ActiveControl.Parent is TCMGLabelBtnEdit) then
    begin
      if (ActiveControl as TXWDatatypeEdit).ReadOnly then
      begin
        Handled := True;
        Exit;
      end;
    end;

    sText := Clipboard.AsText;
    for C in sText do
    begin
      if CharInSet(C, InValidChars) then
      begin
        Handled := True;
        Exit;
      end;
    end;
  end;
end;

procedure TDllGraspForm.FormShow(Sender: TObject);
begin
  inherited;

  if (FunctionNo <> 0) and (FLimitList = '') then
  begin
    // 字符串,当前模块是否要对某个按钮进行权限控制  位置是按钮类型的下标,1表示本窗口需要对此按钮进行权限控制
    FLimitList := CheckLimitNo(FunctionNo);
    // 字符串,当前模块的按钮是否有权限  位置是按钮类型的下标  是布尔型
    GetFunctionDetailLimitNo(FunctionNo, FDetailLimit);
  end;

  InitializationForm;
  RefreshVclSkinControl;
  SetToolBarOnce;
end;

function TDllGraspForm.GetComponentProperty: Boolean;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do // Iterate
  begin
    case StringIndex(Components[I].ClassName, C_CLASS_NAMES) of //
      - 1:
        Continue;
      Ord(cnTLabelLabel):
        with TCMGXwLabelLabel(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;
          if CMBasicType in CMBaseBasicType then
            Params[Ord(CMBasicType)] := CMTypeID
          else
            Params[Ord(CMBasicType)] := LabelText;
        end;
      Ord(cnTLabelMemo):
        with TCMGLabelMemo(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;
          if CMBasicType in CMBaseBasicType then
            Params[Ord(CMBasicType)] := TypeID
          else
            Params[Ord(CMBasicType)] := Lines.Text;
        end;
      Ord(cnTLabelComboBox):
        with TCMGLabelComBox(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;

          Params[Ord(CMBasicType)] := ItemIndex;

          if CMBasicType in [CMbtPeriod, CMbtPeriodBegin, CMbtPeriodEnd] then
          begin
            if ItemIndex = 0 then // 如果选择为本期，则取当前期间值
            begin
              if UnitType = utJxc then
                Params[Ord(CMBasicType)] := GetJxcPeriod
              else
                Params[Ord(CMBasicType)] := GetPeriod;
            end;
          end;
        end;
      Ord(cnTLabelBtnEdit):
        with TCMGLabelBtnEdit(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;

          if CMBasicType = CMbtOperatingType then
            Params[Ord(CMbtAssThree)] := Rec;
          if CMBasicType = CMbtPMtype then
            Params[Ord(CMbtTrueStock)] := Rec;

          if (CMBasicType in CMBaseBasicType) then
          begin
            if CMBasicType = CMbtVchType then
            begin
              Params[Ord(CMbtAssFour)] := TypeID;
              Params[Ord(CMBasicType)] := IntToStr(Rec);
            end
            else if CMBasicType = CMbtOperator then
              Params[Ord(CMBasicType)] := Text
            else
              Params[Ord(CMBasicType)] := TypeID;
          end
          else if CMBasicType in [CMbtDeviceTool, CMbtMaintainItem] then
          begin
            Params[Ord(CMBasicType)] := Text;
            Params[Ord(CMBasicType) + 1] := CMRec;
          end
          else if CMBasicType in [CMbtPluginBaseInfo1..CMbtPluginBaseInfo5] then
          begin
            Params[Ord(CMBasicType)] := Text;
            if CMBasicType = CMbtPluginBaseInfo1 then
              Params[Ord(CMbtPluginBaseInfoRec1)] := CMRec
            else if CMBasicType = CMbtPluginBaseInfo2 then
              Params[Ord(CMbtPluginBaseInfoRec2)] := CMRec
            else if CMBasicType = CMbtPluginBaseInfo3 then
              Params[Ord(CMbtPluginBaseInfoRec3)] := CMRec
            else if CMBasicType = CMbtPluginBaseInfo4 then
              Params[Ord(CMbtPluginBaseInfoRec4)] := CMRec
            else if CMBasicType = CMbtPluginBaseInfo5 then
              Params[Ord(CMbtPluginBaseInfoRec5)] := CMRec;
          end
          else
            Params[Ord(CMBasicType)] := Text;
        end;
      Ord(cnTGCheckBox):
        with TCMGXwChcekBox(Components[I]) do
        begin
          DoubleBuffered := True;
          if CMBasicType = CMbtNo then
            Continue;

          if Checked then
            Params[Ord(CMBasicType)] := 1
          else
            Params[Ord(CMBasicType)] := 0;
        end; // with
      Ord(cnTLabelEmptyDate):
        with TCMGLabelEmptyDate(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;
          Params[Ord(CMBasicType)] := FormatDateTime('yyyy-MM-dd', Date);
        end;
      Ord(cnTQueryDate):
        with TCMGLabelQueryDate(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;
          Params[Ord(CMBasicType)] := FormatDateTime('yyyy-MM-dd', Date);
        end;
      // Ord(cnTGeneralGrid):
      // with TXwGGeneralGrid(Components[I]) do
      // begin
      // //NoteToFile();
      // end;
      // Ord(cnTGeneralWGrid):
      // with TXwGGeneralWGrid(Components[I]) do
      // begin
      // //NoteToFile();
      // end;
      Ord(cnTGRadioButton):
        with TCMGRadioButton(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;
          if Checked then
            Params[Ord(CMBasicType)] := Tag;
        end;
      Ord(cnTLabelValueComboBox):
        with TCMGLabelValueComBox(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;

          if ItemIndex >= 0 then
            Params[Ord(CMBasicType)] := ValueForItem(ItemIndex)
          else
            Params[Ord(CMBasicType)] := '';
        end;
      Ord(cnTLabelClearDate):
        with TCMGLabelClearDate(Components[I]) do
        begin
          if CMBasicType = CMbtNo then
            Continue;
          Params[Ord(CMBasicType)] := DateStr;
        end;
    end; // case
  end; // for
  Result := True;
end;

procedure TDllGraspForm.SetCMToolMenuBtn(ABtn: TCMToolMenuBtn);
begin
  with ABtn do
  begin
    MenuButtonGlyph.Assign(imgArrowDown.Picture.Graphic);
    if Parent is TToolBar then
    begin
      SetColor($007D6857);
      Width := TToolBar(Parent).ButtonWidth;
    end;
    SetToolMenuButtonPicture(ABtn, ButtonGlyph);
  end;
end;

function TDllGraspForm.SetComponentProperty: Boolean;
var
  RadioButtonCount, CheckBoxCount: Integer;
  I: Integer;
  tempStr: string;

  procedure SetCMGxwLabelLabel(cmgXwLabel: TCMGXwLabelLabel);
  begin
    with cmgXwLabel do
    begin
      Color := CMSysColor.CMFaceBackColor;

      OnAfterChange := DoFrameWork;
      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          LabelCaption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          LabelCaption := LabelCaption;
      end
      else
        LabelCaption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      if CMBasicType = CMbtNo then
        Exit;

      if not VarIsNull(Params[Ord(CMBasicType)]) then
      begin
        if CMBasicType in CMBaseBasicType then
        begin
          CMTypeID := Params[Ord(CMBasicType)];
          if CMBasicType = CMbtOperatingType then
          begin
            tempStr := Params[Ord(CMbtAssThree)];

            LabelText := GetOTypeName(tempStr);
          end
          else if CMBasicType = CMbtPMtype then
          begin
            tempStr := Params[Ord(CMbtTrueStock)];

            LabelText := GetOTypeName(tempStr);
          end
          else if CMBasicType = CMbtVchType then
          begin
            LabelText := GetVchTypeName(CMTypeID, CMShowAllBill);
          end
          else if CMBasicType = CMbtOperator then
            LabelText := Params[Ord(CMBasicType)]
          else
            LabelText := GetXIWALabelBasicValue(BasicType, CMTypeID, FieldsList);
        end
        else if CMBasicType = CMbtLMode then
        begin
          LabelText := FParamsLModeStr;
        end
        else if CMBasicType = CMbtcMode then
        begin
          LabelText := FParamsCModeStr;
        end
        else if CMBasicType = CMbtcType then
        begin
          LabelText := FParamsCTypeStr;
        end
        else if CMBasicType = CMbtPeriod then
        begin
          if (Trim(Params[Ord(CMBasicType)]) <> '') and (Trim(Params[Ord(CMBasicType)]) <> '0') then
            //LabelText := GetSimplePeriodCaption(Params[Ord(CMBasicType)])
          else
            LabelText := Params[Ord(CMBasicType)];
        end
        else if CMBasicType in [CMbtPeriodBegin, CMbtPeriodEnd] then
        begin
          if (Trim(Params[Ord(CMBasicType)]) <> '') and (Trim(Params[Ord(CMBasicType)]) <> '0') then
            //LabelText := GetSimplePeriodCaption(Params[Ord(CMBasicType)])
          else
            LabelText := Params[Ord(CMBasicType)];
        end
        else
        begin
          LabelText := Params[Ord(CMBasicType)];
        end;
      end;
    end; // with
  end;

  procedure SetLabelMemo(labelMemo: TCMGLabelMemo);
  begin
    with labelMemo do
    begin
      OnHintEvent := GjpHint;
      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      if CMBasicType = CMbtNo then
        Exit;

      ImeName := '';
    end; // with
  end;

  procedure SetLabelComboBox(labelComboBox: TCMGLabelComBox);
  begin
    with labelComboBox do
    begin
      OnHintEvent := GjpHint;
      OnKeyDown := EnterKeyDown;

      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      if CMBasicType = CMbtNo then
        Exit;

      ImeName := '';

      if not VarIsNull(Params[Ord(CMBasicType)]) and not VarIsEmpty(Params[Ord(CMBasicType)]) then
      begin
        ItemIndex := Params[Ord(CMBasicType)];
      end;
    end; // with
  end;

  procedure SetLabelBtnEdit(labelBtnEdit: TCMGLabelBtnEdit);
  var
    nSpace: Integer;
  begin
    with labelBtnEdit do
    begin
      if LabelSpacing <> 0 then
      begin
        nSpace := LabelSpacing;
        MustCharLen(nSpace);
        LabelSpacing := 0;
      end;
      Color := CMSysColor.CMFaceBackColor;

      if not CMSelfFocusColor then
        FocusColor := CMSysColor.CMEditInputFocusColor;

      AllowBlank := True;
      CMOnChange := DoFrameWork;
      OnHintEvent := GjpHint;
      ReturnNextCom := False;

      if FDllParams.PubVersion3 <> 'XIWA' then
        CanModifyCaption := False;

      if BasicType in [btZFType, btZSType, btCustom3, btCustom4] then
        CanModifyCaption := False;

      if SameText(uOperationFunc.GetConfig('UseNotQuickSearch'), 'F') then
        UseQuickSearch := False;

      if not CanModifyCaption then
      begin
        if CMShowCustomCaption then
        begin
          if CMCustomCaptionNo <> 0 then
            Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
          else
            Caption := Caption;
        end
        else
          Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);
      end;

      if (CMDataType in [dtTotal, dtQty, dtDouble, dtInteger, dtPrice]) then
      begin
        case CMDataType of
          dtTotal:
            begin
              DataTypes.Digital := 2;
              DataTypes.ValueType := vtDouble;
              DataTypes.MaxValue := 100000000;
              DataTypes.MinValue := -100000000;
            end;
          dtQty:
            begin
              DataTypes.Digital := 4;
              DataTypes.ValueType := vtDouble;
              DataTypes.MaxValue := 100000000;
              DataTypes.MinValue := -100000000;
            end;
          dtInteger:
            begin
              DataTypes.ValueType := vtInteger;
            end;
          dtPrice:
            begin
              DataTypes.Digital := 4;
              DataTypes.ValueType := vtDouble;
              DataTypes.MaxValue := 100000000;
              DataTypes.MinValue := -100000000;
            end;
          dtDouble:
            begin
              DataTypes.Digital := CMDigits;
              DataTypes.ValueType := vtDouble;
            end;
        end;

        if (MaxLength = 0) or (MaxLength > 256) then
          MaxLength := 256;
        if (CMIsPlus) then
          // DataTypes.MinValue := 0.000000000001;
          DataTypes.Positive := True;

        if MinValue = 0 then
          MinValue := -100000000;
        if MaxValue = 0 then
          MaxValue := 100000000;
      end;

      CMOnSelectNextC := SelectNextCom;
      ImeName := '';

      if CMBasicType = CMbtNo then
        Exit;

      if not VarIsNull(Params[Ord(CMBasicType)]) then
      begin
        if CMBasicType in CMBaseBasicType then
        begin
          BasicDataLocalClass := GetBasicDataLocalClass; // ExistForm.GBasicDataLocalClass1;

          if (not(CMBasicType in [CMbtOperatingType, CMbtVchType])) then
          begin
            if (Params[Ord(CMBasicType)] <> null) and (Params[Ord(CMBasicType)] <> '') then
            begin
              TypeID := Params[Ord(CMBasicType)];
              FLastText := Text;
            end
            else if Params[Ord(CMBasicType)] = '' then
            begin
              TypeID := '';
              Text := '';
              FLastText := '';
            end;
          end;

          if CMBasicType = CMbtOperatingType then
          begin
            TypeID := Params[Ord(CMBasicType)];
            Rec := Params[Ord(CMbtAssThree)];
            FLastText := Text;
          end;

          if CMBasicType = CMbtPMtype then
          begin
            TypeID := Params[Ord(CMBasicType)];
            Rec := Params[Ord(CMbtTrueStock)];
            FLastText := Text;
          end;

          if CMBasicType = CMbtVchType then
          begin
            TypeID := Params[Ord(CMbtAssFour)];
            Rec := StringToInt(Params[Ord(CMBasicType)]);
            FLastText := Text;
          end;

          if CMBasicType = CMbtOperator then
          begin
            TypeID := Params[Ord(CMBasicType)];
            Text := Params[Ord(CMBasicType)];
            FLastText := Text;
          end;
        end
        else if CMBasicType in [CMbtPluginBaseInfo1..CMbtPluginBaseInfo5] then
        begin
          Text := Params[Ord(CMBasicType)];
          FLastText := Text;
          if CMBasicType = CMbtPluginBaseInfo1 then
            CMRec := Params[Ord(CMbtPluginBaseInfoRec1)]
          else if CMBasicType = CMbtPluginBaseInfo2 then
            CMRec := Params[Ord(CMbtPluginBaseInfoRec2)]
          else if CMBasicType = CMbtPluginBaseInfo3 then
            CMRec := Params[Ord(CMbtPluginBaseInfoRec3)]
          else if CMBasicType = CMbtPluginBaseInfo4 then
            CMRec := Params[Ord(CMbtPluginBaseInfoRec4)]
          else if CMBasicType = CMbtPluginBaseInfo5 then
            CMRec := Params[Ord(CMbtPluginBaseInfoRec5)];
        end
        else if CMBasicType in [CMbtDeviceTool, CMbtMaintainItem] then
        begin
          CMRec := StrToIntDef(Params[Ord(CMBasicType) + 1], 0) ;
          Text := Params[Ord(CMBasicType)];
          FLastText := Text;
        end
        else
        begin
          Text := Params[Ord(CMBasicType)];
        end;
      end;

      if CMRunSelectBase and ((CMBasicType in CMBaseBasicType) or (CMBasicType in [CMbtCustom3, CMbtCustom4])) or
        (CMBasicType in [CMbtPluginBaseInfo1..CMbtPluginBaseInfo5]) or
        (CMBasicType in [CMbtDeviceTool, CMbtMaintainItem]) then
      begin
        CMOnSelectBase := SelectBaseInfo;
      end;

      if (FDllParams.PubVersion2 <> 2680) and (FDllParams.PubVersion2 <> 880) then
      begin
        if CMRunSelectBase and (CMBasicType in [CMbtCustom22, CMbtCustom23, CMbtCustom24]) then
          CMOnSelectBase := UserDefinedSelectBasic;

        if CMRunSelectBase and (CMBasicType in [CMbtUserDefined01, CMbtUserDefined02, CMbtUserDefined03, CMbtUserDefined04, CMbtUserDefined05,
          CMbtUserDefined06, CMbtUserDefined07, CMbtUserDefined08, CMbtUserDefined09, CMbtUserDefined10]) then
          CMOnSelectBase := UserDefinedSelectBasic;
      end;

      if CMRunSelectBase and (CMBasicType in [CMbtBillNumber, CMbtBillNumber1, CMbtBillNumber2, CMbtBillNumber3]) then
      begin
        CMOnSelectBase := BillNumberSelectBasic;
      end;
    end; // with
  end;

  procedure SetBitBtn(bitBtn: TCMGXwBitbtn);
  begin
    with TCMGXwBitbtn(Components[I]) do
    begin
      OnHintEvent := GjpHint;
      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo));
      end
      else
        Caption := Trim(GetBtnType(CMBtnType).Caption);

      if (not CMShowCustomCaption) and (Trim(GetBtnType(CMBtnType).HotKey) <> '') and (Pos(Caption, '(&&') <= 0) then
        Caption := Caption + '(&' + GetBtnType(CMBtnType).HotKey + ')';

      if FDetailLimit[CMBtnType] then
        Visible := FLimitList[Ord(CMBtnType)] = '1';
      // 如果按钮的TAG=14，则不调用框架对Help的处理，而使用程序员的自定义方法。
      if (CMBtnType = gbtHelp) and (Tag <> Ord(gbtHelp)) then
        OnClick := ShowOneHelp;
//      else if (CMBtnType = gbtPrint) and (Tag <> Ord(gbtPrint)) then
//        OnClick := DoPrint
        // 处理导出至Excel   136由程序员自定义处理
//      else if (CMBtnType = gbttoExcel) and (Tag <> Ord(gbttoExcel)) then
//        OnClick := DoExporttoExcel;

      if CMBtnType = gbtHelp then
      begin
        Visible := FHelpButtonVisible;
        Enabled := FHelpButtonVisible;
      end;

      // 屏蔽老打印按钮
      if Tag = Ord(gbtPrint) then
      begin
        Visible := False;
        Enabled := False;
      end;
    end; // with
  end;

  procedure SetSpeedBtn(speedBtn: TCMGXwSpeedBtn);
  begin
    with speedBtn do
    begin
      OnHintEvent := GjpHint;

      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
      begin
        Caption := Trim(GetBtnType(CMBtnType).Caption);
        Hint := Caption;
      end;

      if CMBtnType = gbttoExcel then
//        OnClick := DoExporttoExcel
      else
      begin
        if CMBtnType = gbtHelp then
          OnClick := ShowOneHelp;

        if ShowIcon then
        begin
          if GetBtnType(CMBtnType).ImageIndex > 0 then
            GetImageList.GetBitmap(GetBtnType(CMBtnType).ImageIndex, Glyph);
        end
        else
          Glyph.FreeImage;
      end;

      if FDetailLimit[CMBtnType] then
        Visible := FLimitList[Ord(CMBtnType)] = '1';

      if CMBtnType = gbtHelp then
      begin
        Visible := FHelpButtonVisible;
        Enabled := FHelpButtonVisible;
      end;

      // 屏蔽老打印按钮
      if Tag = Ord(gbtPrint) then
      begin
        Visible := False;
        Enabled := False;
      end;
    end; // with
  end;

  procedure SetToolBtn(toolBtn: TToolButton);
  var
    j: Integer;
  begin
    with toolBtn do
    begin
      if (Action = nil) then
      begin
        for j := 0 to Self.ComponentCount - 1 do
          case StringIndex(Self.Components[j].ClassName, C_CLASS_NAMES) of
            Ord(cnTGBitBtn):
              begin
                if Tag = TCMGXwBitbtn(Self.Components[j]).CMBtnTag then
                begin
                  Hint := TCMGXwBitbtn(Self.Components[j]).Hint;
                  if TCMGXwBitbtn(Self.Components[j]).CMShowCustomCaption then
                  begin
                    if TCMGXwBitbtn(Self.Components[j]).CMCustomCaptionNo <> 0 then
                      Caption := Trim(GetStringsFromStringNo(TCMGXwBitbtn(Self.Components[j]).CMCustomCaptionNo))
                    else
                      Caption := Trim(TCMGXwBitbtn(Self.Components[j]).Caption);
                  end
                  else
                    Caption := Trim(GetBtnType(GetBtnTypeFromTag(Tag)).Caption);

                  // gbtMonthCompare 专用于成本计算按钮
                  if Tag = Ord(gbtMonthCompare) then
                  begin
                    Caption := '成本计算';
                  end;

                  Break;
                end;
              end;
            Ord(cnTGSpeedBtn):
              begin
                if Tag = TCMGXwSpeedBtn(Self.Components[j]).CMBtnTag then
                begin
                  Hint := TCMGXwSpeedBtn(Self.Components[j]).Hint;
                  if TCMGXwSpeedBtn(Self.Components[j]).CMShowCustomCaption then
                  begin
                    if TCMGXwSpeedBtn(Self.Components[j]).CMCustomCaptionNo <> 0 then
                      Caption := Trim(GetStringsFromStringNo(TCMGXwSpeedBtn(Self.Components[j]).CMCustomCaptionNo))
                  end
                  else
                    Caption := Trim(GetBtnType(GetBtnTypeFromTag(Tag)).Caption);

                  // gbtMonthCompare 专用于成本计算按钮
                  if Tag = Ord(gbtMonthCompare) then
                  begin
                    Caption := '成本计算';
                  end;

                  Break;
                end;
              end;
          end; // case

        if Hint = '' then
          Hint := UpperCase(GetBtnType(GetBtnTypeFromTag(Tag)).ShortCut)
        else
          Hint := Hint + '(' + UpperCase(GetBtnType(GetBtnTypeFromTag(Tag)).ShortCut) + ')';

        if Tag = Ord(gbtHelp) then
        begin
          Visible := FHelpButtonVisible;
          Enabled := FHelpButtonVisible;
        end;

        // 按钮宽度调不动，只有这样
        if Tag = Ord(gbtClose) then
          Caption := '  ' + Caption + '  ';
      end; // if
    end; // with
  end;

  procedure SetGeneralGrid(GeneralGrid: TXwGGeneralGrid);
  begin
    with GeneralGrid do
    begin
      Tag := DisableSkinTag;
      DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

      if FDllParams.PubVersion2 = 880 then
      begin
        AddNotShowFieldsList(flPUnitOther);
      end;

      if not CheckSysCon(SYS_DISPALY_QTYTOTAL) then
        CMTotalType := tTotal
      else
        CMTotalType := tAll;

      FooterHeight := 21;
      DefaultRowHeight := 25;
      UseClassName := Self.ClassName;
//      UseNewGridFilter := CheckSysCon(199);

      if FDllParams.PubVersion3 = 'XIWA' then
        CMXIWAVersion := True
      else
        CMXIWAVersion := False;

      ColorSetting.Color := CMSysColor.CMGridBackColor;
      ColorSetting.FooterColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
      ColorSetting.FooterFont.Color := clBlack;
      ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
      ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
      ColorSetting.TitleColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridTitleBackColor);
      ColorSetting.FixedColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
      ColorSetting.RowFont.Color := clBlack;
      ColorSetting.RowSelectColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
      ColorSetting.RowFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
      ColorSetting.CellFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.CellFocusColor', ''), CMSysColor.CMCellFocusColor);

      ColorSetting.TitleFont.Style := [fsBold];
      ColorSetting.FooterFont.Style := [fsBold];
      ColorSetting.TitleFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeadFontColor);
      ColorSetting.FooterFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeJiRowFontColor);

      if CMGridTwoColorType = 1 then
      begin
        ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
        ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
      end
      else if CMGridTwoColorType = 2 then
      begin
        ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
        ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
      end;

      SetFontStandard;

      CMGetExcelDataEvent := DoGetGeneralGridExcelData;
      GOnFenBuGridPrint := DoGeneralGridFenBuPrint;
      OnXWFormShow := DoXwFormShow;

      if Trim(FLimitList) <> '' then
        if FLimitList[Ord(gbtPrint)] <> '1' then
          MenuOptions := MenuOptions - [moExcel];

      CanNotPrint := not(moExcel in MenuOptions);

      MenuOptions := MenuOptions + [moFilter, moLocate];

      // 如果右键有分布表，就要有收藏按钮
      if moFenBu in MenuOptions then
        MenuOptions := MenuOptions - [moNoShowFavorite];

      Options := Options + [dgAlwaysShowSelection];
      if SameText(SearchInfo.SearchText, '') then
        Options := Options + [dgRowSelect];

      if CMArrestRightMenu then
        MenuOptions := [];

      SetGridRefreshClick(GeneralGrid);
      AfterGridSet;
      DrawControlBorder(GeneralGrid, StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), $CEB499));//$CEB499);
    end; // with
  end;

  procedure SetGeneralWGrid(GeneralWGrid: TXwGGeneralWGrid);
  begin
    with GeneralWGrid do
    begin
      Tag := DisableSkinTag;
      DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

      if FDllParams.PubVersion2 = 880 then
      begin
        AddNotShowFieldsList(flPUnitOther);
      end;

      if not CheckSysCon(SYS_DISPALY_QTYTOTAL) then
        CMTotalType := tTotal
      else
        CMTotalType := tAll;

      FooterHeight := 25; // 21
      DefaultRowHeight := 25;
//      UseNewGridFilter := CheckSysCon(199);

      if FDllParams.PubVersion3 = 'XIWA' then
        CMXIWAVersion := True
      else
        CMXIWAVersion := False;

      ColorSetting.Color := CMSysColor.CMGridBackColor;
      ColorSetting.FooterColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
      ColorSetting.FooterFont.Color := clBlack;
      ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
      ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
      ColorSetting.TitleColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridTitleBackColor);
      ColorSetting.FixedColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
      ColorSetting.RowFont.Color := clBlack;
      ColorSetting.RowSelectColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
      ColorSetting.RowFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
      ColorSetting.CellFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.CellFocusColor', ''), CMSysColor.CMCellFocusColor);

      ColorSetting.TitleFont.Style := [fsBold];
      ColorSetting.FooterFont.Style := [fsBold];
      ColorSetting.TitleFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeadFontColor);
      ColorSetting.FooterFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeJiRowFontColor);

      if CMGridTwoColorType = 1 then
      begin
        ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
        ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
      end
      else if CMGridTwoColorType = 2 then
      begin
        ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
        ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
      end;

      SetFontStandard;

      CMGetExcelDataEvent := DoGetGeneralWGridExcelData;
      GOnFenBuGridPrint := DoGeneralWGridFenBuPrint;
      OnXWFormShow := DoXwFormShow;

      if Trim(FLimitList) <> '' then
        if FLimitList[Ord(gbtPrint)] <> '1' then
          MenuOptions := MenuOptions - [moExcel];

      CanNotPrint := not(moExcel in MenuOptions);

      MenuOptions := MenuOptions + [moLocate];

      Options := Options + [dgAlwaysShowSelection, dgCanInputExpr];

      if CMArrestRightMenu then
        MenuOptions := [];

      SetGridRefreshClick(GeneralWGrid);
      UseQuickSearch := False;
      AfterGridSet;

      DrawControlBorder(GeneralWGrid, StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), $CEB499));
    end; // with
  end;

  procedure SetFenBuBiaoGrid(fenbubiaoGrid: TCMFenbubiaoGrid);
  var
    tgo: TGDOption;
  begin
    with fenbubiaoGrid do
    begin
      Tag := DisableSkinTag;
      DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

      if FDllParams.PubVersion2 = 880 then
      begin
        AddNotShowFieldsList(flPUnitOther);
      end;

      if not CheckSysCon(SYS_DISPALY_QTYTOTAL) then
        CMTotalType := tTotal
      else
        CMTotalType := tAll;

      OnXWFormShow := DoXwFormShow;

      FooterHeight := 25;
      DefaultRowHeight := 25;
//      UseNewGridFilter := CheckSysCon(199);

      for tgo := Low(TGDOption) to High(TGDOption) do
      begin
        if FDllParams.PubVersion3 = 'XIWA' then
          GMOptions[tgo] := Ord(tgo)
        else
          GMOptions[tgo] := -100;
      end;

      ColorSetting.Color := CMSysColor.CMGridBackColor;
      ColorSetting.FooterColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
      ColorSetting.FooterFont.Color := clBlack;
      ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
      ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
      ColorSetting.TitleColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridTitleBackColor);
      ColorSetting.FixedColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
      ColorSetting.RowFont.Color := clBlack;
      ColorSetting.RowSelectColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
      ColorSetting.RowFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
      ColorSetting.CellFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.CellFocusColor', ''), CMSysColor.CMCellFocusColor);

      ColorSetting.TitleFont.Style := [fsBold];
      ColorSetting.FooterFont.Style := [fsBold];
      ColorSetting.TitleFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeadFontColor);
      ColorSetting.FooterFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeJiRowFontColor);

      if CMGridTwoColorType = 1 then
      begin
        ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
        ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
      end
      else if CMGridTwoColorType = 2 then
      begin
        ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
        ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
      end;

      if Trim(FLimitList) <> '' then
        if FLimitList[Ord(gbtPrint)] <> '1' then
          MenuOptions := MenuOptions - [moExcel];

      CanNotPrint := not(moExcel in MenuOptions);

      BasicTypeSet := BasicTypeSet + [btBCtype, btBVtype, btTType, btZFType, btZSType, btEtype2, btVchType, btWBType, btWType, btCustom3, btCustom4];

      SetGridRefreshClick(fenbubiaoGrid);
      AfterGridSet;

      DrawControlBorder(fenbubiaoGrid, StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), $CEB499));
    end;
  end;

  procedure SetAction(Action: TAction);
  begin
    with Action do
    begin
      if Tag <> 0 then
      begin
        // if GetBtnType(GetBtnTypeFromTag(Tag)).HotKey <> '' then
        // Caption :=
        // Trim(GetBtnType(GetBtnTypeFromTag(Tag)).Caption) + '(&' +
        // GetBtnType(GetBtnTypeFromTag(Tag)).HotKey + ')';

        ImageIndex := GetBtnType(GetBtnTypeFromTag(Tag)).ImageIndex;

        if GetBtnType(GetBtnTypeFromTag(Tag)).ShortCut <> '' then
          ShortCut := TextToShortCut(GetBtnType(GetBtnTypeFromTag(Tag)).ShortCut);

        if FDetailLimit[GetBtnTypeFromTag(Tag)] then
          Enabled := Enabled and (FLimitList[Ord(GetBtnTypeFromTag(Tag))] = '1');
      end; // if

      // 屏蔽老打印按钮
      if (Tag = Ord(gbtPrint)) or (Tag = Ord(gbtPreview)) then
      begin
        Visible := False;
        Enabled := False;
      end;

      AfterGraspCMSetAction;
    end; // with
  end;

  procedure SetCheckBox(checkBox: TCMGXwChcekBox);
  begin
    with checkBox do
    begin
      WordWrap := False;
      DoubleBuffered := True;
      Color := CMSysColor.CMFaceBackColor;

      OnHintEvent := GjpHint;
      Inc(CheckBoxCount);
      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      if CMBasicType = CMbtNo then
        Exit;

      if not VarIsNull(Params[Ord(CMBasicType)]) then
      begin
        Tag := CheckBoxCount;
        Checked := StrToInteger(Params[Ord(CMBasicType)]) > 0;
      end;

      Repaint;
    end; // with
  end;

  procedure SetLabelEmptyDate(labelEmptyDate: TCMGLabelEmptyDate);
  var
    sDate: TDate;
  begin
    with labelEmptyDate do
    begin
      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      ImeName := '';

      if (CMBasicType <> CMbtNo) and (Params[Ord(CMBasicType)] <> null) and (Trim(Params[Ord(CMBasicType)]) <> '') then
      begin
        sDate := StringToDateTime(Params[Ord(CMBasicType)]);
        if sDate < labelEmptyDate.MinDate then
          labelEmptyDate.MinDate := sDate;
        Date := StringToDateTime(Params[Ord(CMBasicType)]);
      end;

      OnKeyDown := EnterKeyDown;
    end; // with
  end;

  procedure SetGroupBox(groupBox: TCMGGroupBox);
  begin
    with groupBox do
    begin
      Color := CMSysColor.CMFaceBackColor;

      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      ImeName := '';
    end; // with
  end;

  procedure SetRadioButton(radioButton: TCMGRadioButton);
  begin
    with radioButton do
    begin
      Color := CMSysColor.CMFaceBackColor;

      OnHintEvent := GjpHint;
      Inc(RadioButtonCount);

      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      if CMBasicType = CMbtNo then
        Exit;

      if not VarIsNull(Params[Ord(CMBasicType)]) then
        Tag := RadioButtonCount;
      Caption := '(&' + IntToStr(Tag) + ')' + Caption;
    end; // with
  end;

  procedure SetLabelValueComBox(labelValueComBox: TCMGLabelValueComBox);
  begin
    with labelValueComBox do
    begin
      OnHintEvent := GjpHint;
      OnKeyDown := EnterKeyDown;

      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      if CMBasicType = CMbtNo then
        Exit;

      ImeName := '';

      if not VarIsNull(Params[Ord(CMBasicType)]) then
      begin
        if Trim(Params[Ord(CMBasicType)]) <> '' then
          ItemIndex := IndexForValue(Params[Ord(CMBasicType)]);

        if ItemIndex < 0 then
          ItemIndex := 0;
      end
      else
        ItemIndex := 0;
    end; // with
  end;

  procedure SetLabelClearDate(labelClearDate: TCMGLabelClearDate);
  begin
    with labelClearDate do
    begin
      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      if CMBasicType = CMbtNo then
        Exit;

      ImeName := '';
      labelClearDate.CMBeforeSetDateStr := BeforeSetDateStr;
      labelClearDate.CMAfterSetDateStr := AfterSetDateStr;
      DateStr := Params[Ord(CMBasicType)];
      OnKeyDown := EnterKeyDown;
    end; // with
  end;

  procedure SetLabelQueryDate(labelQueryDate: TCMGLabelQueryDate);
  var
    sDate: TDate;
  begin
    with labelQueryDate do
    begin
      if CMShowCustomCaption then
      begin
        if CMCustomCaptionNo <> 0 then
          Caption := Trim(GetStringsFromStringNo(CMCustomCaptionNo))
        else
          Caption := Caption;
      end
      else
        Caption := Trim(GetDataTypeFromBasic(CMBasicType).Caption);

      ImeName := '';

      if (CMBasicType <> CMbtNo) and (Params[Ord(CMBasicType)] <> null) and (Trim(Params[Ord(CMBasicType)]) <> '') then
      begin
        sDate := StringToDateTime(Params[Ord(CMBasicType)]);
        if sDate < labelQueryDate.MinDate then
          labelQueryDate.MinDate := sDate;
        Date := StringToDateTime(Params[Ord(CMBasicType)]);
      end;

      OnKeyDown := EnterKeyDown;
    end; // with
  end;

begin
  try
    FIsFormInit := True;
    RadioButtonCount := 0;
    CheckBoxCount := 0;

    for I := 0 to ComponentCount - 1 do // Iterate
    begin
      if Components[I] is TCMXwPanel then
      begin
        (Components[I] as TCMXwPanel).Color := CMSysColor.CMFaceBackColor;
        Continue;
      end
      else if Components[I] is TRadioGroup then
      begin
        (Components[I] as TRadioGroup).Color := CMSysColor.CMFaceBackColor;
        Continue;
      end
      else if Components[I] is TCheckListBox then
      begin
        (Components[I] as TCheckListBox).Color := CMSysColor.CMFaceBackColor;
        Continue;
      end
      else if Components[I] is TScrollBox then
      begin
        (Components[I] as TScrollBox).Color := CMSysColor.CMFaceBackColor;
        Continue;
      end
      else if Components[I] is TCMGXwLabelLabel then
        SetCMGxwLabelLabel(TCMGXwLabelLabel(Components[I]))
      else if Components[I] is TCMGLabelMemo then
        SetLabelMemo(TCMGLabelMemo(Components[I]))
      else if Components[I] is TCMGLabelComBox then
        SetLabelComboBox(TCMGLabelComBox(Components[I]))
      else if Components[I] is TCMGLabelBtnEdit then
        SetLabelBtnEdit(TCMGLabelBtnEdit(Components[I]))
      else if Components[I] is TCMGXwBitbtn then
        SetBitBtn(TCMGXwBitbtn(Components[I]))
      else if Components[I] is TCMGXwSpeedBtn then
        SetSpeedBtn(TCMGXwSpeedBtn(Components[I]))
      else if Components[I] is TToolButton then
        SetToolBtn(TToolButton(Components[I]))
      else if Components[I] is TXwGGeneralGrid then
        SetGeneralGrid(TXwGGeneralGrid(Components[I]))
      else if Components[I] is TXwGGeneralWGrid then
        SetGeneralWGrid(TXwGGeneralWGrid(Components[I]))
      else if Components[I] is TCMFenbubiaoGrid then
        SetFenBuBiaoGrid(TCMFenbubiaoGrid(Components[I]))
      else if Components[I] is TAction then
        SetAction(TAction(Components[I]))
      else if Components[I] is TCMGXwChcekBox then
        SetCheckBox(TCMGXwChcekBox(Components[I]))
      else if Components[I] is TCMGLabelEmptyDate then
        SetLabelEmptyDate(TCMGLabelEmptyDate(Components[I]))
      else if Components[I] is TCMGGroupBox then
        SetGroupBox(TCMGGroupBox(Components[I]))
      else if Components[I] is TTabControl then
      begin
        with TTabControl(Components[I]) do
        begin
          OwnerDraw := True;
          OnDrawTab := TabControlDrawTab;
        end;
      end
      else if Components[I] is TPageControl then
      begin
        with TPageControl(Components[I]) do
        begin
          OwnerDraw := True;
          OnDrawTab := PageControlDrawTab;
        end;
      end
      else if Components[I] is TPopupMenu then
      begin
        with TPopupMenu(Components[I]) do
          AutoHotkeys := maManual;
      end
      else if Components[I] is TCMGRadioButton then
        SetRadioButton(TCMGRadioButton(Components[I]))
      else if Components[I] is TCMGLabelValueComBox then
        SetLabelValueComBox(TCMGLabelValueComBox(Components[I]))
      else if Components[I] is TCMGLabelClearDate then
        SetLabelClearDate(TCMGLabelClearDate(Components[I]))
      else if Components[I] is TCMGLabelQueryDate then
        SetLabelQueryDate(TCMGLabelQueryDate(Components[I]))
      else if Components[I] is TCMCWBackPanel then
      begin
        with TCMCWBackPanel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
          DoubleBuffered := True;
        end;
      end
      else if Components[I] is TCMCWMaroonPanel then
      begin
        with TCMCWMaroonPanel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
          DoubleBuffered := True;
        end;
      end
      else if Components[I] is TPanel then
      begin
        with TPanel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
          DoubleBuffered := True;
        end;
      end
      else if Components[I] is TShadowPanel then
      begin
        with TShadowPanel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
          DoubleBuffered := True;
        end;
      end
      else if Components[I] is TStatusBar then
      begin
        with TStatusBar(Components[I]) do
        begin
          Color := CMSysColor.CMMainFormToolsBackColor;
          Font.Color := CMSysColor.CMMainFormToolsFontColor;
        end;
      end
      else if Components[I] is TCMXwAlignGrid then
      begin
        with TCMXwAlignGrid(Components[I]) do
        begin
          FixedColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
          DefaultRowHeight := 25;
          SelectedCellColor := CMSysColor.CMGridSelRowBackColor;
          SelectedFontColor := clWhite;

          if FixedRows = 1 then
          begin
            FixedRowFont[0].Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeadFontColor);
            FixedRowFont[0].Style := [fsBold];
          end;

          AlignRow[0] := maCenter;

          AfterGridSet;
        end;

        DrawControlBorder(TCMXwAlignGrid(Components[I]), StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), $CEB499));
      end
      else if Components[I] is TGroupBox then
      begin
        with TGroupBox(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is TLabel then
      begin
        with TLabel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;

          AfterParentLabelSet;
        end;
      end
      else if Components[I] is TCheckBox then
      begin
        with TCheckBox(Components[I]) do
        begin
          DoubleBuffered := True;
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is TEdit then
      begin
        with TEdit(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is TCheckBox then
      begin
        with TCheckBox(Components[I]) do
        begin
          DoubleBuffered := True;
          Color := CMSysColor.CMFaceBackColor;
        end;
      end;
    end; // for
    Result := True;
  finally
    FIsFormInit := False;
  end;
end;

procedure TDllGraspForm.InitializationForm;
begin

end;

procedure TDllGraspForm.RefreshVclSkinControl(AControl: TWinControl);
begin
  // if Assigned(SkinManager) then
  // TSkinData(SkinManager.MainData).UpdateSkinControl(Self, AControl);
end;

procedure TDllGraspForm.LoadData;
begin

end;

constructor TDllGraspForm.CreateByParams(AOwner: TComponent; AParamType: array of TCMBasicType; AParamValue: array of OLEVariant);
var
  I: Integer;
begin
  Params := VarArrayCreate([Ord( Low(TCMBasicType)), Ord( High(TCMBasicType))], varVariant);
  for I := Low(AParamType) to High(AParamType) do
    Params[Ord(AParamType[I])] := AParamValue[I];
  FVersion := 'Grasp Frame 2.0 2010-02-01';
  FunctionNo := 0;
  FunctionNoDetail := '';
  FUnitType := utJxc;
  FCMGridTwoColorType := 0;
  inherited Create(AOwner);
  Self.FormCreate(Self);
end;

constructor TDllGraspForm.Create(AOwner: TComponent);
begin
  Params := VarArrayCreate([Ord( Low(TCMBasicType)), Ord( High(TCMBasicType))], varVariant);
  FVersion := 'Grasp Frame 2.0 2010-02-01';
  FunctionNo := 0;
  FunctionNoDetail := '';
  FUnitType := utJxc;
  FCMGridTwoColorType := 0;
  inherited Create(AOwner);
end;

destructor TDllGraspForm.Destroy;
begin
  if Assigned(FCMSysColor) then
    FreeAndNil(FCMSysColor);

  inherited;
end;

procedure TDllGraspForm.FormCreate(Sender: TObject);
begin
  FCMSysColor := TGraspColorTypeConfig.Create;
  LoadConfig;

  inherited;

  KeyPreview := True;
  FHelpName := '';
  FPrintName := '';

  Color := CMSysColor.CMFaceBackColor;
end;

procedure TDllGraspForm.LoadConfig;
var
  Sql: string;
begin
  try
    if not FDllParams.IsPro then
    begin
      FHelpButtonVisible := True;
      Exit;
    end;

    Sql := 'if exists(Select 1 From dbo.sysobjects Where id = OBJECT_ID(N''T_Gbl_Sysdatacw'') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1) Select 1 Else Select 0';
    if GetValueFromSQL(Sql) = 1 then
    begin
      Sql := 'if exists(Select 1 From T_Gbl_Sysdatacw Where SubName = ''CloseHelpButton'' and SubValue = ''T'') Select 1 Else Select 0';
      FHelpButtonVisible := GetValueFromSQL(Sql) = 0;
    end
    else
      FHelpButtonVisible := not FDllParams.IsPro;
  except
    FHelpButtonVisible := True;
  end;
end;

//procedure TDllGraspForm.DoPrint(Sender: TObject);
//begin
//  Print;
//end;
//
//procedure TDllGraspForm.Print(szRwxFile: string = ''; acMode: Char = 'P');
//var
//  j: Integer;
//  TitleArray: array [0 .. 1000] of TTable_b;
//begin
//  if szRwxFile = '' then
//    szRwxFile := PrintName;
//
//  if szRwxFile = '' then
//    szRwxFile := Title;
//
//  j := -1;
//  PrintLoadTitleData(j, TitleArray, szRwxFile);
//
//  GetTableB(j, TitleArray, GetImageDataSet);
//
//  PrintLoadGridData;
//
//  RunPrintByConfig(szRwxFile);
//end;
//
//procedure TDllGraspForm.PrintLoadSysTitle(var j: Integer; var TitleArray: array of TTable_b);
//begin
//  Inc(j);
//  TitleArray[j].szFieldName := '系统日期';
//  TitleArray[j].nLength := 10;
//  TitleArray[j].szValue := FormatDateTime('yyyy-mm-dd', Date);
//
//  Inc(j);
//  TitleArray[j].szFieldName := '系统时间';
//  TitleArray[j].nLength := 10;
//  TitleArray[j].szValue := FormatDateTime('hh:nn:ss', Time);
//
//  Inc(j);
//  TitleArray[j].szFieldName := '登录日期';
//  TitleArray[j].nLength := 10;
//  TitleArray[j].szValue := FormatDateTime('yyyy-mm-dd', GetLogOnDateTime);
//
//  Inc(j);
//  TitleArray[j].szFieldName := '操作员';
//  TitleArray[j].nLength := Length(AnsiString(GetCurrentOperatorName));
//  TitleArray[j].szValue := GetCurrentOperatorName;
//
//  Inc(j);
//  TitleArray[j].szFieldName := '公司名称';
//  TitleArray[j].szValue := GetSysValue('companyfullname');
//  TitleArray[j].nLength := Length(AnsiString(TitleArray[j].szValue));
//
//  Inc(j);
//  TitleArray[j].szFieldName := '公司地址';
//  TitleArray[j].szValue := GetSysValue('address');
//  TitleArray[j].nLength := Length(AnsiString(TitleArray[j].szValue));
//
//  Inc(j);
//  TitleArray[j].szFieldName := '公司电话';
//  TitleArray[j].szValue := GetSysValue('tel');
//  TitleArray[j].nLength := Length(AnsiString(TitleArray[j].szValue));
//
//  Inc(j);
//  TitleArray[j].szFieldName := '会计年度';
//  TitleArray[j].szValue := GetCurrentYear;
//  TitleArray[j].nLength := 4;
//end;
//
//procedure TDllGraspForm.PrintLoadTitleData(var j: Integer; var TitleArray: array of TTable_b; szRwxFile: string = '');
//var
//  I: Integer;
//begin
//  PrintLoadSysTitle(j, TitleArray);
//
//  if Trim(Title) <> '' then
//  begin
//    Inc(j);
//    TitleArray[j].szFieldName := '表名';
//    TitleArray[j].szValue := Trim(Title);
//    TitleArray[j].nLength := Length(AnsiString(TitleArray[j].szValue));
//  end;
//
//  for I := 0 to Self.ComponentCount - 1 do
//  begin
//    if not(Self.Components[I] is TControl) then
//      Continue;
//
//    case StringIndex(Self.Components[I].ClassName, C_CLASS_NAMES) of //
//      - 1:
//        Continue;
//      Ord(cnTLabelLabel):
//        with TCMGXwLabelLabel(Self.Components[I]) do
//        begin
//          if ((FrameWork <> fwConcatInfo) and (not Visible)) or CMNotPrint then
//            Continue;
//
//          Inc(j);
//          TitleArray[j].szFieldName := LabelCaption;
//          TitleArray[j].nLength := Length(AnsiString(LabelText));
//          TitleArray[j].szValue := LabelText;
//        end;
//      Ord(cnTLabelMemo):
//        with TCMGLabelMemo(Self.Components[I]) do
//        begin
//          if not Visible then
//            Continue;
//
//          Inc(j);
//          TitleArray[j].szFieldName := Caption;
//          TitleArray[j].nLength := Length(AnsiString(Text));
//          TitleArray[j].szValue := Text;
//        end;
//      Ord(cnTLabelComboBox):
//        with TCMGLabelComBox(Self.Components[I]) do
//        begin
//          if not Visible then
//            Continue;
//
//          Inc(j);
//          TitleArray[j].szFieldName := Caption;
//          TitleArray[j].nLength := Length(AnsiString(Text));
//          TitleArray[j].szValue := Text;
//        end;
//      Ord(cnTLabelValueComboBox):
//        with TCMGLabelValueComBox(Self.Components[I]) do
//        begin
//          if not Visible then
//            Continue;
//
//          Inc(j);
//          TitleArray[j].szFieldName := Caption;
//          TitleArray[j].nLength := Length(AnsiString(Text));
//          TitleArray[j].szValue := Text;
//        end;
//      Ord(cnTLabelBtnEdit):
//        with TCMGLabelBtnEdit(Self.Components[I]) do
//        begin
//          if (Trim(Caption) = '') or (not Visible) then
//            Continue;
//
//          Inc(j);
//          TitleArray[j].szFieldName := Caption;
//          TitleArray[j].nLength := Length(AnsiString(Text));
//          TitleArray[j].szValue := Text;
//        end;
//      Ord(cnTLabelEmptyDate):
//        with TCMGLabelEmptyDate(Self.Components[I]) do
//        begin
//          if not Visible then
//            Continue;
//
//          Inc(j);
//          TitleArray[j].szFieldName := Caption;
//          TitleArray[j].nLength := 10;
//          TitleArray[j].szValue := FormatDateTime('yyyy-mm-dd', Date)
//        end;
//      Ord(cnTLabelClearDate):
//        with TCMGLabelClearDate(Self.Components[I]) do
//        begin
//          if not Visible then
//            Continue;
//
//          Inc(j);
//          TitleArray[j].szFieldName := Caption;
//          TitleArray[j].nLength := 10;
//          TitleArray[j].szValue := DateStr;
//        end; // with
//    end; // case
//  end;
//end;
//
//procedure TDllGraspForm.PrintLoadGridData;
//var
//  I: Integer;
//begin
//  for I := 0 to Self.ComponentCount - 1 do
//  begin
//    if not(Self.Components[I] is TControl) then
//      Continue;
//
//    case StringIndex(Self.Components[I].ClassName, C_CLASS_NAMES) of //
//      - 1:
//        Continue;
//      Ord(cnTGeneralGrid):
//        begin
//          if TXwGGeneralGrid(Self.Components[I]).Visible then
//            GetTableM(TXwGGeneralGrid(Self.Components[I]));
//        end;
//      Ord(cnTGeneralWGrid):
//        begin
//          if TXwGGeneralWGrid(Self.Components[I]).Visible then
//            GetTableM(TXwGGeneralWGrid(Self.Components[I]));
//        end;
//      Ord(cnTCMXwAlignGrid):
//        begin
//          if TCMXwAlignGrid(Self.Components[I]).Visible then
//            GetTableM(TCMXwAlignGrid(Self.Components[I]));
//        end;
//      Ord(cnTFenbubiaoGrid):
//        begin
//          if TCMFenbubiaoGrid(Self.Components[I]).Visible then
//            GetTableM(TCMFenbubiaoGrid(Self.Components[I]));
//        end;
//    end;
//  end;
//end;

// 打印设置
procedure TDllGraspForm.PrinterSetup(szRwxFile: string = '');
begin
end;

procedure TDllGraspForm.SelectNextCom(Sender: TObject);
begin
  SelectNext(ActiveControl as TWinControl, True, True);
end;

// 定义虚方法，在状态条中显示帮助，其实现在子类中
procedure TDllGraspForm.GjpHint(Sender: TObject);
begin
end;

procedure TDllGraspForm.ToolBarCustomDrawButton(Sender: TToolBar; Button: TToolButton; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DrawToolBarCustomButton(Sender, Button, State, DefaultDraw);
end;

procedure TDllGraspForm.ToolBtnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

// 定义虚方法，将部分基本信息组合成一条信息显示
procedure TDllGraspForm.DoFrameWork(Sender: TObject);
begin
end;

// 定义Tabcontrol, pagecontrol的tab自画方法
procedure TDllGraspForm.TabControlDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  ATextHeight, ATextWidth: Integer;
begin
  Control.Canvas.Brush.Color := CMSysColor.CMFaceBackColor;
  ATextHeight := Control.Canvas.TextHeight('W');
  ATextWidth := Control.Canvas.TextWidth(TTabControl(Control).Tabs.Strings[TabIndex]);
  Control.Canvas.TextRect(Rect, Rect.Left + (Rect.Right - Rect.Left - ATextWidth) div 2, Rect.Top + (Rect.Bottom - Rect.Top - ATextHeight) div 2 + 2,
    TTabControl(Control).Tabs.Strings[TabIndex]);
end;

procedure TDllGraspForm.PageControlDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  ATextHeight, ATextWidth: Integer;
begin
  Control.Canvas.Brush.Color := CMSysColor.CMFaceBackColor;
  ATextHeight := Control.Canvas.TextHeight('W');
  ATextWidth := Control.Canvas.TextWidth(TPageControl(Control).Pages[TabIndex].Caption);
  Control.Canvas.TextRect(Rect, Rect.Left + (Rect.Right - Rect.Left - ATextWidth) div 2, Rect.Top + (Rect.Bottom - Rect.Top - ATextHeight) div 2 + 2,
    TPageControl(Control).Pages[TabIndex].Caption);
end;

procedure TDllGraspForm.EnterKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SelectNextCom(Sender);
end;

//procedure TDllGraspForm.ExporttoExcel(szRwxFile: string = '');
//var
//  j: Integer;
//  TitleArray: array [0 .. 1000] of TTable_b;
//begin
//  if szRwxFile = '' then
//    szRwxFile := PrintName;
//
//  if szRwxFile = '' then
//    szRwxFile := Title;
//
//  j := -1;
//  PrintLoadTitleData(j, TitleArray, szRwxFile);
//
//  GetTableB(j, TitleArray, nil);
//
//  PrintLoadGridData;
//
//  RunPrintExportToExcel(Self, szRwxFile);
//end;
//
//procedure TDllGraspForm.DoExporttoExcel(Sender: TObject);
//begin
//  ExporttoExcel;
//end;

procedure TDllGraspForm.SelectBaseInfo(Sender: TObject; szMode: string; var Modifyed: Boolean);
var
  temp: TCMBaseArray;
  BaseType: TCMBaseInfoType;
  szSearchType: Char;
  szSearchString, szKTypeID, szAssistant1, szAssistant2: string;
  SubjectType: TCMSubjectType;
  SelectOptions: TCMBaseSelectOptions;
  bContinue, canAddNewAtype: Boolean;
  BaseSelectParam: TBaseSelectParam;
begin
  inherited;
  try
    temp := TCMBaseArray.Create;
    Modifyed := False;
    if not TCMGLabelBtnEdit(Sender).CMRunSelectBase then
      Exit;

    BaseType := BasicTypeToBaseInfoType(TCMGLabelBtnEdit(Sender).CMBasicType);
    szSearchType := '~';
    if szMode = 'KEYDOWN' then
    begin
      if TCMGLabelBtnEdit(Sender).Text <> TCMGLabelBtnEdit(Sender).FLastText then
        szSearchString := TCMGLabelBtnEdit(Sender).Text
      else
        szSearchString := '';
    end
    else
      szSearchString := '';

    szKTypeID := '';
    szAssistant1 := '';
    szAssistant2 := '';
    SubjectType := CMstAll;
    SelectOptions := TCMGLabelBtnEdit(Sender).CMSelectOptions;
    SelectOptions := SelectOptions + [bopQuery];
    bContinue := True;

    if Assigned(FOnBeforeSelectBaseInfo) then
      FOnBeforeSelectBaseInfo(Sender, BaseType, szSearchType, szSearchString, szKTypeID, szAssistant1, szAssistant2, SubjectType, SelectOptions, bContinue);

    if not bContinue then
      Exit;
    BaseSelectParam := GetBaseSelectParam;
    BaseSelectParam.Tag := TCMGLabelBtnEdit(Sender).Tag;
    if (BaseType in [tbtAType, tbtATypeCW]) then // 科目选择换新的单元
    begin
      if bopInsert in SelectOptions then
        canAddNewAtype := True
      else
        canAddNewAtype := False;

      if SelectAtypeData(szSearchString, temp, SubjectType, bopSelectClass in SelectOptions, canAddNewAtype) then
      begin
        TCMGLabelBtnEdit(Sender).TypeID := temp[0].szTypeID;
        TCMGLabelBtnEdit(Sender).FLastText := TCMGLabelBtnEdit(Sender).Text;
        TCMGLabelBtnEdit(Sender).CMSonnum := temp[0].SonNum;
        TCMGLabelBtnEdit(Sender).CMRec := temp[0].lRec;

        Params[Ord(TCMGLabelBtnEdit(Sender).CMBasicType)] := temp[0].szTypeID;

        if Assigned(FOnAfterSelectBaseInfo) then
          FOnAfterSelectBaseInfo(Sender, temp);

        Modifyed := True;
      end;
    end
    else if (BaseType = tbtPStype) then
    begin
//      if SelectPositionData('', '', '', '', '', '', '', '', SelectOptions, BaseSelectParam, temp, szSearchString) then
//      begin
//        TCMGLabelBtnEdit(Sender).TypeID := temp[0].szTypeID;
//        TCMGLabelBtnEdit(Sender).FLastText := TCMGLabelBtnEdit(Sender).Text;
//        TCMGLabelBtnEdit(Sender).CMSonnum := temp[0].SonNum;
//        TCMGLabelBtnEdit(Sender).CMRec := temp[0].lRec;
//
//        if Assigned(FOnAfterSelectBaseInfo) then
//          FOnAfterSelectBaseInfo(Sender, temp);
//
//        Modifyed := True;
//      end;
    end
    else if (BaseType = tbtPluginBaseInfo) then
    begin
      if SelectPluginBaseInfo(BaseSelectParam.DllName, szAssistant1, szSearchString, bopMultiSelect in SelectOptions, temp) then
      begin
        TCMGLabelBtnEdit(Sender).FLastText := TCMGLabelBtnEdit(Sender).Text;
        TCMGLabelBtnEdit(Sender).CMRec := temp[0].lRec;
        TCMGLabelBtnEdit(Sender).Text := temp[0].FullName;

        if Assigned(FOnAfterSelectBaseInfo) then
          FOnAfterSelectBaseInfo(Sender, temp);

        Modifyed := True;
      end;
    end
    else if SelectBaseData(BaseType, szSearchType, szSearchString, szKTypeID, '', szAssistant1, szAssistant2, SubjectType, SelectOptions, BaseSelectParam, temp) then
    begin
      if (Trim(temp[0].szTypeID) <> Trim(TCMGLabelBtnEdit(Sender).TypeID)) and (temp[0].lRec <> TCMGLabelBtnEdit(Sender).Rec) then
        if Assigned(FOnVchAfterSelectBaseInfo) then
          FOnVchAfterSelectBaseInfo(Sender, temp);

      if TCMGLabelBtnEdit(Sender).CMBasicType in [CMbtOperatingType] then
        TCMGLabelBtnEdit(Sender).Rec := temp[0].lRec
      else
        TCMGLabelBtnEdit(Sender).TypeID := temp[0].szTypeID;

      TCMGLabelBtnEdit(Sender).FLastText := TCMGLabelBtnEdit(Sender).Text;
      TCMGLabelBtnEdit(Sender).CMSonnum := temp[0].SonNum;
      TCMGLabelBtnEdit(Sender).CMRec := temp[0].lRec;

      Params[Ord(TCMGLabelBtnEdit(Sender).CMBasicType)] := temp[0].szTypeID;

      if TCMGLabelBtnEdit(Sender).CMBasicType = CMbtOperatingType then
        Params[Ord(CMbtAssThree)] := temp[0].lRec;
      if TCMGLabelBtnEdit(Sender).CMBasicType = CMbtPMtype then
        Params[Ord(CMbtTrueStock)] := temp[0].lRec;

      if TCMGLabelBtnEdit(Sender).CMBasicType = CMbtVchType then
      begin
        Params[Ord(CMbtAssFour)] := temp[0].szTypeID;
        Params[Ord(TCMGLabelBtnEdit(Sender).CMBasicType)] := IntToStr(temp[0].lRec);
      end;

      if TCMGLabelBtnEdit(Sender).BasicinfoEditBandType = bebtOther then
        TCMGLabelBtnEdit(Sender).Text := temp[0].FullName;

      if TCMGLabelBtnEdit(Sender).CMBasicType = CMbtOperator then
        TCMGLabelBtnEdit(Sender).Text := temp[0].FullName;

      if TCMGLabelBtnEdit(Sender).CMBasicType in [CMbtDeviceTool, CMbtMaintainItem] then
      begin
        Params[Ord(TCMGLabelBtnEdit(Sender).CMBasicType) + 1] := temp[0].lRec;
        Params[Ord(TCMGLabelBtnEdit(Sender).CMBasicType)] := temp[0].FullName;
        TCMGLabelBtnEdit(Sender).CMRec := temp[0].lRec;
        TCMGLabelBtnEdit(Sender).Text := temp[0].FullName;
      end;

      if Assigned(FOnAfterSelectBaseInfo) then
        FOnAfterSelectBaseInfo(Sender, temp);

      Modifyed := True;
    end;
  finally
    FreeAndNil(temp);
  end;
end;

procedure TDllGraspForm.UserDefinedSelectBasic(Sender: TObject; szMode: String; var Modifyed: Boolean);
var
  szStr: string;
begin
  inherited;
  if (Sender is TCMGLabelBtnEdit) then
  begin
    if (Sender as TCMGLabelBtnEdit).ReadOnly then
      Exit;

    if szMode = 'KEYDOWN' then
      szStr := (Sender as TCMGLabelBtnEdit).Text
    else
      szStr := '';

    if UserDefinedShow(True, szStr, '') then
    begin
      (Sender as TCMGLabelBtnEdit).Text := szStr;
      Self.Params[Ord((Sender as TCMGLabelBtnEdit).CMBasicType)] := szStr;
    end;

    Modifyed := True;
  end;
end;

procedure TDllGraspForm.BillNumberSelectBasic(Sender: TObject; szMode: String; var Modifyed: Boolean);
var
  szStr, szVchtype: string;
begin
  inherited;
  if (Sender is TCMGLabelBtnEdit) then
  begin
    if (Sender as TCMGLabelBtnEdit).ReadOnly then
      Exit;

    if szMode = 'KEYDOWN' then
      szStr := (Sender as TCMGLabelBtnEdit).Text
    else
      szStr := '';

    szVchtype := (Sender as TCMGLabelBtnEdit).Vchtype;

    if ShowBillNumber(szStr, szVchtype) then
    begin
      (Sender as TCMGLabelBtnEdit).Text := szStr;
    end;

    Modifyed := True;
  end;
end;

function TDllGraspForm.ShowAssistantQty: Boolean;
begin
  if SystemIntf.CheckSysCon(144) then
    Result := True
  else
    Result := False;
end;

procedure TDllGraspForm.ShowOneHelp(Sender: TObject);
begin
  if FHelpButtonVisible then
    ExecHelp(FHelpName);
end;

procedure TDllGraspForm.LoadTitleData;
begin
  SetComponentProperty;
end;

function TDllGraspForm.GetBasicValue(ABasicType: TCMBasicType; AValue: string): string;
begin
  Result := '';
end;

function TDllGraspForm.GetXIWABasicValue(ABasicType: TBasicType; TypeID: string): string;
begin
  Result := '';

  if (Trim(TypeID) = '') then
    Result := ''
  else
    Result := GetCMBasicLocalValue(ABasicType, GetBasicFieldName(ABasicType), TypeID);
end;

function TDllGraspForm.GetXIWALabelBasicValue(ABasicType: TBasicType; TypeID: string; AField: TFieldsList): string;
begin
  Result := '';

  if (Trim(TypeID) = '') then
    Result := ''
  else
  begin
    if AField = flNull then
      Result := GetCMBasicLocalValue(ABasicType, GetBasicFieldName(ABasicType), TypeID)
    else
      Result := GetCMBasicLocalValue(ABasicType, AField, TypeID);
  end;
end;

function TDllGraspForm.GetBasicFieldName(ABasicType: TBasicType): TFieldsList;
begin
  case ABasicType of
    btPtype:
      Result := flPFullName;
    btAtype:
      Result := flAFullName;
    btBtype:
      Result := flBFullName;
    btEtype:
      Result := flEFullName;
    btDtype:
      Result := flDFullName;
    btKtype:
      Result := flKFullName;
    btRtype:
      Result := flRFullName;
    btTType:
      Result := flTFullName;
    btMType:
      Result := flMFullName;
    btZFType:
      Result := flZFFullName;
    btZSType:
      Result := flZSFullName;
    btBCtype:
      Result := flBCFullName;
    btBVtype:
      Result := flBVFullName;
    btItype:
      Result := flIFullName;
    btJtype:
      Result := flJFullName;
    btOtype:
      Result := flGFullName;
    btVchType:
      Result := flVFullName;
    btWBType:
      Result := flBWFullName;
    btWType:
      Result := flWFullName;
    btGXType:
      Result := flGXFullName;
    btGZType:
      Result := flGZFullName;
    btGXtype2:
      Result := flGXFullName2;
    btPStype:
      Result := flPSFullName;
    btPStype2:
      Result := flPSFullName2;
    btCustom3:
      Result := flCustom3FullName;
    btCustom4:
      Result := flCustom4FullName;
    btTIType:
      Result := flTIFullName;
  else
    Result := flNull;
  end;
end;

procedure TDllGraspForm.SetGridProperty(GeneralGrid: TXwGGeneralGrid);
begin
  with GeneralGrid do
  begin
    ClearData;
    ClearAllField;
    BasicRecordAll_C := GetBasicRecordAll_C;
    GridFieldConfigClass := GetGridFieldConfigClass;
    BasicDataLocal := GetBasicDataLocalClass;

    if FDllParams.PubVersion2 = 880 then
    begin
      AddNotShowFieldsList(flPUnitOther);
    end;
  end;
end;

procedure TDllGraspForm.SetWGridProperty(GeneralWGrid: TXwGGeneralWGrid);
begin
  with GeneralWGrid do
  begin
    ClearAllField;
    BasicRecordAll_C := GetBasicRecordAll_C;
    GridFieldConfigClass := GetGridFieldConfigClass;
    BasicDataLocal := GetBasicDataLocalClass;

    if FDllParams.PubVersion2 = 880 then
    begin
      AddNotShowFieldsList(flPUnitOther);
    end;
  end;
end;

function TDllGraspForm.GetCMBasicLocalValue(ABasicType: TBasicType; flField: TFieldsList; TypeID: string): string;
begin
  Result := GetBasicDataLocalClass.GetBasicLocalValue(ABasicType, flField, TypeID);
end;

class function TDllGraspForm.GetCMBasicLocalValueByDouble(ABasicType: TBasicType; flField: TFieldsList; TypeID: string): Integer;
begin
  Result := StrToIntDef(GetCMBasicLocalValueByString(ABasicType, flField, TypeID), 0);
end;

class function TDllGraspForm.GetCMBasicLocalValueByInt(ABasicType: TBasicType; flField: TFieldsList; TypeID: string): Integer;
begin
  Result := StrToIntDef(GetCMBasicLocalValueByString(ABasicType, flField, TypeID), 0);
end;

function TDllGraspForm.GetCMBasicLocalValueByRec(ABasicType: TBasicType; flField: TFieldsList; nRec: Integer): string;
begin
  Result := GetBasicDataLocalClass.GetBasicLocalValue(ABasicType, flField, nRec);
end;

class function TDllGraspForm.GetCMBasicLocalValueByString(ABasicType: TBasicType; flField: TFieldsList; TypeID: string): string;
begin
  Result := GetBasicDataLocalClass.GetBasicLocalValue(ABasicType, flField, TypeID);
end;

function TDllGraspForm.GetCMBasicLocalCaption(flField: TFieldsList): string;
begin
  if flField = flNull then
    Result := ''
  else
    Result := GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flField].DisplayCaption;
end;

function TDllGraspForm.GetCMBasicLocalBaseCaption(flField: TFieldsList; DefaultCaption: string = ''): string;
begin
  if flField = flNull then
    Result := DefaultCaption
  else
    Result := GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flField].Caption;
end;

function TDllGraspForm.GetCMBasicLocalDataBaseName(flField: TFieldsList): string;
begin
  if flField = flNull then
    Result := ''
  else
    Result := GetBasicDataLocalClass.BasicRecordAll_C.FieldsArray[flField].DatabaseName;
end;

procedure TDllGraspForm.SetFunctionNo(const Value: Integer);
begin
  FFunctionNo := Value;

  if FFunctionNo = 0 then
    Exit;

  if FLimitList = '' then
  begin
    // 字符串,当前模块是否要对某个按钮进行权限控制  位置是按钮类型的下标,1表示本窗口需要对此按钮进行权限控制
    FLimitList := CheckLimitNo(FunctionNo);
    // 字符串,当前模块的按钮是否有权限  位置是按钮类型的下标  是布尔型
    GetFunctionDetailLimitNo(FunctionNo, FDetailLimit);
  end;

  if Visible then
    SetButtonsLimit;
end;

procedure TDllGraspForm.SetPrintName(const Value: string);
begin
  FPrintName := Value;
end;

procedure TDllGraspForm.SetToolBarOnce;
var
  I: Integer;
  procedure SetToolBtn(toolBtn: TToolButton);
  var
    j: Integer;
  begin
    with toolBtn do
    begin
      OnMouseMove := ToolBtnMouseMove;
      if (Action = nil) then
      begin
        if (Tag <> 0) and ((Tag < Ord(gbtCustom01)) or (Tag > Ord(gbtCustom30))) then
          ImageIndex := GetBtnType(GetBtnTypeFromTag(Tag)).ImageIndex;

        if not(Style in [tbsSeparator, tbsDivider]) then
          AutoSize := ImageIndex = -1;

        for j := 0 to Self.ComponentCount - 1 do
          case StringIndex(Self.Components[j].ClassName, C_CLASS_NAMES) of
            Ord(cnTGBitBtn):
              begin
                if Tag = TCMGXwBitbtn(Self.Components[j]).CMBtnTag then
                begin
                  Hint := TCMGXwBitbtn(Self.Components[j]).Hint;
                  if TCMGXwBitbtn(Self.Components[j]).CMShowCustomCaption then
                  begin
                    if TCMGXwBitbtn(Self.Components[j]).CMCustomCaptionNo <> 0 then
                      Caption := Trim(GetStringsFromStringNo(TCMGXwBitbtn(Self.Components[j]).CMCustomCaptionNo))
                    else
                      Caption := Trim(TCMGXwBitbtn(Self.Components[j]).Caption);
                  end
                  else
                    Caption := Trim(GetBtnType(GetBtnTypeFromTag(Tag)).Caption);

                  OnClick := TCMGXwBitbtn(Self.Components[j]).OnClick;
                  if Enabled and FDetailLimit[GetBtnTypeFromTag(Tag)] then // modify by zle @2005-07-20visible对显示控制
                    Enabled := FLimitList[Ord(GetBtnTypeFromTag(Tag))] = '1';

                  // gbtMonthCompare 专用于成本计算按钮
                  if Tag = Ord(gbtMonthCompare) then
                  begin
                    Visible := True;
                    Caption := '成本计算';
                  end;

                  // 屏蔽老打印按钮
                  if Tag = Ord(gbtPrint) then
                  begin
                    Visible := False;
                    Enabled := False;
                  end;

                  AfterToolButtonSet;

                  Break;
                end;
              end;
            Ord(cnTGSpeedBtn):
              begin
                if Tag = TCMGXwSpeedBtn(Self.Components[j]).CMBtnTag then
                begin
                  Hint := TCMGXwSpeedBtn(Self.Components[j]).Hint;
                  if TCMGXwSpeedBtn(Self.Components[j]).CMShowCustomCaption then
                  begin
                    if TCMGXwSpeedBtn(Self.Components[j]).CMCustomCaptionNo <> 0 then
                      Caption := Trim(GetStringsFromStringNo(TCMGXwSpeedBtn(Self.Components[j]).CMCustomCaptionNo))
                  end
                  else
                    Caption := Trim(GetBtnType(GetBtnTypeFromTag(Tag)).Caption);

                  OnClick := TCMGXwSpeedBtn(Self.Components[j]).OnClick;
                  if Enabled and FDetailLimit[GetBtnTypeFromTag(Tag)] then
                    Enabled := FLimitList[Ord(GetBtnTypeFromTag(Tag))] = '1';

                  // gbtMonthCompare 专用于成本计算按钮
                  if Tag = Ord(gbtMonthCompare) then
                  begin
                    Visible := True;
                    Caption := '成本计算';
                  end;

                  // 屏蔽老打印按钮
                  if Tag = Ord(gbtPrint) then
                  begin
                    Visible := False;
                    Enabled := False;
                  end;

                  AfterToolButtonSet;

                  Break;
                end;
              end;
          end; // case

        if Hint = '' then
          Hint := UpperCase(GetBtnType(GetBtnTypeFromTag(Tag)).ShortCut)
        else
          Hint := Hint + '(' + UpperCase(GetBtnType(GetBtnTypeFromTag(Tag)).ShortCut) + ')';

        if Tag = Ord(gbtHelp) then
        begin
          Visible := FHelpButtonVisible;
          Enabled := FHelpButtonVisible;
        end;

        // 按钮宽度调不动，只有这样
        if Tag = Ord(gbtClose) then
          Caption := '  ' + Caption + '  ';
      end; // if
    end; // with
  end;

begin
  for I := 0 to ComponentCount - 1 do // Iterate
  begin
    case StringIndex(Components[I].ClassName, C_CLASS_NAMES) of //
      - 1:
        Continue;
      Ord(cnTToolButton):
        begin
          SetToolBtn(TToolButton(Components[I]));
        end;
    end; // case
  end; // for

  for I := 0 to ComponentCount - 1 do // Iterate
  begin
    case StringIndex(Components[I].ClassName, C_CLASS_NAMES) of //
      - 1:
        Continue;
      Ord(cnTToolBar):
        begin
          with TToolBar(Components[I]) do
          begin
            if Images = nil then
              Continue;
            SetBkMode(Canvas.Handle, Windows.TRANSPARENT);
            Color := clWhite;
            Font.Color := $007D6857;
            List := False;
            AutoSize := True;
            ShowCaptions := True;
            DoubleBuffered := True;
            OnCustomDrawButton := ToolBarCustomDrawButton;
          end;
        end;
    end; // case
  end; // for

  for I := 0 to ComponentCount - 1 do // Iterate
  begin
    case StringIndex(Components[I].ClassName, C_CLASS_NAMES) of //
      - 1:
        Continue;
      Ord(cnTCMXwPrintBtn):
        begin
          with TCMXwPrintBtn(Components[I]) do
          begin
            if Parent is TToolBar then
            begin
              ButtonGlyph.Assign(imgPrintButton.Picture.Graphic);
              MenuButtonGlyph.Assign(imgArrowDown.Picture.Graphic);
              SetColor($007D6857);
              Width := TToolBar(Parent).ButtonWidth;
            end;
          end;
        end;
      Ord(cnTCMMenuBtn):
        begin
          with TXwMenuBtn(Components[I]) do
          begin
            MenuButtonGlyph.Assign(imgArrowDown.Picture.Graphic);
            if Parent is TToolBar then
            begin
              SetColor($007D6857);
              Width := TToolBar(Parent).ButtonWidth;
            end;
            SetToolMenuButtonPicture(TControl(Self.Components[I]), ButtonGlyph);
          end;
        end;
      Ord(cnTCMToolMenuBtn):
        SetCMToolMenuBtn(TCMToolMenuBtn(Components[I]));
    end; // case
  end; // for
end;

procedure TDllGraspForm.SetButtonsLimit;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do // Iterate
  begin
    case StringIndex(Components[I].ClassName, C_CLASS_NAMES) of //
      - 1:
        Continue;
      Ord(cnTToolButton):
        begin
          with TToolButton(Components[I]) do
          begin
            if (Action = nil) then
            begin
              if Enabled and FDetailLimit[GetBtnTypeFromTag(Tag)] then
                Enabled := FLimitList[Ord(GetBtnTypeFromTag(Tag))] = '1';

              // gbtMonthCompare 专用于成本计算按钮
              if Tag = Ord(gbtMonthCompare) then
              begin
                Visible := True;
                Caption := '成本计算';
              end;

              // 屏蔽老打印按钮
              if Tag = Ord(gbtPrint) then
              begin
                Visible := False;
                Enabled := False;
              end;

              AfterToolButtonSet;
            end; // if
          end; // with
        end;
      Ord(cnTGBitBtn):
        begin
          with TCMGXwBitbtn(Components[I]) do
          begin
            if FDetailLimit[CMBtnType] then
              Enabled := FLimitList[Ord(CMBtnType)] = '1';

            // 屏蔽老打印按钮
            if Tag = Ord(gbtPrint) then
            begin
              Visible := False;
              Enabled := False;
            end;
          end;
        end;
      Ord(cnTGSpeedBtn):
        begin
          with TCMGXwSpeedBtn(Components[I]) do
          begin
            if FDetailLimit[CMBtnType] then
              Enabled := FLimitList[Ord(CMBtnType)] = '1';

            // 屏蔽老打印按钮
            if Tag = Ord(gbtPrint) then
            begin
              Visible := False;
              Enabled := False;
            end;
          end;
        end;
    end;
  end; // for
end;

procedure TDllGraspForm.SetToolMenuButtonPicture(AControl: TControl;ABitmap: TBitmap);
begin

end;

procedure TDllGraspForm.SetDefaultShowBaseColumn(AGrid: TXwGGeneralGrid;
  AFieldNames: string);
var
  f: TBasicType;
  fieldsList: TStrings;
begin
  if StringEmpty(AFieldNames) then
    Exit;

  fieldsList := TStringList.Create;
  fieldsList.CommaText := AFieldNames;
  try
    with  AGrid.ColumnConfig.BasicRecordAll_C do
    for f := Low(TBasicType) to High(TBasicType) do
    begin
      if fieldsList.IndexOf(FieldsArray[BGFuncs.GetUsercodeField(f)].DatabaseName) < 0 then
        AGrid.CMHideUserCodeField(BGFuncs.GetUsercodeField(f));

      if fieldsList.IndexOf(FieldsArray[BGFuncs.GetFullNameField(f)].DatabaseName) < 0 then
        AGrid.CMHideUserCodeField(BGFuncs.GetFullNameField(f));
    end;
  finally
    FreeAndNil(fieldsList);
  end;
end;

procedure TDllGraspForm.SetDefaultShowColumns(AGrid: TXwGGeneralGrid;
  AFieldNames: string);
var
  i: Integer;
  col: TgpCustomStdColumn;
  fieldsList: TStrings;
begin
  if StringEmpty(AFieldNames) then
    Exit;

  fieldsList := TStringList.Create;
  fieldsList.CommaText := AFieldNames;
  try
    for i := 0 to AGrid.Columns.Count - 1 do
    begin
      col := AGrid.Columns[i];
      if not col.Visible then
        Continue;
      if (col.ChildColumnsCount > 0) or (col.ButtonStyle = gcbsCheckBox)  then
        Continue;

      if fieldsList.IndexOf(col.FieldName) < 0 then
        AGrid.CMSetDefaultNotShow(col.FieldName);
    end;
  finally
    FreeAndNil(fieldsList);
  end;
end;

procedure TDllGraspForm.SetDefaultShowBaseColumn(AGrid: TXwGGeneralWGrid;
  AFieldNames: string);
var
  f: TBasicType;
  fieldsList: TStrings;
begin
  if StringEmpty(AFieldNames) then
    Exit;

  fieldsList := TStringList.Create;
  fieldsList.CommaText := AFieldNames;
  try
    with  AGrid.ColumnConfig.BasicRecordAll_C do
    for f := Low(TBasicType) to High(TBasicType) do
    begin
      if fieldsList.IndexOf(FieldsArray[BGFuncs.GetUsercodeField(f)].DatabaseName) < 0 then
        AGrid.CMHideUserCodeField(BGFuncs.GetUsercodeField(f));

      if fieldsList.IndexOf(FieldsArray[BGFuncs.GetFullNameField(f)].DatabaseName) < 0 then
        AGrid.CMHideUserCodeField(BGFuncs.GetFullNameField(f));
    end;
  finally
    FreeAndNil(fieldsList);
  end;
end;

procedure TDllGraspForm.SetDefaultShowColumns(AGrid: TXwGGeneralWGrid;
  AFieldNames: string);
var
  i: Integer;
  col: TgpCustomStdColumn;
  fieldsList: TStrings;
begin
  if StringEmpty(AFieldNames) then
    Exit;

  fieldsList := TStringList.Create;
  fieldsList.CommaText := AFieldNames;
  try
    for i := 0 to AGrid.Columns.Count - 1 do
    begin
      col := AGrid.Columns[i];
      if not col.Visible then
        Continue;
      if (col.ChildColumnsCount > 0) or (col.ButtonStyle = gcbsCheckBox)  then
        Continue;

      if fieldsList.IndexOf(col.FieldName) < 0 then
        AGrid.CMSetDefaultNotShow(col.FieldName);
    end;
  finally
    FreeAndNil(fieldsList);
  end;
end;

procedure TDllGraspForm.AfterSelectBaseInfo(Sender: TObject; BaseArray: TCMBaseArray);
begin

end;

procedure TDllGraspForm.BeforeSelectBaseInfo(Sender: TObject; var ABaseType: TCMBaseInfoType; var szSearchType: Char;
  var szSearchString, szKTypeID, szAssistant1, szAssistant2: string; var ASubjectType: TCMSubjectType; var ASelectOptions: TCMBaseSelectOptions;
  var ContinueProc: Boolean);
begin

end;

procedure TDllGraspForm.BeforeSetDateStr(Sender: TObject);
begin
  FActControl := ActiveControl;
end;

procedure TDllGraspForm.AfterSetDateStr(Sender: TObject);
begin
  ActiveControl := FActControl;
end;

procedure TDllGraspForm.SetGridRefreshClick(AGrid: TXwBandGrid);
var
  i: Integer;
begin
  if Assigned(AGrid.OnRefreshMenuClick) then
    Exit;

  if not (moRefresh in AGrid.MenuOptions) then
    Exit;

  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TCMGXwBitbtn) and ((Components[i] as TCMGXwBitbtn).CMBtnType = TCMBtnType.gbtRefresh) then
      AGrid.OnRefreshMenuClick := (Components[i] as TCMGXwBitbtn).OnClick;
  end;
end;

procedure TDllGraspForm.AfterGridSet;
begin
end;

procedure TDllGraspForm.AfterToolButtonSet;
begin
end;

function TDllGraspForm.GetVchTypeName(TypeID: string; ShowAllBill: Boolean): string;
var
  SQL: string;
begin
  Result := '';
  if (Trim(TypeID) = '') or ((Trim(TypeID) = '0') and (not ShowAllBill)) then
    Exit;

  SQL := 'Select [Name] From dbo.GetVchtype() Where VchType = ' + TypeID + '';
  Result := GetValueFromSQL(SQL);
end;

function TDllGraspForm.GetOnAfterSelectBaseInfo: TAfterSelectBaseInfoEvent;
begin
  Result := FOnAfterSelectBaseInfo;
end;

function TDllGraspForm.GetOnBeforeSelectBaseInfo: TSelectBaseInfoEvent;
begin
  Result := FOnBeforeSelectBaseInfo;
end;

function TDllGraspForm.GetOnVchAfterSelectBaseInfo: TAfterSelectBaseInfoEvent;
begin
  Result := FOnVchAfterSelectBaseInfo;
end;

function TDllGraspForm.GetOTypeName(Rec: string): string;
var
  SQL: string;
begin
  Result := '';
  if StringToInt(Rec) <= 0 then
    Exit;

  SQL := 'Select [Memo] From DifaType Where Rec = ' + Rec + '';
  Result := GetValueFromSQL(SQL);
end;

function TDllGraspForm.CheckPrintRight: Boolean;
begin
  Result := (Trim(FLimitList) = '') or (FLimitList[Ord(gbtPrint)] = '1');
end;

function TDllGraspForm.GetImageDataSet: TClientDataSet;
begin
  Result := nil;
end;

function TDllGraspForm.GetBaseSelectParam: TBaseSelectParam;
begin
  Result := GetIniBaseSelectParam;
  Result.DllName := ExtractFileName(GetModuleName(HInstance));
end;

procedure TDllGraspForm.AfterGraspCMSetAction;
begin
end;

procedure TDllGraspForm.AfterParentLabelSet;
begin
end;

procedure TDllGraspForm.DoGetGeneralGridExcelData(Sender: TObject; var ADetailData: OLEVariant);
var
  oldPrintPtypeImage: Boolean;
begin
  oldPrintPtypeImage := TXwGGeneralGrid(Sender).PrintPtypeImage;
  TXwGGeneralGrid(Sender).PrintPtypeImage := False;
  ADetailData := GetGridTable(TXwGGeneralGrid(Sender));
  TXwGGeneralGrid(Sender).PrintPtypeImage := oldPrintPtypeImage;
end;

procedure TDllGraspForm.DoGetGeneralWGridExcelData(Sender: TObject; var ADetailData: OLEVariant);
var
  oldPrintPtypeImage: Boolean;
begin
  oldPrintPtypeImage := TXwGGeneralWGrid(Sender).PrintPtypeImage;
  TXwGGeneralWGrid(Sender).PrintPtypeImage := False;
  ADetailData := GetGridTable(TXwGGeneralWGrid(Sender));
  TXwGGeneralWGrid(Sender).PrintPtypeImage := oldPrintPtypeImage;
end;

procedure TDllGraspForm.DoGeneralGridFenBuPrint(Sender: TObject);
var
  btnPrint: TCMXwPrintBtn;
  FClickTag: Integer;
begin
  btnPrint := TCMXwPrintBtn.Create(TXwGGeneralGrid(Sender).Owner);
  try
    FClickTag := GetRadioCheckEx('请选择', ['打印', '打印预览', '打印设计']);
    if FClickTag < 0 then
      Exit;

    btnPrint.AppointPringGridList.Clear;
    btnPrint.AppointPringGridList.Add(TXwGGeneralGrid(Sender));
    btnPrint.TemplateName := Title + '分布表';
    if FClickTag = 1 then
      btnPrint.Print
    else if FClickTag = 2 then
      btnPrint.PreView
    else
      btnPrint.Design;
  finally
    btnPrint.Free;
  end;
end;

procedure TDllGraspForm.DoGeneralWGridFenBuPrint(Sender: TObject);
var
  btnPrint: TCMXwPrintBtn;
  FClickTag: Integer;
begin
  btnPrint := TCMXwPrintBtn.Create(TXwGGeneralWGrid(Sender).Owner);
  try
    FClickTag := GetRadioCheckEx('请选择', ['打印', '打印预览', '打印设计']);
    if FClickTag < 0 then
      Exit;

    btnPrint.AppointPringGridList.Clear;
    btnPrint.AppointPringGridList.Add(TXwGGeneralGrid(Sender));
    btnPrint.TemplateName := Title + '分布表';
    if FClickTag = 1 then
      btnPrint.Print
    else if FClickTag = 2 then
      btnPrint.PreView
    else
      btnPrint.Design;
  finally
    btnPrint.Free;
  end;
end;

procedure TDllGraspForm.DoXwFormShow(Sender: TObject);
var
  I: Integer;
  tgo: TGDOption;
begin
  with (Sender as TComponent) do
  begin
    if (Sender is TForm) then
      (Sender as TForm).Color := CMSysColor.CMFaceBackColor;

    for I := 0 to ComponentCount - 1 do // Iterate
    begin
      if Components[I] is TFenbubiaoGrid then
      begin
        with TFenbubiaoGrid(Components[I]) do
        begin
          DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

          OnXWFormShow := DoXwFormShow;

          FooterHeight := 25;
          DefaultRowHeight := 25;

          for tgo := Low(TGDOption) to High(TGDOption) do
          begin
            if FDllParams.PubVersion3 = 'XIWA' then
              GMOptions[tgo] := Ord(tgo)
            else
              GMOptions[tgo] := -100;
          end;

          ColorSetting.Color := CMSysColor.CMGridBackColor;
          ColorSetting.FooterColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
          ColorSetting.FooterFont.Color := clBlack;
          ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
          ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          ColorSetting.TitleColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridTitleBackColor);
          ColorSetting.FixedColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
          ColorSetting.RowFont.Color := clBlack;
          ColorSetting.RowSelectColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
          ColorSetting.RowFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
          ColorSetting.CellFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.CellFocusColor', ''), CMSysColor.CMCellFocusColor);

          ColorSetting.TitleFont.Style := [fsBold];
          ColorSetting.FooterFont.Style := [fsBold];
          ColorSetting.TitleFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeadFontColor);
          ColorSetting.FooterFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeJiRowFontColor);

          if CMGridTwoColorType = 1 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          end
          else if CMGridTwoColorType = 2 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
          end;

          BasicTypeSet := BasicTypeSet + [btBCtype, btBVtype, btTType, btZFType, btZSType, btEtype2, btVchType, btWBType, btWType, btCustom3, btCustom4,
            btMType, btGXType, btGXtype2, btGZType, btTIType];
        end;

        DrawControlBorder(TFenbubiaoGrid(Components[I]), StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), $CEB499));
      end
      else if Components[I] is TXwSelectPage then
      begin
        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TGLabelLabel then
      begin
        with TGLabelLabel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end; // with
      end
      else if Components[I] is TGLabelBtnEdit then
      begin
        with TGLabelBtnEdit(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
          FocusColor := CMSysColor.CMEditInputFocusColor;
        end; // with
      end
      else if Components[I] is TXwBandGrid then
      begin
        with TXwBandGrid(Components[I]) do
        begin
          DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

          OnXWFormShow := DoXwFormShow;

          FooterHeight := 25;
          DefaultRowHeight := 25;

          for tgo := Low(TGDOption) to High(TGDOption) do
          begin
            if FDllParams.PubVersion3 = 'XIWA' then
              GMOptions[tgo] := Ord(tgo)
            else
              GMOptions[tgo] := -100;
          end;

          ColorSetting.Color := CMSysColor.CMGridBackColor;
          ColorSetting.FooterColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
          ColorSetting.FooterFont.Color := clBlack;
          ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
          ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          ColorSetting.TitleColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridTitleBackColor);
          ColorSetting.FixedColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
          ColorSetting.RowFont.Color := clBlack;
          ColorSetting.RowSelectColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
          ColorSetting.RowFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
          ColorSetting.CellFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.CellFocusColor', ''), CMSysColor.CMCellFocusColor);

          ColorSetting.TitleFont.Style := [fsBold];
          ColorSetting.FooterFont.Style := [fsBold];
          ColorSetting.TitleFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeadFontColor);
          ColorSetting.FooterFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeJiRowFontColor);

          if CMGridTwoColorType = 1 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          end
          else if CMGridTwoColorType = 2 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
          end;

          BasicTypeSet := BasicTypeSet + [btBCtype, btBVtype, btTType, btZFType, btZSType, btEtype2, btVchType, btWBType, btWType, btCustom3, btCustom4,
            btMType, btGXType, btGXtype2, btGZType, btTIType];
        end;

        DrawControlBorder(TXwBandGrid(Components[I]), StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), $CEB499));
      end
      else if Components[I] is TVchGridClass then
      begin
        with TVchGridClass(Components[I]) do
        begin
          DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

          OnXWFormShow := DoXwFormShow;

          FooterHeight := 25;
          DefaultRowHeight := 25;

          for tgo := Low(TGDOption) to High(TGDOption) do
          begin
            if FDllParams.PubVersion3 = 'XIWA' then
              GMOptions[tgo] := Ord(tgo)
            else
              GMOptions[tgo] := -100;
          end;

          ColorSetting.Color := CMSysColor.CMGridBackColor;
          ColorSetting.FooterColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
          ColorSetting.FooterFont.Color := clBlack;
          ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
          ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          ColorSetting.TitleColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridTitleBackColor);
          ColorSetting.FixedColor := StrToIntDef(uOperationFunc.GetConfig('Grid.FixedColor', ''), CMSysColor.CMGridFixedColor);
          ColorSetting.RowFont.Color := clBlack;
          ColorSetting.RowSelectColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
          ColorSetting.RowFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.RowSelectColor', ''), CMSysColor.CMGridSelRowBackColor);
          ColorSetting.CellFocusColor := StrToIntDef(uOperationFunc.GetConfig('Grid.CellFocusColor', ''), CMSysColor.CMCellFocusColor);

          ColorSetting.TitleFont.Style := [fsBold];
          ColorSetting.FooterFont.Style := [fsBold];
          ColorSetting.TitleFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeadFontColor);
          ColorSetting.FooterFont.Color := StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), CMSysColor.CMGridHeJiRowFontColor);

          if CMGridTwoColorType = 1 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          end
          else if CMGridTwoColorType = 2 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
          end;

          BasicTypeSet := BasicTypeSet + [btBCtype, btBVtype, btTType, btZFType, btZSType, btEtype2, btVchType, btWBType, btWType, btCustom3, btCustom4,
            btMType, btGXType, btGXtype2, btGZType, btTIType];
        end;
        DrawControlBorder(TVchGridClass(Components[I]), StrToIntDef(uOperationFunc.GetConfig('Grid.FontColor', ''), $CEB499));
      end
      else if Components[I] is TStringGrid then
      begin
        with TStringGrid(Components[I]) do
        begin
          FixedColor := CMSysColor.CMGridFixedColor;
        end;
      end
      else if Components[I] is TXWCheckBox then
      begin
        with TXWCheckBox(Components[I]) do
        begin
          DoubleBuffered := True;
          Color := CMSysColor.CMFaceBackColor;
          Font.Size := 9;
          Font.Name := '宋体';
          Font.Charset := GB2312_CHARSET;
          Font.Height := -12;
        end; // with
      end
      else if Components[I] is TGroupBox then
      begin
        with TGroupBox(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end; // with
      end
      else if Components[I] is TTabControl then
      begin
        with TTabControl(Components[I]) do
        begin
          OwnerDraw := True;
          OnDrawTab := TabControlDrawTab;
        end;
      end
      else if Components[I] is TPageControl then
      begin
        with TPageControl(Components[I]) do
        begin
          OwnerDraw := True;
          OnDrawTab := PageControlDrawTab;
        end;
      end
      else if Components[I] is TRadioButton then
      begin
        with TRadioButton(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end; // with
      end
      else if Components[I] is TXwPanel then
      begin
        with TXwPanel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TPanel then
      begin
        with TPanel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TStatusBar then
      begin
        with TStatusBar(Components[I]) do
        begin
          Color := CMSysColor.CMMainFormToolsBackColor;
          Font.Color := CMSysColor.CMMainFormToolsFontColor;
        end;
      end
      else if Components[I] is TXwAlignGrid then
      begin
        with TXwAlignGrid(Components[I]) do
        begin
          FixedColor := CMSysColor.CMGridFixedColor;
          // FixedRows := 1;
          // FixedColor := CMSysColor.CMGridFixedColor;
          // DefaultRowHeight := 25;
          // SelectedCellColor := CMSysColor.CMGridSelRowBackColor;
          // SelectedFontColor := clWhite;
          // FixedRowFont[0].Color := CMSysColor.CMGridHeadFontColor;
          // FixedRowFont[0].Style := [fsBold];
          //
          // AlignRow[0] := maCenter;
        end;
      end
      else if Components[I] is TGroupBox then
      begin
        with TGroupBox(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TLabel then
      begin
        with TLabel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is TCheckBox then
      begin
        with TCheckBox(Components[I]) do
        begin
          DoubleBuffered := True;
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is TChart then
      begin
        with TChart(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is XwChartClass then
      begin
        with XwChartClass(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TGSelectLevel then
      begin
        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TXwExpressSet then
      begin
        TXwExpressSet(Components[I]).Brush.Color := CMSysColor.CMFaceBackColor;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end;
    end;
  end;
end;

// procedure TDllGraspForm.DrawControlBorder(WinControl: TWinControl;
// BorderColor: TColor);
// var
// DC : HDC;
// Brush : HBRUSH;
// R: TRect;
// begin
// DC := GetWindowDC(WinControl.Handle);
//
// GetWindowRect(WinControl.Handle, R);
// OffsetRect(R, -R.Left, -R.Top);
//
// Brush := CreateSolidBrush(ColorToRGB(BorderColor));
// FrameRect(DC, R, Brush);
// DeleteObject(Brush);
//
// ReleaseDC(WinControl.Handle, DC);
// end;

procedure TDllGraspForm.SetComponentsStyleCMSQ(AComponent: TComponent);
var
  I: Integer;
  tgo: TGDOption;
begin
  with AComponent do
  begin
    for I := 0 to ComponentCount - 1 do // Iterate
    begin
      if Components[I] is TFenbubiaoGrid then
      begin
        with TFenbubiaoGrid(Components[I]) do
        begin
          DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

          OnXWFormShow := DoXwFormShow;

          FooterHeight := 25;
          DefaultRowHeight := 25;
//          UseNewGridFilter := CheckSysCon(199);

          for tgo := Low(TGDOption) to High(TGDOption) do
          begin
            if FDllParams.PubVersion3 = 'XIWA' then
              GMOptions[tgo] := Ord(tgo)
            else
              GMOptions[tgo] := -100;
          end;

          ColorSetting.Color := CMSysColor.CMGridBackColor;
          ColorSetting.FooterColor := CMSysColor.CMGridFixedColor;
          ColorSetting.FooterFont.Color := clBlack;
          ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
          ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          ColorSetting.TitleColor := CMSysColor.CMGridTitleBackColor;
          ColorSetting.FixedColor := CMSysColor.CMGridFixedColor;
          ColorSetting.RowFont.Color := clBlack;
          ColorSetting.RowSelectColor := CMSysColor.CMGridSelRowBackColor;
          ColorSetting.RowFocusColor := CMSysColor.CMGridSelRowBackColor;
          ColorSetting.CellFocusColor := CMSysColor.CMCellFocusColor;

          ColorSetting.TitleFont.Style := [fsBold];
          ColorSetting.FooterFont.Style := [fsBold];
          ColorSetting.TitleFont.Color := CMSysColor.CMGridHeadFontColor;
          ColorSetting.FooterFont.Color := CMSysColor.CMGridHeJiRowFontColor;

          if CMGridTwoColorType = 1 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          end
          else if CMGridTwoColorType = 2 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
          end;

          BasicTypeSet := BasicTypeSet + [btBCtype, btBVtype, btTType, btZFType, btZSType, btEtype2, btVchType, btWBType, btWType, btCustom3, btCustom4,
            btMType, btGXType, btGXtype2, btGZType, btTIType];
        end;
      end
      else if Components[I] is TXwSelectPage then
      begin
        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TGLabelLabel then
      begin
        with TGLabelLabel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is TGLabelBtnEdit then
      begin
        with TGLabelBtnEdit(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
          FocusColor := CMSysColor.CMEditInputFocusColor;
        end; // with
      end
      else if Components[I] is TXwBandGrid then
      begin
        with TXwBandGrid(Components[I]) do
        begin
          DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

          OnXWFormShow := DoXwFormShow;

          FooterHeight := 25;
          DefaultRowHeight := 25;
//          UseNewGridFilter := CheckSysCon(199);

          for tgo := Low(TGDOption) to High(TGDOption) do
          begin
            if FDllParams.PubVersion3 = 'XIWA' then
              GMOptions[tgo] := Ord(tgo)
            else
              GMOptions[tgo] := -100;
          end;

          ColorSetting.Color := CMSysColor.CMGridBackColor;
          ColorSetting.FooterColor := CMSysColor.CMGridFixedColor;
          ColorSetting.FooterFont.Color := clBlack;
          ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
          ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          ColorSetting.TitleColor := CMSysColor.CMGridTitleBackColor;
          ColorSetting.FixedColor := CMSysColor.CMGridFixedColor;
          ColorSetting.RowFont.Color := clBlack;
          ColorSetting.RowSelectColor := CMSysColor.CMGridSelRowBackColor;
          ColorSetting.RowFocusColor := CMSysColor.CMGridSelRowBackColor;
          ColorSetting.CellFocusColor := CMSysColor.CMCellFocusColor;

          ColorSetting.TitleFont.Style := [fsBold];
          ColorSetting.FooterFont.Style := [fsBold];
          ColorSetting.TitleFont.Color := CMSysColor.CMGridHeadFontColor;
          ColorSetting.FooterFont.Color := CMSysColor.CMGridHeJiRowFontColor;

          if CMGridTwoColorType = 1 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          end
          else if CMGridTwoColorType = 2 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
          end;

          BasicTypeSet := BasicTypeSet + [btBCtype, btBVtype, btTType, btZFType, btZSType, btEtype2, btVchType, btWBType, btWType, btCustom3, btCustom4,
            btMType, btGXType, btGXtype2, btGZType, btTIType];
        end;
      end
      else if Components[I] is TVchGridClass then
      begin
        with TVchGridClass(Components[I]) do
        begin
          DefaultRowHeight := FRAME_GRID_ROW_HEIGHT;

          OnXWFormShow := DoXwFormShow;

          FooterHeight := 25;
          DefaultRowHeight := 25;
//          UseNewGridFilter := CheckSysCon(199);

          for tgo := Low(TGDOption) to High(TGDOption) do
          begin
            if FDllParams.PubVersion3 = 'XIWA' then
              GMOptions[tgo] := Ord(tgo)
            else
              GMOptions[tgo] := -100;
          end;

          ColorSetting.Color := CMSysColor.CMGridBackColor;
          ColorSetting.FooterColor := CMSysColor.CMGridFixedColor;
          ColorSetting.FooterFont.Color := clBlack;
          ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
          ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          ColorSetting.TitleColor := CMSysColor.CMGridTitleBackColor;
          ColorSetting.FixedColor := CMSysColor.CMGridFixedColor;
          ColorSetting.RowFont.Color := clBlack;
          ColorSetting.RowSelectColor := CMSysColor.CMGridSelRowBackColor;
          ColorSetting.RowFocusColor := CMSysColor.CMGridSelRowBackColor;
          ColorSetting.CellFocusColor := CMSysColor.CMCellFocusColor;

          ColorSetting.TitleFont.Style := [fsBold];
          ColorSetting.FooterFont.Style := [fsBold];
          ColorSetting.TitleFont.Color := CMSysColor.CMGridHeadFontColor;
          ColorSetting.FooterFont.Color := CMSysColor.CMGridHeJiRowFontColor;

          if CMGridTwoColorType = 1 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridLightColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridLightColor;
          end
          else if CMGridTwoColorType = 2 then
          begin
            ColorSetting.RowDarkColor := CMSysColor.CMGridDarkColor;
            ColorSetting.RowLightColor := CMSysColor.CMGridDarkColor;
          end;

          BasicTypeSet := BasicTypeSet + [btBCtype, btBVtype, btTType, btZFType, btZSType, btEtype2, btVchType, btWBType, btWType, btCustom3, btCustom4,
            btMType, btGXType, btGXtype2, btGZType, btTIType];
        end;
      end
      else if Components[I] is TXWCheckBox then
      begin

        with TXWCheckBox(Components[I]) do
        begin
          DoubleBuffered := True;
          Color := CMSysColor.CMFaceBackColor;
        end; // with
      end
      else if Components[I] is TGroupBox then
      begin
        with TGroupBox(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end; // with
      end
      else if Components[I] is TTabControl then
      begin
        with TTabControl(Components[I]) do
        begin
          OwnerDraw := True;
          OnDrawTab := TabControlDrawTab;
        end;
      end
      else if Components[I] is TPageControl then
      begin
        with TPageControl(Components[I]) do
        begin
          OwnerDraw := True;
          OnDrawTab := PageControlDrawTab;
        end;
      end
      else if Components[I] is TRadioButton then
      begin
        with TRadioButton(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end; // with
      end
      else if Components[I] is TXwPanel then
      begin
        with TXwPanel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TPanel then
      begin
        with TPanel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TStatusBar then
      begin
        with TStatusBar(Components[I]) do
        begin
          Color := CMSysColor.CMMainFormToolsBackColor;
          // Font.Color := GetSystemColor(MainFormToolsFontColor);
        end;
      end
      else if Components[I] is TXwAlignGrid then
      begin
        with TXwAlignGrid(Components[I]) do
        begin
          FixedColor := CMSysColor.CMGridFixedColor;
        end;
      end
      else if Components[I] is TGroupBox then
      begin
        with TGroupBox(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TLabel then
      begin
        with TLabel(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is TCheckBox then
      begin
        with TCheckBox(Components[I]) do
        begin
          DoubleBuffered := True;
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is TChart then
      begin
        with TChart(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;
      end
      else if Components[I] is XwChartClass then
      begin
        with XwChartClass(Components[I]) do
        begin
          Color := CMSysColor.CMFaceBackColor;
        end;

        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TGSelectLevel then
      begin
        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end
      else if Components[I] is TXwExpressSet then
      begin
        if Components[I].ComponentCount > 0 then
          SetComponentsStyleCMSQ(Components[I]);
      end;
    end;
  end;
end;

procedure TDllGraspForm.FormActivate(Sender: TObject);
var
  I: Integer;
begin
  inherited;

  for I := 0 to ComponentCount - 1 do // Iterate
  begin
    case StringIndex(Components[I].ClassName, C_CLASS_NAMES) of //
      - 1:
        Continue;
      Ord(cnTGeneralGrid):
        begin
          with TXwGGeneralGrid(Components[I]) do
          begin
            OnXWFormShow := DoXwFormShow;
            CMGetExcelDataEvent := DoGetGeneralGridExcelData;
            GOnFenBuGridPrint := DoGeneralGridFenBuPrint;

            if FDllParams.PubVersion3 = 'XIWA' then
              CMXIWAVersion := True
            else
              CMXIWAVersion := False;
          end;
        end;
      Ord(cnTGeneralWGrid):
        begin
          with TXwGGeneralWGrid(Components[I]) do
          begin
            OnXWFormShow := DoXwFormShow;
            CMGetExcelDataEvent := DoGetGeneralWGridExcelData;
            GOnFenBuGridPrint := DoGeneralWGridFenBuPrint;

            if FDllParams.PubVersion3 = 'XIWA' then
              CMXIWAVersion := True
            else
              CMXIWAVersion := False;
          end;
        end;
    end;
  end;
end;

{ TPrintButtonHandler }
constructor TPrintHandler.Create(AOwner: TDllGraspForm; APrintButton: TCMXwPrintBtn);
begin
  CheckError(not Assigned(AOwner), '未正确指定打印窗体。');
  CheckError(not Assigned(APrintButton), '未正确指定打印按钮。');
  FOwnerForm := AOwner;
  FPrintButton := APrintButton;

  FBeforePrint := APrintButton.BeforePrint;
  FPrintButton.BeforePrint := DoBeforePrint;

  FBeforePrintPopmenu := APrintButton.OnBeforeMenu;
  FPrintButton.OnBeforeMenu := DoBeforePrintPopmenu;

  FAfterPrint := APrintButton.AfterPrint;
  FPrintButton.AfterPrint := DoAfterPrint;

  FBeforePrintMenu := APrintButton.BeforePopmenu;
  FPrintButton.BeforePopmenu := DoBeforePrintMenu;
end;

procedure TPrintHandler.DoBeforePrint(Sender: TObject);
begin
  if not Assigned(FPrintButton) then
    Exit;

  CheckError((FOwnerForm.LimitList <> '') and (FOwnerForm.LimitList[Ord(gbtPrint)] <> '1'), '你没有打印的权限，不能继续。');

  if Assigned(FSetPrintIdAndTemplateName) then
    FSetPrintIdAndTemplateName(FPrintButton);

  if Assigned(FCMBeforePrint) then
    FCMBeforePrint(Sender);

  if Assigned(FSelfLoadPrintTitle) then
    FSelfLoadPrintTitle(FPrintButton)
  else
    LoadPrintHeadData(FOwnerForm, FPrintButton);

  if Assigned(FSelfLoadPrintGrid) then
    FSelfLoadPrintGrid(FPrintButton)
  else
    LoadPrintGridData(FOwnerForm, FPrintButton);

  // if Assigned(FCMBeforePrint) then
  // FCMBeforePrint(Sender);

  if Assigned(FBeforePrint) then
    FBeforePrint(Sender);

  CheckError(Self.PrintID = 0, '未指定PrintID属性。');
  CheckError(SameText(Self.PrintTemplate, EmptyStr), '未指定打印模板。');
end;

procedure TPrintHandler.DoBeforePrintPopmenu(Sender: TObject);
begin
  if not Assigned(FPrintButton) then
    Exit;

  if Assigned(FSetPrintIdAndTemplateName) then
    FSetPrintIdAndTemplateName(FPrintButton);

  if Assigned(FCMBeforePrintPopmenu) then
    FCMBeforePrintPopmenu(Sender);

  if Assigned(FBeforePrintPopmenu) then
    FBeforePrintPopmenu(Sender);


  CheckError(Self.PrintID = 0, '未指定PrintID属性。');
  CheckError(SameText(Self.PrintTemplate, EmptyStr), '未指定打印模板。');
end;

procedure TPrintHandler.DoBeforePrintMenu(Sender: TObject);
begin
  if not Assigned(FPrintButton) then
    Exit;

  if Assigned(FSetPrintIdAndTemplateName) then
    FSetPrintIdAndTemplateName(FPrintButton);

  if Assigned(FCMBeforePrintMenu) then
    FCMBeforePrintMenu(Sender);

  if Assigned(FBeforePrintMenu) then
    FBeforePrintMenu(Sender);


  CheckError(Self.PrintID = 0, '未指定PrintID属性。');
  CheckError(SameText(Self.PrintTemplate, EmptyStr), '未指定打印模板。');
end;

procedure TPrintHandler.DoAfterPrint(Sender: TObject);
begin
  if not Assigned(FPrintButton) then
    Exit;

  if Assigned(FAfterPrint) then
    FAfterPrint(Sender);

  if Assigned(FCMAfterPrint) then
    FCMAfterPrint(Sender);
end;

function TPrintHandler.GetPrintID: Integer;
begin
  Result := FPrintID;
end;

function TPrintHandler.GetPrintTemplate: string;
begin
  Result := FPrintTemplate;
end;

procedure TPrintHandler.LoadPrintGridData(AForm: TDllGraspForm; var APrintButton: TCMXwPrintBtn);
var
  j: Integer;

  procedure BindPrintGrid;
  var
    I: Integer;
    Component: TComponent;
  begin
    APrintButton.DetailGridList.Clear;

    if APrintButton.AppointPringGridList.Count > 0 then
    begin
      for i := 0 to APrintButton.AppointPringGridList.Count - 1 do
      begin
        APrintButton.DetailGridList.Add(APrintButton.AppointPringGridList.Items[i]);
      end;
    end
    else
    begin
      for I := 0 to AForm.ComponentCount - 1 do
      begin
        Component := AForm.Components[I];
        if not(Component is TWinControl) then
          Continue;

        if (Component is TXwGGeneralGrid) or (Component is TXwGGeneralWGrid) or (Component is TCMXwAlignGrid) then
        begin
          if not TWinControl(Component).Visible then
            Continue;
          APrintButton.DetailGridList.Add(TWinControl(Component));
        end;
      end;
    end;
  end;

  function AutoLoadGridData(AGrid: TWinControl): OLEVariant;
  begin
    if not Assigned(AGrid) then
      Result := null
    else if AGrid is TXwGGeneralGrid then
      Result := GetGridTable(TXwGGeneralGrid(AGrid))
    else if AGrid is TXwGGeneralWGrid then
      Result := GetGridTable(TXwGGeneralWGrid(AGrid))
    else if AGrid.InheritsFrom(TCMXwAlignGrid) then
      Result := GetGridTable(TCMXwAlignGrid(AGrid))
    else
      Result := null;
  end;

begin
  if not Assigned(AForm) then
    Exit;
  if not Assigned(APrintButton) then
    Exit;

  BindPrintGrid;

  APrintButton.DetailDataList.Clear;
  for j := 0 to APrintButton.DetailGridList.Count - 1 do
  begin
    APrintButton.DetailDataList.Add(AutoLoadGridData(APrintButton.DetailGridList.Items[j]));
  end;
end;

procedure TPrintHandler.LoadPrintHeadData(AForm: TDllGraspForm; var APrintButton: TCMXwPrintBtn);
begin
  APrintButton.Header := GetHeaderData(AForm, AForm.Title, AForm.GetImageDataSet, FAfterLoadPrintHeader);
end;

procedure TPrintHandler.SetPrintID(const Value: Integer);
begin
  FPrintID := Value;
  FPrintButton.PrintID := FPrintID;
end;

procedure TPrintHandler.SetPrintTemplate(const Value: string);
begin
  FPrintTemplate := Value;
  FPrintButton.TemplateName := FPrintTemplate;
end;

end.
