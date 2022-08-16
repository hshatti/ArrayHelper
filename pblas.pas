unit pblas;
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
{.$goto on}
{$macro on}
{$asmmode intel}

{.$undef fpc}
{$ifndef fpc}
  {$mode delphi}
{$endif}
{$H+} //use long strings
{.$W-} // stackframes off
{$define EXPAND_MM}
{$define assem:=assembler}
{$define nf:=nostackframe;assembler}
interface
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

procedure kahanSum_s(const dst, x:PSingle;const Count:integer);assem;inline;
procedure kahanSum_d(const dst, x:PDouble;const Count:integer);assem;inline;
procedure bulkMulSplit_ccs(const dst,ds2,re,r2,im,i2:PSingle;const N:integer);assem;inline;

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

procedure interleave_s(const dst1,dst2,a:psingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*2{(element count per register) X (number of bulk repeates)};
const shifter=4;// log2(16) { bulk elements count }
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @BulkLoop:
 vinsertf128 ymm0,ymm0, [rdx+rax*2],$0
 vinsertf128 ymm1,ymm1, [rdx+rax*2+$10],$0
 vinsertf128 ymm0,ymm0, [rdx+rax*2+$20],$1
 vinsertf128 ymm1,ymm1, [rdx+rax*2+$30],$1
 vshufps ymm2,ymm0,ymm1,$88
 vshufps ymm3,ymm0,ymm1,$dd
 vmovups [rdi+rax*1],ymm2
 vmovups [rsi+rax*1],ymm3
 add    rax,$20
 dec    ecx
 jg     @BulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,1
 je     @done
 @smallMov:
 mov    r8d,DWORD PTR [rdx]
 mov    eax,DWORD PTR [rdx+$4]
 mov    DWORD PTR [rdi],r8d
 mov    DWORD PTR [rsi],eax
 add    rdi,$4
 add    rsi,$4
 add    rdx,$8
 dec    ecx
 jne    @smallMov
 @done:
end;

procedure interleave_d(const dst1,dst2,a:pdouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*2{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(8) { bulk elements count }
asm
 mov    r8d,ecx
 shr    ecx,$3
 je     @skipBulk

 @BulkLoop:
 vinsertf128 ymm0,ymm0, [rdx],$0
 vinsertf128 ymm0,ymm0, [rdx+$20],$1
 vinsertf128 ymm1,ymm1, [rdx+$10],$0
 vinsertf128 ymm1,ymm1, [rdx+$30],$1
 vshufpd ymm2,ymm0,ymm1,$0
 vshufpd ymm3,ymm0,ymm1,$f
 vmovupd [rdi],ymm2
 vmovupd [rsi],ymm3
 add    rdx,$40
 add    rdi,$20
 add    rsi,$20
 dec    ecx
 jg     @BulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @done

 @smallMov:
 mov r8,QWORD PTR [rdx]
 mov rax,QWORD PTR [rdx+$8]
 mov QWORD PTR [rdi],r8
 mov QWORD PTR [rsi],rax
 add    rdi,$8
 add    rsi,$8
 add    rdx,$10
 dec    ecx
 jne    @smallMov
 @done:
end;

function bulkDot_s(const a,b:PSingle;const Count:integer):Single;nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 vpxor  ymm0,ymm0,ymm0
 mov    ecx,edx
 shr    ecx,$5
 je     @skipBulk
 vpxor  ymm2,ymm2,ymm2
 vpxor  ymm4,ymm4,ymm4
 vpxor  ymm6,ymm6,ymm6

 @bulkLoop:
 vmovups ymm1,[rdi+rax*4]
 vmovups ymm3,[rdi+rax*4+$20]
 vmovups ymm5,[rdi+rax*4+$40]
 vmovups ymm7,[rdi+rax*4+$60]
 vfmadd231ps ymm0,ymm1,[rsi+rax*4]
 vfmadd231ps ymm2,ymm3,[rsi+rax*4+$20]
 vfmadd231ps ymm4,ymm5,[rsi+rax*4+$40]
 vfmadd231ps ymm6,ymm7,[rsi+rax*4+$60]
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 vaddps ymm0,ymm0,ymm2
 vaddps ymm4,ymm4,ymm6
 vaddps ymm0,ymm0,ymm4

 @skipBulk:
 mov    ecx,edx
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm1,[rdi+rax*4]
 vfmadd231ps ymm0,ymm1,[rsi+rax*4]
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    edx,$7
 je     @done

 vmovd  xmm3,edx
 vpbroadcastd ymm3,xmm3
 vpcmpgtd ymm3,ymm3,[rip+ymmD]
 vmaskmovps ymm1,ymm3,[rdi+rax*4]
 vfmadd231ps ymm0,ymm1,[rsi+rax*4]

 @done:
 vextractf128 xmm1,ymm0,$1
 vaddps xmm0,xmm0,xmm1
 vhaddps xmm0,xmm0,xmm0
 vhaddps xmm0,xmm0,xmm0
end;

function bulkDot_s(const a,b:Psingle;const bStride,Count:integer):Single;nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 mov    r8d,ecx
 vmovd  xmm1,edx
 vpbroadcastd ymm1,xmm1
 vpmulld ymm1,ymm1,[rip+ymmD]
 imul   rdx,rdx,$20
 vxorps ymm0,ymm0,ymm0
 shr    ecx,$5
 je     @skipBulk

 vxorps ymm7,ymm7,ymm7
 vxorps ymm8,ymm8,ymm8
 vxorps ymm9,ymm9,ymm9

 @bulkLoop:
 vpcmpeqd ymm2,ymm2,ymm2
 vgatherdps ymm3,DWORD PTR [rsi+ymm1*4],ymm2
 lea    rsi,[rsi+rdx*1]
 vpcmpeqd ymm2,ymm2,ymm2
 vgatherdps ymm4,DWORD PTR [rsi+ymm1*4],ymm2
 lea    rsi,[rsi+rdx*1]
 vpcmpeqd ymm2,ymm2,ymm2
 vgatherdps ymm5,DWORD PTR [rsi+ymm1*4],ymm2
 lea    rsi,[rsi+rdx*1]
 vpcmpeqd ymm2,ymm2,ymm2
 vgatherdps ymm6,DWORD PTR [rsi+ymm1*4],ymm2
 lea    rsi,[rsi+rdx*1]

 vfmadd231ps ymm0,ymm3,[rdi]
 vfmadd231ps ymm7,ymm4,[rdi+$20]
 vfmadd231ps ymm8,ymm5,[rdi+$40]
 vfmadd231ps ymm9,ymm6,[rdi+$60]
 add    rdi,$80
 dec    ecx
 jne    @bulkLoop

 vaddps ymm0,ymm7,ymm0
 vaddps ymm8,ymm9,ymm8
 vaddps ymm0,ymm0,ymm8

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 je     @skipShort

 @shortLoop:
 vpcmpeqd ymm2,ymm2,ymm2
 vgatherdps ymm3,DWORD PTR [rsi+ymm1*4],ymm2
 vfmadd231ps ymm0,ymm3,[rdi]
 lea    rsi,[rsi+rdx*1]
 add    rdi,$20
 dec    ecx
 jne    @shortLoop

 @skipShort:
 and    r8d,$7
 je     @done
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm4,ymm2,[rdi]
 vgatherdps ymm3,DWORD PTR [rsi+ymm1*4],ymm2
 vfmadd231ps ymm0,ymm3,ymm4

 @done:
 vextractf128 xmm1,ymm0,$1
 vaddps xmm0,xmm0,xmm1
 vhaddps xmm0,xmm0,xmm0
 vhaddps xmm0,xmm0,xmm0
end;

function bulkDot_d(const a,b:PDouble;const Count:integer):Double;nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 vxorpd ymm0,ymm0,ymm0
 vxorpd ymm2,ymm2,ymm2
 vxorpd ymm4,ymm4,ymm4
 vxorpd ymm6,ymm6,ymm6
 mov    ecx,edx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm1,[rdi+rax*8]
 vmovupd ymm3,[rdi+rax*8+$20]
 vmovupd ymm5,[rdi+rax*8+$40]
 vmovupd ymm7,[rdi+rax*8+$60]
 vfmadd231pd ymm0,ymm1,[rsi+rax*8]
 vfmadd231pd ymm2,ymm3,[rsi+rax*8+$20]
 vfmadd231pd ymm4,ymm5,[rsi+rax*8+$40]
 vfmadd231pd ymm6,ymm7,[rsi+rax*8+$60]
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 vaddpd ymm0,ymm0,ymm2
 vaddpd ymm4,ymm4,ymm6
 vaddpd ymm0,ymm0,ymm4

 @skipBulk:
 mov    ecx,edx
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm1,[rdi+rax*8]
 vfmadd231pd ymm0,ymm1,[rsi+rax*8]
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    edx,$3
 je     @done
 vmovd  xmm3,edx
 vpbroadcastq ymm3,xmm3
 vpcmpgtq ymm3,ymm3,[rip+ymmQ]
 vmaskmovpd ymm1,ymm3,[rdi+rax*8]
 vfmadd231pd ymm0,ymm1,[rsi+rax*8]

 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vaddpd xmm0,xmm0,xmm1
 vhaddpd xmm0,xmm0,xmm0
end;

function bulkDot_d(const a,b:PDouble;const bStride,Count:integer):Double;nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 mov    r8d,ecx
 vmovd  xmm1,edx
 vpbroadcastd ymm1,xmm1
 vpmulld ymm1,ymm1,[rip+ymmD]
 imul   rdx,rdx,$20
 vxorps ymm0,ymm0,ymm0
 shr    ecx,$4
 je     @skipBulk
 vxorpd ymm7,ymm7,ymm7
 vxorpd ymm8,ymm8,ymm8
 vxorpd ymm9,ymm9,ymm9

 @bulkLoop:
 vpcmpeqq ymm2,ymm2,ymm2
 vgatherdpd ymm3,QWORD PTR [rsi+xmm1*8],ymm2
 lea    rsi,[rsi+rdx*1]
 vpcmpeqq ymm2,ymm2,ymm2
 vgatherdpd ymm4,QWORD PTR [rsi+xmm1*8],ymm2
 lea    rsi,[rsi+rdx*1]
 vpcmpeqq ymm2,ymm2,ymm2
 vgatherdpd ymm5,QWORD PTR [rsi+xmm1*8],ymm2
 lea    rsi,[rsi+rdx*1]
 vpcmpeqq ymm2,ymm2,ymm2
 vgatherdpd ymm6,QWORD PTR [rsi+xmm1*8],ymm2
 lea    rsi,[rsi+rdx*1]
 vfmadd231pd ymm0,ymm3,[rdi]
 vfmadd231pd ymm7,ymm4,[rdi+$20]
 vfmadd231pd ymm8,ymm5,[rdi+$40]
 vfmadd231pd ymm9,ymm6,[rdi+$60]
 add    rdi,$80
 dec    ecx
 jne    @bulkLoop

 vaddpd ymm0,ymm7,ymm0
 vaddpd ymm8,ymm9,ymm8
 vaddpd ymm0,ymm0,ymm8

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @shortLoop:
 vpcmpeqq ymm2,ymm2,ymm2
 vgatherdpd ymm3,QWORD PTR [rsi+xmm1*8],ymm2
 vfmadd231pd ymm0,ymm3,[rdi]
 lea    rsi,[rsi+rdx*1]
 add    rdi,$20
 dec    ecx
 jne    @shortLoop

 @skipShort:
 and    r8d,$3
 je     @done
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm2,ymm2,[rip+ymmQ]
 vmaskmovpd ymm4,ymm2,[rdi]
 vgatherdpd ymm3,QWORD PTR [rsi+xmm1*8],ymm2
 vfmadd231pd ymm0,ymm3,ymm4

 @done:
 vextractf128 xmm1,ymm0,$1
 vaddpd xmm0,xmm0,xmm1
 vhaddpd xmm0,xmm0,xmm0
end;

procedure bulkAdd_ss(const dst,a:PSingle;const b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 vbroadcastss ymm0,DWORD PTR [rdx]
 je     @skipBulk

 @bulkLoop:
 vaddps ymm1,ymm0,[rsi+rax*4]
 vaddps ymm2,ymm0,[rsi+rax*4+$20]
 vaddps ymm3,ymm0,[rsi+rax*4+$40]
 vaddps ymm4,ymm0,[rsi+rax*4+$60]
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vaddps ymm1,ymm0,[rsi+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done

 vmovd  xmm1,r8d
 vpbroadcastd ymm1,xmm1
 vpcmpgtd ymm2,ymm1,[rip+ymmD]
 vaddps ymm1,ymm0,[rsi+rax*4]
 vmaskmovps [rdi+rax*4],ymm2,ymm1
 @done:
end;

procedure bulkSub_ss(const dst,a:PSingle;const from:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 vbroadcastss ymm0,DWORD PTR [rdx]
 je     @skipBulk

 @bulkLoop:
 vsubps ymm1,ymm0,[rsi+rax*4]
 vsubps ymm2,ymm0,[rsi+rax*4+$20]
 vsubps ymm3,ymm0,[rsi+rax*4+$40]
 vsubps ymm4,ymm0,[rsi+rax*4+$60]
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vsubps ymm1,ymm0,[rsi+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm1,r8d
 vpbroadcastd ymm1,xmm1
 vpcmpgtd ymm2,ymm1,[rip+ymmD]
 vsubps ymm1,ymm0,[rsi+rax*4]
 vmaskmovps [rdi+rax*4],ymm2,ymm1
 @done:
end;

procedure bulkMul_ss(const dst,a:PSingle;const b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 vbroadcastss ymm0,DWORD PTR [rdx]
 je     @skipBulk

 @bulkLoop:
 vmulps ymm1,ymm0,[rsi+rax*4]
 vmulps ymm2,ymm0,[rsi+rax*4+$20]
 vmulps ymm3,ymm0,[rsi+rax*4+$40]
 vmulps ymm4,ymm0,[rsi+rax*4+$60]
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmulps ymm1,ymm0,[rsi+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm1,r8d
 vpbroadcastd ymm1,xmm1
 vpcmpgtd ymm2,ymm1,[rip+ymmD]
 vmulps ymm1,ymm0,[rsi+rax*4]
 vmaskmovps [rdi+rax*4],ymm2,ymm1
 @done:
end;

procedure bulkDiv_ss(const dst,denom:PSingle;const nom:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(denom^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 vbroadcastss ymm0,DWORD PTR [rdx]
 je      @skipBulk

 @bulkLoop:
 vdivps ymm1,ymm0,[rsi+rax*4]
 vdivps ymm2,ymm0,[rsi+rax*4+$20]
 vdivps ymm3,ymm0,[rsi+rax*4+$40]
 vdivps ymm4,ymm0,[rsi+rax*4+$60]
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vdivps ymm1,ymm0,[rsi+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm1,r8d
 vpbroadcastd ymm1,xmm1
 vpcmpgtd ymm2,ymm1,[rip+ymmD]
 vdivps ymm1,ymm0,[rsi+rax*4]
 vmaskmovps [rdi+rax*4],ymm2,ymm1
 @done:
end;

procedure bulkAdd_sd(const dst,a:PDouble;const b:PDouble;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 vbroadcastsd ymm0, [rdx]
 je     @skipBulk

 @bulkLoop:
 vaddpd ymm1,ymm0,[rsi+rax*8]
 vaddpd ymm2,ymm0,[rsi+rax*8+$20]
 vaddpd ymm3,ymm0,[rsi+rax*8+$40]
 vaddpd ymm4,ymm0,[rsi+rax*8+$60]
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vaddpd ymm1,ymm0,[rsi+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm2,ymm1,[rip+ymmQ]
 vaddpd ymm1,ymm0,[rsi+rax*8]
 vmaskmovpd [rdi+rax*8],ymm2,ymm1
 @done:
end;

procedure bulkSub_sd(const dst,a:PDouble;const from:PDouble;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 vbroadcastsd ymm0, [rdx]
 je    @skipBulk

 @bulkLoop:
 vsubpd ymm1,ymm0,[rsi+rax*8]
 vsubpd ymm2,ymm0,[rsi+rax*8+$20]
 vsubpd ymm3,ymm0,[rsi+rax*8+$40]
 vsubpd ymm4,ymm0,[rsi+rax*8+$60]
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vsubpd ymm1,ymm0,[rsi+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm2,ymm1,[rip+ymmQ]
 vsubpd ymm1,ymm0,[rsi+rax*8]
 vmaskmovpd [rdi+rax*8],ymm2,ymm1
 @done:

end;

procedure bulkMul_sd(const dst,a:PDouble;const b:PDouble;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 vbroadcastsd ymm0, [rdx]
 je     @skipBulk

 @bulkLoop:
 vmulpd ymm1,ymm0,[rsi+rax*8]
 vmulpd ymm2,ymm0,[rsi+rax*8+$20]
 vmulpd ymm3,ymm0,[rsi+rax*8+$40]
 vmulpd ymm4,ymm0,[rsi+rax*8+$60]
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmulpd ymm1,ymm0,[rsi+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm2,ymm1,[rip+ymmQ]
 vmulpd ymm1,ymm0,[rsi+rax*8]
 vmaskmovpd [rdi+rax*8],ymm2,ymm1
 @done:
end;

procedure bulkDiv_sd(const dst,denom:PDouble;const nom:PDouble;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(denom^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 vbroadcastsd ymm0, [rdx]
 je   @skipBulk

 @bulkLoop:
 vdivpd ymm1,ymm0,[rsi+rax*8]
 vdivpd ymm2,ymm0,[rsi+rax*8+$20]
 vdivpd ymm3,ymm0,[rsi+rax*8+$40]
 vdivpd ymm4,ymm0,[rsi+rax*8+$60]
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vdivpd ymm1,ymm0,[rsi+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm2,ymm1,[rip+ymmQ]
 vmaskmovpd ymm1,ymm2,[rsi+rax*8]
 vdivpd ymm1,ymm0,ymm1
 vmaskmovpd [rdi+rax*8],ymm2,ymm1
 @done:
end;

procedure bulkAXPY_s(const dst,x,y:PSingle;const Count:integer;const a:PSingle); nf;
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r9d,ecx
 vbroadcastss ymm0,DWORD PTR [r8]
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmulps ymm1,ymm0,[rsi+rax*4]
 vmulps ymm2,ymm0,[rsi+rax*4+$20]
 vmulps ymm3,ymm0,[rsi+rax*4+$40]
 vmulps ymm4,ymm0,[rsi+rax*4+$60]
 vaddps ymm1,ymm1,[rdx+rax*4]
 vaddps ymm2,ymm2,[rdx+rax*4+$20]
 vaddps ymm3,ymm3,[rdx+rax*4+$40]
 vaddps ymm4,ymm4,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r9d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmulps ymm1,ymm0,[rsi+rax*4]
 vaddps ymm1,ymm1,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r9d,$7
 jle    @done
 vmovd  xmm2,r9d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm1,ymm2,[rsi+rax*4]
 vmulps ymm1,ymm0,ymm1
 vaddps ymm1,ymm1,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm2,ymm1
 @done:
end;

procedure bulkAXPY_d(const dst,x,y:PDouble;const Count:integer;const a:PDouble); nf;
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 vxorpd ymm1,ymm1,ymm1
 mov    r9d,ecx
 vbroadcastsd ymm0, [r8]
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmulpd ymm1,ymm0,[rsi+rax*8]
 vmulpd ymm2,ymm0,[rsi+rax*8+$20]
 vmulpd ymm3,ymm0,[rsi+rax*8+$40]
 vmulpd ymm4,ymm0,[rsi+rax*8+$60]
 vaddpd ymm1,ymm1,[rdx+rax*8]
 vaddpd ymm2,ymm2,[rdx+rax*8+$20]
 vaddpd ymm3,ymm3,[rdx+rax*8+$40]
 vaddpd ymm4,ymm4,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r9d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm1,[rsi+rax*8]
 vmulpd ymm1,ymm0,ymm1
 vaddpd ymm1,ymm1,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r9d,$3
 jle    @done
 vmovd  xmm2,r9d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm2,ymm2,[rip+ymmQ]
 vmaskmovpd ymm1,ymm2,[rsi+rax*8]
 vmulpd ymm1,ymm0,ymm1
 vaddpd ymm1,ymm1,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm2,ymm1
 @done:

end;

procedure bulkAXPBY_s(const dst,x,y:PSingle;const Count:integer;const a,b:PSingle); nf;
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r10d,ecx
 vbroadcastss ymm0,DWORD PTR [r8]
 vbroadcastss ymm5,DWORD PTR [r9]
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmulps ymm1,ymm0,[rsi+rax*4]
 vmulps ymm2,ymm0,[rsi+rax*4+$20]
 vmulps ymm3,ymm0,[rsi+rax*4+$40]
 vmulps ymm4,ymm0,[rsi+rax*4+$60]
 vfmadd231ps ymm1,ymm5,[rdx+rax*4]
 vfmadd231ps ymm2,ymm5,[rdx+rax*4+$20]
 vfmadd231ps ymm3,ymm5,[rdx+rax*4+$40]
 vfmadd231ps ymm4,ymm5,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r10d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmulps ymm1,ymm0,[rsi+rax*4]
 vfmadd231ps ymm1,ymm5,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r10d,$7
 jle    @done
 vmovd  xmm2,r10d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm1,ymm2,[rsi+rax*4]
 vmulps ymm1,ymm0,ymm1
 vfmadd231ps ymm1,ymm5,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm2,ymm1
 @done:
end;

procedure bulkAXPBY_d(const dst,x,y:PDouble;const Count:integer;const a,b:PDouble); nf;
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r10d,ecx
 vbroadcastsd ymm0, [r8]
 vbroadcastsd ymm5, [r9]
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmulpd ymm1,ymm0,[rsi+rax*8]
 vmulpd ymm2,ymm0,[rsi+rax*8+$20]
 vmulpd ymm3,ymm0,[rsi+rax*8+$40]
 vmulpd ymm4,ymm0,[rsi+rax*8+$60]
 vfmadd231pd ymm1,ymm5,[rdx+rax*8]
 vfmadd231pd ymm2,ymm5,[rdx+rax*8+$20]
 vfmadd231pd ymm3,ymm5,[rdx+rax*8+$40]
 vfmadd231pd ymm4,ymm5,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r10d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmulpd ymm1,ymm0,[rsi+rax*8]
 vfmadd231pd ymm1,ymm5,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r10d,$3
 jle    @done
 vmovd  xmm2,r10d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm2,ymm2,[rip+ymmQ]
 vmaskmovpd ymm1,ymm2,[rsi+rax*8]
 vmulpd ymm1,ymm0,ymm1
 vfmadd231pd ymm1,ymm5,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm2,ymm1
 @done:
end;

procedure bulkAdd_s(const dst,a,b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmovups ymm2,[rsi+rax*4+$40]
 vmovups ymm3,[rsi+rax*4+$60]
 vaddps ymm0,ymm0,[rdx+rax*4]
 vaddps ymm1,ymm1,[rdx+rax*4+$20]
 vaddps ymm2,ymm2,[rdx+rax*4+$40]
 vaddps ymm3,ymm3,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm0,[rsi+rax*4]
 vaddps ymm0,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm1,ymm0,[rip+ymmD]
 vmaskmovps ymm0,ymm1,[rsi+rax*4]
 vaddps ymm0,ymm0,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm1,ymm0
 @done:
end;

procedure bulkAdd_d(const dst,a,b:PDouble;const Count:integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmovupd ymm2,[rsi+rax*8+$40]
 vmovupd ymm3,[rsi+rax*8+$60]
 vaddpd ymm0,ymm0,[rdx+rax*8]
 vaddpd ymm1,ymm1,[rdx+rax*8+$20]
 vaddpd ymm2,ymm2,[rdx+rax*8+$40]
 vaddpd ymm3,ymm3,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    ecx
 jne   @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm0,[rsi+rax*8]
 vaddpd ymm0,ymm0,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm1,ymm0,[rip+ymmQ]
 vmaskmovpd ymm0,ymm1,[rsi+rax*8]
 vaddpd ymm0,ymm0,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm1,ymm0
 @done:
end;

procedure bulkSub_s(const dst,a,b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmovups ymm2,[rsi+rax*4+$40]
 vmovups ymm3,[rsi+rax*4+$60]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vsubps ymm1,ymm1,[rdx+rax*4+$20]
 vsubps ymm2,ymm2,[rdx+rax*4+$40]
 vsubps ymm3,ymm3,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm0,[rsi+rax*4]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm1,ymm0,[rip+ymmD]
 vmaskmovps ymm0,ymm1,[rsi+rax*4]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm1,ymm0
 @done:
end;

procedure bulkSub_d(const dst,a,b:PDouble;const Count:integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmovupd ymm2,[rsi+rax*8+$40]
 vmovupd ymm3,[rsi+rax*8+$60]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vsubpd ymm1,ymm1,[rdx+rax*8+$20]
 vsubpd ymm2,ymm2,[rdx+rax*8+$40]
 vsubpd ymm3,ymm3,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm0,[rsi+rax*8]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm1,ymm0,[rip+ymmQ]
 vmaskmovpd ymm0,ymm1,[rsi+rax*8]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm1,ymm0
 @done:
end;

procedure bulkMul_s(const dst,a,b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmovups ymm2,[rsi+rax*4+$40]
 vmovups ymm3,[rsi+rax*4+$60]
 vmulps ymm0,ymm0,[rdx+rax*4]
 vmulps ymm1,ymm1,[rdx+rax*4+$20]
 vmulps ymm2,ymm2,[rdx+rax*4+$40]
 vmulps ymm3,ymm3,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm0,[rsi+rax*4]
 vmulps ymm0,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm1,ymm0,[rip+ymmD]
 vmaskmovps ymm0,ymm1,[rsi+rax*4]
 vmulps ymm0,ymm0,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm1,ymm0
 @done:
end;

procedure bulkMul_d(const dst,a,b:PDouble;const Count:integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmovupd ymm2,[rsi+rax*8+$40]
 vmovupd ymm3,[rsi+rax*8+$60]
 vmulpd ymm0,ymm0,[rdx+rax*8]
 vmulpd ymm1,ymm1,[rdx+rax*8+$20]
 vmulpd ymm2,ymm2,[rdx+rax*8+$40]
 vmulpd ymm3,ymm3,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmulpd ymm0,ymm0,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm1,ymm0,[rip+ymmQ]
 vmaskmovpd ymm0,ymm1,[rsi+rax*8]
 vmulpd ymm0,ymm0,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm1,ymm0
 @done:
end;

procedure bulkDiv_s(const dst,a,b:PSingle;const Count:integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmovups ymm2,[rsi+rax*4+$40]
 vmovups ymm3,[rsi+rax*4+$60]
 vdivps ymm0,ymm0,[rdx+rax*4]
 vdivps ymm1,ymm1,[rdx+rax*4+$20]
 vdivps ymm2,ymm2,[rdx+rax*4+$40]
 vdivps ymm3,ymm3,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm0,[rsi+rax*4]
 vdivps ymm0,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm1,ymm0,[rip+ymmD]
 vmaskmovps ymm0,ymm1,[rsi+rax*4]
 vdivps ymm0,ymm0,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm1,ymm0
 @done:
end;

procedure bulkDiv_d(const dst,a,b:PDouble;const Count:integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmovupd ymm2,[rsi+rax*8+$40]
 vmovupd ymm3,[rsi+rax*8+$60]
 vdivpd ymm0,ymm0,[rdx+rax*8]
 vdivpd ymm1,ymm1,[rdx+rax*8+$20]
 vdivpd ymm2,ymm2,[rdx+rax*8+$40]
 vdivpd ymm3,ymm3,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm0,[rsi+rax*8]
 vdivpd ymm0,ymm0,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jne    @remLoop
 @skipShort:

 and    r8d,$3
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm1,ymm0,[rip+ymmQ]
 vmaskmovpd ymm0,ymm1,[rsi+rax*8]
 vdivpd ymm0,ymm0,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm1,ymm0
 @done:
end;

procedure bulkSum_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 vpxor  ymm0,ymm0,ymm0
 mov    r8d,edx
 shr    rdx,$5
 je     @skipBulk
 vpxor  ymm1,ymm1,ymm1
 vpxor  ymm2,ymm2,ymm2
 vpxor  ymm3,ymm3,ymm3

 @bulkLoop:
 vaddps ymm0,ymm0,[rsi+rax*4]
 vaddps ymm1,ymm1,[rsi+rax*4+$20]
 vaddps ymm2,ymm2,[rsi+rax*4+$40]
 vaddps ymm3,ymm3,[rsi+rax*4+$60]
 add    rax,$20
 dec    rdx
 jne    @bulkLoop
 vaddps ymm2,ymm2,ymm3
 vaddps ymm0,ymm0,ymm1
 vaddps ymm0,ymm0,ymm2

 @skipBulk:
 mov    rcx,r8
 and    rcx,$1f
 shr    rcx,$3
 jle    @skipShort

 @remLoop:
 vaddps ymm0,ymm0,[rsi+rax*4]
 add    rax,$8
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done

 vpxor  ymm2,ymm2,ymm2
 vmovd  xmm1,r8d
 vpbroadcastd ymm1,xmm1
 vpcmpgtd ymm1,ymm1,[rip+ymmD]
 vmaskmovps ymm2,ymm1,[rsi+rax*4]
 vaddps ymm0,ymm0,ymm2

 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vaddps xmm0,xmm0,xmm1
 vhaddps xmm0,xmm0,xmm0
 vhaddps xmm0,xmm0,xmm0
 vmovss DWORD PTR [rdi],xmm0

end;

procedure bulkSum_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 vpxor  ymm0,ymm0,ymm0
 mov    r8d,edx
 shr    rdx,$4
 je     @skipBulk
 vpxor  ymm1,ymm1,ymm1
 vpxor  ymm2,ymm2,ymm2
 vpxor  ymm3,ymm3,ymm3

 @bulkLoop:
 vaddpd ymm0,ymm0,[rsi+rax*8]
 vaddpd ymm1,ymm1,[rsi+rax*8+$20]
 vaddpd ymm2,ymm2,[rsi+rax*8+$40]
 vaddpd ymm3,ymm3,[rsi+rax*8+$60]
 add    rax,$10
 dec    rdx
 jne    @bulkLoop
 vaddpd ymm2,ymm2,ymm3
 vaddpd ymm0,ymm0,ymm1
 vaddpd ymm0,ymm0,ymm2

 @skipBulk:
 mov    rcx,r8
 and    rcx,$f
 shr    rcx,$2
 jle    @skipShort

 @remLoop:
 vaddpd ymm0,ymm0,[rsi+rax*8]
 add    rax,$4
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vpxor  ymm2,ymm2,ymm2
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm1,ymm1,[rip+ymmQ]
 vmaskmovpd ymm2,ymm1,[rsi+rax*8]
 vaddpd ymm0,ymm0,ymm2

 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vaddpd xmm0,xmm0,xmm1
 vhaddpd xmm0,xmm0,xmm0
 vmovsd QWORD PTR [rdi],xmm0
end;

procedure bulkMax_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 vbroadcastss ymm0,DWORD PTR [rsi]
 mov    r8d,edx
 shr    rdx,$5
 je     @skipBulk
 vmovaps ymm1,ymm0
 vmovaps ymm2,ymm0
 vmovaps ymm3,ymm0

 @bulkLoop:
 vmaxps ymm0,ymm0,[rsi+rax*4]
 vmaxps ymm1,ymm1,[rsi+rax*4+$20]
 vmaxps ymm2,ymm2,[rsi+rax*4+$40]
 vmaxps ymm3,ymm3,[rsi+rax*4+$60]
 add    rax,$20
 dec    rdx
 jne    @bulkLoop

 vmaxps ymm0,ymm0,ymm1
 vmaxps ymm2,ymm2,ymm3
 vmaxps ymm0,ymm0,ymm2

 @skipBulk:
 mov    rcx,r8
 and    rcx,$1f
 shr    rcx,$3
 jle    @skipShort

 @remLoop:
 vmaxps ymm0,ymm0,[rsi+rax*4]
 add    rax,$8
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vbroadcastss ymm2,xmm0
 vmovd  xmm1,r8d
 vpbroadcastd ymm1,xmm1
 vpcmpgtd ymm1,ymm1,[rip+ymmD]
 vblendvps ymm2,ymm2,[rsi+rax*4],ymm1
 vmaxps ymm0,ymm0,ymm2

 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vmaxps xmm0,xmm0,xmm1
 vmovhlps xmm1,xmm0,xmm0
 vmaxps xmm0,xmm1,xmm0
 vmovshdup xmm1,xmm0
 vmaxss xmm0,xmm1,xmm0
 vmovss DWORD PTR [rdi],xmm0
end;

procedure bulkMax_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 vbroadcastsd ymm0, [rsi]
 mov    r8d,edx
 shr    rdx,$4
 je     @skipBulk
 vmovapd ymm1,ymm0
 vmovapd ymm2,ymm0
 vmovapd ymm3,ymm0

 @bulkLoop:
 vmaxpd ymm0,ymm0,[rsi+rax*8]
 vmaxpd ymm1,ymm1,[rsi+rax*8+$20]
 vmaxpd ymm2,ymm2,[rsi+rax*8+$40]
 vmaxpd ymm3,ymm3,[rsi+rax*8+$60]
 add    rax,$10
 dec    rdx
 jne    @bulkLoop
 vmaxpd ymm0,ymm0,ymm1
 vmaxpd ymm2,ymm2,ymm3
 vmaxpd ymm0,ymm0,ymm2

 @skipBulk:
 mov    rcx,r8
 and    rcx,$f
 shr    rcx,$2
 jle    @skipShort

 @remLoop:
 vmaxpd ymm0,ymm0,[rsi+rax*8]
 add    rax,$4
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vbroadcastsd ymm2,xmm0
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm1,ymm1,[rip+ymmQ]
 vblendvpd ymm2,ymm2,[rsi+rax*8],ymm1
 vmaxpd ymm0,ymm0,ymm2

 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vmaxpd xmm0,xmm0,xmm1
 vmovhlps xmm1,xmm0,xmm0
 vmaxsd xmm0,xmm0,xmm1
 vmovsd QWORD PTR [rdi],xmm0
end;

procedure bulkMin_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 vbroadcastss ymm0,DWORD PTR [rsi]
 mov    r8d,edx
 shr    rdx,$5
 je     @skipBulk
 vmovaps ymm1,ymm0
 vmovaps ymm2,ymm0
 vmovaps ymm3,ymm0

 @bulkLoop:
 vminps ymm0,ymm0,[rsi+rax*4]
 vminps ymm1,ymm1,[rsi+rax*4+$20]
 vminps ymm2,ymm2,[rsi+rax*4+$40]
 vminps ymm3,ymm3,[rsi+rax*4+$60]
 add    rax,$20
 dec    rdx
 jne    @bulkLoop
 vminps ymm0,ymm0,ymm1
 vminps ymm2,ymm2,ymm3
 vminps ymm0,ymm0,ymm2

 @skipBulk:
 mov    rcx,r8
 and    rcx,$1f
 shr    rcx,$3
 jle   @skipShort

 @remLoop:
 vminps ymm0,ymm0,[rsi+rax*4]
 add    rax,$8
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vbroadcastss ymm2,xmm0
 vmovd  xmm1,r8d
 vpbroadcastd ymm1,xmm1
 vpcmpgtd ymm1,ymm1,[rip+ymmD]
 vblendvps ymm2,ymm2,[rsi+rax*4],ymm1
 vminps ymm0,ymm0,ymm2

 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vminps xmm0,xmm0,xmm1
 vmovhlps xmm1,xmm0,xmm0
 vminps xmm0,xmm1,xmm0
 vmovshdup xmm1,xmm0
 vminss xmm0,xmm1,xmm0
 vmovss DWORD PTR [rdi],xmm0
end;

procedure bulkMin_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 vbroadcastsd ymm0, [rsi]
 mov    r8d,edx
 shr    rdx,$4
 je     @skipBulk
 vmovapd ymm1,ymm0
 vmovapd ymm2,ymm0
 vmovapd ymm3,ymm0

 @bulkLoop:
 vminpd ymm0,ymm0,[rsi+rax*8]
 vminpd ymm1,ymm1,[rsi+rax*8+$20]
 vminpd ymm2,ymm2,[rsi+rax*8+$40]
 vminpd ymm3,ymm3,[rsi+rax*8+$60]
 add    rax,$10
 dec    rdx
 jne    @bulkLoop
 vminpd ymm0,ymm0,ymm1
 vminpd ymm2,ymm2,ymm3
 vminpd ymm0,ymm0,ymm2

 @skipBulk:
 mov    rcx,r8
 and    rcx,$f
 shr    rcx,$2
 jle    @skipShort

 @remLoop:
 vminpd ymm0,ymm0,[rsi+rax*8]
 add    rax,$4
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vbroadcastsd ymm2,xmm0
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm1,ymm1,[rip+ymmQ]
 vblendvpd ymm2,ymm2,[rsi+rax*8],ymm1
 vminpd ymm0,ymm0,ymm2

 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vminpd xmm0,xmm0,xmm1
 vmovhlps xmm1,xmm0,xmm0
 vminsd xmm0,xmm0,xmm1
 vmovsd QWORD PTR [rdi],xmm0
end;

procedure bulkSqr_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,edx
 shr    rdx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmovups ymm2,[rsi+rax*4+$40]
 vmovups ymm3,[rsi+rax*4+$60]
 vmulps ymm0,ymm0,ymm0
 vmulps ymm1,ymm1,ymm1
 vmulps ymm2,ymm2,ymm2
 vmulps ymm3,ymm3,ymm3
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    rdx
 jne    @bulkLoop

 @skipBulk:
 mov    rcx,r8
 and    rcx,$1f
 shr    rcx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm0,[rsi+rax*4]
 vmulps ymm0,ymm0,ymm0
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm0,ymm2,[rsi+rax*4]
 vmulps ymm0,ymm0,ymm0
 vmaskmovps [rdi+rax*4],ymm2,ymm0
 @done:
end;

procedure bulkSqr_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 vpxor  ymm1,ymm1,ymm1
 mov    r8d,edx
 shr    rdx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmovupd ymm2,[rsi+rax*8+$40]
 vmovupd ymm3,[rsi+rax*8+$60]
 vmulpd ymm0,ymm0,ymm0
 vmulpd ymm1,ymm1,ymm1
 vmulpd ymm2,ymm2,ymm2
 vmulpd ymm3,ymm3,ymm3
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    rdx
 jne    @bulkLoop

 @skipBulk:
 mov    rcx,r8
 and    rcx,$f
 shr    rcx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmulpd ymm0,ymm0,ymm0
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm2,ymm2,[rip+ymmQ]
 vmaskmovpd ymm0,ymm2,[rsi+rax*8]
 vmulpd ymm0,ymm0,ymm0
 vmaskmovpd [rdi+rax*8],ymm2,ymm0
 @done:
end;

procedure bulkSqrt_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,edx
 shr    rdx,$5
 je     @skipBulk

 @bulkLoop:
 vsqrtps ymm0,[rsi+rax*4]
 vsqrtps ymm1,[rsi+rax*4+$20]
 vsqrtps ymm2,[rsi+rax*4+$40]
 vsqrtps ymm3,[rsi+rax*4+$60]
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    rdx
 jne    @bulkLoop

 @skipBulk:
 mov    rcx,r8
 and    rcx,$1f
 shr    rcx,$3
 jle    @skipShort

 @remLoop:
 vsqrtps ymm0,[rsi+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm0,ymm2,[rsi+rax*4]
 vsqrtps ymm0,ymm0
 vmaskmovps [rdi+rax*4],ymm2,ymm0
 @done:
end;

procedure bulkSqrt_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,edx
 shr    rdx,$4
 je     @skipBulk

 @bulkLoop:
 vsqrtpd ymm0,[rsi+rax*8]
 vsqrtpd ymm1,[rsi+rax*8+$20]
 vsqrtpd ymm2,[rsi+rax*8+$40]
 vsqrtpd ymm3,[rsi+rax*8+$60]
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    rdx
 jne    @bulkLoop

 @skipBulk:
 mov    rcx,r8
 and    rcx,$f
 shr    rcx,$2
 jle    @skipShort

 @remLoop:
 vsqrtpd ymm0,[rsi+rax*8]
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm2,ymm2,[rip+ymmQ]
 vmaskmovpd ymm0,ymm2,[rsi+rax*8]
 vsqrtpd ymm0,ymm0
 vmaskmovpd [rdi+rax*8],ymm2,ymm0
 @done:
end;

procedure bulkRSqrt_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,edx
 shr    rdx,$5
 je     @skipBulk

 @bulkLoop:
 vrsqrtps ymm0,[rsi+rax*4]
 vrsqrtps ymm1,[rsi+rax*4+$20]
 vrsqrtps ymm2,[rsi+rax*4+$40]
 vrsqrtps ymm3,[rsi+rax*4+$60]
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    rdx
 jne    @bulkLoop

 @skipBulk:
 mov    rcx,r8
 and    rcx,$1f
 shr    rcx,$3
 jle    @skipShort

 @remLoop:
 vrsqrtps ymm0,[rsi+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm0,ymm2,[rsi+rax*4]
 vrsqrtps ymm0,ymm0
 vmaskmovps [rdi+rax*4],ymm2,ymm0
 @done:
end;

procedure bulkAbs_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 mov    eax,$7fffffff
 vmovd  xmm5,eax
 vbroadcastss ymm5,xmm5
 xor    rax,rax
 mov    r8d,edx
 shr    rdx,$5
 je     @skipBulk

 @bulkLoop:
 vandps ymm0,ymm5,[rsi+rax*4]
 vandps ymm1,ymm5,[rsi+rax*4+$20]
 vandps ymm2,ymm5,[rsi+rax*4+$40]
 vandps ymm3,ymm5,[rsi+rax*4+$60]
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    rdx
 jne    @bulkLoop

 @skipBulk:
 mov    rcx,r8
 and    rcx,$1f
 shr    rcx,$3
 jle    @skipShort

 @remLoop:
 vandps ymm0,ymm5,[rsi+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm0,ymm2,[rsi+rax*4]
 vandps ymm0,ymm5,ymm0
 vmaskmovps [rdi+rax*4],ymm2,ymm0
 @done:
end;

procedure bulkAbs_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 movabs rax,$7fffffffffffffff
 vmovq  xmm5,rax
 vbroadcastsd ymm5,xmm5
 xor    rax,rax
 mov    r8d,edx
 shr    rdx,$4
 je     @skipBulk

 @bulkLoop:
 vandpd ymm0,ymm5,[rsi+rax*8]
 vandpd ymm1,ymm5,[rsi+rax*8+$20]
 vandpd ymm2,ymm5,[rsi+rax*8+$40]
 vandpd ymm3,ymm5,[rsi+rax*8+$60]
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    rdx
 jne    @bulkLoop

 @skipBulk:
 mov    rcx,r8
 and    rcx,$f
 shr    rcx,$2
 jle    @skipShort

 @remLoop:
 vandpd ymm0,ymm5,[rsi+rax*8]
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm2,ymm2,[rip+ymmQ]
 vmaskmovpd ymm0,ymm2,[rsi+rax*8]
 vandpd ymm0,ymm5,ymm0
 vmaskmovpd [rdi+rax*8],ymm2,ymm0
 @done:
end;

procedure bulkSumSqr_s(const dst,a:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 vpxor  ymm0,ymm0,ymm0
 vpxor  ymm5,ymm5,ymm5
 vpxor  ymm6,ymm6,ymm6
 vpxor  ymm7,ymm7,ymm7
 mov    r8d,edx
 shr    rdx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm1,[rsi+rax*4]
 vfmadd231ps ymm0,ymm1,ymm1
 vmovups ymm2,[rsi+rax*4+$20]
 vfmadd231ps ymm5,ymm2,ymm2
 vmovups ymm3,[rsi+rax*4+$40]
 vfmadd231ps ymm6,ymm3,ymm3
 vmovups ymm4,[rsi+rax*4+$60]
 vfmadd231ps ymm7,ymm4,ymm4
 add    rax,$20
 dec    rdx
 jne    @bulkLoop

 vaddps ymm0,ymm0,ymm5
 vaddps ymm6,ymm6,ymm7
 vaddps ymm0,ymm0,ymm6

 @skipBulk:
 mov    rcx,r8
 and    rcx,$1f
 shr    rcx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm1,[rsi+rax*4]
 vfmadd231ps ymm0,ymm1,ymm1
 add    rax,$8
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vpxor  ymm1,ymm1,ymm1
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm1,ymm2,[rsi+rax*4]
 vfmadd231ps ymm0,ymm1,ymm1
 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vaddps xmm0,xmm0,xmm1
 vhaddps xmm0,xmm0,xmm0
 vhaddps xmm0,xmm0,xmm0
 vmovss DWORD PTR [rdi],xmm0
end;

procedure bulkSumSqr_d(const dst,a:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 vpxor  ymm0,ymm0,ymm0
 vpxor  ymm5,ymm5,ymm5
 vpxor  ymm6,ymm6,ymm6
 vpxor  ymm7,ymm7,ymm7
 mov    r8d,edx
 shr    rdx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm1,[rsi+rax*8]
 vfmadd231pd ymm0,ymm1,ymm1
 vmovupd ymm2,[rsi+rax*8+$20]
 vfmadd231pd ymm5,ymm2,ymm2
 vmovupd ymm3,[rsi+rax*8+$40]
 vfmadd231pd ymm6,ymm3,ymm3
 vmovupd ymm4,[rsi+rax*8+$60]
 vfmadd231pd ymm7,ymm4,ymm4
 add    rax,$10
 dec    rdx
 jne    @bulkLoop
 vaddpd ymm0,ymm0,ymm5
 vaddpd ymm6,ymm6,ymm7
 vaddpd ymm0,ymm0,ymm6

 @skipBulk:
 mov    rcx,r8
 and    rcx,$f
 shr    rcx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm1,[rsi+rax*8]
 vfmadd231pd ymm0,ymm1,ymm1
 add    rax,$4
 dec    rcx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vpxor  ymm1,ymm1,ymm1
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm2,ymm2,[rip+ymmQ]
 vmaskmovpd ymm1,ymm2,[rsi+rax*8]
 vfmadd231pd ymm0,ymm1,ymm1

 @done:
 vextractf128 xmm1,ymm0,$1
 vzeroupper 
 vaddpd xmm0,xmm0,xmm1
 vhaddpd xmm0,xmm0,xmm0
 vmovsd QWORD PTR [rdi],xmm0
end;

procedure bulkGathera_s(const dst,a:PSingle;const aStride:Longint ;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 mov    r8d,ecx
 vmovd  xmm2,edx
 vpbroadcastd ymm2,xmm2
 vpmulld ymm2,ymm2,[rip+ymmD]
 imul   rdx,rdx,$20
 shr    ecx,$3
 je     @skipShort

 @shortLoop:
 vpcmpeqd ymm1,ymm1,ymm1
 vgatherdps ymm0,DWORD PTR [rsi+ymm2*4],ymm1
 vmovups [rdi],ymm0
 lea    rsi,[rsi+rdx*1]
 add    rdi,$20
 dec    ecx
 jne    @shortLoop

 @skipShort:
 and    r8d,$7
 je     @done
 vmovd  xmm3,r8d
 vpbroadcastd ymm3,xmm3
 vpcmpgtd ymm1,ymm3,[rip+ymmD]
 vmovdqa ymm3,ymm1
 vgatherdps ymm0,DWORD PTR [rsi+ymm2*4],ymm1
 vmaskmovps [rdi],ymm3,ymm0
 @done:
end;

procedure bulkGathera_d(const dst,a:PDouble;const aStride:Longint ;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 mov    r8d,ecx
 vmovd  xmm2,edx
 vpbroadcastd ymm2,xmm2
 imul   rdx,rdx,$20
 vpmulld ymm2,ymm2,[rip+ymmD]
 shr    ecx,$2
 je     @skipShort

 @shortLoop:
 vpcmpeqq ymm1,ymm1,ymm1
 vgatherdpd ymm0,QWORD PTR [rsi+xmm2*8],ymm1
 vmovupd [rdi],ymm0
 lea    rsi,[rsi+rdx*1]
 add    rdi,$20
 dec    ecx
 jne    @shortLoop

 @skipShort:
 and    r8d,$3
 je     @done
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm1,ymm0,[rip+ymmQ]
 vmovdqa ymm3,ymm1
 vgatherdpd ymm0,QWORD PTR [rsi+xmm2*8],ymm1
 vmaskmovpd [rdi],ymm3,ymm0
 @done:
end;

procedure bulkDiffSqr_s(const dst,a,b:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmovups ymm2,[rsi+rax*4+$40]
 vmovups ymm3,[rsi+rax*4+$60]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vsubps ymm1,ymm1,[rdx+rax*4+$20]
 vsubps ymm2,ymm2,[rdx+rax*4+$40]
 vsubps ymm3,ymm3,[rdx+rax*4+$60]
 vmulps ymm0,ymm0,ymm0
 vmulps ymm1,ymm1,ymm1
 vmulps ymm2,ymm2,ymm2
 vmulps ymm3,ymm3,ymm3
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm0,[rsi+rax*4]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vmulps ymm0,ymm0,ymm0
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm1,ymm0,[rip+ymmD]
 vmaskmovps ymm0,ymm1,[rsi+rax*4]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vmulps ymm0,ymm0,ymm0
 vmaskmovps [rdi+rax*4],ymm1,ymm0
 @done:
end;

procedure bulkDiffSqr_d(const dst,a,b:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmovupd ymm2,[rsi+rax*8+$40]
 vmovupd ymm3,[rsi+rax*8+$60]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vsubpd ymm1,ymm1,[rdx+rax*8+$20]
 vsubpd ymm2,ymm2,[rdx+rax*8+$40]
 vsubpd ymm3,ymm3,[rdx+rax*8+$60]
 vmulpd ymm0,ymm0,ymm0
 vmulpd ymm1,ymm1,ymm1
 vmulpd ymm2,ymm2,ymm2
 vmulpd ymm3,ymm3,ymm3
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle   @skipShort

 @remLoop:
 vmovupd ymm0,[rsi+rax*8]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vmulpd ymm0,ymm0,ymm0
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm1,ymm0,[rip+ymmQ]
 vmaskmovpd ymm0,ymm1,[rsi+rax*8]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vmulpd ymm0,ymm0,ymm0
 vmaskmovpd [rdi+rax*8],ymm1,ymm0
 @done:
end;

procedure bulkDiffSqr_sd(const dst,a,b:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 vbroadcastsd ymm0, [rdx]
 je     @skipBulk

 @bulkLoop:
 vsubpd ymm1,ymm0,[rsi+rax*8]
 vsubpd ymm2,ymm0,[rsi+rax*8+$20]
 vsubpd ymm3,ymm0,[rsi+rax*8+$40]
 vsubpd ymm4,ymm0,[rsi+rax*8+$60]
 vmulpd ymm1,ymm1,ymm1
 vmulpd ymm2,ymm2,ymm2
 vmulpd ymm3,ymm3,ymm3
 vmulpd ymm4,ymm4,ymm4
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vsubpd ymm1,ymm0,[rsi+rax*8]
 vmulpd ymm1,ymm1,ymm1
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm1,ymm2,[rip+ymmQ]
 vsubpd ymm0,ymm0,[rsi+rax*8]
 vmulpd ymm0,ymm0,ymm0
 vmaskmovpd [rdi+rax*8],ymm1,ymm0
 @done:
end;

procedure bulkDiffSqr_ss(const dst,a,b:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$5
 vbroadcastss ymm0,DWORD PTR [rdx]
 je     @skipBulk

 @bulkLoop:
 vsubps ymm1,ymm0,[rsi+rax*4]
 vsubps ymm2,ymm0,[rsi+rax*4+$20]
 vsubps ymm3,ymm0,[rsi+rax*4+$40]
 vsubps ymm4,ymm0,[rsi+rax*4+$60]
 vmulps ymm1,ymm1,ymm1
 vmulps ymm2,ymm2,ymm2
 vmulps ymm3,ymm3,ymm3
 vmulps ymm4,ymm4,ymm4
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vsubps ymm1,ymm0,[rsi+rax*4]
 vmulps ymm1,ymm1,ymm1
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm1,ymm2,[rip+ymmD]
 vsubps ymm0,ymm0,[rsi+rax*4]
 vmulps ymm0,ymm0,ymm0
 vmaskmovps [rdi+rax*4],ymm1,ymm0
 @done:
end;

procedure bulkMag_cs(const dst, a:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*1*4{(element count per register) X (number of bulk repeates) X (rquired registers)};
const shifter=3;// log2(rCnt * reqRegisters);
asm
 xor    rax,rax
 mov    ecx,edx
 shr    ecx,$3
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmulps ymm0,ymm0,ymm0
 vmulps ymm1,ymm1,ymm1
 vhaddps ymm0,ymm0,ymm1
 vpermpd ymm0,ymm0,$d8
 vsqrtps ymm0,ymm0
 vmovups [rdi+rax*2],ymm0
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,edx
 and    ecx,$7
 je     @done

 vmovd  xmm0,ecx
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm3,ymm0,[rip+ymmD]
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmulps ymm0,ymm0,ymm0
 vmulps ymm1,ymm1,ymm1
 vhaddps ymm0,ymm0,ymm1
 vpermpd ymm0,ymm0,$d8
 vsqrtps ymm0,ymm0
 vmaskmovps [rdi+rax*2],ymm3,ymm0
 @done:

end;

procedure bulkMag_cd(const dst, a:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*1*4{(element count per register) X (number of bulk repeates) X (rquired registers)};
const shifter=2;// log2(rCnt * reqRegisters);
asm
 xor    rax,rax
 mov    ecx,edx
 shr    ecx,$2
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmulpd ymm0,ymm0,ymm0
 vmulpd ymm1,ymm1,ymm1
 vhaddpd ymm0,ymm0,ymm1
 vpermpd ymm0,ymm0,$d8
 vsqrtpd ymm0,ymm0
 vmovupd [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,edx
 and    ecx,$3
 je     @done
 vmovd  xmm0,ecx
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm3,ymm0,[rip+ymmQ]
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmulpd ymm0,ymm0,ymm0
 vmulpd ymm1,ymm1,ymm1
 vhaddpd ymm0,ymm0,ymm1
 vpermpd ymm0,ymm0,$d8
 vsqrtpd ymm0,ymm0
 vmaskmovpd [rdi+rax*4],ymm3,ymm0
 @done:
end;

procedure bulkAdd_css(const dst, a, b:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 vpbroadcastq ymm0, [rsi]
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vaddps ymm1,ymm0,[rdx+rax*4]
 vaddps ymm2,ymm0,[rdx+rax*4+$20]
 vaddps ymm3,ymm0,[rdx+rax*4+$40]
 vaddps ymm4,ymm0,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vaddps ymm1,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$3
 je     @done
 shl    r8d,1
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm3,ymm2,[rip+ymmD]
 vaddps ymm1,ymm0,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm3,ymm1
 @done:
end;

procedure bulkAdd_csd(const dst, a, b:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 vbroadcastf128 ymm0, [rsi]
 shr    ecx,$3
 je     @skipBulk

 @bulkLoop:
 vaddpd ymm1,ymm0,[rdx+rax*8]
 vaddpd ymm2,ymm0,[rdx+rax*8+$20]
 vaddpd ymm3,ymm0,[rdx+rax*8+$40]
 vaddpd ymm4,ymm0,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vaddpd ymm1,ymm0,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm3,ymm2,[rip+ymmQ]
 vaddpd ymm1,ymm0,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm3,ymm1
 @done:
end;

procedure bulkSub_css(const dst, a, b:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 vpbroadcastq ymm0, [rsi]
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vsubps ymm1,ymm0,[rdx+rax*4]
 vsubps ymm2,ymm0,[rdx+rax*4+$20]
 vsubps ymm3,ymm0,[rdx+rax*4+$40]
 vsubps ymm4,ymm0,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm1
 vmovups [rdi+rax*4+$20],ymm2
 vmovups [rdi+rax*4+$40],ymm3
 vmovups [rdi+rax*4+$60],ymm4
 add    rax,$20
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vsubps ymm1,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$3
 je     @done
 shl    r8d,1
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm3,ymm2,[rip+ymmD]
 vsubps ymm1,ymm0,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm3,ymm1
 @done:

end;

procedure bulkSub_csd(const dst, a, b:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 vbroadcastf128 ymm0, [rsi]
 shr    ecx,$3
 je     @skipBulk

 @bulkLoop:
 vsubpd ymm1,ymm0,[rdx+rax*8]
 vsubpd ymm2,ymm0,[rdx+rax*8+$20]
 vsubpd ymm3,ymm0,[rdx+rax*8+$40]
 vsubpd ymm4,ymm0,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm1
 vmovupd [rdi+rax*8+$20],ymm2
 vmovupd [rdi+rax*8+$40],ymm3
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vsubpd ymm1,ymm0,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm3,ymm2,[rip+ymmQ]
 vsubpd ymm1,ymm0,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm3,ymm1
 @done:

end;

procedure bulkMul_css(const dst, a, b:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 vpbroadcastq ymm0,[rsi]
 vmovshdup ymm1,ymm0
 vmovsldup ymm0,ymm0
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmulps ymm3,ymm0,[rdx+rax*4]
 vmulps ymm4,ymm1,[rdx+rax*4]
 vmulps ymm5,ymm0,[rdx+rax*4+$20]
 vmulps ymm6,ymm1,[rdx+rax*4+$20]
 vmulps ymm7,ymm0,[rdx+rax*4+$40]
 vmulps ymm8,ymm1,[rdx+rax*4+$40]
 vmulps ymm9,ymm0,[rdx+rax*4+$60]
 vmulps ymm10,ymm1,[rdx+rax*4+$60]
 vpermilps ymm4,ymm4,$b1
 vpermilps ymm6,ymm6,$b1
 vpermilps ymm8,ymm8,$b1
 vpermilps ymm10,ymm10,$b1
 vaddsubps ymm3,ymm3,ymm4
 vaddsubps ymm5,ymm5,ymm6
 vaddsubps ymm7,ymm7,ymm8
 vaddsubps ymm9,ymm9,ymm10
 vmovups [rdi+rax*4],ymm3
 vmovups [rdi+rax*4+$20],ymm5
 vmovups [rdi+rax*4+$40],ymm7
 vmovups [rdi+rax*4+$60],ymm9
 add    rax,$20
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vmulps ymm3,ymm0,[rdx+rax*4]
 vmulps ymm4,ymm1,[rdx+rax*4]
 vpermilps ymm4,ymm4,$b1
 vaddsubps ymm3,ymm3,ymm4
 vmovups [rdi+rax*4],ymm3
 add    rax,$8
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$3
 je     @done
 shl    r8d,1
 vmovd  xmm2,r8d
 vpbroadcastd ymm2,xmm2
 vpcmpgtd ymm2,ymm2,[rip+ymmD]
 vmaskmovps ymm5,ymm2,[rdx+rax*4]
 vmulps ymm3,ymm0,ymm5
 vmulps ymm4,ymm1,ymm5
 vpermilps ymm4,ymm4,$b1
 vaddsubps ymm3,ymm3,ymm4
 vmaskmovps [rdi+rax*4],ymm2,ymm3
 @done:

end;

procedure bulkMul_csd(const dst, a, b:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 vbroadcastf128 ymm0, [rsi]
 vpermilpd ymm1,ymm0,$f
 vmovddup ymm0,ymm0
 shr    ecx,$3
 je     @skipBulk

 @bulkLoop:
 vmulpd ymm3,ymm0,[rdx+rax*8]
 vmulpd ymm4,ymm1,[rdx+rax*8]
 vmulpd ymm5,ymm0,[rdx+rax*8+$20]
 vmulpd ymm6,ymm1,[rdx+rax*8+$20]
 vmulpd ymm7,ymm0,[rdx+rax*8+$40]
 vmulpd ymm8,ymm1,[rdx+rax*8+$40]
 vmulpd ymm9,ymm0,[rdx+rax*8+$60]
 vmulpd ymm10,ymm1,[rdx+rax*8+$60]
 vpermilpd ymm4,ymm4,$5
 vpermilpd ymm6,ymm6,$5
 vpermilpd ymm8,ymm8,$5
 vpermilpd ymm10,ymm10,$5
 vaddsubpd ymm3,ymm3,ymm4
 vaddsubpd ymm5,ymm5,ymm6
 vaddsubpd ymm7,ymm7,ymm8
 vaddsubpd ymm9,ymm9,ymm10
 vmovupd [rdi+rax*8],ymm3
 vmovupd [rdi+rax*8+$20],ymm5
 vmovupd [rdi+rax*8+$40],ymm7
 vmovupd [rdi+rax*8+$60],ymm9
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vmulpd ymm3,ymm0,[rdx+rax*8]
 vmulpd ymm4,ymm1,[rdx+rax*8]
 vpermilpd ymm4,ymm4,$5
 vaddsubpd ymm3,ymm3,ymm4
 vmovupd [rdi+rax*8],ymm3
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1
 vmovd  xmm2,r8d
 vpbroadcastq ymm2,xmm2
 vpcmpgtq ymm2,ymm2,[rip+ymmQ]
 vmaskmovpd ymm5,ymm2,[rdx+rax*8]
 vmulpd ymm3,ymm0,ymm5
 vmulpd ymm4,ymm1,ymm5
 vpermilpd ymm4,ymm4,$5
 vaddsubpd ymm3,ymm3,ymm4
 vmaskmovpd [rdi+rax*8],ymm2,ymm3
 @done:

end;

procedure bulkDiv_css(const dst, a, b:PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 vpbroadcastq ymm0, [rsi]
 vmovsldup ymm1,ymm0
 vmovshdup ymm2,ymm0
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovups ymm7,[rdx+rax*4]
 vmovsldup ymm3,ymm7
 vmovshdup ymm4,ymm7
 vmulps ymm3,ymm3,ymm3
 vfmadd231ps ymm3,ymm4,ymm4
 vmulps ymm5,ymm2,ymm7
 vmulps ymm6,ymm1,ymm7
 vpermilps ymm6,ymm6,$b1
 vaddsubps ymm7,ymm5,ymm6
 vpermilps ymm7,ymm7,$b1
 vdivps ymm8,ymm7,ymm3
 vmovups [rdi+rax*4],ymm8
 vmovups ymm7,[rdx+rax*4+$20]
 vmovsldup ymm3,ymm7
 vmovshdup ymm4,ymm7
 vmulps ymm3,ymm3,ymm3
 vfmadd231ps ymm3,ymm4,ymm4
 vmulps ymm5,ymm2,ymm7
 vmulps ymm6,ymm1,ymm7
 vpermilps ymm6,ymm6,$b1
 vaddsubps ymm7,ymm5,ymm6
 vpermilps ymm7,ymm7,$b1
 vdivps ymm8,ymm7,ymm3
 vmovups [rdi+rax*4+$20],ymm8
 vmovups ymm7,[rdx+rax*4+$40]
 vmovsldup ymm3,ymm7
 vmovshdup ymm4,ymm7
 vmulps ymm3,ymm3,ymm3
 vfmadd231ps ymm3,ymm4,ymm4
 vmulps ymm5,ymm2,ymm7
 vmulps ymm6,ymm1,ymm7
 vpermilps ymm6,ymm6,$b1
 vaddsubps ymm7,ymm5,ymm6
 vpermilps ymm7,ymm7,$b1
 vdivps ymm8,ymm7,ymm3
 vmovups [rdi+rax*4+$40],ymm8
 vmovups ymm7,[rdx+rax*4+$60]
 vmovsldup ymm3,ymm7
 vmovshdup ymm4,ymm7
 vmulps ymm3,ymm3,ymm3
 vfmadd231ps ymm3,ymm4,ymm4
 vmulps ymm5,ymm2,ymm7
 vmulps ymm6,ymm1,ymm7
 vpermilps ymm6,ymm6,$b1
 vaddsubps ymm7,ymm5,ymm6
 vpermilps ymm7,ymm7,$b1
 vdivps ymm8,ymm7,ymm3
 vmovups [rdi+rax*4+$60],ymm8
 add    rax,$20
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vmovups ymm7,[rdx+rax*4]
 vmovsldup ymm3,ymm7
 vmovshdup ymm4,ymm7
 vmulps ymm3,ymm3,ymm3
 vfmadd231ps ymm3,ymm4,ymm4
 vmulps ymm5,ymm2,ymm7
 vmulps ymm6,ymm1,ymm7
 vpermilps ymm6,ymm6,$b1
 vaddsubps ymm7,ymm5,ymm6
 vpermilps ymm7,ymm7,$b1
 vdivps ymm8,ymm7,ymm3
 vmovups [rdi+rax*4],ymm8
 add    rax,$8
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$3
 je     @done
 shl    r8d,1
 vmovd  xmm8,r8d
 vpbroadcastd ymm8,xmm8
 vpcmpgtd ymm8,ymm8,[rip+ymmD]
 vmaskmovps ymm7,ymm8,[rdx+rax*4]
 vmovsldup ymm3,ymm7
 vmovshdup ymm4,ymm7
 vmulps ymm3,ymm3,ymm3
 vfmadd231ps ymm3,ymm4,ymm4
 vmulps ymm5,ymm2,ymm7
 vmulps ymm6,ymm1,ymm7
 vpermilps ymm6,ymm6,$b1
 vaddsubps ymm7,ymm5,ymm6
 vpermilps ymm7,ymm7,$b1
 vdivps ymm0,ymm7,ymm3
 vmaskmovps [rdi+rax*4],ymm8,ymm0
 @done:
end;

procedure bulkDiv_csd(const dst, a, b:PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 vbroadcastf128 ymm0, [rsi]
 vmovddup ymm1,ymm0
 vpermilpd ymm2,ymm0,$f
 shr    ecx,$3
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm7,[rdx+rax*8]
 vmovddup ymm3,ymm7
 vpermilpd ymm4,ymm7,$f
 vmulpd ymm3,ymm3,ymm3
 vfmadd231pd ymm3,ymm4,ymm4
 vmulpd ymm5,ymm2,ymm7
 vmulpd ymm6,ymm1,ymm7
 vpermilpd ymm6,ymm6,$5
 vaddsubpd ymm7,ymm5,ymm6
 vpermilpd ymm7,ymm7,$5
 vdivpd ymm8,ymm7,ymm3
 vmovupd [rdi+rax*8],ymm8
 vmovupd ymm7,[rdx+rax*8+$20]
 vmovddup ymm3,ymm7
 vpermilpd ymm4,ymm7,$f
 vmulpd ymm3,ymm3,ymm3
 vfmadd231pd ymm3,ymm4,ymm4
 vmulpd ymm5,ymm2,ymm7
 vmulpd ymm6,ymm1,ymm7
 vpermilpd ymm6,ymm6,$5
 vaddsubpd ymm7,ymm5,ymm6
 vpermilpd ymm7,ymm7,$5
 vdivpd ymm8,ymm7,ymm3
 vmovupd [rdi+rax*8+$20],ymm8
 vmovupd ymm7,[rdx+rax*8+$40]
 vmovddup ymm3,ymm7
 vpermilpd ymm4,ymm7,$f
 vmulpd ymm3,ymm3,ymm3
 vfmadd231pd ymm3,ymm4,ymm4
 vmulpd ymm5,ymm2,ymm7
 vmulpd ymm6,ymm1,ymm7
 vpermilpd ymm6,ymm6,$5
 vaddsubpd ymm7,ymm5,ymm6
 vpermilpd ymm7,ymm7,$5
 vdivpd ymm8,ymm7,ymm3
 vmovupd [rdi+rax*8+$40],ymm8
 vmovupd ymm7,[rdx+rax*8+$60]
 vmovddup ymm3,ymm7
 vpermilpd ymm4,ymm7,$f
 vmulpd ymm3,ymm3,ymm3
 vfmadd231pd ymm3,ymm4,ymm4
 vmulpd ymm5,ymm2,ymm7
 vmulpd ymm6,ymm1,ymm7
 vpermilpd ymm6,ymm6,$5
 vaddsubpd ymm7,ymm5,ymm6
 vpermilpd ymm7,ymm7,$5
 vdivpd ymm8,ymm7,ymm3
 vmovupd [rdi+rax*8+$60],ymm8
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vmovupd ymm7,[rdx+rax*8]
 vmovddup ymm3,ymm7
 vpermilpd ymm4,ymm7,$f
 vmulpd ymm3,ymm3,ymm3
 vfmadd231pd ymm3,ymm4,ymm4
 vmulpd ymm5,ymm2,ymm7
 vmulpd ymm6,ymm1,ymm7
 vpermilpd ymm6,ymm6,$5
 vaddsubpd ymm7,ymm5,ymm6
 vpermilpd ymm7,ymm7,$5
 vdivpd ymm8,ymm7,ymm3
 vmovupd [rdi+rax*8],ymm8
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1
 vmovd  xmm8,r8d
 vpbroadcastq ymm8,xmm8
 vpcmpgtq ymm8,ymm8,[rip+ymmQ]
 vmaskmovpd ymm7,ymm8,[rdx+rax*8]
 vmovddup ymm3,ymm7
 vpermilpd ymm4,ymm7,$f
 vmulpd ymm3,ymm3,ymm3
 vfmadd231pd ymm3,ymm4,ymm4
 vmulpd ymm5,ymm2,ymm7
 vmulpd ymm6,ymm1,ymm7
 vpermilpd ymm6,ymm6,$5
 vaddsubpd ymm7,ymm5,ymm6
 vpermilpd ymm7,ymm7,$5
 vdivpd ymm0,ymm7,ymm3
 vmaskmovpd [rdi+rax*8],ymm8,ymm0
 @done:

end;

procedure bulkMul_ccs(const dst, a, b: PSingle; const Count: integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovsldup ymm1,[rdx+rax*4]
 vmovshdup ymm2,[rdx+rax*4]
 vmulps ymm1,ymm1,[rsi+rax*4]
 vmulps ymm2,ymm2,[rsi+rax*4]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm0,ymm1,ymm2
 vmovups [rdi+rax*4],ymm0
 vmovsldup ymm1,[rdx+rax*4+$20]
 vmovshdup ymm2,[rdx+rax*4+$20]
 vmulps ymm1,ymm1,[rsi+rax*4+$20]
 vmulps ymm2,ymm2,[rsi+rax*4+$20]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm0,ymm1,ymm2
 vmovups [rdi+rax*4+$20],ymm0
 vmovsldup ymm1,[rdx+rax*4+$40]
 vmovshdup ymm2,[rdx+rax*4+$40]
 vmulps ymm1,ymm1,[rsi+rax*4+$40]
 vmulps ymm2,ymm2,[rsi+rax*4+$40]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm0,ymm1,ymm2
 vmovups [rdi+rax*4+$40],ymm0
 vmovsldup ymm1,[rdx+rax*4+$60]
 vmovshdup ymm2,[rdx+rax*4+$60]
 vmulps ymm1,ymm1,[rsi+rax*4+$60]
 vmulps ymm2,ymm2,[rsi+rax*4+$60]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm0,ymm1,ymm2
 vmovups [rdi+rax*4+$60],ymm0
 add    rax,$20
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vmovsldup ymm1,[rdx+rax*4]
 vmovshdup ymm2,[rdx+rax*4]
 vmulps ymm1,ymm1,[rsi+rax*4]
 vmulps ymm2,ymm2,[rsi+rax*4]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm0,ymm1,ymm2
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$3
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm3,ymm0,[rip+ymmD]
 vmaskmovps ymm0,ymm3,[rsi+rax*4]
 vmovsldup ymm1,[rdx+rax*4]
 vmovshdup ymm2,[rdx+rax*4]
 vmulps ymm1,ymm1,ymm0
 vmulps ymm2,ymm2,ymm0
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm0,ymm1,ymm2
 vmaskmovps [rdi+rax*4],ymm3,ymm0
 @done:

end;

procedure bulkMul_cvs(const dst, re, b: PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vpermq ymm0,[rsi+rax*2],$50
 vpermilps ymm1,ymm0,$50
 vmulps ymm0,ymm1,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm0
 vpermq ymm2,[rsi+rax*2+$10],$50
 vpermilps ymm3,ymm2,$50
 vmulps ymm2,ymm3,[rdx+rax*4+$20]
 vmovups [rdi+rax*4+$20],ymm2
 vpermq ymm4,[rsi+rax*2+$20],$50
 vpermilps ymm5,ymm4,$50
 vmulps ymm4,ymm5,[rdx+rax*4+$40]
 vmovups [rdi+rax*4+$40],ymm4
 vpermq ymm6,[rsi+rax*2+$30],$50
 vpermilps ymm7,ymm6,$50
 vmulps ymm6,ymm7,[rdx+rax*4+$60]
 vmovups [rdi+rax*4+$60],ymm6
 add    rax,$20
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vpermq ymm0,[rsi+rax*2],$50
 vpermilps ymm1,ymm0,$50
 vmulps ymm1,ymm1,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm1
 add    rax,$8
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$3
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm3,ymm0,[rip+ymmD]
 vpermq ymm0,[rsi+rax*2],$50
 vpermilps ymm1,ymm0,$50
 vmulps ymm1,ymm1,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm3,ymm1
 @done:

end;

procedure bulkMul_cvd(const dst, re, b: PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$3
 je     @skipBulk

 @bulkLoop:
 vpermq ymm1,[rsi+rax*4],$50
 vmulpd ymm1,ymm1,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm1
 vpermq ymm2,[rsi+rax*4+$10],$50
 vmulpd ymm2,ymm2,[rdx+rax*8+$20]
 vmovupd [rdi+rax*8+$20],ymm2
 vpermq ymm3,[rsi+rax*4+$20],$50
 vmulpd ymm3,ymm3,[rdx+rax*8+$40]
 vmovupd [rdi+rax*8+$40],ymm3
 vpermq ymm4,[rsi+rax*4+$30],$50
 vmulpd ymm4,ymm4,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8+$60],ymm4
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vpermq ymm1,[rsi+rax*4],$50
 vmulpd ymm1,ymm1,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm1
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm3,ymm0,[rip+ymmQ]
 vpermq ymm1,[rsi+rax*4],$50
 vmulpd ymm1,ymm1,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm3,ymm1
 @done:
end;

procedure bulkDot_ccs(const dst, a, b: PSingle; const Count: integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 vxorps ymm0,ymm0,ymm0
 je     @skipBulk

 @bulkLoop:
 vmovsldup ymm1,[rdx+rax*4]
 vmovshdup ymm2,[rdx+rax*4]
 vmulps ymm2,ymm2,[rsi+rax*4]
 vmulps ymm1,ymm1,[rsi+rax*4]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm1,ymm1,ymm2
 vaddps ymm0,ymm0,ymm1
 vmovsldup ymm1,[rdx+rax*4+$20]
 vmovshdup ymm2,[rdx+rax*4+$20]
 vmulps ymm2,ymm2,[rsi+rax*4+$20]
 vmulps ymm1,ymm1,[rsi+rax*4+$20]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm1,ymm1,ymm2
 vaddps ymm0,ymm0,ymm1
 vmovsldup ymm1,[rdx+rax*4+$40]
 vmovshdup ymm2,[rdx+rax*4+$40]
 vmulps ymm2,ymm2,[rsi+rax*4+$40]
 vmulps ymm1,ymm1,[rsi+rax*4+$40]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm1,ymm1,ymm2
 vaddps ymm0,ymm0,ymm1
 vmovsldup ymm1,[rdx+rax*4+$60]
 vmovshdup ymm2,[rdx+rax*4+$60]
 vmulps ymm2,ymm2,[rsi+rax*4+$60]
 vmulps ymm1,ymm1,[rsi+rax*4+$60]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm1,ymm1,ymm2
 vaddps ymm0,ymm0,ymm1
 add    rax,$20
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vmovsldup ymm1,[rdx+rax*4]
 vmovshdup ymm2,[rdx+rax*4]
 vmulps ymm2,ymm2,[rsi+rax*4]
 vmulps ymm1,ymm1,[rsi+rax*4]
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm1,ymm1,ymm2
 vaddps ymm0,ymm0,ymm1
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
 vmaskmovps ymm4,ymm3,[rsi+rax*4]
 vmaskmovps ymm1,ymm3,[rdx+rax*4]
 vmaskmovps ymm2,ymm3,[rdx+rax*4]
 vmovsldup ymm1,ymm1
 vmovshdup ymm2,ymm2
 vmulps ymm2,ymm2,ymm4
 vmulps ymm1,ymm1,ymm4
 vpermilps ymm2,ymm2,$b1
 vaddsubps ymm1,ymm1,ymm2
 vaddps ymm0,ymm0,ymm1

 @done:
 vextractf128 xmm1,ymm0,$1
 addps  xmm0,xmm1
 movhlps xmm1,xmm0
 addps  xmm0,xmm1
 vmovlps QWORD PTR [rdi],xmm0
end;

procedure bulkDot_ccd(const dst, a, b: PDouble; const Count: integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$3
 vxorps ymm0,ymm0,ymm0
 je     @skipBulk

 @bulkLoop:
 vmovddup ymm1,[rdx+rax*8]
 vmovddup ymm2,[rdx+rax*8+$8]
 vmulpd ymm2,ymm2,[rsi+rax*8]
 vmulpd ymm1,ymm1,[rsi+rax*8]
 vpermpd ymm2,ymm2,$b1
 vaddsubpd ymm1,ymm1,ymm2
 vaddpd ymm0,ymm0,ymm1
 vmovddup ymm1,[rdx+rax*8+$20]
 vmovddup ymm2,[rdx+rax*8+$28]
 vmulpd ymm2,ymm2,[rsi+rax*8+$20]
 vmulpd ymm1,ymm1,[rsi+rax*8+$20]
 vpermpd ymm2,ymm2,$b1
 vaddsubpd ymm1,ymm1,ymm2
 vaddpd ymm0,ymm0,ymm1
 vmovddup ymm1,[rdx+rax*8+$40]
 vmovddup ymm2,[rdx+rax*8+$48]
 vmulpd ymm2,ymm2,[rsi+rax*8+$40]
 vmulpd ymm1,ymm1,[rsi+rax*8+$40]
 vpermpd ymm2,ymm2,$b1
 vaddsubpd ymm1,ymm1,ymm2
 vaddpd ymm0,ymm0,ymm1
 vmovddup ymm1,[rdx+rax*8+$60]
 vmovddup ymm2,[rdx+rax*8+$68]
 vmulpd ymm2,ymm2,[rsi+rax*8+$60]
 vmulpd ymm1,ymm1,[rsi+rax*8+$60]
 vpermpd ymm2,ymm2,$b1
 vaddsubpd ymm1,ymm1,ymm2
 vaddpd ymm0,ymm0,ymm1
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vmovddup ymm1,[rdx+rax*8]
 vmovddup ymm2,[rdx+rax*8+$8]
 vmulpd ymm2,ymm2,[rsi+rax*8]
 vmulpd ymm1,ymm1,[rsi+rax*8]
 vpermpd ymm2,ymm2,$b1
 vaddsubpd ymm1,ymm1,ymm2
 vaddpd ymm0,ymm0,ymm1
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm3,ymm1,[rip+ymmQ]
 vmaskmovpd ymm4,ymm3,[rsi+rax*8]
 vmaskmovpd ymm1,ymm3,[rdx+rax*8]
 vmaskmovpd ymm2,ymm3,[rdx+rax*8+$8]
 vmovddup ymm1,ymm1
 vmovddup ymm2,ymm2
 vmulpd ymm2,ymm2,ymm4
 vmulpd ymm1,ymm1,ymm4
 vpermpd ymm2,ymm2,$b1
 vaddsubpd ymm1,ymm1,ymm2
 vaddpd ymm0,ymm0,ymm1
 @done:
 vextractf128 xmm1,ymm0,$1
 addpd  xmm0,xmm1
 vmovups  [rdi],xmm0
end;

procedure bulkDot_cvs(const dst,re,b:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 vxorps ymm0,ymm0,ymm0
 vxorps ymm2,ymm2,ymm2
 vxorps ymm4,ymm4,ymm4
 vxorps ymm6,ymm6,ymm6
 je     @skipBulk

 @bulkLoop:
 vpermq ymm1,[rsi+rax*2],$50
 vpermq ymm3,[rsi+rax*2+$10],$50
 vpermq ymm5,[rsi+rax*2+$20],$50
 vpermq ymm7,[rsi+rax*2+$30],$50
 vpermilps ymm1,ymm1,$50
 vpermilps ymm3,ymm3,$50
 vpermilps ymm5,ymm5,$50
 vpermilps ymm7,ymm7,$50
 vfmadd231ps ymm0,ymm1,[rdx+rax*4]
 vfmadd231ps ymm2,ymm3,[rdx+rax*4+$20]
 vfmadd231ps ymm4,ymm5,[rdx+rax*4+$40]
 vfmadd231ps ymm6,ymm7,[rdx+rax*4+$60]
 add    rax,$20
 dec    ecx
 jg     @bulkLoop
 vaddps ymm0,ymm0,ymm2
 vaddps ymm4,ymm4,ymm6
 vaddps ymm0,ymm0,ymm4

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

procedure bulkDot_cvd(const dst,re,b:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(re^);  // complex of two singles
const rCnt=regSize div (sz*2);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*4;{(element count per register) X (number of bulk repeates)}
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$3
 vxorpd ymm0,ymm0,ymm0
 vxorpd ymm2,ymm2,ymm2
 vxorpd ymm4,ymm4,ymm4
 vxorpd ymm6,ymm6,ymm6
 je     @skipBulk

 @bulkLoop:
 vpermq ymm1,[rsi+rax*4],$50
 vpermq ymm3,[rsi+rax*4+$10],$50
 vpermq ymm5,[rsi+rax*4+$20],$50
 vpermq ymm7,[rsi+rax*4+$30],$50
 vfmadd231pd ymm0,ymm1,[rdx+rax*8]
 vfmadd231pd ymm2,ymm3,[rdx+rax*8+$20]
 vfmadd231pd ymm4,ymm5,[rdx+rax*8+$40]
 vfmadd231pd ymm6,ymm7,[rdx+rax*8+$60]
 add    rax,$10
 dec    ecx
 jg     @bulkLoop
 vaddpd ymm0,ymm0,ymm2
 vaddpd ymm4,ymm4,ymm6
 vaddpd ymm0,ymm0,ymm4

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vpermq ymm1,[rsi+rax*4],$50
 vfmadd231pd ymm0,ymm1,[rdx+rax*8]
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm1,r8d
 vpbroadcastq ymm1,xmm1
 vpcmpgtq ymm3,ymm1,[rip+ymmQ]
 vpermq ymm1,[rsi+rax*4],$50
 vmaskmovpd ymm2,ymm3,[rdx+rax*8]
 vfmadd231pd ymm0,ymm1,ymm2
 @done:
 vextractf128 xmm1,ymm0,$1
 addpd  xmm0,xmm1
 vmovupd  [rdi],xmm0
end;

procedure bulkAdd_ccs(const dst, a, b: PSingle; const Count: integer);nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 shl    ecx,1
 mov    r8d,ecx
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vmovups ymm1,[rsi+rax*4+$20]
 vmovups ymm2,[rsi+rax*4+$40]
 vmovups ymm3,[rsi+rax*4+$60]
 vaddps ymm0,ymm0,[rdx+rax*4]
 vaddps ymm1,ymm1,[rdx+rax*4+$20]
 vaddps ymm2,ymm2,[rdx+rax*4+$40]
 vaddps ymm3,ymm3,[rdx+rax*4+$60]
 vmovups [rdi+rax*4],ymm0
 vmovups [rdi+rax*4+$20],ymm1
 vmovups [rdi+rax*4+$40],ymm2
 vmovups [rdi+rax*4+$60],ymm3
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm0,[rsi+rax*4]
 vaddps ymm0,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm1,ymm0,[rip+ymmD]
 vmaskmovps ymm0,ymm1,[rsi+rax*4]
 vaddps ymm0,ymm0,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm1,ymm0
 @done:

end;

procedure bulkAdd_ccd(const dst, a, b: PDouble; const Count: integer);  nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
 xor    rax,rax
 shl    ecx,1
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmovupd ymm2,[rsi+rax*8+$40]
 vmovupd ymm3,[rsi+rax*8+$60]
 vaddpd ymm0,ymm0,[rdx+rax*8]
 vaddpd ymm1,ymm1,[rdx+rax*8+$20]
 vaddpd ymm2,ymm2,[rdx+rax*8+$40]
 vaddpd ymm3,ymm3,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm0,[rsi+rax*8]
 vaddpd ymm0,ymm0,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm1,ymm0,[rip+ymmQ]
 vmaskmovpd ymm0,ymm1,[rsi+rax*8]
 vaddpd ymm0,ymm0,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm1,ymm0
 @done:
end;

procedure bulkSub_ccs(const dst, a, b: PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 xor    rax,rax
 shl    ecx,1
 mov    r8d,ecx
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 vmovups ymm0,[rsi+rax*4]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm0
 vmovups ymm0,[rsi+rax*4+$20]
 vsubps ymm0,ymm0,[rdx+rax*4+$20]
 vmovups [rdi+rax*4+$20],ymm0
 vmovups ymm0,[rsi+rax*4+$40]
 vsubps ymm0,ymm0,[rdx+rax*4+$40]
 vmovups [rdi+rax*4+$40],ymm0
 vmovups ymm0,[rsi+rax*4+$60]
 vsubps ymm0,ymm0,[rdx+rax*4+$60]
 vmovups [rdi+rax*4+$60],ymm0
 add    rax,$20
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 vmovups ymm0,[rsi+rax*4]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$7
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm1,ymm0,[rip+ymmD]
 vmaskmovps ymm0,ymm1,[rsi+rax*4]
 vsubps ymm0,ymm0,[rdx+rax*4]
 vmaskmovps [rdi+rax*4],ymm1,ymm0
 @done:
end;

procedure bulkSub_ccd(const dst, a, b: PDouble; const Count: integer); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
 xor    rax,rax
 shl    ecx,1
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovupd ymm0,[rsi+rax*8]
 vmovupd ymm1,[rsi+rax*8+$20]
 vmovupd ymm2,[rsi+rax*8+$40]
 vmovupd ymm3,[rsi+rax*8+$60]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vsubpd ymm1,ymm1,[rdx+rax*8+$20]
 vsubpd ymm2,ymm2,[rdx+rax*8+$40]
 vsubpd ymm3,ymm3,[rdx+rax*8+$60]
 vmovupd [rdi+rax*8],ymm0
 vmovupd [rdi+rax*8+$20],ymm1
 vmovupd [rdi+rax*8+$40],ymm2
 vmovupd [rdi+rax*8+$60],ymm3
 add    rax,$10
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 vmovupd ymm0,[rsi+rax*8]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r8d,$3
 jle    @done
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm1,ymm0,[rip+ymmQ]
 vmaskmovpd ymm0,ymm1,[rsi+rax*8]
 vsubpd ymm0,ymm0,[rdx+rax*8]
 vmaskmovpd [rdi+rax*8],ymm1,ymm0
 @done:
end;

procedure bulkMul_ccd(const dst, a, b: PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$3
 je     @skipBulk

 @bulkLoop:
 vmovddup ymm1,[rdx+rax*8]
 vmovddup ymm2,[rdx+rax*8+$8]
 vmulpd ymm1,ymm1,[rsi+rax*8]
 vmulpd ymm2,ymm2,[rsi+rax*8]
 vpermilpd ymm2,ymm2,$5
 vaddsubpd ymm0,ymm1,ymm2
 vmovupd [rdi+rax*8],ymm0
 vmovddup ymm1,[rdx+rax*8+$20]
 vmovddup ymm2,[rdx+rax*8+$28]
 vmulpd ymm1,ymm1,[rsi+rax*8+$20]
 vmulpd ymm2,ymm2,[rsi+rax*8+$20]
 vpermilpd ymm2,ymm2,$5
 vaddsubpd ymm0,ymm1,ymm2
 vmovupd [rdi+rax*8+$20],ymm0
 vmovddup ymm1,[rdx+rax*8+$40]
 vmovddup ymm2,[rdx+rax*8+$48]
 vmulpd ymm1,ymm1,[rsi+rax*8+$40]
 vmulpd ymm2,ymm2,[rsi+rax*8+$40]
 vpermilpd ymm2,ymm2,$5
 vaddsubpd ymm0,ymm1,ymm2
 vmovupd [rdi+rax*8+$40],ymm0
 vmovddup ymm1,[rdx+rax*8+$60]
 vmovddup ymm2,[rdx+rax*8+$68]
 vmulpd ymm1,ymm1,[rsi+rax*8+$60]
 vmulpd ymm2,ymm2,[rsi+rax*8+$60]
 vpermilpd ymm2,ymm2,$5
 vaddsubpd ymm0,ymm1,ymm2
 vmovupd [rdi+rax*8+$60],ymm0
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vmovddup ymm1,[rdx+rax*8]
 vmovddup ymm2,[rdx+rax*8+$8]
 vmulpd ymm1,ymm1,[rsi+rax*8]
 vmulpd ymm2,ymm2,[rsi+rax*8]
 vpermilpd ymm2,ymm2,$5
 vaddsubpd ymm0,ymm1,ymm2
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm3,ymm0,[rip+ymmQ]
 vmaskmovpd ymm0,ymm3,[rsi+rax*8]
 vmovddup ymm1,[rdx+rax*8]
 vmovddup ymm2,[rdx+rax*8+$8]
 vmulpd ymm1,ymm1,ymm0
 vmulpd ymm2,ymm2,ymm0
 vpermilpd ymm2,ymm2,$5
 vaddsubpd ymm0,ymm1,ymm2
 vmaskmovpd [rdi+rax*8],ymm3,ymm0
 @done:
end;

procedure bulkDiv_ccs(const dst, a, b: PSingle; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 vmovsldup ymm0,[rsi+rax*4]
 vmovshdup ymm1,[rsi+rax*4]
 vmovsldup ymm2,[rdx+rax*4]
 vmovshdup ymm3,[rdx+rax*4]
 vmulps ymm2,ymm2,ymm2
 vfmadd231ps ymm2,ymm3,ymm3
 vmulps ymm4,ymm1,[rdx+rax*4]
 vmulps ymm5,ymm0,[rdx+rax*4]
 vpermilps ymm5,ymm5,$b1
 vaddsubps ymm6,ymm4,ymm5
 vpermilps ymm6,ymm6,$b1
 vdivps ymm0,ymm6,ymm2
 vmovups [rdi+rax*4],ymm0
 vmovsldup ymm0,[rsi+rax*4+$20]
 vmovshdup ymm1,[rsi+rax*4+$20]
 vmovsldup ymm2,[rdx+rax*4+$20]
 vmovshdup ymm3,[rdx+rax*4+$20]
 vmulps ymm2,ymm2,ymm2
 vfmadd231ps ymm2,ymm3,ymm3
 vmulps ymm4,ymm1,[rdx+rax*4+$20]
 vmulps ymm5,ymm0,[rdx+rax*4+$20]
 vpermilps ymm5,ymm5,$b1
 vaddsubps ymm6,ymm4,ymm5
 vpermilps ymm6,ymm6,$b1
 vdivps ymm0,ymm6,ymm2
 vmovups [rdi+rax*4+$20],ymm0
 vmovsldup ymm0,[rsi+rax*4+$40]
 vmovshdup ymm1,[rsi+rax*4+$40]
 vmovsldup ymm2,[rdx+rax*4+$40]
 vmovshdup ymm3,[rdx+rax*4+$40]
 vmulps ymm2,ymm2,ymm2
 vfmadd231ps ymm2,ymm3,ymm3
 vmulps ymm4,ymm1,[rdx+rax*4+$40]
 vmulps ymm5,ymm0,[rdx+rax*4+$40]
 vpermilps ymm5,ymm5,$b1
 vaddsubps ymm6,ymm4,ymm5
 vpermilps ymm6,ymm6,$b1
 vdivps ymm0,ymm6,ymm2
 vmovups [rdi+rax*4+$40],ymm0
 vmovsldup ymm0,[rsi+rax*4+$60]
 vmovshdup ymm1,[rsi+rax*4+$60]
 vmovsldup ymm2,[rdx+rax*4+$60]
 vmovshdup ymm3,[rdx+rax*4+$60]
 vmulps ymm2,ymm2,ymm2
 vfmadd231ps ymm2,ymm3,ymm3
 vmulps ymm4,ymm1,[rdx+rax*4+$60]
 vmulps ymm5,ymm0,[rdx+rax*4+$60]
 vpermilps ymm5,ymm5,$b1
 vaddsubps ymm6,ymm4,ymm5
 vpermilps ymm6,ymm6,$b1
 vdivps ymm0,ymm6,ymm2
 vmovups [rdi+rax*4+$60],ymm0
 add    rax,$20
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$f
 shr    ecx,$2
 je     @skipShort

 @remLoop:
 vmovsldup ymm0,[rsi+rax*4]
 vmovshdup ymm1,[rsi+rax*4]
 vmovsldup ymm2,[rdx+rax*4]
 vmovshdup ymm3,[rdx+rax*4]
 vmulps ymm2,ymm2,ymm2
 vfmadd231ps ymm2,ymm3,ymm3
 vmulps ymm4,ymm1,[rdx+rax*4]
 vmulps ymm5,ymm0,[rdx+rax*4]
 vpermilps ymm5,ymm5,$b1
 vaddsubps ymm6,ymm4,ymm5
 vpermilps ymm6,ymm6,$b1
 vdivps ymm0,ymm6,ymm2
 vmovups [rdi+rax*4],ymm0
 add    rax,$8
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$3
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm0,r8d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm7,ymm0,[rip+ymmD]
 vmaskmovps ymm8,ymm7,[rsi+rax*4]
 vmaskmovps ymm9,ymm7,[rdx+rax*4]
 vmovsldup ymm0,ymm8
 vmovshdup ymm1,ymm8
 vmovsldup ymm2,ymm9
 vmovshdup ymm3,ymm9
 vmulps ymm2,ymm2,ymm2
 vfmadd231ps ymm2,ymm3,ymm3
 vmulps ymm4,ymm1,ymm9
 vmulps ymm5,ymm0,ymm9
 vpermilps ymm5,ymm5,$b1
 vaddsubps ymm6,ymm4,ymm5
 vpermilps ymm6,ymm6,$b1
 vdivps ymm0,ymm6,ymm2
 vmaskmovps [rdi+rax*4],ymm7,ymm0
 @done:

end;

procedure bulkDiv_ccd(const dst, a, b: PDouble; const Count: integer); nf;
const regSize=$20 ;
const sz=SizeOf(a^);  // complex of two singles
const rCnt=regSize div (2*sz);{(element count per register ) = (ymm register size in byte) / (element size in byte "number unit size"[sizeof] X dimensions[2]) }
const stride=rCnt*2*4{(element count per register) X (elemet dimensions = 2 "real, imag" ) X (number of bulk repeates)};
const shifter=1;// log2(rCnt)
asm
 xor    rax,rax
 mov    r8d,ecx
 shr    ecx,$3
 je     @skipBulk

@bulkLoop:
 vmovddup ymm0,[rsi+rax*8]
 vmovddup ymm1,[rsi+rax*8+$8]
 vmovddup ymm2,[rdx+rax*8]
 vmovddup ymm3,[rdx+rax*8+$8]
 vmulpd ymm2,ymm2,ymm2
 vfmadd231pd ymm2,ymm3,ymm3
 vmulpd ymm4,ymm1,[rdx+rax*8]
 vmulpd ymm5,ymm0,[rdx+rax*8]
 vpermilpd ymm5,ymm5,$5
 vaddsubpd ymm6,ymm4,ymm5
 vpermilpd ymm6,ymm6,$5
 vdivpd ymm0,ymm6,ymm2
 vmovupd [rdi+rax*8],ymm0
 vmovddup ymm0,[rsi+rax*8+$20]
 vmovddup ymm1,[rsi+rax*8+$28]
 vmovddup ymm2,[rdx+rax*8+$20]
 vmovddup ymm3,[rdx+rax*8+$28]
 vmulpd ymm2,ymm2,ymm2
 vfmadd231pd ymm2,ymm3,ymm3
 vmulpd ymm4,ymm1,[rdx+rax*8+$20]
 vmulpd ymm5,ymm0,[rdx+rax*8+$20]
 vpermilpd ymm5,ymm5,$5
 vaddsubpd ymm6,ymm4,ymm5
 vpermilpd ymm6,ymm6,$5
 vdivpd ymm0,ymm6,ymm2
 vmovupd [rdi+rax*8+$20],ymm0
 vmovddup ymm0,[rsi+rax*8+$40]
 vmovddup ymm1,[rsi+rax*8+$48]
 vmovddup ymm2,[rdx+rax*8+$40]
 vmovddup ymm3,[rdx+rax*8+$48]
 vmulpd ymm2,ymm2,ymm2
 vfmadd231pd ymm2,ymm3,ymm3
 vmulpd ymm4,ymm1,[rdx+rax*8+$40]
 vmulpd ymm5,ymm0,[rdx+rax*8+$40]
 vpermilpd ymm5,ymm5,$5
 vaddsubpd ymm6,ymm4,ymm5
 vpermilpd ymm6,ymm6,$5
 vdivpd ymm0,ymm6,ymm2
 vmovupd [rdi+rax*8+$40],ymm0
 vmovddup ymm0,[rsi+rax*8+$60]
 vmovddup ymm1,[rsi+rax*8+$68]
 vmovddup ymm2,[rdx+rax*8+$60]
 vmovddup ymm3,[rdx+rax*8+$68]
 vmulpd ymm2,ymm2,ymm2
 vfmadd231pd ymm2,ymm3,ymm3
 vmulpd ymm4,ymm1,[rdx+rax*8+$60]
 vmulpd ymm5,ymm0,[rdx+rax*8+$60]
 vpermilpd ymm5,ymm5,$5
 vaddsubpd ymm6,ymm4,ymm5
 vpermilpd ymm6,ymm6,$5
 vdivpd ymm0,ymm6,ymm2
 vmovupd [rdi+rax*8+$60],ymm0
 add    rax,$10
 dec    ecx
 jg     @bulkLoop

 @skipBulk:
 mov    ecx,r8d
 and    ecx,$7
 shr    ecx,1
 je     @skipShort

 @remLoop:
 vmovddup ymm0,[rsi+rax*8]
 vmovddup ymm1,[rsi+rax*8+$8]
 vmovddup ymm2,[rdx+rax*8]
 vmovddup ymm3,[rdx+rax*8+$8]
 vmulpd ymm2,ymm2,ymm2
 vfmadd231pd ymm2,ymm3,ymm3
 vmulpd ymm4,ymm1,[rdx+rax*8]
 vmulpd ymm5,ymm0,[rdx+rax*8]
 vpermilpd ymm5,ymm5,$5
 vaddsubpd ymm6,ymm4,ymm5
 vpermilpd ymm6,ymm6,$5
 vdivpd ymm0,ymm6,ymm2
 vmovupd [rdi+rax*8],ymm0
 add    rax,$4
 dec    ecx
 jg     @remLoop

 @skipShort:
 and    r8d,$1
 je     @done
 shl    r8d,1

 @short:
 vmovd  xmm0,r8d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm7,ymm0,[rip+ymmQ]
 vmaskmovpd ymm8,ymm7,[rsi+rax*8]
 vmaskmovpd ymm9,ymm7,[rdx+rax*8]
 vmovddup ymm0,ymm8
 vpermpd ymm1,ymm8,$f5
 vmovddup ymm2,ymm9
 vpermpd ymm3,ymm9,$f5
 vmulpd ymm2,ymm2,ymm2
 vfmadd231pd ymm2,ymm3,ymm3
 vmulpd ymm4,ymm1,ymm9
 vmulpd ymm5,ymm0,ymm9
 vpermilpd ymm5,ymm5,$5
 vaddsubpd ymm6,ymm4,ymm5
 vpermilpd ymm6,ymm6,$5
 vdivpd ymm0,ymm6,ymm2
 vmaskmovpd [rdi+rax*8],ymm7,ymm0
 @done:

end;

procedure bulkConv_s(const dst,a,f:PSingle;const Count,K{Kernel Size}:Integer;const add:boolean); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;  // log2(rCnt)
asm
 sub    rcx,r8
 inc    rcx
 mov    r10d,ecx
 shr    ecx,$5
 je     @skipBulk

 @bulkLoop:
 mov    rax,r8
 vxorps ymm0,ymm0,ymm0
 vxorps ymm2,ymm2,ymm2
 vxorps ymm3,ymm3,ymm3
 vxorps ymm4,ymm4,ymm4

 @kernelLoop:
 dec    rax
 vbroadcastss ymm1,DWORD PTR [rdx+rax*4]
 vfmadd231ps ymm0,ymm1,[rsi+rax*4]
 vfmadd231ps ymm2,ymm1,[rsi+rax*4+$20]
 vfmadd231ps ymm3,ymm1,[rsi+rax*4+$40]
 vfmadd231ps ymm4,ymm1,[rsi+rax*4+$60]
 jne    @kernelLoop
 test   r9,$1
 je     @noAdd1
 vaddps ymm0,ymm0,[rdi]
 vaddps ymm2,ymm2,[rdi+$20]
 vaddps ymm3,ymm3,[rdi+$40]
 vaddps ymm4,ymm4,[rdi+$60]
 @noAdd1:
 vmovups [rdi],ymm0
 vmovups [rdi+$20],ymm2
 vmovups [rdi+$40],ymm3
 vmovups [rdi+$60],ymm4
 add    rsi,$80
 add    rdi,$80
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r10d
 and    ecx,$1f
 shr    ecx,$3
 jle    @skipShort

 @remLoop:
 mov    rax,r8
 vxorps ymm0,ymm0,ymm0

 @kernelLoop2:
 dec    rax
 vbroadcastss ymm1,DWORD PTR [rdx+rax*4]
 vfmadd231ps ymm0,ymm1,[rsi+rax*4]
 jne    @kernelLoop2
 test   r9,$1
 je     @noAdd2
 vaddps ymm0,ymm0,[rdi]
 @noAdd2:
 vmovups [rdi],ymm0
 add    rsi,$20
 add    rdi,$20
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r10d,$7
 jle    @done
 vmovd  xmm0,r10d
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm2,ymm0,[rip+ymmD]
 mov    rax,r8
 vxorps ymm0,ymm0,ymm0

 @kernelLoop3:
 dec    rax
 vbroadcastss ymm1,DWORD PTR [rdx+rax*4]
 vmaskmovps ymm3,ymm2,[rsi+rax*4]
 vfmadd231ps ymm0,ymm1,ymm3
 jne    @kernelLoop3
 test   r9,$1
 je     @noAdd3
 vmaskmovps ymm3,ymm2,[rdi]
 vaddps ymm0,ymm0,ymm3
 @noAdd3:
 vmaskmovps [rdi],ymm2,ymm0
 @done:
end;

procedure bulkConv_d(const dst,a,f:PDouble;const Count,K{Kernel Size}:Integer;const add:boolean); nf;
const regSize=$20;   //in bytes
const sz=SizeOf(a^); // element size in bytes
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;  // log2(rCnt)
asm
 sub    rcx,r8
 inc    rcx
 mov    r10d,ecx
 shr    ecx,$4
 je     @skipBulk

 @bulkLoop:
 mov    rax,r8
 vxorpd ymm0,ymm0,ymm0
 vxorpd ymm2,ymm2,ymm2
 vxorpd ymm3,ymm3,ymm3
 vxorpd ymm4,ymm4,ymm4

 @kernelLoop:
 dec    rax
 vbroadcastsd ymm1, [rdx+rax*8]
 vfmadd231pd ymm0,ymm1,[rsi+rax*8]
 vfmadd231pd ymm2,ymm1,[rsi+rax*8+$20]
 vfmadd231pd ymm3,ymm1,[rsi+rax*8+$40]
 vfmadd231pd ymm4,ymm1,[rsi+rax*8+$60]
 jne    @kernelLoop
 test   r9,$1
 je     @noAdd1
 vaddpd ymm0,ymm0,[rdi]
 vaddpd ymm2,ymm2,[rdi+$20]
 vaddpd ymm3,ymm3,[rdi+$40]
 vaddpd ymm4,ymm4,[rdi+$60]
 @noAdd1:
 vmovupd [rdi],ymm0
 vmovupd [rdi+$20],ymm2
 vmovupd [rdi+$40],ymm3
 vmovupd [rdi+$60],ymm4
 add    rsi,$80
 add    rdi,$80
 dec    ecx
 jne    @bulkLoop

 @skipBulk:
 mov    ecx,r10d
 and    ecx,$f
 shr    ecx,$2
 jle    @skipShort

 @remLoop:
 mov    rax,r8
 vxorpd ymm0,ymm0,ymm0

 @kernelLoop2:
 dec    rax
 vbroadcastsd ymm1, [rdx+rax*8]
 vfmadd231pd ymm0,ymm1,[rsi+rax*8]
 jne    @kernelLoop2
 test   r9,$1
 je     @noAdd2
 vaddpd ymm0,ymm0,[rdi]

 @noAdd2:
 vmovupd [rdi],ymm0
 add    rsi,$20
 add    rdi,$20
 dec    ecx
 jne    @remLoop

 @skipShort:
 and    r10d,$3
 jle    @done
 vmovd  xmm0,r10d
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm2,ymm0,[rip+ymmQ]
 mov    rax,r8
 vxorpd ymm0,ymm0,ymm0

 @kernelLoop3:
 dec    rax
 vbroadcastsd ymm1, [rdx+rax*8]
 vmaskmovpd ymm3,ymm2,[rsi+rax*8]
 vfmadd231pd ymm0,ymm1,ymm3
 jne    @kernelLoop3
 test   r9,$1
 je     @noAdd3
 vmaskmovpd ymm3,ymm2,[rdi]
 vaddpd ymm0,ymm0,ymm3

 @noAdd3:
 vmaskmovpd [rdi],ymm2,ymm0
 @done:
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

procedure mul_ccs(const dst, a, b: PSingle); nf;
asm
 vmovsldup xmm1, [rdx]
 vmovshdup xmm2, [rdx]
 vmulps xmm2,xmm2, [rsi]
 vmulps xmm1,xmm1, [rsi]
 vpermilps xmm2,xmm2,$b1
 vaddsubps xmm0,xmm1,xmm2
 vmovlps QWORD PTR [rdi],xmm0
end;

procedure mul_ccd(const dst, a, b: PDouble); nf;
asm
 vmovddup xmm1, [rdx]
 vmovddup xmm2, [rdx+$8]
 vmulpd xmm2,xmm2, [rsi]
 vmulpd xmm1,xmm1, [rsi]
 vpermilpd xmm2,xmm2,$5
 vaddsubpd xmm0,xmm1,xmm2
 vmovlpd QWORD PTR [rdi],xmm0
end;

procedure kahanSum_s(const dst, x:PSingle;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=3;// log2(rCnt)
asm
 vpxor  ymm11,ymm11,ymm11
 vpxor  ymm12,ymm12,ymm12
 mov    ecx,edx
 shr    ecx, shifter
 je     @skipShort

 @shortLoop:
 vmovups ymm13,[rsi]
 vsubps ymm13,ymm13,ymm12
 vaddps ymm14,ymm13,ymm11
 vsubps ymm15,ymm14,ymm11
 vsubps ymm12,ymm15,ymm13
 vmovaps ymm11,ymm14
 add    rsi,$20
 dec    ecx
 jne    @shortLoop

 @skipShort:
 mov    ecx,edx
 and    ecx,$7
 je     @done
 vpxor  ymm13,ymm13,ymm13
 vmovd  xmm0,ecx
 vpbroadcastd ymm0,xmm0
 vpcmpgtd ymm0,ymm0,[rip+ymmD]
 vmaskmovps ymm13,ymm0,[rsi]
 vsubps ymm13,ymm13,ymm12
 vaddps ymm14,ymm13,ymm11
 vsubps ymm15,ymm14,ymm11
 vsubps ymm12,ymm15,ymm13
 vmovaps ymm11,ymm14
 @done:
 vextractf128 xmm12,ymm11,$1
 vzeroupper 
 vaddps xmm11,xmm11,xmm12
 vhaddps xmm11,xmm11,xmm11
 vhaddps xmm11,xmm11,xmm11
 vmovss DWORD PTR [rdi],xmm11
end;

procedure kahanSum_d(const dst, x:PDouble;const Count:integer);nf;
const regSize=$20 ;
const sz=SizeOf(x^);
const rCnt=regSize div sz;{(element count per register) = (ymm register size in byte) / (element size in byte) }
const stride=rCnt*4{(element count per register) X (number of bulk repeates)};
const shifter=2;// log2(rCnt)
asm
 vpxor  ymm11,ymm11,ymm11
 vpxor  ymm12,ymm12,ymm12
 mov    ecx,edx
 shr    ecx, shifter
 je     @skipShort

 @shortLoop:
 vmovupd ymm13,[rsi]
 vsubpd ymm13,ymm13,ymm12
 vaddpd ymm14,ymm13,ymm11
 vsubpd ymm15,ymm14,ymm11
 vsubpd ymm12,ymm15,ymm13
 vmovapd ymm11,ymm14
 add    rsi,$20
 dec    ecx
 jne    @shortLoop

 @skipShort:
 mov    ecx,edx
 and    ecx,$3
 je     @done
 vpxor  ymm13,ymm13,ymm13
 vmovd  xmm0,ecx
 vpbroadcastq ymm0,xmm0
 vpcmpgtq ymm0,ymm0,[rip+ymmQ]
 vmaskmovpd ymm13,ymm0,[rsi]
 vsubpd ymm13,ymm13,ymm12
 vaddpd ymm14,ymm13,ymm11
 vsubpd ymm15,ymm14,ymm11
 vsubpd ymm12,ymm15,ymm13
 vmovapd ymm11,ymm14

 @done:
 vextractf128 xmm12,ymm11,$1
 vzeroupper 
 vaddpd xmm11,xmm11,xmm12
 vhaddpd xmm11,xmm11,xmm11
 vmovsd QWORD PTR [rdi],xmm11
end;

procedure bulkMulSplit_ccs(const dst,ds2,re,r2,im,i2:PSingle;const N:integer);nf;
asm
  xor                 rax,   rax
  mov                 r10d,   N
  shr                 r10d,   3
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
  and                 N,      8-1
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


end.
