unit uBatchMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllDialogParent, DB, DBClient, uExtImage, StdCtrls, ExtCtrls,
  uCMEventHander, uDataStructure;

type
  TfrmBatchMessage = class(TfrmDllDialogParent)
    MsgMemo: TMemo;
    btnOK: TButton;
    btnClose: TButton;
    Image: TImage;
    Panel1: TPanel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }

    confirmOK: Boolean;
  public
    { Public declarations }
  end;


function SuperBatchMessageBox(MsgList: TStrings; AMsgType: TMessageBoxType = mbtInformation; needConfirm: Boolean = False; confirmYesNo: Boolean = True): Boolean;

implementation

{$R *.dfm}

var
  IconIDs: array[TMessageBoxType] of PChar = (IDI_EXCLAMATION, IDI_HAND, IDI_ASTERISK, IDI_QUESTION, nil);

function SuperBatchMessageBox(MsgList: TStrings; AMsgType: TMessageBoxType = mbtInformation; needConfirm: Boolean = False; confirmYesNo: Boolean = True): Boolean;
begin
  with TfrmBatchMessage.Create(Application) do
  begin
    try
      if needConfirm then
      begin
        Title := '��ȷ��';
        if confirmYesNo then
        begin
          btnOk.Caption := '��';
          btnClose.Caption := '��';
        end
        else
        begin
          btnOk.Caption := 'ȷ��';
          btnClose.Caption := 'ȡ��';
        end;
        btnOk.Visible := True;
      end
      else
      begin
        if AMsgType = mbtWarning then
          Title := '����'
        else if AMsgType = mbtError then
          Title := '����'
        else
          Title := '��ʾ';
      end;

      Shape1.Visible := False;
      Shape2.Visible := False;
      lblTitle.Visible := False;
      Image.Picture.Icon.Handle := LoadIcon(0, IconIDs[AMsgType]);

      confirmOK := False;
      MsgMemo.Lines.Assign(MsgList);

      ShowModal;
      Result := confirmOK;
    finally
      Free;
    end;
  end;
end;

procedure TfrmBatchMessage.btnCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmBatchMessage.btnOKClick(Sender: TObject);
begin
  inherited;
  confirmOK := True;
  Close;
end;

end.

