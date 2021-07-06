unit uDllFAIntf;

interface

uses SysUtils, uFAIntf;

function LoadCountVch(nVchType: Integer; nModeNo: Integer; nOriginvchcode: Integer): Boolean;
function EditCountVch(AVchtype, AVchCode: Longint; cLib, cTag: Char; cFromVch: Char = 'N'): Integer;
function EditCountVchNew(AVchtype, AVchCode: Longint; cLib, cTag: Char; cFromVch: Char = 'N'; IsOtherLoad: Boolean = False): Integer;
procedure LoadReport(AReport: string);
//�򿪻���ڼ�
function ShowPeriodSet(IsShow: Boolean = True): Boolean;
//�������ڳ�
procedure ShowCWBeginData;

var
  FAIntf: IFAIntf;

implementation

function LoadCountVch(nVchType: Integer; nModeNo: Integer; nOriginvchcode: Integer): Boolean;
begin
  Result := FAIntf.LoadCountVch(nVchType, nModeNo, nOriginvchcode);
end;

function EditCountVch(AVchtype, AVchCode: Longint; cLib, cTag: Char; cFromVch: Char = 'N'): Integer;
begin
  Result := FAIntf.EditCountVch(AVchtype, AVchCode, cLib, cTag, cFromVch);
end;

function EditCountVchNew(AVchtype, AVchCode: Longint; cLib, cTag: Char; cFromVch: Char = 'N'; IsOtherLoad: Boolean = False): Integer;
begin
  Result := FAIntf.EditCountVchNew(AVchtype, AVchCode, cLib, cTag, cFromVch, IsOtherLoad);
end;

procedure LoadReport(AReport: string);
begin
  FAIntf.LoadReport(AReport);
end;

//�򿪻���ڼ�
function ShowPeriodSet(IsShow: Boolean = True): Boolean;
begin
  Result := FAIntf.ShowPeriodSet(IsShow);
end;

//�������ڳ�
procedure ShowCWBeginData;
begin
  FAIntf.ShowCWBeginData;
end;

end.
