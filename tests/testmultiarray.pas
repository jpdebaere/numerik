unit testmultiarray;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, multiarray, numerik;

type

  TTestMultiArray = class(TTestCase)
  published
    procedure TestBroadcastMatrixScalar;
    procedure TestSlicing2D;
    procedure TestSlicing2DAddScalar;
    procedure TestSlicing2DAddTransposed;
    procedure TestTranspose;

    procedure TestReduceSimple;
    procedure TestReduceStacked;
  end;

var
  M: TMultiArray;

implementation

procedure TTestMultiArray.TestBroadcastMatrixScalar;
begin
  M := TMultiArray([1, 2, 3, 4]).Reshape([2, 2]);
  AssertTrue(VectorsEqual((M + 2).GetVirtualData, [3, 4, 5, 6]));
end;

procedure TTestMultiArray.TestSlicing2D;
var
  M: TMultiArray;
begin
  M := TMultiArray(TSingleVector(Range(1, 10))).Reshape([3, 3]);
  M := M.Slice([[0, 2], [1]]); // ==> [[2], [8]]
  Assert(VectorsEqual(M.GetVirtualData, [2, 8]));
end;

procedure TTestMultiArray.TestSlicing2DAddScalar;
begin
  M := TMultiArray(TSingleVector(Range(1, 10))).Reshape([3, 3]);
  M := M.Slice([[0, 2], [1]]) + 10;
  Assert(VectorsEqual(M.GetVirtualData, [12, 18]));
end;

procedure TTestMultiArray.TestSlicing2DAddTransposed;
begin
  M := TMultiArray(TSingleVector(Range(1, 10))).Reshape([3, 3]);
  M := M.Slice([[0, 2], [1]]);
  M := M.T + M;
  AssertTrue(VectorsEqual(M.GetVirtualData, [4, 10, 10, 16]));
end;

procedure TTestMultiArray.TestTranspose;
begin
  M := [1, 2, 3, 4, 5, 6];
  M := M.Reshape([2, 3]);
  AssertTrue(VectorsEqual(M.T.GetVirtualData, [1, 4, 2, 5, 3, 6]));
end;

procedure TTestMultiArray.TestReduceSimple;
begin
  M := TMultiArray([1, 2, 3, 4, 5, 6]).Reshape([2, 3]);
  M := ReduceSum(M, 0);
  AssertTrue(VectorsEqual(M.GetVirtualData, [5, 7, 9]));
end;

procedure TTestMultiArray.TestReduceStacked;
begin
  M := TMultiArray([1, 2, 3, 4, 5, 6]).Reshape([2, 3]);
  M := ReduceSum(ReduceSum(M, 0), 0);
  AssertTrue(VectorsEqual(M.GetVirtualData, [21]));
end;

initialization
  RegisterTest(TTestMultiArray);

end.

