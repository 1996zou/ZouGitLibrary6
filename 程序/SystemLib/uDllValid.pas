{
  该文件中的函数为主程序使用到的函数，必须保留，否则Dll会报错
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
  Pub_Version = ''; //此处为该Dll适用的版本：适用工贸则为  GM,  适用财贸则为  CMSQ，两个都适用为空
  Pub_Dll_File_Version = '21.0.1001.25000018';     //Dll文件版本号，用于DLL自动下载

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

//返回插件的名称，不能为空
function GetDllCaption: string; stdcall;
begin
  Result := '客户往来按存货结算对账单报表';
end;

// 插件的开发公司（开发者），不能为空
function GetDllDeveloper: string; stdcall;
begin
  Result := '广州客派网络科技有限公司';
end;

//外部调用接口，用于返回Dll文件的适用版本
function GetMainVersion: string; stdcall;
begin
  Result := Pub_Version;
end;

//如果需要注册码的插件，返回True  否则返回False，通用注册码的插件请将注册码写入PubKeyNo
function PlugInNeedCheckKeyNo(AProductInfo: TDictionary<string, string>;
      var PubKeyNo: string; var ATrialBillCount: Integer; var APlugInCheckTrialEnded: Boolean;
      var APlugInOnlineReg: Boolean): Boolean; stdcall stdcall;
begin
  //PubKeyNo := '123456';
  //APlugInOnlineReg := False;
  //APlugInCheckTrialEnded := True;
  Result := False;     //不需要注册提示就传false
end;

//此函数将在该Dll注册的时候调用，用于初始化系统中需要执行的Sql语句
//1、可以在此函数中执行该Dll运行所必须的Sql语句
//2、可以返回相对于主程序的相对目录的Sql文件名，由主程序调用该Sql文件进行执行(例如：返回 MyFile\myExeSql.sql)
//3、返回为空表示无文件需要执行
function GetSqlFilePath(FileName: string; AppPath: string): string; stdcall;
{$IFDEF HASSQL}
  var
    Res: TResourceStream;
{$ENDIF}
begin
  //打包SQL 如  Update  File  Update.Sql
  //如果有需要执行的Sql，将SQL打包然后使用屏蔽的这段代码
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

//卸载插件后，把相应的菜单数据清理掉
function UnRegisterPlugin: string; stdcall;
begin
  Result := '';
end;

//外部调用接口，返回DLL文件版本，用于主程序中自动下载插件，如果版本号与配置文件版本号不一致，则重新下载
function GetDllFileVersion: string; stdcall;
begin
  Result := Pub_Dll_File_Version;
end;

//外部调用接口，用于检测Dll文件的合法性，传入参数为当前主版本号，在Dll初始化的时候执行
function CheckValid(sMainVersion: string; var errMsg: string): Boolean; stdcall;
begin
  Result := True;
end;

//返回所有需要注册显示的菜单，包括父项菜单
function GetAllRegMenus(nPubVersion2: Integer): TArray<TMenuRegType>; stdcall;
var
  FMenuRegType: TMenuRegType;
begin
  //这里有多少个菜单就设置多少项，我这里假设有10个菜单
//这里有多少个菜单就设置多少项，我这里假设有10个菜单
  SetLength(Result, 1);

  //添加其中一个菜单
  FMenuRegType.DllName := ADllName;
  FMenuRegType.FunctionNo := 25180001;
  FMenuRegType.ParentNo := 0;
  FMenuRegType.SonNum := 0;
  FMenuRegType.Caption := '客户往来按存货结算对账单报表';
  FMenuRegType.DetailNos := '';
  Result[0] := FMenuRegType;

end;

end.
