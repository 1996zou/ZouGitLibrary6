unit uMessageComm;

interface

uses SysUtils, Classes, Controls, uDataStructure;

type
  //批量提示
  TBatchMessage = class
  private
    FMsgList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ClearMsg;
    procedure AddMsg(AMsg: string);
    procedure AddDistinctMsg(AMsg: string);
    procedure AssignMsg(Source: TPersistent);
    procedure ShowBatchMsg;
    procedure ShowWarningBatchMsg;
    procedure ShowErrorBatchMsg;

    function HasMsg: Boolean;
    function Contains(AMsg: string): Boolean;
    function ConfirmYesNoBatchMsg: Boolean;
    function ConfirmOKCancelBatchMsg: Boolean;

    property MsgList: TStringList read FMsgList;
  end;

////提示信息，会中断程序
//procedure CheckError(bFlag: Boolean; AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
////直接提示，中断程序
//procedure ThrowErrorMsg(AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
////根据条件选择提示其中一个信息
//procedure CheckMessage(bFlag: Boolean; AMessage1, AMessage2: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = '');
////提示警告信息
//procedure ShowWarningMsg(AMessage: string);
////提示错误信息
//procedure ShowErrorMsg(AMessage: string);
//
////由用户确定的提示，是or否
//function ConfirmYesNo(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
////由用户确定的提示，确定or取消
//function ConfirmOKCancel(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;

implementation

uses uBatchMessage;

{ TBatchMessage }
constructor TBatchMessage.Create;
begin
  FMsgList := TStringList.Create;
end;

destructor TBatchMessage.Destroy;
begin
  FreeAndNil(FMsgList);
  inherited;
end;

procedure TBatchMessage.ClearMsg;
begin
  FMsgList.Clear;
end;

procedure TBatchMessage.AddMsg(AMsg: string);
begin
  if not Contains(AMsg) then
    FMsgList.Add(AMsg);
end;

procedure TBatchMessage.AddDistinctMsg(AMsg: string);
begin
  if not Contains(AMsg) then
    AddMsg(AMsg);
end;

procedure TBatchMessage.AssignMsg(Source: TPersistent);
begin
  FMsgList.Clear;
  FMsgList.Assign(Source);
end;

function TBatchMessage.HasMsg: Boolean;
begin
  Result := FMsgList.Count > 0;
end;

function TBatchMessage.Contains(AMsg: string): Boolean;
begin
  Result := FMsgList.IndexOf(AMsg) >= 0;
end;

procedure TBatchMessage.ShowBatchMsg;
begin
  SuperBatchMessageBox(FMsgList);
end;

procedure TBatchMessage.ShowWarningBatchMsg;
begin
  SuperBatchMessageBox(FMsgList, mbtWarning);
end;

procedure TBatchMessage.ShowErrorBatchMsg;
begin
  SuperBatchMessageBox(FMsgList, mbtError);
end;

function TBatchMessage.ConfirmYesNoBatchMsg: Boolean;
begin
  if SuperBatchMessageBox(FMsgList, mbtConfirmation, True) then
    Result := True
  else
    Result := False;
end;

function TBatchMessage.ConfirmOKCancelBatchMsg: Boolean;
begin
  if SuperBatchMessageBox(FMsgList, mbtConfirmation, True, False) then
    Result := True
  else
    Result := False;
end;
{ TBatchMessage End }

//procedure CheckError(bFlag: Boolean; AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
//begin
//  if bFlag then
//  begin
//    SuperMessageBox(AMessage, ACaption, AMsgType);
//    Abort;
//  end;
//end;
//
//procedure ThrowErrorMsg(AMessage: string; AMsgType: TMessageBoxType = mbtWarning; ACaption: string = '');
//begin
//  SuperMessageBox(AMessage, ACaption, AMsgType);
//  Abort;
//end;
//
//procedure CheckMessage(bFlag: Boolean; AMessage1, AMessage2: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = '');
//begin
//  if bFlag then
//    SuperMessageBox(AMessage1, ACaption, AMsgType)
//  else
//    SuperMessageBox(AMessage2, ACaption, AMsgType);
//end;
//
////提示警告信息
//procedure ShowWarningMsg(AMessage: string);
//begin
//  SuperMessageBox(AMessage, '', mbtWarning);
//end;
//
////提示错误信息
//procedure ShowErrorMsg(AMessage: string);
//begin
//  SuperMessageBox(AMessage, '', mbtError);
//end;
//
//function ConfirmYesNo(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
//begin
//  if SuperMessageBox(AMessage, ACaption, AMsgType, [mbbYes, mbbNo]) = mrYes then
//    Result := True
//  else
//    Result := False;
//end;
//
//function ConfirmOKCancel(AMessage: string; AMsgType: TMessageBoxType = mbtInformation; ACaption: string = ''): Boolean;
//begin
//  if SuperMessageBox(AMessage, ACaption, AMsgType, mbbOKCancel) = mrOk then
//    Result := True
//  else
//    Result := False;
//end;

end.
