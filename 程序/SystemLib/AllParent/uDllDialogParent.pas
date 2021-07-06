unit uDllDialogParent;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllGraspForm, uExtImage, ExtCtrls, StdCtrls, DB, DBClient, XwTable,
  XwGGeneralWGrid, XwGGeneralGrid, XwGjpBasicCom,
  uCMEventHander, xwgridsclass;

type
  TfrmDllDialogParent = class(TDllGraspForm)
    pnlTitle: TCMCWBackPanel;
    pnlBottom: TCMCWMaroonPanel;
    pnlEntry: TCMCWBackPanel;
    Shape2: TShape;
    Shape1: TShape;
    lblTitle: TLabel;
    cdsGetRecordSet: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FPrintHandler: TPrintHandler;

    procedure SetPrintID(const Value: Integer);
    procedure SetPrintTemplate(const Value: string);
    function GetPrintID: Integer;
    function GetPrintTemplate: string;
  protected
    procedure SetTitle(const Value: string); override;
    procedure LoadData; override;
    procedure InitializationForm; override; //初始化界面

    procedure CreatePrintHandler(btnExpertPrint: TCMXwPrintBtn);
  public
    { Public declarations }
    property PrintID: Integer read GetPrintID write SetPrintID;
    property PrintTemplate: string read GetPrintTemplate write SetPrintTemplate;
  end;


implementation

uses uOperationFunc;

{$R *.dfm}

procedure TfrmDllDialogParent.FormCreate(Sender: TObject);
begin
  inherited;
  pnlBottom.BevelInner := bvNone;
  pnlBottom.BevelInner := bvNone;
  pnlBottom.NoPaint := True;
  Shape1.Brush.Color := StrToIntDef(GetConfig('Title.PanelColor', ''), $00F4C664);

  UseClassName := Self.ClassName;
end;

procedure TfrmDllDialogParent.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GetComponentProperty;
  inherited;
  if Assigned(FPrintHandler) then
    FreeAndNil(FPrintHandler);
end;

procedure TfrmDllDialogParent.SetTitle(const Value: string);
var
  i: Integer;
begin
  inherited;

  lblTitle.Caption := Value;
  Caption := Value;
  Shape1.Width := lblTitle.Left + lblTitle.Width + 8;
  Shape2.Width := Shape1.Width;

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

procedure TfrmDllDialogParent.CreatePrintHandler(btnExpertPrint: TCMXwPrintBtn);
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

procedure TfrmDllDialogParent.LoadData;
var
  I: Integer;
begin
  try
    if not cdsGetRecordSet.Active then Exit;

    Screen.Cursor := crSQLWait;
    cdsGetRecordSet.First;
    for I := 0 to ComponentCount - 1 do    // Iterate
    begin
      if UpperCase(Components[i].ClassName) = UpperCase('TXwGGeneralGrid') then
      begin
        with TXwGGeneralGrid(Components[i]) do
        begin
          MenuOptions := MenuOptions - [moExpand];
          DataSet := cdsGetRecordSet;
        end;    // with
        Break;
      end
      else
      if UpperCase(Components[i].ClassName) = UpperCase('TXwGGeneralWGrid') then
      begin
        with TXwGGeneralWGrid(Components[i]) do
        begin
          MenuOptions := MenuOptions - [moExpand];
          DataSet := cdsGetRecordSet;
        end;    // with
        Break;
      end;
    end;    // for
    SetComponentProperty;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmDllDialogParent.InitializationForm;
begin
  inherited;
  LoadTitleData;
end;

function TfrmDllDialogParent.GetPrintID: Integer;
begin
  Result := FPrintHandler.PrintID;
end;

function TfrmDllDialogParent.GetPrintTemplate: string;
begin
  Result := FPrintHandler.PrintTemplate;
end;

procedure TfrmDllDialogParent.SetPrintID(const Value: Integer);
begin
  FPrintHandler.PrintID := Value;
end;

procedure TfrmDllDialogParent.SetPrintTemplate(const Value: string);
begin
  FPrintHandler.PrintTemplate := Value;
end;

end.
