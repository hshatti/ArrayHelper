
unit cblas;
interface
{$macro on}
{$ifdef windows}
  {$define libblas:='libblas.dll'}
{$else}
  {$linklib blas}
{$endif}

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  type
    size_t = SizeInt;
    CBLAS_INDEX = size_t;    

  type
    CBLAS_ORDER = (CblasRowMajor := 101,CblasColMajor := 102
      );

    CBLAS_TRANSPOSE = (CblasNoTrans := 111,CblasTrans := 112,CblasConjTrans := 113
      );

    CBLAS_UPLO = (CblasUpper := 121,CblasLower := 122);

    CBLAS_DIAG = (CblasNonUnit := 131,CblasUnit := 132);

    CBLAS_SIDE = (CblasLeft := 141,CblasRight := 142);


  function cblas_sdsdot(N:longint; alpha:single; X:Psingle; incX:longint; Y:Psingle; 
             incY:longint):single;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_dsdot(N:longint; X:Psingle; incX:longint; Y:Psingle; incY:longint):double;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_sdot(N:longint; X:Psingle; incX:longint; Y:Psingle; incY:longint):single;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_ddot(N:longint; X:Pdouble; incX:longint; Y:Pdouble; incY:longint):double;cdecl;external {$ifdef windows}libblas {$endif};

  {
   * Functions having prefixes Z and C only
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cdotu_sub(N:longint; X:pointer; incX:longint; Y:pointer; incY:longint; 
              dotu:pointer);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cdotc_sub(N:longint; X:pointer; incX:longint; Y:pointer; incY:longint; 
              dotc:pointer);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zdotu_sub(N:longint; X:pointer; incX:longint; Y:pointer; incY:longint; 
              dotu:pointer);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zdotc_sub(N:longint; X:pointer; incX:longint; Y:pointer; incY:longint; 
              dotc:pointer);cdecl;external {$ifdef windows}libblas {$endif};

  {
   * Functions having prefixes S D SC DZ
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_snrm2(N:longint; X:Psingle; incX:longint):single;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_sasum(N:longint; X:Psingle; incX:longint):single;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_dnrm2(N:longint; X:Pdouble; incX:longint):double;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_dasum(N:longint; X:Pdouble; incX:longint):double;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_scnrm2(N:longint; X:pointer; incX:longint):single;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_scasum(N:longint; X:pointer; incX:longint):single;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_dznrm2(N:longint; X:pointer; incX:longint):double;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_dzasum(N:longint; X:pointer; incX:longint):double;cdecl;external {$ifdef windows}libblas {$endif};

  {
   * Functions having standard 4 prefixes (S D C Z)
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_isamax(N:longint; X:Psingle; incX:longint):CBLAS_INDEX;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_idamax(N:longint; X:Pdouble; incX:longint):CBLAS_INDEX;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_icamax(N:longint; X:pointer; incX:longint):CBLAS_INDEX;cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function cblas_izamax(N:longint; X:pointer; incX:longint):CBLAS_INDEX;cdecl;external {$ifdef windows}libblas {$endif};

  {
   * ===========================================================================
   * Prototypes for level 1 BLAS routines
   * ===========================================================================
    }
  { 
   * Routines with standard 4 prefixes (s, d, c, z)
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sswap(N:longint; X:Psingle; incX:longint; Y:Psingle; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_scopy(N:longint; X:Psingle; incX:longint; Y:Psingle; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_saxpy(N:longint; alpha:single; X:Psingle; incX:longint; Y:Psingle; 
              incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dswap(N:longint; X:Pdouble; incX:longint; Y:Pdouble; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dcopy(N:longint; X:Pdouble; incX:longint; Y:Pdouble; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_daxpy(N:longint; alpha:double; X:Pdouble; incX:longint; Y:Pdouble; 
              incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cswap(N:longint; X:pointer; incX:longint; Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ccopy(N:longint; X:pointer; incX:longint; Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_caxpy(N:longint; alpha:pointer; X:pointer; incX:longint; Y:pointer; 
              incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zswap(N:longint; X:pointer; incX:longint; Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zcopy(N:longint; X:pointer; incX:longint; Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zaxpy(N:longint; alpha:pointer; X:pointer; incX:longint; Y:pointer; 
              incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

  { 
   * Routines with S and D prefix only
    }
  procedure cblas_srotg(a:Psingle; b:Psingle; c:Psingle; s:Psingle);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
  procedure cblas_srotmg(d1:Psingle; d2:Psingle; b1:Psingle; b2:single; P:Psingle);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_srot(N:longint; X:Psingle; incX:longint; Y:Psingle; incY:longint; 
              c:single; s:single);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_srotm(N:longint; X:Psingle; incX:longint; Y:Psingle; incY:longint; 
              P:Psingle);cdecl;external {$ifdef windows}libblas {$endif};

  procedure cblas_drotg(a:Pdouble; b:Pdouble; c:Pdouble; s:Pdouble);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
  procedure cblas_drotmg(d1:Pdouble; d2:Pdouble; b1:Pdouble; b2:double; P:Pdouble);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_drot(N:longint; X:Pdouble; incX:longint; Y:Pdouble; incY:longint; 
              c:double; s:double);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_drotm(N:longint; X:Pdouble; incX:longint; Y:Pdouble; incY:longint; 
              P:Pdouble);cdecl;external {$ifdef windows}libblas {$endif};

  { 
   * Routines with S D C Z CS and ZD prefixes
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sscal(N:longint; alpha:single; X:Psingle; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dscal(N:longint; alpha:double; X:Pdouble; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cscal(N:longint; alpha:pointer; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zscal(N:longint; alpha:pointer; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_csscal(N:longint; alpha:single; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zdscal(N:longint; alpha:double; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

  {
   * ===========================================================================
   * Prototypes for level 2 BLAS
   * ===========================================================================
    }
  { 
   * Routines with standard 4 prefixes (S, D, C, Z)
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sgemv(order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; M:longint; N:longint; alpha:single; 
              A:Psingle; lda:longint; X:Psingle; incX:longint; beta:single; 
              Y:Psingle; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sgbmv(order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; M:longint; N:longint; KL:longint; 
              KU:longint; alpha:single; A:Psingle; lda:longint; X:Psingle; 
              incX:longint; beta:single; Y:Psingle; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_strmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              A:Psingle; lda:longint; X:Psingle; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_stbmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              K:longint; A:Psingle; lda:longint; X:Psingle; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_stpmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              Ap:Psingle; X:Psingle; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_strsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              A:Psingle; lda:longint; X:Psingle; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_stbsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              K:longint; A:Psingle; lda:longint; X:Psingle; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_stpsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              Ap:Psingle; X:Psingle; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dgemv(order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; M:longint; N:longint; alpha:double; 
              A:Pdouble; lda:longint; X:Pdouble; incX:longint; beta:double; 
              Y:Pdouble; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dgbmv(order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; M:longint; N:longint; KL:longint; 
              KU:longint; alpha:double; A:Pdouble; lda:longint; X:Pdouble; 
              incX:longint; beta:double; Y:Pdouble; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dtrmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              A:Pdouble; lda:longint; X:Pdouble; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dtbmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              K:longint; A:Pdouble; lda:longint; X:Pdouble; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dtpmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              Ap:Pdouble; X:Pdouble; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dtrsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              A:Pdouble; lda:longint; X:Pdouble; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dtbsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              K:longint; A:Pdouble; lda:longint; X:Pdouble; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dtpsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              Ap:Pdouble; X:Pdouble; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cgemv(order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; M:longint; N:longint; alpha:pointer; 
              A:pointer; lda:longint; X:pointer; incX:longint; beta:pointer; 
              Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cgbmv(order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; M:longint; N:longint; KL:longint; 
              KU:longint; alpha:pointer; A:pointer; lda:longint; X:pointer; 
              incX:longint; beta:pointer; Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ctrmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              A:pointer; lda:longint; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ctbmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              K:longint; A:pointer; lda:longint; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ctpmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              Ap:pointer; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ctrsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              A:pointer; lda:longint; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ctbsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              K:longint; A:pointer; lda:longint; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ctpsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              Ap:pointer; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zgemv(order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; M:longint; N:longint; alpha:pointer; 
              A:pointer; lda:longint; X:pointer; incX:longint; beta:pointer; 
              Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zgbmv(order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; M:longint; N:longint; KL:longint; 
              KU:longint; alpha:pointer; A:pointer; lda:longint; X:pointer; 
              incX:longint; beta:pointer; Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ztrmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              A:pointer; lda:longint; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ztbmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              K:longint; A:pointer; lda:longint; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ztpmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              Ap:pointer; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ztrsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              A:pointer; lda:longint; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ztbsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              K:longint; A:pointer; lda:longint; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ztpsv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; N:longint; 
              Ap:pointer; X:pointer; incX:longint);cdecl;external {$ifdef windows}libblas {$endif};

  { 
   * Routines with S and D prefixes only
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ssymv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:single; A:Psingle; 
              lda:longint; X:Psingle; incX:longint; beta:single; Y:Psingle; 
              incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ssbmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; K:longint; alpha:single; 
              A:Psingle; lda:longint; X:Psingle; incX:longint; beta:single; 
              Y:Psingle; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sspmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:single; Ap:Psingle; 
              X:Psingle; incX:longint; beta:single; Y:Psingle; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sger(order:CBLAS_ORDER; M:longint; N:longint; alpha:single; X:Psingle; 
              incX:longint; Y:Psingle; incY:longint; A:Psingle; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ssyr(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:single; X:Psingle; 
              incX:longint; A:Psingle; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sspr(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:single; X:Psingle; 
              incX:longint; Ap:Psingle);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ssyr2(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:single; X:Psingle; 
              incX:longint; Y:Psingle; incY:longint; A:Psingle; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sspr2(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:single; X:Psingle; 
              incX:longint; Y:Psingle; incY:longint; A:Psingle);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dsymv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:double; A:Pdouble; 
              lda:longint; X:Pdouble; incX:longint; beta:double; Y:Pdouble; 
              incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dsbmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; K:longint; alpha:double; 
              A:Pdouble; lda:longint; X:Pdouble; incX:longint; beta:double; 
              Y:Pdouble; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dspmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:double; Ap:Pdouble; 
              X:Pdouble; incX:longint; beta:double; Y:Pdouble; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dger(order:CBLAS_ORDER; M:longint; N:longint; alpha:double; X:Pdouble; 
              incX:longint; Y:Pdouble; incY:longint; A:Pdouble; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dsyr(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:double; X:Pdouble; 
              incX:longint; A:Pdouble; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dspr(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:double; X:Pdouble; 
              incX:longint; Ap:Pdouble);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dsyr2(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:double; X:Pdouble; 
              incX:longint; Y:Pdouble; incY:longint; A:Pdouble; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dspr2(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:double; X:Pdouble; 
              incX:longint; Y:Pdouble; incY:longint; A:Pdouble);cdecl;external {$ifdef windows}libblas {$endif};

  { 
   * Routines with C and Z prefixes only
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_chemv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:pointer; A:pointer; 
              lda:longint; X:pointer; incX:longint; beta:pointer; Y:pointer; 
              incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_chbmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; K:longint; alpha:pointer; 
              A:pointer; lda:longint; X:pointer; incX:longint; beta:pointer; 
              Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_chpmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:pointer; Ap:pointer; 
              X:pointer; incX:longint; beta:pointer; Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cgeru(order:CBLAS_ORDER; M:longint; N:longint; alpha:pointer; X:pointer; 
              incX:longint; Y:pointer; incY:longint; A:pointer; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cgerc(order:CBLAS_ORDER; M:longint; N:longint; alpha:pointer; X:pointer; 
              incX:longint; Y:pointer; incY:longint; A:pointer; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cher(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:single; X:pointer; 
              incX:longint; A:pointer; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_chpr(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:single; X:pointer; 
              incX:longint; A:pointer);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cher2(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:pointer; X:pointer; 
              incX:longint; Y:pointer; incY:longint; A:pointer; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_chpr2(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:pointer; X:pointer; 
              incX:longint; Y:pointer; incY:longint; Ap:pointer);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zhemv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:pointer; A:pointer; 
              lda:longint; X:pointer; incX:longint; beta:pointer; Y:pointer; 
              incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zhbmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; K:longint; alpha:pointer; 
              A:pointer; lda:longint; X:pointer; incX:longint; beta:pointer; 
              Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zhpmv(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:pointer; Ap:pointer; 
              X:pointer; incX:longint; beta:pointer; Y:pointer; incY:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zgeru(order:CBLAS_ORDER; M:longint; N:longint; alpha:pointer; X:pointer; 
              incX:longint; Y:pointer; incY:longint; A:pointer; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zgerc(order:CBLAS_ORDER; M:longint; N:longint; alpha:pointer; X:pointer; 
              incX:longint; Y:pointer; incY:longint; A:pointer; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zher(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:double; X:pointer; 
              incX:longint; A:pointer; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zhpr(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:double; X:pointer; 
              incX:longint; A:pointer);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zher2(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:pointer; X:pointer; 
              incX:longint; Y:pointer; incY:longint; A:pointer; lda:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zhpr2(order:CBLAS_ORDER; Uplo:CBLAS_UPLO; N:longint; alpha:pointer; X:pointer; 
              incX:longint; Y:pointer; incY:longint; Ap:pointer);cdecl;external {$ifdef windows}libblas {$endif};

  {
   * ===========================================================================
   * Prototypes for level 3 BLAS
   * ===========================================================================
    }
  { 
   * Routines with standard 4 prefixes (S, D, C, Z)
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_sgemm(Order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; TransB:CBLAS_TRANSPOSE; M:longint; N:longint; 
              K:longint; alpha:single; A:Psingle; lda:longint; B:Psingle; 
              ldb:longint; beta:single; C:Psingle; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ssymm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; M:longint; N:longint; 
              alpha:single; A:Psingle; lda:longint; B:Psingle; ldb:longint; 
              beta:single; C:Psingle; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ssyrk(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:single; A:Psingle; lda:longint; beta:single; C:Psingle; 
              ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ssyr2k(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:single; A:Psingle; lda:longint; B:Psingle; ldb:longint; 
              beta:single; C:Psingle; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_strmm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; 
              M:longint; N:longint; alpha:single; A:Psingle; lda:longint; 
              B:Psingle; ldb:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_strsm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; 
              M:longint; N:longint; alpha:single; A:Psingle; lda:longint; 
              B:Psingle; ldb:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dgemm(Order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; TransB:CBLAS_TRANSPOSE; M:longint; N:longint; 
              K:longint; alpha:double; A:Pdouble; lda:longint; B:Pdouble; 
              ldb:longint; beta:double; C:Pdouble; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dsymm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; M:longint; N:longint; 
              alpha:double; A:Pdouble; lda:longint; B:Pdouble; ldb:longint; 
              beta:double; C:Pdouble; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dsyrk(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:double; A:Pdouble; lda:longint; beta:double; C:Pdouble; 
              ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dsyr2k(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:double; A:Pdouble; lda:longint; B:Pdouble; ldb:longint; 
              beta:double; C:Pdouble; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dtrmm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; 
              M:longint; N:longint; alpha:double; A:Pdouble; lda:longint; 
              B:Pdouble; ldb:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_dtrsm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; 
              M:longint; N:longint; alpha:double; A:Pdouble; lda:longint; 
              B:Pdouble; ldb:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cgemm(Order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; TransB:CBLAS_TRANSPOSE; M:longint; N:longint; 
              K:longint; alpha:pointer; A:pointer; lda:longint; B:pointer; 
              ldb:longint; beta:pointer; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_csymm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; M:longint; N:longint; 
              alpha:pointer; A:pointer; lda:longint; B:pointer; ldb:longint; 
              beta:pointer; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_csyrk(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:pointer; A:pointer; lda:longint; beta:pointer; C:pointer; 
              ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_csyr2k(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:pointer; A:pointer; lda:longint; B:pointer; ldb:longint; 
              beta:pointer; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ctrmm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; 
              M:longint; N:longint; alpha:pointer; A:pointer; lda:longint; 
              B:pointer; ldb:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ctrsm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; 
              M:longint; N:longint; alpha:pointer; A:pointer; lda:longint; 
              B:pointer; ldb:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zgemm(Order:CBLAS_ORDER; TransA:CBLAS_TRANSPOSE; TransB:CBLAS_TRANSPOSE; M:longint; N:longint; 
              K:longint; alpha:pointer; A:pointer; lda:longint; B:pointer; 
              ldb:longint; beta:pointer; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zsymm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; M:longint; N:longint; 
              alpha:pointer; A:pointer; lda:longint; B:pointer; ldb:longint; 
              beta:pointer; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zsyrk(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:pointer; A:pointer; lda:longint; beta:pointer; C:pointer; 
              ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zsyr2k(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:pointer; A:pointer; lda:longint; B:pointer; ldb:longint; 
              beta:pointer; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ztrmm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; 
              M:longint; N:longint; alpha:pointer; A:pointer; lda:longint; 
              B:pointer; ldb:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_ztrsm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; TransA:CBLAS_TRANSPOSE; Diag:CBLAS_DIAG; 
              M:longint; N:longint; alpha:pointer; A:pointer; lda:longint; 
              B:pointer; ldb:longint);cdecl;external {$ifdef windows}libblas {$endif};

  { 
   * Routines with prefixes C and Z only
    }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_chemm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; M:longint; N:longint; 
              alpha:pointer; A:pointer; lda:longint; B:pointer; ldb:longint; 
              beta:pointer; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cherk(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:single; A:pointer; lda:longint; beta:single; C:pointer; 
              ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_cher2k(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:pointer; A:pointer; lda:longint; B:pointer; ldb:longint; 
              beta:single; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zhemm(Order:CBLAS_ORDER; Side:CBLAS_SIDE; Uplo:CBLAS_UPLO; M:longint; N:longint; 
              alpha:pointer; A:pointer; lda:longint; B:pointer; ldb:longint; 
              beta:pointer; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zherk(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:double; A:pointer; lda:longint; beta:double; C:pointer; 
              ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_zher2k(Order:CBLAS_ORDER; Uplo:CBLAS_UPLO; Trans:CBLAS_TRANSPOSE; N:longint; K:longint; 
              alpha:pointer; A:pointer; lda:longint; B:pointer; ldb:longint; 
              beta:double; C:pointer; ldc:longint);cdecl;external {$ifdef windows}libblas {$endif};

(* Const before type ignored *)
(* Const before type ignored *)
  procedure cblas_xerbla(p:longint; rout:Pchar; form:Pchar; args:array of const);cdecl;external {$ifdef windows}libblas {$endif};

  procedure cblas_xerbla(p:longint; rout:Pchar; form:Pchar);cdecl;external {$ifdef windows}libblas {$endif};


implementation


end.
