unit uDllMDIParent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllGraspForm, ExtCtrls, ToolWin, ComCtrls, DB, DBClient, uExtImage,
  StdCtrls, ShadowPanel, XPMenu, XwGjpBasicCom, xwButtons,
  xwbasiccomponent, xwBasicinfoComponent, XwTable, uCMEventHander, XwGGeneralGrid, XwGGeneralWGrid, xwgridsclass;

type
  TfrmDllMDIParent = class(TDllGraspForm)
    ToolBar: TToolBar;
    cdsGetRecordSet: TClientDataSet;
    pnlTitle: TCMCWBackPanel;
    pnlButton: TCMCWMaroonPanel;
    pnlEntry: TCMCWBackPanel;
    ShadowPanel1: TShadowPanel;
    lblTitle: TLabel;
    sbStatus: TStatusBar;
    XPMenu1: TXPMenu;
    btnExpertPrint: TCMXwPrintBtn;
    tbsPrintSep: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CMEventHandlerSetPrintIdAndTemplateName(Sender: TObject);
  private
    { Private declarations }
    FFormCreating: Boolean;
    FPrintHandler: TPrintHandler;

    procedure SetPrintID(const Value: Integer);
    procedure SetPrintTemplate(const Value: string);
    function GetPrintID: Integer;
    function GetPrintTemplate: string;
    procedure WMSETTEXT(var Message: TMessage); message WM_SETTEXT;
    procedure CreatePrintHandler;
  protected
    procedure SetTitle(const Value: string); override;

    procedure DoCreate; override;
    procedure InitializationForm; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

    property PrintID: Integer read GetPrintID write SetPrintID;
    property PrintTemplate: string read GetPrintTemplate write SetPrintTemplate;
  end;


implementation

uses uDllSystemIntf, uOperationFunc;

{$R *.dfm}

procedure TfrmDllMDIParent.DoCreate;
begin
  FFormCreating := False;
  inherited;
end;

procedure TfrmDllMDIParent.FormCreate(Sender: TObject);
begin
  ToolBar.Images := GetImageList;
  ToolBar.DisabledImages := GetDisableImageList;
  inherited;
  if ShadowPanel1.FaceColor = $00F4C664 then
    ShadowPanel1.FaceColor := StrToIntDef(GetConfig('Title.PanelColor', ''), $00F4C664);

  ToolBar.AutoSize := True;
  CreatePrintHandler;
end;

procedure TfrmDllMDIParent.CMEventHandlerSetPrintIdAndTemplateName(
  Sender: TObject);
begin
  inherited;
  PrintID := FunctionNo;
  PrintTemplate := Title;
end;

constructor TfrmDllMDIParent.Create(AOwner: TComponent);
begin
  FFormCreating := True;
  inherited Create(AOwner);
  CreatePrintHandler;
end;

procedure TfrmDllMDIParent.CreatePrintHandler;
begin
  if not Assigned(FPrintHandler) then
  begin
    FPrintHandler := TPrintHandler.Create(Self, btnExpertPrint);
    FPrintHandler.CMBeforePrintPopmenu := CMEventHandler.BeforePrintPopupMenu;
    FPrintHandler.CMBeforePrintMenu := CMEventHandler.BeforePrintMenu;
    FPrintHandler.CMBeforePrint := CMEventHandler.BeforePrint;
    FPrintHandler.CMAfterPrint := CMEventHandler.AfterPrint;
    FPrintHandler.AfterLoadPrintHeader := CMEventHandler.AfterLoadPrintHeader;
    FPrintHandler.SelfLoadPrintTitle := CMEventHandler.SelfLoadPrintTitle;
    FPrintHandler.SelfLoadPrintGrid := CMEventHandler.SelfLoadPrintGrid;
    FPrintHandler.SetPrintIdAndTemplateName := CMEventHandler.SetPrintIdAndTemplateName;
    FPrintHandler.SelfOldPrint := CMEventHandler.SelfOldPrint;
    //btnExpertPrint.ShowTypeSelMenu := False;
//    btnExpertPrint.ShowBaseStyle := False;
  end;
end;

procedure TfrmDllMDIParent.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GetComponentProperty;
  if Assigned(FPrintHandler) then
    FreeAndNil(FPrintHandler);
  inherited;
  Action := caFree;
end;

procedure TfrmDllMDIParent.InitializationForm;
begin
  SetComponentProperty;

  pnlButton.Visible := not ToolBar.Visible;
end;

procedure TfrmDllMDIParent.SetTitle(const Value: string);
var
  i: Integer;
begin
  inherited;

  lblTitle.Caption := Value;
  Caption := Value;
  ShadowPanel1.Width := lblTitle.Left + lblTitle.Width + 8;

  if Assigned(FPrintHandler) and (PrintTemplate = '') then
    PrintTemplate := Value;

  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TXwGGeneralGrid then
      (Components[i] as TXwGGeneralGrid).FormTitle := Value
    else if Components[i] is TXwGGeneralWGrid then
      (Components[i] as TXwGGeneralWGrid).FormTitle := Value
    else if Components[i] is TXwBandGrid then
      (Components[i] as TXwBandGrid).FormTitle := Value;
  end;
end;

function TfrmDllMDIParent.GetPrintID: Integer;
begin
  Result := FPrintHandler.PrintID;
end;

function TfrmDllMDIParent.GetPrintTemplate: string;
begin
  Result := FPrintHandler.PrintTemplate;
end;

procedure TfrmDllMDIParent.SetPrintID(const Value: Integer);
begin
  FPrintHandler.PrintID := Value;
end;

procedure TfrmDllMDIParent.SetPrintTemplate(const Value: string);
begin
  FPrintHandler.PrintTemplate := Value;
end;

procedure TfrmDllMDIParent.WMSETTEXT(var Message: TMessage);
begin
  //窗体在创建的时候屏蔽Caption的赋值，避免主窗体Caption闪烁
  if not FFormCreating then
    DefaultHandler(Message);
end;

end.
