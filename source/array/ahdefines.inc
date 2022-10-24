{$macro on}

{$define _INLINE:=inline;}

{$define _DOMAP_:=var i,C:integer; begin C:=Length(Self);setLength(result,C);for i:=0 To C-1 do Result[i]:=func(Self[i],i,Self); end}

{$define _SIMPLEMAP_:=var i,C:integer; begin C:=Length(Self);setLength(result,C);for i:=0 To C-1 do Result[i]:=func(Self[i]); end}

{$define _REDUCE_:=var i,l:integer;begin l:=Length(Self); if l>0 then result:=func(init,self[0],0,Self);if l>1 then for i:=1 to l-1 do result:=func(result,self[i],i,self) end}

{$define _SIMPLEREDUCE_:=var i,l:integer; begin l:=Length(Self); if l>0 then result:=self[0]; for i:=1 to l-1 do result:=func(result,self[i]) end}

{$define _DOSORT_:=begin if Assigned(CompareFunc) then QuickSort(Self, 0, High(Self),CompareFunc) else QuickSort(Self, 0, High(Self),@cmp);result:=self end}

{$define _SORTED_:=begin result:=copy(self);result.sort(CompareFunc) end}

{$define _ISSORTED_:=var i:integer; begin  result:=true; if not Assigned(CompareFunc) then CompareFunc:={$ifdef fpc}@{$endif}Self.cmp; if descending then for i:=1 to high(Self) do if CompareFunc(Self[i-1],Self[i])<0 then begin result:=false; exit() end else else for i:=1 to high(Self) do if CompareFunc(Self[i],Self[i-1])<0 then begin result:=false; exit() end end}

{$define _DOCOUNT_:=begin Result:=Length(Self) end}

{$define _SETCOUNT_:= begin if AValue=GetCount then exit; SetLength(Self,AValue);end}

//{$define _PUSH_:=begin result:=v;System.insert(v,Self,Length(Self)) end}

{$define _PUSH_:=var C:integer;begin c:=Length(Self)+1; SetLength(Self,C); Self[C-1]:=v;result:=v end}

{$define _POP_:=var C:integer;begin C:=Length(Self); if C>0 then begin  result:=Self[C-1];  SetLength(Self,C-1) end;end}

//{$define _SHIFT_:=var i,C:integer;begin C:=Length(Self); result:=Self[0];System.Delete(Self,0,1) end}

{$define _SHIFT_:=var i,C:integer;begin C:=Length(Self); result:=Self[0];for i:=1 to C-1 do Self[i-1]:=Self[i];SetLength(Self,C-1) end}

{$define _UNSHIFT_:=var i,C:integer;begin C:=Length(Self); setLength(Self,C+1);for i:=C downto 1 do Self[i]:=Self[i-1];Self[0]:=v;result:=v end}

{$define _SLICE_:=var i,C:integer;begin C:=Length(Self); if start<0 then start:=C+start;if _end<0 then _end:=C + _end; result:=copy(Self,start,_end - start) end}

// Should only return array of the deleted part
{$define _SPLICE_:=var l,n,i,C:integer;begin C:=Length(Self);if start<0 then start:=C+start;   l:=Length(Items); if deleteCount>0 then result:=copy(Self,start,deleteCount) else result:=nil;
  n:=l-deleteCount ; if n>0 then  begin setLength(Self,C+n);C:=C+n;for i:=C-1 downto start+1 do Self[i]:=Self[i-1] end;
  if n<0 then begin  for i:=start to C-1+n do Self[i]:=Self[i-n];SetLength(Self,C+n) end;if l>0 then for i:=0 to l-1 do Self[start+i]:=Items[i];end}

{$define _EXTRACT_:=var i:integer; begin setLength(result,Length(Indecies)); for i:=0 to High(Indecies) do result[i]:=Self[Indecies[i]] end}

{$define _SCATTER_:=var i:integer; begin assert(High(Indecies)<=High(Values)); for i:=0 to High(Indecies) do Self[Indecies[i]]:=Values[i] end}

{$define _TRANSPOSE_:=var i,j:integer; begin Assert(Assigned(Self),'must be a 2D Array'); setLength(Result, Length(Self[0]));for i:=0 to length(result)-1 do begin setLength(Result[i], Length(Self)); for j:=0 to Length(Self)- 1 do Result[i,j]:=Self[j,i] end end}

{$define _CONCAT_:=var l,i,C:integer; begin C:=Length(Self);l:=Length(Items);setLength(Result,C+l);if (Self<>Result) and (C>0) then Move(Self[0],Result[0],C*SizeOf(Result[0]));for i:=0 to l-1 do Result[C+i]:=Items[i] end}

{$define _INDEXOF_:=var C:integer; begin C:=Length(Self);for result:=0 to C-1 do if Self[result]=val then exit;result:=-1  end}

{$define _FIND_:=var i,j:integer; begin j:=0;setLength(result, Length(Self));for i:=0 to High(Self) do if func(Self[i]) then begin result[j]:=i;inc(j) end;setLength(result,j) end}

{$define _FINDVALS1_:=var i,j,k:integer; begin j:=0;setLength(result, Length(Self));for i:=0 to High(Self) do begin for k:=0 to high(Values) do if Values[k]=Self[i] then begin result[j]:=i;inc(j);break end end;setLength(result,j) end}

{$define _FINDVALS2_:=var i,j:integer; begin j:=0;setLength(result, Length(Self));for i:=0 to High(Self) do if Self[i]=Value then begin result[j]:=i;inc(j) end;setLength(result,j) end}

{$define _FILTER_:=var i,j,C:integer; begin C:=Length(Self);j:=0;setLength(result,C); for i:=0 to C-1 do if func(Self[i],i,@Self[0]) then begin Result[j]:=Self[i];inc(j) end;setLength(result,j) end}

{$define _AADD_:=var i,C1:integer; begin C1:=Arr.Count;Assert(C1=Arr2.Count,'Array elements must match befor adding'); setLength(result,C1); for i:=0 to C1-1 do result[i]:=Arr[i]+Arr2[i] end}

{$define _ASUB_:=var i,C1:integer; begin C1:=Arr.Count;Assert(C1=Arr2.Count,'Array elements must match befor substract'); setLength(result,C1); for i:=0 to C1-1 do result[i]:=Arr[i]-Arr2[i] end}

{$define _AMUL_:=var i,C1:integer; begin C1:=Arr.Count;Assert(C1=Arr2.Count,'Array elements must match befor multiply'); setLength(result,C1); for i:=0 to C1-1 do result[i]:=Arr[i]*Arr2[i] end}

{$define _ADIV_:=var i,C1:integer;begin C1:=Arr.Count;Assert(C1=Arr2.Count,'Array elements must match!'); setLength(result,C1); for i:=0 to C1-1 do result[i]:=trunc(Arr[i] / Arr2[i]) end}

{$define _ADIVIDE_:=var i,C1:integer; begin C1:=Arr.Count;Assert(C1=Arr2.Count,'Array elements must match!'); setLength(result,C1); for i:=0 to C1-1 do result[i]:=Arr[i] / Arr2[i] end}

{$define _ADD_:=var i,C:integer; begin C:=arr.count;setLength(result,C); for i:=0 to C-1 do result[i]:=Arr[i]+v end}

{$define _SUB1_:=var i,C:integer; begin C:=arr.count;setLength(result,C); for i:=0 to C-1 do result[i]:=Arr[i]-v end}

{$define _SUB2_:=var i,C:integer; begin C:=arr.count;setLength(result,C); for i:=0 to C-1 do result[i]:=v-Arr[i] end}

{$define _MUL_:=var i,C:integer; begin C:=arr.count;setLength(result,C); for i:=0 to C-1 do result[i]:=Arr[i]*v end}

{$define _DIV1_:=var i,C:integer; begin C:=arr.count;setLength(result,C); for i:=0 to C-1 do result[i]:=trunc(Arr[i] / v) end}

{$define _DIVIDE1_:=var i,C:integer; begin C:=arr.count;setLength(result,C); for i:=0 to C-1 do result[i]:=Arr[i] / v end}

{$define _DIV2_:=var i,C:integer; begin C:=arr.count;setLength(result,C); for i:=0 to C-1 do result[i]:=trunc(v/Arr[i]) end}

{$define _DIVIDE2_:=var i,C:integer; begin C:=arr.count;setLength(result,C); for i:=0 to C-1 do result[i]:=v/Arr[i] end}

{$define _REVERSE_:=var C,i:integer;begin C:=High(Self);setLength(result,C+1); for i:=0 to C do result[i]:=Self[C-i] end}

{$define _EVERY_:=var i:integer;begin result:=true; for i:=0 to aCount-1 do if not func(dst[i],i,dst) then begin Result:=false; exit; end; end}

{$define _SOME_:=var i:integer;begin result:=false; for i:=0 to aCount-1 do if func(dst[i],i,dst) then begin Result:=true; exit; end; end}


