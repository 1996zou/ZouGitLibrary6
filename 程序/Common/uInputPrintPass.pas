unit uInputPrintPass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllDialogParent, DB, DBClient, uExtImage, StdCtrls, ExtCtrls,
  uCMEventHander;

type
  TfrmInputPrintPass = class(TfrmDllDialogParent)
    Label1: TLabel;
    edtPassWord: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function InputPrintPass: Boolean;

implementation

uses uDllDataBaseIntf, uDllDBService, uDllMessageIntf;

{$R *.dfm}

function InputPrintPass: Boolean;
var
  frmInputPrintPass: TfrmInputPrintPass;
begin
  frmInputPrintPass := TfrmInputPrintPass.Create(Application);
  with frmInputPrintPass do
  begin
    try
      Title := '��¼���ӡ����';
      Result := ShowModal = mrOk;
    finally
      Free;
    end;
  end;
end;

procedure TfrmInputPrintPass.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TfrmInputPrintPass.btnOKClick(Sender: TObject);
var
  nResult: Integer;
begin
  inherited;

  nResult := ExecuteProcByName('P_GBL_PrintPassword', ['@cMode', '@Password', '@NewPassword'], ['C', edtPassWord.Text, ''], nil);
  if nResult < 0 then
  begin
    ShowErrorMsg('��ӡ����¼��������顣');
    edtPassWord.SetFocus;
    Exit;
  end;

  ModalResult := mrOk;
end;

end.
