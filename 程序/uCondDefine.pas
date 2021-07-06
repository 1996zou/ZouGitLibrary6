unit uCondDefine;

interface

uses
  Classes, XWComponentType, xwgtypedefine, uDllCondBox;

var
  SaleFeeCondtion: TCondition;
  SaleBillCondtion: TCondition;


implementation

uses uDllDataBaseIntf,uDllDBService,uDllComm; //, SysDef;

initialization
  with SaleFeeCondtion do
  begin
    SetLength(ConditionSet, 5);

    ConditionSet[0].ConditionType := CMbtDateBegin;
    ConditionSet[0].ControlType := ctDate;

    ConditionSet[1].ConditionType := CMbtDateEnd;
    ConditionSet[1].ControlType := ctDate;

    ConditionSet[2].ConditionType := CMbtCType;
    ConditionSet[2].XWBasicType := btBCtype;
    ConditionSet[2].ControlType := ctButtonEdit;
    ConditionSet[2].SelectOptions := [bopSelectClass, bopAllSelect];
    ConditionSet[2].DataType := dtString;

    ConditionSet[3].ConditionType := CMbtBillNumber1;
    ConditionSet[3].XWBasicType:=btNo;
    ConditionSet[3].ControlType:=ctButtonEdit;
    ConditionSet[3].DataType:=dtString;
    ConditionSet[3].CanModifySelectEdit:=True;
    ConditionSet[3].Caption:='���ݱ��';

    ConditionSet[4].ConditionType := CMbtLevel;
    ConditionSet[4].ControlType := ctCheckBox;
    ConditionSet[4].Caption := '����������ɵĵ���';
    ConditionSet[4].DataType := dtInteger;

    ImageIndex := 0;
    Title := '��ѯ����';
  end; // with

   with SaleBillCondtion do
  begin
    SetLength(ConditionSet, 6);

    ConditionSet[0].ConditionType := CMbtDateBegin;
    ConditionSet[0].ControlType := ctDate;

    ConditionSet[1].ConditionType := CMbtDateEnd;
    ConditionSet[1].ControlType := ctDate;

    ConditionSet[2].ConditionType := CMbtVchtype;
    ConditionSet[2].ControlType := ctValueComBoBox;
    ConditionSet[2].Caption := '��������';
    ConditionSet[2].DisplayValue := TStringList.Create;
    ConditionSet[2].ReturnValue := TStringList.Create;
    ConditionSet[2].DisplayValue.Add('ȫ������');
    ConditionSet[2].ReturnValue.Add('0');
    ConditionSet[2].DisplayValue.Add('���۵�');
    ConditionSet[2].ReturnValue.Add('11');
    ConditionSet[2].DisplayValue.Add('�����˻���');
    ConditionSet[2].ReturnValue.Add('45');
    ConditionSet[2].DisplayValue.Add('ί�н��㵥');
    ConditionSet[2].ReturnValue.Add('26');

    ConditionSet[3].ConditionType := CMbtCType;
    ConditionSet[3].XWBasicType := btBCtype;
    ConditionSet[3].ControlType := ctButtonEdit;
    ConditionSet[3].SelectOptions := [bopSelectClass, bopAllSelect];
    ConditionSet[3].DataType := dtString;

    ConditionSet[4].ConditionType := CMbtPType;
    ConditionSet[4].XWBasicType := btPType;
    ConditionSet[4].ControlType := ctButtonEdit;
    ConditionSet[4].DataType := dtString;
    ConditionSet[4].SelectOptions := [bopAllSelect];

    ConditionSet[5].ConditionType := CMbtBillNumber1;
    ConditionSet[5].XWBasicType:=btNo;
    ConditionSet[5].ControlType:=ctButtonEdit;
    ConditionSet[5].DataType:=dtString;
    ConditionSet[5].CanModifySelectEdit:=True;
    ConditionSet[5].Caption:='���ݱ��';

    ImageIndex := 0;
    Title := '��ѯ����';
  end; // with
  
finalization
//  FreeCondition(CondBillFactOutLib);

end.

