unit oprs_simd;
{$ALIGN               32}
{$Codealign RECORDMIN=32}
{$Codealign RECORDMAX=32}
{$Codealign  LOCALMIN=32}
{$Codealign  LOCALMAX=32}
{$Codealign    VARMIN=32}
{$Codealign    VARMAX=32}
{$Codealign  CONSTMIN=32}
{$Codealign  CONSTMAX=32}
{$packrecords C}
{.$FPUType AVX2}
{$SafeFPUExceptions OFF}
{.$goto on}
{$macro on}

{.$undef fpc}
{$ifndef fpc}
  {$mode delphi}
{$endif}
{$H+} //use long strings
{.$W-} // stackframes off
{$define EXPAND_MM}
{$define assem:=assembler;register}
{$define nf:=nostackframe;assembler;register}

interface

uses
  Classes, Types, SysUtils;

type
  TInt32Array=array of int32;

  __m128=packed record case boolean of false:(a,b,c,d:single);true: (id : array[0..3] of single) end;
  __m128i=packed record case boolean of false:(a,b,c,d:int32);true: (id : array[0..3] of int32) end;
  __m128q=packed record case boolean of false:(a,b:int64);true: (id : array[0..1] of int64) end;
  __m128d=packed record case boolean of false:(a,b:double);true: (id : array[0..1] of double) end;
  __m256=packed record case boolean of false:(a,b,c,d,e,f,g,h:single);true: (id : array[0..7] of single) end;
  __m256i=packed record case boolean of false:(a,b,c,d,e,f,g,h:int32);true: (id : array[0..7] of int32) end;
  __m256q=packed record case boolean of false:(a,b,c,d:int64);true: (id : array[0..3] of int64) end;
  __m256d=packed record case boolean of false:(a,b,c,d:double);true: (id : array[0..3] of double) end;


(*

  1- Microsoft (x64 only ) calling convention states that the lower 128bit part of the (xmm6 to xmm15) simd registers are non-volatile thus they must be preserved be the callee(PUSHED/POPED) before exiting function
   read :
    https://docs.microsoft.com/en-us/cpp/build/x64-calling-convention?view=msvc-170
    https://docs.microsoft.com/en-us/cpp/build/x64-software-conventions?redirectedfrom=MSDN&view=msvc-170
  2- Microsoft x64 Non-volitile registers:
     - R12:R15
     - RDI, RSI, RBX, RBP, RSP, xmm6:xmm15
  3- On Unix like systems, we don't have to preserve SIMD registers but do need to preserve (RBX, RSP, RBP, and R12–R15)

  4- in windows x68 mode ,the calling convention with no stackframe seems to be (rcx , rdx, r8, r9, rax) instead of (rcx , rdx, r8, rbp+0x30)

*)

procedure interleave_s(const dst1,dst2,a:psingle;const Count:integer);              assem;//overload;
procedure interleave_d(const dst1,dst2,a:pdouble;const Count:integer);              assem;//overload;
function bulkDot_s(const a,b:PSingle;const Count:integer):Single;                   assem;overload;
function bulkDot_d(const a,b:PDouble;const Count:integer):Double;                   assem;overload;
function bulkDot_s(const a,b:PSingle;const bStride,Count:integer):Single; assem; overload;
function bulkDot_d(const a,b:PDouble;const bStride,Count:integer):Double; assem; overload;
procedure bulkAdd_ss(const dst,a:PSingle;const b:PSingle;const Count:integer);      assem;//overload;
procedure bulkSub_ss(const dst,a:PSingle;const from:PSingle;const Count:integer);   assem;//overload;
procedure bulkMul_ss(const dst,a:PSingle;const b:PSingle;const Count:integer);      assem;//overload;
procedure bulkDiv_ss(const dst,denom:PSingle;const nom:PSingle;const Count:integer);assem;//overload;
procedure bulkAdd_sd(const dst,a:PDouble;const b:PDouble;const Count:integer);      assem;//overload;
procedure bulkSub_sd(const dst,a:PDouble;const from:PDouble;const Count:integer);   assem;//overload;
procedure bulkMul_sd(const dst,a:PDouble;const b:PDouble;const Count:integer);      assem;//overload;
procedure bulkDiv_sd(const dst,denom:PDouble;const nom:PDouble;const Count:integer);assem;//overload;
procedure bulkAdd_s(const dst,a,b:PSingle;const Count:integer);                     assem;//overload;
procedure bulkAdd_d(const dst,a,b:PDouble;const Count:integer);                     assem;//overload;
procedure bulkSub_s(const dst,a,b:PSingle;const Count:integer);                     assem;//overload;
procedure bulkSub_d(const dst,a,b:PDouble;const Count:integer);                     assem;//overload;
procedure bulkMul_s(const dst,a,b:PSingle;const Count:integer);                     assem;//overload;
procedure bulkMul_d(const dst,a,b:PDouble;const Count:integer);                     assem;//overload;
procedure bulkDiv_s(const dst,a,b:PSingle;const Count:integer);                     assem;//overload;
procedure bulkDiv_d(const dst,a,b:PDouble;const Count:integer);                     assem;//overload;
procedure bulkAXPY_s(const dst,x,y:PSingle;const Count:integer;const a:PSingle);    assem;
procedure bulkAXPY_d(const dst,x,y:PDouble;const Count:integer;const a:PDouble);    assem;
procedure bulkAXPBY_s(const dst,x,y:PSingle;const Count:integer;const a,b:PSingle); assem;
procedure bulkAXPBY_d(const dst,x,y:PDouble;const Count:integer;const a,b:PDouble); assem;

procedure bulkSum_s(const dst,a:PSingle;const Count:integer);                       assem;
procedure bulkSum_d(const dst,a:PDouble;const Count:integer);                       assem;

procedure bulkMax_s(const dst,a:PSingle;const Count:integer);                       assem;
procedure bulkMax_d(const dst,a:PDouble;const Count:integer);                       assem;

procedure bulkMin_s(const dst,a:PSingle;const Count:integer);                       assem;
procedure bulkMin_d(const dst,a:PDouble;const Count:integer);                       assem;

procedure bulkAbs_s(const dst,a:PSingle;const Count:integer);                       assem;
procedure bulkAbs_d(const dst,a:PDouble;const Count:integer);                       assem;

procedure bulkSqr_s(const dst,a:Psingle;const Count:integer);                       assem;
procedure bulkSqr_d(const dst,a:PDouble;const Count:integer);                       assem;
procedure bulkSqrt_s(const dst,a:Psingle;const Count:integer);                      assem;
procedure bulkSqrt_d(const dst,a:PDouble;const Count:integer);                      assem;
procedure bulkRSqrt_s(const dst,a:Psingle;const Count:integer);                      assem;
//  no SIMD RSqrt instruction for packed doubles in intel x64!

procedure bulkSumSqr_s(const dst,a:PSingle;const Count:integer);                    assem;
procedure bulkSumSqr_d(const dst,a:PDouble;const Count:integer);                    assem;

procedure bulkSumAbs_s(const dst,a:PSingle;const Count:integer);  assem;
procedure bulkSumAbs_d(const dst,a:PDouble;const Count:integer);  assem;

procedure bulkGathera_s(const dst,a:PSingle;const aStride:Longint ;const Count:integer); assem;
procedure bulkGathera_d(const dst,a:PDouble;const aStride:Longint ;const Count:integer); assem;

procedure bulkDiffSqr_s(const dst,a,b:PSingle;const Count:integer);assem;
procedure bulkDiffSqr_d(const dst,a,b:PDouble;const Count:integer);assem;
procedure bulkDiffSqr_ss(const dst,a,b:PSingle;const Count:integer);assem;
procedure bulkDiffSqr_sd(const dst,a,b:PDouble;const Count:integer);assem;



// complex number array operation complex to complex
procedure bulkMul_ccs(const dst,a,b:PSingle;const Count:integer);             assem;
procedure bulkMul_ccd(const dst,a,b:PDouble;const Count:integer);             assem;

procedure bulkDiv_ccs(const dst,a,b:PSingle;const Count:integer);             assem;
procedure bulkDiv_ccd(const dst,a,b:PDouble;const Count:integer);             assem;

procedure bulkAdd_ccs(const dst,a,b:PSingle;const Count:integer);             assem;
procedure bulkAdd_ccd(const dst,a,b:PDouble;const Count:integer);             assem;

procedure bulkSub_ccs(const dst,a,b:PSingle;const Count:integer);             assem;
procedure bulkSub_ccd(const dst,a,b:PDouble;const Count:integer);             assem;

procedure bulkMag_cs(const dst,a:PSingle;const Count:integer);                assem;
procedure bulkMag_cd(const dst,a:PDouble;const Count:integer);                assem;

procedure bulkAdd_css(const dst, a, b:PSingle;const Count:integer);           assem;
procedure bulkAdd_csd(const dst, a, b:PDouble;const Count:integer);           assem;

procedure bulkSub_css(const dst, a, b:PSingle;const Count:integer);           assem;
procedure bulkSub_csd(const dst, a, b:PDouble;const Count:integer);           assem;

procedure bulkMul_css(const dst, a, b:PSingle;const Count:integer);           assem;
procedure bulkMul_csd(const dst, a, b:PDouble;const Count:integer);           assem;

procedure bulkDiv_css(const dst, a, b:PSingle;const Count:integer);           assem;
procedure bulkDiv_csd(const dst, a, b:PDouble;const Count:integer);           assem;

{ dot product (Count) of reals array (re) by complex array(b) and put the results in (dst) }
procedure bulkDot_cvs(const dst, re, b:Psingle;const Count:integer); assem;
procedure bulkDot_cvd(const dst,re,b:PDouble;const Count:integer); assem;


procedure bulkDot_ccs(const dst, a, b: PSingle; const Count: integer);assem;
procedure bulkDot_ccd(const dst, a, b: PDouble; const Count: integer);assem;

//procedure bulkGemm_s(const dst,a,b:PSingle;const lda,ldb,ldc:integer);assem;
//procedure bulkGemm_d(const dst,a,b:PDouble;const lda,ldb,ldc:integer);assem;

procedure bulkConv_s(const dst,a,f:PSingle;const Count,K{Kernel Size}:Integer;const add:boolean=false); assem;
procedure bulkConv_d(const dst,a,f:PDouble;const Count,K{Kernel Size}:Integer;const add:boolean=false); assem;

procedure bulkConv2d_s(const dst,a,f:PSingle;const Width,Height,P,Q{Kernel Size}:Integer);
procedure bulkConv2d_d(const dst,a,f:PDouble;const Width,Height,P,Q{Kernel Size}:Integer);

{$ifdef USE_AVX512}
procedure bulkDot512_cvs(const dst, re, b:Psingle;const Count:integer); assem;
{$endif}

procedure bulkMul_cvs(const dst, re, b: PSingle; const Count: integer); assem;
procedure bulkMul_cvd(const dst, re, b: PDouble; const Count: integer); assem;
{just multiply a complex (a) by a complex (b) but the result in (dst)}
procedure mul_ccs(const dst, a, b:PSingle);assem;
procedure mul_ccd(const dst, a, b: PDouble); assem;

procedure kahanSum_s(const dst, x:PSingle;const Count:integer);assem;
procedure kahanSum_d(const dst, x:PDouble;const Count:integer);assem;
procedure bulkMulSplit_ccs(const dst,ds2,re,r2,im,i2:PSingle;const N:integer);assem;
//var
//  bulkAdd_s   :TProcFFF;
//  bulkAdd_d   :TProcDDD;
//  bulkAdd_ss  :TProcFFV;
//  bulkAdd_sd  :TProcDDV;
//  bulkSub_s   :TProcFFF;
//  bulkSub_d   :TProcDDD;
//  bulkSub_ss  :TProcFFV;
//  bulkSub_sd  :TProcDDV;
//  bulkMul_s   :TProcFFF;
//  bulkMul_d   :TProcDDD;
//  bulkMul_ss  :TProcFFV;
//  bulkMul_sd  :TProcDDV;
//  bulkDiv_s   :TProcFFF;
//  bulkDiv_d   :TProcDDD;
//  bulkDiv_ss  :TProcFFV;
//  bulkDiv_sd  :TProcDDV;
//  bulkDot_s   :TFuncFFV;
//  bulkDot_d   :TFuncDDV;
//  interleave_s:TProcFFF;
//  interleave_d:TProcFFF;


 implementation
 const
   zmmD:packed array[0..15] of longword=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
   zmmQ:packed array[0..7] of qword    =(0,1,2,3,4,5,6,7);
   ymmD:packed array[0..7] of longword=(0,1,2,3,4,5,6,7);
   ymmQ:packed array[0..3] of qword   =(0,1,2,3);
   xmmD:packed array[0..3] of longword=(0,1,2,3);
   xmmQ:packed array[0..1] of qword   =(0,1);
   mskD:packed array[0..7] of int32   =(-1,-1,-1,-1,-1,-1,-1,-1);
   mskQ:packed array[0..3] of int64   =(-1,-1,-1,-1);

{$ifdef fpc}

operator := (const r:__m256):string;
begin
  result:=format('[%f %f %f %f %f %f %f %f]',[r.id[0],r.id[1],r.id[2],r.id[3],r.id[4],r.id[5],r.id[6],r.id[7]])
end;

operator := (const r:__m256i):string;
begin
  result:=format('[%d %d %d %d %d %d %d %d]',[r.id[0],r.id[1],r.id[2],r.id[3],r.id[4],r.id[5],r.id[6],r.id[7]])
end;

operator := (const r:__m256d):string;
begin
  result:=format('[%f %f %f %f]',[r.id[0],r.id[1],r.id[2],r.id[3]]);
end;

operator := (const r:__m256q):string;
begin
  result:=format('[%d %d %d %d]',[r.id[0],r.id[1],r.id[2],r.id[3]]) ;
end;
{$endif}
//{.$asmmode gas}

procedure interleave_s(const dst1,dst2,a:psingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*2{(element count per register) X (number of bulk repeates)};
const shifter=4;// log2(16) { bulk elements count }
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst1, %rdi
       mov dst2, %rsi
       mov a, %rdx
       mov Count, %ecx
    {$endif}
  xor       %rax, %rax
  mov Count, %r8d
  shr shifter, %ecx  // C div 16 ;  16 is the (8= ymm register size in element) X (2= number of repeats)
  jz .LskipBulk

.LBulkLoop:
  vinsertf128 $0,   (%rdx,%rax,2),%ymm0, %ymm0                // load first  4 elements [1,2,3,4]              to mm0
  vinsertf128 $0, 16(%rdx,%rax,2),%ymm1, %ymm1                // load first 4 elements [ 5, 6, 7, 8] elements  to mm1
  vinsertf128 $1, 32(%rdx,%rax,2),%ymm0, %ymm0                // load second 4 elements [9,10,11,12] elements  to mm0
  vinsertf128 $1, 48(%rdx,%rax,2),%ymm1, %ymm1                // load second 4 elements [13,14,15,16] elements to mm1

  vshufps $0b10001000, %ymm1, %ymm0, %ymm2                   //select [1,3] from m0 and [5,7] from m1, m2 now is [1,3,5,7, 9,11,13,15]
  vshufps $0b11011101, %ymm1, %ymm0, %ymm3                   //select [2,4] from m0 and [6,8] from m1, m3 now is [2,4,6,8,10,12,14,14]

  vmovups %ymm2, (%rdi,%rax,1)
  vmovups %ymm3, (%rsi,%rax,1)

  add $32, %rax
  //add $64, %rdx
  //add $32, %rdi
  //add $32, %rsi
  dec      %ecx
  jg  .LBulkLoop

.LskipBulk:
  mov %r8d, %ecx
  and $0xf, %ecx         // reminder of 16
  shr   $1, %ecx         // divide by 2
  jz .Ldone
.LsmallMov:
  mov (%rdx),%r8d
  mov 4(%rdx),%eax
  mov %r8d,(%rdi)
  mov %eax,(%rsi)
  add sz,   %rdi
  add sz,   %rsi
  add sz*2, %rdx
  dec %ecx
  jnz .LsmallMov
.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}

end;

procedure interleave_d(const dst1,dst2,a:pdouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*2{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(8) { bulk elements count }
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst1, %rdi
       mov dst2, %rsi
       mov a, %rdx
       mov Count, %ecx
    {$endif}

  mov Count, %r8d
  shr shifter, %ecx  // C div 8 ;  8 is the (4= ymm register size in element) X (2= number of repeats)
  jz .LskipBulk

.LBulkLoop:
  vinsertf128 $0,   (%rdx),%ymm0, %ymm0                // load first  4 elements [1,2]
  vinsertf128 $1, 32(%rdx),%ymm0, %ymm0                // load second 4 elements [5,6] elements
  vinsertf128 $0, 16(%rdx),%ymm1, %ymm1                // load second 4 elements [ 3, 4] elements
  vinsertf128 $1, 48(%rdx),%ymm1, %ymm1                // load second 4 elements [ 7, 8] elements

  vshufpd $0b0000, %ymm1, %ymm0, %ymm2                   //select [1,3] from m0 and [5,7] from m1, m2 now is [1,3,5,7]
  vshufpd $0b1111, %ymm1, %ymm0, %ymm3                   //select [2,4] from m0 and [6,8] from m1, m3 now is [2,4,6,8]

  vmovupd %ymm2, (%rdi)
  vmovupd %ymm3, (%rsi)

  add $64, %rdx
  add $32, %rdi
  add $32, %rsi
  dec      %ecx
  jg  .LBulkLoop

.LskipBulk:
  mov %r8d, %ecx
  and $0x7, %ecx     // reminder of 8
  shr   $1, %ecx     // divide by 2
  jz .Ldone
.LsmallMov:
  vmovsd  (%rdx),%xmm0
  vmovsd 8(%rdx),%xmm1
  vmovsd %xmm0,(%rdi)
  vmovsd %xmm1,(%rsi)
  add sz,   %rdi
  add sz,   %rsi
  add sz*2, %rdx
  dec %ecx
  jnz .LsmallMov
.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}

end;


function bulkDot_s(const a,b:PSingle;const Count:integer):Single;nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov a, %rdi
       mov b, %rsi
       mov Count, %rdx
    {$endif}
      //push %rax
      xor %rax,%rax
      vpxor %ymm0, %ymm0, %ymm0                                      //reset ymm0
      mov Count  , %ecx
      shr shifter+2 , %ecx                                         // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      jz .LskipBulk
      {$ifdef EXPAND_MM}
      vpxor %ymm2, %ymm2, %ymm2                                      //reset ymm2
      //vpxor %ymm4, %ymm4, %ymm4                                      //reset ymm4
      //vpxor %ymm6, %ymm6, %ymm6                                      //reset ymm6
      {$endif}

  .LbulkLoop:
      vmovups           (%rdi,%rax,sz), %ymm1
      {$ifdef EXPAND_MM}
      vfmadd231ps       (%rsi,%rax,sz), %ymm1, %ymm0
      vmovups       0x20(%rdi,%rax,sz), %ymm3
      vfmadd231ps   0x20(%rsi,%rax,sz), %ymm3, %ymm2
      vmovups     2*0x20(%rdi,%rax,sz), %ymm1
      vfmadd231ps 2*0x20(%rsi,%rax,sz), %ymm1, %ymm0
      vmovups     3*0x20(%rdi,%rax,sz), %ymm3
      vfmadd231ps 3*0x20(%rsi,%rax,sz), %ymm3, %ymm2
      {$else}
      vfmadd231ps       (%rsi,%rax,sz), %ymm1, %ymm0
      vmovups       0x20(%rdi,%rax,sz), %ymm1
      vfmadd231ps   0x20(%rsi,%rax,sz), %ymm1, %ymm0
      vmovups     2*0x20(%rdi,%rax,sz), %ymm1
      vfmadd231ps 2*0x20(%rsi,%rax,sz), %ymm1, %ymm0
      vmovups     3*0x20(%rdi,%rax,sz), %ymm1
      vfmadd231ps 3*0x20(%rsi,%rax,sz), %ymm1, %ymm0
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
      {$ifdef EXPAND_MM}
      vaddps      %ymm2, %ymm0, %ymm0
      //vaddps      %ymm6, %ymm4, %ymm4
      //vaddps      %ymm4, %ymm0, %ymm0
      {$endif}
  .LskipBulk:

      mov Count , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovups         (%rdi,%rax,sz), %ymm1
      vfmadd231ps     (%rsi,%rax,sz), %ymm1, %ymm0
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , Count  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jz .Ldone

      vmovd Count, %xmm3
      vpbroadcastd %xmm3,%ymm3
      vpcmpgtd ymmD(%rip), %ymm3, %ymm3
      vmaskmovps (%rdi,%rax,sz), %ymm3, %ymm1
      vfmadd231ps (%rsi,%rax,sz), %ymm1, %ymm0
  .Ldone:
      vextractf128   $1, %ymm0, %xmm1
      //vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      //vdpps $0b11110001, %xmm1, %xmm0, %xmm0
      vaddps     %xmm1, %xmm0, %xmm0
      vhaddps    %xmm0, %xmm0, %xmm0
      vhaddps    %xmm0, %xmm0, %xmm0
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

function bulkDot_s(const a,b:Psingle;const bStride,Count:integer):Single;nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi

       mov a, %rdi
       mov b, %rsi
       mov bStride, %edx
       mov Count, %ecx
    {$endif}

  mov             %ecx        ,     %r8d
  vmovd           %edx        ,     %xmm1             //stride
  vpbroadcastd    %xmm1       ,     %ymm1             //stride
  vpmulld         ymmD(%rip)  ,     %ymm1,    %ymm1   //gather offset
  imulq           regSize     ,     %rdx              //loop offset
  vxorps          %ymm0       ,     %ymm0,    %ymm0   //reselt packed result
  shr             shifter+2   ,     %ecx
  jz              .LskipBulk

  vxorps          %ymm5       ,     %ymm5,    %ymm5   //reset packed result
  //vxorps          %ymm8       ,     %ymm8,    %ymm8   //reset packed result
  //vxorps          %ymm9       ,     %ymm9,    %ymm9   //reset packed result
.LbulkLoop:

// we think that the mask ymm2 is cleared after eash gather instruction so we set it?
  //vmovups         mskD(%rip) ,  %ymm2
  vpcmpeqd        %ymm2,            %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdps      %ymm2,            (%rsi,%ymm1,sz), %ymm3
  vfmadd231ps         (%rdi) ,       %ymm3,  %ymm0

  lea             (%rsi,%rdx),      %rsi
  vpcmpeqd        %ymm2,            %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdps      %ymm2,            (%rsi,%ymm1,sz), %ymm4
  vfmadd231ps     0x20(%rdi) ,       %ymm4,  %ymm5

  lea             (%rsi,%rdx),      %rsi
  vpcmpeqd        %ymm2,            %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdps      %ymm2,            (%rsi,%ymm1,sz), %ymm3
  vfmadd231ps     0x40(%rdi) ,       %ymm3,  %ymm0

  lea             (%rsi,%rdx),      %rsi
  vpcmpeqd        %ymm2,            %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdps      %ymm2,            (%rsi,%ymm1,sz), %ymm4
  vfmadd231ps     0x60(%rdi) ,       %ymm4,  %ymm5

  lea             (%rsi,%rdx),      %rsi
  add             stride*sz  ,       %rdi

  dec             %ecx
  jnz             .LbulkLoop

  vaddps          %ymm0      ,    %ymm5       , %ymm0
  //vaddps          %ymm8      ,    %ymm9       , %ymm8
  //vaddps          %ymm8      ,    %ymm0       , %ymm0

.LskipBulk:
  mov             %r8d, %ecx
  and             stride-1, %ecx
  shr             shifter,  %ecx              // count div 8
  jz              .LskipShort

.LshortLoop:
// we think that the mask ymm2 is cleared after eash gather instruction so we set it?
  //vpbroadcastd    %xmm4      ,  %ymm2
  //vmovups         mskD(%rip) ,  %ymm2
  vpcmpeqd        %ymm2,        %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdps      %ymm2,       (%rsi,%ymm1,sz), %ymm3
  vfmadd231ps     (%rdi),  %ymm3,  %ymm0
  lea             (%rsi,%rdx),    %rsi
  add             rCnt*sz    ,    %rdi
  dec             %ecx
  jnz             .LshortLoop

.LskipShort:
  andl            rCnt-1, %r8d
  jz              .Ldone
  vmovd           %r8d ,    %xmm2
  vpbroadcastd    %xmm2,%ymm2
  vpcmpgtd        ymmD(%rip), %ymm2, %ymm2
  vmaskmovps      (%rdi),  %ymm2,  %ymm4
  vgatherdps      %ymm2 ,  (%rsi,%ymm1,sz), %ymm3
//vxorps          %ymm3, %ymm3, %ymm3
//vmulps          %ymm3,  %ymm4,  %ymm3
//vaddps           %ymm3,  %ymm0,  %ymm0
  vfmadd231ps     %ymm4,  %ymm3,  %ymm0

//vmaskmovps      %ymm1, %ymm0, (%rdi)

.Ldone:
  vextractf128   $1, %ymm0, %xmm1
  //vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
  //vdpps $0b11110001, %xmm1, %xmm0, %xmm0
  vaddps     %xmm1, %xmm0, %xmm0
  vhaddps    %xmm0, %xmm0, %xmm0
  vhaddps    %xmm0, %xmm0, %xmm0
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
{$else}

{$endif}
end;

function bulkDot_d(const a,b:PDouble;const Count:integer):Double;nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov a, %rdi
       mov b, %rsi
       mov Count, %rdx
    {$endif}
      //push %rax
      xor %rax,%rax
      vxorpd  %ymm0, %ymm0, %ymm0        //reset ymm0
      {$ifdef EXPAND_MM}
      vxorpd  %ymm2, %ymm2, %ymm2        //reset ymm2
      //vxorpd  %ymm4, %ymm4, %ymm4        //reset ymm0
      //vxorpd  %ymm6, %ymm6, %ymm6        //reset ymm2
      {$endif}
      mov Count  , %ecx
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmovupd           (%rdi,%rax,sz), %ymm1
      {$ifdef EXPAND_MM}
      vfmadd231pd       (%rsi,%rax,sz), %ymm1, %ymm0
      vmovupd       0x20(%rdi,%rax,sz), %ymm3
      vfmadd231pd   0x20(%rsi,%rax,sz), %ymm3, %ymm2
      vmovupd     2*0x20(%rdi,%rax,sz), %ymm1
      vfmadd231pd 2*0x20(%rsi,%rax,sz), %ymm1, %ymm0
      vmovupd     3*0x20(%rdi,%rax,sz), %ymm3
      vfmadd231pd 3*0x20(%rsi,%rax,sz), %ymm3, %ymm2
      {$else}
      vfmadd231pd       (%rsi,%rax,sz), %ymm1, %ymm0
      vmovupd       0x20(%rdi,%rax,sz), %ymm1
      vfmadd231pd   0x20(%rsi,%rax,sz), %ymm1, %ymm0
      vmovupd     2*0x20(%rdi,%rax,sz), %ymm1
      vfmadd231pd 2*0x20(%rsi,%rax,sz), %ymm1, %ymm0
      vmovupd     3*0x20(%rdi,%rax,sz), %ymm1
      vfmadd231pd 3*0x20(%rsi,%rax,sz), %ymm1, %ymm0
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
      {$ifdef EXPAND_MM}
      vaddpd      %ymm2, %ymm0, %ymm0
      //vaddpd      %ymm6, %ymm4, %ymm4
      //vaddpd      %ymm4, %ymm0, %ymm0
      {$endif}
  .LskipBulk:

      mov Count , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd         (%rdi,%rax,sz), %ymm1
      vfmadd231pd     (%rsi,%rax,sz), %ymm1, %ymm0
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , Count  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jz .Ldone

      vmovd Count, %xmm3
      vpbroadcastq %xmm3,%ymm3
      vpcmpgtq ymmQ(%rip), %ymm3, %ymm3
      vmaskmovpd (%rdi,%rax,sz), %ymm3, %ymm1
      vfmadd231pd (%rsi,%rax,sz), %ymm1, %ymm0
  .Ldone:
      vextractf128   $1, %ymm0, %xmm1
      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      //vdppd $0b11110001, %xmm1, %xmm0, %xmm0
      vaddpd     %xmm1, %xmm0, %xmm0
      vhaddpd    %xmm0, %xmm0, %xmm0
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

function bulkDot_d(const a,b:PDouble;const bStride,Count:integer):Double;nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov a, %rdi
       mov b, %rsi
       mov bStride, %edx
       mov Count, %ecx
    {$endif}

  mov             %ecx        ,     %r8d
  vmovd           %edx        ,     %xmm1             //stride
  vpbroadcastd    %xmm1       ,     %ymm1             //stride
  vpmulld         ymmD(%rip)  ,     %ymm1,    %ymm1   //gather offset
  imulq           regSize     ,     %rdx              //loop offset
  vxorps          %ymm0       ,     %ymm0,    %ymm0   //reselt packed result
  shr             shifter+2   ,     %ecx
  jz              .LskipBulk

  vxorpd          %ymm5       ,     %ymm5,    %ymm5   //reset packed result
  //vxorpd          %ymm8       ,     %ymm8,    %ymm8   //reset packed result
  //vxorpd          %ymm9       ,     %ymm9,    %ymm9   //reset packed result
.LbulkLoop:

// we think that the mask ymm2 is cleared after eash gather instruction so we set it?
  //vmovups         mskD(%rip) ,  %ymm2
  vpcmpeqq        %ymm2,            %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdpd      %ymm2,            (%rsi,%xmm1,sz), %ymm3
  vfmadd231pd         (%rdi) ,       %ymm3,  %ymm0

  lea             (%rsi,%rdx),      %rsi
  vpcmpeqq        %ymm2,            %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdpd      %ymm2,            (%rsi,%xmm1,sz), %ymm4
  vfmadd231pd     0x20(%rdi) ,      %ymm4,  %ymm5

  lea             (%rsi,%rdx),      %rsi
  vpcmpeqq        %ymm2,            %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdpd      %ymm2,            (%rsi,%xmm1,sz), %ymm3
  vfmadd231pd     0x40(%rdi) ,      %ymm3,  %ymm0

  lea             (%rsi,%rdx),      %rsi
  vpcmpeqq        %ymm2,            %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdpd      %ymm2,            (%rsi,%xmm1,sz), %ymm4
  vfmadd231pd     0x60(%rdi) ,      %ymm4,  %ymm5

  lea             (%rsi,%rdx),      %rsi
  add             stride*sz  ,       %rdi

  dec             %ecx
  jnz             .LbulkLoop

  vaddpd          %ymm0      ,    %ymm5       , %ymm0
  //vaddpd          %ymm8      ,    %ymm9       , %ymm8
  //vaddpd          %ymm8      ,    %ymm0       , %ymm0

.LskipBulk:
  mov             %r8d, %ecx
  and             stride-1, %ecx
  shr             shifter,  %ecx              // count div 8
  jz              .LskipShort

.LshortLoop:
// we think that the mask ymm2 is cleared after eash gather instruction so we set it?
  //vpbroadcastd    %xmm4      ,  %ymm2
  //vmovups         mskD(%rip) ,  %ymm2
  vpcmpeqq        %ymm2,        %ymm2         , %ymm2          // set mask to $0xffffffff
  vgatherdpd      %ymm2,       (%rsi,%xmm1,sz), %ymm3
  vfmadd231pd     (%rdi),  %ymm3,  %ymm0
  lea             (%rsi,%rdx),    %rsi
  add             rCnt*sz    ,    %rdi
  dec             %ecx
  jnz             .LshortLoop

.LskipShort:
  andl            rCnt-1, %r8d
  jz              .Ldone
  vmovd           %r8d ,    %xmm2
  vpbroadcastq    %xmm2,%ymm2
  vpcmpgtq        ymmQ(%rip), %ymm2, %ymm2
  vmaskmovpd      (%rdi),  %ymm2,  %ymm4
  vgatherdpd      %ymm2 ,  (%rsi,%xmm1,sz), %ymm3
//vxorps          %ymm3, %ymm3, %ymm3
//vmulps          %ymm3,  %ymm4,  %ymm3
//vaddps           %ymm3,  %ymm0,  %ymm0
  vfmadd231pd     %ymm4,  %ymm3,  %ymm0

//vmaskmovps      %ymm1, %ymm0, (%rdi)

.Ldone:
  vextractf128   $1, %ymm0, %xmm1
  //vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
  //vdpps $0b11110001, %xmm1, %xmm0, %xmm0
  vaddpd     %xmm1, %xmm0, %xmm0
  vhaddpd    %xmm0, %xmm0, %xmm0
  //vhaddps    %xmm0, %xmm0, %xmm0
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
{$else}

{$endif}
end;

{** element scalar operations}
procedure bulkAdd_ss(const dst,a:PSingle;const b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
//linux param index   : %rdi, %rsi, %rdx, %rcx,  %r8,       %r9   (order is for integers and pointers) // floats uses [xmm reg], means Count is %rdx)
//function results: %rax or %xmm0 if float
//Windows param index : %rcx, %rdx, %r8 , %r9,  %rbp+0x30,
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vbroadcastss (%rdx), %ymm0
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vaddps          (%rsi,%rax,sz), %ymm0, %ymm1
      {$ifdef EXPAND_MM}
      vaddps      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vaddps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vaddps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      vmovups   %ymm1,       (%rdi,%rax,sz)
      vmovups   %ymm2,   0x20(%rdi,%rax,sz)
      vmovups   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovups   %ymm4, 3*0x20(%rdi,%rax,sz)
      {$else}
      vmovups   %ymm1,       (%rdi,%rax,sz)
      vaddps      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1,   0x20(%rdi,%rax,sz)
      vaddps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, 2*0x20(%rdi,%rax,sz)
      vaddps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vaddps    (%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm1
      vpbroadcastd %xmm1,%ymm1
      vpcmpgtd ymmD(%rip), %ymm1, %ymm2
      //vmaskmovps (%rsi,%rax,sz), %ymm2, %ymm1
      vaddps     (%rsi,%rax,sz), %ymm0, %ymm1
      vmaskmovps  %ymm1, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSub_ss(const dst,a:PSingle;const from:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
//linux param index   : %rdi, %rsi, %rdx, %rcx,  %r8,       %r9   (order is for integers and pointers) // floats uses [xmm reg]             //function results: %rax
//Windows param index : %rcx, %rdx, %r8 , %r9d,  %rbp+0x30
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov from, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vbroadcastss (%rdx), %ymm0
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vsubps          (%rsi,%rax,sz), %ymm0, %ymm1
      {$ifdef EXPAND_MM}
      vsubps      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vsubps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vsubps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      vmovups   %ymm1,       (%rdi,%rax,sz)
      vmovups   %ymm2,   0x20(%rdi,%rax,sz)
      vmovups   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovups   %ymm4, 3*0x20(%rdi,%rax,sz)
      {$else}
      vmovups   %ymm1,       (%rdi,%rax,sz)
      vsubps      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1,   0x20(%rdi,%rax,sz)
      vsubps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, 2*0x20(%rdi,%rax,sz)
      vsubps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vsubps    (%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm1
      vpbroadcastd %xmm1,%ymm1
      vpcmpgtd ymmD(%rip), %ymm1, %ymm2
      //vmaskmovps (%rsi,%rax,sz), %ymm2, %ymm0
      vsubps     (%rsi,%rax,sz), %ymm0, %ymm1
      vmaskmovps  %ymm1, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;
procedure bulkMul_ss(const dst,a:PSingle;const b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
//linux param index   : %rdi, %rsi, %rdx, %rcx,  %r8,       %r9   (order is for integers and pointers) // floats uses [xmm reg]             //function results: %rax
//Windows param index : %rcx, %rdx, %r8 , %r9d,  %rbp+0x30
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vbroadcastss (%rdx), %ymm0
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmulps          (%rsi,%rax,sz), %ymm0, %ymm1
      {$ifdef EXPAND_MM}
      vmulps      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vmulps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vmulps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      vmovups   %ymm1,       (%rdi,%rax,sz)
      vmovups   %ymm2,   0x20(%rdi,%rax,sz)
      vmovups   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovups   %ymm4, 3*0x20(%rdi,%rax,sz)
      {$else}
      vmovups   %ymm1,       (%rdi,%rax,sz)
      vmulps      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1,   0x20(%rdi,%rax,sz)
      vmulps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, 2*0x20(%rdi,%rax,sz)
      vmulps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmulps    (%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm1
      vpbroadcastd %xmm1,%ymm1
      vpcmpgtd ymmD(%rip), %ymm1, %ymm2
      //vmaskmovps (%rsi,%rax,sz), %ymm2, %ymm0
      vmulps     (%rsi,%rax,sz), %ymm0, %ymm1
      vmaskmovps  %ymm1, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;
procedure bulkDiv_ss(const dst,denom:PSingle;const nom:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(denom^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
//linux param index   : %rdi, %rsi, %rdx, %rcx,  %r8,       %r9   (order is for integers and pointers) // floats uses [xmm reg]             //function results: %rax
//Windows param index : %rcx, %rdx, %r8 , %r9d,  %rbp+0x30
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov denom, %rsi
       mov nom, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vbroadcastss (%rdx), %ymm0
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vdivps          (%rsi,%rax,sz), %ymm0, %ymm1
      {$ifdef EXPAND_MM}
      vdivps      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vdivps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vdivps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      vmovups   %ymm1,       (%rdi,%rax,sz)
      vmovups   %ymm2,   0x20(%rdi,%rax,sz)
      vmovups   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovups   %ymm4, 3*0x20(%rdi,%rax,sz)
      {$else}
      vmovups   %ymm1,       (%rdi,%rax,sz)
      vdivps      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1,   0x20(%rdi,%rax,sz)
      vdivps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, 2*0x20(%rdi,%rax,sz)
      vdivps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vdivps    (%rsi,%rax,sz), %ymm0, %ymm1
      vmovups   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd        %r8d , %xmm1
      vpbroadcastd %xmm1,%ymm1
      vpcmpgtd     ymmD(%rip), %ymm1, %ymm2
      vblendvps    %ymm2, (%rsi,%rax,sz), %ymm0, %ymm1            // avoid possible div by zero?
      vdivps       %ymm1, %ymm0, %ymm1
      vmaskmovps   %ymm1, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;


procedure bulkAdd_sd(const dst,a:PDouble;const b:PDouble;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
//linux param index   : %rdi, %rsi, %rdx, %rcx,  %r8,       %r9   (order is for integers and pointers) // floats uses [xmm reg]             //function results: %rax
//Windows param index : %rcx, %rdx, %r8 , %r9d,  %rbp+0x30
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (4= ymm register size in element) X (4= number of repeats)
      vbroadcastsd (%rdx), %ymm0
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vaddpd          (%rsi,%rax,sz), %ymm0, %ymm1
      vaddpd      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vaddpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vaddpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      vmovupd   %ymm1, (%rdi,%rax,sz)
      vmovupd   %ymm2,   0x20(%rdi,%rax,sz)
      vmovupd   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm4, 3*0x20(%rdi,%rax,sz)
      {$else}
      vaddpd          (%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, (%rdi,%rax,sz)
      vaddpd      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1,   0x20(%rdi,%rax,sz)
      vaddpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, 2*0x20(%rdi,%rax,sz)
      vaddpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vaddpd    (%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm1
      vpbroadcastq %xmm1,%ymm1
      vpcmpgtq ymmQ(%rip), %ymm1, %ymm2
      //vmaskmovpd (%rsi,%rax,sz), %ymm2, %ymm0
      vaddpd     (%rsi,%rax,sz), %ymm0, %ymm1
      vmaskmovpd  %ymm1, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSub_sd(const dst,a:PDouble;const from:PDouble;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
//linux param index   : %rdi, %rsi, %rdx, %rcx,  %r8,       %r9   (order is for integers and pointers) // floats uses [xmm reg]             //function results: %rax
//Windows param index : %rcx, %rdx, %r8 , %r9d,  %rbp+0x30
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov from, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vbroadcastsd (%rdx), %ymm0
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vsubpd          (%rsi,%rax,sz), %ymm0, %ymm1
      {$ifdef EXPAND_MM}
      vsubpd      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vsubpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vsubpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      vmovupd   %ymm1,       (%rdi,%rax,sz)
      vmovupd   %ymm2,   0x20(%rdi,%rax,sz)
      vmovupd   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm4, 3*0x20(%rdi,%rax,sz)
      {$else}
      vmovupd   %ymm1,       (%rdi,%rax,sz)
      vsubpd      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1,   0x20(%rdi,%rax,sz)
      vsubpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, 2*0x20(%rdi,%rax,sz)
      vsubpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vsubpd    (%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm1
      vpbroadcastq %xmm1,%ymm1
      vpcmpgtq ymmQ(%rip), %ymm1, %ymm2
      //vmaskmovpd (%rsi,%rax,sz), %ymm2, %ymm0
      vsubpd      (%rsi,%rax,sz), %ymm0, %ymm1
      vmaskmovpd  %ymm1, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkMul_sd(const dst,a:PDouble;const b:PDouble;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
//linux param index   : %rdi, %rsi, %rdx, %rcx,  %r8,       %r9   (order is for integers and pointers) // floats uses [xmm reg]             //function results: %rax
//Windows param index : %rcx, %rdx, %r8 , %r9d,  %rbp+0x30
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vbroadcastsd (%rdx), %ymm0
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vMulpd          (%rsi,%rax,sz), %ymm0, %ymm1
      vMulpd      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vMulpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vMulpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      vmovupd   %ymm1,       (%rdi,%rax,sz)
      vmovupd   %ymm2,   0x20(%rdi,%rax,sz)
      vmovupd   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm4, 3*0x20(%rdi,%rax,sz)
      {$else}
      vMulpd          (%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, (%rdi,%rax,sz)
      vMulpd      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1,   0x20(%rdi,%rax,sz)
      vMulpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, 2*0x20(%rdi,%rax,sz)
      vMulpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vMulpd    (%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm1
      vpbroadcastq %xmm1,%ymm1
      vpcmpgtq ymmQ(%rip), %ymm1, %ymm2
      //vmaskmovpd (%rsi,%rax,sz), %ymm2, %ymm0
      vMulpd     (%rsi,%rax,sz), %ymm0, %ymm1
      vmaskmovpd  %ymm1, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;
procedure bulkDiv_sd(const dst,denom:PDouble;const nom:PDouble;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(denom^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
//linux param index   : %rdi, %rsi, %rdx, %rcx,  %r8,       %r9   (order is for integers and pointers) // floats uses [xmm reg]             //function results: %rax
//Windows param index : %rcx, %rdx, %r8 , %r9d,  %rbp+0x30
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov denom, %rsi
       mov nom, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vbroadcastsd (%rdx), %ymm0
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vdivpd          (%rsi,%rax,sz), %ymm0, %ymm1
      vdivpd      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vdivpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vdivpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      vmovupd   %ymm1,       (%rdi,%rax,sz)
      vmovupd   %ymm2,   0x20(%rdi,%rax,sz)
      vmovupd   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm4, 3*0x20(%rdi,%rax,sz)
      {$else}
      //vmovupd         (%rsi,%rax,sz), %ymm1
      vdivpd          (%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1,       (%rdi,%rax,sz)
      //vmovupd     0x20(%rsi,%rax,sz), %ymm1
      vdivpd      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1,   0x20(%rdi,%rax,sz)
      //vmovupd   2*0x20(%rsi,%rax,sz), %ymm1
      vdivpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, 2*0x20(%rdi,%rax,sz)
      //vmovupd   3*0x20(%rsi,%rax,sz), %ymm1
      vdivpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      //vmovupd   (%rsi,%rax,sz), %ymm1
      vdivpd    (%rsi,%rax,sz), %ymm0, %ymm1
      vmovupd   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd        %r8d , %xmm1
      vpbroadcastq %xmm1,%ymm1
      vpcmpgtq     ymmQ(%rip), %ymm1, %ymm2
      //vmaskmovpd (%rsi,%rax,sz), %ymm2, %ymm1
      vblendvpd    %ymm2, (%rsi,%rax,sz), %ymm0, %ymm1         // avoid possible div by zero?
      vdivpd       %ymm1, %ymm0, %ymm1
      vmaskmovpd   %ymm1, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;


{** Element to element wise operations}
{%region element to elemet}


// TODO : Refactor the following later

procedure bulkAXPY_s(const dst,x,y:PSingle;const Count:integer;const a:PSingle); {$ifndef windows}nf;{$endif}// loading the 5th parameter with nostackframe is messed up in windows
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
//stack frame (rbp offset) bp-8 |bp-16|bp-24|bp-32|bp-40
//                         ________________________________________
//   linux param order is | %rdi, %rsi, %rdx, %rcx,  %r8,       %r9      , %rbp+0x10, %rbp+0x18 .. so on          //function results: %rax
// windows param order is | %rcx, %rdx, %r8 , %r9d,  %rbp+0x30, %rbp+0x38 .. so on

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov x, %rsi
       mov y, %rdx
       mov Count, %ecx
       mov a , %r8
    {$endif}
      //push %rax
      xor %rax,%rax
      //vzeroall
      mov %ecx  ,   %r9d
      vbroadcastss   (%r8), %ymm0
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
//      cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      //vmulps          (%rsi,%rax,sz), %ymm0, %ymm1
      //vmulps      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      //vmulps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      //vmulps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
      //
      //vaddps          (%rdx,%rax,sz), %ymm1, %ymm1
      //vaddps      0x20(%rdx,%rax,sz), %ymm2, %ymm2
      //vaddps    2*0x20(%rdx,%rax,sz), %ymm3, %ymm3
      //vaddps    3*0x20(%rdx,%rax,sz), %ymm4, %ymm4

      vmovups          (%rdx,%rax,sz), %ymm1
      vmovups      0x20(%rdx,%rax,sz), %ymm2
      vmovups    2*0x20(%rdx,%rax,sz), %ymm3
      vmovups    3*0x20(%rdx,%rax,sz), %ymm4

      vfmadd231ps          (%rsi,%rax,sz), %ymm0, %ymm1
      vfmadd231ps      0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vfmadd231ps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vfmadd231ps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4

      vmovups   %ymm1,       (%rdi,%rax,sz)
      vmovups   %ymm2,   0x20(%rdi,%rax,sz)
      vmovups   %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovups   %ymm4, 3*0x20(%rdi,%rax,sz)

      {$else}
      vmulps          (%rsi,%rax,sz), %ymm0, %ymm1
      vaddps          (%rdx,%rax,sz), %ymm1, %ymm1
      vmovups   %ymm1,       (%rdi,%rax,sz)

      vmulps      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vaddps      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vmovups   %ymm1,   0x20(%rdi,%rax,sz)

      vmulps    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vaddps    2*0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vmovups   %ymm1, 2*0x20(%rdi,%rax,sz)

      vmulps    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vaddps    3*0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vmovups   %ymm1, 3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r9d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      //vmulps    (%rsi,%rax,sz), %ymm0, %ymm1
      //vaddps    (%rdx,%rax,sz), %ymm1, %ymm1

      vmovups          (%rdx,%rax,sz), %ymm1
      vfmadd231ps          (%rsi,%rax,sz), %ymm0, %ymm1

      vmovups   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r9d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone
      vmovd %r9d , %xmm2
      vpbroadcastd %xmm2,%ymm2
      vpcmpgtd ymmD(%rip), %ymm2, %ymm2
      vmaskmovps (%rsi,%rax,sz), %ymm2, %ymm1
      //vmulps     %ymm1, %ymm0,  %ymm1
      //vaddps     (%rdx,%rax,sz), %ymm1, %ymm1

      vmaskmovps   (%rdx,%rax,sz), %ymm2, %ymm1
      vfmadd231ps  (%rsi,%rax,sz), %ymm0, %ymm1

      vmaskmovps  %ymm1, %ymm2, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkAXPY_d(const dst,x,y:PDouble;const Count:integer;const a:PDouble); {$ifndef windows}nf;{$endif}// loading the 5th parameter with nostackframe is messed up in windows
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
//stack frame (rbp offset) bp-8 |bp-16|bp-24|bp-32|bp-40
//                         ________________________________________
//   linux param order is | %rdi, %rsi, %rdx, %rcx,  %r8,       %r9                 //function results: %rax
// windows param order is | %rcx, %rdx, %r8 , %r9d,  %rbp+0x30

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov x, %rsi
       mov y, %rdx
       mov Count, %ecx
       mov a, %r8
    {$endif}
      //push %rax
      xor %rax,%rax
      //vzeroall
      vxorpd         %ymm1, %ymm1, %ymm1
      mov %ecx  ,   %r9d
      vbroadcastsd   (%r8), %ymm0
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
//      cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
     {$ifdef EXPAND_MM}
     //vmulpd          (%rsi,%rax,sz), %ymm0, %ymm1
     //vmulpd      0x20(%rsi,%rax,sz), %ymm0, %ymm2
     //vmulpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
     //vmulpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4
     //
     //vaddpd          (%rdx,%rax,sz), %ymm1, %ymm1
     //vaddpd      0x20(%rdx,%rax,sz), %ymm2, %ymm2
     //vaddpd    2*0x20(%rdx,%rax,sz), %ymm3, %ymm3
     //vaddpd    3*0x20(%rdx,%rax,sz), %ymm4, %ymm4

     vmovupd          (%rdx,%rax,sz), %ymm1
     vmovupd      0x20(%rdx,%rax,sz), %ymm2
     vmovupd    2*0x20(%rdx,%rax,sz), %ymm3
     vmovupd    3*0x20(%rdx,%rax,sz), %ymm4

     vfmadd231pd          (%rsi,%rax,sz), %ymm0, %ymm1
     vfmadd231pd      0x20(%rsi,%rax,sz), %ymm0, %ymm2
     vfmadd231pd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
     vfmadd231pd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm4

     vmovupd   %ymm1,        (%rdi,%rax,sz)
     vmovupd   %ymm2,    0x20(%rdi,%rax,sz)
     vmovupd   %ymm3,  2*0x20(%rdi,%rax,sz)
     vmovupd   %ymm4,  3*0x20(%rdi,%rax,sz)
     {$else}
      //vmovupd         (%rsi,%rax,sz), %ymm1
      vmulpd          (%rsi,%rax,sz), %ymm0, %ymm1
      vaddpd          (%rdx,%rax,sz), %ymm1, %ymm1
      vmovupd   %ymm1,  (%rdi,%rax,sz)

      //vmovupd     0x20(%rsi,%rax,sz), %ymm1
      vmulpd      0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vaddpd      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vmovupd   %ymm1,  0x20(%rdi,%rax,sz)

      //vmovupd   2*0x20(%rsi,%rax,sz), %ymm1
      vmulpd    2*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vaddpd    2*0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vmovupd   %ymm1,  2*0x20(%rdi,%rax,sz)

      //vmovupd   3*0x20(%rsi,%rax,sz), %ymm1
      vmulpd    3*0x20(%rsi,%rax,sz), %ymm0, %ymm1
      vaddpd    3*0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vmovupd   %ymm1,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r9d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd   (%rsi,%rax,sz), %ymm1
      //vmulpd     %ymm1, %ymm0,  %ymm1
      //vaddpd    (%rdx,%rax,sz), %ymm1, %ymm1

      vmovupd          (%rdx,%rax,sz), %ymm1
      vfmadd231pd      (%rsi,%rax,sz), %ymm0, %ymm1

      vmovupd   %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r9d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r9d , %xmm2
      vpbroadcastq %xmm2,%ymm2

      vpcmpgtq ymmQ(%rip), %ymm2, %ymm2
      vmaskmovpd (%rsi,%rax,sz), %ymm2, %ymm1
      //vmulpd     %ymm1, %ymm0,  %ymm1
      //vaddpd     (%rdx,%rax,sz), %ymm1, %ymm1

      vmovupd          (%rdx,%rax,sz), %ymm1
      vfmadd231pd      (%rsi,%rax,sz), %ymm0, %ymm1
      vmaskmovpd  %ymm1, %ymm2, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}

      //pop %rax
{$else}

{$endif}
end;

procedure bulkAXPBY_s(const dst,x,y:PSingle;const Count:integer;const a,b:PSingle);{$ifndef windows}nf;{$endif}// loading the 5th parameter with nostackframe is messed up in windows
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
//stack frame (rbp offset) bp-8 |bp-16|bp-24|bp-32|bp-40
//                         ________________________________________
//   linux param order is | %rdi, %rsi, %rdx, %rcx,  %r8,       %r9                 //function results: %rax
// windows param order is | %rcx, %rdx, %r8 , %r9d,  %rbp+0x30, %rbp+0x38

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov x, %rsi
       mov y, %rdx
       mov Count, %ecx
       mov a, %r8
       mov b, %r9
    {$endif}
      //push %rax
      xor %rax,%rax
      //vxorps         %ymm1, %ymm1, %ymm1
      //vzeroall
      mov %ecx  ,   %r10d
      vbroadcastss   (%r8), %ymm0
      vbroadcastss   (%r9), %ymm5

      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
//      cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmulps               (%rsi,%rax,sz), %ymm0, %ymm1
      vmulps           0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vmulps         2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vmulps         3*0x20(%rsi,%rax,sz), %ymm0, %ymm4

      vfmadd231ps          (%rdx,%rax,sz), %ymm5, %ymm1
      vfmadd231ps      0x20(%rdx,%rax,sz), %ymm5, %ymm2
      vfmadd231ps    2*0x20(%rdx,%rax,sz), %ymm5, %ymm3
      vfmadd231ps    3*0x20(%rdx,%rax,sz), %ymm5, %ymm4

      vmovups        %ymm1,       (%rdi,%rax,sz)
      vmovups        %ymm2,   0x20(%rdi,%rax,sz)
      vmovups        %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovups        %ymm4, 3*0x20(%rdi,%rax,sz)

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r10d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmulps         (%rsi,%rax,sz), %ymm0, %ymm1
      vfmadd231ps    (%rdx,%rax,sz), %ymm5, %ymm1
      vmovups        %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r10d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r10d , %xmm2
      vpbroadcastd %xmm2,%ymm2

      vpcmpgtd      ymmD(%rip), %ymm2, %ymm2
      vmaskmovps    (%rsi,%rax,sz), %ymm2, %ymm1
      vmulps        %ymm1, %ymm0,  %ymm1
      vfmadd231ps   (%rdx,%rax,sz), %ymm5, %ymm1
      vmaskmovps    %ymm1, %ymm2, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkAXPBY_d(const dst,x,y:PDouble;const Count:integer;const a,b:PDouble);{$ifndef windows}nf;{$endif}// loading the 5th parameter with nostackframe is messed up in windows
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
//stack frame (rbp offset) bp-8 |bp-16|bp-24|bp-32|bp-40
//                         ________________________________________
//   linux param order is | %rdi, %rsi, %rdx, %rcx,  %r8,       %r9                 //function results: %rax
// windows param order is | %rcx, %rdx, %r8 , %r9d,  %rbp+0x30, %rbp+0x38

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov x, %rsi
       mov y, %rdx
       mov Count, %ecx
       mov a, %r8
       mov b, %r9
    {$endif}
      //push %rax
      xor            %rax,%rax
      //vxorps         %ymm1, %ymm1, %ymm1
      //vzeroall
      mov            %ecx  ,   %r10d
      vbroadcastsd   (%r8), %ymm0
      vbroadcastsd   (%r9), %ymm5

      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
//      cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmulpd               (%rsi,%rax,sz), %ymm0, %ymm1
      vmulpd           0x20(%rsi,%rax,sz), %ymm0, %ymm2
      vmulpd         2*0x20(%rsi,%rax,sz), %ymm0, %ymm3
      vmulpd         3*0x20(%rsi,%rax,sz), %ymm0, %ymm4

      vfmadd231pd          (%rdx,%rax,sz), %ymm5, %ymm1
      vfmadd231pd      0x20(%rdx,%rax,sz), %ymm5, %ymm2
      vfmadd231pd    2*0x20(%rdx,%rax,sz), %ymm5, %ymm3
      vfmadd231pd    3*0x20(%rdx,%rax,sz), %ymm5, %ymm4

      vmovupd        %ymm1,       (%rdi,%rax,sz)
      vmovupd        %ymm2,   0x20(%rdi,%rax,sz)
      vmovupd        %ymm3, 2*0x20(%rdi,%rax,sz)
      vmovupd        %ymm4, 3*0x20(%rdi,%rax,sz)

      add            stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov            %r10d  , %ecx
      and            stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr            shifter , %ecx
      jle            .LskipShort

  .LremLoop:
      vmulpd         (%rsi,%rax,sz), %ymm0, %ymm1
      vfmadd231pd    (%rdx,%rax,sz), %ymm5, %ymm1
      vmovupd        %ymm1, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl          rCnt-1 ,%r10d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle           .Ldone

      vmovd         %r10d , %xmm2
      vpbroadcastq  %xmm2,%ymm2

      vpcmpgtq      ymmQ(%rip), %ymm2, %ymm2
      vmaskmovpd    (%rsi,%rax,sz), %ymm2, %ymm1
      vmulpd        %ymm1, %ymm0,  %ymm1
      vfmadd231pd   (%rdx,%rax,sz), %ymm5, %ymm1
      vmaskmovpd    %ymm1, %ymm2, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

(*another method just to compare performance*)
//procedure bulkAdd1(const dst,a,b:PSingle;const Count:integer); nf;
//const regSize=$20;   //in bytes
//const sz=SizeOf(a^); // element size in bytes
//const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
//const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
//const shifter=3;  // log2(rCnt)
//asm
//{$ifdef CPUX86_64}
//    {$ifdef windows}
//       mov dst, %rdi
//       mov a, %rsi                  //linux param order is   : %rsi, %rdx, %rdi, %rcx, %r8                 //function results: %rax
//       mov b, %rdx                 //windows param order id : %rcx, %rdi, %r8 , %r9d, %rbp+0x30 (+48)
//       mov Count,  %ecx
//    {$endif}
//      //push %rax
//      xor %rax,%rax
//      mov Count  , %r8d
//      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
//      //cmp $0 , %ecx
//      jz .LskipBulk
//
//  .LbulkLoop:
//      vmovups       (%rsi), %ymm0
//      vaddps        (%rdx), %ymm0, %ymm0
//      vmovups   %ymm0,  (%rdi)
//      vmovups   0x20(%rsi), %ymm0
//      vaddps    0x20(%rdx), %ymm0, %ymm0
//      vmovups   %ymm0,  0x20(%rdi)
//      vmovups   2*0x20(%rsi), %ymm0
//      vaddps    2*0x20(%rdx), %ymm0, %ymm0
//      vmovups   %ymm0,  2*0x20(%rdi)
//      vmovups   3*0x20(%rsi), %ymm0
//      vaddps    3*0x20(%rdx), %ymm0, %ymm0
//      vmovups   %ymm0,  3*0x20(%rdi)
//      add       regSize*4, %rsi
//      add       regSize*4, %rdx
//      add       regSize*4, %rdi
//
//      dec %ecx
//      jnz .LbulkLoop
//      //loop .LbulkLoop
//  .LskipBulk:
//
//      mov %r8d  , %ecx
//      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
//      shr shifter , %ecx
//      //add bulkReminder, %ecx
//      jle .LskipShort
//
//  .LremLoop:
//      vmovups   (%rsi), %ymm0
//      vaddps    (%rdx), %ymm0, %ymm0
//      vmovups   %ymm0, (%rdi)
//      add       regSize, %rsi
//      add       regSize, %rdx
//      add       regSize, %rdi
//      dec %ecx
//      jnz .LremLoop
//      //loop .LremLoop
//  .LskipShort:
//
//      andl rCnt-1 ,%r8d       //last reminder less than 4 elements := C mod 4
//      jle .Ldone
//
//      vmovd %r8d , %xmm0
//      vpbroadcastd %xmm0,%ymm0
//      vpcmpgtd ymmQ(%rip), %ymm0, %ymm1
//      vmaskmovps (%rsi), %ymm1, %ymm0
//      vaddps     (%rdx), %ymm0, %ymm0
//      vmaskmovps  %ymm0, %ymm1, (%rdi)
//
//  .Ldone:
//      //pop %rax
//{$else}
//
//{$endif}
//end;


procedure bulkAdd_s(const dst,a,b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
//stack frame (rbp offset) bp-8 |bp-16|bp-24|bp-32|bp-40
//                         ________________________________________
//   linux param order is | %rdi, %rsi, %rdx, %rcx,  %r8,       %r9                 //function results: %rax
// windows param order is | %rcx, %rdx, %r8 , %r9d,  %rbp+0x30

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  ,   %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
//      cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vmovups         (%rsi,%rax,sz), %ymm0
      vmovups     0x20(%rsi,%rax,sz), %ymm1
      vmovups   2*0x20(%rsi,%rax,sz), %ymm2
      vmovups   3*0x20(%rsi,%rax,sz), %ymm3

      vaddps          (%rdx,%rax,sz), %ymm0, %ymm0
      vaddps      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vaddps    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vaddps    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovups   %ymm0,        (%rdi,%rax,sz)
      vmovups   %ymm1,    0x20(%rdi,%rax,sz)
      vmovups   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovups   %ymm3,  3*0x20(%rdi,%rax,sz)
      {$else}
      vmovups       (%rsi,%rax,sz), %ymm0
      vaddps        (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  (%rdi,%rax,sz)
      vmovups   0x20(%rsi,%rax,sz), %ymm0
      vaddps    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  0x20(%rdi,%rax,sz)
      vmovups   2*0x20(%rsi,%rax,sz), %ymm0
      vaddps    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovups   3*0x20(%rsi,%rax,sz), %ymm0
      vaddps    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovups   (%rsi,%rax,sz), %ymm0
      vaddps    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm0
      vpbroadcastd %xmm0,%ymm0
      vpcmpgtd ymmD(%rip), %ymm0, %ymm1
      vmaskmovps (%rsi,%rax,sz), %ymm1, %ymm0
      vaddps     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovps  %ymm0, %ymm1, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkAdd_d(const dst,a,b:PDouble;const Count:integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi                  //linux param order is   : %rsi, %rdx, %rdi, %rcx, %r8                 //function results: %rax
       mov b, %rdx                 //windows param order id : %rcx, %rdi, %r8 , %r9d, %rbp+0x30 (+48)
       mov Count,  %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vmovupd         (%rsi,%rax,sz), %ymm0
      vmovupd     0x20(%rsi,%rax,sz), %ymm1
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm2
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm3

      vaddpd          (%rdx,%rax,sz), %ymm0, %ymm0
      vaddpd      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vaddpd    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vaddpd    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovupd   %ymm0,        (%rdi,%rax,sz)
      vmovupd   %ymm1,    0x20(%rdi,%rax,sz)
      vmovupd   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm3,  3*0x20(%rdi,%rax,sz)
      {$else}
      vmovupd       (%rsi,%rax,sz), %ymm0
      vaddpd        (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  (%rdi,%rax,sz)
      vmovupd   0x20(%rsi,%rax,sz), %ymm0
      vaddpd    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  0x20(%rdi,%rax,sz)
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm0
      vaddpd    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm0
      vaddpd    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %ecx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd   (%rsi,%rax,sz), %ymm0
      vaddpd    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d       //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd %r8d , %xmm0
      vpbroadcastq %xmm0,%ymm0
      vpcmpgtq ymmQ(%rip), %ymm0, %ymm1
      vmaskmovpd (%rsi,%rax,sz), %ymm1, %ymm0
      vaddpd     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovpd  %ymm0, %ymm1, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSub_s(const dst,a,b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax

      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
            {$ifdef EXPAND_MM}
      vmovups         (%rsi,%rax,sz), %ymm0
      vmovups     0x20(%rsi,%rax,sz), %ymm1
      vmovups   2*0x20(%rsi,%rax,sz), %ymm2
      vmovups   3*0x20(%rsi,%rax,sz), %ymm3

      vsubps          (%rdx,%rax,sz), %ymm0, %ymm0
      vsubps      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vsubps    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vsubps    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovups   %ymm0,        (%rdi,%rax,sz)
      vmovups   %ymm1,    0x20(%rdi,%rax,sz)
      vmovups   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovups   %ymm3,  3*0x20(%rdi,%rax,sz)
      {$else}
      vmovups       (%rsi,%rax,sz), %ymm0
      vsubps        (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  (%rdi,%rax,sz)
      vmovups   0x20(%rsi,%rax,sz), %ymm0
      vsubps    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  0x20(%rdi,%rax,sz)
      vmovups   2*0x20(%rsi,%rax,sz), %ymm0
      vsubps    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovups   3*0x20(%rsi,%rax,sz), %ymm0
      vsubps    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovups   (%rsi,%rax,sz), %ymm0
      vsubps    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm0
      vpbroadcastd %xmm0,%ymm0
      vpcmpgtd ymmD(%rip), %ymm0, %ymm1
      vmaskmovps (%rsi,%rax,sz), %ymm1, %ymm0
      vsubps     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovps  %ymm0, %ymm1, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSub_d(const dst,a,b:PDouble;const Count:integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vmovupd         (%rsi,%rax,sz), %ymm0
      vmovupd     0x20(%rsi,%rax,sz), %ymm1
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm2
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm3

      vsubpd          (%rdx,%rax,sz), %ymm0, %ymm0
      vsubpd      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vsubpd    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vsubpd    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovupd   %ymm0,        (%rdi,%rax,sz)
      vmovupd   %ymm1,    0x20(%rdi,%rax,sz)
      vmovupd   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm3,  3*0x20(%rdi,%rax,sz)
      {$else}
      vmovupd       (%rsi,%rax,sz), %ymm0
      vsubpd        (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  (%rdi,%rax,sz)
      vmovupd   0x20(%rsi,%rax,sz), %ymm0
      vsubpd    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  0x20(%rdi,%rax,sz)
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm0
      vsubpd    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm0
      vsubpd    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8d   , %ecx
      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %ecx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd   (%rsi,%rax,sz), %ymm0
      vsubpd    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd %r8d  , %xmm0
      vpbroadcastq %xmm0,%ymm0
      vpcmpgtq ymmQ(%rip), %ymm0, %ymm1
      vmaskmovpd (%rsi,%rax,sz), %ymm1, %ymm0
      vsubpd     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovpd  %ymm0, %ymm1, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkMul_s(const dst,a,b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax

      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vmovups         (%rsi,%rax,sz), %ymm0
      vmovups     0x20(%rsi,%rax,sz), %ymm1
      vmovups   2*0x20(%rsi,%rax,sz), %ymm2
      vmovups   3*0x20(%rsi,%rax,sz), %ymm3

      vmulps          (%rdx,%rax,sz), %ymm0, %ymm0
      vmulps      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vmulps    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vmulps    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovups   %ymm0,        (%rdi,%rax,sz)
      vmovups   %ymm1,    0x20(%rdi,%rax,sz)
      vmovups   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovups   %ymm3,  3*0x20(%rdi,%rax,sz)
      {$else}
      vmovups       (%rsi,%rax,sz), %ymm0
      vmulps        (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  (%rdi,%rax,sz)
      vmovups   0x20(%rsi,%rax,sz), %ymm0
      vmulps    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  0x20(%rdi,%rax,sz)
      vmovups   2*0x20(%rsi,%rax,sz), %ymm0
      vmulps    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovups   3*0x20(%rsi,%rax,sz), %ymm0
      vmulps    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d   , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovups   (%rsi,%rax,sz), %ymm0
      vmulps    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d   //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d  , %xmm0
      vpbroadcastd %xmm0,%ymm0
      vpcmpgtd ymmD(%rip), %ymm0, %ymm1
      vmaskmovps (%rsi,%rax,sz), %ymm1, %ymm0
      vmulps     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovps  %ymm0, %ymm1, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkMul_d(const dst,a,b:PDouble;const Count:integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vmovupd         (%rsi,%rax,sz), %ymm0
      vmovupd     0x20(%rsi,%rax,sz), %ymm1
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm2
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm3

      vmulpd          (%rdx,%rax,sz), %ymm0, %ymm0
      vmulpd      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vmulpd    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vmulpd    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovupd   %ymm0,        (%rdi,%rax,sz)
      vmovupd   %ymm1,    0x20(%rdi,%rax,sz)
      vmovupd   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm3,  3*0x20(%rdi,%rax,sz)
      {$else}
      vmovupd       (%rsi,%rax,sz), %ymm0
      vmulpd        (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  (%rdi,%rax,sz)
      vmovupd   0x20(%rsi,%rax,sz), %ymm0
      vmulpd    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  0x20(%rdi,%rax,sz)
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm0
      vmulpd    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm0
      vmulpd    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8d   , %ecx
      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %ecx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd   (%rsi,%rax,sz), %ymm0
      vmulpd    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd %r8d  , %xmm0
      vpbroadcastq %xmm0,%ymm0
      vpcmpgtq ymmQ(%rip), %ymm0, %ymm1
      vmaskmovpd (%rsi,%rax,sz), %ymm1, %ymm0
      vmulpd     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovpd  %ymm0, %ymm1, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkDiv_s(const dst,a,b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax

      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vmovups         (%rsi,%rax,sz), %ymm0
      vmovups     0x20(%rsi,%rax,sz), %ymm1
      vmovups   2*0x20(%rsi,%rax,sz), %ymm2
      vmovups   3*0x20(%rsi,%rax,sz), %ymm3

      vdivps          (%rdx,%rax,sz), %ymm0, %ymm0
      vdivps      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vdivps    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vdivps    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovups   %ymm0,        (%rdi,%rax,sz)
      vmovups   %ymm1,    0x20(%rdi,%rax,sz)
      vmovups   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovups   %ymm3,  3*0x20(%rdi,%rax,sz)
      {$else}
      vmovups       (%rsi,%rax,sz), %ymm0
      vdivps        (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  (%rdi,%rax,sz)
      vmovups   0x20(%rsi,%rax,sz), %ymm0
      vdivps    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  0x20(%rdi,%rax,sz)
      vmovups   2*0x20(%rsi,%rax,sz), %ymm0
      vdivps    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovups   3*0x20(%rsi,%rax,sz), %ymm0
      vdivps    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d   , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovups   (%rsi,%rax,sz), %ymm0
      vdivps    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d   //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd        %r8d  , %xmm2
      vpbroadcastd %xmm2,%ymm1
      vpcmpgtd     ymmD(%rip), %ymm1, %ymm2
      vmaskmovps   (%rsi,%rax,sz), %ymm2, %ymm0
      vblendvps    %ymm2, (%rdx,%rax,sz), %ymm1, %ymm1     // we used blend to avoid pssible division by zero
      vdivps       %ymm1, %ymm0, %ymm0
      vmaskmovps   %ymm0, %ymm2, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkDiv_d(const dst,a,b:PDouble;const Count:integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      {$ifdef EXPAND_MM}
      vmovupd         (%rsi,%rax,sz), %ymm0
      vmovupd     0x20(%rsi,%rax,sz), %ymm1
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm2
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm3

      vdivpd          (%rdx,%rax,sz), %ymm0, %ymm0
      vdivpd      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vdivpd    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vdivpd    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovupd   %ymm0,        (%rdi,%rax,sz)
      vmovupd   %ymm1,    0x20(%rdi,%rax,sz)
      vmovupd   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm3,  3*0x20(%rdi,%rax,sz)
      {$else}
      vmovupd       (%rsi,%rax,sz), %ymm0
      vdivpd        (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  (%rdi,%rax,sz)
      vmovupd   0x20(%rsi,%rax,sz), %ymm0
      vdivpd    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  0x20(%rdi,%rax,sz)
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm0
      vdivpd    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm0
      vdivpd    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0,  3*0x20(%rdi,%rax,sz)
      {$endif}
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8d   , %ecx
      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %ecx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd   (%rsi,%rax,sz), %ymm0
      vdivpd    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r8d  , %xmm2
      vpbroadcastq %xmm2,%ymm1
      vpcmpgtq     ymmQ(%rip), %ymm1, %ymm2
      vmaskmovpd   (%rsi,%rax,sz), %ymm2, %ymm0
      vblendvpd    %ymm2, (%rdx,%rax,sz), %ymm1, %ymm1        // we used blend to avoid pssible division by zero
      vdivpd       %ymm1, %ymm0, %ymm0
      vmaskmovpd   %ymm0, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
  pop %rdi
  pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

// [Haitham note to self] : the Sum functions below were optimized for performance over accuracy however..,
//  here is the kahan method for more accurate (but slower) summation for future implementation
//======================================
//float kahan(float x[], int N) {
//        float s = x[0];
//        float c = 0.0;
//        for (int i = 1; i < N; i++) {
//            float y = x[i] - c;
//            float t = s + y;
//            c = (t - s) - y;
//            s = t;
//        }
//        return s;
//    }
// =====================================
procedure bulkSum_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vpxor %ymm0,  %ymm0 ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
      vpxor %ymm1,  %ymm1 ,%ymm1
      vpxor %ymm2,  %ymm2 ,%ymm2
      vpxor %ymm3,  %ymm3 ,%ymm3

  .LbulkLoop:
      vaddps       (%rsi,%rax,sz), %ymm0, %ymm0
      vaddps     32(%rsi,%rax,sz), %ymm1, %ymm1
      vaddps   2*32(%rsi,%rax,sz), %ymm2, %ymm2
      vaddps   3*32(%rsi,%rax,sz), %ymm3, %ymm3

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
      vaddps       %ymm3, %ymm2, %ymm2
      vaddps       %ymm1, %ymm0, %ymm0
      vaddps       %ymm2, %ymm0, %ymm0


  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vaddps    (%rsi,%rax,sz), %ymm0, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vpxor        %ymm2,  %ymm2 ,%ymm2
      vmovd        %r8d , %xmm1
      vpbroadcastd %xmm1, %ymm1
      vpcmpgtd     ymmD(%rip), %ymm1, %ymm1
      vmaskmovps   (%rsi,%rax,sz), %ymm1, %ymm2
      vaddps       %ymm2,  %ymm0,  %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vaddps        %xmm1, %xmm0, %xmm0
      vhaddps       %xmm0, %xmm0, %xmm0
      vhaddps       %xmm0, %xmm0, %xmm0
      vmovss        %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSum_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vpxor %ymm0,  %ymm0 ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
      vpxor %ymm1,  %ymm1 ,%ymm1
      vpxor %ymm2,  %ymm2 ,%ymm2
      vpxor %ymm3,  %ymm3 ,%ymm3

  .LbulkLoop:
      vaddpd       (%rsi,%rax,sz), %ymm0, %ymm0
      vaddpd     32(%rsi,%rax,sz), %ymm1, %ymm1
      vaddpd   2*32(%rsi,%rax,sz), %ymm2, %ymm2
      vaddpd   3*32(%rsi,%rax,sz), %ymm3, %ymm3

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
      vaddpd       %ymm3, %ymm2, %ymm2
      vaddpd       %ymm1, %ymm0, %ymm0
      vaddpd       %ymm2, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vaddpd    (%rsi,%rax,sz), %ymm0, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vpxor        %ymm2,  %ymm2 ,%ymm2
      vmovd        %r8d , %xmm1
      vpbroadcastq %xmm1, %ymm1
      vpcmpgtq     ymmQ(%rip), %ymm1, %ymm1
      vmaskmovpd   (%rsi,%rax,sz), %ymm1, %ymm2
      vaddpd       %ymm2,  %ymm0,  %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vaddpd        %xmm1, %xmm0, %xmm0
      vhaddpd       %xmm0, %xmm0, %xmm0
//      vhaddpd       %xmm0, %xmm0, %xmm0
      vmovsd        %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkMax_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vbroadcastss (%rsi), %ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
      vmovaps      %ymm0 , %ymm1
      vmovaps      %ymm0 , %ymm2
      vmovaps      %ymm0 , %ymm3


  .LbulkLoop:
      vmaxps       (%rsi,%rax,sz), %ymm0, %ymm0
      vmaxps     32(%rsi,%rax,sz), %ymm1, %ymm1
      vmaxps   2*32(%rsi,%rax,sz), %ymm2, %ymm2
      vmaxps   3*32(%rsi,%rax,sz), %ymm3, %ymm3

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop

      vmaxps  %ymm1, %ymm0, %ymm0
      vmaxps  %ymm3, %ymm2, %ymm2
      vmaxps  %ymm2, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmaxps    (%rsi,%rax,sz), %ymm0, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop

  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vbroadcastss %xmm0, %ymm2
      vmovd        %r8d , %xmm1
      vpbroadcastd %xmm1, %ymm1
      vpcmpgtd     ymmD(%rip), %ymm1, %ymm1
//      vmaskmovps   (%rsi,%rax,sz), %ymm1, %ymm2
      vblendvps   %ymm1, (%rsi,%rax,sz), %ymm2  ,%ymm2

      vmaxps       %ymm2,  %ymm0,  %ymm0

.Ldone:
      vextractf128  $1, %ymm0, %xmm1
      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vmaxps        %xmm1, %xmm0, %xmm0
      vmovhlps      %xmm0, %xmm0, %xmm1
      vmaxps        %xmm0, %xmm1, %xmm0
      vmovshdup     %xmm0, %xmm1
      vmaxss        %xmm0, %xmm1, %xmm0
      vmovss       %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkMax_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vbroadcastsd (%rsi) ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
      vmovapd      %ymm0 , %ymm1
      vmovapd      %ymm0 , %ymm2
      vmovapd      %ymm0 , %ymm3

  .LbulkLoop:
      vmaxpd       (%rsi,%rax,sz), %ymm0, %ymm0
      vmaxpd     32(%rsi,%rax,sz), %ymm1, %ymm1
      vmaxpd   2*32(%rsi,%rax,sz), %ymm2, %ymm2
      vmaxpd   3*32(%rsi,%rax,sz), %ymm3, %ymm3

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
      vmaxpd  %ymm1, %ymm0, %ymm0
      vmaxpd  %ymm3, %ymm2, %ymm2
      vmaxpd  %ymm2, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmaxpd    (%rsi,%rax,sz), %ymm0, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vbroadcastsd %xmm0, %ymm2
      vmovd        %r8d , %xmm1
      vpbroadcastq %xmm1, %ymm1
      vpcmpgtq     ymmQ(%rip), %ymm1, %ymm1
//      vmaskmovpd   (%rsi,%rax,sz), %ymm1, %ymm2
      vblendvpd   %ymm1, (%rsi,%rax,sz), %ymm2  ,%ymm2
      vmaxpd       %ymm2,  %ymm0,  %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vmaxpd        %xmm1, %xmm0, %xmm0
      vmovhlps      %xmm0, %xmm0, %xmm1
      vmaxsd        %xmm1, %xmm0, %xmm0
      vmovsd        %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkMin_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vbroadcastss (%rsi) ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
      vmovaps      %ymm0 , %ymm1
      vmovaps      %ymm0 , %ymm2
      vmovaps      %ymm0 , %ymm3

  .LbulkLoop:
      vminps       (%rsi,%rax,sz), %ymm0, %ymm0
      vminps     32(%rsi,%rax,sz), %ymm1, %ymm1
      vminps   2*32(%rsi,%rax,sz), %ymm2, %ymm2
      vminps   3*32(%rsi,%rax,sz), %ymm3, %ymm3

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
      vminps  %ymm1, %ymm0, %ymm0
      vminps  %ymm3, %ymm2, %ymm2
      vminps  %ymm2, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vminps    (%rsi,%rax,sz), %ymm0, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vbroadcastss %xmm0, %ymm2
      vmovd        %r8d , %xmm1
      vpbroadcastd %xmm1, %ymm1
      vpcmpgtd     ymmD(%rip), %ymm1, %ymm1
//      vmaskmovps   (%rsi,%rax,sz), %ymm1, %ymm2
      vblendvps   %ymm1, (%rsi,%rax,sz), %ymm2  ,%ymm2
      vminps       %ymm2,  %ymm0,  %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vminps        %xmm1, %xmm0, %xmm0
      vmovhlps      %xmm0, %xmm0, %xmm1
      vminps        %xmm0, %xmm1, %xmm0
      vmovshdup     %xmm0, %xmm1
      vminss        %xmm0, %xmm1, %xmm0
      vmovss       %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkMin_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vbroadcastsd (%rsi) ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
      vmovapd      %ymm0 , %ymm1
      vmovapd      %ymm0 , %ymm2
      vmovapd      %ymm0 , %ymm3

  .LbulkLoop:
      vminpd       (%rsi,%rax,sz), %ymm0, %ymm0
      vminpd     32(%rsi,%rax,sz), %ymm1, %ymm1
      vminpd   2*32(%rsi,%rax,sz), %ymm2, %ymm2
      vminpd   3*32(%rsi,%rax,sz), %ymm3, %ymm3

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
      vminpd  %ymm1, %ymm0, %ymm0
      vminpd  %ymm3, %ymm2, %ymm2
      vminpd  %ymm2, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vminpd    (%rsi,%rax,sz), %ymm0, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vbroadcastsd %xmm0, %ymm2
      vmovd        %r8d , %xmm1
      vpbroadcastq %xmm1, %ymm1
      vpcmpgtq     ymmQ(%rip), %ymm1, %ymm1
//      vmaskmovpd   (%rsi,%rax,sz), %ymm1, %ymm2
      vblendvpd   %ymm1, (%rsi,%rax,sz), %ymm2  ,%ymm2
      vminpd       %ymm2,  %ymm0,  %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vminpd        %xmm1, %xmm0, %xmm0
      vmovhlps      %xmm0, %xmm0, %xmm1
      vminsd        %xmm1, %xmm0, %xmm0
      vmovsd        %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;


procedure bulkSqr_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmovups               (%rsi,%rax,sz), %ymm0
      vmulps            %ymm0, %ymm0, %ymm0
      vmovups           %ymm0,     (%rdi,%rax,sz)

      vmovups             32(%rsi,%rax,sz), %ymm1
      vmulps            %ymm1, %ymm1, %ymm1
      vmovups           %ymm1,   32(%rdi,%rax,sz)

      vmovups           2*32(%rsi,%rax,sz), %ymm2
      vmulps            %ymm2, %ymm2, %ymm2
      vmovups           %ymm2, 2*32(%rdi,%rax,sz)

      vmovups           3*32(%rsi,%rax,sz), %ymm3
      vmulps            %ymm3, %ymm3, %ymm3
      vmovups           %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8     , %rcx
      and stride-1, %rcx
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovups           (%rsi,%rax,sz), %ymm0
      vmulps            %ymm0, %ymm0, %ymm0
      vmovups           %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r8d , %xmm2
      vpbroadcastd %xmm2, %ymm2
      vpcmpgtd     ymmD(%rip), %ymm2, %ymm2
      vmaskmovps   (%rsi,%rax,sz), %ymm2, %ymm0
      vmulps       %ymm0, %ymm0, %ymm0
      vmaskmovps   %ymm0, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSqr_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vpxor %ymm1,  %ymm1  ,%ymm1
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmovupd               (%rsi,%rax,sz), %ymm0
      vmovupd             32(%rsi,%rax,sz), %ymm1
      vmovupd           2*32(%rsi,%rax,sz), %ymm2
      vmovupd           3*32(%rsi,%rax,sz), %ymm3

      vmulpd            %ymm0, %ymm0, %ymm0
      vmulpd            %ymm1, %ymm1, %ymm1
      vmulpd            %ymm2, %ymm2, %ymm2
      vmulpd            %ymm3, %ymm3, %ymm3

      vmovupd           %ymm0,     (%rdi,%rax,sz)
      vmovupd           %ymm1,   32(%rdi,%rax,sz)
      vmovupd           %ymm2, 2*32(%rdi,%rax,sz)
      vmovupd           %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8     , %rcx
      and stride-1, %rcx
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd           (%rsi,%rax,sz), %ymm0
      vmulpd            %ymm0, %ymm0, %ymm0
      vmovupd           %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r8d , %xmm2
      vpbroadcastq %xmm2, %ymm2
      vpcmpgtq     ymmQ(%rip), %ymm2, %ymm2
      vmaskmovpd   (%rsi,%rax,sz), %ymm2, %ymm0
      vmulpd       %ymm0, %ymm0, %ymm0
      vmaskmovpd   %ymm0, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSqrt_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      //vpxor %ymm1,  %ymm1  ,%ymm1
      //vzeroall
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vsqrtps               (%rsi,%rax,sz), %ymm0
      vsqrtps             32(%rsi,%rax,sz), %ymm1
      vsqrtps           2*32(%rsi,%rax,sz), %ymm2
      vsqrtps           3*32(%rsi,%rax,sz), %ymm3

      vmovups           %ymm0,     (%rdi,%rax,sz)
      vmovups           %ymm1,   32(%rdi,%rax,sz)
      vmovups           %ymm2, 2*32(%rdi,%rax,sz)
      vmovups           %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8     , %rcx
      and stride-1, %rcx
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vsqrtps           (%rsi,%rax,sz), %ymm0
      vmovups           %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r8d , %xmm2
      vpbroadcastd %xmm2, %ymm2
      vpcmpgtd     ymmD(%rip), %ymm2, %ymm2
      vmaskmovps   (%rsi,%rax,sz), %ymm2, %ymm0
      vsqrtps       %ymm0, %ymm0
      vmaskmovps   %ymm0, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSqrt_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      //vpxor %ymm1,  %ymm1  ,%ymm1
      //vzeroall
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vsqrtpd               (%rsi,%rax,sz), %ymm0
      vsqrtpd             32(%rsi,%rax,sz), %ymm1
      vsqrtpd           2*32(%rsi,%rax,sz), %ymm2
      vsqrtpd           3*32(%rsi,%rax,sz), %ymm3

      vmovupd           %ymm0,     (%rdi,%rax,sz)
      vmovupd           %ymm1,   32(%rdi,%rax,sz)
      vmovupd           %ymm2, 2*32(%rdi,%rax,sz)
      vmovupd           %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8     , %rcx
      and stride-1, %rcx
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vsqrtpd           (%rsi,%rax,sz), %ymm0
      vmovupd           %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r8d , %xmm2
      vpbroadcastq %xmm2, %ymm2
      vpcmpgtq     ymmQ(%rip), %ymm2, %ymm2
      vmaskmovpd   (%rsi,%rax,sz), %ymm2, %ymm0
      vsqrtpd      %ymm0, %ymm0
      vmaskmovpd   %ymm0, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkRSqrt_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      //vpxor %ymm1,  %ymm1  ,%ymm1
      //vzeroall
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vrsqrtps               (%rsi,%rax,sz), %ymm0
      vrsqrtps             32(%rsi,%rax,sz), %ymm1
      vrsqrtps           2*32(%rsi,%rax,sz), %ymm2
      vrsqrtps           3*32(%rsi,%rax,sz), %ymm3

      vmovups           %ymm0,     (%rdi,%rax,sz)
      vmovups           %ymm1,   32(%rdi,%rax,sz)
      vmovups           %ymm2, 2*32(%rdi,%rax,sz)
      vmovups           %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8     , %rcx
      and stride-1, %rcx
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vrsqrtps           (%rsi,%rax,sz), %ymm0
      vmovups           %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r8d , %xmm2
      vpbroadcastd %xmm2, %ymm2
      vpcmpgtd     ymmD(%rip), %ymm2, %ymm2
      vmaskmovps   (%rsi,%rax,sz), %ymm2, %ymm0
      vrsqrtps       %ymm0, %ymm0
      vmaskmovps   %ymm0, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkAbs_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      mov               $0x7FFFFFFF,    %eax
      vmovd             %eax,        %xmm5
      vbroadcastss      %xmm5,       %ymm5
      xor %rax,%rax
      //vpxor %ymm1,  %ymm1  ,%ymm1
      //vzeroall
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx

      jz .LskipBulk

  .LbulkLoop:
      vandps                 (%rsi,%rax,sz), %ymm5, %ymm0
      vandps               32(%rsi,%rax,sz), %ymm5, %ymm1
      vandps             2*32(%rsi,%rax,sz), %ymm5, %ymm2
      vandps             3*32(%rsi,%rax,sz), %ymm5, %ymm3

      vmovups           %ymm0,     (%rdi,%rax,sz)
      vmovups           %ymm1,   32(%rdi,%rax,sz)
      vmovups           %ymm2, 2*32(%rdi,%rax,sz)
      vmovups           %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8     , %rcx
      and stride-1, %rcx
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vandps             (%rsi,%rax,sz), %ymm5, %ymm0
      vmovups           %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r8d , %xmm2
      vpbroadcastd %xmm2, %ymm2
      vpcmpgtd     ymmD(%rip), %ymm2, %ymm2
      vmaskmovps   (%rsi,%rax,sz), %ymm2, %ymm0
      vandps        %ymm0, %ymm5, %ymm0
      vmaskmovps   %ymm0, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkAbs_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      mov               $0x7FFFFFFFFFFFFFFF, %rax
      vmovq             %rax,                %xmm5
      vbroadcastsd      %xmm5,               %ymm5
      xor %rax,%rax
      //vpxor %ymm1,  %ymm1  ,%ymm1
      //vzeroall
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx

      jz .LskipBulk

  .LbulkLoop:
      vandpd                 (%rsi,%rax,sz), %ymm5, %ymm0
      vandpd               32(%rsi,%rax,sz), %ymm5, %ymm1
      vandpd             2*32(%rsi,%rax,sz), %ymm5, %ymm2
      vandpd             3*32(%rsi,%rax,sz), %ymm5, %ymm3

      vmovupd           %ymm0,     (%rdi,%rax,sz)
      vmovupd           %ymm1,   32(%rdi,%rax,sz)
      vmovupd           %ymm2, 2*32(%rdi,%rax,sz)
      vmovupd           %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8     , %rcx
      and stride-1, %rcx
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vandpd             (%rsi,%rax,sz), %ymm5, %ymm0
      vmovupd            %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r8d , %xmm2
      vpbroadcastq %xmm2, %ymm2
      vpcmpgtq     ymmQ(%rip), %ymm2, %ymm2
      vmaskmovpd   (%rsi,%rax,sz), %ymm2, %ymm0
      vandpd       %ymm0, %ymm5, %ymm0
      vmaskmovpd   %ymm0, %ymm2, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSumSqr_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vpxor %ymm0,  %ymm0  ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

      vpxor %ymm5,  %ymm5  ,%ymm5
      //vpxor %ymm6,  %ymm6  ,%ymm6
      //vpxor %ymm7,  %ymm7  ,%ymm7

  .LbulkLoop:
      vmovups               (%rsi,%rax,sz), %ymm1
      vmovups             32(%rsi,%rax,sz), %ymm2
      vmovups           2*32(%rsi,%rax,sz), %ymm3
      vmovups           3*32(%rsi,%rax,sz), %ymm4

      vfmadd231ps       %ymm1, %ymm1, %ymm0
      vfmadd231ps       %ymm2, %ymm2, %ymm5
      vfmadd231ps       %ymm3, %ymm3, %ymm0
      vfmadd231ps       %ymm4, %ymm4, %ymm5

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop

      //loop .LbulkLoop
      vaddps           %ymm5, %ymm0, %ymm0
      //vaddps           %ymm7, %ymm6, %ymm6
      //vaddps           %ymm6, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovups           (%rsi,%rax,sz), %ymm1
      vfmadd231ps       %ymm1, %ymm1, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

//      vpxor        %ymm1, %ymm1, %ymm1
      vmovd        %r8d , %xmm2
      vpbroadcastd %xmm2, %ymm2
      vpcmpgtd     ymmD(%rip), %ymm2, %ymm2
      vmaskmovps   (%rsi,%rax,sz), %ymm2, %ymm1
      vfmadd231ps       %ymm1, %ymm1, %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
//      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vaddps        %xmm1, %xmm0, %xmm0
      vhaddps       %xmm0, %xmm0, %xmm0
      vhaddps       %xmm0, %xmm0, %xmm0
      vmovss        %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSumSqr_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
    {$endif}
      //push %rax
      xor %rax,%rax
      vpxor %ymm0,  %ymm0  ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

      vpxor %ymm5,  %ymm5  ,%ymm5
      //vpxor %ymm6,  %ymm6  ,%ymm6
      //vpxor %ymm7,  %ymm7  ,%ymm7
  .LbulkLoop:
      vmovupd               (%rsi,%rax,sz), %ymm1
      vmovupd             32(%rsi,%rax,sz), %ymm2
      vmovupd           2*32(%rsi,%rax,sz), %ymm3
      vmovupd           3*32(%rsi,%rax,sz), %ymm4

      vfmadd231pd       %ymm1, %ymm1, %ymm0
      vfmadd231pd       %ymm2, %ymm2, %ymm5
      vfmadd231pd       %ymm3, %ymm3, %ymm0
      vfmadd231pd       %ymm4, %ymm4, %ymm5

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop
      //loop .LbulkLoop
      vaddpd           %ymm5, %ymm0, %ymm0
      //vaddpd           %ymm7, %ymm6, %ymm6
      //vaddpd           %ymm6, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd           (%rsi,%rax,sz), %ymm1
      vfmadd231pd       %ymm1, %ymm1, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vpxor        %ymm1, %ymm1, %ymm1
      vmovd        %r8d , %xmm2
      vpbroadcastq %xmm2, %ymm2
      vpcmpgtq     ymmQ(%rip), %ymm2, %ymm2
      vmaskmovpd   (%rsi,%rax,sz), %ymm2, %ymm1
      vfmadd231pd       %ymm1, %ymm1, %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
//      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vaddpd        %xmm1, %xmm0, %xmm0
      vhaddpd       %xmm0, %xmm0, %xmm0
      //vhaddps       %xmm0, %xmm0, %xmm0
      vmovsd        %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSumAbs_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
       lea -0x10(%rsp), %rsp
       vmovdqu %xmm6, (%rsp)
    {$endif}
      //push %rax
      mov               $0x7FFFFFFF, %eax
      vmovd             %eax,        %xmm6
      vpbroadcastd      %xmm6,       %ymm6
      xor %rax,%rax

      vpxor %ymm0,  %ymm0  ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

      vpxor %ymm5,  %ymm5  ,%ymm5
      //vpxor %ymm6,  %ymm6  ,%ymm6
      //vpxor %ymm7,  %ymm7  ,%ymm7

  .LbulkLoop:
      vandps               (%rsi,%rax,sz), %ymm6, %ymm1
      vandps             32(%rsi,%rax,sz), %ymm6, %ymm2
      vandps           2*32(%rsi,%rax,sz), %ymm6, %ymm3
      vandps           3*32(%rsi,%rax,sz), %ymm6, %ymm4

      vaddps       %ymm1, %ymm0, %ymm0
      vaddps       %ymm2, %ymm5, %ymm5
      vaddps       %ymm3, %ymm0, %ymm0
      vaddps       %ymm4, %ymm5, %ymm5

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop

      //loop .LbulkLoop
      vaddps           %ymm5, %ymm0, %ymm0
      //vaddps           %ymm7, %ymm6, %ymm6
      //vaddps           %ymm6, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vandps           (%rsi,%rax,sz), %ymm6, %ymm1
      vaddps           %ymm1, %ymm0, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

//      vpxor        %ymm1, %ymm1, %ymm1
      vmovd        %r8d , %xmm2
      vpbroadcastd %xmm2, %ymm2
      vpcmpgtd     ymmD(%rip), %ymm2, %ymm2
      vmaskmovps   (%rsi,%rax,sz), %ymm2, %ymm1
      vandps       %ymm1, %ymm6, %ymm1
      vaddps       %ymm1, %ymm0, %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
//      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vaddps        %xmm1, %xmm0, %xmm0
      vhaddps       %xmm0, %xmm0, %xmm0
      vhaddps       %xmm0, %xmm0, %xmm0
      vmovss        %xmm0, (%rdi)
      {$ifdef windows}
        vmovdqu  (%rsp),  %xmm6
        lea      0x10(%rsp), %rsp
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSumAbs_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov Count, %edx
       lea -0x10(%rsp), %rsp
       vmovdqu %xmm6, (%rsp)
    {$endif}
      //push %rax
      mov               $0x7FFFFFFFFFFFFFFF, %rax
      vmovq             %rax,        %xmm6
      vpbroadcastq      %xmm6,       %ymm6
      xor %rax,%rax

      vpxor %ymm0,  %ymm0  ,%ymm0
      mov %edx  , %r8d
      shr shifter+2 , %rdx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

      vpxor %ymm5,  %ymm5  ,%ymm5
      //vpxor %ymm6,  %ymm6  ,%ymm6
      //vpxor %ymm7,  %ymm7  ,%ymm7

  .LbulkLoop:
      vandpd               (%rsi,%rax,sz), %ymm6, %ymm1
      vandpd             32(%rsi,%rax,sz), %ymm6, %ymm2
      vandpd           2*32(%rsi,%rax,sz), %ymm6, %ymm3
      vandpd           3*32(%rsi,%rax,sz), %ymm6, %ymm4

      vaddpd       %ymm1, %ymm0, %ymm0
      vaddpd       %ymm2, %ymm5, %ymm5
      vaddpd       %ymm3, %ymm0, %ymm0
      vaddpd       %ymm4, %ymm5, %ymm5

      add       stride, %rax
      dec %rdx
      jnz .LbulkLoop

      //loop .LbulkLoop
      vaddpd           %ymm5, %ymm0, %ymm0
      //vaddps           %ymm7, %ymm6, %ymm6
      //vaddps           %ymm6, %ymm0, %ymm0

  .LskipBulk:

      mov %r8   , %rcx
      and stride-1, %rcx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %rcx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vandpd           (%rsi,%rax,sz), %ymm6, %ymm1
      vaddpd           %ymm1, %ymm0, %ymm0

      add rCnt, %rax
      dec %rcx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

//      vpxor        %ymm1, %ymm1, %ymm1
      vmovd        %r8d , %xmm2
      vpbroadcastq %xmm2, %ymm2
      vpcmpgtq     ymmQ(%rip), %ymm2, %ymm2
      vmaskmovpd   (%rsi,%rax,sz), %ymm2, %ymm1
      vandpd       %ymm1, %ymm6, %ymm1
      vaddpd       %ymm1, %ymm0, %ymm0

  .Ldone:
      vextractf128  $1, %ymm0, %xmm1
//      vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
      vaddpd        %xmm1, %xmm0, %xmm0
      vhaddpd       %xmm0, %xmm0, %xmm0
      //vhaddpd       %xmm0, %xmm0, %xmm0
      vmovsd        %xmm0, (%rdi)
      {$ifdef windows}
        vmovdqu  (%rsp),  %xmm6
        lea      0x10(%rsp), %rsp
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkGathera_s(const dst,a:PSingle;const aStride:Longint ;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov aStride, %edx
       mov Count, %ecx
    {$endif}

  mov             %ecx,  %r8d
  //mov             $-1,   %eax
  //vmovd           %eax,  %xmm3
  vmovd           %edx,  %xmm2
  vpbroadcastd    %xmm2, %ymm2
  vpmulld         ymmD(%rip), %ymm2, %ymm2
  imul            regSize,  %rdx

  //shr             shifter+2, %ecx
  //jz              .LskipBulk

//.LbulkLoop:
//  vmovups         mskPs(%rip), %ymm1
//  vgatherdps      %ymm1,       (%rsi,%ymm2,sz), %ymm0
//  vgatherdps      %ymm1,   0x20(%rsi,%ymm2,sz), %ymm3
//  vgatherdps      %ymm1, 2*0x20(%rsi,%ymm2,sz), %ymm4
//  vgatherdps      %ymm1, 3*0x20(%rsi,%ymm2,sz), %ymm5
//
//  vmovups         %ymm0,       (%rdi)
//  vmovups         %ymm3,   0x20(%rdi)
//  vmovups         %ymm4, 2*0x20(%rdi)
//  vmovups         %ymm5, 3*0x20(%rdi)
//
//  lea             (%rsi, %rax,4), %rsi
//  add             stride*sz, %rdi
//  dec             %ecx
//  jnz             .LbulkLoop
//
//.LskipBulk:
  //mov             %r8d, %ecx
  //and             stride-1, %ecx
  shr             shifter,  %ecx              // count div 8
  jz              .LskipShort

.LshortLoop:
  //vpbroadcastd    %xmm3, %ymm1
  vpcmpeqd        %ymm1,       %ymm1          , %ymm1
  vgatherdps      %ymm1,       (%rsi,%ymm2,sz), %ymm0
  vmovups         %ymm0,       (%rdi)
  lea             (%rsi,%rdx), %rsi
  add             rCnt*sz,      %rdi
  dec             %ecx
  jnz             .LshortLoop

.LskipShort:
  andl            rCnt-1, %r8d
  jz              .Ldone
  vmovd           %r8d ,    %xmm3
  vpbroadcastd    %xmm3,%ymm3
  vpcmpgtd        ymmD(%rip), %ymm3, %ymm1
  vmovdqa         %ymm1, %ymm3
  vgatherdps      %ymm1, (%rsi,%ymm2,sz), %ymm0
  vmaskmovps      %ymm0, %ymm3, (%rdi)

.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}
end;

procedure bulkGathera_d(const dst,a:PDouble;const aStride:Longint ;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov aStride, %edx
       mov Count, %ecx
    {$endif}

  mov             %ecx,    %r8d
//  mov             $-1,     %rax
//  vmovq           %rax,    %xmm3
  vmovd           %edx,    %xmm2
  vpbroadcastd    %xmm2,   %ymm2
  imul            regSize, %rdx

  vpmulld         ymmD(%rip), %ymm2, %ymm2
  //shr             shifter+2, %ecx
  //jz              .LskipBulk

//.LbulkLoop:
//  vgatherdps      %ymm1,       (%rsi,%ymm2,sz), %ymm0
//  vgatherdps      %ymm1,   0x20(%rsi,%ymm2,sz), %ymm3
//  vgatherdps      %ymm1, 2*0x20(%rsi,%ymm2,sz), %ymm4
//  vgatherdps      %ymm1, 3*0x20(%rsi,%ymm2,sz), %ymm5
//
//  vmovups         %ymm0,       (%rdi)
//  vmovups         %ymm3,   0x20(%rdi)
//  vmovups         %ymm4, 2*0x20(%rdi)
//  vmovups         %ymm5, 3*0x20(%rdi)
//
//  lea             (%rsi, %rax,4), %rsi
//  add             stride*sz, %rdi
//  dec             %ecx
//  jnz             .LbulkLoop
//
//.LskipBulk:
  //mov             %r8d, %ecx
  //and             stride-1, %ecx
  shr             shifter,  %ecx              // count div 4
  jz              .LskipShort

.LshortLoop:
  //vpbroadcastq    %xmm3, %ymm1
  vpcmpeqq        %ymm1,        %ymm1          ,%ymm1
  vgatherdpd      %ymm1,        (%rsi,%xmm2,sz), %ymm0
  vmovupd         %ymm0,        (%rdi)
  lea             (%rsi,%rdx),  %rsi
  add             rCnt*sz,      %rdi
  dec             %ecx
  jnz             .LshortLoop

.LskipShort:
  andl            rCnt-1, %r8d
  jz              .Ldone
  vmovd           %r8d ,    %xmm0
  vpbroadcastq    %xmm0,%ymm0
  vpcmpgtq        ymmQ(%rip), %ymm0, %ymm1
  vmovdqa         %ymm1, %ymm3
  vgatherdpd      %ymm1,  (%rsi,%xmm2,sz), %ymm0
  vmaskmovpd      %ymm0,  %ymm3, (%rdi)

.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}
end;


procedure bulkDiffSqr_s(const dst,a,b:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax

      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
// [Haitham Shatti] note to self :- bellow trying to group loads and operations
//  utilizing more SIMD registers but when testing, i didn't find any noticable performance improvement
//  over using minimum registers with ungrouped loads and ops, but anyway so be it!...

  .LbulkLoop:
      vmovups       (%rsi,%rax,sz), %ymm0
      vmovups     32(%rsi,%rax,sz), %ymm1
      vmovups   2*32(%rsi,%rax,sz), %ymm2
      vmovups   3*32(%rsi,%rax,sz), %ymm3

      vsubps        (%rdx,%rax,sz), %ymm0, %ymm0
      vsubps      32(%rdx,%rax,sz), %ymm1, %ymm1
      vsubps    2*32(%rdx,%rax,sz), %ymm2, %ymm2
      vsubps    3*32(%rdx,%rax,sz), %ymm3, %ymm3

      vmulps        %ymm0, %ymm0, %ymm0
      vmulps        %ymm1, %ymm1, %ymm1
      vmulps        %ymm2, %ymm2, %ymm2
      vmulps        %ymm3, %ymm3, %ymm3

      vmovups   %ymm0,     (%rdi,%rax,sz)
      vmovups   %ymm1,   32(%rdi,%rax,sz)
      vmovups   %ymm2, 2*32(%rdi,%rax,sz)
      vmovups   %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovups       (%rsi,%rax,sz), %ymm0
      vsubps        (%rdx,%rax,sz), %ymm0, %ymm0
      vmulps        %ymm0, %ymm0, %ymm0
      vmovups       %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm0
      vpbroadcastd %xmm0,%ymm0
      vpcmpgtd ymmD(%rip), %ymm0, %ymm1
      vmaskmovps    (%rsi,%rax,sz),%ymm1, %ymm0
      vsubps        (%rdx,%rax,sz), %ymm0, %ymm0
      vmulps        %ymm0, %ymm0, %ymm0
      vmaskmovps    %ymm0, %ymm1, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
  //pop %rax
{$else}

{$endif}
end;

procedure bulkDiffSqr_d(const dst,a,b:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax

      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
// [Haitham Shatti] note to self :- bellow trying to group loads and operations
//  utilizing more SIMD registers but when testing, i didn't find any noticable performance improvement
//  over using minimum registers with ungrouped loads and ops, but anyway so be it!...

  .LbulkLoop:
      vmovupd       (%rsi,%rax,sz), %ymm0
      vmovupd     32(%rsi,%rax,sz), %ymm1
      vmovupd   2*32(%rsi,%rax,sz), %ymm2
      vmovupd   3*32(%rsi,%rax,sz), %ymm3

      vsubpd        (%rdx,%rax,sz), %ymm0, %ymm0
      vsubpd      32(%rdx,%rax,sz), %ymm1, %ymm1
      vsubpd    2*32(%rdx,%rax,sz), %ymm2, %ymm2
      vsubpd    3*32(%rdx,%rax,sz), %ymm3, %ymm3

      vmulpd        %ymm0, %ymm0, %ymm0
      vmulpd        %ymm1, %ymm1, %ymm1
      vmulpd        %ymm2, %ymm2, %ymm2
      vmulpd        %ymm3, %ymm3, %ymm3

      vmovupd   %ymm0,     (%rdi,%rax,sz)
      vmovupd   %ymm1,   32(%rdi,%rax,sz)
      vmovupd   %ymm2, 2*32(%rdi,%rax,sz)
      vmovupd   %ymm3, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd       (%rsi,%rax,sz), %ymm0
      vsubpd        (%rdx,%rax,sz), %ymm0, %ymm0
      vmulpd        %ymm0, %ymm0, %ymm0
      vmovupd       %ymm0, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm0
      vpbroadcastq %xmm0,%ymm0
      vpcmpgtq ymmQ(%rip), %ymm0, %ymm1
      //vmovdqu       %ymm1, (%rdi)
      //ret

      vmaskmovpd    (%rsi,%rax,sz),%ymm1, %ymm0
      vsubpd        (%rdx,%rax,sz), %ymm0, %ymm0
      vmulpd        %ymm0, %ymm0, %ymm0
      vmaskmovpd    %ymm0, %ymm1, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkDiffSqr_sd(const dst,a,b:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax

      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      vbroadcastsd (%rdx), %ymm0
      jz .LskipBulk
// [Haitham Shatti] note to self :- bellow trying to group loads and operations
//  utilizing more SIMD registers but when testing, i didn't find any noticable performance improvement
//  over using minimum registers with ungrouped loads and ops, but anyway so be it!...

  .LbulkLoop:

      vsubpd        (%rsi,%rax,sz), %ymm0, %ymm1
      vsubpd      32(%rsi,%rax,sz), %ymm0, %ymm2
      vsubpd    2*32(%rsi,%rax,sz), %ymm0, %ymm3
      vsubpd    3*32(%rsi,%rax,sz), %ymm0, %ymm4

      vmulpd        %ymm1, %ymm1, %ymm1
      vmulpd        %ymm2, %ymm2, %ymm2
      vmulpd        %ymm3, %ymm3, %ymm3
      vmulpd        %ymm4, %ymm4, %ymm4

      vmovupd   %ymm1,     (%rdi,%rax,sz)
      vmovupd   %ymm2,   32(%rdi,%rax,sz)
      vmovupd   %ymm3, 2*32(%rdi,%rax,sz)
      vmovupd   %ymm4, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vsubpd        (%rsi,%rax,sz), %ymm0, %ymm1
      vmulpd        %ymm1, %ymm1, %ymm1
      vmovupd       %ymm1, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm2
      vpbroadcastq %xmm2,%ymm2
      vpcmpgtq ymmQ(%rip), %ymm2, %ymm1
      //vmovdqu       %ymm1, (%rdi)
      //ret

      vsubpd        (%rsi,%rax,sz), %ymm0, %ymm0
      vmulpd        %ymm0, %ymm0, %ymm0
      vmaskmovpd    %ymm0, %ymm1, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkDiffSqr_ss(const dst,a,b:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax

      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      vbroadcastss (%rdx), %ymm0
      jz .LskipBulk
// [Haitham Shatti] note to self :- bellow trying to group loads and operations
//  utilizing more SIMD registers but when testing, i didn't find any noticable performance improvement
//  over using minimum registers with ungrouped loads and ops, but anyway so be it!...

  .LbulkLoop:

      vsubps        (%rsi,%rax,sz), %ymm0, %ymm1
      vsubps      32(%rsi,%rax,sz), %ymm0, %ymm2
      vsubps    2*32(%rsi,%rax,sz), %ymm0, %ymm3
      vsubps    3*32(%rsi,%rax,sz), %ymm0, %ymm4

      vmulps        %ymm1, %ymm1, %ymm1
      vmulps        %ymm2, %ymm2, %ymm2
      vmulps        %ymm3, %ymm3, %ymm3
      vmulps        %ymm4, %ymm4, %ymm4

      vmovups   %ymm1,     (%rdi,%rax,sz)
      vmovups   %ymm2,   32(%rdi,%rax,sz)
      vmovups   %ymm3, 2*32(%rdi,%rax,sz)
      vmovups   %ymm4, 3*32(%rdi,%rax,sz)

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vsubps        (%rsi,%rax,sz), %ymm0, %ymm1
      vmulps        %ymm1, %ymm1, %ymm1
      vmovups       %ymm1, (%rdi,%rax,sz)

      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm2
      vpbroadcastd %xmm2,%ymm2
      vpcmpgtd ymmQ(%rip), %ymm2, %ymm1
      //vmovdqu       %ymm1, (%rdi)
      //ret

      vsubps        (%rsi,%rax,sz), %ymm0, %ymm0
      vmulps        %ymm0, %ymm0, %ymm0
      vmaskmovps    %ymm0, %ymm1, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;



{%endregion}

{%region complex}


{ calculate the magnitude vector of a complex vector of singles}
procedure bulkMag_cs(const dst, a:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*1*4{(element count per register) X (number of bulk repeates) X (rquired registers)};
const shifter=3;// log2(rCnt * reqRegisters);
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
//   mov b, %rdx
   mov Count, %edx
{$endif}
  xor %rax,%rax
  mov %edx  , %ecx
  shr shifter{+2} , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
  jz .LskipBulk
.LbulkLoop:
  vmovups   (%rsi,%rax,sz), %ymm0                  // [1, 2, 3, 4]
  vmovups 32(%rsi,%rax,sz), %ymm1                  // [5, 6, 7, 8]

  vmulps    %ymm0, %ymm0, %ymm0           //sqr
  vmulps    %ymm1, %ymm1, %ymm1           //sqr
  vhaddps   %ymm1, %ymm0, %ymm0             // mag^2 [1, 2, 5, 6, 3, 4, 7, 8]
  vpermpd   $0b11011000, %ymm0, %ymm0          // mag^2 [1, 2, 3, 4, 5, 6, 7, 8]
  vsqrtps   %ymm0, %ymm0                  // sqrt(mag^2) => mag
  vmovups   %ymm0, (%rdi,%rax,sz/2)
  add       stride,   %rax
  dec       %ecx
  jg  .LbulkLoop
.LskipBulk:
  mov           %edx,  %ecx
  and           rCnt*2-1, %ecx
  jz            .Ldone

  vmovd         %ecx,  %xmm0
  vpbroadcastd  %xmm0, %ymm0
  vpcmpgtd      ymmD(%rip), %ymm0, %ymm3
  vmovups       (%rsi,%rax,sz), %ymm0                  // [1, 2, 3, 4]
  vmovups       32(%rsi,%rax,sz), %ymm1                  // [5, 6, 7, 8]
  vmulps        %ymm0, %ymm0, %ymm0           //sqr
  vmulps        %ymm1, %ymm1, %ymm1           //sqr
  vhaddps       %ymm1,  %ymm0, %ymm0             // mag^2 [1, 2, 5, 6, 3, 4, 7, 8]
  vpermpd       $0b11011000, %ymm0, %ymm0          // mag^2 [1, 2, 3, 4, 5, 6, 7, 8]
  vsqrtps       %ymm0,  %ymm0                  // sqrt(mag^2) => mag
  vmaskmovps    %ymm0,  %ymm3, (%rdi,%rax,sz/2)
.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;

procedure bulkMag_cd(const dst, a:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*1*4{(element count per register) X (number of bulk repeates) X (rquired registers)};
const shifter=2;// log2(rCnt * reqRegisters);
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
//   mov b, %rdx
   mov Count, %edx
{$endif}
  xor %rax,%rax
  mov %edx  , %ecx
  shr shifter{+2} , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
  jz .LskipBulk
.LbulkLoop:
  vmovupd   (%rsi,%rax,sz), %ymm0                  // [1, 2]
  vmovupd 32(%rsi,%rax,sz), %ymm1                  // [3, 4]
  vmulpd    %ymm0, %ymm0, %ymm0           //sqr
  vmulpd    %ymm1, %ymm1, %ymm1           //sqr

  vhaddpd   %ymm1,  %ymm0, %ymm0             // mag^2 [1, 3, 2, 4]
  vpermpd   $0b11011000, %ymm0, %ymm0          // mag^2 [1, 2, 3, 4]
  vsqrtpd   %ymm0,  %ymm0                  // sqrt(mag^2) => mag
  vmovupd   %ymm0,  (%rdi,%rax,sz/2)
  add       stride,   %rax
  dec       %ecx
  jg  .LbulkLoop
.LskipBulk:
  mov           %edx,  %ecx
  and           rCnt*2-1, %ecx
  jz            .Ldone

  vmovd         %ecx,  %xmm0
  vpbroadcastq  %xmm0, %ymm0
  vpcmpgtq      ymmQ(%rip), %ymm0, %ymm3
  vmovupd         (%rsi,%rax,sz), %ymm0                  // [1, 2]
  vmovupd       32(%rsi,%rax,sz), %ymm1                  // [3, 4]
  vmulpd        %ymm0, %ymm0, %ymm0           //sqr
  vmulpd        %ymm1, %ymm1, %ymm1           //sqr
  vhaddpd       %ymm1,  %ymm0, %ymm0             // mag^2 [1, 3, 2, 4]
  vpermpd       $0b11011000, %ymm0, %ymm0          // mag^2 [1, 2, 3, 4]
  vsqrtpd       %ymm0,  %ymm0                  // sqrt(mag^2) => mag
  vmaskmovpd    %ymm0,  %ymm3, (%rdi,%rax,sz/2)
.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;


{ Add all elements of complex vector of singles to a complex of single}
procedure bulkAdd_css(const dst, a, b:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
   mov b, %rdx
   mov Count, %ecx
{$endif}
   xor            %rax,  %rax
   mov            %ecx, %r8d
   vpbroadcastq   (%rsi), %ymm0
   shr            shifter+2, %ecx             // div stride
   jz             .LskipBulk
.LbulkLoop:
   vaddps           (%rdx,%rax,sz), %ymm0, %ymm1
   vaddps         32(%rdx,%rax,sz), %ymm0, %ymm2
   vaddps         64(%rdx,%rax,sz), %ymm0, %ymm3
   vaddps         96(%rdx,%rax,sz), %ymm0, %ymm4
   vmovups        %ymm1,   (%rdi,%rax,sz)
   vmovups        %ymm2, 32(%rdi,%rax,sz)
   vmovups        %ymm3, 64(%rdi,%rax,sz)
   vmovups        %ymm4, 96(%rdi,%rax,sz)
   add            stride*2, %rax
   dec            %ecx
   jg             .LbulkLoop

.LskipBulk:
   mov            %r8d, %ecx
   and            stride-1,  %ecx
   shr            shifter,   %ecx
   jz             .LskipShort

.LremLoop:
   vaddps           (%rdx,%rax,sz), %ymm0, %ymm1
   vmovups        %ymm1, (%rdi,%rax,sz)
   add            rCnt*2,  %rax
   dec            %ecx
   jg             .LremLoop

.LskipShort:
   and            rCnt-1,  %r8d
   jz             .Ldone
   shl            $1,      %r8d

   vmovd          %r8d,    %xmm2
   vpbroadcastd   %xmm2,   %ymm2
   vpcmpgtd       ymmD(%rip),  %ymm2, %ymm3
   vaddps           (%rdx,%rax,sz), %ymm0, %ymm1
   vmaskmovps     %ymm1,   %ymm3,  (%rdi,%rax,sz)


.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;

procedure bulkAdd_csd(const dst, a, b:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
   mov b, %rdx
   mov Count, %ecx
{$endif}
   xor            %rax,  %rax
   mov            %ecx, %r8d
   vbroadcastf128   (%rsi), %ymm0
   shr            shifter+2, %ecx             // div stride
   jz             .LskipBulk
.LbulkLoop:
   vaddpd           (%rdx,%rax,sz), %ymm0, %ymm1
   vaddpd         32(%rdx,%rax,sz), %ymm0, %ymm2
   vaddpd         64(%rdx,%rax,sz), %ymm0, %ymm3
   vaddpd         96(%rdx,%rax,sz), %ymm0, %ymm4
   vmovupd        %ymm1,   (%rdi,%rax,sz)
   vmovupd        %ymm2, 32(%rdi,%rax,sz)
   vmovupd        %ymm3, 64(%rdi,%rax,sz)
   vmovupd        %ymm4, 96(%rdi,%rax,sz)
   add            stride*2, %rax
   dec            %ecx
   jg             .LbulkLoop

.LskipBulk:
   mov            %r8d, %ecx
   and            stride-1,  %ecx
   shr            shifter,   %ecx
   jz             .LskipShort

.LremLoop:
   vaddpd           (%rdx,%rax,sz), %ymm0, %ymm1
   vmovupd        %ymm1, (%rdi,%rax,sz)
   add            rCnt*2,  %rax
   dec            %ecx
   jg             .LremLoop

.LskipShort:
   and            rCnt-1,  %r8d
   jz             .Ldone
   shl            $1,      %r8d

   vmovd          %r8d,    %xmm2
   vpbroadcastq   %xmm2,   %ymm2
   vpcmpgtq       ymmQ(%rip),  %ymm2, %ymm3
   vaddpd         (%rdx,%rax,sz), %ymm0, %ymm1
   vmaskmovpd     %ymm1,   %ymm3,  (%rdi,%rax,sz)


.Ldone:
 {$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;

{ Subtract all elements of complex vector of singles from a complex of single (b - a)}
procedure bulkSub_css(const dst, a, b:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
   mov b, %rdx
   mov Count, %ecx
{$endif}
   xor            %rax,  %rax
   mov            %ecx, %r8d
   vpbroadcastq   (%rsi), %ymm0
   shr            shifter+2, %ecx             // div stride
   jz             .LskipBulk
.LbulkLoop:
   vsubps           (%rdx,%rax,sz), %ymm0, %ymm1
   vsubps         32(%rdx,%rax,sz), %ymm0, %ymm2
   vsubps         64(%rdx,%rax,sz), %ymm0, %ymm3
   vsubps         96(%rdx,%rax,sz), %ymm0, %ymm4
   vmovups        %ymm1,   (%rdi,%rax,sz)
   vmovups        %ymm2, 32(%rdi,%rax,sz)
   vmovups        %ymm3, 64(%rdi,%rax,sz)
   vmovups        %ymm4, 96(%rdi,%rax,sz)
   add            stride*2, %rax
   dec            %ecx
   jg             .LbulkLoop

.LskipBulk:
   mov            %r8d, %ecx
   and            stride-1,  %ecx
   shr            shifter,   %ecx
   jz             .LskipShort

.LremLoop:
   vsubps           (%rdx,%rax,sz), %ymm0, %ymm1
   vmovups        %ymm1, (%rdi,%rax,sz)
   add            rCnt*2,  %rax
   dec            %ecx
   jg             .LremLoop

.LskipShort:
   and            rCnt-1,  %r8d
   jz             .Ldone
   shl            $1,      %r8d

   vmovd          %r8d,    %xmm2
   vpbroadcastd   %xmm2,   %ymm2
   vpcmpgtd       ymmD(%rip),  %ymm2, %ymm3
   vsubps         (%rdx,%rax,sz), %ymm0, %ymm1
   vmaskmovps     %ymm1,   %ymm3,  (%rdi,%rax,sz)


.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;

{ Subtract all elements of complex vector of singles from a complex of single (b - a)}
procedure bulkSub_csd(const dst, a, b:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
   mov b, %rdx
   mov Count, %ecx
{$endif}
   xor            %rax,  %rax
   mov            %ecx, %r8d
   vbroadcastf128   (%rsi), %ymm0
   shr            shifter+2, %ecx             // div stride
   jz             .LskipBulk
.LbulkLoop:
   vsubpd           (%rdx,%rax,sz), %ymm0, %ymm1
   vsubpd         32(%rdx,%rax,sz), %ymm0, %ymm2
   vsubpd         64(%rdx,%rax,sz), %ymm0, %ymm3
   vsubpd         96(%rdx,%rax,sz), %ymm0, %ymm4
   vmovupd        %ymm1,   (%rdi,%rax,sz)
   vmovupd        %ymm2, 32(%rdi,%rax,sz)
   vmovupd        %ymm3, 64(%rdi,%rax,sz)
   vmovupd        %ymm4, 96(%rdi,%rax,sz)
   add            stride*2, %rax
   dec            %ecx
   jg             .LbulkLoop

.LskipBulk:
   mov            %r8d, %ecx
   and            stride-1,  %ecx
   shr            shifter,   %ecx
   jz             .LskipShort

.LremLoop:
   vsubpd           (%rdx,%rax,sz), %ymm0, %ymm1
   vmovupd        %ymm1, (%rdi,%rax,sz)
   add            rCnt*2,  %rax
   dec            %ecx
   jg             .LremLoop

.LskipShort:
   and            rCnt-1,  %r8d
   jz             .Ldone
   shl            $1,      %r8d

   vmovd          %r8d,    %xmm2
   vpbroadcastq   %xmm2,   %ymm2
   vpcmpgtq       ymmQ(%rip),  %ymm2, %ymm3
   vsubpd         (%rdx,%rax,sz), %ymm0, %ymm1
   vmaskmovpd     %ymm1,   %ymm3,  (%rdi,%rax,sz)


.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;


{ Multiply all elements of complex vector of singles by a complex of single}
procedure bulkMul_css(const dst, a, b:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
   mov b, %rdx
   mov Count, %ecx
{$endif}
   xor            %rax  , %rax
   mov            %ecx , %r8d
   vpbroadcastq   (%rsi), %ymm0
   vmovshdup      %ymm0 , %ymm1     // load Imag part b of 4 complex and replicat [0,1,3,4] to mm1
   vmovsldup      %ymm0 , %ymm0     // load Real part b of 4 complex and replicat [0,1,3,4] to mm2
   shr            shifter+2, %ecx             // div stride
   jz             .LskipBulk
.LbulkLoop:

   vmulps         (%rdx,%rax,sz), %ymm0, %ymm2      // a.re*b.re , a.im*b.re
   vmulps         (%rdx,%rax,sz), %ymm1, %ymm3      // a.re*b.im , a.im*b.im
   vpermilps  $0b10110001       , %ymm3, %ymm3      // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubps  %ymm3             , %ymm2, %ymm2      // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovups    %ymm2             , (%rdi,%rax,sz)

   vmulps     0x20(%rdx,%rax,sz), %ymm0, %ymm4      // a.re*b.re , a.im*b.re
   vmulps     0x20(%rdx,%rax,sz), %ymm1, %ymm5      // a.re*b.im , a.im*b.im
   vpermilps  $0b10110001       , %ymm5, %ymm5      // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubps  %ymm5             , %ymm4, %ymm4      // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovups    %ymm4             , 0x20(%rdi,%rax,sz)

   vmulps     0x40(%rdx,%rax,sz), %ymm0, %ymm2      // a.re*b.re , a.im*b.re
   vmulps     0x40(%rdx,%rax,sz), %ymm1, %ymm3      // a.re*b.im , a.im*b.im
   vpermilps  $0b10110001       , %ymm3, %ymm3      // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubps  %ymm3             , %ymm2, %ymm2      // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovups    %ymm2             , 0x40(%rdi,%rax,sz)

   vmulps     0x60(%rdx,%rax,sz), %ymm0, %ymm4      // a.re*b.re , a.im*b.re
   vmulps     0x60(%rdx,%rax,sz), %ymm1, %ymm5      // a.re*b.im , a.im*b.im
   vpermilps  $0b10110001       , %ymm5, %ymm5      // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubps  %ymm5             , %ymm4, %ymm4      // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovups    %ymm4             , 0x60(%rdi,%rax,sz)

   add            stride*2, %rax
   dec            %ecx
   jg             .LbulkLoop

.LskipBulk:
   mov            %r8d, %ecx
   and            stride-1,  %ecx
   shr            shifter,   %ecx
   jz             .LskipShort

.LremLoop:
   vmulps         (%rdx,%rax,sz), %ymm0, %ymm2      // a.re*b.re , a.im*b.re
   vmulps         (%rdx,%rax,sz), %ymm1, %ymm3      // a.re*b.im , a.im*b.im
   vpermilps  $0b10110001       , %ymm3, %ymm3      // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubps  %ymm3             , %ymm2, %ymm2      // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovups    %ymm2             , (%rdi,%rax,sz)

   add            rCnt*2,  %rax
   dec            %ecx
   jg             .LremLoop

.LskipShort:
   and            rCnt-1,  %r8d
   jz             .Ldone
   shl            $1,      %r8d

   vmovd          %r8d      , %xmm5
   vpbroadcastd   %xmm5     , %ymm5
   vpcmpgtd       ymmD(%rip), %ymm5, %ymm5

   vmaskmovps (%rdx,%rax,sz), %ymm5, %ymm4
   vmulps     %ymm4         , %ymm0, %ymm2      // a.re*b.re , a.im*b.re
   vmulps     %ymm4         , %ymm1, %ymm3      // a.re*b.im , a.im*b.im
   vpermilps  $0b10110001   , %ymm3, %ymm3         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubps  %ymm3         , %ymm2, %ymm2               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmaskmovps %ymm2         , %ymm5, (%rdi,%rax,sz)


.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;

{ Multiply all elements of complex vector of singles by a complex of single}
procedure bulkMul_csd(const dst, a, b:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
   mov b, %rdx
   mov Count, %ecx
{$endif}
   xor            %rax         , %rax
   mov            %ecx         , %r8d
   vbroadcastf128 (%rsi)       , %ymm0
   vpermilpd      $0b1111      , %ymm0 , %ymm1     // load Imag part b of 4 complex and replicat [0,1,3,4] to mm1
   vmovddup       %ymm0        , %ymm0     // load Real part b of 4 complex and replicat [0,1,3,4] to mm2
   shr            shifter+2    , %ecx             // div stride
   jz             .LskipBulk
.LbulkLoop:

   vmulpd         (%rdx,%rax,sz), %ymm0, %ymm2      // a.re*b.re , a.im*b.re
   vmulpd         (%rdx,%rax,sz), %ymm1, %ymm3      // a.re*b.im , a.im*b.im
   vpermilpd  $0b0101           , %ymm3, %ymm3         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubpd  %ymm3             , %ymm2, %ymm2               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovupd    %ymm2             ,     (%rdi,%rax,sz)

   vmulpd     0x20(%rdx,%rax,sz), %ymm0, %ymm4      // a.re*b.re , a.im*b.re
   vmulpd     0x20(%rdx,%rax,sz), %ymm1, %ymm5      // a.re*b.im , a.im*b.im
   vpermilpd  $0b0101           , %ymm5, %ymm5         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubpd  %ymm5             , %ymm4, %ymm4               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovupd    %ymm4             , 0x20(%rdi,%rax,sz)

   vmulpd     0x40(%rdx,%rax,sz), %ymm0, %ymm2      // a.re*b.re , a.im*b.re
   vmulpd     0x40(%rdx,%rax,sz), %ymm1, %ymm3      // a.re*b.im , a.im*b.im
   vpermilpd  $0b0101           , %ymm3, %ymm3         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubpd  %ymm3             , %ymm2, %ymm2               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovupd    %ymm2             , 0x40(%rdi,%rax,sz)

   vmulpd     0x60(%rdx,%rax,sz), %ymm0, %ymm4      // a.re*b.re , a.im*b.re
   vmulpd     0x60(%rdx,%rax,sz), %ymm1, %ymm5     // a.re*b.im , a.im*b.im
   vpermilpd  $0b0101           , %ymm5, %ymm5        // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubpd  %ymm5             , %ymm4, %ymm4               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovupd    %ymm4             , 0x60(%rdi,%rax,sz)

   add            stride*2, %rax
   dec            %ecx
   jg             .LbulkLoop

.LskipBulk:
   mov            %r8d, %ecx
   and            stride-1,  %ecx
   shr            shifter,   %ecx
   jz             .LskipShort

.LremLoop:
   vmulpd         (%rdx,%rax,sz), %ymm0, %ymm2      // a.re*b.re , a.im*b.re
   vmulpd         (%rdx,%rax,sz), %ymm1, %ymm3      // a.re*b.im , a.im*b.im
   vpermilpd  $0b0101           , %ymm3, %ymm3         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubpd  %ymm3             , %ymm2, %ymm2               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmovupd    %ymm2             ,     (%rdi,%rax,sz)

   add            rCnt*2,  %rax
   dec            %ecx
   jg             .LremLoop

.LskipShort:
   and            rCnt-1,  %r8d
   jz             .Ldone
   shl            $1,      %r8d

   vmovd          %r8d      , %xmm5
   vpbroadcastq   %xmm5     , %ymm5
   vpcmpgtq       ymmQ(%rip), %ymm5, %ymm5

   vmaskmovpd (%rdx,%rax,sz), %ymm5, %ymm4
   vmulpd     %ymm4         , %ymm0, %ymm2      // a.re*b.re , a.im*b.re
   vmulpd     %ymm4         , %ymm1, %ymm3      // a.re*b.im , a.im*b.im
   vpermilpd  $0b0101       , %ymm3, %ymm3         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
   vaddsubpd  %ymm3         , %ymm2, %ymm2               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
   vmaskmovpd %ymm2         , %ymm5, (%rdi,%rax,sz)

.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;

{ Divide a complex of single by all elements of complex vector of singles}
procedure bulkDiv_css(const dst, a, b:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
   mov b, %rdx
   mov Count, %ecx
{$endif}
   xor            %rax,  %rax
   mov            %ecx,  %r8d
   vpbroadcastq   (%rsi), %ymm0
   vmovsldup      %ymm0             ,  %ymm1            //a.re                  ,             a.re
   vmovshdup      %ymm0             ,  %ymm2            //a.im                  ,             a.im
   shr            shifter+2, %ecx             // div stride
   jz             .LskipBulk
.LbulkLoop:

   vmovups        (%rdx,%rax,sz)    ,  %ymm0
   vmovsldup      %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vmovshdup      %ymm0             ,  %ymm4            //b.im                  ,             b.im
   vmulps         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231ps    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulps         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulps         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilps      $0b10110001       ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubps      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilps      $0b10110001       ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivps         %ymm3             ,  %ymm0,   %ymm0
   vmovups        %ymm0             ,  (%rdi,%rax,sz)

   vmovups        0x20(%rdx,%rax,sz),  %ymm0
   vmovsldup      %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vmovshdup      %ymm0             ,  %ymm4            //b.im                  ,             b.im
   vmulps         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231ps    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulps         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulps         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilps      $0b10110001       ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubps      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilps      $0b10110001       ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivps         %ymm3             ,  %ymm0,   %ymm0
   vmovups        %ymm0             ,  0x20(%rdi,%rax,sz)

   vmovups        0x40(%rdx,%rax,sz),  %ymm0
   vmovsldup      %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vmovshdup      %ymm0             ,  %ymm4            //b.im                  ,             b.im
   vmulps         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231ps    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulps         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulps         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilps      $0b10110001       ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubps      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilps      $0b10110001       ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivps         %ymm3             ,  %ymm0,   %ymm0
   vmovups        %ymm0             ,  0x40(%rdi,%rax,sz)

   vmovups        0x60(%rdx,%rax,sz),  %ymm0
   vmovsldup      %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vmovshdup      %ymm0             ,  %ymm4            //b.im                  ,             b.im
   vmulps         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231ps    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulps         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulps         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilps      $0b10110001       ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubps      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilps      $0b10110001       ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivps         %ymm3             ,  %ymm0,   %ymm0
   vmovups        %ymm0             ,  0x60(%rdi,%rax,sz)


   add            stride*2, %rax
   dec            %ecx
   jg             .LbulkLoop

.LskipBulk:
   mov            %r8d, %ecx
   and            stride-1,  %ecx
   shr            shifter,   %ecx
   jz             .LskipShort

.LremLoop:

   vmovups        (%rdx,%rax,sz)    ,  %ymm0
   vmovsldup      %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vmovshdup      %ymm0             ,  %ymm4            //b.im                  ,             b.im
   vmulps         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231ps    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulps         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulps         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilps      $0b10110001       ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubps      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilps      $0b10110001       ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivps         %ymm3             ,  %ymm0,   %ymm0
   vmovups        %ymm0             ,  (%rdi,%rax,sz)

   add            rCnt*2,  %rax
   dec            %ecx
   jg             .LremLoop

.LskipShort:
   and            rCnt-1,  %r8d
   jz             .Ldone
   shl            $1,      %r8d

   vmovd          %r8d,    %xmm0
   vpbroadcastd   %xmm0,   %ymm0
   vpcmpgtd       ymmD(%rip),  %ymm0, %ymm5
   //vcvtdq2ps      %ymm0,   %ymm0
   vpcmpeqd       %ymm0,   %ymm0    ,  %ymm0

   vblendvps      %ymm5             ,  (%rdx,%rax,sz) , %ymm0,  %ymm0
   vmovsldup      %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vmovshdup      %ymm0             ,  %ymm4            //b.im                  ,             b.im
   vmulps         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231ps    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulps         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulps         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilps      $0b10110001       ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubps      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilps      $0b10110001       ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivps         %ymm3             ,  %ymm0,   %ymm0
   vmaskmovps     %ymm0             ,  %ymm5,   (%rdi,%rax,sz)


.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;

{ Divide a complex of single by all elements of complex vector of singles}
procedure bulkDiv_csd(const dst, a, b:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
{$ifdef CPUX86_64}
{$ifdef windows}
   push %rsi
   push %rdi
   mov dst, %rdi
   mov a, %rsi
   mov b, %rdx
   mov Count, %ecx
{$endif}
   xor            %rax     , %rax
   mov            %ecx     , %r8d
   vbroadcastf128 (%rsi)   , %ymm0
   vmovddup       %ymm0    , %ymm1            //a.re                  ,             a.re
   vpermilpd      $0b1111  , %ymm0  ,  %ymm2            //a.im                  ,             a.im
   shr            shifter+2, %ecx             // div stride
   jz             .LskipBulk
.LbulkLoop:

   vmovupd        (%rdx,%rax,sz)    ,  %ymm0
   vmovddup       %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vpermilpd      $0b1111           ,  %ymm0,   %ymm4   //b.im                  ,             b.im
   vmulpd         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231pd    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulpd         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulpd         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilpd      $0b0101           ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubpd      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilpd      $0b0101           ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivpd         %ymm3             ,  %ymm0,   %ymm0
   vmovupd        %ymm0             ,  (%rdi,%rax,sz)

   vmovupd    0x20(%rdx,%rax,sz)    ,  %ymm0
   vmovddup       %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vpermilpd      $0b1111           ,  %ymm0,   %ymm4   //b.im                  ,             b.im
   vmulpd         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231pd    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulpd         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulpd         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilpd      $0b0101           ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubpd      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilpd      $0b0101           ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivpd         %ymm3             ,  %ymm0,   %ymm0
   vmovupd        %ymm0             ,  0x20(%rdi,%rax,sz)

   vmovupd    0x40(%rdx,%rax,sz)    ,  %ymm0
   vmovddup       %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vpermilpd      $0b1111           ,  %ymm0,   %ymm4   //b.im                  ,             b.im
   vmulpd         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231pd    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulpd         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulpd         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilpd      $0b0101           ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubpd      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilpd      $0b0101           ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivpd         %ymm3             ,  %ymm0,   %ymm0
   vmovupd        %ymm0             ,  0x40(%rdi,%rax,sz)

   vmovupd    0x60(%rdx,%rax,sz)    ,  %ymm0
   vmovddup       %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vpermilpd      $0b1111           ,  %ymm0,   %ymm4   //b.im                  ,             b.im
   vmulpd         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231pd    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulpd         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulpd         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilpd      $0b0101           ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubpd      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilpd      $0b0101           ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivpd         %ymm3             ,  %ymm0,   %ymm0
   vmovupd        %ymm0             ,  0x60(%rdi,%rax,sz)

   add            stride*2, %rax
   dec            %ecx
   jg             .LbulkLoop

.LskipBulk:
   mov            %r8d, %ecx
   and            stride-1,  %ecx
   shr            shifter,   %ecx
   jz             .LskipShort

.LremLoop:

   vmovupd        (%rdx,%rax,sz)    ,  %ymm0
   vmovddup       %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vpermilpd      $0b1111           ,  %ymm0,   %ymm4   //b.im                  ,             b.im
   vmulpd         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231pd    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulpd         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulpd         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilpd      $0b0101           ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubpd      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilpd      $0b0101           ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivpd         %ymm3             ,  %ymm0,   %ymm0
   vmovupd        %ymm0             ,  (%rdi,%rax,sz)

   add            rCnt*2,  %rax
   dec            %ecx
   jg             .LremLoop

.LskipShort:
   and            rCnt-1,  %r8d
   jz             .Ldone
   shl            $1,      %r8d

   vmovd          %r8d,    %xmm0
   vpbroadcastq   %xmm0,   %ymm0
   vpcmpgtq       ymmQ(%rip),  %ymm0,  %ymm5
   vpcmpeqq       %ymm0,   %ymm0    ,  %ymm0

   vblendvpd      %ymm5             ,  (%rdx,%rax,sz), %ymm0, %ymm0
   vmovddup       %ymm0             ,  %ymm3            //b.re                  ,             b.re
   vpermilpd      $0b1111           ,  %ymm0,   %ymm4   //b.im                  ,             b.im
   vmulpd         %ymm3             ,  %ymm3,   %ymm3   //b.re^2                ,             b.re^2
   vfmadd231pd    %ymm4             ,  %ymm4,   %ymm3   //b.im^2 + b.re^2       , b.im^2 + b.re^2
   vmulpd         %ymm0             ,  %ymm1,   %ymm4   //b.re*a.re             ,             b.im*a.re
   vmulpd         %ymm0             ,  %ymm2,   %ymm0   //b.re*a.im             ,             b.im*a.im
   vpermilpd      $0b0101           ,  %ymm4,   %ymm4   //b.im*a.re             ,             b.re*a.re
   vaddsubpd      %ymm4             ,  %ymm0,   %ymm0   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
   vpermilpd      $0b0101           ,  %ymm0,   %ymm0   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
   vdivpd         %ymm3             ,  %ymm0,   %ymm0
   vmaskmovpd     %ymm0             ,  %ymm5,   (%rdi,%rax,sz)


.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$endif}
end;


{ multiply a vector complex of singles by a vector complex of singles }
procedure bulkMul_ccs(const dst, a, b: PSingle; const Count: integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
.LbulkLoop:
      vmovsldup  (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  (%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     (%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulps     (%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilps  $0b10110001, %ymm2, %ymm2         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
      vaddsubps  %ymm2, %ymm1, %ymm0               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
      vmovups    %ymm0,(%rdi,%rax,sz)

      vmovsldup  0x20(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  0x20(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     0x20(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re    X  4
      vmulps     0x20(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im    X  4
      vpermilps  $0b10110001, %ymm2, %ymm2             // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
      vaddsubps  %ymm2, %ymm1, %ymm0
      vmovups    %ymm0,0x20(%rdi,%rax,sz)

      vmovsldup  0x40(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  0x40(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     0x40(%rsi,%rax,sz), %ymm1, %ymm1     // a.re*b.re , a.im*b.re
      vmulps     0x40(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilps  $0b10110001, %ymm2, %ymm2
      vaddsubps  %ymm2, %ymm1, %ymm0
      vmovups    %ymm0,0x40(%rdi,%rax,sz)

      vmovsldup  0x60(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  0x60(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     0x60(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulps     0x60(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilps  $0b10110001, %ymm2, %ymm2      //swap every two elements
      vaddsubps  %ymm2, %ymm1, %ymm0
      vmovups    %ymm0,0x60(%rdi,%rax,sz)

      //vaddsubps  %ymm2, %ymm1, %ymm0
      //vaddsubps  %ymm4, %ymm3, %ymm5                   // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im   X  4
      //vaddsubps  %ymm7, %ymm6, %ymm8
      //vaddsubps  %ymm10, %ymm9, %ymm11                 // a.re*b.re - a.im*b.im , a.Im*b.re + a.re*b.im

      add        stride, %rax
      //add        sz*stride, %rsi
      //add        sz*stride, %rdx
      //add        sz*stride, %rdi
      dec        %ecx
      jg         .LbulkLoop
.LskipBulk:
      mov        %r8d, %ecx
      and        stride/2-1, %ecx
      shr        shifter , %ecx
      jz         .LskipShort

.LremLoop:
      vmovsldup  (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  (%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     (%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulps     (%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilps  $0b10110001, %ymm2, %ymm2
      vaddsubps  %ymm2, %ymm1, %ymm0
      vmovups    %ymm0,(%rdi,%rax,sz)

      add        $2*rCnt , %rax    // element dimenzionz X elements per register
      //add        sz*rCnt, %rsi
      //add        sz*rCnt, %rdx
      //add        sz*rCnt, %rdi
      dec        %ecx
      jg         .LremLoop

.LskipShort:
      and        rCnt-1,  %r8d
      jz         .Ldone
      shl        $1, %r8d     // X2 (number of singles = elements x 2

.Lshort:
      vmovd      %r8d, %xmm0
      vpbroadcastd  %xmm0,   %ymm0
      vpcmpgtd   ymmD(%rip), %ymm0, %ymm3
      vmaskmovps (%rsi,%rax,sz), %ymm3, %ymm0
      vmovsldup  (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  (%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     %ymm0, %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulps     %ymm0, %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilps  $0b10110001, %ymm2, %ymm2
      vaddsubps  %ymm2, %ymm1, %ymm0
      vmaskmovps %ymm0, %ymm3, (%rdi,%rax,sz)

.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}

end;

{ multiply a vector of real singles by a complex vector of singles}
procedure bulkMul_cvs(const dst, re, b: PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=2;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov re, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      jz .LskipBulk
.LbulkLoop:
                      //
      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm0                  //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps    $0b01010000, %ymm0 , %ymm1                            //[1, 1, 2, 2, 3, 3, 4, 4]
      vmulps       (%rdx,%rax,sz), %ymm1, %ymm0
      vmovups      %ymm0, (%rdi,%rax,sz)

      vpermq       $0b01010000, 0x10(%rsi,%rax,sz/2), %ymm2
      vpermilps    $0b01010000, %ymm2 , %ymm3
      vmulps       0x20(%rdx,%rax,sz), %ymm3, %ymm2
      vmovups      %ymm2, 0x20(%rdi,%rax,sz)

      vpermq       $0b01010000, 0x20(%rsi,%rax,sz/2), %ymm4
      vpermilps    $0b01010000, %ymm4 , %ymm5
      vmulps       0x40(%rdx,%rax,sz), %ymm5, %ymm4
      vmovups      %ymm4, 0x40(%rdi,%rax,sz)

      vpermq       $0b01010000, 0x30(%rsi,%rax,sz/2), %ymm2
      vpermilps    $0b01010000, %ymm2 , %ymm3
      vmulps       0x60(%rdx,%rax,sz), %ymm3, %ymm2
      vmovups      %ymm2, 0x60(%rdi,%rax,sz)

      add          stride*2, %rax
      dec          %ecx
      jg           .LbulkLoop
.LskipBulk:
      mov        %r8d, %ecx
      and        stride-1, %ecx              // mod stride
      shr        shifter , %ecx              // div rCnt
      jz         .LskipShort

.LremLoop:

      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm0
      vpermilps    $0b01010000, %ymm0, %ymm1
//      vinsertf128  $1,  %xmm1, %ymm0, %ymm1
      vmulps       (%rdx,%rax,sz), %ymm1, %ymm1
      vmovups      %ymm1, (%rdi,%rax,sz)

      add          rCnt*2  , %rax
      dec          %ecx
      jg           .LremLoop

.LskipShort:
      and          rCnt-1,  %r8d
      jz           .Ldone
      shl          $1, %r8d     // X2 (number of singles = elements x 2

.Lshort:
      vmovd        %r8d, %xmm0
      vpbroadcastd %xmm0,   %ymm0
      vpcmpgtd     ymmD(%rip), %ymm0, %ymm3
      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm0
      vpermilps    $0b01010000, %ymm0, %ymm1
      vmulps       (%rdx,%rax,sz), %ymm1, %ymm1
      vmaskmovps   %ymm1, %ymm3, (%rdi,%rax,sz)

.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}

end;

{ multiply a vector of real singles by a complex vector of singles}
procedure bulkMul_cvd(const dst, re, b: PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=1;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov re, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      jz .LskipBulk
.LbulkLoop:
                      //
      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm1                  //[1, 1, 2, 2]
      vmulpd       (%rdx,%rax,sz), %ymm1, %ymm1
      vmovupd      %ymm1, (%rdi,%rax,sz)

      vpermq       $0b01010000, 0x10(%rsi,%rax,sz/2), %ymm2
      vmulpd       0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vmovupd      %ymm2, 0x20(%rdi,%rax,sz)

      vpermq       $0b01010000, 0x20(%rsi,%rax,sz/2), %ymm3
      vmulpd       0x40(%rdx,%rax,sz), %ymm3, %ymm3
      vmovupd      %ymm3, 0x40(%rdi,%rax,sz)

      vpermq       $0b01010000, 0x30(%rsi,%rax,sz/2), %ymm2
      vmulpd       0x60(%rdx,%rax,sz), %ymm2, %ymm2
      vmovupd      %ymm2, 0x60(%rdi,%rax,sz)

      add          stride*2, %rax
      dec          %ecx
      jg           .LbulkLoop
.LskipBulk:
      mov        %r8d, %ecx
      and        stride-1, %ecx              // mod stride
      shr        shifter , %ecx              // div rCnt
      jz         .LskipShort

.LremLoop:

      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm1
      vmulpd       (%rdx,%rax,sz), %ymm1, %ymm1
      vmovupd      %ymm1, (%rdi,%rax,sz)

      add          rCnt*2  , %rax
      dec          %ecx
      jg           .LremLoop

.LskipShort:
      and          rCnt-1,  %r8d
      jz           .Ldone
      shl          $1, %r8d     // X2 (number of singles = elements x 2

.Lshort:
      vmovd        %r8d, %xmm0
      vpbroadcastq %xmm0,   %ymm0
      vpcmpgtq     ymmQ(%rip), %ymm0, %ymm3
      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm1
      vmulpd       (%rdx,%rax,sz), %ymm1, %ymm1
      vmaskmovpd   %ymm1, %ymm3, (%rdi,%rax,sz)

.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}

end;

{ dot product of vector complex of singles by a vector complex of singles }
procedure bulkDot_ccs(const dst, a, b: PSingle; const Count: integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      vxorps %ymm0, %ymm0, %ymm0
      jz .LskipBulk
.LbulkLoop:

      vmovsldup  (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  (%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     (%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulps     (%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vpermilps  $0b10110001, %ymm2, %ymm2         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
      vaddsubps  %ymm2, %ymm1, %ymm1               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
      vaddps     %ymm1, %ymm0, %ymm0

      vmovsldup  0x20(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  0x20(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     0x20(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im    X  4
      vmulps     0x20(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re    X  4
      vpermilps  $0b10110001, %ymm2, %ymm2             // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
      vaddsubps  %ymm2, %ymm1, %ymm1
      vaddps     %ymm1, %ymm0, %ymm0

      vmovsldup  0x40(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  0x40(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     0x40(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulps     0x40(%rsi,%rax,sz), %ymm1, %ymm1     // a.re*b.re , a.im*b.re
      vpermilps  $0b10110001, %ymm2, %ymm2
      vaddsubps  %ymm2, %ymm1, %ymm1
      vaddps     %ymm1, %ymm0, %ymm0

      vmovsldup  0x60(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  0x60(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     0x60(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulps     0x60(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vpermilps  $0b10110001, %ymm2, %ymm2      //swap every two elements
      vaddsubps  %ymm2, %ymm1, %ymm1
      vaddps     %ymm1, %ymm0, %ymm0

      //vaddsubps  %ymm2, %ymm1, %ymm0
      //vaddsubps  %ymm4, %ymm3, %ymm5                   // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im   X  4
      //vaddsubps  %ymm7, %ymm6, %ymm8
      //vaddsubps  %ymm10, %ymm9, %ymm11                 // a.re*b.re - a.im*b.im , a.Im*b.re + a.re*b.im

      add        stride, %rax
      //add        sz*stride, %rsi
      //add        sz*stride, %rdx
      //add        sz*stride, %rdi
      dec        %ecx
      jg         .LbulkLoop
.LskipBulk:
      mov        %r8d, %ecx
      and        stride/2-1, %ecx
      shr        shifter , %ecx
      jz         .LskipShort

.LremLoop:
      vmovsldup  (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  (%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     (%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulps     (%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vpermilps  $0b10110001, %ymm2, %ymm2
      vaddsubps  %ymm2, %ymm1, %ymm1
      vaddps     %ymm1, %ymm0, %ymm0

      add        $2*rCnt , %rax    // element dimenzionz X elements per register
      //add        sz*rCnt, %rsi
      //add        sz*rCnt, %rdx
      //add        sz*rCnt, %rdi
      dec        %ecx
      jg         .LremLoop
.LskipShort:
      and        rCnt-1,  %r8d
      jz         .Ldone
      shl        $1, %r8d     // X2 (number of singles = elements x 2

.Lshort:
      vmovd      %r8d, %xmm1
      vpbroadcastd  %xmm1,   %ymm1
      vpcmpgtd   ymmD(%rip), %ymm1, %ymm3
      vmaskmovps (%rsi,%rax,sz), %ymm3, %ymm4
      vmaskmovps (%rdx,%rax,sz), %ymm3, %ymm1
      vmaskmovps (%rdx,%rax,sz), %ymm3, %ymm2
      vmovsldup  %ymm1, %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovshdup  %ymm2, %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulps     %ymm4, %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulps     %ymm4, %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vpermilps  $0b10110001, %ymm2, %ymm2
      vaddsubps  %ymm2, %ymm1, %ymm1
      vaddps     %ymm1, %ymm0, %ymm0

.Ldone:
      vextractf128 $1   , %ymm0, %xmm1
      addps        %xmm1, %xmm0
      movhlps      %xmm0, %xmm1
      addps        %xmm1, %xmm0
      vmovlps      %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
{$else}

{$endif}

end;

{ dot product of vector complex of double by a vector complex of double }
procedure bulkDot_ccd(const dst, a, b: PDouble; const Count: integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      vxorps %ymm0, %ymm0, %ymm0
      jz .LskipBulk
.LbulkLoop:

      vmovddup   (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup  8(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     (%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulpd     (%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vpermpd    $0b10110001, %ymm2, %ymm2         // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
      vaddsubpd  %ymm2, %ymm1, %ymm1               // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im
      vaddpd     %ymm1, %ymm0, %ymm0

      vmovddup   0x20(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   0x28(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     0x20(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im    X  4
      vmulpd     0x20(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re    X  4
      vpermpd    $0b10110001, %ymm2, %ymm2             // a.re*b.im , a.im*b.im => a.im*b.im , a.re*b.im   X  4
      vaddsubpd  %ymm2, %ymm1, %ymm1
      vaddpd     %ymm1, %ymm0, %ymm0

      vmovddup   0x40(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   0x48(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     0x40(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulpd     0x40(%rsi,%rax,sz), %ymm1, %ymm1     // a.re*b.re , a.im*b.re
      vpermpd    $0b10110001, %ymm2, %ymm2
      vaddsubpd  %ymm2, %ymm1, %ymm1
      vaddpd     %ymm1, %ymm0, %ymm0

      vmovddup   0x60(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   0x68(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     0x60(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulpd     0x60(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vpermpd    $0b10110001, %ymm2, %ymm2      //swap every two elements
      vaddsubpd  %ymm2, %ymm1, %ymm1
      vaddpd     %ymm1, %ymm0, %ymm0

      //vaddsubpd  %ymm2, %ymm1, %ymm0
      //vaddsubpd  %ymm4, %ymm3, %ymm5                   // a.re*b.re - a.im*b.im , a.im*b.re + a.re*b.im   X  4
      //vaddsubpd  %ymm7, %ymm6, %ymm8
      //vaddsubpd  %ymm10, %ymm9, %ymm11                 // a.re*b.re - a.im*b.im , a.Im*b.re + a.re*b.im

      add        stride, %rax
      //add        sz*stride, %rsi
      //add        sz*stride, %rdx
      //add        sz*stride, %rdi
      dec        %ecx
      jg         .LbulkLoop
.LskipBulk:
      mov        %r8d, %ecx
      and        stride/2-1, %ecx
      shr        shifter , %ecx
      jz         .LskipShort

.LremLoop:
      vmovddup   (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup  8(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     (%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulpd     (%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vpermpd    $0b10110001, %ymm2, %ymm2
      vaddsubpd  %ymm2, %ymm1, %ymm1
      vaddpd     %ymm1, %ymm0, %ymm0

      add        $2*rCnt , %rax    // element dimenzionz X elements per register
      //add        sz*rCnt, %rsi
      //add        sz*rCnt, %rdx
      //add        sz*rCnt, %rdi
      dec        %ecx
      jg         .LremLoop
.LskipShort:
      and        rCnt-1,  %r8d
      jz         .Ldone
      shl        $1, %r8d     // X2 (number of singles = elements x 2

.Lshort:
      vmovd      %r8d, %xmm1
      vpbroadcastq  %xmm1,   %ymm1
      vpcmpgtq   ymmQ(%rip), %ymm1, %ymm3
      vmaskmovpd (%rsi,%rax,sz), %ymm3, %ymm4
      vmaskmovpd (%rdx,%rax,sz), %ymm3, %ymm1
      vmaskmovpd 8(%rdx,%rax,sz), %ymm3, %ymm2
      vmovddup   %ymm1, %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   %ymm2, %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     %ymm4, %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vmulpd     %ymm4, %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vpermpd    $0b10110001, %ymm2, %ymm2
      vaddsubpd  %ymm2, %ymm1, %ymm1
      vaddpd     %ymm1, %ymm0, %ymm0

.Ldone:
      vextractf128 $1   , %ymm0, %xmm1
      addpd        %xmm1, %xmm0
      vmovups      %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
{$else}

{$endif}

end;

{ interleaved dot product of a vector of singles by a complex vector of singles
  [a,b,c,d, ....] . [a1,b1,c1,d1, ....] = [a*a1.re + a*a1.im , b*b1.re + b*b1.im , c*c1.re + c*c1.im , d*d1.re + d*d1.im. . . ...]
}
(*
{$asmmode intel}
procedure bulkDot_cvs(const dst,re,b:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,2+shifter
 vxorps ymm0,ymm0,ymm0
 je     @skipBulk
 vxorps ymm2,ymm2,ymm2
// vxorps ymm4,ymm4,ymm4
// vxorps ymm6,ymm6,ymm6

 @bulkLoop:
 vpermq ymm1,[rsi+rax*2],$50
 vpermilps ymm1,ymm1,$50
 vfmadd231ps ymm0,ymm1,[rdx+rax*4]

 vpermq ymm3,[rsi+rax*2+$10],$50
 vpermilps ymm3,ymm3,$50
 vfmadd231ps ymm2,ymm3,[rdx+rax*4+$20]

 vpermq ymm1,[rsi+rax*2+$20],$50
 vpermilps ymm1,ymm1,$50
 vfmadd231ps ymm0,ymm1,[rdx+rax*4+$40]

 vpermq ymm3,[rsi+rax*2+$30],$50
 vpermilps ymm3,ymm3,$50
 vfmadd231ps ymm2,ymm3,[rdx+rax*4+$60]

 add    rax,$20
 dec    ecx
 jg     @bulkLoop
 vaddps ymm0,ymm0,ymm2
// vaddps ymm4,ymm4,ymm6
// vaddps ymm0,ymm0,ymm4

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vpermq ymm1,[rsi+rax*2],$50
 vpermilps ymm1,ymm1,$50
 vfmadd231ps ymm0,ymm1,[rdx+rax*4]
 add    rax,$8
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$3
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm1,r8d
 vpbroadcastd ymm1,xmm1
 vpcmpgtd ymm3,ymm1,[rip+ymmD]
 vpermq ymm1,[rsi+rax*2],$50
 vpermilps ymm1,ymm1,$50
 vmaskmovps ymm2,ymm3,[rdx+rax*4]
 vfmadd231ps ymm0,ymm1,ymm2

 @done:
 vextractf128 xmm1,ymm0,$1
 addps  xmm0,xmm1
 movhlps xmm1,xmm0
 addps  xmm0,xmm1
 vmovlps QWORD PTR [rdi],xmm0
end;

{$asmmode att}
*)

procedure bulkDot_cvs(const dst,re,b:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=2;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov re, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vxorps       %ymm0, %ymm0, %ymm0
      jz .LskipBulk
      vxorps       %ymm2, %ymm2, %ymm2
      //vxorps       %ymm4, %ymm4, %ymm4
      //vxorps       %ymm6, %ymm6, %ymm6
.LbulkLoop:
                      //
      vpermq       $0b01010000,     (%rsi,%rax,sz/2), %ymm1                  //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps    $0b01010000, %ymm1 , %ymm1                            //[1, 1, 2, 2, 3, 3, 4, 4]
      //vmulps       (%rdx,%rax,sz), %ymm1, %ymm1
      //vaddps       %ymm1, %ymm0, %ymm0
      vfmadd231ps      (%rdx,%rax,sz), %ymm1, %ymm0

      vpermq       $0b01010000, 0x10(%rsi,%rax,sz/2), %ymm3
      vpermilps    $0b01010000, %ymm3 , %ymm3
      //vmulps       0x20(%rdx,%rax,sz), %ymm3, %ymm3
      //vaddps       %ymm3, %ymm2, %ymm2
      vfmadd231ps  0x20(%rdx,%rax,sz), %ymm3, %ymm2

      vpermq       $0b01010000, 0x20(%rsi,%rax,sz/2), %ymm1                  //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps    $0b01010000, %ymm1 , %ymm1                            //[1, 1, 2, 2, 3, 3, 4, 4]
      //vmulps       0x20(%rdx,%rax,sz), %ymm1, %ymm1
      //vaddps       %ymm1, %ymm0, %ymm0
      vfmadd231ps  0x40(%rdx,%rax,sz), %ymm1, %ymm0

      vpermq       $0b01010000, 0x30(%rsi,%rax,sz/2), %ymm3
      vpermilps    $0b01010000, %ymm3 , %ymm3
      //vmulps       0x60(%rdx,%rax,sz), %ymm3, %ymm3
      //vaddps       %ymm3, %ymm2, %ymm2
      vfmadd231ps  0x60(%rdx,%rax,sz) , %ymm3, %ymm2

      add          stride*2, %rax
      dec          %ecx
      jg           .LbulkLoop

      vaddps       %ymm2, %ymm0, %ymm0
      //vaddps       %ymm6, %ymm4, %ymm4
      //vaddps       %ymm4, %ymm0, %ymm0

.LskipBulk:
      mov        %r8d, %ecx
      and        stride-1, %ecx              // mod stride
      shr        shifter , %ecx              // div rCnt
      jz         .LskipShort

.LremLoop:

      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm1
      vpermilps    $0b01010000, %ymm1, %ymm1
      //vmulps       (%rdx,%rax,sz), %ymm1, %ymm1
      //vaddps       %ymm1, %ymm0, %ymm0
      vfmadd231ps  (%rdx,%rax,sz), %ymm1, %ymm0

      add          rCnt*2  , %rax
      dec          %ecx
      jg           .LremLoop

.LskipShort:
      and          rCnt-1,  %r8d
      jz           .Ldone
      shl          $1, %r8d     // X2 (number of singles = elements x 2

.Lshort:

      vmovd        %r8d, %xmm1
      vpbroadcastd %xmm1,   %ymm1
      vpcmpgtd     ymmD(%rip), %ymm1, %ymm3
      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm1
      vpermilps    $0b01010000, %ymm1, %ymm1
      vmaskmovps   (%rdx,%rax,sz), %ymm3, %ymm2
      //vmulps       %ymm2, %ymm1, %ymm1
      //vaddps       %ymm1, %ymm0, %ymm0
      vfmadd231ps  %ymm2, %ymm1, %ymm0

.Ldone:
      vextractf128 $1   , %ymm0, %xmm1
      addps        %xmm1, %xmm0
      movhlps      %xmm0, %xmm1
      addps        %xmm1, %xmm0
      vmovlps      %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
{$else}

{$endif}

end;

procedure bulkDot_cvd(const dst,re,b:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=1;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov re, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      vxorpd       %ymm0, %ymm0, %ymm0
      jz .LskipBulk
      vxorpd       %ymm2, %ymm2, %ymm2
      //vxorpd       %ymm4, %ymm4, %ymm4
      //vxorpd       %ymm6, %ymm6, %ymm6
.LbulkLoop:
                      //
      vpermq       $0b01010000,     (%rsi,%rax,sz/2), %ymm1                  //[1, 1, 2, 2]
      //vmulpd       (%rdx,%rax,sz), %ymm1, %ymm1
      //vaddpd       %ymm1, %ymm0, %ymm0
      vfmadd231pd      (%rdx,%rax,sz), %ymm1, %ymm0

      vpermq       $0b01010000, 0x10(%rsi,%rax,sz/2), %ymm3
      //vmulpd       0x20(%rdx,%rax,sz), %ymm3, %ymm3
      //vaddpd       %ymm3, %ymm2, %ymm2
      vfmadd231pd  0x20(%rdx,%rax,sz), %ymm3, %ymm2

      vpermq       $0b01010000, 0x20(%rsi,%rax,sz/2), %ymm1                  //[1, 1, 2, 2]
      //vmulpd       0x40(%rdx,%rax,sz), %ymm1, %ymm1
      //vaddpd       %ymm1, %ymm0, %ymm0
      vfmadd231pd  0x40(%rdx,%rax,sz), %ymm1, %ymm0

      vpermq       $0b01010000, 0x30(%rsi,%rax,sz/2), %ymm3
      //vmulpd       0x20(%rdx,%rax,sz), %ymm3, %ymm3
      //vaddpd       %ymm3, %ymm2, %ymm2
      vfmadd231pd  0x60(%rdx,%rax,sz), %ymm3, %ymm2

      add          stride*2, %rax
      dec          %ecx
      jg           .LbulkLoop

      vaddpd       %ymm2,  %ymm0, %ymm0
      //vaddpd       %ymm6,  %ymm4, %ymm4
      //vaddpd       %ymm4,  %ymm0, %ymm0


.LskipBulk:
      mov        %r8d, %ecx
      and        stride-1, %ecx              // mod stride
      shr        shifter , %ecx              // div rCnt
      jz         .LskipShort

.LremLoop:

      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm1
      //vmulpd       (%rdx,%rax,sz), %ymm1, %ymm1
      //vaddpd       %ymm1, %ymm0, %ymm0
      vfmadd231pd  (%rdx,%rax,sz), %ymm1, %ymm0

      add          rCnt*2  , %rax
      dec          %ecx
      jg           .LremLoop

.LskipShort:
      and          rCnt-1,  %r8d
      jz           .Ldone
      shl          $1, %r8d     // X2 (number of singles = elements x 2

.Lshort:

      vmovd        %r8d, %xmm1
      vpbroadcastq %xmm1,   %ymm1
      vpcmpgtq     ymmQ(%rip), %ymm1, %ymm3
      vpermq       $0b01010000, (%rsi,%rax,sz/2), %ymm1
      vmaskmovpd   (%rdx,%rax,sz), %ymm3, %ymm2
      //vmulps       %ymm2, %ymm1, %ymm1
      //vaddps       %ymm1, %ymm0, %ymm0
      vfmadd231pd  %ymm2, %ymm1, %ymm0

.Ldone:
      vextractf128 $1   , %ymm0, %xmm1
      addpd        %xmm1, %xmm0
      vmovupd      %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
{$else}

{$endif}

end;

procedure bulkAdd_ccs(const dst, a, b: PSingle; const Count: integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
//stack frame (rbp offset) bp-8 |bp-16|bp-24|bp-32|bp-40
//                         ________________________________________
//   linux param order is | %rdi, %rsi, %rdx, %rcx,  %r8,       %r9                 //function results: %rax
// windows param order is | %rcx, %rdx, %r8 , %r9d,  %rbp+0x30

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov a, %rsi
       mov dst, %rdi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      shl $1, %ecx
      mov %ecx  ,   %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
//      cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmovups         (%rsi,%rax,sz), %ymm0
      vmovups     0x20(%rsi,%rax,sz), %ymm1
      vmovups   2*0x20(%rsi,%rax,sz), %ymm2
      vmovups   3*0x20(%rsi,%rax,sz), %ymm3

      vaddps          (%rdx,%rax,sz), %ymm0, %ymm0
      vaddps      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vaddps    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vaddps    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovups   %ymm0,  (%rdi,%rax,sz)
      vmovups   %ymm1,  0x20(%rdi,%rax,sz)
      vmovups   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovups   %ymm3,  3*0x20(%rdi,%rax,sz)

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovups   (%rsi,%rax,sz), %ymm0
      vaddps    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm0
      vpbroadcastd %xmm0,%ymm0
      vpcmpgtd ymmD(%rip), %ymm0, %ymm1
      vmaskmovps (%rsi,%rax,sz), %ymm1, %ymm0
      vaddps     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovps  %ymm0, %ymm1, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;


procedure bulkAdd_ccd(const dst, a, b: PDouble; const Count: integer);  nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi                  //linux param order is   : %rsi, %rdx, %rdi, %rcx, %r8                 //function results: %rax
       mov b, %rdx                 //windows param order id : %rcx, %rdi, %r8 , %r9d, %rbp+0x30 (+48)
       mov Count,  %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      shl $1, %ecx
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmovupd         (%rsi,%rax,sz), %ymm0
      vmovupd     0x20(%rsi,%rax,sz), %ymm1
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm2
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm3

      vaddpd          (%rdx,%rax,sz), %ymm0, %ymm0
      vaddpd      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vaddpd    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vaddpd    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovupd   %ymm0,        (%rdi,%rax,sz)
      vmovupd   %ymm1,    0x20(%rdi,%rax,sz)
      vmovupd   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm3,  3*0x20(%rdi,%rax,sz)

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %ecx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd   (%rsi,%rax,sz), %ymm0
      vaddpd    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d       //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd %r8d , %xmm0
      vpbroadcastq %xmm0,%ymm0
      vpcmpgtq ymmQ(%rip), %ymm0, %ymm1
      vmaskmovpd (%rsi,%rax,sz), %ymm1, %ymm0
      vaddpd     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovpd  %ymm0, %ymm1, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkSub_ccs(const dst, a, b: PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      shl $1, %ecx   //complex numbers must multiply by 2
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
  .LbulkLoop:
      vmovups       (%rsi,%rax,sz), %ymm0
      vsubps        (%rdx,%rax,sz), %ymm0, %ymm0        // a-b
      vmovups   %ymm0,  (%rdi,%rax,sz)
      vmovups   0x20(%rsi,%rax,sz), %ymm0
      vsubps    0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  0x20(%rdi,%rax,sz)
      vmovups   2*0x20(%rsi,%rax,sz), %ymm0
      vsubps    2*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  2*0x20(%rdi,%rax,sz)
      vmovups   3*0x20(%rsi,%rax,sz), %ymm0
      vsubps    3*0x20(%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0,  3*0x20(%rdi,%rax,sz)
      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
  .LskipBulk:

      mov %r8d  , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vmovups   (%rsi,%rax,sz), %ymm0
      vsubps    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovups   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jle .Ldone

      vmovd %r8d , %xmm0
      vpbroadcastd %xmm0,%ymm0
      vpcmpgtd ymmD(%rip), %ymm0, %ymm1
      vmaskmovps (%rsi,%rax,sz), %ymm1, %ymm0
      vsubps     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovps  %ymm0, %ymm1, (%rdi,%rax,sz)

  //.LlastLoop:
  //    vmovss (%rsi,%rax,sz), %xmm0
  //    addss (%rdx,%rax,sz), %xmm0
  //    vmovss %xmm0, (%rsi,%rax,sz)
  //    inc %rax
  //    dec %ecx
  //    jnz .LlastLoop
      //loop .Llastloop
  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;


procedure bulkSub_ccd(const dst, a, b: PDouble; const Count: integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      shl $1, %ecx
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      vmovupd         (%rsi,%rax,sz), %ymm0
      vmovupd     0x20(%rsi,%rax,sz), %ymm1
      vmovupd   2*0x20(%rsi,%rax,sz), %ymm2
      vmovupd   3*0x20(%rsi,%rax,sz), %ymm3

      vsubpd          (%rdx,%rax,sz), %ymm0, %ymm0
      vsubpd      0x20(%rdx,%rax,sz), %ymm1, %ymm1
      vsubpd    2*0x20(%rdx,%rax,sz), %ymm2, %ymm2
      vsubpd    3*0x20(%rdx,%rax,sz), %ymm3, %ymm3

      vmovupd   %ymm0,  (%rdi,%rax,sz)
      vmovupd   %ymm1,  0x20(%rdi,%rax,sz)
      vmovupd   %ymm2,  2*0x20(%rdi,%rax,sz)
      vmovupd   %ymm3,  3*0x20(%rdi,%rax,sz)

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r8d   , %ecx
      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %ecx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      vmovupd   (%rsi,%rax,sz), %ymm0
      vsubpd    (%rdx,%rax,sz), %ymm0, %ymm0
      vmovupd   %ymm0, (%rdi,%rax,sz)
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r8d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd %r8d  , %xmm0
      vpbroadcastq %xmm0,%ymm0
      vpcmpgtq ymmQ(%rip), %ymm0, %ymm1
      vmaskmovpd (%rsi,%rax,sz), %ymm1, %ymm0
      vsubpd     (%rdx,%rax,sz), %ymm0, %ymm0
      vmaskmovpd  %ymm0, %ymm1, (%rdi,%rax,sz)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}                                                  //
end;

{ multiply a complex vector  of doubles by a complex vector of doubles }
procedure bulkMul_ccd(const dst, a, b: PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      mov %ecx  , %r8d
      shr shifter+2 , %ecx  // C div 8 ;  8 is the (2= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk
.LbulkLoop:

      vmovddup   (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup  8(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     (%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulpd     (%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilpd  $0b0101, %ymm2, %ymm2
      vaddsubpd  %ymm2, %ymm1, %ymm0
      vmovupd    %ymm0,(%rdi,%rax,sz)

      vmovddup   0x20(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   0x28(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     0x20(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulpd     0x20(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilpd  $0b0101, %ymm2, %ymm2
      vaddsubpd  %ymm2, %ymm1, %ymm0
      vmovupd    %ymm0, 0x20(%rdi,%rax,sz)

      vmovddup   0x40(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   0x48(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     0x40(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulpd     0x40(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilpd  $0b0101, %ymm2, %ymm2
      vaddsubpd  %ymm2, %ymm1, %ymm0
      vmovupd    %ymm0, 0x40(%rdi,%rax,sz)

      vmovddup   0x60(%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   0x68(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     0x60(%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulpd     0x60(%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilpd  $0b0101, %ymm2, %ymm2      //swap every two elements
      vaddsubpd  %ymm2, %ymm1, %ymm0         // a.re*b.re - a.im*b.im , a.Im*b.re + a.re*b.im
      vmovupd    %ymm0, 0x60(%rdi,%rax,sz)

      add        stride, %rax
      //add        sz*stride, %rsi
      //add        sz*stride, %rdx
      //add        sz*stride, %rdi
      dec        %ecx
      jg         .LbulkLoop
.LskipBulk:
      mov        %r8d, %ecx
      and        stride/2-1, %ecx
      shr        shifter , %ecx
      jz         .LskipShort

.LremLoop:
      vmovddup   (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   8(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     (%rsi,%rax,sz), %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulpd     (%rsi,%rax,sz), %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilpd  $0b0101, %ymm2, %ymm2
      vaddsubpd  %ymm2, %ymm1, %ymm0
      vmovupd    %ymm0,(%rdi,%rax,sz)

      add        $2*rCnt , %rax    // element dimension X elements per register
      //add        sz*rCnt, %rsi
      //add        sz*rCnt, %rdx
      //add        sz*rCnt, %rdi
      dec        %ecx
      jg         .LremLoop

.LskipShort:
      and        rCnt-1,  %r8d
      jz         .Ldone
      shl        $1, %r8d     // X2 (number of doubles = elements x 2

.Lshort:
      vmovd      %r8d, %xmm0
      vpbroadcastq  %xmm0,   %ymm0
      vpcmpgtq   ymmQ(%rip), %ymm0, %ymm3
      vmaskmovpd (%rsi,%rax,sz), %ymm3, %ymm0
      vmovddup   (%rdx,%rax,sz), %ymm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
      vmovddup   8(%rdx,%rax,sz), %ymm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
      vmulpd     %ymm0, %ymm1, %ymm1      // a.re*b.re , a.im*b.re
      vmulpd     %ymm0, %ymm2, %ymm2      // a.re*b.im , a.im*b.im
      vpermilpd  $0b0101, %ymm2, %ymm2
      vaddsubpd  %ymm2, %ymm1, %ymm0
      vmaskmovpd %ymm0, %ymm3, (%rdi,%rax,sz)

.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
      //pop %rax
{$else}

{$endif}

end;


(*
denom := b.re*b.re + b.im*b.im;
r:=(a.re*b.re + a.im*b.im)/denom;
a.im:=(a.im*b.re - a.re*b.im)/denom;
a.re:=r;

//if a.re<0 then r:=-a.re else r:=a.re;
//if a.im<0 then i:=-a.im else i:=a.im;
//
//if ( r > i ) then begin
//        tmp := a.im / a.re;
//        denom := a.re + a.im * tmp;
//        self.re := (self.re + self.im * tmp) / denom;
//        self.im := (self.im - self.re * tmp) / denom;
//end else begin
//        tmp := a.re / a.im;
//        denom := a.im + a.re * tmp;
//        self.re := (self.im + self.re * tmp) / denom;
//        self.im := (self.im * tmp - self.re) / denom;
//end;
*)
{.$asmmode intel}
procedure bulkDiv_ccs(const dst, a, b: PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re

{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor            %rax              ,  %rax
      mov            %ecx             ,  %r8d
      shr            shifter+2         ,  %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp            $0                ,  %ecx
      jz .LskipBulk
.LbulkLoop:     {$define myAlgorithm}
{$ifdef myAlgorithm}
      vmovsldup      (%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovshdup      (%rsi,%rax,sz)    ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      (%rdx,%rax,sz)    ,  %ymm2            //b.re                  ,             b.re
      vmovshdup      (%rdx,%rax,sz)    ,  %ymm3            //b.im                  ,             b.im
      vmulps         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231ps    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulps         (%rdx,%rax,sz)    ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulps         (%rdx,%rax,sz)    ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubps      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivps         %ymm2             ,  %ymm5,   %ymm0
      vmovups        %ymm0             ,  (%rdi,%rax,sz)

      vmovsldup      0x20(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovshdup      0x20(%rsi,%rax,sz),  %ymm1            //a.im                  ,             a.im
      vmovsldup      0x20(%rdx,%rax,sz),  %ymm2            //b.re                  ,             b.re
      vmovshdup      0x20(%rdx,%rax,sz),  %ymm3            //b.im                  ,             b.im
      vmulps         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231ps    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulps         0x20(%rdx,%rax,sz),  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulps         0x20(%rdx,%rax,sz),  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubps      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivps         %ymm2             ,  %ymm5,   %ymm0
      vmovups        %ymm0             ,  0x20(%rdi,%rax,sz)

      vmovsldup      0x40(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovshdup      0x40(%rsi,%rax,sz),  %ymm1            //a.im                  ,             a.im
      vmovsldup      0x40(%rdx,%rax,sz),  %ymm2            //b.re                  ,             b.re
      vmovshdup      0x40(%rdx,%rax,sz),  %ymm3            //b.im                  ,             b.im
      vmulps         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231ps    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulps         0x40(%rdx,%rax,sz),  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulps         0x40(%rdx,%rax,sz),  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubps      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivps         %ymm2             ,  %ymm5,   %ymm0
      vmovups        %ymm0             ,  0x40(%rdi,%rax,sz)

      vmovsldup      0x60(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovshdup      0x60(%rsi,%rax,sz),  %ymm1            //a.im                  ,             a.im
      vmovsldup      0x60(%rdx,%rax,sz),  %ymm2            //b.re                  ,             b.re
      vmovshdup      0x60(%rdx,%rax,sz),  %ymm3            //b.im                  ,             b.im
      vmulps         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231ps    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulps         0x60(%rdx,%rax,sz),  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulps         0x60(%rdx,%rax,sz),  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubps      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivps         %ymm2             ,  %ymm5,   %ymm0
      vmovups        %ymm0             ,  0x60(%rdi,%rax,sz)

{$else}

      vmovups        (%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovups        (%rdx,%rax,sz)    ,  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  (%rdi,%rax,sz)

      vmovups        0x20(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovups        0x20(%rdx,%rax,sz),  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  0x20(%rdi,%rax,sz)

      vmovups        0x40(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovups        0x40(%rdx,%rax,sz),  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  0x40(%rdi,%rax,sz)

      vmovups        0x60(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovups        0x60(%rdx,%rax,sz),  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  0x60(%rdi,%rax,sz)
{$endif}

      add            stride            ,  %rax
      //add            sz*stride         , %rsi
      //add            sz*stride         , %rdx
      //add            sz*stride         , %rdi
      dec            %ecx
      jg             .LbulkLoop
.LskipBulk:
      mov            %r8d              , %ecx
      and            stride/2-1        , %ecx
      shr            shifter           , %ecx
      jz             .LskipShort

.LremLoop:
{$ifdef myAlgorithm}
      vmovsldup      (%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovshdup      (%rsi,%rax,sz)    ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      (%rdx,%rax,sz)    ,  %ymm2            //b.re                  ,             b.re
      vmovshdup      (%rdx,%rax,sz)    ,  %ymm3            //b.im                  ,             b.im
      vmulps         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231ps    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulps         (%rdx,%rax,sz)    ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulps         (%rdx,%rax,sz)    ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubps      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilps      $0b10110001       ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivps         %ymm2             ,  %ymm5,   %ymm0
      vmovups        %ymm0             ,  (%rdi,%rax,sz)
{$else}
      vmovups        (%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovups        (%rdx,%rax,sz)    ,  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  (%rdi,%rax,sz)

{$endif}

      add            $2*rCnt , %rax    // element dimenzionz X elements per register
      //add            sz*rCnt, %rsi
      //add            sz*rCnt, %rdx
      //add            sz*rCnt, %rdi
      dec            %ecx
      jg             .LremLoop

.LskipShort:
      and            rCnt-1,  %r8d
      jz             .Ldone
      shl            $1, %r8d     // X2 (complex number of singles = elements x 2

.Lshort:
      {$ifdef windows}
      sub            $0x10         ,  %rsp
      vmovdqu        %xmm6         ,  (%rsp)
      {$endif}
      vmovd          %r8d          ,  %xmm0
      vpbroadcastd   %xmm0         ,  %ymm0
      vpcmpgtd       ymmD(%rip)    ,  %ymm0,   %ymm6
      vcvtdq2ps      %ymm0         ,  %ymm0
      {$ifdef myAlgorithm}
      vblendvps      %ymm6         ,  (%rsi,%rax,sz),  %ymm0,   %ymm4
      vblendvps      %ymm6         ,  (%rdx,%rax,sz),  %ymm0,   %ymm5
      vmovsldup      %ymm4         ,  %ymm0            //a.re                  ,             a.re
      vmovshdup      %ymm4         ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm5         ,  %ymm2            //b.re                  ,             b.re
      vmovshdup      %ymm5         ,  %ymm3            //b.im                  ,             b.im
      vmulps         %ymm2         ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231ps    %ymm3         ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulps         %ymm5         ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulps         %ymm5         ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilps      $0b10110001   ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubps      %ymm5         ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilps      $0b10110001   ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivps         %ymm2         ,  %ymm5,   %ymm1
      vmaskmovps     %ymm1         ,  %ymm6,   (%rdi,%rax,sz)
      {$ifdef windows}
      vmovdqu        (%rsp)        ,  %xmm6
      add            $0x10         ,  %rsp
      {$endif}
      {$else}
      vmaskmovps     (%rsi,%rax,sz),  %ymm7,   %ymm0   //a.re                  ,             a.re
      vmaskmovps     (%rdx,%rax,sz),  %ymm7,   %ymm4   //b.re                  ,             b.im
      vmovshdup      %ymm0         ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0         ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4         ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001   ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4         ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4         ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1         ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000   ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5         ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmaskmovps     %ymm0         ,  %ymm7,   (%rdi,%rax,sz)
      {$endif}
.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}

end;

procedure bulkDiv_ccd(const dst, a, b: PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4;{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)}
const shifter=1;// log2(rCnt)
asm
// dst.re = a.re*b.re - a.im*b.im
// dst.im = a.re*b.im + a.im*b.re
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      xor            %rax              ,  %rax
      mov            %ecx              ,  %r8d
      shr            shifter+2         ,  %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp            $0                ,  %ecx
      jz .LskipBulk
.LbulkLoop:     {$define myAlgorithm}
{$ifdef myAlgorithm}
      vmovddup       (%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovddup      8(%rsi,%rax,sz)    ,  %ymm1            //a.im                  ,             a.im
      vmovddup       (%rdx,%rax,sz)    ,  %ymm2            //b.re                  ,             b.re
      vmovddup      8(%rdx,%rax,sz)    ,  %ymm3            //b.im                  ,             b.im
      vmulpd         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231pd    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulpd         (%rdx,%rax,sz)    ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulpd         (%rdx,%rax,sz)    ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubpd      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivpd         %ymm2             ,  %ymm5,   %ymm0
      vmovupd        %ymm0             ,  (%rdi,%rax,sz)

      vmovddup   0x20(%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovddup   0x28(%rsi,%rax,sz)    ,  %ymm1            //a.im                  ,             a.im
      vmovddup   0x20(%rdx,%rax,sz)    ,  %ymm2            //b.re                  ,             b.re
      vmovddup   0x28(%rdx,%rax,sz)    ,  %ymm3            //b.im                  ,             b.im
      vmulpd         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231pd    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulpd     0x20(%rdx,%rax,sz)    ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulpd     0x20(%rdx,%rax,sz)    ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubpd      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivpd         %ymm2             ,  %ymm5,   %ymm0
      vmovupd        %ymm0             ,  0x20(%rdi,%rax,sz)

      vmovddup   0x40(%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovddup   0x48(%rsi,%rax,sz)    ,  %ymm1            //a.im                  ,             a.im
      vmovddup   0x40(%rdx,%rax,sz)    ,  %ymm2            //b.re                  ,             b.re
      vmovddup   0x48(%rdx,%rax,sz)    ,  %ymm3            //b.im                  ,             b.im
      vmulpd         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231pd    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulpd     0x40(%rdx,%rax,sz)    ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulpd     0x40(%rdx,%rax,sz)    ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubpd      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivpd         %ymm2             ,  %ymm5,   %ymm0
      vmovupd        %ymm0             ,  0x40(%rdi,%rax,sz)

      vmovddup   0x60(%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovddup   0x68(%rsi,%rax,sz)    ,  %ymm1            //a.im                  ,             a.im
      vmovddup   0x60(%rdx,%rax,sz)    ,  %ymm2            //b.re                  ,             b.re
      vmovddup   0x68(%rdx,%rax,sz)    ,  %ymm3            //b.im                  ,             b.im
      vmulpd         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231pd    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulpd     0x60(%rdx,%rax,sz)    ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulpd     0x60(%rdx,%rax,sz)    ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubpd      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivpd         %ymm2             ,  %ymm5,   %ymm0
      vmovupd        %ymm0             ,  0x60(%rdi,%rax,sz)

{$else}

      vmovups        (%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovups        (%rdx,%rax,sz)    ,  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  (%rdi,%rax,sz)

      vmovups        0x20(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovups        0x20(%rdx,%rax,sz),  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  0x20(%rdi,%rax,sz)

      vmovups        0x40(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovups        0x40(%rdx,%rax,sz),  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  0x40(%rdi,%rax,sz)

      vmovups        0x60(%rsi,%rax,sz),  %ymm0            //a.re                  ,             a.re
      vmovups        0x60(%rdx,%rax,sz),  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  0x60(%rdi,%rax,sz)
{$endif}

      add            stride            ,  %rax
      //add            sz*stride         , %rsi
      //add            sz*stride         , %rdx
      //add            sz*stride         , %rdi
      dec            %ecx
      jg             .LbulkLoop
.LskipBulk:
      mov            %r8d              , %ecx
      and            stride/2-1        , %ecx
      shr            shifter           , %ecx
      jz             .LskipShort

.LremLoop:
{$ifdef myAlgorithm}
      vmovddup       (%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovddup      8(%rsi,%rax,sz)    ,  %ymm1            //a.im                  ,             a.im
      vmovddup       (%rdx,%rax,sz)    ,  %ymm2            //b.re                  ,             b.re
      vmovddup      8(%rdx,%rax,sz)    ,  %ymm3            //b.im                  ,             b.im
      vmulpd         %ymm2             ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231pd    %ymm3             ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulpd         (%rdx,%rax,sz)    ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulpd         (%rdx,%rax,sz)    ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubpd      %ymm5             ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilpd      $0b0101           ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivpd         %ymm2             ,  %ymm5,   %ymm0
      vmovupd        %ymm0             ,  (%rdi,%rax,sz)
{$else}
      vmovups        (%rsi,%rax,sz)    ,  %ymm0            //a.re                  ,             a.re
      vmovups        (%rdx,%rax,sz)    ,  %ymm4            //b.re                  ,             b.im
      vmovshdup      %ymm0             ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0             ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4             ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001       ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4             ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4             ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1             ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000       ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5             ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmovups        %ymm0             ,  (%rdi,%rax,sz)

{$endif}

      add            $2*rCnt , %rax    // element dimenzionz X elements per register
      //add            sz*rCnt, %rsi
      //add            sz*rCnt, %rdx
      //add            sz*rCnt, %rdi
      dec            %ecx
      jg             .LremLoop

.LskipShort:
      and            rCnt-1,  %r8d
      jz             .Ldone
      shl            $1, %r8d     // X2 (complex number of singles = elements x 2

.Lshort:
      {$ifdef windows}
      sub            $0x10         ,  %rsp
      vmovdqu        %xmm6         ,  (%rsp)
      {$endif}
      vmovd          %r8d          ,  %xmm0
      vpbroadcastq   %xmm0         ,  %ymm0
      vpcmpgtq       ymmQ(%rip)    ,  %ymm0,   %ymm6
      vpcmpeqq       %ymm0         ,  %ymm0,   %ymm0
      {$ifdef myAlgorithm}
      vblendvpd      %ymm6         ,  (%rsi,%rax,sz),  %ymm0,   %ymm4
      vblendvpd      %ymm6         ,  (%rdx,%rax,sz),  %ymm0,   %ymm5
      vmovddup       %ymm4         ,  %ymm0            //a.re                  ,             a.re
      vpermilpd      $0b1111       ,  %ymm4         ,  %ymm1            //a.im                  ,             a.im
      vmovddup       %ymm5         ,  %ymm2            //b.re                  ,             b.re
      vpermilpd        $0b1111       ,  %ymm5         ,  %ymm3            //b.im                  ,             b.im
      vmulpd         %ymm2         ,  %ymm2,   %ymm2   //b.re^2                ,             b.re^2
      vfmadd231pd    %ymm3         ,  %ymm3,   %ymm2   //b.im^2 + b.re^2       , b.im^2 + b.re^2
      vmulpd         %ymm5         ,  %ymm1,   %ymm4   //b.re*a.im             ,             b.im*a.im
      vmulpd         %ymm5         ,  %ymm0,   %ymm5   //b.re*a.re             ,             b.im*a.re
      vpermilpd      $0b0101       ,  %ymm5,   %ymm5   //b.im*a.re             ,             b.re*a.re
      vaddsubpd      %ymm5         ,  %ymm4,   %ymm5   //b.re*a.im - b.im*a.re , b.im*a.im + b.re*a.re
      vpermilpd      $0b0101       ,  %ymm5,   %ymm5   //b.im*a.im + b.re*a.re , b.re*a.im - b.im*a.re
      vdivpd         %ymm2         ,  %ymm5,   %ymm1
      vmaskmovpd     %ymm1         ,  %ymm6,   (%rdi,%rax,sz)
      {$ifdef windows}
      vmovdqu        (%rsp)        ,  %xmm6
      add            $0x10         ,  %rsp
      {$endif}
      {$else}
      vmaskmovps     (%rsi,%rax,sz),  %ymm7,   %ymm0   //a.re                  ,             a.re
      vmaskmovps     (%rdx,%rax,sz),  %ymm7,   %ymm4   //b.re                  ,             b.im
      vmovshdup      %ymm0         ,  %ymm1            //a.im                  ,             a.im
      vmovsldup      %ymm0         ,  %ymm0            //a.re                  ,             a.re
      vmulps         %ymm4         ,  %ymm0,   %ymm3   //b.re * a.re           ,      b.im * a.re
      vpermilps      $0b10110001   ,  %ymm4,   %ymm2   //b.im                  ,             b.re
      vmulps         %ymm4         ,  %ymm4,   %ymm4   //b.re^2                ,             b.im^2
      vhaddps        %ymm4         ,  %ymm4,   %ymm5   //b.re^2 + b.im^2       ,
      vfmsubadd231ps %ymm1         ,  %ymm2,   %ymm3   //a.im*b.im + b.re*a.re , a.im*b.re - b.im*a.re
      vpermilps      $0b11011000   ,  %ymm5,   %ymm5   //b.re^2 + b.im^2       , b.re^2 + b.im^2
      vdivps         %ymm5         ,  %ymm3,   %ymm0   //a.im*b.im + b.re*a.re/mag2 , a.im*b.re - b.im*a.re/mag2
      vmaskmovps     %ymm0         ,  %ymm7,   (%rdi,%rax,sz)
      {$endif}
.Ldone:
{$ifdef windows}
  pop %rdi
  pop %rsi
{$endif}
{$else}

{$endif}

end;

(*
procedure bulkGemm_s(const dst,a,b:PSingle;const lda,ldb,ldc:integer);{$ifndef windows} nf;{$endif}
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register ) = (ymm register size in byte) / element size in byte "number unit size"[sizeof] }
const stride=rCnt*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
  {$ifdef windows}
     push %rsi
     push %rdi
     mov dst, %rdi
     mov a, %rsi
     mov b, %rdx
     mov lda, %ecx     // columns of a (also columns of b)
     mov ldb , %r8d    // rows of a (also rows of c)
     mov ldc , %r9b    // rows of b (also columns of c)
  {$endif}
.L1:
     xor      %r10, %r10
     xor      %rax, %rax
     vmovups  (%rdx,%r10,sz), %ymm0
.L2:
     vmulps   (%rsi,%rax,sz), %ymm0, %ymm1
     vmovups  %ymm1,  (%rdi,%rax,sz)
     addq     %rcx, %rax       // inc (rax,lda)
     cmp      %rax, %r8        // rax < ldb?
     jl       .L2



  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
{$endif}
end;

procedure bulkGemm_d(const dst,a,b:PDouble;const lda,ldb,ldc:integer);{$ifndef windows} nf;{$endif}
asm

end;
*)
procedure bulkConv_s(const dst,a,f:PSingle;const Count,K{Kernel Size}:Integer;const add:boolean); {$ifndef windows} nf;{$endif}
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;  // log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov f, %rdx
       mov Count, %ecx
       mov K , %r8d
       mov add , %r9b
    {$endif}
      //push %rax
      //xor %rax,%rax
      sub %r8, %rcx
      inc %rcx
      mov %ecx  , %r10d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      mov                   %r8, %rax   // reset to filter size
      vxorps                %ymm0, %ymm0, %ymm0  // reset sum
      vxorps                %ymm2, %ymm2, %ymm2  // reset sum
      vxorps                %ymm3, %ymm3, %ymm3  // reset sum
      vxorps                %ymm4, %ymm4, %ymm4  // reset sum
  .LkernelLoop:
      dec                   %rax
      vbroadcastss          (%rdx,%rax,sz), %ymm1
      vfmadd231ps               (%rsi,%rax,sz), %ymm1, %ymm0
      vfmadd231ps           0x20(%rsi,%rax,sz), %ymm1, %ymm2
      vfmadd231ps           0x40(%rsi,%rax,sz), %ymm1, %ymm3
      vfmadd231ps           0x60(%rsi,%rax,sz), %ymm1, %ymm4
      jnz .LkernelLoop
      test          true, %r9b
      jz            .LnoAdd1
      vaddps            (%rdi), %ymm0, %ymm0
      vaddps        0x20(%rdi), %ymm2, %ymm2
      vaddps        0x40(%rdi), %ymm3, %ymm3
      vaddps        0x60(%rdi), %ymm4, %ymm4
      .LnoAdd1:
      vmovups               %ymm0,     (%rdi)
      vmovups               %ymm2, 0x20(%rdi)
      vmovups               %ymm3, 0x40(%rdi)
      vmovups               %ymm4, 0x60(%rdi)

      //add stride, %rsi
      add regSize*4, %rsi
      add regSize*4, %rdi
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r10d   , %ecx
      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %ecx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      mov           %r8, %rax   // reset to filter size
      vxorps        %ymm0, %ymm0, %ymm0  // reset sum
  .LkernelLoop2:
      dec           %rax
      vbroadcastss  (%rdx,%rax,sz), %ymm1
      vfmadd231ps   (%rsi,%rax,sz), %ymm1, %ymm0
      jnz .LkernelLoop2
      test          true, %r9b
      jz            .LnoAdd2
      vaddps        (%rdi), %ymm0, %ymm0
      .LnoAdd2:
      vmovups       %ymm0,     (%rdi)

      //add stride, %rsi
      add regSize, %rsi
      add regSize, %rdi
      dec %ecx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r10d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r10d ,%xmm0
      vpbroadcastd %xmm0,%ymm0
      vpcmpgtd     ymmD(%rip), %ymm0, %ymm2

      mov          %r8, %rax   // reset to filter size
      vxorps       %ymm0, %ymm0, %ymm0

  .LkernelLoop3:
      dec           %rax
      vbroadcastss  (%rdx,%rax,sz), %ymm1
      vmaskmovps    (%rsi,%rax,sz), %ymm2, %ymm3
      vfmadd231ps   %ymm3, %ymm1, %ymm0
      jnz .LkernelLoop3
      test          true, %r9b
      jz            .LnoAdd3
      vmaskmovps    (%rdi), %ymm2, %ymm3
      vaddps        %ymm3 , %ymm0, %ymm0
      .LnoAdd3:
      vmaskmovps    %ymm0, %ymm2, (%rdi)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkConv_d(const dst,a,f:PDouble;const Count,K{Kernel Size}:Integer;const add:boolean); {$ifndef windows}nf;{$endif}
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       push %rsi
       push %rdi
       mov dst, %rdi
       mov a, %rsi
       mov f, %rdx
       mov Count, %ecx
       mov K , %r8d
       mov add , %r9b
    {$endif}
      //push %rax
      //xor %rax,%rax
      sub %r8, %rcx
      inc %rcx
      mov %ecx  , %r10d
      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
      //cmp $0 , %ecx
      jz .LskipBulk

  .LbulkLoop:
      mov           %r8, %rax   // reset to filter size
      vxorpd        %ymm0, %ymm0, %ymm0  // reset sum
      vxorpd        %ymm2, %ymm2, %ymm2  // reset sum
      vxorpd        %ymm3, %ymm3, %ymm3  // reset sum
      vxorpd        %ymm4, %ymm4, %ymm4  // reset sum
  .LkernelLoop:
      dec           %rax
      vbroadcastsd  (%rdx,%rax,sz), %ymm1
      vfmadd231pd       (%rsi,%rax,sz), %ymm1, %ymm0
      vfmadd231pd   0x20(%rsi,%rax,sz), %ymm1, %ymm2
      vfmadd231pd   0x40(%rsi,%rax,sz), %ymm1, %ymm3
      vfmadd231pd   0x60(%rsi,%rax,sz), %ymm1, %ymm4
      jnz .LkernelLoop
      test          true, %r9b
      jz            .LnoAdd1
      vaddpd            (%rdi), %ymm0, %ymm0
      vaddpd        0x20(%rdi), %ymm2, %ymm2
      vaddpd        0x40(%rdi), %ymm3, %ymm3
      vaddpd        0x60(%rdi), %ymm4, %ymm4
      .LnoAdd1:
      vmovupd       %ymm0,     (%rdi)
      vmovupd       %ymm2, 0x20(%rdi)
      vmovupd       %ymm3, 0x40(%rdi)
      vmovupd       %ymm4, 0x60(%rdi)

      //add stride, %rsi
      add regSize*4, %rsi
      add regSize*4, %rdi
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop
  .LskipBulk:

      mov %r10d   , %ecx
      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
      shr shifter , %ecx
//      add bulkReminder, %ecx
      jle .LskipShort

  .LremLoop:
      mov           %r8, %rax   // reset to filter size
      vxorpd        %ymm0, %ymm0, %ymm0  // reset sum
  .LkernelLoop2:
      dec           %rax
      vbroadcastsd  (%rdx,%rax,sz), %ymm1
      vfmadd231pd   (%rsi,%rax,sz), %ymm1, %ymm0
      jnz .LkernelLoop2
      test          true, %r9b
      jz            .LnoAdd2
      vaddpd        (%rdi),    %ymm0, %ymm0
      .LnoAdd2:
      vmovupd       %ymm0,     (%rdi)

      //add stride, %rsi
      add regSize, %rsi
      add regSize, %rdi
      dec %ecx
      jnz .LremLoop
      //loop .LremLoop
  .LskipShort:

      andl rCnt-1 ,%r10d        //last reminder less than 4 elements := C mod 4
      jle .Ldone

      vmovd        %r10d ,%xmm0
      vpbroadcastq %xmm0,%ymm0
      vpcmpgtq     ymmQ(%rip), %ymm0, %ymm2

      mov          %r8, %rax   // reset to filter size
      vxorpd       %ymm0, %ymm0, %ymm0

  .LkernelLoop3:
      dec           %rax
      vbroadcastsd  (%rdx,%rax,sz), %ymm1
      vmaskmovpd    (%rsi,%rax,sz), %ymm2, %ymm3
      vfmadd231pd   %ymm3, %ymm1, %ymm0
      jnz .LkernelLoop3
      test          true, %r9b
      jz            .LnoAdd3
      vmaskmovpd    (%rdi), %ymm2, %ymm3
      vaddpd        %ymm3, %ymm0, %ymm0
      .LnoAdd3:
      vmaskmovpd    %ymm0, %ymm2, (%rdi)

  .Ldone:
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
      //pop %rax
{$else}

{$endif}
end;

procedure bulkConv2d_s(const dst,a,f:PSingle;const Width,Height,P,Q{Kernel Size}:Integer);
var y,i,pp,qq:integer;
begin
  pp:=(P-1) div 2;
  qq:=(Q-1) div 2;
  FillDWord(dst[0],Width*Height,0);
  for y:=0 to Height-Q do
    for i:=0 to Q-1 do
      bulkConv_s(@dst[(y+qq)*width+pp],@a[y*width+i*width],@f[i*P],Width,P,i>0);
end;

procedure bulkConv2d_d(const dst,a,f:PDouble;const Width,Height,P,Q{Kernel Size}:Integer);
var y,i,pp,qq:integer;
begin
  pp:=(P-1) div 2;
  qq:=(Q-1) div 2;
  FillQWord(dst[0],Width*Height,0);
  for y:=0 to Height-Q do
    for i:=0 to Q-1 do
      bulkConv_d(@dst[(y+qq)*width+pp],@a[y*width+i*width],@f[i*P],Width,P,i>0);
end;

// procedure SIMD templates
//procedure bulkProc_s(const dst,a,f:PSingle;const Count,K{Kernel Size}:Integer); nf;
//const regSize=$20;   //in bytes
//const sz=SizeOf(a^); // element size in bytes
//const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
//const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
//const shifter=3;  // log2(rCnt)
//asm
//{$ifdef CPUX86_64}
//    {$ifdef windows}
//       mov dst, %rdi
//       mov a, %rsi
//       mov f, %rdx
//       mov Count, %ecx
//       mov
//    {$endif}
//      //push %rax
//      xor %rax,%rax
//      mov Count  , %r9d
//      shr shifter+2 , %ecx  // C div 16 ;  16 is the (4= ymm register size in element) X (4= number of repeats)
//      //cmp $0 , %ecx
//      jz .LskipBulk
//
//  .LbulkLoop:
//
//
//      add       stride, %rax
//      dec %ecx
//      jnz .LbulkLoop
//      //loop .LbulkLoop
//  .LskipBulk:
//
//      mov %r8d   , %ecx
//      and stride-1, %ecx     //(C mod stride) div 4 = (C and stride-1) shr 3 //  calculate how many multiples of 4 remaining
//      shr shifter , %ecx
////      add bulkReminder, %ecx
//      jle .LskipShort
//
//  .LremLoop:
//
//
//      add rCnt, %rax
//      dec %ecx
//      jnz .LremLoop
//      //loop .LremLoop
//  .LskipShort:
//
//      andl rCnt-1 ,%r9d        //last reminder less than 4 elements := C mod 4
//      jle .Ldone
//
//      vmovd %r9d  , %xmm0
//      vpbroadcastd %xmm0,%ymm0
//      vpcmpgtd ymmD(%rip), %ymm0, %ymm1
//      vmaskmovps (%rsi,%rax,sz), %ymm1, %ymm0
//
//
//      vmaskmovps  %ymm0, %ymm1, (%rdi,%rax,sz)
//
//  .Ldone:
//      //pop %rax
//{$else}
//
//{$endif}
//end;



{$ifdef USE_AVX512}
procedure bulkDot512_cvs(const dst,re,b:PSingle;const Count:integer);nf;
const regSize=$40 ;
const sz=SizeOf(re^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=4;// log2(rCnt)
(*var i:integer=0;
begin
//  i:=0;
  while i<Count do
  begin
    dst[0]+=a[i]*b[i*2];
    dst[1]+=a[i]*b[i*2+1];
    inc(i)
  end;
end;   *)
asm
{$ifdef CPUX86_64}
    {$ifdef windows}
       mov dst, %rdi
       mov re, %rsi
       mov b, %rdx
       mov Count, %ecx
    {$endif}
      //push %rax
      xor %rax,%rax
      vpxor %zmm0, %zmm0, %zmm0        //reset ymm0
      //vpxor %ymm2, %ymm2, %ymm2        //reset ymm0
      //vpxor %ymm3, %ymm3, %ymm3        //reset ymm0
      //vpxor %ymm4, %ymm4, %ymm4        //reset ymm0
      shl   $1    , %ecx
      mov   %ecx  , %r8d
      shr   shifter+2 , %ecx  // C div 32 ;  32 is the (8= ymm register size in element) X (4= number of repeats)
      jz .LskipBulk
  .LbulkLoop:
      vpermq      $0b01010000, (%rsi,%rax,sz/2), %zmm1                  //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps   $0b01010000, %zmm1,  %zmm1                            //[1, 1, 2, 2, 3, 3, 4, 4]
      vfmadd231ps (%rdx,%rax,sz), %zmm1, %zmm0

      vpermq      $0b01010000, 1*16(%rsi,%rax,sz/2), %zmm1              //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps   $0b01010000, %zmm1,  %zmm1                            //[1, 1, 2, 2, 3, 3, 4, 4]
      vfmadd231ps 1*32(%rdx,%rax,sz), %zmm1, %zmm0

      vpermq      $0b01010000, 2*16(%rsi,%rax,sz/2), %zmm1              //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps   $0b01010000, %zmm1,  %zmm1                            //[1, 1, 2, 2, 3, 3, 4, 4]
      vfmadd231ps 2*32(%rdx,%rax,sz), %zmm1, %zmm0

      vpermq      $0b01010000, 3*16(%rsi,%rax,sz/2), %zmm1              //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps   $0b01010000, %zmm1,  %zmm1                            //[1, 1, 2, 2, 3, 3, 4, 4]
      vfmadd231ps 3*32(%rdx,%rax,sz), %zmm1, %zmm0

      add       stride, %rax
      dec %ecx
      jnz .LbulkLoop
      //loop .LbulkLoop         // for some reason loop instruction is slower than dec/jnz by almost 1.5 times
      //vaddps     %ymm2,  %ymm0,   %ymm0
      //vaddps     %ymm3,  %ymm0,   %ymm0
      //vaddps     %ymm4,  %ymm0,   %ymm0
  .LskipBulk:
      mov %r8d , %ecx
      and stride-1, %ecx     //(C mod stride) div 8 = (C and stride-1) shr 3 //  calculate how many multiples of 8 remaining
      shr shifter , %ecx
      jle .LskipShort

  .LremLoop:
      vpermq      $0b01010000, (%rsi,%rax,sz/2), %zmm1              //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps   $0b01010000, %zmm1,  %zmm1                        //[1, 1, 2, 2, 3, 3, 4, 4]
      vfmadd231ps (%rdx,%rax,sz), %zmm1, %zmm0
      add rCnt, %rax
      dec %ecx
      jnz .LremLoop
  .LskipShort:

      andl rCnt-1 , %r8d  //last reminder less than 8 elements := C mod 8 (8=elements per register)
      jz .Ldone
     // shl  $1,  %r8d

      vpxor %zmm2, %zmm2, %zmm2

      vmovd %r8d, %xmm3
      vpbroadcastd %xmm3,%zmm3
      vpcmpgtd zmmPs(%rip), %zmm3, %zmm3
      vmovups  (%rsi,%rax,sz/2), %zmm1           //[1, 2, 3, 4, 0, 0, 0, 0]
      vpermq      $0b01010000, %zmm1,  %zmm1              //[1, 2, 1, 2, 3, 4, 3, 4]
      vpermilps   $0b01010000, %zmm1,  %zmm1              //[1, 1, 2, 2, 3, 3, 4, 4]
      vblendvps   %zmm3, %zmm1, %zmm2  ,%zmm1
      vfmadd231ps (%rdx,%rax,sz), %zmm1, %zmm0
  .Ldone:
      vextract32x8   $1, %zmm0, %ymm2
      vaddps      %ymm2, %ymm1, %ymm0                        //[1, 2 , 3 , 4]
      vextracti128   $1, %ymm0, %xmm1
      vzeroupper
      vaddps     %xmm1, %xmm0, %xmm0                        //[1, 2 , 3 , 4]
      vpermilps  $0b11011000,  %xmm0, %xmm0                 //[1, 3 , 2 , 4]
      vhaddps    %xmm0, %xmm0, %xmm0
      vmovlps    %xmm0, (%rdi)
      {$ifdef windows}
        pop %rdi
        pop %rsi
      {$endif}
      //pop %rax
{$else}

{$endif}
end;
{$endif}

{ multiply 2 single precision complex numbers}
procedure mul_ccs(const dst, a, b: PSingle); nf;
asm
{$ifdef windows}
  vmovsldup  (%r8), %xmm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
  vmovshdup  (%r8), %xmm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
  vmulps     (%rdx), %xmm2, %xmm2      // a.re*b.im , a.im*b.im  =>  mm2
  vmulps     (%rdx), %xmm1, %xmm1      // a.re*b.re , a.im*b.re  =>  mm1
  vpermilps  $0b10110001, %xmm2, %xmm2 // a.im*b.im , a.re*b.im  <=> mm2
  vaddsubps  %xmm2, %xmm1, %xmm0       // a.re*b.re - a.im*b.im, a.im*b.re + a.re*b.im
  vmovlps    %xmm0, (%rcx)
{$else}
  vmovsldup  (%rdx), %xmm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
  vmovshdup  (%rdx), %xmm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
  vmulps     (%rsi), %xmm2, %xmm2      // a.re*b.im , a.im*b.im  =>  mm2
  vmulps     (%rsi), %xmm1, %xmm1      // a.re*b.re , a.im*b.re  =>  mm1
  vpermilps  $0b10110001, %xmm2, %xmm2 // a.im*b.im , a.re*b.im  <=> mm2
  vaddsubps  %xmm2, %xmm1, %xmm0       // a.re*b.re - a.im*b.im, a.im*b.re + a.re*b.im
  vmovlps    %xmm0, (%rdi)
{$endif}
end;

{ multiply 2 double precision complex numbers}
procedure mul_ccd(const dst, a, b: PDouble); nf;
asm
{$ifdef windows}
  vmovddup  (%r8), %xmm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
  vmovddup  (%r8), %xmm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
  vmulpd     (%rdx), %xmm2, %xmm2      // a.re*b.im , a.im*b.im  =>  mm2
  vmulpd     (%rdx), %xmm1, %xmm1      // a.re*b.re , a.im*b.re  =>  mm1
  vpermilpd  $0b10110001, %xmm2, %xmm2 // a.im*b.im , a.re*b.im  <=> mm2
  vaddsubpd  %xmm2, %xmm1, %xmm0       // a.re*b.re - a.im*b.im, a.im*b.re + a.re*b.im
  vmovlpd    %xmm0, (%rcx)
{$else}
  vmovddup   (%rdx), %xmm1     // load real part b of 4 complex and replicat [0,1,3,4] to mm1
  vmovddup  8(%rdx), %xmm2     // load imag part b of 4 complex and replicat [0,1,3,4] to mm2
  vmulpd     (%rsi), %xmm2, %xmm2      // a.re*b.im , a.im*b.im  =>  mm2
  vmulpd     (%rsi), %xmm1, %xmm1      // a.re*b.re , a.im*b.re  =>  mm1
  vpermilpd  $0b0101, %xmm2, %xmm2 // a.im*b.im , a.re*b.im  <=> mm2
  vaddsubpd  %xmm2, %xmm1, %xmm0       // a.re*b.re - a.im*b.im, a.im*b.re + a.re*b.im
  vmovlpd    %xmm0, (%rdi)
{$endif}
end;
{%endregion}

// [Haitham note to self] : the Sum functions below were optimized for performance over accuracy however..,
//  here is the kahan method for more accurate (but slower) summation for future implementation
//======================================
//float kahan(float x[], int N) {
//        float sum = x[0];
//        float c = 0.0;
//        for (int i = 1; i < N; i++) {
//            float y = x[i] - c;
//            float t = sum + y;
//            c = (t - sum) - y;
//            s = t;
//        }
//        return s;
//    }
procedure kahanSum_s(const dst, x:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
{$ifdef CPUX86_64}
  {$ifdef windows}
     mov dst, %rdi
     mov x, %rsi
     //mov b, %rdx
     mov Count, %edx
  {$endif}

  //mov       Count, %ecx
  //shr       shifter+2,     %ecx                 //div 8 (number of singles per register)
  //jz .LskipBulk
  vpxor      %ymm1, %ymm1, %ymm1               // sum = x[0]
  vpxor      %ymm2, %ymm2, %ymm2      // c   = 0.0
  //dec        %ecx
  //add        $20,    %rsi                // for i=N
//.LbulkLoop:
//  vmovups   (%rsi), %ymm3
//  vsubps    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
//  vaddps    %ymm1, %ymm3, %ymm4      // sum + y   => t
//  vsubps    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
//  vsubps    %ymm3, %ymm5, %ymm2      // tmp - y -> c
//  vmovaps   %ymm4, %ymm1              // t =>  sum
//
//  vmovups   1*regSize(%rsi), %ymm3
//  vsubps    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
//  vaddps    %ymm1, %ymm3, %ymm4      // sum + y   => t
//  vsubps    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
//  vsubps    %ymm3, %ymm5, %ymm2      // tmp - y -> c
//  vmovaps   %ymm4, %ymm1              // t =>  sum
//
//  vmovups   2*regSize(%rsi), %ymm3
//  vsubps    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
//  vaddps    %ymm1, %ymm3, %ymm4      // sum + y   => t
//  vsubps    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
//  vsubps    %ymm3, %ymm5, %ymm2      // tmp - y -> c
//  vmovaps   %ymm4, %ymm1              // t =>  sum
//
//  vmovups   3*regSize(%rsi), %ymm3
//  vsubps    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
//  vaddps    %ymm1, %ymm3, %ymm4      // sum + y   => t
//  vsubps    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
//  vsubps    %ymm3, %ymm5, %ymm2      // tmp - y -> c
//  vmovaps   %ymm4, %ymm1              // t =>  sum
//
//  add       stride*sz, %rsi
//  dec       %ecx                        // i > 1
//  jnz       .LbulkLoop
//
//.LskipBulk:

  mov       %edx,     %ecx
//  and       stride-1,  %ecx
  shr       shifter,  %ecx
  jz        .LskipShort
.LshortLoop:
  vmovups   (%rsi), %ymm3
  vsubps    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
  vaddps    %ymm1, %ymm3, %ymm4      // sum + y   => t
  vsubps    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
  vsubps    %ymm3, %ymm5, %ymm2      // tmp - y -> c
  vmovaps   %ymm4, %ymm1              // t =>  sum
  add       rCnt*sz,    %rsi
  dec       %ecx
  jnz       .LshortLoop
.LskipShort:
  mov       %edx,     %ecx
  and       rCnt-1,    %ecx
  jz        .Ldone
  vpxor     %ymm3, %ymm3, %ymm3     // y=0
  vmovd     %ecx,    %xmm0
  vpbroadcastd %xmm0,%ymm0
  vpcmpgtd ymmD(%rip), %ymm0, %ymm0
  vmaskmovps (%rsi), %ymm0, %ymm3
  vsubps    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
  vaddps    %ymm1, %ymm3, %ymm4      // sum + y   => t
  vsubps    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
  vsubps    %ymm3, %ymm5, %ymm2      // tmp - y -> c
  vmovaps   %ymm4, %ymm1              // t =>  sum
  //vmaskmovps %ymm4, %ymm0, %ymm1



.Ldone:
  vextractf128  $1,  %ymm1, %xmm2
  vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
  vaddps        %xmm2, %xmm1, %xmm1
  vhaddps       %xmm1, %xmm1, %xmm1
  vhaddps       %xmm1, %xmm1, %xmm1
  vmovss        %xmm1,  (%rdi)
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
{$endif}
end;

procedure kahanSum_d(const dst, x:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
{$ifdef CPUX86_64}
  {$ifdef windows}
     mov dst, %rdi
     mov x, %rsi
     //mov b, %rdx
     mov Count, %ecx
  {$endif}

  //mov       Count, %ecx
  //shr       shifter+2,     %ecx                 //div 8 (number of singles per register)
  //jz .LskipBulk
  vpxor      %ymm1, %ymm1, %ymm1               // sum = x[0]
  vpxor      %ymm2, %ymm2, %ymm2      // c   = 0.0
  //dec        %ecx
  //add        $20,    %rsi                // for i=N
//.LbulkLoop:
//  vmovupd   (%rsi), %ymm3
//  vsubpd    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
//  vaddpd    %ymm1, %ymm3, %ymm4      // sum + y   => t
//  vsubpd    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
//  vsubpd    %ymm3, %ymm5, %ymm2      // tmp - y -> c
//  vmovapd   %ymm4, %ymm1              // t =>  sum
//
//  vmovupd   1*regSize(%rsi), %ymm3
//  vsubpd    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
//  vaddpd    %ymm1, %ymm3, %ymm4      // sum + y   => t
//  vsubpd    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
//  vsubpd    %ymm3, %ymm5, %ymm2      // tmp - y -> c
//  vmovapd   %ymm4, %ymm1              // t =>  sum
//
//  vmovupd   2*regSize(%rsi), %ymm3
//  vsubpd    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
//  vaddpd    %ymm1, %ymm3, %ymm4      // sum + y   => t
//  vsubpd    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
//  vsubpd    %ymm3, %ymm5, %ymm2      // tmp - y -> c
//  vmovapd   %ymm4, %ymm1              // t =>  sum
//
//  vmovupd   3*regSize(%rsi), %ymm3
//  vsubpd    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
//  vaddpd    %ymm1, %ymm3, %ymm4      // sum + y   => t
//  vsubpd    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
//  vsubpd    %ymm3, %ymm5, %ymm2      // tmp - y -> c
//  vmovapd   %ymm4, %ymm1              // t =>  sum
//
//  add       stride*sz, %rsi
//  dec       %ecx                        // i > 1
//  jnz       .LbulkLoop
//
//.LskipBulk:

  mov       %edx,     %ecx
//  and       stride-1,  %ecx
  shr       shifter,  %ecx
  jz        .LskipShort
.LshortLoop:
  vmovupd   (%rsi), %ymm3
  vsubpd    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
  vaddpd    %ymm1, %ymm3, %ymm4      // sum + y   => t
  vsubpd    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
  vsubpd    %ymm3, %ymm5, %ymm2      // tmp - y -> c
  vmovapd   %ymm4, %ymm1              // t =>  sum
  add       rCnt*sz,    %rsi
  dec       %ecx
  jnz       .LshortLoop
.LskipShort:
  mov       %edx,     %ecx
  and       rCnt-1,    %ecx
  jz        .Ldone
  vpxor     %ymm3, %ymm3, %ymm3     // y=0
  vmovd     %ecx,    %xmm0
  vpbroadcastq %xmm0,%ymm0
  vpcmpgtq ymmQ(%rip), %ymm0, %ymm0
  vmaskmovpd (%rsi), %ymm0, %ymm3
  vsubpd    %ymm2, %ymm3, %ymm3      // x[i] - c  => y
  vaddpd    %ymm1, %ymm3, %ymm4      // sum + y   => t
  vsubpd    %ymm1, %ymm4, %ymm5      // t - sum  =>tmp
  vsubpd    %ymm3, %ymm5, %ymm2      // tmp - y -> c
  vmovapd   %ymm4, %ymm1              // t =>  sum
  //vmaskmovps %ymm4, %ymm0, %ymm1



.Ldone:
  vextractf128  $1,  %ymm1, %xmm2
  vzeroupper     // this may prevent some perfomance penalties on earlier Skylake/Haswell CPUs
  vaddpd        %xmm2, %xmm1, %xmm1
  vhaddpd       %xmm1, %xmm1, %xmm1
//  vhaddps       %xmm1, %xmm1, %xmm1
  vmovsd       %xmm1,  (%rdi)
  {$ifdef windows}
    pop %rdi
    pop %rsi
  {$endif}
{$endif}
end;

{$asmmode intel}
procedure bulkMulSplit_ccs(const dst,ds2,re,r2,im,i2:PSingle;const N:integer);nf;
const regSize=$20 ;
const sz=SizeOf(dst^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter = 3;
asm
  xor                 rax,   rax
  mov                 r10d,   N
  shr                 r10d,   shifter
  jz                  @rem
@bulk:
  vmovups             ymm0,  ymmword ptr [re {rdx} + rax*4]                  //
  vmulps              ymm2,  ymm0, ymmword ptr [r2 {rcx} + rax*4]            // r1*r2

  vmovups             ymm1,  ymmword ptr [im {r8} + rax*4]
  vmulps              ymm3,  ymm1, ymmword ptr [i2 {r8} + rax*4]             // i1*i2

  vsubps              ymm4,  ymm2, ymm3                                      // r1*r2 - i1*i2
  vmovups             ymmword ptr [dst + rax*4],  ymm4

  vmulps              ymm2,  ymm0, ymmword ptr [i2 + rax*4]                  // i2*r1
  vmulps              ymm3,  ymm1, ymmword ptr [r2 + rax*4]                  // r2*i1

  vaddps              ymm4,  ymm2, ymm3                                      // i2*r1 + r2*i1
  vmovups             ymmword ptr [ds2 + rax*4],  ymm4
  add                 rax,  8
  dec                 r10d
  jg                  @bulk

@rem:
  and                 N,      rCnt-1
  jz                  @done
  vmovss              xmm0,   N
  vpbroadcastd        ymm5,   xmm0
  vpcmpgtd            ymm5,   ymm5, [rip+ymmD]

  vmaskmovps          ymm0,  ymm5,  ymmword ptr [re + rax*4]
  vmulps              ymm2,  ymm0,  ymmword ptr [r2 + rax*4]

  vmaskmovps          ymm1,  ymm5,  ymmword ptr [im + rax*4]
  vmulps              ymm3,  ymm1,  ymmword ptr [i2 + rax*4]

  vsubps              ymm4,  ymm2, ymm3
  vmaskmovps          ymmword ptr [dst + rax*4],  ymm5,  ymm4

  vmulps              ymm2,  ymm0, ymmword ptr [i2 + rax*4]
  vmulps              ymm3,  ymm1, ymmword ptr [r2 + rax*4]
  vaddps              ymm4,  ymm2, ymm3
  vmaskmovps          ymmword ptr [ds2 + rax*4],  ymm5,  ymm4
@done:
end;

function argcheck(const a,b,c,d,e,f,g,h:psingle):single;vectorcall;
var s:integer;
begin

end;

//var a:array[0..10] of single;

initialization


//argcheck(@a[1],@a[2],@a[3],@a[4],@a[5],@a[6],@a[7],@a[8])
  //SetRoundMode(rmNearest);
  //DefaultMXCSR:=DefaultMXCSR or (1 shl 15);   // FZ Flush underflow operations to zero
  //DefaultMXCSR:=DefaultMXCSR or (1 shl 6);   // DAZ tells the CPU to force all Denormals to zero.  (check if CPU supports setting this bit 1st)
  //
  //SetMXCSR(DefaultMXCSR);

 //bulkAdd_s   := @bulkAdd;
 //bulkAdd_d   := @bulkAdd;
 //bulkAdd_ss  := @bulkAdd;
 //bulkAdd_sd  := @bulkAdd;
 //bulkSub_s   := @bulkSub;
 //bulkSub_d   := @bulkSub;
 //bulkSub_ss  := @bulkSub;
 //bulkSub_sd  := @bulkSub;
 //bulkMul_s   := @bulkMul;
 //bulkMul_d   := @bulkMul;
 //bulkMul_ss  := @bulkMul;
 //bulkMul_sd  := @bulkMul;
 //bulkDiv_s   := @bulkDiv;
 //bulkDiv_d   := @bulkDiv;
 //bulkDiv_ss  := @bulkDiv;
 //bulkDiv_sd  := @bulkDiv;
 //bulkDot_s   := @bulkDot;
 //bulkDot_d   := @bulkDot;
 //interleave_s:= @interleave;
 //interleave_d:= @interleave;


end.

