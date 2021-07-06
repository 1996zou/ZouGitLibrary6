unit uDataSetHelper;

interface

uses
  DB, Variants, Classes, DbClient, SysUtils, ugpMemDataset, ugpDbUtility;

type
  TDataSetFormater = class(TObject)
  private
    class procedure CloneDataSetInternal(ASource, ATarget: TDataSet);
  protected
    FDataSet: TClientDataSet;
    FResultSet: TgpMemDataset;
  public
    constructor Create(ADataSet: TClientDataSet);
    destructor Destroy; override;
    //复制一个数据集的结构到另一个数据集
    class procedure CopyDataSetStructure(ASource, ATarget: TClientDataSet); overload;
    class procedure CopyDataSetStructure(ASource: TClientDataSet;ATarget: TgpMemDataset); overload;
    //复制当前行的数据到另一个数据集
    class procedure CopyDataSetCurrentRecord(ASource, ATarget: TDataSet);
    //克隆一个数据集
    class function CloneDataSet(ASource: TClientDataSet): TClientDataSet;
  end;

implementation

{ TDataSetFormater }

class function TDataSetFormater.CloneDataSet(ASource: TClientDataSet): TClientDataSet;
begin
  Result := TClientDataSet(ugpDbUtility.CloneDataset(ASource, TClientDataSet));
end;

class procedure TDataSetFormater.CloneDataSetInternal(ASource,
  ATarget: TDataSet);
var
  i: Integer;
begin
  ATarget.FieldDefs.Clear;
  for i := 0 to ASource.FieldDefs.Count - 1 do
  begin
    with ATarget.FieldDefs.AddFieldDef do
    begin
      Name := ASource.FieldDefs.Items[I].Name;
      DataType := ASource.FieldDefs.Items[I].DataType;
      Size := ASource.FieldDefs.Items[I].Size;
    end;
  end;
end;

class procedure TDataSetFormater.CopyDataSetStructure(ASource,
  ATarget: TClientDataSet);
begin
  CloneDataSetInternal(ASource, ATarget);
  if ATarget.Active then
    ATarget.Close;
  ATarget.CreateDataSet;
end;

class procedure TDataSetFormater.CopyDataSetStructure(ASource: TClientDataSet;
  ATarget: TgpMemDataset);
begin
  CloneDataSetInternal(ASource, ATarget);
  if ATarget.Active then
    ATarget.Close;
  ATarget.CreateDataSet;
end;

class procedure TDataSetFormater.CopyDataSetCurrentRecord(ASource,
  ATarget: TDataSet);
var
  i: Integer;
begin
  for i := 0 to ASource.Fields.Count - 1 do
    ATarget.Fields[i].Value := ASource.Fields[i].Value;
end;

constructor TDataSetFormater.Create(ADataSet: TClientDataSet);
begin
  FResultSet := TgpMemDataset.Create(nil);
  FDataSet := ADataSet;
  CopyDataSetStructure(FDataSet, FResultSet);
end;

destructor TDataSetFormater.Destroy;
begin
  inherited;
  FreeAndNil(FResultSet);
end;

end.
