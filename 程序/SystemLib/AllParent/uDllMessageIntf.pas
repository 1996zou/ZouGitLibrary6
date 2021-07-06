unit uDllMessageIntf;

interface

uses Generics.Collections, uMsgIntf, uDataStructure;

//��ʾ��Ϣ�����жϳ���
procedure CheckError(bFlag: Boolean; AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
//ֱ����ʾ���жϳ���
procedure ThrowErrorMsg(AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
//��������ѡ����ʾ����һ����Ϣ
procedure CheckMessage(bFlag: Boolean; AMessage1, AMessage2: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = '');
//��ʾ������Ϣ
procedure ShowWarningMsg(AMessage: string);
//��ʾ������Ϣ
procedure ShowErrorMsg(AMessage: string);
//��ʾ��Ϣ
procedure ShowInfoMessage(AMessage: string);

//���û�ȷ������ʾ����or��
function ConfirmYesNo(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
//���û�ȷ������ʾ��ȷ��orȡ��
function ConfirmOKCancel(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
//��ʾ�����ť���������
function SelectMsg(Amessage: string; AButtons: TMessageBoxButtons; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): ShortInt;

//���������ʾ
function SuperMessageBox(AMessage: string; ACaption: string = '';
  AMsgType: TMessageBoxType = mbtInformation; AButtons: TMessageBoxButtons = [mbbOk]): Integer;

//����������ʾ
function SuperBillBatchMessageBox(AMsgList, AStockMsgList, ACommissionMsgList, AFactStockMsgList, AWorkShowMsgList: TList<TBillMessageInfo>; AMsgType: TMessageBoxType = mbtInformation; needConfirm: Boolean = False; confirmYesNo: Boolean = True): Boolean;

var
  DllMessage: IDllMessageCon;

implementation

//��ʾ��Ϣ�����жϳ���
procedure CheckError(bFlag: Boolean; AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
begin
  DllMessage.CheckError(bFlag, AMessage, AMsgType, ACaption);
end;

//ֱ����ʾ���жϳ���
procedure ThrowErrorMsg(AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
begin
  DllMessage.ThrowErrorMsg(AMessage, AMsgType, ACaption);
end;

//��������ѡ����ʾ����һ����Ϣ
procedure CheckMessage(bFlag: Boolean; AMessage1, AMessage2: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = '');
begin
  DllMessage.CheckMessage(bFlag, AMessage1, AMessage2, AMsgType, ACaption);
end;

//��ʾ������Ϣ
procedure ShowWarningMsg(AMessage: string);
begin
  DllMessage.ShowWarningMsg(AMessage);
end;

//��ʾ������Ϣ
procedure ShowErrorMsg(AMessage: string);
begin
  DllMessage.ShowErrorMsg(AMessage);
end;

//��ʾ��Ϣ
procedure ShowInfoMessage(AMessage: string);
begin
  DllMessage.ShowInfoMessage(AMessage);
end;

//���û�ȷ������ʾ����or��
function ConfirmYesNo(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
begin
  Result := DllMessage.ConfirmYesNo(AMessage, AMsgType, ACaption);
end;

//���û�ȷ������ʾ��ȷ��orȡ��
function ConfirmOKCancel(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
begin
  Result := DllMessage.ConfirmOKCancel(AMessage, AMsgType, ACaption);
end;

//��ʾ�����ť���������
function SelectMsg(Amessage: string; AButtons: TMessageBoxButtons; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): ShortInt;
begin
  Result := DllMessage.SelectMsg(Amessage, AButtons, AMsgType, ACaption);
end;

//���������ʾ
function SuperMessageBox(AMessage: string; ACaption: string = '';
  AMsgType: TMessageBoxType = mbtInformation; AButtons: TMessageBoxButtons = [mbbOk]): Integer;
begin
  Result := DllMessage.SuperMessageBox(AMessage, ACaption, AMsgType, AButtons);
end;

//����������ʾ
function SuperBillBatchMessageBox(AMsgList, AStockMsgList, ACommissionMsgList, AFactStockMsgList, AWorkShowMsgList: TList<TBillMessageInfo>; AMsgType: TMessageBoxType = mbtInformation; needConfirm: Boolean = False; confirmYesNo: Boolean = True): Boolean;
begin
  Result := DllMessage.SuperBillBatchMessageBox(AMsgList, AStockMsgList, ACommissionMsgList, AFactStockMsgList, AWorkShowMsgList, AMsgType, needConfirm, confirmYesNo);
end;

end.
