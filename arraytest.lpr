program arraytest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  Types,
  ArrayHelper,
  Sysutils ,
  StrUtils,
  tensors ,
  Math ,
  quickchart,
  HiresTimer, complexarray
  { you can add units after this };

  //procedure WriteLn(const X:TDoubleTensor);
  //begin
  //  system.WriteLn(string(X));
  //end;
  //procedure WriteLn(const X:TExtendedTensor);
  //begin
  //  system.WriteLn(string(X));
  //end;
  //procedure WriteLn(const X:TSingleTensor);
  //begin
  //  system.WriteLn(string(X));
  //end;


var
  T,TT:QWord;
  aa:TDoubleDynArray;
  X, A, v2,re: TDoubleTensor;
  i,N,j,k:integer; cc,cc2:TComplexArrayD;
  s:TStringArray; theta,v:double;
  function _sin(x:Double):Double;begin exit(RandG(sin(x),0.2));end;


begin

  //ten:=specialize TCustomVec<Single>.Create([[3,3],[4,4],[5,5]]);
  //ten.uniform();

  //writeln(d.toString(' ,',2));
  //writeln('Min:[%.2f], Max:[%.2f]',[d.Min,d.Max]);
  //Chart.DataCount:=1;
  //d:=TDoubleDynArray.uniform(10,10).sort;
  //if Chart.DataCount>0 then Chart.Remove(0);
  //Chart.Add(d,gsLine);
  //writeln(d);
  //writeln('Min:[%.2f], Max:[%.2f]',[Chart.Ranges[0].minVal,Chart.Ranges[0].maxVal]);
  //exit;

  // ((x * 6 -15) * x + 10) * power(x,3)
  // (6*power(x,2) -15*x + 10) * power(x,3)
  //10*x^3 -15*x^4 +6*x^5
    X:=[ TDoubleDynArray.fill(100,1)
        ,TDoubleDynArray.polynomial(100,[0,1])
        ,TDoubleDynArray.polynomial(100,[0,0,1])
        ,TDoubleDynArray.polynomial(100,[0,0,0,1])
        ,TDoubleDynArray.polynomial(100,[0,0,0,0,1])
        ,TDoubleDynArray.polynomial(100,[0,0,0,0,0,1])
        ,TDoubleDynArray.polynomial(100,[0,0,0,0,0,0,1])
        ];
  v2:=TDoubleDynArray.fill(100,0,0.01).map(TSimpleMapDoubleFunc(@_sin));
//  //v2:=TDoubleDynArray.fill(100,0,2*PI*0.01,0.1).Sin;
//
//  //writeln(#13#10'X :');
//  //writeln(X);
  A:=X.Multiply(X.Transpose );
  A:=A.inverse;
//
  writeln(string(A));
  A:=A.Multiply(X);
  re:=A.Multiply(v2);
  //writeln(#13#10'D.v2 = Result :');
  writeln(string(re));

  while plot.DataCount>0 do
    plot.Remove(0);
////
  plot.add(v2.data,gsScatter);
  plot.add(TDoubleDynArray.polynomial(100,re.Data),gsLine);
////  aa:=[1,2,3,4,5,6,7,8,9,0,11,22,33,44,55];
////  s.Count:=100;
////
////  for i:=0 to 99 do begin
////    s[i]:=format('%f',[sin(i*0.25)]);
////  end;
//  //cc:=aa.fft();
//  //writeln(cc);
//    plot.showplot;
  readln;
  exit;

  writeln(format('CPU speed = %d, Max speed = %d', [HighResTimer.CPUSpeed,HighResTimer.CPUMaxSpeed]));
  aa:=TDoubleDynArray.{Uniform(1024,1,0.5); }Uniform(100,0.1,-1);
  i:=0;
  TT:=GetTickCount64;
  T:=HighResTimer.MicroSeconds;
//  while t+1000>GetTickCount64 do
    begin
      cc:=aa.fft();
      inc(i);
    end;
  TT:=GetTickCount64-TT;
  T:=HighResTimer.MicroSeconds-T;
  //writeln('[FFT] Loops: [%d], %s per loop',[i,ifthen(i>=1000,format('%fus',[1000000/i]),format('%fms',[1000/i]))]);
  system.writeln(format('[FFT] : %d sample size @ [%s]',[aa.count,IfThen(T>=1000,format('%fms',[T/1000]),format('%fus',[T*1.0]))]));
 // Application.ProcessMessages;
  i:=0;
  TT:=GetTickCount64;
  T:=HighResTimer.MicroSeconds;
//  while t+1000>GetTickCount64 do
    begin


      begin
        N:=Length(aa);//.Count;
        setLength(cc2,n);
        for k:=0 to N-1 do with cc2[k] do begin
          re:=0;im:=0;
          for j:=0 to N-1 do begin
            theta:=PIx2*k*j/N;
            re:=re+aa[j]*system.Cos(theta);
            im:=im-aa[j]*system.Sin(theta);
            //twid:=ucomplex.cexp(-i*PIx2*k*j/N);
            //result[k]:=result[k]+self[j]*twid
          end;
        end;
      end;


    end;
  TT:=GetTickCount64-TT;
  T:=HighResTimer.MicroSeconds-T;

  system.writeln(format('[DFT] : %d sample size @ [%s]',[aa.count,ifthen(T>=1000,format('%fms',[T/1000]),format('%fus',[T*1.0]))]));
 // Application.ProcessMessages;
  //aa:=TDoubleDynArray.fill(1024,0,0.2).sin.mul(2);
  //chart.add(aa,gsLine);


  //chart.add(aa,gsLine);
  //plot.add(aa,gsLine);
  //plot.add(cc2,gsLine);
  //plot.ShowPlot;
  exit;
  //writeln(10002.5253);

  //d.count:=10;
  //for i:=0 to 10-1 do d[i]:=fade(i*0.1) ;
  //
  //Chart.Add(TDoubleDynArray.polynomial(10,[0,0,0,10,-15,6],0.1),gsScatter);
  //Chart.add(d,gsLine);



  //chart.Add(v2.data,gsScatter);
  //chart.Add(TDoubleDynArray.polynomial(100,v.data),gsLine);

  //chart.Add(v2.Data,gsScatter);
  //chart.add(TDoubleDynArray.polynomial(100,v.data),gsLine);

  //v:=[
  //  [1,2,3,6,3,1,2,3,6,3]
  // ,[4,5,2,7,4,4,5,2,7,4]
  // ,[1,3,5,2,0,1,3,5,2,0]
  // ,[2,2,5,4,8,2,2,5,4,8]
  // ,[1,2,0,4,7,1,2,0,4,7]
  //];
  //v.uniform(5.0);
  //writeln(v);
  //V1:=[
  //     [1,2,5,3,8]
  //    ,[5,6,7,3,8]
  //    ,[9,1,2,4,8]
  //    ,[9,1,2,6,6]
  //    ,[9,1,2,6,9]
  //    ,[1,2,5,3,8]
  //    ,[5,6,7,3,8]
  //    ,[9,1,2,4,8]
  //    ,[9,1,2,6,6]
  //    ,[9,1,2,6,9]
  //    ];
  //v1.uniform(10.0);
  //writeln(v1);
  ////v:=v.map(@log);
  ////writeln(v.sort.toString);
  ////writeln(v.Shape);
  //writeln(
  //  v1.multiply(v)
  //  );
  //);
 //       writeln(v1.inverse);
  //writeln(v1.Cofactors);

  //ten.free   ;

end.

