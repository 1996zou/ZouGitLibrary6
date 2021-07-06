unit uJXCQueryParent;

interface

uses
  Windows, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllMDIParent, DB, DBClient, uExtImage, StdCtrls, ExtCtrls,
  ShadowPanel, ToolWin, ComCtrls, uBasalMethod, XwGjpBasicCom,
  XWComponentType, XPMenu, XwGGeneralWGrid, XwGGeneralGrid, ugpDbGrids, ugpStdGrids,
  xwbasiccomponent, xwBasicinfoComponent, xwgridsclass, xwButtons, XwTable,
  uCMEventHander, uCMGridOperation, pngimage, uDllComm, uDllDBService,
  xwbasicinfoclassdefine_c, Generics.Collections;

type
  TfrmJXCQueryParent = class(TfrmDllMDIParent)
    PanelLeft: TPanel;
    PanelRight: TPanel;
    allconditioninfo: TCMGLabelBtnEdit;
    CMGridTools: TCMCWBackPanel;
    btnGridFilter: TCMImageButton;
    btnGridLocation: TCMImageButton;
    btnGridRef: TCMImageButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoGridFilterClick(Sender: TObject);
    procedure DoGridLocationClick(Sender: TObject);
  private
    { Private declarations }

    FDefaultTop: Integer;
    FNoDisplayCondition: string;
    FConditionName: string;
    FStatusText: string;
    procedure SetStatusText(const Value: string);
    procedure FindGridToOperation;
    procedure AfterLoadData(Sender: TObject);
  protected
    FGridOperation: CMGridOperation;
    procedure SetTitle(const Value: string); override;
    procedure GjpHint(Sender : TObject);override;
    procedure ToolBtnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);override;
    procedure DoFrameWork(Sender : Tobject);override;
    procedure LoadData; override;
    procedure LoadDataWithParams(TargetGrid:TComponent;TargetDataSet:TClientDataSet;SetComponent:Boolean = True);
    procedure DictionaryToParams(AParams: TDictionary<string, string>; Key: string; ABasicType: TCMBasicType);

    procedure SetGridProperty(GeneralGrid: TXwGGeneralGrid); override;
    procedure SetWGridProperty(GeneralWGrid: TXwGGeneralWGrid); override;

    procedure AddUserDefineColumnByVchtype(AGrid: TXwGGeneralGrid; AVchtype: Integer = 0; AMinIndex: Integer = 1; AMaxIndex: Integer = 16);
    procedure AddFreedomColumnByVchtype(AGrid: TXwGGeneralGrid; AVchtype: Integer = 0; ADataArea: Integer = 0); virtual;

    property NoDisplayCondition: string read FNoDisplayCondition write FNoDisplayCondition;
    property ConditionName: string read FConditionName write FConditionName;
    property StatusText: string read FStatusText write SetStatusText;
  public
    destructor Destroy; override;
  end;


implementation

uses uDataStructure, uOperationFunc, uGridFilter, uGridLocate;

{$R *.dfm}

procedure TfrmJXCQueryParent.FormCreate(Sender: TObject);
begin
  inherited;
  FGridOperation := CMGridOperation.Create(nil);
  FDefaultTop := 57;
  PanelLeft.Width := 8;
  PanelRight.Width := 8;

  pnlTitle.Height := 85;

  ToolBar.AutoSize := True;
//  TGridTools.AutoSize := true;
  ShadowPanel1.Left :=  (pnlTitle.Width - ShadowPanel1.Width) div 2;
  ShadowPanel1.Top := 10;
  ShadowPanel1.FaceColor := CMSYSCOLOR.CMFaceBackColor;
  ShadowPanel1.ShadowColor := CMSysColor.CMFaceBackColor;
  ShadowPanel1.ShadowOffset := 0;
  ShadowPanel1.Width := 150;
  ShadowPanel1.Height := 36;
  lblTitle.Font.Size := 18;
  FNoDisplayCondition := '00000';
  FConditionName := '查询条件 ';
  FStatusText := '';
  if ShowBaseOption() then
    StatusText:='由于系统管理了基本信息权限，表格可能没有统计所有数据。';


  allconditioninfo.Left := 20;
  allconditioninfo.Font.Height := -12;
  allconditioninfo.CMSelfFocusColor := True;
  allconditioninfo.FocusColor := CMSysColor.CMFaceBackColor;
  allconditioninfo.ReadOnly := True;
  allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
  allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;

  btnGridFilter.Hint := '过滤';
  btnGridLocation.Hint := '定位';
  btnGridRef.Hint := '刷新';
  btnGridFilter.ShowHint := True;
  btnGridLocation.ShowHint := True;
  btnGridRef.ShowHint := True;
  if CMGridTools.Visible then
    CMGridTools.Visible := FDllParams.PubVersion2 <> 680
end;

destructor TfrmJXCQueryParent.Destroy;
begin
  inherited;
  FreeAndNil(FGridOperation);
end;

procedure TfrmJXCQueryParent.DictionaryToParams(
  AParams: TDictionary<string, string>; Key: string; ABasicType: TCMBasicType);
var
  Value: string;
begin
  if AParams.TryGetValue(Key, Value) then
    Params[Ord(ABasicType)] := Value;
end;

procedure TfrmJXCQueryParent.FormResize(Sender: TObject);
begin
  inherited;

  if WindowState <> wsMinimized then
  begin
    ShadowPanel1.Width := lblTitle.Left + lblTitle.Width + 8;
    ShadowPanel1.Left := (pnlTitle.Width-ShadowPanel1.Width) div 2;
    allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
    allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;
  end;
end;

procedure TfrmJXCQueryParent.FormShow(Sender: TObject);
begin
  inherited;
  DoFrameWork(Self);
  FindGridToOperation;
//  FGridOperation.AddGrid(GetFirstGrid);
  ShadowPanel1.Width := lblTitle.Left + lblTitle.Width + 8;
  ShadowPanel1.Left := (pnlTitle.Width-ShadowPanel1.Width) div 2;
  allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
  allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;
  if CMGridTools.Visible then
  begin
    CMGridTools.Top := pnlTitle.Height - CMGridTools.Height - 2;
    if btnGridRef.Visible then
      CMGridTools.Left := pnlTitle.Width - CMGridTools.Width - 20
    else
      CMGridTools.Left := pnlTitle.Width - CMGridTools.Width + 15;
  end;
end;

procedure TfrmJXCQueryParent.GjpHint(Sender: TObject);
begin
  inherited;

//  if FStatusText = '' then
//    sbStatus.SimpleText := TWinControl(Sender).Hint;
end;

procedure TfrmJXCQueryParent.ToolBtnMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;

//  if TWinControl(Sender).ShowHint and (FStatusText = '') then
//    sbStatus.SimpleText := TWinControl(Sender).Hint;
end;

procedure TfrmJXCQueryParent.DoGridFilterClick(Sender: TObject);
begin
  inherited;

  if Assigned(FGridOperation.ActiveGrid) and FGridOperation.ActiveGrid.UseNewGridFilter then
    ShowGridFilterForm(FGridOperation.ActiveGrid)
  else
    FGridOperation.ShowFilterForm;
end;

procedure TfrmJXCQueryParent.DoGridLocationClick(Sender: TObject);
begin
  inherited;

  if Assigned(FGridOperation.ActiveGrid) then
    ShowGridLocateForm(FGridOperation.ActiveGrid);
//  FGridOperation.ShowLocationForm;
end;

procedure TfrmJXCQueryParent.DoFrameWork(Sender: Tobject);
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

              if (not CMAlwaysAloneShow) and (CMBasictype in [CMbtDateEnd, CMbtDateBegin]) then
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
  else szDate := szBegin + '--' + szEnd;

  szTemp := szDate + '   ' + szTemp;

  allconditioninfo.Caption := '';
  allconditioninfo.Text := szTemp;
  allconditioninfo.Hint := ConditionName + ':' + allconditioninfo.Text;
  allconditioninfo.SendToBack;
  allconditioninfo.BorderStyle := bsNone;

  szTemp := Trim(szTemp);

  if szTemp <> '' then allconditioninfo.Visible := True;
end;

procedure TfrmJXCQueryParent.SetTitle(const Value: string);
begin
  inherited;

  lblTitle.Caption := Value;
  Caption := Value;
  ShadowPanel1.Width := lblTitle.Left + lblTitle.Width + 8;
  ShadowPanel1.Left := (pnlTitle.Width - ShadowPanel1.Width) div 2;//-10;
end;

procedure TfrmJXCQueryParent.FindGridToOperation;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if UpperCase(Components[i].ClassName) = UpperCase('TXwGGeneralGrid') then
    begin
      TXwGGeneralGrid(Components[i]).AfterLoadData := AfterLoadData;
      FGridOperation.AddGrid(TXwGGeneralGrid(Components[i]));
    end;
  end;
end;

procedure TfrmJXCQueryParent.AddFreedomColumnByVchtype(AGrid: TXwGGeneralGrid;
  AVchtype, ADataArea: Integer);
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

procedure TfrmJXCQueryParent.AddUserDefineColumnByVchtype(AGrid: TXwGGeneralGrid;
    AVchtype, AMinIndex, AMaxIndex: Integer);
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

procedure TfrmJXCQueryParent.AfterLoadData(Sender: TObject);
begin
  FGridOperation.ClearFilterData(TXwGGeneralGrid(Sender));
end;

procedure TfrmJXCQueryParent.LoadDataWithParams(TargetGrid:TComponent;TargetDataSet:TClientDataSet;SetComponent:Boolean = True);
begin
  try
    if not TargetDataSet.Active then Exit;
    Screen.Cursor := crSQLWait;
    TargetDataSet.First;
    if UpperCase(TargetGrid.ClassName) = UpperCase('TXwGGeneralGrid') then
    begin
      with TXwGGeneralGrid(TargetGrid) do
      begin
        MenuOptions := MenuOptions - [moExpand];
        DataSet := TargetDataSet;
      end;    // with
    end
    else
    if UpperCase(TargetGrid.ClassName) = UpperCase('TXwGGeneralWGrid') then
    begin
      with TXwGGeneralWGrid(TargetGrid) do
      begin
        MenuOptions := MenuOptions - [moExpand];
        DataSet := TargetDataSet;
      end;
    end;
    if SetComponent then
      SetComponentProperty;
  finally
    Screen.Cursor := crDefault;
  end;

end;

procedure TfrmJXCQueryParent.SetGridProperty(GeneralGrid: TXwGGeneralGrid);
begin
  inherited;

  if FDllParams.PubVersion2 <= 2680 then
    GeneralGrid.CMHideMtypeColumn := True;
end;

procedure TfrmJXCQueryParent.SetWGridProperty(GeneralWGrid: TXwGGeneralWGrid);
begin
  inherited;

  if FDllParams.PubVersion2 <= 2680 then
    GeneralWGrid.CMHideMtypeColumn := True;
end;

procedure TfrmJXCQueryParent.LoadData;
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
          ResetShowFooter;
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
          ResetShowFooter;
        end;    // with
        Break;
      end;
    end;    // for
    SetComponentProperty;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmJXCQueryParent.SetStatusText(const Value: string);
begin
  FStatusText := Value;

  sbStatus.SimpleText := FStatusText;
end;

end.

