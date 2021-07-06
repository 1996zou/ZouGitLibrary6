unit uDllMDIQueryParent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllMDIParent, DB, DBClient, ComCtrls, uExtImage, StdCtrls,
  ExtCtrls, ShadowPanel, ToolWin, XwGjpBasicCom,
  XWComponentType, XPMenu, xwbasiccomponent, xwBasicinfoComponent,
  XwGGeneralWGrid, XwGGeneralGrid, uCMEventHander, XwTable, xwgridsclass;

type
  TfrmDllMDIQueryParent = class(TfrmDllMDIParent)
    PanelLeft: TPanel;
    PanelRight: TPanel;
    allconditioninfo: TCMGLabelBtnEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDefaultTop: Integer;
    FNoDisplayCondition: string;
    FConditionName: string;
    FStatusText: string;

  protected
    procedure SetTitle(const Value: string); override;
    procedure GjpHint(Sender : TObject);override;
    procedure ToolBtnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);override;
    procedure DoFrameWork(Sender : Tobject);override;
    procedure LoadData; override;

    property NoDisplayCondition: string read FNoDisplayCondition write FNoDisplayCondition;
    property ConditionName: string read FConditionName write FConditionName;
  public
    { Public declarations }
  end;


implementation

uses uDataStructure;

{$R *.dfm}

procedure TfrmDllMDIQueryParent.FormCreate(Sender: TObject);
begin
  inherited;
  //财务报表部分不显示status
  sbStatus.Visible := False;

  FDefaultTop := 57;
  PanelLeft.Width := 8;
  PanelRight.Width := 8;

  pnlTitle.Height := 85;

  ToolBar.AutoSize := True;
  ShadowPanel1.Left :=  (pnlTitle.Width - ShadowPanel1.Width) div 2;
  ShadowPanel1.Top := 10;
  ShadowPanel1.FaceColor := CMSysColor.CMFaceBackColor;
  ShadowPanel1.ShadowColor := CMSysColor.CMFaceBackColor;
  ShadowPanel1.ShadowOffset := 0;
  ShadowPanel1.Width := 150;
  ShadowPanel1.Height := 36;
  lblTitle.Font.Size := 18;
  FNoDisplayCondition := '00000';
  FConditionName := '查询条件 ';
  FStatusText := '';

  allconditioninfo.Left := 20;
  allconditioninfo.CMSelfFocusColor := True;
  allconditioninfo.FocusColor := CMSysColor.CMFaceBackColor;
  allconditioninfo.ReadOnly := True;
  allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
  allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;

//  ToolBar.Color := CMSysColor.CMToolBarBackColor;
end;

procedure TfrmDllMDIQueryParent.FormResize(Sender: TObject);
begin
  inherited;
  ShadowPanel1.Left := (pnlTitle.Width-ShadowPanel1.Width) div 2;
  allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
  allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;
end;

procedure TfrmDllMDIQueryParent.FormShow(Sender: TObject);
begin
  inherited;
  DoFrameWork(Self);
  ShadowPanel1.Left := (pnlTitle.Width-ShadowPanel1.Width) div 2;
  allconditioninfo.Width := pnlTitle.Width - allconditioninfo.Left - 20;
  allconditioninfo.Top := pnlTitle.Height - allconditioninfo.Height + 2;
end;

procedure TfrmDllMDIQueryParent.GjpHint(Sender: TObject);
begin
  inherited;
  
//  if FStatusText = '' then
//    sbStatus.SimpleText := TWinControl(Sender).Hint;
end;

procedure TfrmDllMDIQueryParent.ToolBtnMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
//  if TWinControl(Sender).ShowHint and (FStatusText = '') then
//    sbStatus.SimpleText := TWinControl(Sender).Hint;
end;

procedure TfrmDllMDIQueryParent.DoFrameWork(Sender: Tobject);
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
    if Components[i] is TCMGXwLabelLabel then
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
    end
    else if Components[i] is TCMGXwChcekBox then
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
    end
    else if Components[i] is TCMGLabelBtnEdit then
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
    end
    else if Components[i] is TCMGLabelComBox then
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
    end
    else if Components[i] is TCMGLabelEmptyDate then
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

  if szBegin='' then szDate := szEnd
  else if szEnd='' then szDate := szBegin
  else szDate := szBegin+'--'+szEnd;

  szTemp := szDate + '   ' + szTemp;

  allconditioninfo.Caption := '';
  allconditioninfo.Text := szTemp;
  allconditioninfo.Hint := ConditionName + ':' + allconditioninfo.Text;
  allconditioninfo.SendToBack;
  allconditioninfo.BorderStyle := bsNone;

  szTemp := Trim(szTemp);
  if szTemp <> '' then allconditioninfo.Visible := True;
end;

procedure TfrmDllMDIQueryParent.SetTitle(const Value: string);
begin
  inherited;
  
  lblTitle.Caption := Value;
  Caption := Value;
  ShadowPanel1.Width := lblTitle.Left + lblTitle.Width + 8;
  ShadowPanel1.Left := (pnlTitle.Width - ShadowPanel1.Width) div 2;//-10;
end;

procedure TfrmDllMDIQueryParent.LoadData;
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

end.
