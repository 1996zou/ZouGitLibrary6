library ReaccountQueryPtypeReport;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }


{$R 'Picture.res' 'Picture\Picture.rc'}
{$R *.res}

uses
  Forms,
  sharemem,
  uDllComm,
  uCommonFunc in 'SystemLib\uCommonFunc.pas',
  uDllMenuRegister in 'SystemLib\uDllMenuRegister.pas',
  uDllValid in 'SystemLib\uDllValid.pas',
  uIniApp in 'SystemLib\uIniApp.pas',
  xwParentFormUnit in 'SystemLib\AllParent\xwParentFormUnit.pas' {xwParentForm},
  uDllGraspForm in 'SystemLib\AllParent\uDllGraspForm.pas' {DllGraspForm},
  uDllDialogParent in 'SystemLib\AllParent\uDllDialogParent.pas' {frmDllDialogParent},
  uDllMDIParent in 'SystemLib\AllParent\uDllMDIParent.pas' {frmDllMDIParent},
  uDllCondBox in 'SystemLib\AllParent\uDllCondBox.pas' {frmDllCondBox},
  uDllDialogQueryParent in 'SystemLib\AllParent\uDllDialogQueryParent.pas' {frmDllDialogQueryParent},
  uDllMultiRadioBox in 'SystemLib\AllParent\uDllMultiRadioBox.pas' {frmDllMultiRadioBox},
  uDllMessageIntf in 'SystemLib\AllParent\uDllMessageIntf.pas',
  uDllMDIQueryParent in 'SystemLib\AllParent\uDllMDIQueryParent.pas' {frmDllMDIQueryParent},
  uJXCQueryParent in 'SystemLib\AllParent\uJXCQueryParent.pas' {frmJXCQueryParent},
  uBasalMethod in 'Common\uBasalMethod.pas',
  uBatchMessage in 'Common\uBatchMessage.pas' {frmBatchMessage},
  uDllDataBaseIntf in 'Common\uDllDataBaseIntf.pas',
  uInputPrintPass in 'Common\uInputPrintPass.pas' {frmInputPrintPass},
  uMessageComm in 'Common\uMessageComm.pas',
  uOperationFunc in 'Common\uOperationFunc.pas',
  uStringConst in 'Common\uStringConst.pas',
  uTransformFunc in 'Common\uTransformFunc.pas',
  uDataSetHelper in 'Common\uDataSetHelper.pas',
  uBillBasicConfig in 'Common\uBillBasicConfig.pas',
  uBillCommon in 'Common\uBillCommon.pas',
  uBillMessageComm in 'Common\uBillMessageComm.pas',
  uMRPReport in 'uMRPReport.pas' {frmBuyStateReport},
  uCondDefine in 'uCondDefine.pas',
  uCommonSql in 'Common\uCommonSql.pas',
  uDllPrintdata in 'SystemLib\AllParent\uDllPrintdata.pas';

begin
  DLLApp := Application;                    //保留Application
  DllScreen := Screen;
  DLLProc := @DLLUnloadProc;                //将重写后的入口函数地址付给DLLProc
end.
