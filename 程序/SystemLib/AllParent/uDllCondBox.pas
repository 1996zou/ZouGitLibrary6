unit uDllCondBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uDllDialogParent, ExtCtrls, StdCtrls, Buttons, XWComponentType,
  ComCtrls, Db, DBClient, uDllGraspForm, uOperationFunc,
  xwbasiccomponent, XwGjpBasicCom, uExtImage, xwBasicinfoComponent,
  uBasalMethod, Variants, uDllDataBaseIntf, uDllDBService, uTransformFunc, xwgtypedefine,
  xwButtons, xwbasicinfoclassdefine_c, uDllExistIntf, uCMEventHander,
  uDataStructure, RzButton, RzRadChk;

type
  TControlType = (ctRadioButton, ctCheckBox,
    ctButtonEdit, ctRadioGroup, ctComboBox, ctMemo, ctDate, ctEmptyDate,
    ctEdit, ctValueComBoBox);

  TConditionSet = record
    CustomCaptionNo: Integer;
    ConditionType: TCMBasicType;
    XWBasicType: TBasicType;
    DisplayValue: TStrings;
    ReturnValue: TStrings;
    SelectOptions: TCMBaseSelectOptions;
    ControlType: TControlType;
    DataType: TCMDataType;
    DataDecimal: Integer;  //小数位数
    Disabled: Boolean; // 是否无效，缺省为False;
    Invisible: Boolean; // 是否不显示，缺省为False
    Required: Boolean; // 是否允许为空，如果是数字则不能为0，基本信息类则必须选择，缺省为False;
    ReadOnly: Boolean; // 是否允许可手写
    Tag: Integer;
    Rec: Integer;
    Checked: Boolean;
    Caption: string;
    CanModifyLabel: Boolean; //仅对于btnedit有效 设置CanModifyCaption
    BtnEditFieldsList: TFieldsList; //设置btnedit的fieldslist
    MaxValue: Double;
    MinValue: Double;
    MaxDate: string;
    MinDate: string;
    MaxLength: Integer;
    CanModifySelectEdit: Boolean;  //是否能修改基本信息选择框
    CustomCode:string;  //自定义代码标识 用于处理特殊情况
    Vchtype: string;
  end;

  TCondition = record
    ConditionSet: array of TConditionSet;
    Title: string;
    TitleNo: integer;
    ImageIndex: Integer;
    NO: Integer; // 表示该查询查询所在模块的Title对应stringno
                //定义后可以在确定按钮校验代码
  end;

  TfrmDllCondBox = class(TfrmDllDialogParent)
    imgTitle: TImage;
    Bevel1: TBevel;
    cbxSaveDate: TCMGXwChcekBox;
    btnOK: TCMGXwBitbtn;
    btnCancel: TCMGXwBitbtn;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    FListControl: TList;
    FFirstControl: TWinControl;
    FCondition: TCondition;
    FShowSaveDate: Boolean;
    FBeginDateCondSet: TConditionSet;
    FEndDateCondSet: TConditionSet;

    procedure InitSaveDate;
    procedure DoKeyDown(Sender : TObject;var Key: Word; Shift: TShiftState);
    procedure DateSpaceComBoxChange(Sender: TObject);
    procedure AddDateRages(var TopIndex: Integer);
  protected
    procedure InitializationForm; override; //初始化界面
    function ExitCheck: Boolean;
    procedure LoadTitleData; override;
    procedure BeforeSelectBaseInfo(Sender: TObject;
      var ABaseType: TCMBaseInfoType; var szSearchType: Char;
      var szSearchString, szKTypeID, szAssistant1, szAssistant2: string; var ASubjectType: TCMSubjectType;
      var ASelectOptions: TCMBaseSelectOptions; var ContinueProc: Boolean); override;
  public
    { Public declarations }
  end;

function GetCondition(var AParams: variant;
  ACondition: TCondition; AUnitType: TUnitType = utJxc; ShowSaveDate: Boolean = True): Boolean;

procedure FreeCondition(ACondition: TCondition); //手工释放查询条件中使用TStringList

procedure ResetCondition(out ACondition:TCondition);

//Add by fhying 2004-07-08 To 增加一个接口，可以返回类型为btlmode,btcmode,btctype的控件
//对应的Caption的值。
function GetConditionNew(var AParams: Variant; ACondition: TCondition;
  var AParamslMode: string; var AParamscMode: string;
  var AParamscType: string; AUnitType: TUnitType = utJxc; ShowSaveDate: Boolean = True): Boolean;

implementation

uses DateCommon, uDllMessageIntf, uDllSystemIntf;

{$R *.DFM}

const

  LEFTBORDER = 135; //左边距
  TOPBORDER = 30;
  BOTTOMBORDER = 15; //底边距
  CONTROLWIDTH = 243;//180;//150
  CONTROLSPACE = 10;
  RIGHTBORDER = 30;

//接口函数

function GetCondition(var AParams: variant;
  ACondition: TCondition; AUnitType: TUnitType = utJxc; ShowSaveDate: Boolean = True): Boolean;
begin
  with TfrmDllCondBox.Create(Application) do
  begin
    try
      UnitType := AUnitType;
      FCondition := ACondition;
      FShowSaveDate := ShowSaveDate;
      Params := AParams;
      Result := ShowModal = mrOk;
      if Result then
        AParams := Params;
    finally
      Free;
    end;
  end;
end;

function GetConditionNew(var AParams: Variant; ACondition: TCondition;
  var AParamslMode: string; var AParamscMode: string;
  var AParamscType: string; AUnitType: TUnitType = utJxc; ShowSaveDate: Boolean = True): Boolean;
begin
  with TfrmDllCondBox.Create(Application) do
  begin
    try
      UnitType := AUnitType;
      FCondition := ACondition;
      FShowSaveDate := ShowSaveDate;
      Params := AParams;
      Result := ShowModal = mrOK;
      if Result then
      begin
        AParams := Params;
        AParamslMode := FParamsLModeStr;
        AParamscMode := FParamsCModeStr;
        AParamscType := FParamsCTypeStr;
      end;
    finally
      Free;
    end;
  end;
end;

procedure FreeCondition(ACondition: TCondition);
var
  i: Integer;
begin
  for i := Low(ACondition.ConditionSet) to High(ACondition.ConditionSet) do
  begin
    if Assigned(ACondition.ConditionSet[i].DisplayValue) then
      FreeAndNil(ACondition.ConditionSet[i].DisplayValue);
    if Assigned(ACondition.ConditionSet[i].ReturnValue) then
      FreeAndNil(ACondition.ConditionSet[i].ReturnValue);
  end;
end;

procedure ResetCondition(out ACondition: TCondition);
begin
  with ACondition do
  begin
    SetLength(ConditionSet,0);
    Title :='';
    TitleNo := 0;
    ImageIndex := 0;
    NO := 0;
  end;
end;

//初始化界面
procedure TfrmDllCondBox.InitializationForm;
var
  needDateSpace, hasBeginEdit, hasEndEdit: Boolean;
  i, J: Integer;
begin
  hasBeginEdit := False;
  hasEndEdit := False;
  for i := Low(FCondition.ConditionSet) to High(FCondition.ConditionSet) do
  begin
    if FCondition.ConditionSet[I].ConditionType = CMbtDateBegin then
    begin
      hasBeginEdit := True;
      FBeginDateCondSet := FCondition.ConditionSet[I];
    end
    else if FCondition.ConditionSet[I].ConditionType = CMbtDateEnd then
    begin
      hasEndEdit := True;
      FEndDateCondSet := FCondition.ConditionSet[I];
    end;
  end;
  needDateSpace := hasBeginEdit and hasEndEdit;

  InitSaveDate;

  OnBeforeSelectBaseInfo := BeforeSelectBaseInfo;

  pnlTitle.Visible := False;
  cbxSaveDate.Visible := False;
  J := TOPBORDER;
  if (FCondition.Title <> '') then
    Title := FCondition.Title
  else
    Title := GetStringsFromStringNo(FCondition.TitleNo);

  imgTitle.Picture.Bitmap.FreeImage;
  GetCondBoxImage.GetBitmap(FCondition.ImageIndex, imgTitle.Picture.Bitmap);

  if needDateSpace then
    AddDateRages(J);

  //动态显示界面控件
  for i := Low(FCondition.ConditionSet) to High(FCondition.ConditionSet) do
  begin
    case FCondition.ConditionSet[I].ControlType of
    {
      ctRadioButton:
        begin
          with TGRadioButton.Create(Self) do
          begin
            FListControl.Add(TWinControl(Owner));
            if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
            begin
              CustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
              ShowCustomCaption := True;
            end
            else if FCondition.ConditionSet[i].Caption <> '' then
            begin
              ShowCustomCaption := True;
              Caption := FCondition.ConditionSet[i].Caption;
            end;
            BasicType := FCondition.ConditionSet[I].ConditionType;
            Parent := pnlEntry;
            Left := LEFTBORDER;
            Width := CONTROLWIDTH;
            Top := J;
            J := J + Height + CONTROLSPACE;
            Visible := not FCondition.ConditionSet[i].Invisible;
            Enabled := not FCondition.ConditionSet[i].Disabled;
            if not Assigned(FFirstControl) then
            begin
              FFirstControl := TWinControl(Owner);
              SetFocus;
            end;
          end; // with
        end;
        }
      ctCheckBox:
        begin
          with TCMGXwChcekBox.Create(Self) do
          begin
            FListControl.Add(TWinControl(Owner));
            if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
            begin
              CMCustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
              CMShowCustomCaption := True;
            end
            else if FCondition.ConditionSet[i].Caption <> '' then
            begin
              CMShowCustomCaption := True;
              Caption := FCondition.ConditionSet[i].Caption;
            end
            else
              CMShowCustomCaption := False;

            CMBasicType := FCondition.ConditionSet[I].ConditionType;
            Parent := pnlEntry;
            //此处Checked赋值没有实际效果，Checked属性在uGraspForm单元中使用SetComponentProperty重新赋值 "Checked := StrToInteger(Params[Ord(Basictype)]) > 0"
            Checked := FCondition.ConditionSet[I].Tag <> 0;
            Left := LEFTBORDER;
            Width := CONTROLWIDTH;
            Top := J;
            J := J + Height + CONTROLSPACE;
            Visible := not FCondition.ConditionSet[i].Invisible;
            Enabled := not FCondition.ConditionSet[i].Disabled;
            if not Assigned(FFirstControl) then
            begin
              if (not FCondition.ConditionSet[i].Disabled) and (not FCondition.ConditionSet[i].Invisible) then
              begin
                FFirstControl := TWinControl(Owner);
                SetFocus;
              end;
            end;
          end; // with
        end;
      ctEdit:
        begin
          with TCMGLabelBtnEdit.Create(Self) do
          begin
            FListControl.Add(TWinControl(Owner));

            BasicRecord := GetBasicRecordAll_C;
            BasicType := FCondition.ConditionSet[I].XWBasicType;

            if FCondition.ConditionSet[I].CanModifyLabel then
            begin
              if FCondition.ConditionSet[I].BtnEditFieldsList <> flNull then
                FieldsList := FCondition.ConditionSet[I].BtnEditFieldsList
              else
                FieldsList := GetBasicFieldName(BasicType);

              CanModifyCaption := FCondition.ConditionSet[I].CanModifyLabel;
            end;

            if not CanModifyCaption then
            begin
              if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
              begin
                CMCustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
                CMShowCustomCaption := True;
              end
              else if FCondition.ConditionSet[i].Caption <> '' then
              begin
                CMShowCustomCaption := True;
                Caption := FCondition.ConditionSet[i].Caption;
              end
              else
                CMShowCustomCaption := False;
            end;
              
            if FCondition.ConditionSet[I].ControlType = ctEdit then
            begin
              BtnVisible := False;
            end;

            FocusColor := CMSysColor.CMEditInputFocusColor;
            Color := CMSysColor.CMEditInputFocusColor;

            CanLeaveEmpty := False;
            CMDataType := FCondition.ConditionSet[I].DataType;
            CMBasicType := FCondition.ConditionSet[I].ConditionType;
            if FCondition.ConditionSet[I].DataDecimal <> 0 then
              CMDigits := FCondition.ConditionSet[I].DataDecimal;

            MaxLength := FCondition.ConditionSet[I].MaxLength;
            DataTypes.MaxValue := FCondition.ConditionSet[I].MaxValue;
            DataTypes.MinValue := FCondition.ConditionSet[I].MinValue;

            CMRunSelectBase := False;
            BasicinfoEditBandType := bebtOther;
            CMSelectOptions := FCondition.ConditionSet[I].SelectOptions;
            Tag := FCondition.ConditionSet[I].Tag;
            CMRec := FCondition.ConditionSet[I].Rec;
            if CMBasicType = CMbtOperatingType then
            begin
              CMRec := Params[Ord(CMbtAssThree)];
            end;

            if CMBasicType = CMbtPMtype then
            begin
              CMRec := Params[Ord(CMbtTrueStock)];
            end;

            DisplayStar := FCondition.ConditionSet[I].Required;
            Vchtype := FCondition.ConditionSet[I].Vchtype;

            LabelSpacing := 5;
            Parent := pnlEntry;
            Left := LEFTBORDER;
            Width := CONTROLWIDTH;
            Top := J;
            J := J + Height + CONTROLSPACE;
            ReadOnly := FCondition.ConditionSet[i].ReadOnly;
            Visible := not FCondition.ConditionSet[i].Invisible;
            Enabled := not FCondition.ConditionSet[i].Disabled;
            if not Assigned(FFirstControl) then
            begin
              if (not FCondition.ConditionSet[i].Disabled) and (not FCondition.ConditionSet[i].Invisible) then
              begin
                FFirstControl := TWinControl(Owner);
                SetFocus;
              end;
            end;
          end;
        end;
      ctButtonEdit:
        begin
          with TCMGLabelBtnEdit.Create(Self) do
          begin
            FListControl.Add(TWinControl(Owner));

            BasicRecord := GetBasicRecordAll_C;
            BasicType := FCondition.ConditionSet[I].XWBasicType;

            if FCondition.ConditionSet[I].CanModifyLabel then
            begin
              if FCondition.ConditionSet[I].BtnEditFieldsList <> flNull then
                FieldsList := FCondition.ConditionSet[I].BtnEditFieldsList
              else
                FieldsList := GetBasicFieldName(BasicType);

              CanModifyCaption := FCondition.ConditionSet[I].CanModifyLabel;
            end;

            if not CanModifyCaption then
            begin
              if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
              begin
                CMCustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
                CMShowCustomCaption := True;
              end
              else if FCondition.ConditionSet[i].Caption <> '' then
              begin
                CMShowCustomCaption := True;
                Caption := FCondition.ConditionSet[i].Caption;
              end
              else
                CMShowCustomCaption := False;
            end;

            if FCondition.ConditionSet[I].ControlType = ctEdit then
            begin
              BtnVisible := False;
            end;

            FocusColor := CMSysColor.CMEditInputFocusColor;
            Color := CMSysColor.CMEditInputFocusColor;

            MaxLength := FCondition.ConditionSet[I].MaxLength;
            CMDataType := FCondition.ConditionSet[I].DataType;
            CMBasicType := FCondition.ConditionSet[I].ConditionType;
            if FCondition.ConditionSet[I].DataDecimal <> 0 then
              CMDigits := FCondition.ConditionSet[I].DataDecimal;

            CMRunSelectBase := True;
            CMSelectOptions := FCondition.ConditionSet[I].SelectOptions;
            Tag := FCondition.ConditionSet[I].Tag;
            CMRec := FCondition.ConditionSet[I].Rec;
            if CMBasicType = CMbtOperatingType then
            begin
              CMRec := Params[Ord(CMbtAssThree)];
            end;

            if CMBasicType = CMbtPMtype then
            begin
              CMRec := Params[Ord(CMbtTrueStock)];
            end;

            Vchtype := FCondition.ConditionSet[I].Vchtype;

            LabelSpacing := 5;
            Parent := pnlEntry;
            Left := LEFTBORDER;
            Width := CONTROLWIDTH;
            Top := J;
            J := J + Height + CONTROLSPACE;
            ReadOnly := FCondition.ConditionSet[i].ReadOnly;
            Visible := not FCondition.ConditionSet[i].Invisible;
            Enabled := not FCondition.ConditionSet[i].Disabled;
            if FCondition.ConditionSet[I].CanModifySelectEdit then
              BasicinfoEditBandType := bebtOther;

            if not Assigned(FFirstControl) and TWinControl(Owner).Enabled then
            begin
              if (not FCondition.ConditionSet[i].Disabled) and (not FCondition.ConditionSet[i].Invisible) then
              begin
                FFirstControl := TWinControl(Owner);
                SetFocus;
              end;
            end;
          end;
        end;
     { ctRadioGroup:
        begin
          if Assigned(FCondition.ConditionSet[I].DisplayValue) then
            with TGRadioGroup.Create(Self) do
            begin
              FListControl.Add(TWinControl(Owner));
              BasicType := FCondition.ConditionSet[I].ConditionType;
              Parent := pnlEntry;
              Left := LEFTBORDER;
              Width := CONTROLWIDTH;
              Top := J;
              J := J + Height + CONTROLSPACE;
              Visible := not FCondition.ConditionSet[i].Invisible;
              Enabled := not FCondition.ConditionSet[i].Disabled;
              ItemIndex := FCondition.ConditionSet[i].Tag;
              if not Assigned(FFirstControl) then
              begin
                FFirstControl := TWinControl(Owner);
                SetFocus;
              end;
                //for iCount := 0 to FCondition.ConditionSet[I].DisplayValue.Count - 1 do
              if Assigned(FCondition.COnditionSet[I].DisplayValue) then
              begin
                Items.Assign(FCondition.ConditionSet[I].DisplayValue);
              end;
            end;
        end;   }
      ctComboBox:
        begin
          if Assigned(FCondition.ConditionSet[I].DisplayValue) then
            with TCMGLabelComBox.Create(Self) do
            begin
              FListControl.Add(TWinControl(Owner));
              if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
              begin
                CMCustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
                CMShowCustomCaption := True;
              end
              else if FCondition.ConditionSet[i].Caption <> '' then
              begin
                CMShowCustomCaption := True;
                Caption := FCondition.ConditionSet[i].Caption;
              end
              else
                CMShowCustomCaption := False;
              
              Style := csDropDownList;
              CMBasicType := FCondition.ConditionSet[I].ConditionType;
              Parent := pnlEntry;
              Left := LEFTBORDER;
              Width := CONTROLWIDTH;
              Top := J;
              J := J + Height + CONTROLSPACE;
              Visible := not FCondition.ConditionSet[i].Invisible;
              Enabled := not FCondition.ConditionSet[i].Disabled;
              if not Assigned(FFirstControl) then
              begin
                if (not FCondition.ConditionSet[i].Disabled) and (not FCondition.ConditionSet[i].Invisible) then
                begin
                  FFirstControl := TWinControl(Owner);
                  SetFocus;
                end;
              end;

              if Assigned(FCondition.COnditionSet[I].DisplayValue) then
              begin
                Items.Assign(FCondition.ConditionSet[I].DisplayValue);
                if (FCondition.ConditionSet[I].Tag > 0) and (FCondition.ConditionSet[I].Tag < Items.Count) then
                  ItemIndex := FCondition.ConditionSet[I].Tag
                else
                  ItemIndex := 0;
              end;
            end; // with
        end;
      ctValueComBoBox:
        begin
          if Assigned(FCondition.ConditionSet[I].DisplayValue) then
          begin
            with TCMGLabelValueComBox.Create(Self) do
            begin
              FListControl.Add(TWinControl(Owner));
              if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
              begin
                CMCustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
                CMShowCustomCaption := True;
              end
              else if FCondition.ConditionSet[i].Caption <> '' then
              begin
                CMShowCustomCaption := True;
                Caption := FCondition.ConditionSet[i].Caption;
              end
              else
                CMShowCustomCaption := False;
              
              Style := csDropDownList;
              CMBasicType := FCondition.ConditionSet[I].ConditionType;
              Parent := pnlEntry;
              Left := LEFTBORDER;
              Width := CONTROLWIDTH;
              Top := J;
              J := J + Height + CONTROLSPACE;
              Visible := not FCondition.ConditionSet[i].Invisible;
              Enabled := not FCondition.ConditionSet[i].Disabled;
              if not Assigned(FFirstControl) then
              begin
                if (not FCondition.ConditionSet[i].Disabled) and (not FCondition.ConditionSet[i].Invisible) then
                begin
                  FFirstControl := TWinControl(Owner);
                  SetFocus;
                end;
              end;

              if Assigned(FCondition.COnditionSet[I].DisplayValue) then
              begin
                Items.Assign(FCondition.ConditionSet[I].DisplayValue);
                AssignValue(FCondition.ConditionSet[I].ReturnValue);

                if (FCondition.ConditionSet[I].Tag > 0) and (FCondition.ConditionSet[I].Tag < Items.Count - 1) then
                  ItemIndex := FCondition.ConditionSet[I].Tag
                else
                  ItemIndex := 0;
              end;
            end; // with
          end;
        end;
      ctMemo:
        begin
        end;
      ctDate:
        begin
          if needDateSpace and
             ((FCondition.ConditionSet[I].ConditionType = CMbtDateBegin) or
             (FCondition.ConditionSet[I].ConditionType = CMbtDateEnd)) then
             Continue;

//          with TCMGLabelEmptyDate.Create(Self) do
//          begin
//            FListControl.Add(TWinControl(Owner));
//            if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
//            begin
//              CMCustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
//              CMShowCustomCaption := True;
//            end
//            else if FCondition.ConditionSet[i].Caption <> '' then
//            begin
//              CMShowCustomCaption := True;
//              Caption := FCondition.ConditionSet[i].Caption;
//            end
//            else
//              CMShowCustomCaption := False;
//
//            CMBasicType := FCondition.ConditionSet[I].ConditionType;
//            AllowBlank := False;
//            Parent := pnlEntry;
//            Left := LEFTBORDER;
//            Width := CONTROLWIDTH;
//            if FCondition.ConditionSet[I].MaxDate <> '' then
//              MaxDate := StrToDate(FCondition.ConditionSet[I].MaxDate);
//            if FCondition.ConditionSet[I].MinDate <> '' then
//              MinDate := StrToDate(FCondition.ConditionSet[I].MinDate);
//            //Kind := dtkDate;
//            DateFormat := dfLong;
//            Top := J;
//            J := J + Height + CONTROLSPACE;
//            Visible := not FCondition.ConditionSet[i].Invisible;
//            Enabled := not FCondition.ConditionSet[i].Disabled;
//            if not Assigned(FFirstControl) then
//            begin
//              if (not FCondition.ConditionSet[i].Disabled) and (not FCondition.ConditionSet[i].Invisible) then
//              begin
//                FFirstControl := TWinControl(Owner);
//                SetFocus;
//              end;
//            end;
//
//            if FShowSaveDate then
//              cbxSaveDate.Visible := True;
//          end;

          with TCMGLabelQueryDate.Create(Self) do
          begin
            FListControl.Add(TWinControl(Owner));
            if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
            begin
              CMCustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
              CMShowCustomCaption := True;
            end
            else if FCondition.ConditionSet[i].Caption <> '' then
            begin
              CMShowCustomCaption := True;
              Caption := FCondition.ConditionSet[i].Caption;
            end
            else
              CMShowCustomCaption := False;

            CMBasicType := FCondition.ConditionSet[I].ConditionType;
            Parent := pnlEntry;
            Left := LEFTBORDER;
            Width := CONTROLWIDTH;
            if FCondition.ConditionSet[I].MaxDate <> '' then
              MaxDate := StringToDateTime(FCondition.ConditionSet[I].MaxDate);
            if FCondition.ConditionSet[I].MinDate <> '' then
              MinDate := StringToDateTime(FCondition.ConditionSet[I].MinDate);
            Top := J;
            J := J + Height + CONTROLSPACE;
            Visible := not FCondition.ConditionSet[i].Invisible;
            Enabled := not FCondition.ConditionSet[i].Disabled;

            if not Assigned(FFirstControl) then
            begin
              if (not FCondition.ConditionSet[i].Disabled) and (not FCondition.ConditionSet[i].Invisible) then
              begin
                FFirstControl := TWinControl(Owner);
                SetFocus;
              end;
            end;

            if FShowSaveDate then
              cbxSaveDate.Visible := True;
          end;

//          if needDateSpace and (FCondition.ConditionSet[I].ConditionType = CMbtDateEnd) then
//          begin
//            with TCMGDateSpaceComBox.Create(Self) do
//            begin
//              FListControl.Add(TWinControl(Owner));
//              CMShowCustomCaption := True;
//              Caption := '日期区间';
//
//              Style := csDropDownList;
//              CMBasicType := CMbtNo; //FCondition.ConditionSet[I].ConditionType;
//              Parent := pnlEntry;
//              Left := LEFTBORDER;
//              Width := CONTROLWIDTH;
//              Top := J;
//              J := J + Height + CONTROLSPACE;
//              Visible := True;//not FCondition.ConditionSet[i].Invisible;
//              Enabled := True;//not FCondition.ConditionSet[i].Disabled;
//              Clear;
//
//              OnChange := DateSpaceComBoxChange;
//            end; // with
//          end;
        end;
      ctEmptyDate:
        begin
          with TCMGLabelClearDate.Create(Self) do
          begin
            FListControl.Add(TWinControl(Owner));
            if FCondition.ConditionSet[i].CustomCaptionNo <> 0 then
            begin
              CMCustomCaptionNo := FCondition.ConditionSet[i].CustomCaptionNo;
              CMShowCustomCaption := True;
            end
            else if FCondition.ConditionSet[i].Caption <> '' then
            begin
              CMShowCustomCaption := True;
              Caption := FCondition.ConditionSet[i].Caption;
            end
            else
              CMShowCustomCaption := False;

            CMBasicType := FCondition.ConditionSet[I].ConditionType;
            Parent := pnlEntry;
            Left := LEFTBORDER;
            Width := CONTROLWIDTH;
            if FCondition.ConditionSet[I].MaxDate <> '' then
              MaxDate := StrToDate(FCondition.ConditionSet[I].MaxDate);
            if FCondition.ConditionSet[I].MinDate <> '' then
              MinDate := StrToDate(FCondition.ConditionSet[I].MinDate);
            //Kind := dtkDate;
            DateFormat := dfLong;
            Top := J;
            J := J + Height + CONTROLSPACE;
            Visible := not FCondition.ConditionSet[i].Invisible;
            Enabled := not FCondition.ConditionSet[i].Disabled;
            if not Assigned(FFirstControl) then
            begin
              if (not FCondition.ConditionSet[i].Disabled) and (not FCondition.ConditionSet[i].Invisible) then
              begin
                FFirstControl := TWinControl(Owner);
                SetFocus;
              end;
            end;

            if FShowSaveDate then
              cbxSaveDate.Visible := True;
          end;
        end;
    end;
  end;
  ClientHeight := J + pnlBottom.Height + pnlEntry.Top + BOTTOMBORDER;
  ClientWidth := pnlEntry.Left + LEFTBORDER + CONTROLWIDTH + RIGHTBORDER;

  inherited InitializationForm;
end;

procedure TfrmDllCondBox.AddDateRages(var TopIndex: Integer);
var
  DateTop: Integer;
  DateWidth: Integer;
begin
  DateWidth := 110;

  with TCMGDateSpaceComBox.Create(Self) do
  begin
    FListControl.Add(TWinControl(Owner));
    CMShowCustomCaption := True;
    Caption := '日期区间';

    Style := csDropDownList;
    CMBasicType := CMbtNo; //FCondition.ConditionSet[I].ConditionType;
    Parent := pnlEntry;
    Left := LEFTBORDER;
    Width := CONTROLWIDTH;
    Top := TopIndex;
    TopIndex := TopIndex + Height + CONTROLSPACE;
    Visible := True;//not FCondition.ConditionSet[i].Invisible;
    Enabled := True;//not FCondition.ConditionSet[i].Disabled;
    Clear;

    OnChange := DateSpaceComBoxChange;
  end; // with

//  FBeginDateCondSet: TConditionSet;
//    FEndDateCondSet: TConditionSet;

  with TCMGLabelQueryDate.Create(Self) do
  begin
    FListControl.Add(TWinControl(Owner));

    CMShowCustomCaption := True;
    Caption := '';
    CMBasicType := FBeginDateCondSet.ConditionType;
    Parent := pnlEntry;
//    AllowBlank := False;
    Left := LEFTBORDER;
    Width := DateWidth;
    if FBeginDateCondSet.MaxDate <> '' then
      MaxDate := StringToDateTime(FBeginDateCondSet.MaxDate);
    if FBeginDateCondSet.MinDate <> '' then
      MinDate := StringToDateTime(FBeginDateCondSet.MinDate);
    //DateFormat := dfLong;
//    DateFormat := dfShort;
    Top := TopIndex;
    TopIndex := TopIndex + Height + CONTROLSPACE;
    DateTop := Top;
    Visible := not FBeginDateCondSet.Invisible;
    Enabled := not FBeginDateCondSet.Disabled;

//    if not Assigned(FFirstControl) then
//    begin
//      if (not FBeginDateCondSet.Disabled) and (not FBeginDateCondSet.Invisible) then
//      begin
//        FFirstControl := TWinControl(Owner);
//        SetFocus;
//      end;
//    end;

    if FShowSaveDate then
      cbxSaveDate.Visible := True;
  end;

  with TCMGLabelQueryDate.Create(Self) do
  begin
    FListControl.Add(TWinControl(Owner));
 
    CMShowCustomCaption := True;
    Caption := '至';
    CMBasicType := FEndDateCondSet.ConditionType;
    Parent := pnlEntry;
//    AllowBlank := False;
    Left := LEFTBORDER + DateWidth + 23;
    Width := DateWidth;
    if FEndDateCondSet.MaxDate <> '' then
      MaxDate := StringToDateTime(FEndDateCondSet.MaxDate);
    if FEndDateCondSet.MinDate <> '' then
      MinDate := StringToDateTime(FEndDateCondSet.MinDate);
    //DateFormat := dfLong;
//    DateFormat := dfShort;
    Top := DateTop;
    Visible := not FEndDateCondSet.Invisible;
    Enabled := not FEndDateCondSet.Disabled;

//    if not Assigned(FFirstControl) then
//    begin
//      if (not FEndDateCondSet.Disabled) and (not FEndDateCondSet.Invisible) then
//      begin
//        FFirstControl := TWinControl(Owner);
//        SetFocus;
//      end;
//    end;

    if FShowSaveDate then
      cbxSaveDate.Visible := True;
  end;
end;

procedure TfrmDllCondBox.DateSpaceComBoxChange(Sender: TObject);
var
  I: Integer;
  sDateBegin, sDateEnd: string;
  ADate: TDateTime;
  AQueryDate: TCMGLabelQueryDate;
  //AQueryDate: TCMGLabelEmptyDate;
begin
  sDateBegin := '';
  sDateEnd := '';

  if (Sender as TCMGLabelValueComBox).ItemValue = 'week' then
  begin
    sDateBegin := GetMonday;
    sDateEnd := GetSunday;
  end
  else if (Sender as TCMGLabelValueComBox).ItemValue = 'lastweek' then
  begin
    sDateBegin := GetLastMonday;
    sDateEnd := GetLastSunday;
  end
  else if (Sender as TCMGLabelValueComBox).ItemValue = 'month' then
  begin
    sDateBegin := GetMonthBegin;
    sDateEnd := GetMonthEnd;
  end
  else if (Sender as TCMGLabelValueComBox).ItemValue = 'lastmonth' then
  begin
    sDateBegin := GetLastMonthBegin;
    sDateEnd := GetLastMonthEnd;
  end
  else if (Sender as TCMGLabelValueComBox).ItemValue = 'querter' then
  begin
    sDateBegin := GetQuarterBegin;
    sDateEnd := GetQuarterEnd;
  end
  else if (Sender as TCMGLabelValueComBox).ItemValue = 'lastquerter' then
  begin
    sDateBegin := GetLastQuarterBegin;
    sDateEnd := GetLastQuarterEnd;
  end
  else if (Sender as TCMGLabelValueComBox).ItemValue = 'year' then
  begin
    sDateBegin := GetYearBegin;
    sDateEnd := GetYearEnd;
  end;

  if (Trim(sDateBegin) <> '') and (Trim(sDateEnd) <> '') then
  begin
    for I := 0 to Self.ComponentCount - 1 do
    begin
//      if Components[I] is TCMGLabelEmptyDate then
//      begin
//        AQueryDate := (Components[I] as TCMGLabelEmptyDate);
//        if AQueryDate.CMBasicType = CMbtDateBegin then
//        begin
//          ADate := StringToDateTime(sDateBegin);
//          if ADate < AQueryDate.MinDate then
//            AQueryDate.Date := AQueryDate.MinDate
//          else if ADate > AQueryDate.MaxDate then
//            AQueryDate.Date := AQueryDate.MaxDate
//          else
//            AQueryDate.Date := ADate;
//        end
//        else if (Components[I] as TCMGLabelEmptyDate).CMBasicType = CMbtDateEnd then
//        begin
//          ADate := StringToDateTime(sDateEnd);
//          if ADate < AQueryDate.MinDate then
//            AQueryDate.Date := AQueryDate.MinDate
//          else if ADate > AQueryDate.MaxDate then
//            AQueryDate.Date := AQueryDate.MaxDate
//          else
//            AQueryDate.Date := ADate;
//        end;
//      end;

      if Components[I] is TCMGLabelQueryDate then
      begin
        AQueryDate := (Components[I] as TCMGLabelQueryDate);
        if AQueryDate.CMBasicType = CMbtDateBegin then
        begin
          ADate := StringToDateTime(sDateBegin);
          if ADate < AQueryDate.MinDate then
            AQueryDate.Date := AQueryDate.MinDate
          else if ADate > AQueryDate.MaxDate then
            AQueryDate.Date := AQueryDate.MaxDate
          else
            AQueryDate.Date := ADate;
        end
        else if (Components[I] as TCMGLabelQueryDate).CMBasicType = CMbtDateEnd then
        begin
          ADate := StringToDateTime(sDateEnd);
          if ADate < AQueryDate.MinDate then
            AQueryDate.Date := AQueryDate.MinDate
          else if ADate > AQueryDate.MaxDate then
            AQueryDate.Date := AQueryDate.MaxDate
          else
            AQueryDate.Date := ADate;
        end;
      end;
    end;
  end;
end;

procedure TfrmDllCondBox.FormCreate(Sender: TObject);
begin
  inherited;

  if not Assigned(FListControl) then
    FListControl := TList.Create;
end;

procedure TfrmDllCondBox.btnOKClick(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  pnlBottom.SetFocus();  //--2299
  GetComponentProperty;

  if ExitCheck = false then
    exit;
  for I := 0 to self.ComponentCount - 1 do // Iterate
  begin
    case StringIndex(Components[i].ClassName, C_CLASS_NAMES) of //
      Ord(cnTLabelBtnEdit):
        with TCMGLabelBtnEdit(Components[i]) do
        begin
          if (CMBasicType = CMbtOperatingType) then
            Params[Ord(CMbtAssThree)] := Rec
          else if CMBasicType = CMbtPMtype then
            Params[Ord(CMbtTrueStock)] := Rec
          else if (CMBasicType in CMBaseBasicType) and (Text = '') then
            Params[Ord(CMBasicType)] := '00000'
          else if (CMDataType in [dtTotal..dtDouble]) and (Text = '') then //数值型条件，默认为0 Add By Guiyun 2010-12-29
            Params[Ord(CMBasicType)] := 0;
        end;

      //保存默认日期
      Ord(cnTLabelEmptyDate):
        with TCMGLabelEmptyDate(Components[i]) do
        begin
          if (not cbxSaveDate.Visible) or (not cbxSaveDate.Checked) then Continue;
          if not VarIsNull(Params[Ord(CMBasicType)]) and not VarIsEmpty(Params[Ord(CMBasicType)]) then
          case CMBasicType of //
            CMbtDateBegin:
              SetPubDefaultBeginDate(FormatDateTime('yyyy-mm-dd', Date));
            CMbtDateEnd:
              SetPubDefaultEndDate(FormatDateTime('yyyy-mm-dd', Date));
            else
              SetPubDefaultDate(FormatDateTime('yyyy-mm-dd', Date));
          end;
        end;

      Ord(cnTQueryDate):
        with TCMGLabelQueryDate(Components[i]) do
        begin
          if (not cbxSaveDate.Visible) or (not cbxSaveDate.Checked) then Continue;
          if not VarIsNull(Params[Ord(CMBasicType)]) and not VarIsEmpty(Params[Ord(CMBasicType)]) then
          case CMBasicType of //
            CMbtDateBegin:
              SetPubDefaultBeginDate(FormatDateTime('yyyy-mm-dd', Date));
            CMbtDateEnd:
              SetPubDefaultEndDate(FormatDateTime('yyyy-mm-dd', Date));
            else
              SetPubDefaultDate(FormatDateTime('yyyy-mm-dd', Date));
          end;
        end;
    end;
  end; // for
  ModalResult := mrOk;
end;

function TfrmDllCondBox.ExitCheck: Boolean;
var
  szValue, szCaption: string;
  dValue: Double;
  I, J: Integer;
  FErrorControl: TWinControl;
begin
  Result := true;
  FErrorControl := nil;

  for i := Low(FCondition.ConditionSet) to High(FCondition.ConditionSet) do
    if FCondition.ConditionSet[I].Required then
    begin
      if FCondition.ConditionSet[I].ConditionType in CMBaseBasicType then
      begin
        szValue := Params[Ord(FCondition.ConditionSet[I].ConditionType)];
        if (szValue = '') or (szValue = '00000') then
        begin
          for j := 0 to Self.ComponentCount - 1 do
          begin
            FErrorControl := TWinControl(Components[J]);
            
            case StringIndex(Components[J].ClassName, C_CLASS_NAMES) of
              Ord(cnTLabelBtnEdit):
                begin
                  with TCMGLabelBtnEdit(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelComboBox):
                begin
                  with TCMGLabelComBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTGCheckBox):
                begin
                  with TCMGXwChcekBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelEmptyDate):
                begin
                  with TCMGLabelEmptyDate(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelValueComboBox):
                begin
                  with TCMGLabelValueComBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelClearDate):
                begin
                  with TCMGLabelClearDate(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
            end;
          end;

          if Trim(szCaption) = '' then
          begin
            if FCondition.ConditionSet[I].CustomCaptionNo <> 0 then
              szCaption := GetStringsFromStringNo(FCondition.ConditionSet[I].CustomCaptionNo)
            else
              szCaption := GetDataTypeFromBasic(FCondition.ConditionSet[I].ConditionType).Caption;
          end;

          ShowWarningMsg(Format('“%s”不能为空，请重新输入。', [szCaption]));
          if FErrorControl.CanFocus then
            FErrorControl.SetFocus;
          Result := False;
          Exit;
        end;
      end
      else if FCondition.ConditionSet[I].DataType in
        [dtTotal, dtPrice, dtQty, dtInteger, dtDouble] then
      begin
        dValue := Params[Ord(FCondition.ConditionSet[I].ConditionType)];
        if Abs(dValue) < 0.00001 then
        begin
          for j := 0 to Self.ComponentCount - 1 do
          begin
            FErrorControl := TWinControl(Components[J]);
            
            case StringIndex(Components[J].ClassName, C_CLASS_NAMES) of
              Ord(cnTLabelBtnEdit):
                begin
                  with TCMGLabelBtnEdit(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelComboBox):
                begin
                  with TCMGLabelComBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTGCheckBox):
                begin
                  with TCMGXwChcekBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelEmptyDate):
                begin
                  with TCMGLabelEmptyDate(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelValueComboBox):
                begin
                  with TCMGLabelValueComBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelClearDate):
                begin
                  with TCMGLabelClearDate(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
            end;
          end;

          if Trim(szCaption) = '' then
          begin
            if FCondition.ConditionSet[I].CustomCaptionNo <> 0 then
              szCaption := GetStringsFromStringNo(FCondition.ConditionSet[I].CustomCaptionNo)
            else
              szCaption := GetDataTypeFromBasic(FCondition.ConditionSet[I].ConditionType).Caption;
          end;

          ShowWarningMsg(Format('“%s”不能为0，请重新输入。', [szCaption]));
          if FErrorControl.CanFocus then
            FErrorControl.SetFocus;
          Result := False;
          Exit;
        end;
      end
      else if FCondition.ConditionSet[I].DataType = dtString then
      begin
        szValue := Params[Ord(FCondition.ConditionSet[I].ConditionType)];
        if szValue = '' then
        begin
          for j := 0 to Self.ComponentCount - 1 do
          begin
            FErrorControl := TWinControl(Components[J]);
            
            case StringIndex(Components[J].ClassName, C_CLASS_NAMES) of
              Ord(cnTLabelBtnEdit):
                begin
                  with TCMGLabelBtnEdit(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelComboBox):
                begin
                  with TCMGLabelComBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTGCheckBox):
                begin
                  with TCMGXwChcekBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelEmptyDate):
                begin
                  with TCMGLabelEmptyDate(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelValueComboBox):
                begin
                  with TCMGLabelValueComBox(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
              Ord(cnTLabelClearDate):
                begin
                  with TCMGLabelClearDate(Components[J]) do
                  begin
                    if CMBasicType = FCondition.ConditionSet[I].ConditionType then
                    begin
                      szCaption := Caption;
                      Break;
                    end;
                  end;
                end;
            end;
          end;

          if Trim(szCaption) = '' then
          begin
            if FCondition.ConditionSet[I].CustomCaptionNo <> 0 then
              szCaption := GetStringsFromStringNo(FCondition.ConditionSet[I].CustomCaptionNo)
            else
              szCaption := GetDataTypeFromBasic(FCondition.ConditionSet[I].ConditionType).Caption;
          end;

          ShowWarningMsg(Format('“%s”不能为空，请重新输入。', [szCaption]));
          if FErrorControl.CanFocus then
            FErrorControl.SetFocus;
          Result := False;
          Exit;
        end;
      end;
    end;
end;

procedure TfrmDllCondBox.LoadTitleData;
  function CheckMaxDate(maxDate, value: TDateTime): TDateTime;
  begin
     Result := maxDate;
     if maxDate = StringToDateTime('1899-12-30') then
        Result := value;
     if (not VarIsNull(value)) and (maxDate > value) then
       Result := value;
  end;
  function CheckMinDate(minDate, Value: TDateTime): TDateTime;
  begin
     Result := minDate;
     if minDate = StringToDateTime('1899-12-30') then
        Result := value;
     if (not VarIsNull(value)) and (minDate < value) then
       Result := value;
  end;
var
  i, j: Integer;
  tempDate, DefaultDate: TDatetime;
  sDefaultBeginDate, sDefaultEndDate, sDefaultDate: string;
begin
  inherited LoadTitleData;

  sDefaultBeginDate := GetPubDefaultBeginDate;
  sDefaultEndDate := GetPubDefaultEndDate;
  sDefaultDate := GetPubDefaultDate;

  for i :=  0 to Self.ComponentCount - 1 do
  begin
    case StringIndex(Components[i].ClassName, C_CLASS_NAMES) of
      Ord(cnTLabelEmptyDate):
        with TCMGLabelEmptyDate(Components[i]) do
        begin
          OnKeyDown := DoKeyDown;
          //重置日期控件查询日期
          if not VarIsNull(Params[Ord(CMBasicType)]) then
          begin
            try
              case CMBasicType of //
                CMbtDateBegin:
                  if (sDefaultBeginDate <> '') and (FShowSaveDate) then
                  begin
                    DefaultDate := StringToDateTime(sDefaultBeginDate);
                    Params[Ord(CMBasicType)] := sDefaultBeginDate;
                    tempDate := StringToDateTime(Params[Ord(CMBasicType)], DefaultDate);
                    tempDate := CheckMinDate(MinDate, tempDate);
                    Date := CheckMaxDate(MaxDate, tempDate);
                  end;
                CMbtDateEnd:
                  if (sDefaultEndDate <> '') and (FShowSaveDate) then
                  begin
                    DefaultDate := StringToDateTime(sDefaultEndDate);
                    Params[Ord(CMBasicType)] := sDefaultEndDate;
                    tempDate := StringToDateTime(Params[Ord(CMBasicType)], DefaultDate);
                    tempDate := CheckMinDate(MinDate, tempDate);
                    Date := CheckMaxDate(MaxDate, tempDate);
                  end;
                else
                  if sDefaultDate <> '' then
                  begin
                    DefaultDate := StringToDateTime(sDefaultDate);
                    Params[Ord(CMBasicType)] := sDefaultDate;
                    tempDate := StringToDateTime(Params[Ord(CMBasicType)], DefaultDate);
                    tempDate := CheckMinDate(MinDate, tempDate);
                    Date := CheckMaxDate(MaxDate, tempDate);
                  end;
              end; // case
            except
            end;
          end;
        end;
      Ord(cnTQueryDate):
        with TCMGLabelQueryDate(Components[i]) do
        begin
          OnKeyDown := DoKeyDown;
          //重置日期控件查询日期
          if not VarIsNull(Params[Ord(CMBasicType)]) then
          begin
            try
              case CMBasicType of //
                CMbtDateBegin:
                  if (sDefaultBeginDate <> '') and (FShowSaveDate) then
                  begin
                    DefaultDate := StringToDateTime(sDefaultBeginDate);
                    Params[Ord(CMBasicType)] := sDefaultBeginDate;
                    tempDate := StringToDateTime(Params[Ord(CMBasicType)], DefaultDate);
                    tempDate := CheckMinDate(MinDate, tempDate);
                    Date := CheckMaxDate(MaxDate, tempDate);
                  end;
                CMbtDateEnd:
                  if (sDefaultEndDate <> '') and (FShowSaveDate) then
                  begin
                    DefaultDate := StringToDateTime(sDefaultEndDate);
                    Params[Ord(CMBasicType)] := sDefaultEndDate;
                    tempDate := StringToDateTime(Params[Ord(CMBasicType)], DefaultDate);
                    tempDate := CheckMinDate(MinDate, tempDate);
                    Date := CheckMaxDate(MaxDate, tempDate);
                  end;
                else
                  if sDefaultDate <> '' then
                  begin
                    DefaultDate := StringToDateTime(sDefaultDate);
                    Params[Ord(CMBasicType)] := sDefaultDate;
                    tempDate := StringToDateTime(Params[Ord(CMBasicType)], DefaultDate);
                    tempDate := CheckMinDate(MinDate, tempDate);
                    Date := CheckMaxDate(MaxDate, tempDate);
                  end;
              end; // case
            except
            end;
          end;
        end;
      Ord(cnTLabelComboBox):
        begin
          TCMGLabelComBox(Components[i]).OnKeyDown := DoKeyDown;
          for j := Low(FCondition.ConditionSet) to High(FCondition.ConditionSet) do
            if (TCMGLabelComBox(Components[i]).CMCustomCaptionNo = FCondition.ConditionSet[j].CustomCaptionNo) then
            begin
              if (FCondition.ConditionSet[j].Tag > 0) and
                 (FCondition.ConditionSet[j].Tag <= TCMGLabelComBox(Components[i]).Items.Count - 1) then
                TCMGLabelComBox(Components[i]).ItemIndex := FCondition.ConditionSet[j].Tag
              else
                TCMGLabelComBox(Components[i]).ItemIndex := 0;
              Break;
            end;
        end;
      Ord(cnTGCheckBox):
        begin
          TCMGXwChcekBox(Components[i]).OnKeyDown := DoKeyDown;
        end;
    end;
  end;
end;

procedure TfrmDllCondBox.InitSaveDate;
begin
  cbxSaveDate.Caption := '保存查询时间';
  cbxSaveDate.Checked := False;
end;

procedure TfrmDllCondBox.DoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if Key = VK_RETURN then
//     SelectNextCom(Sender); //执行基本信息选择后再定位到下一控件 lsbai 20130308
end;

procedure TfrmDllCondBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FListControl) then
    FreeAndNil(FListControl);
end;

procedure TfrmDllCondBox.BeforeSelectBaseInfo(Sender: TObject;
  var ABaseType: TcmBaseInfoType; var szSearchType: Char; var szSearchString,
  szKTypeID, szAssistant1, szAssistant2: string;
  var ASubjectType: TCMSubjectType; var ASelectOptions: TCMBaseSelectOptions;
  var ContinueProc: Boolean);
var
  i: Integer;
begin
  if (Sender is TCMGLabelBtnEdit) then
  begin
    if (Sender as TCMGLabelBtnEdit).CMBasicType = CMbtOperatingType then
    begin
      szAssistant1 := InttoStr((Sender as TCMGLabelBtnEdit).Tag);
    end;

    if(Sender as TCMGLabelBtnEdit).CMBasicType = CMbtVchType then
    begin
      szAssistant2 := FCondition.ConditionSet[0].CustomCode;
    end;

    if(Sender as TCMGLabelBtnEdit).CMBasicType = CMbtTIType then
    begin
      for i := 0 to Length(FCondition.ConditionSet) - 1 do
      begin
        if FCondition.ConditionSet[i].XWBasicType = btTItype then
          szAssistant1 := FCondition.ConditionSet[i].CustomCode;
      end;
    end;
  end;
end;

end.

