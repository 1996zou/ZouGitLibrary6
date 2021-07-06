unit uDllMenuRegister;

interface

uses Dialogs, Generics.Collections, Controls,SysUtils,ugpstdgrids;

const
  ADllName = 'ReaccountQueryPtypeReport.dll';  //这个为当前dll的名称，不能为其他，否则程序会出错，例如: ADllName = 'TestDll.dll'

type
  TReLoadBill = procedure(ABillParams: TDictionary<string, string>) of object;

procedure InitDllFunc; stdcall;
function CallFunction(AFunctionNoType: string): Boolean; stdcall;
procedure MainBillMenuLoadProc(AParams: TDictionary<string, string>; AControlParams: TList<TControl>; AReLoadBill: TReLoadBill); stdcall;


exports
  InitDllFunc, CallFunction,MainBillMenuLoadProc;

implementation

uses uDllComm,uMRPReport,XwTable,XwGjpBasicCom,XwGGeneralWGrid,uDllBillInterface,uDllDBService, DB, DBClient;

//这里添加模块
procedure InitDllFunc; stdcall;
begin
  FDllFuncDictionary.Add(ADllName + '客户往来按存货结算对账单报表', ShowMRPReport);

end;

//外部调用的接口，这个为标准格式，不用改变
function CallFunction(AFunctionNoType: string): Boolean;
var
  FCallDllFunction: TCallDllFunction;
begin
  if FDllFuncDictionary.TryGetValue(AFunctionNoType, FCallDllFunction) and Assigned(FCallDllFunction) then
    Result := FCallDllFunction
  else
    Result := False;
end;

procedure MainBillMenuLoadProc(AParams: TDictionary<string, string>; AControlParams: TList<TControl>; AReLoadBill: TReLoadBill); stdcall;
var
  i,l,selectRow:Integer;
  price,taxrate,qty,total:Double;
  snumber,pfullname,ptypeid,szSQL,sVchcode:string;
  iControl :TControl;
  edtUserDefined16 :TCMGLabelBtnEdit;
  edtBtype :TCMGLabelBtnEdit;
  mainGrid:TXwGGeneralWGrid;

  vchtype, vchcode, menuCaption,dlyorder: string;
  FVchcode,FVchtype: Integer;

  rowRecordSet: TClientDataSet;
  j: Integer;
  fieldvalues,field,value,value1:string;
  column:TgpCustomStdColumn;
begin
  AParams.TryGetValue('Vchtype', vchtype);
    AParams.TryGetValue('Vchcode', vchcode);
    AParams.TryGetValue('MenuCaption', menuCaption);
    FVchcode := StrToIntDef(vchcode,0);
    FVchtype := StrToIntDef(vchtype,0);
    //if FVchcode<=0 then  Exit;

//    if SameText( menuCaption,'获取采购价') then
//    begin
//      //获取表头控件和表体控件
//      for i := 0 to AControlParams.Count-1 do
//      begin
//
//          if (AControlParams[i] is TCMGLabelBtnEdit) then
//          begin
//              //ShowMessage(AControlParams[i].Name);
//              if SameText(AControlParams[i].Name,'edtBtype') then
//               begin
//                  edtBtype := AControlParams[i] as TCMGLabelBtnEdit;
//               end;
//          end;
//          if (AControlParams[i] is TXwGGeneralWGrid) then
//          begin
//              if SameText(AControlParams[i].Name,'mainGrid') then
//               begin
//                  mainGrid := AControlParams[i] as TXwGGeneralWGrid;
//               end;
//          end;
//
//      end;
//      //ShowMessage(MainGrid.CMGetCellTextStrByDBName('unit',mainGrid.RowIndex));
////      for l := 0 to mainGrid.ColumnsCount-1 do
////      begin
////          //value1 := (mainGrid.Columns[l].Tag);  TgpCustomStdColumn
////          //column := mainGrid.Columns[l];
////          field := mainGrid.Columns[l].Name+'-'+mainGrid.Columns[l].FieldName;
////
////          //mainGrid.Columns[l].FieldName;
////          value := mainGrid.GetCellValue(mainGrid.Columns[l],mainGrid.RowIndex);
////          fieldvalues := fieldvalues + field + ':' +value+#13#10;
////      end;
////      ShowMessage(fieldvalues);
//
//      Exit;
//      for j := 1 to mainGrid.DataRowCount do
//      begin
//          rowRecordSet:= TClientDataSet.Create(nil);
//          ptypeid:=MainGrid.CMGetCellTextStrByDBName('Ptypeid',j-1);
//
//          OpenSQL(Format('Select price,tax From T_Inf_PurchasePrice_11000008 Where draft=2 and BTypeID = ''%s'' and PTypeID = ''%s''',[edtBtype.Value,ptypeid]),rowRecordSet) ;
//          if not rowRecordSet.Eof then
//          begin
//             price := rowRecordSet.FindField('price').Value;
//             taxrate := rowRecordSet.FindField('tax').Value;
//             qty := mainGrid.CMGetCellValueByFloat('qty',j-1);
//             if qty>0 then
//             begin
//                 total := price * qty;
//             end else
//             begin
//               total := price;
//             end;
//              mainGrid.CMSetCellValueByDBName('tax',j-1,taxrate); //税率
//              mainGrid.CMSetCellValueByDBName('price',j-1,price); //单价
//              mainGrid.CMSetCellValueByDBName('taxprice',j-1,price*(1+taxrate/100)); //含税单价
//              mainGrid.CMSetCellValueByDBName('taxtotal',j-1,price*taxrate);  //税额
//              mainGrid.CMSetCellValueByDBName('total',j-1,total);  //金额
//              mainGrid.CMSetCellValueByDBName('discount',j-1,1);   //折扣
//              mainGrid.CMSetCellValueByDBName('discountprice',j-1,price*(1+taxrate/100)); //折后单价
//              mainGrid.CMSetCellValueByDBName('discounttotal',j-1,total*(1+taxrate/100)); //折后金额
//              mainGrid.CMSetCellValueByDBName('tax_total',j-1,total*(1+taxrate/100));   //价税合计
//      end;
//      FreeAndNil(rowRecordSet);
//      end;
//       // showImportBillDialog(mainGrid,edtBtype.Value);
//    end;




end;

end.
