unit uDllDialogQueryParent;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllDialogParent, DB, DBClient, uExtImage, StdCtrls, ExtCtrls,
  ToolWin, ComCtrls, XwGGeneralWGrid, XwGGeneralGrid, XwGjpBasicCom,
  XWComponentType, xwbasiccomponent, xwBasicinfoComponent, uCMEventHander,
  XwTable, xwgridsclass, ugpDbGrids, ugpStdGrids, uDllComm,
  xwbasicinfoclassdefine_c, uDllDBService;

type
  TfrmDllDialogQueryParent = class(TfrmDllDialogParent)
    ToolBar: TToolBar;
    sbStatus: TStatusBar;
    allconditioninfo: TCMGLabelBtnEdit;
    PanelLeft: TPanel;
    PanelRight: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDefaultTop: Integer;
    FNoDisplayCondition: string;
    FConditionName: string;
    FStatusText: string;
    FDisplayDateTitle: Boolean;

    procedure SetStatusText(const Value: string);
  protected
    procedure SetTitle(const Value: string); override;
    procedure GjpHint(Sender : TObject);override;
    procedure ToolBtnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);override;
    procedure DoFrameWork(Sender : Tobject);override;

    procedure LoadData; override;
    procedure InitializationForm; override;

    property DefaultTop: Integer read FDefaultTop;
    property NoDisplayCondition: string read FNoDisplayCondition write FNoDisplayCondition;
    property ConditionName: string read FConditionName write FConditionName;
    property StatusText: string read FStatusText write SetStatusText;
    property DisplayDateTitle: Boolean read FDisplayDateTitle write FDisplayDateTitle;

    procedure AddUserDefineColumnByVchtype(AGrid: TXwGGeneralGrid; AVchtype: Integer = 0; AMinIndex: Integer = 1; AMaxIndex: Integer = 16);
    procedure AddFreedomColumnByVchtype(AGrid: TXwGGeneralGrid; AVchtype: Integer = 0; ADataArea: Integer = 0); virtual;
  public
    { Public declarations }
  end;


implementation

uses uBasalMethod, uDataStructure, uDllSystemIntf;

{$R *.dfm}

procedure TfrmDllDialogQueryParent.FormCreate(Sender: TObject);
begin
  ToolBar.Images := GetImageList;
  ToolBar.DisabledImages := GetDisableImageList;

  inherited;

  ToolBar.AutoSize := True;

  PanelLeft.Width := 5;
  PanelRight.Width := 5;

  pnlTitle.Height := 70;

  FNoDisplayCondition := '00000';
  FConditionName := '查询条件 ';
  FStatusText := '';
  FDisplayDateTitle := False;

  allconditioninfo.Left := 20;
  allconditioninfo.CMSelfFocusColor := True;
  allconditioninfo.FocusColor := CMSysColor.CMFaceBackColor;
  allconditioninfo.ReadOnly := True;
  allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
  allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;
end;

procedure TfrmDllDialogQueryParent.GjpHint(Sender: TObject);
begin
  inherited;

  if FStatusText = '' then
    sbStatus.SimpleText := TWinControl(Sender).Hint;
end;

procedure TfrmDllDialogQueryParent.ToolBtnMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;

  if TWinControl(Sender).ShowHint and (FStatusText = '') then
    sbStatus.SimpleText := TWinControl(Sender).Hint;
end;

procedure TfrmDllDialogQueryParent.LoadData;
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

procedure TfrmDllDialogQueryParent.InitializationForm;
begin
  SetComponentProperty;

  pnlBottom.Visible := not ToolBar.Visible;
end;

procedure TfrmDllDialogQueryParent.SetTitle(const Value: string);
begin
  inherited;

  lblTitle.Caption := Value;
  Caption := Value;
  Shape1.Width := lblTitle.Left + lblTitle.Width + 8;
end;

procedure TfrmDllDialogQueryParent.AddFreedomColumnByVchtype(
  AGrid: TXwGGeneralGrid; AVchtype, ADataArea: Integer);
var
  cdsFreedomConfig: TClientDataSet;
  szSql: string;
  nFreedomIndex: Integer;
  FColumn: TGPCustomStdColumn;
  procedure SetFreedomColumn(AColumn: TgpCustomStdColumn; TotalColumn: Boolean);
  begin
    if AColumn <> nil then
    begin
      AColumn.CustomColumnType := TCustomColumnType.FreeDom;
      AColumn.TotalColumn := TotalColumn;
    end;
  end;
begin
  if FDllParams.PubVersion2 < 2680 then
    Exit;
  if AVchtype <= 0 then
  begin
    with AGrid do
    begin
      SetFreedomColumn(CMAddField(flNMemo, '自由项1', 'FreeDom01'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项2', 'FreeDom02'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项3', 'FreeDom03'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项4', 'FreeDom04'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项5', 'FreeDom05'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项6', 'FreeDom06'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项7', 'FreeDom07'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项8', 'FreeDom08'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项9', 'FreeDom09'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项10', 'FreeDom10'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项11', 'FreeDom11'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项12', 'FreeDom12'), True);
      SetFreedomColumn(CMAddField(flNMemo, '自由项13', 'FreeDom13'), True);
      SetFreedomColumn(CMAddField(flNFourPrice, '自由项14', 'FreeDom14'), True);
      SetFreedomColumn(CMAddField(flNFourPrice, '自由项15', 'FreeDom15'), True);
      SetFreedomColumn(CMAddField(flNFourPrice, '自由项16', 'FreeDom16'), True);

      CMSetDefaultNotShow('FreeDom01');
      CMSetDefaultNotShow('FreeDom02');
      CMSetDefaultNotShow('FreeDom03');
      CMSetDefaultNotShow('FreeDom04');
      CMSetDefaultNotShow('FreeDom05');
      CMSetDefaultNotShow('FreeDom06');
      CMSetDefaultNotShow('FreeDom07');
      CMSetDefaultNotShow('FreeDom08');
      CMSetDefaultNotShow('FreeDom09');
      CMSetDefaultNotShow('FreeDom10');
      CMSetDefaultNotShow('FreeDom11');
      CMSetDefaultNotShow('FreeDom12');
      CMSetDefaultNotShow('FreeDom13');
      CMSetDefaultNotShow('FreeDom14');
      CMSetDefaultNotShow('FreeDom15');
      CMSetDefaultNotShow('FreeDom16');
    end;
    Exit;
  end;

  cdsFreedomConfig := TClientDataSet.Create(nil);
  try
    szSql := Format('SELECT columnname, FreeDomIndex, '+
                'CASE fieldnameo WHEN '''' THEN fieldname ELSE fieldnameo END AS Caption '+
                'FROM dbo.t_jxc_vchcolumn '+
                'WHERE vchtype = %0:d AND dataarea = %1:d AND FreeDomIndex BETWEEN 1 AND 16 '+
                'ORDER BY FreeDomIndex ',
                [AVchtype, ADataArea]);
    OpenSQL(szSql, cdsFreedomConfig);
    if cdsFreedomConfig.RecordCount = 0 then
      Exit;

    with AGrid, cdsFreedomConfig do
    begin
      First;
      while not Eof do
      begin
        nFreedomIndex := FieldByName('FreeDomIndex').AsInteger;
        if nFreedomIndex in [14,15,16] then
        begin
          FColumn := CMAddField(flNFourPrice, FieldByName('Caption').AsString, FieldByName('columnname').AsString);
          FColumn.TotalColumn := True;
        end
        else
        begin
          FColumn := CMAddField(flNMemo, FieldByName('Caption').AsString, FieldByName('columnname').AsString);
          FColumn.TotalColumn := nFreedomIndex in [1,2,3,4,5,6,7,8,9,10];
        end;

        FColumn.CustomColumnType := TCustomColumnType.FreeDom;

        CMSetDefaultNotShow(FieldByName('columnname').AsString);
        Next;
      end;
    end;
  finally
    FreeAndNil(cdsFreedomConfig);
  end;
end;

procedure TfrmDllDialogQueryParent.AddUserDefineColumnByVchtype(
  AGrid: TXwGGeneralGrid; AVchtype, AMinIndex, AMaxIndex: Integer);
var
  cdsUserDefined: TClientDataSet;
  szSql, szDataField: string;
  nFreedomIndex: Integer;
  FColumn: TGPCustomStdColumn;
begin
  if AVchtype <= 0 then
  begin
    with AGrid do
    begin
      if FDllParams.PubVersion2 > 2680 then
      begin
        CMAddField(flNMemo, '自定义1', 'UserDefined01').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义2', 'UserDefined02').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义3', 'UserDefined03').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义4', 'UserDefined04').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义5', 'UserDefined05').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义6', 'UserDefined06').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义7', 'UserDefined07').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义8', 'UserDefined08').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义9', 'UserDefined09').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义10', 'UserDefined10').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义11', 'UserDefined11').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义12', 'UserDefined12').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNMemo, '自定义13', 'UserDefined13').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNFourPrice,'自定义14','UserDefined14').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNFourPrice,'自定义15','UserDefined15').CustomColumnType := TCustomColumnType.UserDefined;
        CMAddField(flNFourPrice,'自定义16','UserDefined16').CustomColumnType := TCustomColumnType.UserDefined;

        CMSetDefaultNotShow('UserDefined01');
        CMSetDefaultNotShow('UserDefined02');
        CMSetDefaultNotShow('UserDefined03');

        CMSetDefaultNotShow('UserDefined04');
        CMSetDefaultNotShow('UserDefined05');
        CMSetDefaultNotShow('UserDefined06');
        CMSetDefaultNotShow('UserDefined07');
        CMSetDefaultNotShow('UserDefined08');
        CMSetDefaultNotShow('UserDefined09');
        CMSetDefaultNotShow('UserDefined10');
        CMSetDefaultNotShow('UserDefined11');
        CMSetDefaultNotShow('UserDefined12');
        CMSetDefaultNotShow('UserDefined13');
        CMSetDefaultNotShow('UserDefined14');
        CMSetDefaultNotShow('UserDefined15');
        CMSetDefaultNotShow('UserDefined16');
      end;

    end;
    Exit;
  end;

  cdsUserDefined := TClientDataSet.Create(nil);
  try
    szSql := Format('SELECT t.Caption, t.UseDefinedIndex FROM '+
                  '( SELECT CASE FieldNameo WHEN '''' THEN titlename ELSE FieldNameo END AS Caption, '+
                  '(TitleNumber - 20) AS UseDefinedIndex '+
                  'FROM dbo.t_jxc_vchtitle '+
                  'WHERE vchtype = %0:d '+
                  'AND ( datatype BETWEEN 62 AND 70 '+
                  'OR datatype BETWEEN 111 AND 117 ) ) t '+
                  'WHERE t.UseDefinedIndex BETWEEN %1:d AND %2:d '+
                  'ORDER BY t.UseDefinedIndex',
                [AVchtype, AMinIndex, AMaxIndex]);
    OpenSQL(szSql, cdsUserDefined);
    if cdsUserDefined.RecordCount = 0 then
      Exit;

    with AGrid, cdsUserDefined do
    begin
      First;
      while not Eof do
      begin
        nFreedomIndex := FieldByName('UseDefinedIndex').AsInteger;
        szDataField := Format('UserDefined%.2d', [nFreedomIndex]);
        if nFreedomIndex in [14,15,16] then
        begin
          FColumn := CMAddField(flNFourPrice, FieldByName('Caption').AsString, szDataField);
          FColumn.TotalColumn := True;
        end
        else
        begin
          FColumn := CMAddField(flNMemo, FieldByName('Caption').AsString, szDataField);
          FColumn.TotalColumn := False;
        end;

        FColumn.CustomColumnType := TCustomColumnType.UserDefined;

        CMSetDefaultNotShow(szDataField);
        Next;
      end;
    end;
  finally
    FreeAndNil(cdsUserDefined);
  end;
end;

procedure TfrmDllDialogQueryParent.DoFrameWork(Sender: Tobject);
var
  i,n : Integer;
  szTemp : String;
  szBegin,szEnd,szDate : String;
begin
  inherited;
  n := -15;
  szTemp := '';
  for I := 0 to ComponentCount - 1 do
  begin
    case StringIndex(Components[i].ClassName, C_CLASS_NAMES) of
      -1: Continue;
      Ord(cnTLabelLabel):
        begin
          with TCMGXwLabelLabel(Components[i]) do
          begin
            if FrameWork = fwConcatInfo then
            begin
              labelSplitor := ' : ';

              if CMBasictype in [CMbtDateEnd, CMbtDateBegin] then
              begin
                Visible := False;
                if CMBasictype = CMbtDateBegin then szBegin := LabelText
                else if CMBasictype = CMbtDateEnd then szEnd := LabelText;
              end
              else
              begin
                if (LabelText <> '') and (CMTypeID <> FNoDisplayCondition) then
                  szTemp := szTemp + Caption + '   ';

                Visible := False;
              end;
            end
            else if FrameWork = fwResetTop then
            begin
              Top := FDefaultTop + n + 1;
            end;
          end;
        end;
      Ord(cnTGCheckBox):
        begin
          with TCMGXwChcekBox(Components[i]) do
          begin
            if FrameWork = fwConcatInfo then
            begin
            end
            else if FrameWork = fwResetTop then
            begin
              Top := FDefaultTop + n;
            end;
          end;
        end;
      Ord(cnTLabelBtnEdit):
        begin
          with TCMGLabelBtnEdit(Components[i]) do
          begin
            if FrameWork = fwConcatInfo then
            begin
            end
            else if FrameWork = fwResetTop then
            begin
              Top := FDefaultTop + n + 1;
            end
            else if FrameWork = fwfwResetTop2 then     //add by zle @2005-06-16
              Top := FDefaultTop + 10;
          end;
        end;
      Ord(cnTLabelComboBox):
        begin
          with TCMGLabelComBox(Components[i]) do
          begin
            if FrameWork = fwConcatInfo then
            begin
            end
            else if FrameWork = fwResetTop then
            begin
              Top := FDefaultTop + n;
            end;
          end;
        end;
      Ord(cnTLabelEmptyDate):
        begin
          with TCMGLabelEmptyDate(Components[i]) do
          begin
            if FrameWork = fwConcatInfo then
            begin
            end
            else if FrameWork = fwResetTop then
            begin
              Top := FDefaultTop + n;
            end;
          end;
        end;
    end;
  end;
  if szBegin = '' then szDate := szEnd
  else if szEnd = '' then szDate := szBegin
  else szDate := szBegin+'--'+szEnd;

  if FDisplayDateTitle and (Trim(szDate) <> '') then
    szDate := '查询期间 : ' + szDate;

  szTemp := szDate + '   ' + szTemp;

  allconditioninfo.Caption := '';
  allconditioninfo.Text := szTemp;
  allconditioninfo.Hint := '';
  //allconditioninfo.Hint := ConditionName + ':' + allconditioninfo.Text;
  allconditioninfo.SendToBack;
  allconditioninfo.BorderStyle := bsNone;

  szTemp := Trim(szTemp);
  if szTemp <> '' then allconditioninfo.Visible := True;
end;

procedure TfrmDllDialogQueryParent.FormResize(Sender: TObject);
begin
  inherited;
  allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
  allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;
end;

procedure TfrmDllDialogQueryParent.FormShow(Sender: TObject);
begin
  inherited;
  DoFrameWork(Self);
  allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
  allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;
end;

procedure TfrmDllDialogQueryParent.SetStatusText(const Value: string);
begin
  FStatusText := Value;

  sbStatus.SimpleText := FStatusText;
end;

end.
