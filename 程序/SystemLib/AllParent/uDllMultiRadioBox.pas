unit uDllMultiRadioBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uDllDialogParent, StdCtrls, ExtCtrls, Buttons, Db, DBClient, xwbasiccomponent,
  xwBasicinfoComponent, XwGjpBasicCom, uExtImage, XWComponentType,
  xwButtons, uCMEventHander;

type
  TfrmDllMultiRadioBox = class(TfrmDllDialogParent)
    imgTitle: TImage;
    Bevel1: TBevel;
    btnOK: TCMGXwBitbtn;
    btnCancel: TCMGXwBitbtn;
    lblHint: TLabel;
    procedure btnOKClick(Sender: TObject);
  private
    FUseNo: Boolean;
    FCaptions: array of string;
    FCaptionNos: array of Integer;
    FFirstControl : TWinControl;
    FDefaultIndex: Integer;
    FHint: string;
    procedure ButtonClick(Sender: TObject);
  protected
    procedure InitializationForm; override; //��ʼ������
  public
    { Public declarations }
  end;

function GetRadioCheck(ATitle: string; CaptionNOs: array of Integer; DefaultIndex: Integer = 1): Integer;
function GetRadioCheckEx(ATitle: string; Captions: array of string;
    DefaultIndex: Integer = 1; DefaultHint: string = ''): Integer;

implementation

uses uDllSystemIntf;

{$R *.DFM}

const
  LEFTBORDER = 80; //��߾�
  TOPBORDER = 30;
  BOTTOMBORDER = 15; //�ױ߾�
  CONTROLWIDTH = 180;
  CONTROLSPACE = 10;
  RIGHTBORDER = 30;

function GetRadioCheck(ATitle: string; CaptionNOs: array of Integer; DefaultIndex: Integer = 1): Integer;
var
  i : Integer;
begin
  with TfrmDllMultiRadioBox.Create(Application) do
  begin
    try
      Title := ATitle;
      FDefaultIndex := DefaultIndex;
      FUseNo := True;
      SetLength(FCaptionNOs, High(CaptionNOs) + 1);
      for i := Low(FCaptionNOs) to High(FCaptionNos) do
        FCaptionNOs[I] := CaptionNOs[I];
      if ShowModal = mrOk then
        Result := FFirstControl.Tag
      else
        Result := -1;
    finally
      Free;
    end;
  end; // with
end;

function GetRadioCheckEx(ATitle: string; Captions: array of string;
    DefaultIndex: Integer = 1; DefaultHint: string = ''): Integer;
var
  i : Integer;
begin
  with TfrmDllMultiRadioBox.Create(Application) do
  begin
    try
      Title := ATitle;
      FHint := DefaultHint;
      FDefaultIndex := DefaultIndex;
      FUseNo := False;
      SetLength(FCaptions, High(Captions) + 1);
      for i := Low(FCaptions) to High(FCaptions) do
        FCaptions[I] := Captions[I];
      if ShowModal = mrOk then
        Result := FFirstControl.Tag
      else
        Result := -1;
    finally
      Free;
    end;
  end; // with
end;

{ TfrmDllMultiRadioBox }

procedure TfrmDllMultiRadioBox.InitializationForm;
const
  cMinSpace = 30; //������ʾ��ʾ��Ϣ��Label�Ҷ˵�"ȷ��"��ť����С���
var
  nOrder, i, j : Integer;
  lo, hi: Integer;
begin
  nOrder := 0;
  pnlTitle.Visible := False;

  if FHint <> '' then //��ʾ��ʾ��Ϣ����ʾ�ӹ̶�λ��(�����·�)
  begin
    lblHint.Visible := True;
    lblHint.Caption := FHint;
  end;

  j := TOPBORDER;
  imgTitle.Picture.Bitmap.FreeImage;
  GetCondBoxImage.GetBitmap(1, imgTitle.Picture.Bitmap);
  //��̬��ʾ����ؼ�
  if FUseNo then
  begin
    lo := Low(FCaptionNOs);
    hi := High(FCaptionNOs);
  end
  else
  begin
    lo := Low(FCaptions);
    hi := High(FCaptions);
  end;

  for i := lo to hi do
    with TCMGRadioButton.Create(Self) do
    begin
      Inc(nOrder);
      Tag := nOrder;
      CMBasictype := CMbtCustom01;
      CMShowCustomCaption := True;
      if FUseNo then
        CMCustomCaptionNo := FCaptionNos[i]
      else
        Caption := FCaptions[i];
      Parent := pnlEntry;
      Left := LEFTBORDER;
      {��ǰû��ΪWidth��ֵ����֪��ԭ��}
      Width := CONTROLWIDTH;
      Top := J;
      J := J + Height + CONTROLSPACE;
      OnClick := ButtonClick;
      if not Assigned(FFirstControl) then
      begin
        FFirstControl := TWinControl(Owner);
      end;
      if nOrder = FDefaultIndex then Checked := True;
    end;

  ClientHeight := J + pnlBottom.Height + pnlEntry.Top + BOTTOMBORDER;
  ClientWidth := pnlEntry.Left + LEFTBORDER + CONTROLWIDTH + RIGHTBORDER + cMinSpace;
  FFirstControl.SetFocus;
  inherited InitializationForm;
end;

procedure TfrmDllMultiRadioBox.btnOKClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TfrmDllMultiRadioBox.ButtonClick(Sender: TObject);
begin
  FFirstControl := TCMGRadioButton(Sender);
end;

end.

