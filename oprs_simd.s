# Begin asmlist al_pure_assembler

.text
	.align 3
.globl	_OPRS_SIMD_$$_INTERLEAVE_S$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_INTERLEAVE_S$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj21
Lj22:
	vinsertf128	$0,(%rdx,%rax,2),%ymm0,%ymm0
	vinsertf128	$0,16(%rdx,%rax,2),%ymm1,%ymm1
	vinsertf128	$1,32(%rdx,%rax,2),%ymm0,%ymm0
	vinsertf128	$1,48(%rdx,%rax,2),%ymm1,%ymm1
	vshufps	$136,%ymm1,%ymm0,%ymm2
	vshufps	$221,%ymm1,%ymm0,%ymm3
	vmovups	%ymm2,(%rdi,%rax,1)
	vmovups	%ymm3,(%rsi,%rax,1)
	addq	$32,%rax
	decl	%ecx
	jg	Lj22
Lj21:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$1,%ecx
	jz	Lj23
Lj24:
	movl	(%rdx),%r8d
	movl	4(%rdx),%eax
	movl	%r8d,(%rdi)
	movl	%eax,(%rsi)
	addq	$4,%rdi
	addq	$4,%rsi
	addq	$8,%rdx
	decl	%ecx
	jnz	Lj24
Lj23:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_INTERLEAVE_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_INTERLEAVE_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	movl	%ecx,%r8d
	shrl	$3,%ecx
	jz	Lj27
Lj28:
	vinsertf128	$0,(%rdx),%ymm0,%ymm0
	vinsertf128	$1,32(%rdx),%ymm0,%ymm0
	vinsertf128	$0,16(%rdx),%ymm1,%ymm1
	vinsertf128	$1,48(%rdx),%ymm1,%ymm1
	vshufpd	$0,%ymm1,%ymm0,%ymm2
	vshufpd	$15,%ymm1,%ymm0,%ymm3
	vmovupd	%ymm2,(%rdi)
	vmovupd	%ymm3,(%rsi)
	addq	$64,%rdx
	addq	$32,%rdi
	addq	$32,%rsi
	decl	%ecx
	jg	Lj28
Lj27:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj29
Lj30:
	vmovsd	(%rdx),%xmm0
	vmovsd	8(%rdx),%xmm1
	vmovsd	%xmm0,(%rdi)
	vmovsd	%xmm1,(%rsi)
	addq	$8,%rdi
	addq	$8,%rsi
	addq	$16,%rdx
	decl	%ecx
	jnz	Lj30
Lj29:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDOT_S$PSINGLE$PSINGLE$LONGINT$$SINGLE
_OPRS_SIMD_$$_BULKDOT_S$PSINGLE$PSINGLE$LONGINT$$SINGLE:
#  CPU ATHLON64
	xorq	%rax,%rax
	vpxor	%ymm0,%ymm0,%ymm0
	vpxor	%ymm2,%ymm2,%ymm2
	vpxor	%ymm4,%ymm4,%ymm4
	vpxor	%ymm6,%ymm6,%ymm6
	movl	%edx,%ecx
	shrl	$5,%ecx
	jz	Lj33
Lj34:
	vmovups	(%rdi,%rax,4),%ymm1
	vmovups	32(%rdi,%rax,4),%ymm3
	vmovups	64(%rdi,%rax,4),%ymm5
	vmovups	96(%rdi,%rax,4),%ymm7
	vfmadd231ps	(%rsi,%rax,4),%ymm1,%ymm0
	vfmadd231ps	32(%rsi,%rax,4),%ymm3,%ymm2
	vfmadd231ps	64(%rsi,%rax,4),%ymm5,%ymm4
	vfmadd231ps	96(%rsi,%rax,4),%ymm7,%ymm6
	addq	$32,%rax
	decl	%ecx
	jnz	Lj34
	vaddps	%ymm2,%ymm0,%ymm0
	vaddps	%ymm6,%ymm4,%ymm4
	vaddps	%ymm4,%ymm0,%ymm0
Lj33:
	movl	%edx,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj35
Lj36:
	vmovups	(%rdi,%rax,4),%ymm1
	vfmadd231ps	(%rsi,%rax,4),%ymm1,%ymm0
	addq	$8,%rax
	decl	%ecx
	jnz	Lj36
Lj35:
	andl	$7,%edx
	jz	Lj37
	vmovd	%edx,%xmm3
	vpbroadcastd	%xmm3,%ymm3
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm3,%ymm3
	vmaskmovps	(%rdi,%rax,4),%ymm3,%ymm1
	vfmadd231ps	(%rsi,%rax,4),%ymm1,%ymm0
Lj37:
	vextractf128	$1,%ymm0,%xmm1
	vaddps	%xmm1,%xmm0,%xmm0
	vhaddps	%xmm0,%xmm0,%xmm0
	vhaddps	%xmm0,%xmm0,%xmm0
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDOT_S$PSINGLE$PSINGLE$LONGINT$LONGINT$$SINGLE
_OPRS_SIMD_$$_BULKDOT_S$PSINGLE$PSINGLE$LONGINT$LONGINT$$SINGLE:
#  CPU ATHLON64
	movl	%ecx,%r8d
	vmovd	%edx,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpmulld	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm1
	imulq	$32,%rdx
	vxorps	%ymm0,%ymm0,%ymm0
	shrl	$5,%ecx
	jz	Lj40
	vxorps	%ymm7,%ymm7,%ymm7
	vxorps	%ymm8,%ymm8,%ymm8
	vxorps	%ymm9,%ymm9,%ymm9
Lj41:
	vpcmpeqd	%ymm2,%ymm2,%ymm2
	vgatherdps	%ymm2,(%rsi,%ymm1,4),%ymm3
	leaq	(%rsi,%rdx,1),%rsi
	vpcmpeqd	%ymm2,%ymm2,%ymm2
	vgatherdps	%ymm2,(%rsi,%ymm1,4),%ymm4
	leaq	(%rsi,%rdx,1),%rsi
	vpcmpeqd	%ymm2,%ymm2,%ymm2
	vgatherdps	%ymm2,(%rsi,%ymm1,4),%ymm5
	leaq	(%rsi,%rdx,1),%rsi
	vpcmpeqd	%ymm2,%ymm2,%ymm2
	vgatherdps	%ymm2,(%rsi,%ymm1,4),%ymm6
	leaq	(%rsi,%rdx,1),%rsi
	vfmadd231ps	(%rdi),%ymm3,%ymm0
	vfmadd231ps	32(%rdi),%ymm4,%ymm7
	vfmadd231ps	64(%rdi),%ymm5,%ymm8
	vfmadd231ps	96(%rdi),%ymm6,%ymm9
	addq	$128,%rdi
	decl	%ecx
	jnz	Lj41
	vaddps	%ymm0,%ymm7,%ymm0
	vaddps	%ymm8,%ymm9,%ymm8
	vaddps	%ymm8,%ymm0,%ymm0
Lj40:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jz	Lj42
Lj43:
	vpcmpeqd	%ymm2,%ymm2,%ymm2
	vgatherdps	%ymm2,(%rsi,%ymm1,4),%ymm3
	vfmadd231ps	(%rdi),%ymm3,%ymm0
	leaq	(%rsi,%rdx,1),%rsi
	addq	$32,%rdi
	decl	%ecx
	jnz	Lj43
Lj42:
	andl	$7,%r8d
	jz	Lj44
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rdi),%ymm2,%ymm4
	vgatherdps	%ymm2,(%rsi,%ymm1,4),%ymm3
	vfmadd231ps	%ymm4,%ymm3,%ymm0
Lj44:
	vextractf128	$1,%ymm0,%xmm1
	vaddps	%xmm1,%xmm0,%xmm0
	vhaddps	%xmm0,%xmm0,%xmm0
	vhaddps	%xmm0,%xmm0,%xmm0
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDOT_D$PDOUBLE$PDOUBLE$LONGINT$$DOUBLE
_OPRS_SIMD_$$_BULKDOT_D$PDOUBLE$PDOUBLE$LONGINT$$DOUBLE:
#  CPU ATHLON64
	xorq	%rax,%rax
	vxorpd	%ymm0,%ymm0,%ymm0
	vxorpd	%ymm2,%ymm2,%ymm2
	vxorpd	%ymm4,%ymm4,%ymm4
	vxorpd	%ymm6,%ymm6,%ymm6
	movl	%edx,%ecx
	shrl	$4,%ecx
	jz	Lj47
Lj48:
	vmovupd	(%rdi,%rax,8),%ymm1
	vmovupd	32(%rdi,%rax,8),%ymm3
	vmovupd	64(%rdi,%rax,8),%ymm5
	vmovupd	96(%rdi,%rax,8),%ymm7
	vfmadd231pd	(%rsi,%rax,8),%ymm1,%ymm0
	vfmadd231pd	32(%rsi,%rax,8),%ymm3,%ymm2
	vfmadd231pd	64(%rsi,%rax,8),%ymm5,%ymm4
	vfmadd231pd	96(%rsi,%rax,8),%ymm7,%ymm6
	addq	$16,%rax
	decl	%ecx
	jnz	Lj48
	vaddpd	%ymm2,%ymm0,%ymm0
	vaddpd	%ymm6,%ymm4,%ymm4
	vaddpd	%ymm4,%ymm0,%ymm0
Lj47:
	movl	%edx,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj49
Lj50:
	vmovupd	(%rdi,%rax,8),%ymm1
	vfmadd231pd	(%rsi,%rax,8),%ymm1,%ymm0
	addq	$4,%rax
	decl	%ecx
	jnz	Lj50
Lj49:
	andl	$3,%edx
	jz	Lj51
	vmovd	%edx,%xmm3
	vpbroadcastq	%xmm3,%ymm3
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm3,%ymm3
	vmaskmovpd	(%rdi,%rax,8),%ymm3,%ymm1
	vfmadd231pd	(%rsi,%rax,8),%ymm1,%ymm0
Lj51:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vaddpd	%xmm1,%xmm0,%xmm0
	vhaddpd	%xmm0,%xmm0,%xmm0
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDOT_D$PDOUBLE$PDOUBLE$LONGINT$LONGINT$$DOUBLE
_OPRS_SIMD_$$_BULKDOT_D$PDOUBLE$PDOUBLE$LONGINT$LONGINT$$DOUBLE:
#  CPU ATHLON64
	movl	%ecx,%r8d
	vmovd	%edx,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpmulld	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm1
	imulq	$32,%rdx
	vxorps	%ymm0,%ymm0,%ymm0
	shrl	$4,%ecx
	jz	Lj54
	vxorpd	%ymm7,%ymm7,%ymm7
	vxorpd	%ymm8,%ymm8,%ymm8
	vxorpd	%ymm9,%ymm9,%ymm9
Lj55:
	vpcmpeqq	%ymm2,%ymm2,%ymm2
	vgatherdpd	%ymm2,(%rsi,%xmm1,8),%ymm3
	leaq	(%rsi,%rdx,1),%rsi
	vpcmpeqq	%ymm2,%ymm2,%ymm2
	vgatherdpd	%ymm2,(%rsi,%xmm1,8),%ymm4
	leaq	(%rsi,%rdx,1),%rsi
	vpcmpeqq	%ymm2,%ymm2,%ymm2
	vgatherdpd	%ymm2,(%rsi,%xmm1,8),%ymm5
	leaq	(%rsi,%rdx,1),%rsi
	vpcmpeqq	%ymm2,%ymm2,%ymm2
	vgatherdpd	%ymm2,(%rsi,%xmm1,8),%ymm6
	leaq	(%rsi,%rdx,1),%rsi
	vfmadd231pd	(%rdi),%ymm3,%ymm0
	vfmadd231pd	32(%rdi),%ymm4,%ymm7
	vfmadd231pd	64(%rdi),%ymm5,%ymm8
	vfmadd231pd	96(%rdi),%ymm6,%ymm9
	addq	$128,%rdi
	decl	%ecx
	jnz	Lj55
	vaddpd	%ymm0,%ymm7,%ymm0
	vaddpd	%ymm8,%ymm9,%ymm8
	vaddpd	%ymm8,%ymm0,%ymm0
Lj54:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj56
Lj57:
	vpcmpeqq	%ymm2,%ymm2,%ymm2
	vgatherdpd	%ymm2,(%rsi,%xmm1,8),%ymm3
	vfmadd231pd	(%rdi),%ymm3,%ymm0
	leaq	(%rsi,%rdx,1),%rsi
	addq	$32,%rdi
	decl	%ecx
	jnz	Lj57
Lj56:
	andl	$3,%r8d
	jz	Lj58
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm2
	vmaskmovpd	(%rdi),%ymm2,%ymm4
	vgatherdpd	%ymm2,(%rsi,%xmm1,8),%ymm3
	vfmadd231pd	%ymm4,%ymm3,%ymm0
Lj58:
	vextractf128	$1,%ymm0,%xmm1
	vaddpd	%xmm1,%xmm0,%xmm0
	vhaddpd	%xmm0,%xmm0,%xmm0
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKADD_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKADD_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	vbroadcastss	(%rdx),%ymm0
	jz	Lj61
Lj62:
	vaddps	(%rsi,%rax,4),%ymm0,%ymm1
	vaddps	32(%rsi,%rax,4),%ymm0,%ymm2
	vaddps	64(%rsi,%rax,4),%ymm0,%ymm3
	vaddps	96(%rsi,%rax,4),%ymm0,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj62
Lj61:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj63
Lj64:
	vaddps	(%rsi,%rax,4),%ymm0,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj64
Lj63:
	andl	$7,%r8d
	jle	Lj65
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm2
	vaddps	(%rsi,%rax,4),%ymm0,%ymm1
	vmaskmovps	%ymm1,%ymm2,(%rdi,%rax,4)
Lj65:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUB_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKSUB_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	vbroadcastss	(%rdx),%ymm0
	jz	Lj68
Lj69:
	vsubps	(%rsi,%rax,4),%ymm0,%ymm1
	vsubps	32(%rsi,%rax,4),%ymm0,%ymm2
	vsubps	64(%rsi,%rax,4),%ymm0,%ymm3
	vsubps	96(%rsi,%rax,4),%ymm0,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj69
Lj68:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj70
Lj71:
	vsubps	(%rsi,%rax,4),%ymm0,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj71
Lj70:
	andl	$7,%r8d
	jle	Lj72
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm2
	vsubps	(%rsi,%rax,4),%ymm0,%ymm1
	vmaskmovps	%ymm1,%ymm2,(%rdi,%rax,4)
Lj72:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	vbroadcastss	(%rdx),%ymm0
	jz	Lj75
Lj76:
	vmulps	(%rsi,%rax,4),%ymm0,%ymm1
	vmulps	32(%rsi,%rax,4),%ymm0,%ymm2
	vmulps	64(%rsi,%rax,4),%ymm0,%ymm3
	vmulps	96(%rsi,%rax,4),%ymm0,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj76
Lj75:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj77
Lj78:
	vmulps	(%rsi,%rax,4),%ymm0,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj78
Lj77:
	andl	$7,%r8d
	jle	Lj79
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm2
	vmulps	(%rsi,%rax,4),%ymm0,%ymm1
	vmaskmovps	%ymm1,%ymm2,(%rdi,%rax,4)
Lj79:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIV_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKDIV_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	vbroadcastss	(%rdx),%ymm0
	jz	Lj82
Lj83:
	vdivps	(%rsi,%rax,4),%ymm0,%ymm1
	vdivps	32(%rsi,%rax,4),%ymm0,%ymm2
	vdivps	64(%rsi,%rax,4),%ymm0,%ymm3
	vdivps	96(%rsi,%rax,4),%ymm0,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj83
Lj82:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj84
Lj85:
	vdivps	(%rsi,%rax,4),%ymm0,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj85
Lj84:
	andl	$7,%r8d
	jle	Lj86
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm2
	vdivps	(%rsi,%rax,4),%ymm0,%ymm1
	vmaskmovps	%ymm1,%ymm2,(%rdi,%rax,4)
Lj86:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKADD_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKADD_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	vbroadcastsd	(%rdx),%ymm0
	jz	Lj89
Lj90:
	vaddpd	(%rsi,%rax,8),%ymm0,%ymm1
	vaddpd	32(%rsi,%rax,8),%ymm0,%ymm2
	vaddpd	64(%rsi,%rax,8),%ymm0,%ymm3
	vaddpd	96(%rsi,%rax,8),%ymm0,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj90
Lj89:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj91
Lj92:
	vaddpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj92
Lj91:
	andl	$3,%r8d
	jle	Lj93
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm2
	vaddpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmaskmovpd	%ymm1,%ymm2,(%rdi,%rax,8)
Lj93:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUB_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKSUB_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	vbroadcastsd	(%rdx),%ymm0
	jz	Lj96
Lj97:
	vsubpd	(%rsi,%rax,8),%ymm0,%ymm1
	vsubpd	32(%rsi,%rax,8),%ymm0,%ymm2
	vsubpd	64(%rsi,%rax,8),%ymm0,%ymm3
	vsubpd	96(%rsi,%rax,8),%ymm0,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj97
Lj96:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj98
Lj99:
	vsubpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj99
Lj98:
	andl	$3,%r8d
	jle	Lj100
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm2
	vsubpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmaskmovpd	%ymm1,%ymm2,(%rdi,%rax,8)
Lj100:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	vbroadcastsd	(%rdx),%ymm0
	jz	Lj103
Lj104:
	vmulpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmulpd	32(%rsi,%rax,8),%ymm0,%ymm2
	vmulpd	64(%rsi,%rax,8),%ymm0,%ymm3
	vmulpd	96(%rsi,%rax,8),%ymm0,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj104
Lj103:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj105
Lj106:
	vmulpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj106
Lj105:
	andl	$3,%r8d
	jle	Lj107
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm2
	vmulpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmaskmovpd	%ymm1,%ymm2,(%rdi,%rax,8)
Lj107:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIV_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKDIV_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	vbroadcastsd	(%rdx),%ymm0
	jz	Lj110
Lj111:
	vdivpd	(%rsi,%rax,8),%ymm0,%ymm1
	vdivpd	32(%rsi,%rax,8),%ymm0,%ymm2
	vdivpd	64(%rsi,%rax,8),%ymm0,%ymm3
	vdivpd	96(%rsi,%rax,8),%ymm0,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj111
Lj110:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj112
Lj113:
	vdivpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj113
Lj112:
	andl	$3,%r8d
	jle	Lj114
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm2
	vmaskmovpd	(%rsi,%rax,8),%ymm2,%ymm1
	vdivpd	%ymm1,%ymm0,%ymm1
	vmaskmovpd	%ymm1,%ymm2,(%rdi,%rax,8)
Lj114:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKAXPY_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$PSINGLE
_OPRS_SIMD_$$_BULKAXPY_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$PSINGLE:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r9d
	vbroadcastss	(%r8),%ymm0
	shrl	$5,%ecx
	jz	Lj117
Lj118:
	vmulps	(%rsi,%rax,4),%ymm0,%ymm1
	vmulps	32(%rsi,%rax,4),%ymm0,%ymm2
	vmulps	64(%rsi,%rax,4),%ymm0,%ymm3
	vmulps	96(%rsi,%rax,4),%ymm0,%ymm4
	vaddps	(%rdx,%rax,4),%ymm1,%ymm1
	vaddps	32(%rdx,%rax,4),%ymm2,%ymm2
	vaddps	64(%rdx,%rax,4),%ymm3,%ymm3
	vaddps	96(%rdx,%rax,4),%ymm4,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj118
Lj117:
	movl	%r9d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj119
Lj120:
	vmulps	(%rsi,%rax,4),%ymm0,%ymm1
	vaddps	(%rdx,%rax,4),%ymm1,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj120
Lj119:
	andl	$7,%r9d
	jle	Lj121
	vmovd	%r9d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rsi,%rax,4),%ymm2,%ymm1
	vmulps	%ymm1,%ymm0,%ymm1
	vaddps	(%rdx,%rax,4),%ymm1,%ymm1
	vmaskmovps	%ymm1,%ymm2,(%rdi,%rax,4)
Lj121:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKAXPY_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$PDOUBLE
_OPRS_SIMD_$$_BULKAXPY_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$PDOUBLE:
#  CPU ATHLON64
	xorq	%rax,%rax
	vxorpd	%ymm1,%ymm1,%ymm1
	movl	%ecx,%r9d
	vbroadcastsd	(%r8),%ymm0
	shrl	$4,%ecx
	jz	Lj124
Lj125:
	vmulpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmulpd	32(%rsi,%rax,8),%ymm0,%ymm2
	vmulpd	64(%rsi,%rax,8),%ymm0,%ymm3
	vmulpd	96(%rsi,%rax,8),%ymm0,%ymm4
	vaddpd	(%rdx,%rax,8),%ymm1,%ymm1
	vaddpd	32(%rdx,%rax,8),%ymm2,%ymm2
	vaddpd	64(%rdx,%rax,8),%ymm3,%ymm3
	vaddpd	96(%rdx,%rax,8),%ymm4,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj125
Lj124:
	movl	%r9d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj126
Lj127:
	vmovupd	(%rsi,%rax,8),%ymm1
	vmulpd	%ymm1,%ymm0,%ymm1
	vaddpd	(%rdx,%rax,8),%ymm1,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj127
Lj126:
	andl	$3,%r9d
	jle	Lj128
	vmovd	%r9d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm2
	vmaskmovpd	(%rsi,%rax,8),%ymm2,%ymm1
	vmulpd	%ymm1,%ymm0,%ymm1
	vaddpd	(%rdx,%rax,8),%ymm1,%ymm1
	vmaskmovpd	%ymm1,%ymm2,(%rdi,%rax,8)
Lj128:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKAXPBY_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$PSINGLE$PSINGLE
_OPRS_SIMD_$$_BULKAXPBY_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$PSINGLE$PSINGLE:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r10d
	vbroadcastss	(%r8),%ymm0
	vbroadcastss	(%r9),%ymm5
	shrl	$5,%ecx
	jz	Lj131
Lj132:
	vmulps	(%rsi,%rax,4),%ymm0,%ymm1
	vmulps	32(%rsi,%rax,4),%ymm0,%ymm2
	vmulps	64(%rsi,%rax,4),%ymm0,%ymm3
	vmulps	96(%rsi,%rax,4),%ymm0,%ymm4
	vfmadd231ps	(%rdx,%rax,4),%ymm5,%ymm1
	vfmadd231ps	32(%rdx,%rax,4),%ymm5,%ymm2
	vfmadd231ps	64(%rdx,%rax,4),%ymm5,%ymm3
	vfmadd231ps	96(%rdx,%rax,4),%ymm5,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj132
Lj131:
	movl	%r10d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj133
Lj134:
	vmulps	(%rsi,%rax,4),%ymm0,%ymm1
	vfmadd231ps	(%rdx,%rax,4),%ymm5,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj134
Lj133:
	andl	$7,%r10d
	jle	Lj135
	vmovd	%r10d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rsi,%rax,4),%ymm2,%ymm1
	vmulps	%ymm1,%ymm0,%ymm1
	vfmadd231ps	(%rdx,%rax,4),%ymm5,%ymm1
	vmaskmovps	%ymm1,%ymm2,(%rdi,%rax,4)
Lj135:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKAXPBY_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$PDOUBLE$PDOUBLE
_OPRS_SIMD_$$_BULKAXPBY_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$PDOUBLE$PDOUBLE:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r10d
	vbroadcastsd	(%r8),%ymm0
	vbroadcastsd	(%r9),%ymm5
	shrl	$4,%ecx
	jz	Lj138
Lj139:
	vmulpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmulpd	32(%rsi,%rax,8),%ymm0,%ymm2
	vmulpd	64(%rsi,%rax,8),%ymm0,%ymm3
	vmulpd	96(%rsi,%rax,8),%ymm0,%ymm4
	vfmadd231pd	(%rdx,%rax,8),%ymm5,%ymm1
	vfmadd231pd	32(%rdx,%rax,8),%ymm5,%ymm2
	vfmadd231pd	64(%rdx,%rax,8),%ymm5,%ymm3
	vfmadd231pd	96(%rdx,%rax,8),%ymm5,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj139
Lj138:
	movl	%r10d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj140
Lj141:
	vmulpd	(%rsi,%rax,8),%ymm0,%ymm1
	vfmadd231pd	(%rdx,%rax,8),%ymm5,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj141
Lj140:
	andl	$3,%r10d
	jle	Lj142
	vmovd	%r10d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm2
	vmaskmovpd	(%rsi,%rax,8),%ymm2,%ymm1
	vmulpd	%ymm1,%ymm0,%ymm1
	vfmadd231pd	(%rdx,%rax,8),%ymm5,%ymm1
	vmaskmovpd	%ymm1,%ymm2,(%rdi,%rax,8)
Lj142:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKADD_S$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKADD_S$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	jz	Lj145
Lj146:
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmovups	64(%rsi,%rax,4),%ymm2
	vmovups	96(%rsi,%rax,4),%ymm3
	vaddps	(%rdx,%rax,4),%ymm0,%ymm0
	vaddps	32(%rdx,%rax,4),%ymm1,%ymm1
	vaddps	64(%rdx,%rax,4),%ymm2,%ymm2
	vaddps	96(%rdx,%rax,4),%ymm3,%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj146
Lj145:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj147
Lj148:
	vmovups	(%rsi,%rax,4),%ymm0
	vaddps	(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj148
Lj147:
	andl	$7,%r8d
	jle	Lj149
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm1,%ymm0
	vaddps	(%rdx,%rax,4),%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm1,(%rdi,%rax,4)
Lj149:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKADD_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKADD_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj152
Lj153:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmovupd	64(%rsi,%rax,8),%ymm2
	vmovupd	96(%rsi,%rax,8),%ymm3
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm0
	vaddpd	32(%rdx,%rax,8),%ymm1,%ymm1
	vaddpd	64(%rdx,%rax,8),%ymm2,%ymm2
	vaddpd	96(%rdx,%rax,8),%ymm3,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj153
Lj152:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj154
Lj155:
	vmovupd	(%rsi,%rax,8),%ymm0
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj155
Lj154:
	andl	$3,%r8d
	jle	Lj156
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm1,%ymm0
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm1,(%rdi,%rax,8)
Lj156:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUB_S$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKSUB_S$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	jz	Lj159
Lj160:
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmovups	64(%rsi,%rax,4),%ymm2
	vmovups	96(%rsi,%rax,4),%ymm3
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vsubps	32(%rdx,%rax,4),%ymm1,%ymm1
	vsubps	64(%rdx,%rax,4),%ymm2,%ymm2
	vsubps	96(%rdx,%rax,4),%ymm3,%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj160
Lj159:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj161
Lj162:
	vmovups	(%rsi,%rax,4),%ymm0
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj162
Lj161:
	andl	$7,%r8d
	jle	Lj163
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm1,%ymm0
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm1,(%rdi,%rax,4)
Lj163:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUB_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKSUB_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj166
Lj167:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmovupd	64(%rsi,%rax,8),%ymm2
	vmovupd	96(%rsi,%rax,8),%ymm3
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vsubpd	32(%rdx,%rax,8),%ymm1,%ymm1
	vsubpd	64(%rdx,%rax,8),%ymm2,%ymm2
	vsubpd	96(%rdx,%rax,8),%ymm3,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj167
Lj166:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj168
Lj169:
	vmovupd	(%rsi,%rax,8),%ymm0
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj169
Lj168:
	andl	$3,%r8d
	jle	Lj170
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm1,%ymm0
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm1,(%rdi,%rax,8)
Lj170:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_S$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_S$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	jz	Lj173
Lj174:
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmovups	64(%rsi,%rax,4),%ymm2
	vmovups	96(%rsi,%rax,4),%ymm3
	vmulps	(%rdx,%rax,4),%ymm0,%ymm0
	vmulps	32(%rdx,%rax,4),%ymm1,%ymm1
	vmulps	64(%rdx,%rax,4),%ymm2,%ymm2
	vmulps	96(%rdx,%rax,4),%ymm3,%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj174
Lj173:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj175
Lj176:
	vmovups	(%rsi,%rax,4),%ymm0
	vmulps	(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj176
Lj175:
	andl	$7,%r8d
	jle	Lj177
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm1,%ymm0
	vmulps	(%rdx,%rax,4),%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm1,(%rdi,%rax,4)
Lj177:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj180
Lj181:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmovupd	64(%rsi,%rax,8),%ymm2
	vmovupd	96(%rsi,%rax,8),%ymm3
	vmulpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmulpd	32(%rdx,%rax,8),%ymm1,%ymm1
	vmulpd	64(%rdx,%rax,8),%ymm2,%ymm2
	vmulpd	96(%rdx,%rax,8),%ymm3,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj181
Lj180:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj182
Lj183:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmulpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj183
Lj182:
	andl	$3,%r8d
	jle	Lj184
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm1,%ymm0
	vmulpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm1,(%rdi,%rax,8)
Lj184:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIV_S$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKDIV_S$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	jz	Lj187
Lj188:
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmovups	64(%rsi,%rax,4),%ymm2
	vmovups	96(%rsi,%rax,4),%ymm3
	vdivps	(%rdx,%rax,4),%ymm0,%ymm0
	vdivps	32(%rdx,%rax,4),%ymm1,%ymm1
	vdivps	64(%rdx,%rax,4),%ymm2,%ymm2
	vdivps	96(%rdx,%rax,4),%ymm3,%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj188
Lj187:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj189
Lj190:
	vmovups	(%rsi,%rax,4),%ymm0
	vdivps	(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj190
Lj189:
	andl	$7,%r8d
	jle	Lj191
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm1,%ymm0
	vdivps	(%rdx,%rax,4),%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm1,(%rdi,%rax,4)
Lj191:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIV_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKDIV_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj194
Lj195:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmovupd	64(%rsi,%rax,8),%ymm2
	vmovupd	96(%rsi,%rax,8),%ymm3
	vdivpd	(%rdx,%rax,8),%ymm0,%ymm0
	vdivpd	32(%rdx,%rax,8),%ymm1,%ymm1
	vdivpd	64(%rdx,%rax,8),%ymm2,%ymm2
	vdivpd	96(%rdx,%rax,8),%ymm3,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj195
Lj194:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj196
Lj197:
	vmovupd	(%rsi,%rax,8),%ymm0
	vdivpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj197
Lj196:
	andl	$3,%r8d
	jle	Lj198
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm1,%ymm0
	vdivpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm1,(%rdi,%rax,8)
Lj198:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUM_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKSUM_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vpxor	%ymm0,%ymm0,%ymm0
	movl	%edx,%r8d
	shrq	$5,%rdx
	jz	Lj201
	vpxor	%ymm1,%ymm1,%ymm1
	vpxor	%ymm2,%ymm2,%ymm2
	vpxor	%ymm3,%ymm3,%ymm3
Lj202:
	vaddps	(%rsi,%rax,4),%ymm0,%ymm0
	vaddps	32(%rsi,%rax,4),%ymm1,%ymm1
	vaddps	64(%rsi,%rax,4),%ymm2,%ymm2
	vaddps	96(%rsi,%rax,4),%ymm3,%ymm3
	addq	$32,%rax
	decq	%rdx
	jnz	Lj202
	vaddps	%ymm3,%ymm2,%ymm2
	vaddps	%ymm1,%ymm0,%ymm0
	vaddps	%ymm2,%ymm0,%ymm0
Lj201:
	movq	%r8,%rcx
	andq	$31,%rcx
	shrq	$3,%rcx
	jle	Lj203
Lj204:
	vaddps	(%rsi,%rax,4),%ymm0,%ymm0
	addq	$8,%rax
	decq	%rcx
	jnz	Lj204
Lj203:
	andl	$7,%r8d
	jle	Lj205
	vpxor	%ymm2,%ymm2,%ymm2
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm1,%ymm2
	vaddps	%ymm2,%ymm0,%ymm0
Lj205:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vaddps	%xmm1,%xmm0,%xmm0
	vhaddps	%xmm0,%xmm0,%xmm0
	vhaddps	%xmm0,%xmm0,%xmm0
	vmovss	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUM_D$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKSUM_D$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vpxor	%ymm0,%ymm0,%ymm0
	movl	%edx,%r8d
	shrq	$4,%rdx
	jz	Lj208
	vpxor	%ymm1,%ymm1,%ymm1
	vpxor	%ymm2,%ymm2,%ymm2
	vpxor	%ymm3,%ymm3,%ymm3
Lj209:
	vaddpd	(%rsi,%rax,8),%ymm0,%ymm0
	vaddpd	32(%rsi,%rax,8),%ymm1,%ymm1
	vaddpd	64(%rsi,%rax,8),%ymm2,%ymm2
	vaddpd	96(%rsi,%rax,8),%ymm3,%ymm3
	addq	$16,%rax
	decq	%rdx
	jnz	Lj209
	vaddpd	%ymm3,%ymm2,%ymm2
	vaddpd	%ymm1,%ymm0,%ymm0
	vaddpd	%ymm2,%ymm0,%ymm0
Lj208:
	movq	%r8,%rcx
	andq	$15,%rcx
	shrq	$2,%rcx
	jle	Lj210
Lj211:
	vaddpd	(%rsi,%rax,8),%ymm0,%ymm0
	addq	$4,%rax
	decq	%rcx
	jnz	Lj211
Lj210:
	andl	$3,%r8d
	jle	Lj212
	vpxor	%ymm2,%ymm2,%ymm2
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm1,%ymm2
	vaddpd	%ymm2,%ymm0,%ymm0
Lj212:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vaddpd	%xmm1,%xmm0,%xmm0
	vhaddpd	%xmm0,%xmm0,%xmm0
	vmovsd	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMAX_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMAX_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vbroadcastss	(%rsi),%ymm0
	movl	%edx,%r8d
	shrq	$5,%rdx
	jz	Lj215
	vmovaps	%ymm0,%ymm1
	vmovaps	%ymm0,%ymm2
	vmovaps	%ymm0,%ymm3
Lj216:
	vmaxps	(%rsi,%rax,4),%ymm0,%ymm0
	vmaxps	32(%rsi,%rax,4),%ymm1,%ymm1
	vmaxps	64(%rsi,%rax,4),%ymm2,%ymm2
	vmaxps	96(%rsi,%rax,4),%ymm3,%ymm3
	addq	$32,%rax
	decq	%rdx
	jnz	Lj216
	vmaxps	%ymm1,%ymm0,%ymm0
	vmaxps	%ymm3,%ymm2,%ymm2
	vmaxps	%ymm2,%ymm0,%ymm0
Lj215:
	movq	%r8,%rcx
	andq	$31,%rcx
	shrq	$3,%rcx
	jle	Lj217
Lj218:
	vmaxps	(%rsi,%rax,4),%ymm0,%ymm0
	addq	$8,%rax
	decq	%rcx
	jnz	Lj218
Lj217:
	andl	$7,%r8d
	jle	Lj219
	vbroadcastss	%xmm0,%ymm2
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm1
	vblendvps	%ymm1,(%rsi,%rax,4),%ymm2,%ymm2
	vmaxps	%ymm2,%ymm0,%ymm0
Lj219:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vmaxps	%xmm1,%xmm0,%xmm0
	vmovhlps	%xmm0,%xmm0,%xmm1
	vmaxps	%xmm0,%xmm1,%xmm0
	vmovshdup	%xmm0,%xmm1
	vmaxss	%xmm0,%xmm1,%xmm0
	vmovss	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMAX_D$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKMAX_D$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vbroadcastsd	(%rsi),%ymm0
	movl	%edx,%r8d
	shrq	$4,%rdx
	jz	Lj222
	vmovapd	%ymm0,%ymm1
	vmovapd	%ymm0,%ymm2
	vmovapd	%ymm0,%ymm3
Lj223:
	vmaxpd	(%rsi,%rax,8),%ymm0,%ymm0
	vmaxpd	32(%rsi,%rax,8),%ymm1,%ymm1
	vmaxpd	64(%rsi,%rax,8),%ymm2,%ymm2
	vmaxpd	96(%rsi,%rax,8),%ymm3,%ymm3
	addq	$16,%rax
	decq	%rdx
	jnz	Lj223
	vmaxpd	%ymm1,%ymm0,%ymm0
	vmaxpd	%ymm3,%ymm2,%ymm2
	vmaxpd	%ymm2,%ymm0,%ymm0
Lj222:
	movq	%r8,%rcx
	andq	$15,%rcx
	shrq	$2,%rcx
	jle	Lj224
Lj225:
	vmaxpd	(%rsi,%rax,8),%ymm0,%ymm0
	addq	$4,%rax
	decq	%rcx
	jnz	Lj225
Lj224:
	andl	$3,%r8d
	jle	Lj226
	vbroadcastsd	%xmm0,%ymm2
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm1
	vblendvpd	%ymm1,(%rsi,%rax,8),%ymm2,%ymm2
	vmaxpd	%ymm2,%ymm0,%ymm0
Lj226:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vmaxpd	%xmm1,%xmm0,%xmm0
	vmovhlps	%xmm0,%xmm0,%xmm1
	vmaxsd	%xmm1,%xmm0,%xmm0
	vmovsd	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMIN_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMIN_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vbroadcastss	(%rsi),%ymm0
	movl	%edx,%r8d
	shrq	$5,%rdx
	jz	Lj229
	vmovaps	%ymm0,%ymm1
	vmovaps	%ymm0,%ymm2
	vmovaps	%ymm0,%ymm3
Lj230:
	vminps	(%rsi,%rax,4),%ymm0,%ymm0
	vminps	32(%rsi,%rax,4),%ymm1,%ymm1
	vminps	64(%rsi,%rax,4),%ymm2,%ymm2
	vminps	96(%rsi,%rax,4),%ymm3,%ymm3
	addq	$32,%rax
	decq	%rdx
	jnz	Lj230
	vminps	%ymm1,%ymm0,%ymm0
	vminps	%ymm3,%ymm2,%ymm2
	vminps	%ymm2,%ymm0,%ymm0
Lj229:
	movq	%r8,%rcx
	andq	$31,%rcx
	shrq	$3,%rcx
	jle	Lj231
Lj232:
	vminps	(%rsi,%rax,4),%ymm0,%ymm0
	addq	$8,%rax
	decq	%rcx
	jnz	Lj232
Lj231:
	andl	$7,%r8d
	jle	Lj233
	vbroadcastss	%xmm0,%ymm2
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm1
	vblendvps	%ymm1,(%rsi,%rax,4),%ymm2,%ymm2
	vminps	%ymm2,%ymm0,%ymm0
Lj233:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vminps	%xmm1,%xmm0,%xmm0
	vmovhlps	%xmm0,%xmm0,%xmm1
	vminps	%xmm0,%xmm1,%xmm0
	vmovshdup	%xmm0,%xmm1
	vminss	%xmm0,%xmm1,%xmm0
	vmovss	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMIN_D$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKMIN_D$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vbroadcastsd	(%rsi),%ymm0
	movl	%edx,%r8d
	shrq	$4,%rdx
	jz	Lj236
	vmovapd	%ymm0,%ymm1
	vmovapd	%ymm0,%ymm2
	vmovapd	%ymm0,%ymm3
Lj237:
	vminpd	(%rsi,%rax,8),%ymm0,%ymm0
	vminpd	32(%rsi,%rax,8),%ymm1,%ymm1
	vminpd	64(%rsi,%rax,8),%ymm2,%ymm2
	vminpd	96(%rsi,%rax,8),%ymm3,%ymm3
	addq	$16,%rax
	decq	%rdx
	jnz	Lj237
	vminpd	%ymm1,%ymm0,%ymm0
	vminpd	%ymm3,%ymm2,%ymm2
	vminpd	%ymm2,%ymm0,%ymm0
Lj236:
	movq	%r8,%rcx
	andq	$15,%rcx
	shrq	$2,%rcx
	jle	Lj238
Lj239:
	vminpd	(%rsi,%rax,8),%ymm0,%ymm0
	addq	$4,%rax
	decq	%rcx
	jnz	Lj239
Lj238:
	andl	$3,%r8d
	jle	Lj240
	vbroadcastsd	%xmm0,%ymm2
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm1
	vblendvpd	%ymm1,(%rsi,%rax,8),%ymm2,%ymm2
	vminpd	%ymm2,%ymm0,%ymm0
Lj240:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vminpd	%xmm1,%xmm0,%xmm0
	vmovhlps	%xmm0,%xmm0,%xmm1
	vminsd	%xmm1,%xmm0,%xmm0
	vmovsd	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSQR_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKSQR_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%edx,%r8d
	shrq	$5,%rdx
	jz	Lj243
Lj244:
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmovups	64(%rsi,%rax,4),%ymm2
	vmovups	96(%rsi,%rax,4),%ymm3
	vmulps	%ymm0,%ymm0,%ymm0
	vmulps	%ymm1,%ymm1,%ymm1
	vmulps	%ymm2,%ymm2,%ymm2
	vmulps	%ymm3,%ymm3,%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decq	%rdx
	jnz	Lj244
Lj243:
	movq	%r8,%rcx
	andq	$31,%rcx
	shrq	$3,%rcx
	jle	Lj245
Lj246:
	vmovups	(%rsi,%rax,4),%ymm0
	vmulps	%ymm0,%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decq	%rcx
	jnz	Lj246
Lj245:
	andl	$7,%r8d
	jle	Lj247
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rsi,%rax,4),%ymm2,%ymm0
	vmulps	%ymm0,%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm2,(%rdi,%rax,4)
Lj247:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSQR_D$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKSQR_D$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vpxor	%ymm1,%ymm1,%ymm1
	movl	%edx,%r8d
	shrq	$4,%rdx
	jz	Lj250
Lj251:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmovupd	64(%rsi,%rax,8),%ymm2
	vmovupd	96(%rsi,%rax,8),%ymm3
	vmulpd	%ymm0,%ymm0,%ymm0
	vmulpd	%ymm1,%ymm1,%ymm1
	vmulpd	%ymm2,%ymm2,%ymm2
	vmulpd	%ymm3,%ymm3,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decq	%rdx
	jnz	Lj251
Lj250:
	movq	%r8,%rcx
	andq	$15,%rcx
	shrq	$2,%rcx
	jle	Lj252
Lj253:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmulpd	%ymm0,%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decq	%rcx
	jnz	Lj253
Lj252:
	andl	$3,%r8d
	jle	Lj254
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm2
	vmaskmovpd	(%rsi,%rax,8),%ymm2,%ymm0
	vmulpd	%ymm0,%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm2,(%rdi,%rax,8)
Lj254:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSQRT_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKSQRT_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%edx,%r8d
	shrq	$5,%rdx
	jz	Lj257
Lj258:
	vsqrtps	(%rsi,%rax,4),%ymm0
	vsqrtps	32(%rsi,%rax,4),%ymm1
	vsqrtps	64(%rsi,%rax,4),%ymm2
	vsqrtps	96(%rsi,%rax,4),%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decq	%rdx
	jnz	Lj258
Lj257:
	movq	%r8,%rcx
	andq	$31,%rcx
	shrq	$3,%rcx
	jle	Lj259
Lj260:
	vsqrtps	(%rsi,%rax,4),%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decq	%rcx
	jnz	Lj260
Lj259:
	andl	$7,%r8d
	jle	Lj261
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rsi,%rax,4),%ymm2,%ymm0
	vsqrtps	%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm2,(%rdi,%rax,4)
Lj261:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSQRT_D$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKSQRT_D$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%edx,%r8d
	shrq	$4,%rdx
	jz	Lj264
Lj265:
	vsqrtpd	(%rsi,%rax,8),%ymm0
	vsqrtpd	32(%rsi,%rax,8),%ymm1
	vsqrtpd	64(%rsi,%rax,8),%ymm2
	vsqrtpd	96(%rsi,%rax,8),%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decq	%rdx
	jnz	Lj265
Lj264:
	movq	%r8,%rcx
	andq	$15,%rcx
	shrq	$2,%rcx
	jle	Lj266
Lj267:
	vsqrtpd	(%rsi,%rax,8),%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decq	%rcx
	jnz	Lj267
Lj266:
	andl	$3,%r8d
	jle	Lj268
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm2
	vmaskmovpd	(%rsi,%rax,8),%ymm2,%ymm0
	vsqrtpd	%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm2,(%rdi,%rax,8)
Lj268:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKRSQRT_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKRSQRT_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%edx,%r8d
	shrq	$5,%rdx
	jz	Lj271
Lj272:
	vrsqrtps	(%rsi,%rax,4),%ymm0
	vrsqrtps	32(%rsi,%rax,4),%ymm1
	vrsqrtps	64(%rsi,%rax,4),%ymm2
	vrsqrtps	96(%rsi,%rax,4),%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decq	%rdx
	jnz	Lj272
Lj271:
	movq	%r8,%rcx
	andq	$31,%rcx
	shrq	$3,%rcx
	jle	Lj273
Lj274:
	vrsqrtps	(%rsi,%rax,4),%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decq	%rcx
	jnz	Lj274
Lj273:
	andl	$7,%r8d
	jle	Lj275
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rsi,%rax,4),%ymm2,%ymm0
	vrsqrtps	%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm2,(%rdi,%rax,4)
Lj275:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKABS_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKABS_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	movl	$2147483647,%eax
	vmovd	%eax,%xmm5
	vbroadcastss	%xmm5,%ymm5
	xorq	%rax,%rax
	movl	%edx,%r8d
	shrq	$5,%rdx
	jz	Lj278
Lj279:
	vandps	(%rsi,%rax,4),%ymm5,%ymm0
	vandps	32(%rsi,%rax,4),%ymm5,%ymm1
	vandps	64(%rsi,%rax,4),%ymm5,%ymm2
	vandps	96(%rsi,%rax,4),%ymm5,%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decq	%rdx
	jnz	Lj279
Lj278:
	movq	%r8,%rcx
	andq	$31,%rcx
	shrq	$3,%rcx
	jle	Lj280
Lj281:
	vandps	(%rsi,%rax,4),%ymm5,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decq	%rcx
	jnz	Lj281
Lj280:
	andl	$7,%r8d
	jle	Lj282
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rsi,%rax,4),%ymm2,%ymm0
	vandps	%ymm0,%ymm5,%ymm0
	vmaskmovps	%ymm0,%ymm2,(%rdi,%rax,4)
Lj282:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKABS_D$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKABS_D$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	movq	$9223372036854775807,%rax
	vmovd	%rax,%xmm5
	vbroadcastsd	%xmm5,%ymm5
	xorq	%rax,%rax
	movl	%edx,%r8d
	shrq	$4,%rdx
	jz	Lj285
Lj286:
	vandpd	(%rsi,%rax,8),%ymm5,%ymm0
	vandpd	32(%rsi,%rax,8),%ymm5,%ymm1
	vandpd	64(%rsi,%rax,8),%ymm5,%ymm2
	vandpd	96(%rsi,%rax,8),%ymm5,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decq	%rdx
	jnz	Lj286
Lj285:
	movq	%r8,%rcx
	andq	$15,%rcx
	shrq	$2,%rcx
	jle	Lj287
Lj288:
	vandpd	(%rsi,%rax,8),%ymm5,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decq	%rcx
	jnz	Lj288
Lj287:
	andl	$3,%r8d
	jle	Lj289
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm2
	vmaskmovpd	(%rsi,%rax,8),%ymm2,%ymm0
	vandpd	%ymm0,%ymm5,%ymm0
	vmaskmovpd	%ymm0,%ymm2,(%rdi,%rax,8)
Lj289:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUMSQR_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKSUMSQR_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vpxor	%ymm0,%ymm0,%ymm0
	vpxor	%ymm5,%ymm5,%ymm5
	vpxor	%ymm6,%ymm6,%ymm6
	vpxor	%ymm7,%ymm7,%ymm7
	movl	%edx,%r8d
	shrq	$5,%rdx
	jz	Lj292
Lj293:
	vmovups	(%rsi,%rax,4),%ymm1
	vfmadd231ps	%ymm1,%ymm1,%ymm0
	vmovups	32(%rsi,%rax,4),%ymm2
	vfmadd231ps	%ymm2,%ymm2,%ymm5
	vmovups	64(%rsi,%rax,4),%ymm3
	vfmadd231ps	%ymm3,%ymm3,%ymm6
	vmovups	96(%rsi,%rax,4),%ymm4
	vfmadd231ps	%ymm4,%ymm4,%ymm7
	addq	$32,%rax
	decq	%rdx
	jnz	Lj293
	vaddps	%ymm5,%ymm0,%ymm0
	vaddps	%ymm7,%ymm6,%ymm6
	vaddps	%ymm6,%ymm0,%ymm0
Lj292:
	movq	%r8,%rcx
	andq	$31,%rcx
	shrq	$3,%rcx
	jle	Lj294
Lj295:
	vmovups	(%rsi,%rax,4),%ymm1
	vfmadd231ps	%ymm1,%ymm1,%ymm0
	addq	$8,%rax
	decq	%rcx
	jnz	Lj295
Lj294:
	andl	$7,%r8d
	jle	Lj296
	vpxor	%ymm1,%ymm1,%ymm1
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rsi,%rax,4),%ymm2,%ymm1
	vfmadd231ps	%ymm1,%ymm1,%ymm0
Lj296:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vaddps	%xmm1,%xmm0,%xmm0
	vhaddps	%xmm0,%xmm0,%xmm0
	vhaddps	%xmm0,%xmm0,%xmm0
	vmovss	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUMSQR_D$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKSUMSQR_D$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	vpxor	%ymm0,%ymm0,%ymm0
	vpxor	%ymm5,%ymm5,%ymm5
	vpxor	%ymm6,%ymm6,%ymm6
	vpxor	%ymm7,%ymm7,%ymm7
	movl	%edx,%r8d
	shrq	$4,%rdx
	jz	Lj299
Lj300:
	vmovupd	(%rsi,%rax,8),%ymm1
	vfmadd231pd	%ymm1,%ymm1,%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm2
	vfmadd231pd	%ymm2,%ymm2,%ymm5
	vmovupd	64(%rsi,%rax,8),%ymm3
	vfmadd231pd	%ymm3,%ymm3,%ymm6
	vmovupd	96(%rsi,%rax,8),%ymm4
	vfmadd231pd	%ymm4,%ymm4,%ymm7
	addq	$16,%rax
	decq	%rdx
	jnz	Lj300
	vaddpd	%ymm5,%ymm0,%ymm0
	vaddpd	%ymm7,%ymm6,%ymm6
	vaddpd	%ymm6,%ymm0,%ymm0
Lj299:
	movq	%r8,%rcx
	andq	$15,%rcx
	shrq	$2,%rcx
	jle	Lj301
Lj302:
	vmovupd	(%rsi,%rax,8),%ymm1
	vfmadd231pd	%ymm1,%ymm1,%ymm0
	addq	$4,%rax
	decq	%rcx
	jnz	Lj302
Lj301:
	andl	$3,%r8d
	jle	Lj303
	vpxor	%ymm1,%ymm1,%ymm1
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm2
	vmaskmovpd	(%rsi,%rax,8),%ymm2,%ymm1
	vfmadd231pd	%ymm1,%ymm1,%ymm0
Lj303:
	vextractf128	$1,%ymm0,%xmm1
	vzeroupper
	vaddpd	%xmm1,%xmm0,%xmm0
	vhaddpd	%xmm0,%xmm0,%xmm0
	vmovsd	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKGATHERA_S$PSINGLE$PSINGLE$LONGINT$LONGINT
_OPRS_SIMD_$$_BULKGATHERA_S$PSINGLE$PSINGLE$LONGINT$LONGINT:
#  CPU ATHLON64
	movl	%ecx,%r8d
	vmovd	%edx,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpmulld	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	imulq	$32,%rdx
	shrl	$3,%ecx
	jz	Lj306
Lj307:
	vpcmpeqd	%ymm1,%ymm1,%ymm1
	vgatherdps	%ymm1,(%rsi,%ymm2,4),%ymm0
	vmovups	%ymm0,(%rdi)
	leaq	(%rsi,%rdx,1),%rsi
	addq	$32,%rdi
	decl	%ecx
	jnz	Lj307
Lj306:
	andl	$7,%r8d
	jz	Lj308
	vmovd	%r8d,%xmm3
	vpbroadcastd	%xmm3,%ymm3
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm3,%ymm1
	vmovdqa	%ymm1,%ymm3
	vgatherdps	%ymm1,(%rsi,%ymm2,4),%ymm0
	vmaskmovps	%ymm0,%ymm3,(%rdi)
Lj308:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKGATHERA_D$PDOUBLE$PDOUBLE$LONGINT$LONGINT
_OPRS_SIMD_$$_BULKGATHERA_D$PDOUBLE$PDOUBLE$LONGINT$LONGINT:
#  CPU ATHLON64
	movl	%ecx,%r8d
	vmovd	%edx,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	imulq	$32,%rdx
	vpmulld	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	shrl	$2,%ecx
	jz	Lj311
Lj312:
	vpcmpeqq	%ymm1,%ymm1,%ymm1
	vgatherdpd	%ymm1,(%rsi,%xmm2,8),%ymm0
	vmovupd	%ymm0,(%rdi)
	leaq	(%rsi,%rdx,1),%rsi
	addq	$32,%rdi
	decl	%ecx
	jnz	Lj312
Lj311:
	andl	$3,%r8d
	jz	Lj313
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm1
	vmovdqa	%ymm1,%ymm3
	vgatherdpd	%ymm1,(%rsi,%xmm2,8),%ymm0
	vmaskmovpd	%ymm0,%ymm3,(%rdi)
Lj313:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIFFSQR_S$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKDIFFSQR_S$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	jz	Lj316
Lj317:
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmovups	64(%rsi,%rax,4),%ymm2
	vmovups	96(%rsi,%rax,4),%ymm3
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vsubps	32(%rdx,%rax,4),%ymm1,%ymm1
	vsubps	64(%rdx,%rax,4),%ymm2,%ymm2
	vsubps	96(%rdx,%rax,4),%ymm3,%ymm3
	vmulps	%ymm0,%ymm0,%ymm0
	vmulps	%ymm1,%ymm1,%ymm1
	vmulps	%ymm2,%ymm2,%ymm2
	vmulps	%ymm3,%ymm3,%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj317
Lj316:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj318
Lj319:
	vmovups	(%rsi,%rax,4),%ymm0
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vmulps	%ymm0,%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj319
Lj318:
	andl	$7,%r8d
	jle	Lj320
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm1,%ymm0
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vmulps	%ymm0,%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm1,(%rdi,%rax,4)
Lj320:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIFFSQR_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKDIFFSQR_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj323
Lj324:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmovupd	64(%rsi,%rax,8),%ymm2
	vmovupd	96(%rsi,%rax,8),%ymm3
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vsubpd	32(%rdx,%rax,8),%ymm1,%ymm1
	vsubpd	64(%rdx,%rax,8),%ymm2,%ymm2
	vsubpd	96(%rdx,%rax,8),%ymm3,%ymm3
	vmulpd	%ymm0,%ymm0,%ymm0
	vmulpd	%ymm1,%ymm1,%ymm1
	vmulpd	%ymm2,%ymm2,%ymm2
	vmulpd	%ymm3,%ymm3,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj324
Lj323:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj325
Lj326:
	vmovupd	(%rsi,%rax,8),%ymm0
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmulpd	%ymm0,%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj326
Lj325:
	andl	$3,%r8d
	jle	Lj327
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm1,%ymm0
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmulpd	%ymm0,%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm1,(%rdi,%rax,8)
Lj327:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIFFSQR_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKDIFFSQR_SD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	vbroadcastsd	(%rdx),%ymm0
	jz	Lj330
Lj331:
	vsubpd	(%rsi,%rax,8),%ymm0,%ymm1
	vsubpd	32(%rsi,%rax,8),%ymm0,%ymm2
	vsubpd	64(%rsi,%rax,8),%ymm0,%ymm3
	vsubpd	96(%rsi,%rax,8),%ymm0,%ymm4
	vmulpd	%ymm1,%ymm1,%ymm1
	vmulpd	%ymm2,%ymm2,%ymm2
	vmulpd	%ymm3,%ymm3,%ymm3
	vmulpd	%ymm4,%ymm4,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj331
Lj330:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj332
Lj333:
	vsubpd	(%rsi,%rax,8),%ymm0,%ymm1
	vmulpd	%ymm1,%ymm1,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj333
Lj332:
	andl	$3,%r8d
	jle	Lj334
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm1
	vsubpd	(%rsi,%rax,8),%ymm0,%ymm0
	vmulpd	%ymm0,%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm1,(%rdi,%rax,8)
Lj334:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIFFSQR_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKDIFFSQR_SS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$5,%ecx
	vbroadcastss	(%rdx),%ymm0
	jz	Lj337
Lj338:
	vsubps	(%rsi,%rax,4),%ymm0,%ymm1
	vsubps	32(%rsi,%rax,4),%ymm0,%ymm2
	vsubps	64(%rsi,%rax,4),%ymm0,%ymm3
	vsubps	96(%rsi,%rax,4),%ymm0,%ymm4
	vmulps	%ymm1,%ymm1,%ymm1
	vmulps	%ymm2,%ymm2,%ymm2
	vmulps	%ymm3,%ymm3,%ymm3
	vmulps	%ymm4,%ymm4,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj338
Lj337:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj339
Lj340:
	vsubps	(%rsi,%rax,4),%ymm0,%ymm1
	vmulps	%ymm1,%ymm1,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj340
Lj339:
	andl	$7,%r8d
	jle	Lj341
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm1
	vsubps	(%rsi,%rax,4),%ymm0,%ymm0
	vmulps	%ymm0,%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm1,(%rdi,%rax,4)
Lj341:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMAG_CS$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMAG_CS$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%edx,%ecx
	shrl	$3,%ecx
	jz	Lj344
Lj345:
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmulps	%ymm0,%ymm0,%ymm0
	vmulps	%ymm1,%ymm1,%ymm1
	vhaddps	%ymm1,%ymm0,%ymm0
	vpermpd	$216,%ymm0,%ymm0
	vsqrtps	%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,2)
	addq	$16,%rax
	decl	%ecx
	jg	Lj345
Lj344:
	movl	%edx,%ecx
	andl	$7,%ecx
	jz	Lj346
	vmovd	%ecx,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm3
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmulps	%ymm0,%ymm0,%ymm0
	vmulps	%ymm1,%ymm1,%ymm1
	vhaddps	%ymm1,%ymm0,%ymm0
	vpermpd	$216,%ymm0,%ymm0
	vsqrtps	%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm3,(%rdi,%rax,2)
Lj346:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMAG_CD$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKMAG_CD$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%edx,%ecx
	shrl	$2,%ecx
	jz	Lj349
Lj350:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmulpd	%ymm0,%ymm0,%ymm0
	vmulpd	%ymm1,%ymm1,%ymm1
	vhaddpd	%ymm1,%ymm0,%ymm0
	vpermpd	$216,%ymm0,%ymm0
	vsqrtpd	%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jg	Lj350
Lj349:
	movl	%edx,%ecx
	andl	$3,%ecx
	jz	Lj351
	vmovd	%ecx,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm3
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmulpd	%ymm0,%ymm0,%ymm0
	vmulpd	%ymm1,%ymm1,%ymm1
	vhaddpd	%ymm1,%ymm0,%ymm0
	vpermpd	$216,%ymm0,%ymm0
	vsqrtpd	%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm3,(%rdi,%rax,4)
Lj351:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKADD_CSS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKADD_CSS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	vpbroadcastq	(%rsi),%ymm0
	shrl	$4,%ecx
	jz	Lj354
Lj355:
	vaddps	(%rdx,%rax,4),%ymm0,%ymm1
	vaddps	32(%rdx,%rax,4),%ymm0,%ymm2
	vaddps	64(%rdx,%rax,4),%ymm0,%ymm3
	vaddps	96(%rdx,%rax,4),%ymm0,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jg	Lj355
Lj354:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj356
Lj357:
	vaddps	(%rdx,%rax,4),%ymm0,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jg	Lj357
Lj356:
	andl	$3,%r8d
	jz	Lj358
	shll	$1,%r8d
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm3
	vaddps	(%rdx,%rax,4),%ymm0,%ymm1
	vmaskmovps	%ymm1,%ymm3,(%rdi,%rax,4)
Lj358:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKADD_CSD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKADD_CSD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	vbroadcastf128	(%rsi),%ymm0
	shrl	$3,%ecx
	jz	Lj361
Lj362:
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm1
	vaddpd	32(%rdx,%rax,8),%ymm0,%ymm2
	vaddpd	64(%rdx,%rax,8),%ymm0,%ymm3
	vaddpd	96(%rdx,%rax,8),%ymm0,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jg	Lj362
Lj361:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj363
Lj364:
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jg	Lj364
Lj363:
	andl	$1,%r8d
	jz	Lj365
	shll	$1,%r8d
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm3
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm1
	vmaskmovpd	%ymm1,%ymm3,(%rdi,%rax,8)
Lj365:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUB_CSS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKSUB_CSS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	vpbroadcastq	(%rsi),%ymm0
	shrl	$4,%ecx
	jz	Lj368
Lj369:
	vsubps	(%rdx,%rax,4),%ymm0,%ymm1
	vsubps	32(%rdx,%rax,4),%ymm0,%ymm2
	vsubps	64(%rdx,%rax,4),%ymm0,%ymm3
	vsubps	96(%rdx,%rax,4),%ymm0,%ymm4
	vmovups	%ymm1,(%rdi,%rax,4)
	vmovups	%ymm2,32(%rdi,%rax,4)
	vmovups	%ymm3,64(%rdi,%rax,4)
	vmovups	%ymm4,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jg	Lj369
Lj368:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj370
Lj371:
	vsubps	(%rdx,%rax,4),%ymm0,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jg	Lj371
Lj370:
	andl	$3,%r8d
	jz	Lj372
	shll	$1,%r8d
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm3
	vsubps	(%rdx,%rax,4),%ymm0,%ymm1
	vmaskmovps	%ymm1,%ymm3,(%rdi,%rax,4)
Lj372:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUB_CSD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKSUB_CSD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	vbroadcastf128	(%rsi),%ymm0
	shrl	$3,%ecx
	jz	Lj375
Lj376:
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm1
	vsubpd	32(%rdx,%rax,8),%ymm0,%ymm2
	vsubpd	64(%rdx,%rax,8),%ymm0,%ymm3
	vsubpd	96(%rdx,%rax,8),%ymm0,%ymm4
	vmovupd	%ymm1,(%rdi,%rax,8)
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jg	Lj376
Lj375:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj377
Lj378:
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jg	Lj378
Lj377:
	andl	$1,%r8d
	jz	Lj379
	shll	$1,%r8d
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm3
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm1
	vmaskmovpd	%ymm1,%ymm3,(%rdi,%rax,8)
Lj379:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_CSS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_CSS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	vpbroadcastq	(%rsi),%ymm0
	vmovshdup	%ymm0,%ymm1
	vmovsldup	%ymm0,%ymm0
	shrl	$4,%ecx
	jz	Lj382
Lj383:
	vmulps	(%rdx,%rax,4),%ymm0,%ymm3
	vmulps	(%rdx,%rax,4),%ymm1,%ymm4
	vmulps	32(%rdx,%rax,4),%ymm0,%ymm5
	vmulps	32(%rdx,%rax,4),%ymm1,%ymm6
	vmulps	64(%rdx,%rax,4),%ymm0,%ymm7
	vmulps	64(%rdx,%rax,4),%ymm1,%ymm8
	vmulps	96(%rdx,%rax,4),%ymm0,%ymm9
	vmulps	96(%rdx,%rax,4),%ymm1,%ymm10
	vpermilps	$177,%ymm4,%ymm4
	vpermilps	$177,%ymm6,%ymm6
	vpermilps	$177,%ymm8,%ymm8
	vpermilps	$177,%ymm10,%ymm10
	vaddsubps	%ymm4,%ymm3,%ymm3
	vaddsubps	%ymm6,%ymm5,%ymm5
	vaddsubps	%ymm8,%ymm7,%ymm7
	vaddsubps	%ymm10,%ymm9,%ymm9
	vmovups	%ymm3,(%rdi,%rax,4)
	vmovups	%ymm5,32(%rdi,%rax,4)
	vmovups	%ymm7,64(%rdi,%rax,4)
	vmovups	%ymm9,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jg	Lj383
Lj382:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj384
Lj385:
	vmulps	(%rdx,%rax,4),%ymm0,%ymm3
	vmulps	(%rdx,%rax,4),%ymm1,%ymm4
	vpermilps	$177,%ymm4,%ymm4
	vaddsubps	%ymm4,%ymm3,%ymm3
	vmovups	%ymm3,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jg	Lj385
Lj384:
	andl	$3,%r8d
	jz	Lj386
	shll	$1,%r8d
	vmovd	%r8d,%xmm2
	vpbroadcastd	%xmm2,%ymm2
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm2,%ymm2
	vmaskmovps	(%rdx,%rax,4),%ymm2,%ymm5
	vmulps	%ymm5,%ymm0,%ymm3
	vmulps	%ymm5,%ymm1,%ymm4
	vpermilps	$177,%ymm4,%ymm4
	vaddsubps	%ymm4,%ymm3,%ymm3
	vmaskmovps	%ymm3,%ymm2,(%rdi,%rax,4)
Lj386:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_CSD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_CSD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	vbroadcastf128	(%rsi),%ymm0
	vpermilpd	$15,%ymm0,%ymm1
	vmovddup	%ymm0,%ymm0
	shrl	$3,%ecx
	jz	Lj389
Lj390:
	vmulpd	(%rdx,%rax,8),%ymm0,%ymm3
	vmulpd	(%rdx,%rax,8),%ymm1,%ymm4
	vmulpd	32(%rdx,%rax,8),%ymm0,%ymm5
	vmulpd	32(%rdx,%rax,8),%ymm1,%ymm6
	vmulpd	64(%rdx,%rax,8),%ymm0,%ymm7
	vmulpd	64(%rdx,%rax,8),%ymm1,%ymm8
	vmulpd	96(%rdx,%rax,8),%ymm0,%ymm9
	vmulpd	96(%rdx,%rax,8),%ymm1,%ymm10
	vpermilpd	$5,%ymm4,%ymm4
	vpermilpd	$5,%ymm6,%ymm6
	vpermilpd	$5,%ymm8,%ymm8
	vpermilpd	$5,%ymm10,%ymm10
	vaddsubpd	%ymm4,%ymm3,%ymm3
	vaddsubpd	%ymm6,%ymm5,%ymm5
	vaddsubpd	%ymm8,%ymm7,%ymm7
	vaddsubpd	%ymm10,%ymm9,%ymm9
	vmovupd	%ymm3,(%rdi,%rax,8)
	vmovupd	%ymm5,32(%rdi,%rax,8)
	vmovupd	%ymm7,64(%rdi,%rax,8)
	vmovupd	%ymm9,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jg	Lj390
Lj389:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj391
Lj392:
	vmulpd	(%rdx,%rax,8),%ymm0,%ymm3
	vmulpd	(%rdx,%rax,8),%ymm1,%ymm4
	vpermilpd	$5,%ymm4,%ymm4
	vaddsubpd	%ymm4,%ymm3,%ymm3
	vmovupd	%ymm3,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jg	Lj392
Lj391:
	andl	$1,%r8d
	jz	Lj393
	shll	$1,%r8d
	vmovd	%r8d,%xmm2
	vpbroadcastq	%xmm2,%ymm2
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm2,%ymm2
	vmaskmovpd	(%rdx,%rax,8),%ymm2,%ymm5
	vmulpd	%ymm5,%ymm0,%ymm3
	vmulpd	%ymm5,%ymm1,%ymm4
	vpermilpd	$5,%ymm4,%ymm4
	vaddsubpd	%ymm4,%ymm3,%ymm3
	vmaskmovpd	%ymm3,%ymm2,(%rdi,%rax,8)
Lj393:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIV_CSS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKDIV_CSS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	vpbroadcastq	(%rsi),%ymm0
	vmovsldup	%ymm0,%ymm1
	vmovshdup	%ymm0,%ymm2
	shrl	$4,%ecx
	jz	Lj396
Lj397:
	vmovups	(%rdx,%rax,4),%ymm7
	vmovsldup	%ymm7,%ymm3
	vmovshdup	%ymm7,%ymm4
	vmulps	%ymm3,%ymm3,%ymm3
	vfmadd231ps	%ymm4,%ymm4,%ymm3
	vmulps	%ymm7,%ymm2,%ymm5
	vmulps	%ymm7,%ymm1,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vaddsubps	%ymm6,%ymm5,%ymm7
	vpermilps	$177,%ymm7,%ymm7
	vdivps	%ymm3,%ymm7,%ymm8
	vmovups	%ymm8,(%rdi,%rax,4)
	vmovups	32(%rdx,%rax,4),%ymm7
	vmovsldup	%ymm7,%ymm3
	vmovshdup	%ymm7,%ymm4
	vmulps	%ymm3,%ymm3,%ymm3
	vfmadd231ps	%ymm4,%ymm4,%ymm3
	vmulps	%ymm7,%ymm2,%ymm5
	vmulps	%ymm7,%ymm1,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vaddsubps	%ymm6,%ymm5,%ymm7
	vpermilps	$177,%ymm7,%ymm7
	vdivps	%ymm3,%ymm7,%ymm8
	vmovups	%ymm8,32(%rdi,%rax,4)
	vmovups	64(%rdx,%rax,4),%ymm7
	vmovsldup	%ymm7,%ymm3
	vmovshdup	%ymm7,%ymm4
	vmulps	%ymm3,%ymm3,%ymm3
	vfmadd231ps	%ymm4,%ymm4,%ymm3
	vmulps	%ymm7,%ymm2,%ymm5
	vmulps	%ymm7,%ymm1,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vaddsubps	%ymm6,%ymm5,%ymm7
	vpermilps	$177,%ymm7,%ymm7
	vdivps	%ymm3,%ymm7,%ymm8
	vmovups	%ymm8,64(%rdi,%rax,4)
	vmovups	96(%rdx,%rax,4),%ymm7
	vmovsldup	%ymm7,%ymm3
	vmovshdup	%ymm7,%ymm4
	vmulps	%ymm3,%ymm3,%ymm3
	vfmadd231ps	%ymm4,%ymm4,%ymm3
	vmulps	%ymm7,%ymm2,%ymm5
	vmulps	%ymm7,%ymm1,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vaddsubps	%ymm6,%ymm5,%ymm7
	vpermilps	$177,%ymm7,%ymm7
	vdivps	%ymm3,%ymm7,%ymm8
	vmovups	%ymm8,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jg	Lj397
Lj396:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj398
Lj399:
	vmovups	(%rdx,%rax,4),%ymm7
	vmovsldup	%ymm7,%ymm3
	vmovshdup	%ymm7,%ymm4
	vmulps	%ymm3,%ymm3,%ymm3
	vfmadd231ps	%ymm4,%ymm4,%ymm3
	vmulps	%ymm7,%ymm2,%ymm5
	vmulps	%ymm7,%ymm1,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vaddsubps	%ymm6,%ymm5,%ymm7
	vpermilps	$177,%ymm7,%ymm7
	vdivps	%ymm3,%ymm7,%ymm8
	vmovups	%ymm8,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jg	Lj399
Lj398:
	andl	$3,%r8d
	jz	Lj400
	shll	$1,%r8d
	vmovd	%r8d,%xmm8
	vpbroadcastd	%xmm8,%ymm8
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm8,%ymm8
	vmaskmovps	(%rdx,%rax,4),%ymm8,%ymm7
	vmovsldup	%ymm7,%ymm3
	vmovshdup	%ymm7,%ymm4
	vmulps	%ymm3,%ymm3,%ymm3
	vfmadd231ps	%ymm4,%ymm4,%ymm3
	vmulps	%ymm7,%ymm2,%ymm5
	vmulps	%ymm7,%ymm1,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vaddsubps	%ymm6,%ymm5,%ymm7
	vpermilps	$177,%ymm7,%ymm7
	vdivps	%ymm3,%ymm7,%ymm0
	vmaskmovps	%ymm0,%ymm8,(%rdi,%rax,4)
Lj400:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIV_CSD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKDIV_CSD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	vbroadcastf128	(%rsi),%ymm0
	vmovddup	%ymm0,%ymm1
	vpermilpd	$15,%ymm0,%ymm2
	shrl	$3,%ecx
	jz	Lj403
Lj404:
	vmovupd	(%rdx,%rax,8),%ymm7
	vmovddup	%ymm7,%ymm3
	vpermilpd	$15,%ymm7,%ymm4
	vmulpd	%ymm3,%ymm3,%ymm3
	vfmadd231pd	%ymm4,%ymm4,%ymm3
	vmulpd	%ymm7,%ymm2,%ymm5
	vmulpd	%ymm7,%ymm1,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vaddsubpd	%ymm6,%ymm5,%ymm7
	vpermilpd	$5,%ymm7,%ymm7
	vdivpd	%ymm3,%ymm7,%ymm8
	vmovupd	%ymm8,(%rdi,%rax,8)
	vmovupd	32(%rdx,%rax,8),%ymm7
	vmovddup	%ymm7,%ymm3
	vpermilpd	$15,%ymm7,%ymm4
	vmulpd	%ymm3,%ymm3,%ymm3
	vfmadd231pd	%ymm4,%ymm4,%ymm3
	vmulpd	%ymm7,%ymm2,%ymm5
	vmulpd	%ymm7,%ymm1,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vaddsubpd	%ymm6,%ymm5,%ymm7
	vpermilpd	$5,%ymm7,%ymm7
	vdivpd	%ymm3,%ymm7,%ymm8
	vmovupd	%ymm8,32(%rdi,%rax,8)
	vmovupd	64(%rdx,%rax,8),%ymm7
	vmovddup	%ymm7,%ymm3
	vpermilpd	$15,%ymm7,%ymm4
	vmulpd	%ymm3,%ymm3,%ymm3
	vfmadd231pd	%ymm4,%ymm4,%ymm3
	vmulpd	%ymm7,%ymm2,%ymm5
	vmulpd	%ymm7,%ymm1,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vaddsubpd	%ymm6,%ymm5,%ymm7
	vpermilpd	$5,%ymm7,%ymm7
	vdivpd	%ymm3,%ymm7,%ymm8
	vmovupd	%ymm8,64(%rdi,%rax,8)
	vmovupd	96(%rdx,%rax,8),%ymm7
	vmovddup	%ymm7,%ymm3
	vpermilpd	$15,%ymm7,%ymm4
	vmulpd	%ymm3,%ymm3,%ymm3
	vfmadd231pd	%ymm4,%ymm4,%ymm3
	vmulpd	%ymm7,%ymm2,%ymm5
	vmulpd	%ymm7,%ymm1,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vaddsubpd	%ymm6,%ymm5,%ymm7
	vpermilpd	$5,%ymm7,%ymm7
	vdivpd	%ymm3,%ymm7,%ymm8
	vmovupd	%ymm8,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jg	Lj404
Lj403:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj405
Lj406:
	vmovupd	(%rdx,%rax,8),%ymm7
	vmovddup	%ymm7,%ymm3
	vpermilpd	$15,%ymm7,%ymm4
	vmulpd	%ymm3,%ymm3,%ymm3
	vfmadd231pd	%ymm4,%ymm4,%ymm3
	vmulpd	%ymm7,%ymm2,%ymm5
	vmulpd	%ymm7,%ymm1,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vaddsubpd	%ymm6,%ymm5,%ymm7
	vpermilpd	$5,%ymm7,%ymm7
	vdivpd	%ymm3,%ymm7,%ymm8
	vmovupd	%ymm8,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jg	Lj406
Lj405:
	andl	$1,%r8d
	jz	Lj407
	shll	$1,%r8d
	vmovd	%r8d,%xmm8
	vpbroadcastq	%xmm8,%ymm8
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm8,%ymm8
	vmaskmovpd	(%rdx,%rax,8),%ymm8,%ymm7
	vmovddup	%ymm7,%ymm3
	vpermilpd	$15,%ymm7,%ymm4
	vmulpd	%ymm3,%ymm3,%ymm3
	vfmadd231pd	%ymm4,%ymm4,%ymm3
	vmulpd	%ymm7,%ymm2,%ymm5
	vmulpd	%ymm7,%ymm1,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vaddsubpd	%ymm6,%ymm5,%ymm7
	vpermilpd	$5,%ymm7,%ymm7
	vdivpd	%ymm3,%ymm7,%ymm0
	vmaskmovpd	%ymm0,%ymm8,(%rdi,%rax,8)
Lj407:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj410
Lj411:
	vmovsldup	(%rdx,%rax,4),%ymm1
	vmovshdup	(%rdx,%rax,4),%ymm2
	vmulps	(%rsi,%rax,4),%ymm1,%ymm1
	vmulps	(%rsi,%rax,4),%ymm2,%ymm2
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovsldup	32(%rdx,%rax,4),%ymm1
	vmovshdup	32(%rdx,%rax,4),%ymm2
	vmulps	32(%rsi,%rax,4),%ymm1,%ymm1
	vmulps	32(%rsi,%rax,4),%ymm2,%ymm2
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm0
	vmovups	%ymm0,32(%rdi,%rax,4)
	vmovsldup	64(%rdx,%rax,4),%ymm1
	vmovshdup	64(%rdx,%rax,4),%ymm2
	vmulps	64(%rsi,%rax,4),%ymm1,%ymm1
	vmulps	64(%rsi,%rax,4),%ymm2,%ymm2
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm0
	vmovups	%ymm0,64(%rdi,%rax,4)
	vmovsldup	96(%rdx,%rax,4),%ymm1
	vmovshdup	96(%rdx,%rax,4),%ymm2
	vmulps	96(%rsi,%rax,4),%ymm1,%ymm1
	vmulps	96(%rsi,%rax,4),%ymm2,%ymm2
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm0
	vmovups	%ymm0,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jg	Lj411
Lj410:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj412
Lj413:
	vmovsldup	(%rdx,%rax,4),%ymm1
	vmovshdup	(%rdx,%rax,4),%ymm2
	vmulps	(%rsi,%rax,4),%ymm1,%ymm1
	vmulps	(%rsi,%rax,4),%ymm2,%ymm2
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jg	Lj413
Lj412:
	andl	$3,%r8d
	jz	Lj414
	shll	$1,%r8d
Lj415:
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm3
	vmaskmovps	(%rsi,%rax,4),%ymm3,%ymm0
	vmovsldup	(%rdx,%rax,4),%ymm1
	vmovshdup	(%rdx,%rax,4),%ymm2
	vmulps	%ymm0,%ymm1,%ymm1
	vmulps	%ymm0,%ymm2,%ymm2
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm0
	vmaskmovps	%ymm0,%ymm3,(%rdi,%rax,4)
Lj414:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_CVS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_CVS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj418
Lj419:
	vpermq	$80,(%rsi,%rax,2),%ymm0
	vpermilps	$80,%ymm0,%ymm1
	vmulps	(%rdx,%rax,4),%ymm1,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	vpermq	$80,16(%rsi,%rax,2),%ymm2
	vpermilps	$80,%ymm2,%ymm3
	vmulps	32(%rdx,%rax,4),%ymm3,%ymm2
	vmovups	%ymm2,32(%rdi,%rax,4)
	vpermq	$80,32(%rsi,%rax,2),%ymm4
	vpermilps	$80,%ymm4,%ymm5
	vmulps	64(%rdx,%rax,4),%ymm5,%ymm4
	vmovups	%ymm4,64(%rdi,%rax,4)
	vpermq	$80,48(%rsi,%rax,2),%ymm6
	vpermilps	$80,%ymm6,%ymm7
	vmulps	96(%rdx,%rax,4),%ymm7,%ymm6
	vmovups	%ymm6,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jg	Lj419
Lj418:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj420
Lj421:
	vpermq	$80,(%rsi,%rax,2),%ymm0
	vpermilps	$80,%ymm0,%ymm1
	vmulps	(%rdx,%rax,4),%ymm1,%ymm1
	vmovups	%ymm1,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jg	Lj421
Lj420:
	andl	$3,%r8d
	jz	Lj422
	shll	$1,%r8d
Lj423:
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm3
	vpermq	$80,(%rsi,%rax,2),%ymm0
	vpermilps	$80,%ymm0,%ymm1
	vmulps	(%rdx,%rax,4),%ymm1,%ymm1
	vmaskmovps	%ymm1,%ymm3,(%rdi,%rax,4)
Lj422:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_CVD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_CVD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$3,%ecx
	jz	Lj426
Lj427:
	vpermq	$80,(%rsi,%rax,4),%ymm1
	vmulpd	(%rdx,%rax,8),%ymm1,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	vpermq	$80,16(%rsi,%rax,4),%ymm2
	vmulpd	32(%rdx,%rax,8),%ymm2,%ymm2
	vmovupd	%ymm2,32(%rdi,%rax,8)
	vpermq	$80,32(%rsi,%rax,4),%ymm3
	vmulpd	64(%rdx,%rax,8),%ymm3,%ymm3
	vmovupd	%ymm3,64(%rdi,%rax,8)
	vpermq	$80,48(%rsi,%rax,4),%ymm4
	vmulpd	96(%rdx,%rax,8),%ymm4,%ymm4
	vmovupd	%ymm4,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jg	Lj427
Lj426:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj428
Lj429:
	vpermq	$80,(%rsi,%rax,4),%ymm1
	vmulpd	(%rdx,%rax,8),%ymm1,%ymm1
	vmovupd	%ymm1,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jg	Lj429
Lj428:
	andl	$1,%r8d
	jz	Lj430
	shll	$1,%r8d
Lj431:
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm3
	vpermq	$80,(%rsi,%rax,4),%ymm1
	vmulpd	(%rdx,%rax,8),%ymm1,%ymm1
	vmaskmovpd	%ymm1,%ymm3,(%rdi,%rax,8)
Lj430:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDOT_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKDOT_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	vxorps	%ymm0,%ymm0,%ymm0
	jz	Lj434
Lj435:
	vmovsldup	(%rdx,%rax,4),%ymm1
	vmovshdup	(%rdx,%rax,4),%ymm2
	vmulps	(%rsi,%rax,4),%ymm2,%ymm2
	vmulps	(%rsi,%rax,4),%ymm1,%ymm1
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm1
	vaddps	%ymm1,%ymm0,%ymm0
	vmovsldup	32(%rdx,%rax,4),%ymm1
	vmovshdup	32(%rdx,%rax,4),%ymm2
	vmulps	32(%rsi,%rax,4),%ymm2,%ymm2
	vmulps	32(%rsi,%rax,4),%ymm1,%ymm1
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm1
	vaddps	%ymm1,%ymm0,%ymm0
	vmovsldup	64(%rdx,%rax,4),%ymm1
	vmovshdup	64(%rdx,%rax,4),%ymm2
	vmulps	64(%rsi,%rax,4),%ymm2,%ymm2
	vmulps	64(%rsi,%rax,4),%ymm1,%ymm1
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm1
	vaddps	%ymm1,%ymm0,%ymm0
	vmovsldup	96(%rdx,%rax,4),%ymm1
	vmovshdup	96(%rdx,%rax,4),%ymm2
	vmulps	96(%rsi,%rax,4),%ymm2,%ymm2
	vmulps	96(%rsi,%rax,4),%ymm1,%ymm1
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm1
	vaddps	%ymm1,%ymm0,%ymm0
	addq	$32,%rax
	decl	%ecx
	jg	Lj435
Lj434:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj436
Lj437:
	vmovsldup	(%rdx,%rax,4),%ymm1
	vmovshdup	(%rdx,%rax,4),%ymm2
	vmulps	(%rsi,%rax,4),%ymm2,%ymm2
	vmulps	(%rsi,%rax,4),%ymm1,%ymm1
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm1
	vaddps	%ymm1,%ymm0,%ymm0
	addq	$8,%rax
	decl	%ecx
	jg	Lj437
Lj436:
	andl	$3,%r8d
	jz	Lj438
	shll	$1,%r8d
Lj439:
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm3
	vmaskmovps	(%rsi,%rax,4),%ymm3,%ymm4
	vmaskmovps	(%rdx,%rax,4),%ymm3,%ymm1
	vmaskmovps	(%rdx,%rax,4),%ymm3,%ymm2
	vmovsldup	%ymm1,%ymm1
	vmovshdup	%ymm2,%ymm2
	vmulps	%ymm4,%ymm2,%ymm2
	vmulps	%ymm4,%ymm1,%ymm1
	vpermilps	$177,%ymm2,%ymm2
	vaddsubps	%ymm2,%ymm1,%ymm1
	vaddps	%ymm1,%ymm0,%ymm0
Lj438:
	vextractf128	$1,%ymm0,%xmm1
	addps	%xmm1,%xmm0
	movhlps	%xmm0,%xmm1
	addps	%xmm1,%xmm0
	vmovlps	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDOT_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKDOT_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$3,%ecx
	vxorps	%ymm0,%ymm0,%ymm0
	jz	Lj442
Lj443:
	vmovddup	(%rdx,%rax,8),%ymm1
	vmovddup	8(%rdx,%rax,8),%ymm2
	vmulpd	(%rsi,%rax,8),%ymm2,%ymm2
	vmulpd	(%rsi,%rax,8),%ymm1,%ymm1
	vpermpd	$177,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm1
	vaddpd	%ymm1,%ymm0,%ymm0
	vmovddup	32(%rdx,%rax,8),%ymm1
	vmovddup	40(%rdx,%rax,8),%ymm2
	vmulpd	32(%rsi,%rax,8),%ymm2,%ymm2
	vmulpd	32(%rsi,%rax,8),%ymm1,%ymm1
	vpermpd	$177,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm1
	vaddpd	%ymm1,%ymm0,%ymm0
	vmovddup	64(%rdx,%rax,8),%ymm1
	vmovddup	72(%rdx,%rax,8),%ymm2
	vmulpd	64(%rsi,%rax,8),%ymm2,%ymm2
	vmulpd	64(%rsi,%rax,8),%ymm1,%ymm1
	vpermpd	$177,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm1
	vaddpd	%ymm1,%ymm0,%ymm0
	vmovddup	96(%rdx,%rax,8),%ymm1
	vmovddup	104(%rdx,%rax,8),%ymm2
	vmulpd	96(%rsi,%rax,8),%ymm2,%ymm2
	vmulpd	96(%rsi,%rax,8),%ymm1,%ymm1
	vpermpd	$177,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm1
	vaddpd	%ymm1,%ymm0,%ymm0
	addq	$16,%rax
	decl	%ecx
	jg	Lj443
Lj442:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj444
Lj445:
	vmovddup	(%rdx,%rax,8),%ymm1
	vmovddup	8(%rdx,%rax,8),%ymm2
	vmulpd	(%rsi,%rax,8),%ymm2,%ymm2
	vmulpd	(%rsi,%rax,8),%ymm1,%ymm1
	vpermpd	$177,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm1
	vaddpd	%ymm1,%ymm0,%ymm0
	addq	$4,%rax
	decl	%ecx
	jg	Lj445
Lj444:
	andl	$1,%r8d
	jz	Lj446
	shll	$1,%r8d
Lj447:
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm3
	vmaskmovpd	(%rsi,%rax,8),%ymm3,%ymm4
	vmaskmovpd	(%rdx,%rax,8),%ymm3,%ymm1
	vmaskmovpd	8(%rdx,%rax,8),%ymm3,%ymm2
	vmovddup	%ymm1,%ymm1
	vmovddup	%ymm2,%ymm2
	vmulpd	%ymm4,%ymm2,%ymm2
	vmulpd	%ymm4,%ymm1,%ymm1
	vpermpd	$177,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm1
	vaddpd	%ymm1,%ymm0,%ymm0
Lj446:
	vextractf128	$1,%ymm0,%xmm1
	addpd	%xmm1,%xmm0
	vmovups	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDOT_CVS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKDOT_CVS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	vxorps	%ymm0,%ymm0,%ymm0
	vxorps	%ymm2,%ymm2,%ymm2
	vxorps	%ymm4,%ymm4,%ymm4
	vxorps	%ymm6,%ymm6,%ymm6
	jz	Lj450
Lj451:
	vpermq	$80,(%rsi,%rax,2),%ymm1
	vpermq	$80,16(%rsi,%rax,2),%ymm3
	vpermq	$80,32(%rsi,%rax,2),%ymm5
	vpermq	$80,48(%rsi,%rax,2),%ymm7
	vpermilps	$80,%ymm1,%ymm1
	vpermilps	$80,%ymm3,%ymm3
	vpermilps	$80,%ymm5,%ymm5
	vpermilps	$80,%ymm7,%ymm7
	vfmadd231ps	(%rdx,%rax,4),%ymm1,%ymm0
	vfmadd231ps	32(%rdx,%rax,4),%ymm3,%ymm2
	vfmadd231ps	64(%rdx,%rax,4),%ymm5,%ymm4
	vfmadd231ps	96(%rdx,%rax,4),%ymm7,%ymm6
	addq	$32,%rax
	decl	%ecx
	jg	Lj451
	vaddps	%ymm2,%ymm0,%ymm0
	vaddps	%ymm6,%ymm4,%ymm4
	vaddps	%ymm4,%ymm0,%ymm0
Lj450:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj452
Lj453:
	vpermq	$80,(%rsi,%rax,2),%ymm1
	vpermilps	$80,%ymm1,%ymm1
	vfmadd231ps	(%rdx,%rax,4),%ymm1,%ymm0
	addq	$8,%rax
	decl	%ecx
	jg	Lj453
Lj452:
	andl	$3,%r8d
	jz	Lj454
	shll	$1,%r8d
Lj455:
	vmovd	%r8d,%xmm1
	vpbroadcastd	%xmm1,%ymm1
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm1,%ymm3
	vpermq	$80,(%rsi,%rax,2),%ymm1
	vpermilps	$80,%ymm1,%ymm1
	vmaskmovps	(%rdx,%rax,4),%ymm3,%ymm2
	vfmadd231ps	%ymm2,%ymm1,%ymm0
Lj454:
	vextractf128	$1,%ymm0,%xmm1
	addps	%xmm1,%xmm0
	movhlps	%xmm0,%xmm1
	addps	%xmm1,%xmm0
	vmovlps	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDOT_CVD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKDOT_CVD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$3,%ecx
	vxorpd	%ymm0,%ymm0,%ymm0
	vxorpd	%ymm2,%ymm2,%ymm2
	vxorpd	%ymm4,%ymm4,%ymm4
	vxorpd	%ymm6,%ymm6,%ymm6
	jz	Lj458
Lj459:
	vpermq	$80,(%rsi,%rax,4),%ymm1
	vpermq	$80,16(%rsi,%rax,4),%ymm3
	vpermq	$80,32(%rsi,%rax,4),%ymm5
	vpermq	$80,48(%rsi,%rax,4),%ymm7
	vfmadd231pd	(%rdx,%rax,8),%ymm1,%ymm0
	vfmadd231pd	32(%rdx,%rax,8),%ymm3,%ymm2
	vfmadd231pd	64(%rdx,%rax,8),%ymm5,%ymm4
	vfmadd231pd	96(%rdx,%rax,8),%ymm7,%ymm6
	addq	$16,%rax
	decl	%ecx
	jg	Lj459
	vaddpd	%ymm2,%ymm0,%ymm0
	vaddpd	%ymm6,%ymm4,%ymm4
	vaddpd	%ymm4,%ymm0,%ymm0
Lj458:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj460
Lj461:
	vpermq	$80,(%rsi,%rax,4),%ymm1
	vfmadd231pd	(%rdx,%rax,8),%ymm1,%ymm0
	addq	$4,%rax
	decl	%ecx
	jg	Lj461
Lj460:
	andl	$1,%r8d
	jz	Lj462
	shll	$1,%r8d
Lj463:
	vmovd	%r8d,%xmm1
	vpbroadcastq	%xmm1,%ymm1
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm1,%ymm3
	vpermq	$80,(%rsi,%rax,4),%ymm1
	vmaskmovpd	(%rdx,%rax,8),%ymm3,%ymm2
	vfmadd231pd	%ymm2,%ymm1,%ymm0
Lj462:
	vextractf128	$1,%ymm0,%xmm1
	addpd	%xmm1,%xmm0
	vmovupd	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKADD_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKADD_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	shll	$1,%ecx
	movl	%ecx,%r8d
	shrl	$5,%ecx
	jz	Lj466
Lj467:
	vmovups	(%rsi,%rax,4),%ymm0
	vmovups	32(%rsi,%rax,4),%ymm1
	vmovups	64(%rsi,%rax,4),%ymm2
	vmovups	96(%rsi,%rax,4),%ymm3
	vaddps	(%rdx,%rax,4),%ymm0,%ymm0
	vaddps	32(%rdx,%rax,4),%ymm1,%ymm1
	vaddps	64(%rdx,%rax,4),%ymm2,%ymm2
	vaddps	96(%rdx,%rax,4),%ymm3,%ymm3
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	%ymm1,32(%rdi,%rax,4)
	vmovups	%ymm2,64(%rdi,%rax,4)
	vmovups	%ymm3,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj467
Lj466:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj468
Lj469:
	vmovups	(%rsi,%rax,4),%ymm0
	vaddps	(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj469
Lj468:
	andl	$7,%r8d
	jle	Lj470
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm1,%ymm0
	vaddps	(%rdx,%rax,4),%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm1,(%rdi,%rax,4)
Lj470:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKADD_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKADD_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	shll	$1,%ecx
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj473
Lj474:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmovupd	64(%rsi,%rax,8),%ymm2
	vmovupd	96(%rsi,%rax,8),%ymm3
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm0
	vaddpd	32(%rdx,%rax,8),%ymm1,%ymm1
	vaddpd	64(%rdx,%rax,8),%ymm2,%ymm2
	vaddpd	96(%rdx,%rax,8),%ymm3,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj474
Lj473:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj475
Lj476:
	vmovupd	(%rsi,%rax,8),%ymm0
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj476
Lj475:
	andl	$3,%r8d
	jle	Lj477
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm1,%ymm0
	vaddpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm1,(%rdi,%rax,8)
Lj477:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUB_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKSUB_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	shll	$1,%ecx
	movl	%ecx,%r8d
	shrl	$5,%ecx
	jz	Lj480
Lj481:
	vmovups	(%rsi,%rax,4),%ymm0
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovups	32(%rsi,%rax,4),%ymm0
	vsubps	32(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,32(%rdi,%rax,4)
	vmovups	64(%rsi,%rax,4),%ymm0
	vsubps	64(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,64(%rdi,%rax,4)
	vmovups	96(%rsi,%rax,4),%ymm0
	vsubps	96(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jnz	Lj481
Lj480:
	movl	%r8d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj482
Lj483:
	vmovups	(%rsi,%rax,4),%ymm0
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jnz	Lj483
Lj482:
	andl	$7,%r8d
	jle	Lj484
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm1,%ymm0
	vsubps	(%rdx,%rax,4),%ymm0,%ymm0
	vmaskmovps	%ymm0,%ymm1,(%rdi,%rax,4)
Lj484:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKSUB_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKSUB_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	shll	$1,%ecx
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj487
Lj488:
	vmovupd	(%rsi,%rax,8),%ymm0
	vmovupd	32(%rsi,%rax,8),%ymm1
	vmovupd	64(%rsi,%rax,8),%ymm2
	vmovupd	96(%rsi,%rax,8),%ymm3
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vsubpd	32(%rdx,%rax,8),%ymm1,%ymm1
	vsubpd	64(%rdx,%rax,8),%ymm2,%ymm2
	vsubpd	96(%rdx,%rax,8),%ymm3,%ymm3
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovupd	%ymm1,32(%rdi,%rax,8)
	vmovupd	%ymm2,64(%rdi,%rax,8)
	vmovupd	%ymm3,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jnz	Lj488
Lj487:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj489
Lj490:
	vmovupd	(%rsi,%rax,8),%ymm0
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jnz	Lj490
Lj489:
	andl	$3,%r8d
	jle	Lj491
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm1,%ymm0
	vsubpd	(%rdx,%rax,8),%ymm0,%ymm0
	vmaskmovpd	%ymm0,%ymm1,(%rdi,%rax,8)
Lj491:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMUL_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKMUL_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$3,%ecx
	jz	Lj494
Lj495:
	vmovddup	(%rdx,%rax,8),%ymm1
	vmovddup	8(%rdx,%rax,8),%ymm2
	vmulpd	(%rsi,%rax,8),%ymm1,%ymm1
	vmulpd	(%rsi,%rax,8),%ymm2,%ymm2
	vpermilpd	$5,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovddup	32(%rdx,%rax,8),%ymm1
	vmovddup	40(%rdx,%rax,8),%ymm2
	vmulpd	32(%rsi,%rax,8),%ymm1,%ymm1
	vmulpd	32(%rsi,%rax,8),%ymm2,%ymm2
	vpermilpd	$5,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm0
	vmovupd	%ymm0,32(%rdi,%rax,8)
	vmovddup	64(%rdx,%rax,8),%ymm1
	vmovddup	72(%rdx,%rax,8),%ymm2
	vmulpd	64(%rsi,%rax,8),%ymm1,%ymm1
	vmulpd	64(%rsi,%rax,8),%ymm2,%ymm2
	vpermilpd	$5,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm0
	vmovupd	%ymm0,64(%rdi,%rax,8)
	vmovddup	96(%rdx,%rax,8),%ymm1
	vmovddup	104(%rdx,%rax,8),%ymm2
	vmulpd	96(%rsi,%rax,8),%ymm1,%ymm1
	vmulpd	96(%rsi,%rax,8),%ymm2,%ymm2
	vpermilpd	$5,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm0
	vmovupd	%ymm0,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jg	Lj495
Lj494:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj496
Lj497:
	vmovddup	(%rdx,%rax,8),%ymm1
	vmovddup	8(%rdx,%rax,8),%ymm2
	vmulpd	(%rsi,%rax,8),%ymm1,%ymm1
	vmulpd	(%rsi,%rax,8),%ymm2,%ymm2
	vpermilpd	$5,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jg	Lj497
Lj496:
	andl	$1,%r8d
	jz	Lj498
	shll	$1,%r8d
Lj499:
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm3
	vmaskmovpd	(%rsi,%rax,8),%ymm3,%ymm0
	vmovddup	(%rdx,%rax,8),%ymm1
	vmovddup	8(%rdx,%rax,8),%ymm2
	vmulpd	%ymm0,%ymm1,%ymm1
	vmulpd	%ymm0,%ymm2,%ymm2
	vpermilpd	$5,%ymm2,%ymm2
	vaddsubpd	%ymm2,%ymm1,%ymm0
	vmaskmovpd	%ymm0,%ymm3,(%rdi,%rax,8)
Lj498:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIV_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKDIV_CCS$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$4,%ecx
	jz	Lj502
Lj503:
	vmovsldup	(%rsi,%rax,4),%ymm0
	vmovshdup	(%rsi,%rax,4),%ymm1
	vmovsldup	(%rdx,%rax,4),%ymm2
	vmovshdup	(%rdx,%rax,4),%ymm3
	vmulps	%ymm2,%ymm2,%ymm2
	vfmadd231ps	%ymm3,%ymm3,%ymm2
	vmulps	(%rdx,%rax,4),%ymm1,%ymm4
	vmulps	(%rdx,%rax,4),%ymm0,%ymm5
	vpermilps	$177,%ymm5,%ymm5
	vaddsubps	%ymm5,%ymm4,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vdivps	%ymm2,%ymm6,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	vmovsldup	32(%rsi,%rax,4),%ymm0
	vmovshdup	32(%rsi,%rax,4),%ymm1
	vmovsldup	32(%rdx,%rax,4),%ymm2
	vmovshdup	32(%rdx,%rax,4),%ymm3
	vmulps	%ymm2,%ymm2,%ymm2
	vfmadd231ps	%ymm3,%ymm3,%ymm2
	vmulps	32(%rdx,%rax,4),%ymm1,%ymm4
	vmulps	32(%rdx,%rax,4),%ymm0,%ymm5
	vpermilps	$177,%ymm5,%ymm5
	vaddsubps	%ymm5,%ymm4,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vdivps	%ymm2,%ymm6,%ymm0
	vmovups	%ymm0,32(%rdi,%rax,4)
	vmovsldup	64(%rsi,%rax,4),%ymm0
	vmovshdup	64(%rsi,%rax,4),%ymm1
	vmovsldup	64(%rdx,%rax,4),%ymm2
	vmovshdup	64(%rdx,%rax,4),%ymm3
	vmulps	%ymm2,%ymm2,%ymm2
	vfmadd231ps	%ymm3,%ymm3,%ymm2
	vmulps	64(%rdx,%rax,4),%ymm1,%ymm4
	vmulps	64(%rdx,%rax,4),%ymm0,%ymm5
	vpermilps	$177,%ymm5,%ymm5
	vaddsubps	%ymm5,%ymm4,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vdivps	%ymm2,%ymm6,%ymm0
	vmovups	%ymm0,64(%rdi,%rax,4)
	vmovsldup	96(%rsi,%rax,4),%ymm0
	vmovshdup	96(%rsi,%rax,4),%ymm1
	vmovsldup	96(%rdx,%rax,4),%ymm2
	vmovshdup	96(%rdx,%rax,4),%ymm3
	vmulps	%ymm2,%ymm2,%ymm2
	vfmadd231ps	%ymm3,%ymm3,%ymm2
	vmulps	96(%rdx,%rax,4),%ymm1,%ymm4
	vmulps	96(%rdx,%rax,4),%ymm0,%ymm5
	vpermilps	$177,%ymm5,%ymm5
	vaddsubps	%ymm5,%ymm4,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vdivps	%ymm2,%ymm6,%ymm0
	vmovups	%ymm0,96(%rdi,%rax,4)
	addq	$32,%rax
	decl	%ecx
	jg	Lj503
Lj502:
	movl	%r8d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jz	Lj504
Lj505:
	vmovsldup	(%rsi,%rax,4),%ymm0
	vmovshdup	(%rsi,%rax,4),%ymm1
	vmovsldup	(%rdx,%rax,4),%ymm2
	vmovshdup	(%rdx,%rax,4),%ymm3
	vmulps	%ymm2,%ymm2,%ymm2
	vfmadd231ps	%ymm3,%ymm3,%ymm2
	vmulps	(%rdx,%rax,4),%ymm1,%ymm4
	vmulps	(%rdx,%rax,4),%ymm0,%ymm5
	vpermilps	$177,%ymm5,%ymm5
	vaddsubps	%ymm5,%ymm4,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vdivps	%ymm2,%ymm6,%ymm0
	vmovups	%ymm0,(%rdi,%rax,4)
	addq	$8,%rax
	decl	%ecx
	jg	Lj505
Lj504:
	andl	$3,%r8d
	jz	Lj506
	shll	$1,%r8d
Lj507:
	vmovd	%r8d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm7
	vmaskmovps	(%rsi,%rax,4),%ymm7,%ymm8
	vmaskmovps	(%rdx,%rax,4),%ymm7,%ymm9
	vmovsldup	%ymm8,%ymm0
	vmovshdup	%ymm8,%ymm1
	vmovsldup	%ymm9,%ymm2
	vmovshdup	%ymm9,%ymm3
	vmulps	%ymm2,%ymm2,%ymm2
	vfmadd231ps	%ymm3,%ymm3,%ymm2
	vmulps	%ymm9,%ymm1,%ymm4
	vmulps	%ymm9,%ymm0,%ymm5
	vpermilps	$177,%ymm5,%ymm5
	vaddsubps	%ymm5,%ymm4,%ymm6
	vpermilps	$177,%ymm6,%ymm6
	vdivps	%ymm2,%ymm6,%ymm0
	vmaskmovps	%ymm0,%ymm7,(%rdi,%rax,4)
Lj506:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKDIV_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_BULKDIV_CCD$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	%ecx,%r8d
	shrl	$3,%ecx
	jz	Lj510
Lj511:
	vmovddup	(%rsi,%rax,8),%ymm0
	vmovddup	8(%rsi,%rax,8),%ymm1
	vmovddup	(%rdx,%rax,8),%ymm2
	vmovddup	8(%rdx,%rax,8),%ymm3
	vmulpd	%ymm2,%ymm2,%ymm2
	vfmadd231pd	%ymm3,%ymm3,%ymm2
	vmulpd	(%rdx,%rax,8),%ymm1,%ymm4
	vmulpd	(%rdx,%rax,8),%ymm0,%ymm5
	vpermilpd	$5,%ymm5,%ymm5
	vaddsubpd	%ymm5,%ymm4,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vdivpd	%ymm2,%ymm6,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	vmovddup	32(%rsi,%rax,8),%ymm0
	vmovddup	40(%rsi,%rax,8),%ymm1
	vmovddup	32(%rdx,%rax,8),%ymm2
	vmovddup	40(%rdx,%rax,8),%ymm3
	vmulpd	%ymm2,%ymm2,%ymm2
	vfmadd231pd	%ymm3,%ymm3,%ymm2
	vmulpd	32(%rdx,%rax,8),%ymm1,%ymm4
	vmulpd	32(%rdx,%rax,8),%ymm0,%ymm5
	vpermilpd	$5,%ymm5,%ymm5
	vaddsubpd	%ymm5,%ymm4,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vdivpd	%ymm2,%ymm6,%ymm0
	vmovupd	%ymm0,32(%rdi,%rax,8)
	vmovddup	64(%rsi,%rax,8),%ymm0
	vmovddup	72(%rsi,%rax,8),%ymm1
	vmovddup	64(%rdx,%rax,8),%ymm2
	vmovddup	72(%rdx,%rax,8),%ymm3
	vmulpd	%ymm2,%ymm2,%ymm2
	vfmadd231pd	%ymm3,%ymm3,%ymm2
	vmulpd	64(%rdx,%rax,8),%ymm1,%ymm4
	vmulpd	64(%rdx,%rax,8),%ymm0,%ymm5
	vpermilpd	$5,%ymm5,%ymm5
	vaddsubpd	%ymm5,%ymm4,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vdivpd	%ymm2,%ymm6,%ymm0
	vmovupd	%ymm0,64(%rdi,%rax,8)
	vmovddup	96(%rsi,%rax,8),%ymm0
	vmovddup	104(%rsi,%rax,8),%ymm1
	vmovddup	96(%rdx,%rax,8),%ymm2
	vmovddup	104(%rdx,%rax,8),%ymm3
	vmulpd	%ymm2,%ymm2,%ymm2
	vfmadd231pd	%ymm3,%ymm3,%ymm2
	vmulpd	96(%rdx,%rax,8),%ymm1,%ymm4
	vmulpd	96(%rdx,%rax,8),%ymm0,%ymm5
	vpermilpd	$5,%ymm5,%ymm5
	vaddsubpd	%ymm5,%ymm4,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vdivpd	%ymm2,%ymm6,%ymm0
	vmovupd	%ymm0,96(%rdi,%rax,8)
	addq	$16,%rax
	decl	%ecx
	jg	Lj511
Lj510:
	movl	%r8d,%ecx
	andl	$7,%ecx
	shrl	$1,%ecx
	jz	Lj512
Lj513:
	vmovddup	(%rsi,%rax,8),%ymm0
	vmovddup	8(%rsi,%rax,8),%ymm1
	vmovddup	(%rdx,%rax,8),%ymm2
	vmovddup	8(%rdx,%rax,8),%ymm3
	vmulpd	%ymm2,%ymm2,%ymm2
	vfmadd231pd	%ymm3,%ymm3,%ymm2
	vmulpd	(%rdx,%rax,8),%ymm1,%ymm4
	vmulpd	(%rdx,%rax,8),%ymm0,%ymm5
	vpermilpd	$5,%ymm5,%ymm5
	vaddsubpd	%ymm5,%ymm4,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vdivpd	%ymm2,%ymm6,%ymm0
	vmovupd	%ymm0,(%rdi,%rax,8)
	addq	$4,%rax
	decl	%ecx
	jg	Lj513
Lj512:
	andl	$1,%r8d
	jz	Lj514
	shll	$1,%r8d
Lj515:
	vmovd	%r8d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm7
	vmaskmovpd	(%rsi,%rax,8),%ymm7,%ymm8
	vmaskmovpd	(%rdx,%rax,8),%ymm7,%ymm9
	vmovddup	%ymm8,%ymm0
	vpermpd	$245,%ymm8,%ymm1
	vmovddup	%ymm9,%ymm2
	vpermpd	$245,%ymm9,%ymm3
	vmulpd	%ymm2,%ymm2,%ymm2
	vfmadd231pd	%ymm3,%ymm3,%ymm2
	vmulpd	%ymm9,%ymm1,%ymm4
	vmulpd	%ymm9,%ymm0,%ymm5
	vpermilpd	$5,%ymm5,%ymm5
	vaddsubpd	%ymm5,%ymm4,%ymm6
	vpermilpd	$5,%ymm6,%ymm6
	vdivpd	%ymm2,%ymm6,%ymm0
	vmaskmovpd	%ymm0,%ymm7,(%rdi,%rax,8)
Lj514:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKCONV_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$LONGINT$BOOLEAN
_OPRS_SIMD_$$_BULKCONV_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$LONGINT$BOOLEAN:
#  CPU ATHLON64
	subq	%r8,%rcx
	incq	%rcx
	movl	%ecx,%r10d
	shrl	$5,%ecx
	jz	Lj518
Lj519:
	movq	%r8,%rax
	vxorps	%ymm0,%ymm0,%ymm0
	vxorps	%ymm2,%ymm2,%ymm2
	vxorps	%ymm3,%ymm3,%ymm3
	vxorps	%ymm4,%ymm4,%ymm4
Lj520:
	decq	%rax
	vbroadcastss	(%rdx,%rax,4),%ymm1
	vfmadd231ps	(%rsi,%rax,4),%ymm1,%ymm0
	vfmadd231ps	32(%rsi,%rax,4),%ymm1,%ymm2
	vfmadd231ps	64(%rsi,%rax,4),%ymm1,%ymm3
	vfmadd231ps	96(%rsi,%rax,4),%ymm1,%ymm4
	jnz	Lj520
	testq	$1,%r9
	jz	Lj521
	vaddps	(%rdi),%ymm0,%ymm0
	vaddps	32(%rdi),%ymm2,%ymm2
	vaddps	64(%rdi),%ymm3,%ymm3
	vaddps	96(%rdi),%ymm4,%ymm4
Lj521:
	vmovups	%ymm0,(%rdi)
	vmovups	%ymm2,32(%rdi)
	vmovups	%ymm3,64(%rdi)
	vmovups	%ymm4,96(%rdi)
	addq	$128,%rsi
	addq	$128,%rdi
	decl	%ecx
	jnz	Lj519
Lj518:
	movl	%r10d,%ecx
	andl	$31,%ecx
	shrl	$3,%ecx
	jle	Lj522
Lj523:
	movq	%r8,%rax
	vxorps	%ymm0,%ymm0,%ymm0
Lj524:
	decq	%rax
	vbroadcastss	(%rdx,%rax,4),%ymm1
	vfmadd231ps	(%rsi,%rax,4),%ymm1,%ymm0
	jnz	Lj524
	testq	$1,%r9
	jz	Lj525
	vaddps	(%rdi),%ymm0,%ymm0
Lj525:
	vmovups	%ymm0,(%rdi)
	addq	$32,%rsi
	addq	$32,%rdi
	decl	%ecx
	jnz	Lj523
Lj522:
	andl	$7,%r10d
	jle	Lj526
	vmovd	%r10d,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm2
	movq	%r8,%rax
	vxorps	%ymm0,%ymm0,%ymm0
Lj527:
	decq	%rax
	vbroadcastss	(%rdx,%rax,4),%ymm1
	vmaskmovps	(%rsi,%rax,4),%ymm2,%ymm3
	vfmadd231ps	%ymm3,%ymm1,%ymm0
	jnz	Lj527
	testq	$1,%r9
	jz	Lj528
	vmaskmovps	(%rdi),%ymm2,%ymm3
	vaddps	%ymm3,%ymm0,%ymm0
Lj528:
	vmaskmovps	%ymm0,%ymm2,(%rdi)
Lj526:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKCONV_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$LONGINT$BOOLEAN
_OPRS_SIMD_$$_BULKCONV_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$LONGINT$BOOLEAN:
#  CPU ATHLON64
	subq	%r8,%rcx
	incq	%rcx
	movl	%ecx,%r10d
	shrl	$4,%ecx
	jz	Lj531
Lj532:
	movq	%r8,%rax
	vxorpd	%ymm0,%ymm0,%ymm0
	vxorpd	%ymm2,%ymm2,%ymm2
	vxorpd	%ymm3,%ymm3,%ymm3
	vxorpd	%ymm4,%ymm4,%ymm4
Lj533:
	decq	%rax
	vbroadcastsd	(%rdx,%rax,8),%ymm1
	vfmadd231pd	(%rsi,%rax,8),%ymm1,%ymm0
	vfmadd231pd	32(%rsi,%rax,8),%ymm1,%ymm2
	vfmadd231pd	64(%rsi,%rax,8),%ymm1,%ymm3
	vfmadd231pd	96(%rsi,%rax,8),%ymm1,%ymm4
	jnz	Lj533
	testq	$1,%r9
	jz	Lj534
	vaddpd	(%rdi),%ymm0,%ymm0
	vaddpd	32(%rdi),%ymm2,%ymm2
	vaddpd	64(%rdi),%ymm3,%ymm3
	vaddpd	96(%rdi),%ymm4,%ymm4
Lj534:
	vmovupd	%ymm0,(%rdi)
	vmovupd	%ymm2,32(%rdi)
	vmovupd	%ymm3,64(%rdi)
	vmovupd	%ymm4,96(%rdi)
	addq	$128,%rsi
	addq	$128,%rdi
	decl	%ecx
	jnz	Lj532
Lj531:
	movl	%r10d,%ecx
	andl	$15,%ecx
	shrl	$2,%ecx
	jle	Lj535
Lj536:
	movq	%r8,%rax
	vxorpd	%ymm0,%ymm0,%ymm0
Lj537:
	decq	%rax
	vbroadcastsd	(%rdx,%rax,8),%ymm1
	vfmadd231pd	(%rsi,%rax,8),%ymm1,%ymm0
	jnz	Lj537
	testq	$1,%r9
	jz	Lj538
	vaddpd	(%rdi),%ymm0,%ymm0
Lj538:
	vmovupd	%ymm0,(%rdi)
	addq	$32,%rsi
	addq	$32,%rdi
	decl	%ecx
	jnz	Lj536
Lj535:
	andl	$3,%r10d
	jle	Lj539
	vmovd	%r10d,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm2
	movq	%r8,%rax
	vxorpd	%ymm0,%ymm0,%ymm0
Lj540:
	decq	%rax
	vbroadcastsd	(%rdx,%rax,8),%ymm1
	vmaskmovpd	(%rsi,%rax,8),%ymm2,%ymm3
	vfmadd231pd	%ymm3,%ymm1,%ymm0
	jnz	Lj540
	testq	$1,%r9
	jz	Lj541
	vmaskmovpd	(%rdi),%ymm2,%ymm3
	vaddpd	%ymm3,%ymm0,%ymm0
Lj541:
	vmaskmovpd	%ymm0,%ymm2,(%rdi)
Lj539:
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_MUL_CCS$PSINGLE$PSINGLE$PSINGLE
_OPRS_SIMD_$$_MUL_CCS$PSINGLE$PSINGLE$PSINGLE:
#  CPU ATHLON64
	vmovsldup	(%rdx),%xmm1
	vmovshdup	(%rdx),%xmm2
	vmulps	(%rsi),%xmm2,%xmm2
	vmulps	(%rsi),%xmm1,%xmm1
	vpermilps	$177,%xmm2,%xmm2
	vaddsubps	%xmm2,%xmm1,%xmm0
	vmovlps	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_MUL_CCD$PDOUBLE$PDOUBLE$PDOUBLE
_OPRS_SIMD_$$_MUL_CCD$PDOUBLE$PDOUBLE$PDOUBLE:
#  CPU ATHLON64
	vmovddup	(%rdx),%xmm1
	vmovddup	8(%rdx),%xmm2
	vmulpd	(%rsi),%xmm2,%xmm2
	vmulpd	(%rsi),%xmm1,%xmm1
	vpermilpd	$5,%xmm2,%xmm2
	vaddsubpd	%xmm2,%xmm1,%xmm0
	vmovlpd	%xmm0,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_KAHANSUM_S$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_KAHANSUM_S$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	vpxor	%ymm11,%ymm11,%ymm11
	vpxor	%ymm12,%ymm12,%ymm12
	movl	%edx,%ecx
	shrl	$3,%ecx
	jz	Lj572_1
Lj573_1:
	vmovups	(%rsi),%ymm13
	vsubps	%ymm12,%ymm13,%ymm13
	vaddps	%ymm11,%ymm13,%ymm14
	vsubps	%ymm11,%ymm14,%ymm15
	vsubps	%ymm13,%ymm15,%ymm12
	vmovaps	%ymm14,%ymm11
	addq	$32,%rsi
	decl	%ecx
	jnz	Lj573_1
Lj572_1:
	movl	%edx,%ecx
	andl	$7,%ecx
	jz	Lj574_1
	vpxor	%ymm13,%ymm13,%ymm13
	vmovd	%ecx,%xmm0
	vpbroadcastd	%xmm0,%ymm0
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm0,%ymm0
	vmaskmovps	(%rsi),%ymm0,%ymm13
	vsubps	%ymm12,%ymm13,%ymm13
	vaddps	%ymm11,%ymm13,%ymm14
	vsubps	%ymm11,%ymm14,%ymm15
	vsubps	%ymm13,%ymm15,%ymm12
	vmovaps	%ymm14,%ymm11
Lj574_1:
	vextractf128	$1,%ymm11,%xmm12
	vzeroupper
	vaddps	%xmm12,%xmm11,%xmm11
	vhaddps	%xmm11,%xmm11,%xmm11
	vhaddps	%xmm11,%xmm11,%xmm11
	vmovss	%xmm11,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_KAHANSUM_D$PDOUBLE$PDOUBLE$LONGINT
_OPRS_SIMD_$$_KAHANSUM_D$PDOUBLE$PDOUBLE$LONGINT:
#  CPU ATHLON64
	vpxor	%ymm11,%ymm11,%ymm11
	vpxor	%ymm12,%ymm12,%ymm12
	movl	%edx,%ecx
	shrl	$2,%ecx
	jz	Lj577_1
Lj578_1:
	vmovupd	(%rsi),%ymm13
	vsubpd	%ymm12,%ymm13,%ymm13
	vaddpd	%ymm11,%ymm13,%ymm14
	vsubpd	%ymm11,%ymm14,%ymm15
	vsubpd	%ymm13,%ymm15,%ymm12
	vmovapd	%ymm14,%ymm11
	addq	$32,%rsi
	decl	%ecx
	jnz	Lj578_1
Lj577_1:
	movl	%edx,%ecx
	andl	$3,%ecx
	jz	Lj579_1
	vpxor	%ymm13,%ymm13,%ymm13
	vmovd	%ecx,%xmm0
	vpbroadcastq	%xmm0,%ymm0
	vpcmpgtq	_TC_$OPRS_SIMD_$$_YMMQ(%rip),%ymm0,%ymm0
	vmaskmovpd	(%rsi),%ymm0,%ymm13
	vsubpd	%ymm12,%ymm13,%ymm13
	vaddpd	%ymm11,%ymm13,%ymm14
	vsubpd	%ymm11,%ymm14,%ymm15
	vsubpd	%ymm13,%ymm15,%ymm12
	vmovapd	%ymm14,%ymm11
Lj579_1:
	vextractf128	$1,%ymm11,%xmm12
	vzeroupper
	vaddpd	%xmm12,%xmm11,%xmm11
	vhaddpd	%xmm11,%xmm11,%xmm11
	vmovsd	%xmm11,(%rdi)
#  CPU ATHLON64
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKMULSPLIT_CCS$PSINGLE$PSINGLE$PSINGLE$PSINGLE$PSINGLE$PSINGLE$LONGINT
_OPRS_SIMD_$$_BULKMULSPLIT_CCS$PSINGLE$PSINGLE$PSINGLE$PSINGLE$PSINGLE$PSINGLE$LONGINT:
#  CPU ATHLON64
	xorq	%rax,%rax
	movl	16(%rbp),%r10d
	shrl	$3,%r10d
	jz	Lj582_1
Lj583_1:
	vmovups	(%rdx,%rax,4),%ymm0
	vmulps	(%rcx,%rax,4),%ymm0,%ymm2
	vmovups	(%r8,%rax,4),%ymm1
	vmulps	(%r9,%rax,4),%ymm1,%ymm3
	vsubps	%ymm3,%ymm2,%ymm4
	vmovups	%ymm4,(%rdi,%rax,4)
	vmulps	(%r9,%rax,4),%ymm0,%ymm2
	vmulps	(%rcx,%rax,4),%ymm1,%ymm3
	vaddps	%ymm3,%ymm2,%ymm4
	vmovups	%ymm4,(%rsi,%rax,4)
	addq	$8,%rax
	decl	%r10d
	jg	Lj583_1
Lj582_1:
	andl	$7,16(%rbp)
	jz	Lj584_1
	vmovss	16(%rbp),%xmm0
	vpbroadcastd	%xmm0,%ymm5
	vpcmpgtd	_TC_$OPRS_SIMD_$$_YMMD(%rip),%ymm5,%ymm5
	vmaskmovps	(%rdx,%rax,4),%ymm5,%ymm0
	vmulps	(%rcx,%rax,4),%ymm0,%ymm2
	vmaskmovps	(%r8,%rax,4),%ymm5,%ymm1
	vmulps	(%r9,%rax,4),%ymm1,%ymm3
	vsubps	%ymm3,%ymm2,%ymm4
	vmaskmovps	%ymm4,%ymm5,(%rdi,%rax,4)
	vmulps	(%r9,%rax,4),%ymm0,%ymm2
	vmulps	(%rcx,%rax,4),%ymm1,%ymm3
	vaddps	%ymm3,%ymm2,%ymm4
	vmaskmovps	%ymm4,%ymm5,(%rsi,%rax,4)
Lj584_1:
#  CPU ATHLON64
	ret
# End asmlist al_pure_assembler
# Begin asmlist al_procedures

.text
	.align 3
_OPRS_SIMD_$$_assign$__M256$$ANSISTRING:
	pushq	%rbx
	pushq	%r12
	leaq	-552(%rsp),%rsp
	movq	%rdi,%rbx
	movq	%rsi,%r12
	movq	$0,128(%rsp)
	movq	%rsp,%rdx
	leaq	32(%rsp),%rsi
	movl	$1,%edi
	call	fpc_pushexceptaddr
	movq	%rax,%rdi
	call	fpc_setjmp
	movslq	%eax,%rdx
	movq	%rdx,96(%rsp)
	testl	%eax,%eax
	jne	Lj6
	flds	(%r12)
	fstpt	288(%rsp)
	leaq	288(%rsp),%rax
	movq	%rax,168(%rsp)
	movq	$3,160(%rsp)
	flds	4(%r12)
	fstpt	320(%rsp)
	leaq	320(%rsp),%rax
	movq	%rax,184(%rsp)
	movq	$3,176(%rsp)
	flds	8(%r12)
	fstpt	352(%rsp)
	leaq	352(%rsp),%rax
	movq	%rax,200(%rsp)
	movq	$3,192(%rsp)
	flds	12(%r12)
	fstpt	384(%rsp)
	leaq	384(%rsp),%rax
	movq	%rax,216(%rsp)
	movq	$3,208(%rsp)
	flds	16(%r12)
	fstpt	416(%rsp)
	leaq	416(%rsp),%rax
	movq	%rax,232(%rsp)
	movq	$3,224(%rsp)
	flds	20(%r12)
	fstpt	448(%rsp)
	leaq	448(%rsp),%rax
	movq	%rax,248(%rsp)
	movq	$3,240(%rsp)
	flds	24(%r12)
	fstpt	480(%rsp)
	leaq	480(%rsp),%rax
	movq	%rax,264(%rsp)
	movq	$3,256(%rsp)
	flds	28(%r12)
	fstpt	512(%rsp)
	leaq	512(%rsp),%rax
	movq	%rax,280(%rsp)
	movq	$3,272(%rsp)
	leaq	160(%rsp),%rdx
	movl	$7,%ecx
	leaq	_$$fpclocal$_ld1+24(%rip),%rsi
	leaq	128(%rsp),%rdi
	call	_SYSUTILS_$$_FORMAT$ANSISTRING$array_of_const$$ANSISTRING
	movq	128(%rsp),%rsi
	movq	%rbx,%rdi
	call	fpc_ansistr_assign
Lj6:
	call	fpc_popaddrstack
	leaq	128(%rsp),%rdi
	call	fpc_ansistr_decr_ref
	movq	96(%rsp),%rax
	testq	%rax,%rax
	je	Lj5
	call	fpc_reraise
Lj5:
	leaq	552(%rsp),%rsp
	popq	%r12
	popq	%rbx
	ret

.text
	.align 3
_OPRS_SIMD_$$_assign$__M256I$$ANSISTRING:
	pushq	%rbx
	pushq	%r12
	leaq	-296(%rsp),%rsp
	movq	%rdi,%rbx
	movq	%rsi,%r12
	movq	$0,128(%rsp)
	movq	%rsp,%rdx
	leaq	32(%rsp),%rsi
	movl	$1,%edi
	call	fpc_pushexceptaddr
	movq	%rax,%rdi
	call	fpc_setjmp
	movslq	%eax,%rdx
	movq	%rdx,96(%rsp)
	testl	%eax,%eax
	jne	Lj10
	movl	(%r12),%eax
	movl	%eax,168(%rsp)
	movq	$0,160(%rsp)
	movl	4(%r12),%eax
	movl	%eax,184(%rsp)
	movq	$0,176(%rsp)
	movl	8(%r12),%eax
	movl	%eax,200(%rsp)
	movq	$0,192(%rsp)
	movl	12(%r12),%eax
	movl	%eax,216(%rsp)
	movq	$0,208(%rsp)
	movl	16(%r12),%eax
	movl	%eax,232(%rsp)
	movq	$0,224(%rsp)
	movl	20(%r12),%eax
	movl	%eax,248(%rsp)
	movq	$0,240(%rsp)
	movl	24(%r12),%eax
	movl	%eax,264(%rsp)
	movq	$0,256(%rsp)
	movl	28(%r12),%eax
	movl	%eax,280(%rsp)
	movq	$0,272(%rsp)
	leaq	160(%rsp),%rdx
	movl	$7,%ecx
	leaq	_$$fpclocal$_ld2+24(%rip),%rsi
	leaq	128(%rsp),%rdi
	call	_SYSUTILS_$$_FORMAT$ANSISTRING$array_of_const$$ANSISTRING
	movq	128(%rsp),%rsi
	movq	%rbx,%rdi
	call	fpc_ansistr_assign
Lj10:
	call	fpc_popaddrstack
	leaq	128(%rsp),%rdi
	call	fpc_ansistr_decr_ref
	movq	96(%rsp),%rax
	testq	%rax,%rax
	je	Lj9
	call	fpc_reraise
Lj9:
	leaq	296(%rsp),%rsp
	popq	%r12
	popq	%rbx
	ret

.text
	.align 3
_OPRS_SIMD_$$_assign$__M256D$$ANSISTRING:
	pushq	%rbx
	pushq	%r12
	leaq	-360(%rsp),%rsp
	movq	%rdi,%rbx
	movq	%rsi,%r12
	movq	$0,128(%rsp)
	movq	%rsp,%rdx
	leaq	32(%rsp),%rsi
	movl	$1,%edi
	call	fpc_pushexceptaddr
	movq	%rax,%rdi
	call	fpc_setjmp
	movslq	%eax,%rdx
	movq	%rdx,96(%rsp)
	testl	%eax,%eax
	jne	Lj14
	fldl	(%r12)
	fstpt	224(%rsp)
	leaq	224(%rsp),%rax
	movq	%rax,168(%rsp)
	movq	$3,160(%rsp)
	fldl	8(%r12)
	fstpt	256(%rsp)
	leaq	256(%rsp),%rax
	movq	%rax,184(%rsp)
	movq	$3,176(%rsp)
	fldl	16(%r12)
	fstpt	288(%rsp)
	leaq	288(%rsp),%rax
	movq	%rax,200(%rsp)
	movq	$3,192(%rsp)
	fldl	24(%r12)
	fstpt	320(%rsp)
	leaq	320(%rsp),%rax
	movq	%rax,216(%rsp)
	movq	$3,208(%rsp)
	leaq	160(%rsp),%rdx
	movl	$3,%ecx
	leaq	_$$fpclocal$_ld3+24(%rip),%rsi
	leaq	128(%rsp),%rdi
	call	_SYSUTILS_$$_FORMAT$ANSISTRING$array_of_const$$ANSISTRING
	movq	128(%rsp),%rsi
	movq	%rbx,%rdi
	call	fpc_ansistr_assign
Lj14:
	call	fpc_popaddrstack
	leaq	128(%rsp),%rdi
	call	fpc_ansistr_decr_ref
	movq	96(%rsp),%rax
	testq	%rax,%rax
	je	Lj13
	call	fpc_reraise
Lj13:
	leaq	360(%rsp),%rsp
	popq	%r12
	popq	%rbx
	ret

.text
	.align 3
_OPRS_SIMD_$$_assign$__M256Q$$ANSISTRING:
	pushq	%rbx
	pushq	%r12
	leaq	-232(%rsp),%rsp
	movq	%rdi,%rbx
	movq	%rsi,%r12
	movq	$0,128(%rsp)
	movq	%rsp,%rdx
	leaq	32(%rsp),%rsi
	movl	$1,%edi
	call	fpc_pushexceptaddr
	movq	%rax,%rdi
	call	fpc_setjmp
	movslq	%eax,%rdx
	movq	%rdx,96(%rsp)
	testl	%eax,%eax
	jne	Lj18
	movq	%r12,168(%rsp)
	movq	$16,160(%rsp)
	leaq	8(%r12),%rax
	movq	%rax,184(%rsp)
	movq	$16,176(%rsp)
	leaq	16(%r12),%rax
	movq	%rax,200(%rsp)
	movq	$16,192(%rsp)
	leaq	24(%r12),%rax
	movq	%rax,216(%rsp)
	movq	$16,208(%rsp)
	leaq	160(%rsp),%rdx
	movl	$3,%ecx
	leaq	_$$fpclocal$_ld4+24(%rip),%rsi
	leaq	128(%rsp),%rdi
	call	_SYSUTILS_$$_FORMAT$ANSISTRING$array_of_const$$ANSISTRING
	movq	128(%rsp),%rsi
	movq	%rbx,%rdi
	call	fpc_ansistr_assign
Lj18:
	call	fpc_popaddrstack
	leaq	128(%rsp),%rdi
	call	fpc_ansistr_decr_ref
	movq	96(%rsp),%rax
	testq	%rax,%rax
	je	Lj17
	call	fpc_reraise
Lj17:
	leaq	232(%rsp),%rsp
	popq	%r12
	popq	%rbx
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKCONV2D_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$LONGINT$LONGINT$LONGINT
_OPRS_SIMD_$$_BULKCONV2D_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$LONGINT$LONGINT$LONGINT:
	pushq	%rbp
	movq	%rsp,%rbp
	leaq	-288(%rsp),%rsp
	movq	%rbx,-288(%rbp)
	movq	%r12,-280(%rbp)
	movq	%r13,-272(%rbp)
	movq	%r14,-264(%rbp)
	movq	%r15,-256(%rbp)
	movq	%rdi,-128(%rbp)
	movq	%rsi,-64(%rbp)
	movq	%rdx,-96(%rbp)
	movl	%ecx,%eax
	movq	%rax,-192(%rbp)
	movl	%r8d,%ebx
	movl	%r9d,%eax
	movq	%rax,-160(%rbp)
	movl	16(%rbp),%eax
	movq	%rax,-32(%rbp)
	movslq	-160(%rbp),%rdx
	subq	$1,%rdx
	movq	%rdx,%rax
	shrq	$63,%rax
	addq	%rax,%rdx
	sarq	$1,%rdx
	movl	%edx,%eax
	movq	%rax,-224(%rbp)
	movslq	-32(%rbp),%rax
	subq	$1,%rax
	movq	%rax,%rdx
	shrq	$63,%rdx
	addq	%rdx,%rax
	sarq	$1,%rax
	movl	%eax,%r15d
	movslq	-192(%rbp),%rsi
	movslq	%ebx,%rax
	imulq	%rax,%rsi
	movq	-128(%rbp),%rdi
	xorl	%edx,%edx
	call	_SYSTEM_$$_FILLDWORD$formal$INT64$LONGWORD
	movl	%ebx,%eax
	movl	-32(%rbp),%edx
	subl	%edx,%eax
	movl	%eax,%r14d
	testl	%r14d,%r14d
	jnge	Lj545
	movl	$-1,%r13d
	.align 2
Lj546:
	addl	$1,%r13d
	movl	-32(%rbp),%edx
	leal	-1(%edx),%ebx
	testl	%ebx,%ebx
	jnge	Lj550
	movl	$-1,%r12d
	.align 2
Lj551:
	addl	$1,%r12d
	movslq	%r13d,%rcx
	movslq	-192(%rbp),%rax
	imulq	%rax,%rcx
	movslq	%r12d,%rdx
	imulq	%rax,%rdx
	leaq	(%rcx,%rdx),%rax
	movq	-64(%rbp),%rdx
	leaq	(%rdx,%rax,4),%rsi
	movslq	%r13d,%rax
	movslq	%r15d,%rdx
	addq	%rax,%rdx
	movslq	-192(%rbp),%rax
	imulq	%rax,%rdx
	movslq	-224(%rbp),%rax
	addq	%rax,%rdx
	movq	-128(%rbp),%rax
	leaq	(%rax,%rdx,4),%rdi
	movslq	%r12d,%rdx
	movslq	-160(%rbp),%rax
	imulq	%rax,%rdx
	movq	-96(%rbp),%rax
	leaq	(%rax,%rdx,4),%rdx
	testl	%r12d,%r12d
	setgb	%al
	movb	%al,%r9b
	movl	-160(%rbp),%r8d
	movl	-192(%rbp),%ecx
	call	_OPRS_SIMD_$$_BULKCONV_S$PSINGLE$PSINGLE$PSINGLE$LONGINT$LONGINT$BOOLEAN
	cmpl	%r12d,%ebx
	jnle	Lj551
Lj550:
	cmpl	%r13d,%r14d
	jnle	Lj546
Lj545:
	movq	-288(%rbp),%rbx
	movq	-280(%rbp),%r12
	movq	-272(%rbp),%r13
	movq	-264(%rbp),%r14
	movq	-256(%rbp),%r15
	movq	%rbp,%rsp
	popq	%rbp
	ret

.text
	.align 3
.globl	_OPRS_SIMD_$$_BULKCONV2D_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$LONGINT$LONGINT$LONGINT
_OPRS_SIMD_$$_BULKCONV2D_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$LONGINT$LONGINT$LONGINT:
	pushq	%rbp
	movq	%rsp,%rbp
	leaq	-288(%rsp),%rsp
	movq	%rbx,-288(%rbp)
	movq	%r12,-280(%rbp)
	movq	%r13,-272(%rbp)
	movq	%r14,-264(%rbp)
	movq	%r15,-256(%rbp)
	movq	%rdi,-128(%rbp)
	movq	%rsi,-64(%rbp)
	movq	%rdx,-96(%rbp)
	movl	%ecx,%eax
	movq	%rax,-192(%rbp)
	movl	%r8d,%ebx
	movl	%r9d,%eax
	movq	%rax,-160(%rbp)
	movl	16(%rbp),%eax
	movq	%rax,-32(%rbp)
	movslq	-160(%rbp),%rdx
	subq	$1,%rdx
	movq	%rdx,%rax
	shrq	$63,%rax
	addq	%rax,%rdx
	sarq	$1,%rdx
	movl	%edx,%eax
	movq	%rax,-224(%rbp)
	movslq	-32(%rbp),%rax
	subq	$1,%rax
	movq	%rax,%rdx
	shrq	$63,%rdx
	addq	%rdx,%rax
	sarq	$1,%rax
	movl	%eax,%r15d
	movslq	-192(%rbp),%rsi
	movslq	%ebx,%rax
	imulq	%rax,%rsi
	movq	-128(%rbp),%rdi
	xorl	%edx,%edx
	call	_SYSTEM_$$_FILLQWORD$formal$INT64$QWORD
	movl	%ebx,%eax
	movl	-32(%rbp),%edx
	subl	%edx,%eax
	movl	%eax,%r14d
	testl	%r14d,%r14d
	jnge	Lj557
	movl	$-1,%r13d
	.align 2
Lj558:
	addl	$1,%r13d
	movl	-32(%rbp),%edx
	leal	-1(%edx),%ebx
	testl	%ebx,%ebx
	jnge	Lj562
	movl	$-1,%r12d
	.align 2
Lj563:
	addl	$1,%r12d
	movslq	%r13d,%rcx
	movslq	-192(%rbp),%rax
	imulq	%rax,%rcx
	movslq	%r12d,%rdx
	imulq	%rax,%rdx
	leaq	(%rcx,%rdx),%rax
	movq	-64(%rbp),%rdx
	leaq	(%rdx,%rax,8),%rsi
	movslq	%r13d,%rax
	movslq	%r15d,%rdx
	addq	%rax,%rdx
	movslq	-192(%rbp),%rax
	imulq	%rax,%rdx
	movslq	-224(%rbp),%rax
	addq	%rax,%rdx
	movq	-128(%rbp),%rax
	leaq	(%rax,%rdx,8),%rdi
	movslq	%r12d,%rdx
	movslq	-160(%rbp),%rax
	imulq	%rax,%rdx
	movq	-96(%rbp),%rax
	leaq	(%rax,%rdx,8),%rdx
	testl	%r12d,%r12d
	setgb	%al
	movb	%al,%r9b
	movl	-160(%rbp),%r8d
	movl	-192(%rbp),%ecx
	call	_OPRS_SIMD_$$_BULKCONV_D$PDOUBLE$PDOUBLE$PDOUBLE$LONGINT$LONGINT$BOOLEAN
	cmpl	%r12d,%ebx
	jnle	Lj563
Lj562:
	cmpl	%r13d,%r14d
	jnle	Lj558
Lj557:
	movq	-288(%rbp),%rbx
	movq	-280(%rbp),%r12
	movq	-272(%rbp),%r13
	movq	-264(%rbp),%r14
	movq	-256(%rbp),%r15
	movq	%rbp,%rsp
	popq	%rbp
	ret

.text
	.align 3
_OPRS_SIMD_$$_ARGCHECK$crcB2CB2C96:
	pushq	%rbp
	movq	%rsp,%rbp
	leaq	-32(%rsp),%rsp
	movq	24(%rbp),%rax
	movaps	%xmm1,%xmm0
	movq	%rbp,%rsp
	popq	%rbp
	ret
# End asmlist al_procedures
# Begin asmlist al_typedconsts

.data
	.align 5
_TC_$OPRS_SIMD_$$_ZMMD:
	.long	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

.data
	.align 5
_TC_$OPRS_SIMD_$$_ZMMQ:
	.quad	0,1,2,3,4,5,6,7

.data
	.align 5
_TC_$OPRS_SIMD_$$_YMMD:
	.long	0,1,2,3,4,5,6,7

.data
	.align 5
_TC_$OPRS_SIMD_$$_YMMQ:
	.quad	0,1,2,3

.data
	.align 5
_TC_$OPRS_SIMD_$$_XMMD:
	.long	0,1,2,3

.data
	.align 5
_TC_$OPRS_SIMD_$$_XMMQ:
	.quad	0,1

.data
	.align 5
_TC_$OPRS_SIMD_$$_MSKD:
	.long	-1,-1,-1,-1,-1,-1,-1,-1

.data
	.align 5
_TC_$OPRS_SIMD_$$_MSKQ:
	.quad	-1,-1,-1,-1

.const
	.align 5
_$$fpclocal$_ld1:
	.short	0,1
	.long	0
	.quad	-1,25
	.ascii	"[%f %f %f %f %f %f %f %f]\000"

.const
	.align 5
_$$fpclocal$_ld2:
	.short	0,1
	.long	0
	.quad	-1,25
	.ascii	"[%d %d %d %d %d %d %d %d]\000"

.const
	.align 5
_$$fpclocal$_ld3:
	.short	0,1
	.long	0
	.quad	-1,13
	.ascii	"[%f %f %f %f]\000"

.const
	.align 5
_$$fpclocal$_ld4:
	.short	0,1
	.long	0
	.quad	-1,13
	.ascii	"[%d %d %d %d]\000"
# End asmlist al_typedconsts
# Begin asmlist al_rtti

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_TINT32ARRAY
_RTTI_$OPRS_SIMD_$$_TINT32ARRAY:
	.byte	21,11
	.ascii	"TInt32Array"
	.quad	4
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.long	3
	.quad	0
	.byte	9
	.ascii	"oprs_simd"

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M128
_INIT_$OPRS_SIMD_$$___M128:
	.byte	13,6
	.ascii	"__m128"
	.quad	0
	.long	100
	.quad	0,0
	.long	0

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000003
_RTTI_$OPRS_SIMD_$$_def00000003:
	.byte	12,0
	.quad	16,4
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.byte	1
	.quad	_RTTI_$SYSTEM_$$_SHORTINT$indirect

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M128
_RTTI_$OPRS_SIMD_$$___M128:
	.byte	13,6
	.ascii	"__m128"
	.quad	_INIT_$OPRS_SIMD_$$___M128
	.long	100,5
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	0
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	32
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	64
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	96
	.quad	_RTTI_$OPRS_SIMD_$$_def00000003$indirect
	.quad	0

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M128I
_INIT_$OPRS_SIMD_$$___M128I:
	.byte	13,7
	.ascii	"__m128i"
	.quad	0
	.long	100
	.quad	0,0
	.long	0

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000006
_RTTI_$OPRS_SIMD_$$_def00000006:
	.byte	12,0
	.quad	16,4
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.byte	1
	.quad	_RTTI_$SYSTEM_$$_SHORTINT$indirect

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M128I
_RTTI_$OPRS_SIMD_$$___M128I:
	.byte	13,7
	.ascii	"__m128i"
	.quad	_INIT_$OPRS_SIMD_$$___M128I
	.long	100,5
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	0
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	32
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	64
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	96
	.quad	_RTTI_$OPRS_SIMD_$$_def00000006$indirect
	.quad	0

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M128Q
_INIT_$OPRS_SIMD_$$___M128Q:
	.byte	13,7
	.ascii	"__m128q"
	.quad	0
	.long	40
	.quad	0,0
	.long	0

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000009
_RTTI_$OPRS_SIMD_$$_def00000009:
	.byte	12,0
	.quad	16,2
	.quad	_RTTI_$SYSTEM_$$_INT64$indirect
	.byte	1
	.quad	_RTTI_$SYSTEM_$$_SHORTINT$indirect

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M128Q
_RTTI_$OPRS_SIMD_$$___M128Q:
	.byte	13,7
	.ascii	"__m128q"
	.quad	_INIT_$OPRS_SIMD_$$___M128Q
	.long	40,3
	.quad	_RTTI_$SYSTEM_$$_INT64$indirect
	.quad	0
	.quad	_RTTI_$SYSTEM_$$_INT64$indirect
	.quad	32
	.quad	_RTTI_$OPRS_SIMD_$$_def00000009$indirect
	.quad	0

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M128D
_INIT_$OPRS_SIMD_$$___M128D:
	.byte	13,7
	.ascii	"__m128d"
	.quad	0
	.long	40
	.quad	0,0
	.long	0

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def0000000C
_RTTI_$OPRS_SIMD_$$_def0000000C:
	.byte	12,0
	.quad	16,2
	.quad	_RTTI_$SYSTEM_$$_DOUBLE$indirect
	.byte	1
	.quad	_RTTI_$SYSTEM_$$_SHORTINT$indirect

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M128D
_RTTI_$OPRS_SIMD_$$___M128D:
	.byte	13,7
	.ascii	"__m128d"
	.quad	_INIT_$OPRS_SIMD_$$___M128D
	.long	40,3
	.quad	_RTTI_$SYSTEM_$$_DOUBLE$indirect
	.quad	0
	.quad	_RTTI_$SYSTEM_$$_DOUBLE$indirect
	.quad	32
	.quad	_RTTI_$OPRS_SIMD_$$_def0000000C$indirect
	.quad	0

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M256
_INIT_$OPRS_SIMD_$$___M256:
	.byte	13,6
	.ascii	"__m256"
	.quad	0
	.long	228
	.quad	0,0
	.long	0

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def0000000F
_RTTI_$OPRS_SIMD_$$_def0000000F:
	.byte	12,0
	.quad	32,8
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.byte	1
	.quad	_RTTI_$SYSTEM_$$_SHORTINT$indirect

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M256
_RTTI_$OPRS_SIMD_$$___M256:
	.byte	13,6
	.ascii	"__m256"
	.quad	_INIT_$OPRS_SIMD_$$___M256
	.long	228,9
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	0
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	32
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	64
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	96
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	128
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	160
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	192
	.quad	_RTTI_$SYSTEM_$$_SINGLE$indirect
	.quad	224
	.quad	_RTTI_$OPRS_SIMD_$$_def0000000F$indirect
	.quad	0

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M256I
_INIT_$OPRS_SIMD_$$___M256I:
	.byte	13,7
	.ascii	"__m256i"
	.quad	0
	.long	228
	.quad	0,0
	.long	0

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000012
_RTTI_$OPRS_SIMD_$$_def00000012:
	.byte	12,0
	.quad	32,8
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.byte	1
	.quad	_RTTI_$SYSTEM_$$_SHORTINT$indirect

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M256I
_RTTI_$OPRS_SIMD_$$___M256I:
	.byte	13,7
	.ascii	"__m256i"
	.quad	_INIT_$OPRS_SIMD_$$___M256I
	.long	228,9
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	0
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	32
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	64
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	96
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	128
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	160
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	192
	.quad	_RTTI_$SYSTEM_$$_LONGINT$indirect
	.quad	224
	.quad	_RTTI_$OPRS_SIMD_$$_def00000012$indirect
	.quad	0

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M256Q
_INIT_$OPRS_SIMD_$$___M256Q:
	.byte	13,7
	.ascii	"__m256q"
	.quad	0
	.long	104
	.quad	0,0
	.long	0

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000015
_RTTI_$OPRS_SIMD_$$_def00000015:
	.byte	12,0
	.quad	32,4
	.quad	_RTTI_$SYSTEM_$$_INT64$indirect
	.byte	1
	.quad	_RTTI_$SYSTEM_$$_SHORTINT$indirect

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M256Q
_RTTI_$OPRS_SIMD_$$___M256Q:
	.byte	13,7
	.ascii	"__m256q"
	.quad	_INIT_$OPRS_SIMD_$$___M256Q
	.long	104,5
	.quad	_RTTI_$SYSTEM_$$_INT64$indirect
	.quad	0
	.quad	_RTTI_$SYSTEM_$$_INT64$indirect
	.quad	32
	.quad	_RTTI_$SYSTEM_$$_INT64$indirect
	.quad	64
	.quad	_RTTI_$SYSTEM_$$_INT64$indirect
	.quad	96
	.quad	_RTTI_$OPRS_SIMD_$$_def00000015$indirect
	.quad	0

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M256D
_INIT_$OPRS_SIMD_$$___M256D:
	.byte	13,7
	.ascii	"__m256d"
	.quad	0
	.long	104
	.quad	0,0
	.long	0

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000018
_RTTI_$OPRS_SIMD_$$_def00000018:
	.byte	12,0
	.quad	32,4
	.quad	_RTTI_$SYSTEM_$$_DOUBLE$indirect
	.byte	1
	.quad	_RTTI_$SYSTEM_$$_SHORTINT$indirect

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M256D
_RTTI_$OPRS_SIMD_$$___M256D:
	.byte	13,7
	.ascii	"__m256d"
	.quad	_INIT_$OPRS_SIMD_$$___M256D
	.long	104,5
	.quad	_RTTI_$SYSTEM_$$_DOUBLE$indirect
	.quad	0
	.quad	_RTTI_$SYSTEM_$$_DOUBLE$indirect
	.quad	32
	.quad	_RTTI_$SYSTEM_$$_DOUBLE$indirect
	.quad	64
	.quad	_RTTI_$SYSTEM_$$_DOUBLE$indirect
	.quad	96
	.quad	_RTTI_$OPRS_SIMD_$$_def00000018$indirect
	.quad	0
# End asmlist al_rtti
# Begin asmlist al_indirectglobals

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_TINT32ARRAY$indirect
_RTTI_$OPRS_SIMD_$$_TINT32ARRAY$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_TINT32ARRAY

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M128$indirect
_INIT_$OPRS_SIMD_$$___M128$indirect:
	.quad	_INIT_$OPRS_SIMD_$$___M128

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000003$indirect
_RTTI_$OPRS_SIMD_$$_def00000003$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_def00000003

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M128$indirect
_RTTI_$OPRS_SIMD_$$___M128$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$___M128

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M128I$indirect
_INIT_$OPRS_SIMD_$$___M128I$indirect:
	.quad	_INIT_$OPRS_SIMD_$$___M128I

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000006$indirect
_RTTI_$OPRS_SIMD_$$_def00000006$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_def00000006

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M128I$indirect
_RTTI_$OPRS_SIMD_$$___M128I$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$___M128I

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M128Q$indirect
_INIT_$OPRS_SIMD_$$___M128Q$indirect:
	.quad	_INIT_$OPRS_SIMD_$$___M128Q

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000009$indirect
_RTTI_$OPRS_SIMD_$$_def00000009$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_def00000009

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M128Q$indirect
_RTTI_$OPRS_SIMD_$$___M128Q$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$___M128Q

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M128D$indirect
_INIT_$OPRS_SIMD_$$___M128D$indirect:
	.quad	_INIT_$OPRS_SIMD_$$___M128D

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def0000000C$indirect
_RTTI_$OPRS_SIMD_$$_def0000000C$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_def0000000C

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M128D$indirect
_RTTI_$OPRS_SIMD_$$___M128D$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$___M128D

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M256$indirect
_INIT_$OPRS_SIMD_$$___M256$indirect:
	.quad	_INIT_$OPRS_SIMD_$$___M256

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def0000000F$indirect
_RTTI_$OPRS_SIMD_$$_def0000000F$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_def0000000F

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M256$indirect
_RTTI_$OPRS_SIMD_$$___M256$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$___M256

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M256I$indirect
_INIT_$OPRS_SIMD_$$___M256I$indirect:
	.quad	_INIT_$OPRS_SIMD_$$___M256I

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000012$indirect
_RTTI_$OPRS_SIMD_$$_def00000012$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_def00000012

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M256I$indirect
_RTTI_$OPRS_SIMD_$$___M256I$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$___M256I

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M256Q$indirect
_INIT_$OPRS_SIMD_$$___M256Q$indirect:
	.quad	_INIT_$OPRS_SIMD_$$___M256Q

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000015$indirect
_RTTI_$OPRS_SIMD_$$_def00000015$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_def00000015

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M256Q$indirect
_RTTI_$OPRS_SIMD_$$___M256Q$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$___M256Q

.const_data
	.align 3
.globl	_INIT_$OPRS_SIMD_$$___M256D$indirect
_INIT_$OPRS_SIMD_$$___M256D$indirect:
	.quad	_INIT_$OPRS_SIMD_$$___M256D

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$_def00000018$indirect
_RTTI_$OPRS_SIMD_$$_def00000018$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$_def00000018

.const_data
	.align 3
.globl	_RTTI_$OPRS_SIMD_$$___M256D$indirect
_RTTI_$OPRS_SIMD_$$___M256D$indirect:
	.quad	_RTTI_$OPRS_SIMD_$$___M256D
# End asmlist al_indirectglobals
	.subsections_via_symbols

