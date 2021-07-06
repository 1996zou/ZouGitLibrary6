unit uPurchasePriceSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDllDialogParent, DB, DBClient, uCMEventHander, uExtImage, StdCtrls,
  ExtCtrls, xwButtons, xwbasiccomponent, xwBasicinfoComponent, XwGjpBasicCom,
  uDllDBService, XWCBasicCom;

type
  TfrmPurchaseSetting = class(TfrmDllDialogParent)
    grpElecBar: TCMGGroupBox;
    chkIsCreateVoucher: TCheckBox;
    btnClose: TCMGXwBitbtn;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure chkIsCreateVoucherClick(Sender: TObject);
  private
    procedure LoadModuleData;
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowPurchasePriceSetting: Boolean;
implementation

{$R *.dfm}

function ShowPurchasePriceSetting: Boolean;
begin
  with TfrmPurchaseSetting.Create(Application) do
  try
    FunctionNo := 11800001;
    Title := '采购价格表配置';
    LoadModuleData;
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

procedure TfrmPurchaseSetting.LoadModuleData;
var
  szSQL: string;
begin
  szSQL := 'if exists(Select 1 From T_Inf_PurchasePrice_SysData_11000008 Where Name = ''PurchasePriceEnable'' and Value = ''1'' and Comment = ''采购价格表启用'')' +
         '  Select 1 Else select 0 ';

  chkIsCreateVoucher.Checked := SameText(GetValueFromSQL(szSQL),'1');
end;

procedure TfrmPurchaseSetting.btnCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfrmPurchaseSetting.btnCloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;


procedure TfrmPurchaseSetting.chkIsCreateVoucherClick(Sender: TObject);
begin
  inherited;
  ExecuteSQL(Format('Update T_Inf_PurchasePrice_SysData_11000008 Set Value = ''%d'' Where Name =''PurchasePriceEnable'' And Comment =''采购价格表启用'' ',
    [Ord(chkIsCreateVoucher.Checked)]));
end;

end.
