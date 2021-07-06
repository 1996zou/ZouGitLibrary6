{
  ���ļ��еĺ���Ϊ������ʹ�õ��ĺ��������뱣��������Dll�ᱨ��
}
unit uDllValid;

interface

uses SysUtils, Classes, uDataStructure, Generics.Collections;

function GetDllCaption: string; stdcall;
function GetDllDeveloper: string; stdcall;
function GetMainVersion: string; stdcall;
function PlugInNeedCheckKeyNo(AProductInfo: TDictionary<string, string>;
      var PubKeyNo: string; var ATrialBillCount: Integer; var APlugInCheckTrialEnded: Boolean;
      var APlugInOnlineReg: Boolean): Boolean; stdcall stdcall;
function GetSqlFilePath(FileName: string; AppPath: string): string; stdcall;
function UnRegisterPlugin: string; stdcall;
function GetDllFileVersion: string; stdcall;
function CheckValid(sMainVersion: string; var errMsg: string): Boolean; stdcall;
function GetAllRegMenus(nPubVersion2: Integer): TArray<TMenuRegType>; stdcall;

const
  Pub_Version = ''; //�˴�Ϊ��Dll���õİ汾�����ù�ó��Ϊ  GM,  ���ò�ó��Ϊ  CMSQ������������Ϊ��
  Pub_Dll_File_Version = '21.0.1001.25000018';     //Dll�ļ��汾�ţ�����DLL�Զ�����

exports
  GetDllCaption,
  GetDllDeveloper,
  GetMainVersion,
  PlugInNeedCheckKeyNo,
  GetSqlFilePath,
  UnRegisterPlugin,
  GetDllFileVersion,
  CheckValid,
  GetAllRegMenus;

implementation

uses uDllMenuRegister, XWComponentType, uDllComm, uDllDBService,
  uDllMessageIntf;

//���ز�������ƣ�����Ϊ��
function GetDllCaption: string; stdcall;
begin
  Result := '�ͻ����������������˵�����';
end;

// ����Ŀ�����˾�������ߣ�������Ϊ��
function GetDllDeveloper: string; stdcall;
begin
  Result := '���ݿ�������Ƽ����޹�˾';
end;

//�ⲿ���ýӿڣ����ڷ���Dll�ļ������ð汾
function GetMainVersion: string; stdcall;
begin
  Result := Pub_Version;
end;

//�����Ҫע����Ĳ��������True  ���򷵻�False��ͨ��ע����Ĳ���뽫ע����д��PubKeyNo
function PlugInNeedCheckKeyNo(AProductInfo: TDictionary<string, string>;
      var PubKeyNo: string; var ATrialBillCount: Integer; var APlugInCheckTrialEnded: Boolean;
      var APlugInOnlineReg: Boolean): Boolean; stdcall stdcall;
begin
  //PubKeyNo := '123456';
  //APlugInOnlineReg := False;
  //APlugInCheckTrialEnded := True;
  Result := False;     //����Ҫע����ʾ�ʹ�false
end;

//�˺������ڸ�Dllע���ʱ����ã����ڳ�ʼ��ϵͳ����Ҫִ�е�Sql���
//1�������ڴ˺�����ִ�и�Dll�����������Sql���
//2�����Է������������������Ŀ¼��Sql�ļ���������������ø�Sql�ļ�����ִ��(���磺���� MyFile\myExeSql.sql)
//3������Ϊ�ձ�ʾ���ļ���Ҫִ��
function GetSqlFilePath(FileName: string; AppPath: string): string; stdcall;
{$IFDEF HASSQL}
  var
    Res: TResourceStream;
{$ENDIF}
begin
  //���SQL ��  Update  File  Update.Sql
  //�������Ҫִ�е�Sql����SQL���Ȼ��ʹ�����ε���δ���
  {$IFDEF HASSQL}
    Res := TResourceStream.Create(HInstance, 'Update', PChar('File'));
    try
      Res.SaveToFile(AppPath + '\' + Trim(FileName) + 'Update.Sql');
      Result := Trim(FileName) + 'Update.Sql';
    finally
      FreeAndNil(Res);
    end;
  {$ELSE}
    Result := '';
  {$ENDIF}
end;

//ж�ز���󣬰���Ӧ�Ĳ˵����������
function UnRegisterPlugin: string; stdcall;
begin
  Result := '';
end;

//�ⲿ���ýӿڣ�����DLL�ļ��汾���������������Զ����ز��������汾���������ļ��汾�Ų�һ�£�����������
function GetDllFileVersion: string; stdcall;
begin
  Result := Pub_Dll_File_Version;
end;

//�ⲿ���ýӿڣ����ڼ��Dll�ļ��ĺϷ��ԣ��������Ϊ��ǰ���汾�ţ���Dll��ʼ����ʱ��ִ��
function CheckValid(sMainVersion: string; var errMsg: string): Boolean; stdcall;
begin
  Result := True;
end;

//����������Ҫע����ʾ�Ĳ˵�����������˵�
function GetAllRegMenus(nPubVersion2: Integer): TArray<TMenuRegType>; stdcall;
var
  FMenuRegType: TMenuRegType;
begin
  //�����ж��ٸ��˵������ö���������������10���˵�
//�����ж��ٸ��˵������ö���������������10���˵�
  SetLength(Result, 1);

  //�������һ���˵�
  FMenuRegType.DllName := ADllName;
  FMenuRegType.FunctionNo := 25180001;
  FMenuRegType.ParentNo := 0;
  FMenuRegType.SonNum := 0;
  FMenuRegType.Caption := '�ͻ����������������˵�����';
  FMenuRegType.DetailNos := '';
  Result[0] := FMenuRegType;

end;

end.
