unit uBillMessageComm;

interface

uses SysUtils, Classes, Controls, Generics.Collections, uDataStructure;

type
  //单据批量提示
  TBillBatchMessage = class
  private
    FMsgList: TList<TBillMessageInfo>;
    FStockMsgList: TList<TBillMessageInfo>;
    FCommissionMsgList: TList<TBillMessageInfo>;
    FFactStockMsgList: TList<TBillMessageInfo>;
    FWorkShowMsgList: TList<TBillMessageInfo>;
    FSerialNoMsgList: TList<TBillMessageInfo>;
    FFactSerialNoMsgList: TList<TBillMessageInfo>;
    FProduceStockMsgList: TList<TBillMessageInfo>;
    FConsignStockMsgList: TList<TBillMessageInfo>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ClearMsg;
    procedure AddMsg(AMsg: string);
    procedure AddStockMsg(FBillMessageInfo: TBillMessageInfo);
    procedure AddCommissionMsg(FBillMessageInfo: TBillMessageInfo);
    procedure AddFactStockMsg(FBillMessageInfo: TBillMessageInfo);
    procedure AddWorkShopMsg(FBillMessageInfo: TBillMessageInfo);
    procedure AddSerialNoMsg(FBillMessageInfo: TBillMessageInfo);
    procedure AddFactSerialNoMsg(FBillMessageInfo: TBillMessageInfo);
    procedure AddProduceStockMsg(FBillMessageInfo: TBillMessageInfo);
    procedure AddConsignStockMsg(FBillMessageInfo: TBillMessageInfo);
    procedure ShowBatchMsg;
    procedure ShowWarningBatchMsg;
    procedure ShowErrorBatchMsg;
    procedure ShowBatchMsgModaless;
    procedure ShowWarningBatchMsgModaless;
    procedure ShowErrorBatchMsgModaless;

    function HasMsg: Boolean;
    function ConfirmYesNoBatchMsg: Boolean;
    function ConfirmOKCancelBatchMsg: Boolean;
    function ConfirmYesNoBatchMsgModaless: Boolean;
    function ConfirmOKCancelBatchMsgModaless: Boolean;
  end;

implementation

uses uDllMessageIntf;

{ TBillBatchMessage }
constructor TBillBatchMessage.Create;
begin
  FMsgList := TList<TBillMessageInfo>.Create;
  FStockMsgList := TList<TBillMessageInfo>.Create;
  FCommissionMsgList := TList<TBillMessageInfo>.Create;
  FFactStockMsgList := TList<TBillMessageInfo>.Create;
  FWorkShowMsgList := TList<TBillMessageInfo>.Create;
  FSerialNoMsgList := TList<TBillMessageInfo>.Create;
  FFactSerialNoMsgList := TList<TBillMessageInfo>.Create;
  FProduceStockMsgList := TList<TBillMessageInfo>.Create;
  FConsignStockMsgList := TList<TBillMessageInfo>.Create;

  FMsgList.Clear;
  FStockMsgList.Clear;
  FCommissionMsgList.Clear;
  FFactStockMsgList.Clear;
  FWorkShowMsgList.Clear;
  FSerialNoMsgList.Clear;
  FFactSerialNoMsgList.Clear;
  FProduceStockMsgList.Clear;
  FConsignStockMsgList.Clear;
end;

destructor TBillBatchMessage.Destroy;
begin
  FreeAndNil(FMsgList);
  FreeAndNil(FStockMsgList);
  FreeAndNil(FCommissionMsgList);
  FreeAndNil(FFactStockMsgList);
  FreeAndNil(FWorkShowMsgList);
  FreeAndNil(FSerialNoMsgList);
  FreeAndNil(FFactSerialNoMsgList);
  FreeAndNil(FProduceStockMsgList);
  FreeAndNil(FConsignStockMsgList);
  inherited;
end;

procedure TBillBatchMessage.ClearMsg;
begin
  FMsgList.Clear;
  FStockMsgList.Clear;
  FCommissionMsgList.Clear;
  FFactStockMsgList.Clear;
  FWorkShowMsgList.Clear;
  FSerialNoMsgList.Clear;
  FFactSerialNoMsgList.Clear;
  FProduceStockMsgList.Clear;
  FConsignStockMsgList.Clear;
end;

procedure TBillBatchMessage.AddMsg(AMsg: string);
var
  FBillMessageInfo: TBillMessageInfo;
begin
  FBillMessageInfo.ErrMsg := AMsg;

  if FMsgList.IndexOf(FBillMessageInfo) < 0 then
    FMsgList.Add(FBillMessageInfo);
end;

procedure TBillBatchMessage.AddStockMsg(FBillMessageInfo: TBillMessageInfo);
begin
  if FStockMsgList.IndexOf(FBillMessageInfo) < 0 then
    FStockMsgList.Add(FBillMessageInfo);
end;

procedure TBillBatchMessage.AddCommissionMsg(FBillMessageInfo: TBillMessageInfo);
begin
  if FCommissionMsgList.IndexOf(FBillMessageInfo) < 0 then
    FCommissionMsgList.Add(FBillMessageInfo);
end;

procedure TBillBatchMessage.AddFactStockMsg(FBillMessageInfo: TBillMessageInfo);
begin
  if FFactStockMsgList.IndexOf(FBillMessageInfo) < 0 then
    FFactStockMsgList.Add(FBillMessageInfo);
end;

procedure TBillBatchMessage.AddWorkShopMsg(FBillMessageInfo: TBillMessageInfo);
begin
  if FWorkShowMsgList.IndexOf(FBillMessageInfo) < 0 then
    FWorkShowMsgList.Add(FBillMessageInfo);
end;

procedure TBillBatchMessage.AddSerialNoMsg(FBillMessageInfo: TBillMessageInfo);
begin
  if FSerialNoMsgList.IndexOf(FBillMessageInfo) < 0 then
    FSerialNoMsgList.Add(FBillMessageInfo);
end;

procedure TBillBatchMessage.AddFactSerialNoMsg(FBillMessageInfo: TBillMessageInfo);
begin
  if FFactSerialNoMsgList.IndexOf(FBillMessageInfo) < 0 then
    FFactSerialNoMsgList.Add(FBillMessageInfo);
end;

procedure TBillBatchMessage.AddProduceStockMsg(FBillMessageInfo: TBillMessageInfo);
begin
  if FProduceStockMsgList.IndexOf(FBillMessageInfo) < 0 then
    FProduceStockMsgList.Add(FBillMessageInfo);
end;

procedure TBillBatchMessage.AddConsignStockMsg(FBillMessageInfo: TBillMessageInfo);
begin
  if FConsignStockMsgList.IndexOf(FBillMessageInfo) < 0 then
    FConsignStockMsgList.Add(FBillMessageInfo);
end;

function TBillBatchMessage.HasMsg: Boolean;
begin
  Result := (FMsgList.Count > 0) or (FStockMsgList.Count > 0) or (FCommissionMsgList.Count > 0) or
            (FFactStockMsgList.Count > 0) or (FWorkShowMsgList.Count > 0) or (FSerialNoMsgList.Count > 0) or
            (FFactSerialNoMsgList.Count > 0) or (FProduceStockMsgList.Count > 0) or (FConsignStockMsgList.Count > 0);
end;

procedure TBillBatchMessage.ShowBatchMsg;
begin
  SuperBillBatchMessageBox(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                            FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList);
end;

procedure TBillBatchMessage.ShowWarningBatchMsg;
begin
  SuperBillBatchMessageBox(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                            FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtWarning);
end;

procedure TBillBatchMessage.ShowErrorBatchMsg;
begin
  SuperBillBatchMessageBox(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                            FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtError);
end;

function TBillBatchMessage.ConfirmYesNoBatchMsg: Boolean;
begin
  if SuperBillBatchMessageBox(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                              FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtConfirmation, True) = TMessageResult.Ok then
    Result := True
  else
    Result := False;
end;

function TBillBatchMessage.ConfirmOKCancelBatchMsg: Boolean;
begin
  if SuperBillBatchMessageBox(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                              FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtConfirmation, True, False) = TMessageResult.Ok then
    Result := True
  else
    Result := False;
end;

procedure TBillBatchMessage.ShowBatchMsgModaless;
begin
  SuperBillBatchMessageBoxModaless(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                            FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList);
end;

procedure TBillBatchMessage.ShowWarningBatchMsgModaless;
begin
  SuperBillBatchMessageBoxModaless(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                            FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtWarning);
end;

procedure TBillBatchMessage.ShowErrorBatchMsgModaless;
begin
  SuperBillBatchMessageBoxModaless(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                            FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtError);
end;

function TBillBatchMessage.ConfirmYesNoBatchMsgModaless: Boolean;
var
  FMessageResult: TMessageResult;
begin
  FMessageResult := SuperBillBatchMessageBox(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                              FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtConfirmation, True, True, True);
  if FMessageResult = TMessageResult.Ok then
    Result := True
  else
  begin
    if FMessageResult = TMessageResult.ReOpen then
    begin
      SuperBillBatchMessageBoxModaless(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                            FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtWarning);
    end;

    Result := False;
  end;
end;

function TBillBatchMessage.ConfirmOKCancelBatchMsgModaless: Boolean;
var
  FMessageResult: TMessageResult;
begin
  FMessageResult := SuperBillBatchMessageBox(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                              FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtConfirmation, True, False, True);
  if FMessageResult = TMessageResult.Ok then
    Result := True
  else
  begin
    if FMessageResult = TMessageResult.ReOpen then
    begin
      SuperBillBatchMessageBoxModaless(FMsgList, FStockMsgList, FCommissionMsgList, FFactStockMsgList, FWorkShowMsgList,
                            FSerialNoMsgList, FFactSerialNoMsgList, FProduceStockMsgList, FConsignStockMsgList, mbtWarning);
    end;

    Result := False;
  end;
end;
{ TBillBatchMessage End }

end.
