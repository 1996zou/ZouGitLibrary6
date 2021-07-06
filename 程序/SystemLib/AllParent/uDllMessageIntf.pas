unit uDllMessageIntf;

interface

uses Generics.Collections, uMsgIntf, uDataStructure;

//提示信息，会中断程序
procedure CheckError(bFlag: Boolean; AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
//直接提示，中断程序
procedure ThrowErrorMsg(AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
//根据条件选择提示其中一个信息
procedure CheckMessage(bFlag: Boolean; AMessage1, AMessage2: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = '');
//提示警告信息
procedure ShowWarningMsg(AMessage: string);
//提示错误信息
procedure ShowErrorMsg(AMessage: string);
//提示信息
procedure ShowInfoMessage(AMessage: string);

//由用户确定的提示，是or否
function ConfirmYesNo(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
//由用户确定的提示，确定or取消
function ConfirmOKCancel(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
//提示多个按钮出来的情况
function SelectMsg(Amessage: string; AButtons: TMessageBoxButtons; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): ShortInt;

//最基础的提示
function SuperMessageBox(AMessage: string; ACaption: string = '';
  AMsgType: TMessageBoxType = mbtInformation; AButtons: TMessageBoxButtons = [mbbOk]): Integer;

//单据批量提示
function SuperBillBatchMessageBox(AMsgList, AStockMsgList, ACommissionMsgList, AFactStockMsgList, AWorkShowMsgList: TList<TBillMessageInfo>; AMsgType: TMessageBoxType = mbtInformation; needConfirm: Boolean = False; confirmYesNo: Boolean = True): Boolean;

var
  DllMessage: IDllMessageCon;

implementation

//提示信息，会中断程序
procedure CheckError(bFlag: Boolean; AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
begin
  DllMessage.CheckError(bFlag, AMessage, AMsgType, ACaption);
end;

//直接提示，中断程序
procedure ThrowErrorMsg(AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
begin
  DllMessage.ThrowErrorMsg(AMessage, AMsgType, ACaption);
end;

//根据条件选择提示其中一个信息
procedure CheckMessage(bFlag: Boolean; AMessage1, AMessage2: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = '');
begin
  DllMessage.CheckMessage(bFlag, AMessage1, AMessage2, AMsgType, ACaption);
end;

//提示警告信息
procedure ShowWarningMsg(AMessage: string);
begin
  DllMessage.ShowWarningMsg(AMessage);
end;

//提示错误信息
procedure ShowErrorMsg(AMessage: string);
begin
  DllMessage.ShowErrorMsg(AMessage);
end;

//提示信息
procedure ShowInfoMessage(AMessage: string);
begin
  DllMessage.ShowInfoMessage(AMessage);
end;

//由用户确定的提示，是or否
function ConfirmYesNo(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
begin
  Result := DllMessage.ConfirmYesNo(AMessage, AMsgType, ACaption);
end;

//由用户确定的提示，确定or取消
function ConfirmOKCancel(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
begin
  Result := DllMessage.ConfirmOKCancel(AMessage, AMsgType, ACaption);
end;

//提示多个按钮出来的情况
function SelectMsg(Amessage: string; AButtons: TMessageBoxButtons; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): ShortInt;
begin
  Result := DllMessage.SelectMsg(Amessage, AButtons, AMsgType, ACaption);
end;

//最基础的提示
function SuperMessageBox(AMessage: string; ACaption: string = '';
  AMsgType: TMessageBoxType = mbtInformation; AButtons: TMessageBoxButtons = [mbbOk]): Integer;
begin
  Result := DllMessage.SuperMessageBox(AMessage, ACaption, AMsgType, AButtons);
end;

//单据批量提示
function SuperBillBatchMessageBox(AMsgList, AStockMsgList, ACommissionMsgList, AFactStockMsgList, AWorkShowMsgList: TList<TBillMessageInfo>; AMsgType: TMessageBoxType = mbtInformation; needConfirm: Boolean = False; confirmYesNo: Boolean = True): Boolean;
begin
  Result := DllMessage.SuperBillBatchMessageBox(AMsgList, AStockMsgList, ACommissionMsgList, AFactStockMsgList, AWorkShowMsgList, AMsgType, needConfirm, confirmYesNo);
end;

end.
