unit mkl_blas_64;
interface

uses types, mkl_types;

{$include mkl.inc}

  {******************************************************************************
  * Copyright 2021 Intel Corporation.
  *
  * This software and the related documents are Intel copyrighted  materials,  and
  * your use of  them is  governed by the  express license  under which  they were
  * provided to you (License).  Unless the License provides otherwise, you may not
  * use, modify, copy, publish, distribute,  disclose or transmit this software or
  * the related documents without Intel's prior written permission.
  *
  * This software and the related documents  are provided as  is,  with no express
  * or implied  warranties,  other  than those  that are  expressly stated  in the
  * License.
  ****************************************************************************** }
  {
  !  Content:
  !      Intel(R) oneAPI Math Kernel Library (oneMKL) interface for ILP64 BLAS routines
  !***************************************************************************** }

  { Upper case declaration  }
  { BLAS Level1  }

{$ifdef UPPERCASE_DECL}
  function SCABS1_64(const c:PMKL_Complex8):single;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function SASUM_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure SAXPY_64(const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure SAXPBY_64(const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const beta:Psingle; const 
              y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure SAXPYI_64(const nz:PMKL_INT64; const a:Psingle; const x:Psingle; const indx:PMKL_INT64; const y:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function SCASUM_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function SCNRM2_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure SCOPY_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  function SDOT_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};







  function SDSDOT_64(const n:PMKL_INT64; const sb:Psingle; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const 
             incy:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};





  function SDOTI_64(const nz:PMKL_INT64; const x:Psingle; const indx:PMKL_INT64; const y:Psingle):single;_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure SGTHR_64(const nz:PMKL_INT64; const y:Psingle; const x:Psingle; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};



  procedure SGTHRZ_64(const nz:PMKL_INT64; const y:Psingle; const x:Psingle; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function SNRM2_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure SROT_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64; const 
              c:Psingle; const s:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};

  procedure SROTG_64(const a:Psingle; const b:Psingle; const c:Psingle; const s:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure SROTI_64(const nz:PMKL_INT64; const x:Psingle; const indx:PMKL_INT64; const y:Psingle; const c:Psingle; const 
              s:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure SROTM_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64; const 
              param:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};


  procedure SROTMG_64(const d1:Psingle; const d2:Psingle; const x1:Psingle; const y1:Psingle; const param:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure SSCAL_64(const n:PMKL_INT64; const a:Psingle; const x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure SSCTR_64(const nz:PMKL_INT64; const x:Psingle; const indx:PMKL_INT64; const y:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure SSWAP_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function ISAMAX_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function ISAMIN_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure CAXPY_64(const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure CAXPBY_64(const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const 
              y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure CAXPYI_64(const nz:PMKL_INT64; const a:PMKL_Complex8; const x:PMKL_Complex8; const indx:PMKL_INT64; const y:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure CCOPY_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure CDOTC_64(const pres:PMKL_Complex8; const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure CDOTCI_64(const pres:PMKL_Complex8; const nz:PMKL_INT64; const x:PMKL_Complex8; const indx:PMKL_INT64; const y:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure CDOTU_64(const pres:PMKL_Complex8; const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure CDOTUI_64(const pres:PMKL_Complex8; const nz:PMKL_INT64; const x:PMKL_Complex8; const indx:PMKL_INT64; const y:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure CGTHR_64(const nz:PMKL_INT64; const y:PMKL_Complex8; const x:PMKL_Complex8; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};



  procedure CGTHRZ_64(const nz:PMKL_INT64; const y:PMKL_Complex8; const x:PMKL_Complex8; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};


  procedure CROTG_64(const a:PMKL_Complex8; const b:PMKL_Complex8; const c:Psingle; const s:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure CSCAL_64(const n:PMKL_INT64; const a:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure CSCTR_64(const nz:PMKL_INT64; const x:PMKL_Complex8; const indx:PMKL_INT64; const y:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure CSROT_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const incy:PMKL_INT64; const 
              c:Psingle; const s:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure CSSCAL_64(const n:PMKL_INT64; const a:Psingle; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure CSWAP_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function ICAMAX_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function ICAMIN_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};


  function DCABS1_64(const z:PMKL_Complex16):double;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function DASUM_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure DAXPY_64(const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure DAXPBY_64(const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const beta:Pdouble; const 
              y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure DAXPYI_64(const nz:PMKL_INT64; const a:Pdouble; const x:Pdouble; const indx:PMKL_INT64; const y:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure DCOPY_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  function DDOT_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};






  function DSDOT_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};





  function DDOTI_64(const nz:PMKL_INT64; const x:Pdouble; const indx:PMKL_INT64; const y:Pdouble):double;_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure DGTHR_64(const nz:PMKL_INT64; const y:Pdouble; const x:Pdouble; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};



  procedure DGTHRZ_64(const nz:PMKL_INT64; const y:Pdouble; const x:Pdouble; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function DNRM2_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure DROT_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64; const 
              c:Pdouble; const s:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};

  procedure DROTG_64(const a:Pdouble; const b:Pdouble; const c:Pdouble; const s:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure DROTI_64(const nz:PMKL_INT64; const x:Pdouble; const indx:PMKL_INT64; const y:Pdouble; const c:Pdouble; const 
              s:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure DROTM_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64; const 
              param:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};


  procedure DROTMG_64(const d1:Pdouble; const d2:Pdouble; const x1:Pdouble; const y1:Pdouble; const param:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure DSCAL_64(const n:PMKL_INT64; const a:Pdouble; const x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure DSCTR_64(const nz:PMKL_INT64; const x:Pdouble; const indx:PMKL_INT64; const y:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure DSWAP_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function DZASUM_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function DZNRM2_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function IDAMAX_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function IDAMIN_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure ZAXPY_64(const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure ZAXPBY_64(const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const 
              y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure ZAXPYI_64(const nz:PMKL_INT64; const a:PMKL_Complex16; const x:PMKL_Complex16; const indx:PMKL_INT64; const y:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure ZCOPY_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure ZDOTC_64(const pres:PMKL_Complex16; const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure ZDOTCI_64(const pres:PMKL_Complex16; const nz:PMKL_INT64; const x:PMKL_Complex16; const indx:PMKL_INT64; const y:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure ZDOTU_64(const pres:PMKL_Complex16; const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure ZDOTUI_64(const pres:PMKL_Complex16; const nz:PMKL_INT64; const x:PMKL_Complex16; const indx:PMKL_INT64; const y:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure ZDROT_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const incy:PMKL_INT64; const 
              c:Pdouble; const s:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure ZDSCAL_64(const n:PMKL_INT64; const a:Pdouble; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure ZGTHR_64(const nz:PMKL_INT64; const y:PMKL_Complex16; const x:PMKL_Complex16; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};



  procedure ZGTHRZ_64(const nz:PMKL_INT64; const y:PMKL_Complex16; const x:PMKL_Complex16; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};


  procedure ZROTG_64(const a:PMKL_Complex16; const b:PMKL_Complex16; const c:Pdouble; const s:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure ZSCAL_64(const n:PMKL_INT64; const a:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure ZSCTR_64(const nz:PMKL_INT64; const x:PMKL_Complex16; const indx:PMKL_INT64; const y:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure ZSWAP_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function IZAMAX_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function IZAMIN_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};

  { BLAS Level2  }












  procedure SGBMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const kl:PMKL_INT64; const ku:PMKL_INT64; const 
              alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const 
              beta:Psingle; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure SGEMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const 
              lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const beta:Psingle; const y:Psingle; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure SGER_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              y:Psingle; const incy:PMKL_INT64; const a:Psingle; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure SSBMV_64(const uplo:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const a:Psingle; const 
              lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const beta:Psingle; const y:Psingle; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure SSPMV_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const ap:Psingle; const x:Psingle; const 
              incx:PMKL_INT64; const beta:Psingle; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure SSPR_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              ap:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure SSPR2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              y:Psingle; const incy:PMKL_INT64; const ap:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure SSYMV_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const 
              x:Psingle; const incx:PMKL_INT64; const beta:Psingle; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure SSYR_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              a:Psingle; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure SSYR2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              y:Psingle; const incy:PMKL_INT64; const a:Psingle; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure STBMV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Psingle; const lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure STBSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Psingle; const lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure STPMV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:Psingle; const 
              x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure STPSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:Psingle; const 
              x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure STRMV_64(const uplo:Pchar; const transa:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:Psingle; const 
              lda:PMKL_INT64; const b:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure STRSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:Psingle; const 
              lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure SGEM2VU_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const 
              x1:Psingle; const incx1:PMKL_INT64; const x2:Psingle; const incx2:PMKL_INT64; const beta:Psingle; const 
              y1:Psingle; const incy1:PMKL_INT64; const y2:Psingle; const incy2:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CGBMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const kl:PMKL_INT64; const ku:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              beta:PMKL_Complex8; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure CGEMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure CGERC_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const a:PMKL_Complex8; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure CGERU_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const a:PMKL_Complex8; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure CHBMV_64(const uplo:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure CHEMV_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const 
              x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure CHER_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              a:PMKL_Complex8; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure CHER2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const a:PMKL_Complex8; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure CHPMV_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex8; const ap:PMKL_Complex8; const x:PMKL_Complex8; const 
              incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure CHPR_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              ap:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure CHPR2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const ap:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure CTBMV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure CTBSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure CTPMV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:PMKL_Complex8; const 
              x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure CTPSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:PMKL_Complex8; const 
              x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure CTRMV_64(const uplo:Pchar; const transa:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const b:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure CTRSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CGEM2VC_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const 
              x1:PMKL_Complex8; const incx1:PMKL_INT64; const x2:PMKL_Complex8; const incx2:PMKL_INT64; const beta:PMKL_Complex8; const 
              y1:PMKL_Complex8; const incy1:PMKL_INT64; const y2:PMKL_Complex8; const incy2:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure SCGEMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:Psingle; const 
              lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DGBMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const kl:PMKL_INT64; const ku:PMKL_INT64; const 
              alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const 
              beta:Pdouble; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure DGEMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const 
              lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const beta:Pdouble; const y:Pdouble; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure DGER_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              y:Pdouble; const incy:PMKL_INT64; const a:Pdouble; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure DSBMV_64(const uplo:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const 
              lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const beta:Pdouble; const y:Pdouble; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure DSPMV_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const ap:Pdouble; const x:Pdouble; const 
              incx:PMKL_INT64; const beta:Pdouble; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure DSPR_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              ap:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure DSPR2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              y:Pdouble; const incy:PMKL_INT64; const ap:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure DSYMV_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const 
              x:Pdouble; const incx:PMKL_INT64; const beta:Pdouble; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure DSYR_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              a:Pdouble; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure DSYR2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              y:Pdouble; const incy:PMKL_INT64; const a:Pdouble; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure DTBMV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Pdouble; const lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure DTBSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Pdouble; const lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure DTPMV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:Pdouble; const 
              x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure DTPSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:Pdouble; const 
              x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure DTRMV_64(const uplo:Pchar; const transa:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:Pdouble; const 
              lda:PMKL_INT64; const b:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure DTRSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:Pdouble; const 
              lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DGEM2VU_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const 
              x1:Pdouble; const incx1:PMKL_INT64; const x2:Pdouble; const incx2:PMKL_INT64; const beta:Pdouble; const 
              y1:Pdouble; const incy1:PMKL_INT64; const y2:Pdouble; const incy2:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZGBMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const kl:PMKL_INT64; const ku:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              beta:PMKL_Complex16; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ZGEMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ZGERC_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const a:PMKL_Complex16; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ZGERU_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const a:PMKL_Complex16; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ZHBMV_64(const uplo:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure ZHEMV_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const 
              x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure ZHER_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              a:PMKL_Complex16; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ZHER2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const a:PMKL_Complex16; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ZHPMV_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex16; const ap:PMKL_Complex16; const x:PMKL_Complex16; const 
              incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure ZHPR_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              ap:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure ZHPR2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const ap:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ZTBMV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ZTBSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure ZTPMV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:PMKL_Complex16; const 
              x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure ZTPSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:PMKL_Complex16; const 
              x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure ZTRMV_64(const uplo:Pchar; const transa:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const b:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure ZTRSV_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZGEM2VC_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const 
              x1:PMKL_Complex16; const incx1:PMKL_INT64; const x2:PMKL_Complex16; const incx2:PMKL_INT64; const beta:PMKL_Complex16; const 
              y1:PMKL_Complex16; const incy1:PMKL_INT64; const y2:PMKL_Complex16; const incy2:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure DZGEMV_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:Pdouble; const 
              lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

  { BLAS Level3  }












  procedure SGEMM_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const 
              beta:Psingle; const c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  function SGEMM_PACK_GET_SIZE_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure SGEMM_PACK_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Psingle; const src:Psingle; const ld:PMKL_INT64; const dest:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure SGEMM_COMPUTE_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const beta:Psingle; const 
              c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure SGEMM_BATCH_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:Psingle; const a_array:PPsingle; const lda_array:PMKL_INT64; const b_array:PPsingle; const ldb_array:PMKL_INT64; const 
              beta_array:Psingle; const c_array:PPsingle; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure SGEMM_BATCH_STRIDED_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const stridea:PMKL_INT64; const b:Psingle; const 
              ldb:PMKL_INT64; const strideb:PMKL_INT64; const beta:Psingle; const c:Psingle; const ldc:PMKL_INT64; const 
              stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure SGEMMT_64(const uplo:Pchar; const transa:Pchar; const transb:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const 
              beta:Psingle; const c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure SSYMM_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const 
              a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const beta:Psingle; const 
              c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure SSYR2K_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const 
              a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const beta:Psingle; const 
              c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure SSYRK_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const 
              a:Psingle; const lda:PMKL_INT64; const beta:Psingle; const c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure SSYRK_BATCH_STRIDED_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const 
              a:Psingle; const lda:PMKL_INT64; const stridea:PMKL_INT64; const beta:Psingle; const c:Psingle; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure SSYRK_BATCH_64(const uplo_array:Pchar; const trans_array:Pchar; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const alpha_array:Psingle; const 
              a_array:PPsingle; const lda_array:PMKL_INT64; const beta_array:Psingle; const c_array:PPsingle; const ldc_array:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure STRMM_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const b:Psingle; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure STRSM_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const b:Psingle; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure STRSM_BATCH_64(const side_array:Pchar; const uplo_array:Pchar; const transa_array:Pchar; const diag_array:Pchar; const m_array:PMKL_INT64; const 
              n_array:PMKL_INT64; const alpha_array:Psingle; const a_array:PPsingle; const lda_array:PMKL_INT64; const b_array:PPsingle; const 
              ldb:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};














  procedure STRSM_BATCH_STRIDED_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const stridea:PMKL_INT64; const 
              b:Psingle; const ldb:PMKL_INT64; const strideb:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CGEMM_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure CGEMM_BATCH_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:PMKL_Complex8; const a_array:PPMKL_Complex8; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex8; const ldb_array:PMKL_INT64; const 
              beta_array:PMKL_Complex8; const c_array:PPMKL_Complex8; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure CGEMM_BATCH_STRIDED_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const stridea:PMKL_INT64; const b:PMKL_Complex8; const 
              ldb:PMKL_INT64; const strideb:PMKL_INT64; const beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64; const 
              stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure SCGEMM_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:Psingle; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CGEMM3M_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure CGEMM3M_BATCH_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:PMKL_Complex8; const a_array:PPMKL_Complex8; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex8; const ldb_array:PMKL_INT64; const 
              beta_array:PMKL_Complex8; const c_array:PPMKL_Complex8; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CGEMMT_64(const uplo:Pchar; const transa:Pchar; const transb:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CTRSM_BATCH_64(const side_array:Pchar; const uplo_array:Pchar; const transa_array:Pchar; const diag_array:Pchar; const m_array:PMKL_INT64; const 
              n_array:PMKL_INT64; const alpha_array:PMKL_Complex8; const a_array:PPMKL_Complex8; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex8; const 
              ldb:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};














  procedure CTRSM_BATCH_STRIDED_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const stridea:PMKL_INT64; const 
              b:PMKL_Complex8; const ldb:PMKL_INT64; const strideb:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure CHEMM_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const beta:PMKL_Complex8; const 
              c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure CHER2K_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const beta:Psingle; const 
              c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure CHERK_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const beta:Psingle; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure CSYMM_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const beta:PMKL_Complex8; const 
              c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure CSYR2K_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const beta:PMKL_Complex8; const 
              c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure CSYRK_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure CSYRK_BATCH_64(const uplo_array:Pchar; const trans_array:Pchar; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const alpha_array:PMKL_Complex8; const 
              a_array:PPMKL_Complex8; const lda_array:PMKL_INT64; const beta_array:PMKL_Complex8; const c_array:PPMKL_Complex8; const ldc_array:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CSYRK_BATCH_STRIDED_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const stridea:PMKL_INT64; const beta:PMKL_Complex8; const c:PMKL_Complex8; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure CTRMM_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure CTRSM_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DGEMM_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const 
              beta:Pdouble; const c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  function DGEMM_PACK_GET_SIZE_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure DGEMM_PACK_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Pdouble; const src:Pdouble; const ld:PMKL_INT64; const dest:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure DGEMM_COMPUTE_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const beta:Pdouble; const 
              c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure DGEMM_BATCH_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:Pdouble; const a_array:PPdouble; const lda_array:PMKL_INT64; const b_array:PPdouble; const ldb_array:PMKL_INT64; const 
              beta_array:Pdouble; const c_array:PPdouble; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure DGEMM_BATCH_STRIDED_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const stridea:PMKL_INT64; const b:Pdouble; const 
              ldb:PMKL_INT64; const strideb:PMKL_INT64; const beta:Pdouble; const c:Pdouble; const ldc:PMKL_INT64; const 
              stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DGEMMT_64(const uplo:Pchar; const transa:Pchar; const transb:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const 
              beta:Pdouble; const c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure DSYMM_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const 
              a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const beta:Pdouble; const 
              c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure DSYR2K_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const 
              a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const beta:Pdouble; const 
              c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure DSYRK_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const 
              a:Pdouble; const lda:PMKL_INT64; const beta:Pdouble; const c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure DSYRK_BATCH_64(const uplo_array:Pchar; const trans_array:Pchar; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const alpha_array:Pdouble; const 
              a_array:PPdouble; const lda_array:PMKL_INT64; const beta_array:Pdouble; const c_array:PPdouble; const ldc_array:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DSYRK_BATCH_STRIDED_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const 
              a:Pdouble; const lda:PMKL_INT64; const stridea:PMKL_INT64; const beta:Pdouble; const c:Pdouble; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure DTRMM_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure DTRSM_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DTRSM_BATCH_64(const side_array:Pchar; const uplo_array:Pchar; const transa_array:Pchar; const diag_array:Pchar; const m_array:PMKL_INT64; const 
              n_array:PMKL_INT64; const alpha_array:Pdouble; const a_array:PPdouble; const lda_array:PMKL_INT64; const b_array:PPdouble; const 
              ldb:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};














  procedure DTRSM_BATCH_STRIDED_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const stridea:PMKL_INT64; const 
              b:Pdouble; const ldb:PMKL_INT64; const strideb:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZGEMM_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure ZGEMM_BATCH_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:PMKL_Complex16; const a_array:PPMKL_Complex16; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex16; const ldb_array:PMKL_INT64; const 
              beta_array:PMKL_Complex16; const c_array:PPMKL_Complex16; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure ZGEMM_BATCH_STRIDED_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const stridea:PMKL_INT64; const b:PMKL_Complex16; const 
              ldb:PMKL_INT64; const strideb:PMKL_INT64; const beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64; const 
              stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DZGEMM_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:Pdouble; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZGEMM3M_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure ZGEMM3M_BATCH_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:PMKL_Complex16; const a_array:PPMKL_Complex16; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex16; const ldb_array:PMKL_INT64; const 
              beta_array:PMKL_Complex16; const c_array:PPMKL_Complex16; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZGEMMT_64(const uplo:Pchar; const transa:Pchar; const transb:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure ZHEMM_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const beta:PMKL_Complex16; const 
              c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure ZHER2K_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const beta:Pdouble; const 
              c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure ZHERK_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const beta:Pdouble; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure ZSYMM_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const beta:PMKL_Complex16; const 
              c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure ZSYR2K_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const beta:PMKL_Complex16; const 
              c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure ZSYRK_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure ZSYRK_BATCH_64(const uplo_array:Pchar; const trans_array:Pchar; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const alpha_array:PMKL_Complex16; const 
              a_array:PPMKL_Complex16; const lda_array:PMKL_INT64; const beta_array:PMKL_Complex16; const c_array:PPMKL_Complex16; const ldc_array:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZSYRK_BATCH_STRIDED_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const stridea:PMKL_INT64; const beta:PMKL_Complex16; const c:PMKL_Complex16; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ZTRMM_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ZTRSM_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZTRSM_BATCH_64(const side_array:Pchar; const uplo_array:Pchar; const transa_array:Pchar; const diag_array:Pchar; const m_array:PMKL_INT64; const 
              n_array:PMKL_INT64; const alpha_array:PMKL_Complex16; const a_array:PPMKL_Complex16; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex16; const 
              ldb:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};














  procedure ZTRSM_BATCH_STRIDED_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const stridea:PMKL_INT64; const 
              b:PMKL_Complex16; const ldb:PMKL_INT64; const strideb:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure GEMM_S8U8S32_64(const transa:Pchar; const transb:Pchar; const offsetc:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const 
              k:PMKL_INT64; const alpha:Psingle; const a:PMKL_INT8; const lda:PMKL_INT64; const ao:PMKL_INT8; const 
              b:PMKL_UINT8; const ldb:PMKL_INT64; const bo:PMKL_INT8; const beta:Psingle; const c:PMKL_INT32; const 
              ldc:PMKL_INT64; const co:PMKL_INT32);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure GEMM_S16S16S32_64(const transa:Pchar; const transb:Pchar; const offsetc:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const 
              k:PMKL_INT64; const alpha:Psingle; const a:PMKL_INT16; const lda:PMKL_INT64; const ao:PMKL_INT16; const 
              b:PMKL_INT16; const ldb:PMKL_INT64; const bo:PMKL_INT16; const beta:Psingle; const c:PMKL_INT32; const 
              ldc:PMKL_INT64; const co:PMKL_INT32);_CALLING external {$ifdef libmkl} libmkl{$endif};





  function GEMM_S8U8S32_PACK_GET_SIZE_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};





  function GEMM_S16S16S32_PACK_GET_SIZE_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure GEMM_S8U8S32_PACK_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              src:pointer; const ld:PMKL_INT64; const dest:pointer);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure GEMM_S16S16S32_PACK_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              src:PMKL_INT16; const ld:PMKL_INT64; const dest:PMKL_INT16);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure GEMM_S8U8S32_COMPUTE_64(const transa:Pchar; const transb:Pchar; const offsetc:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const 
              k:PMKL_INT64; const alpha:Psingle; const a:PMKL_INT8; const lda:PMKL_INT64; const ao:PMKL_INT8; const 
              b:PMKL_UINT8; const ldb:PMKL_INT64; const bo:PMKL_INT8; const beta:Psingle; const c:PMKL_INT32; const 
              ldc:PMKL_INT64; const co:PMKL_INT32);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure GEMM_S16S16S32_COMPUTE_64(const transa:Pchar; const transb:Pchar; const offsetc:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const 
              k:PMKL_INT64; const alpha:Psingle; const a:PMKL_INT16; const lda:PMKL_INT64; const ao:PMKL_INT16; const 
              b:PMKL_INT16; const ldb:PMKL_INT64; const bo:PMKL_INT16; const beta:Psingle; const c:PMKL_INT32; const 
              ldc:PMKL_INT64; const co:PMKL_INT32);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure HGEMM_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_F16; const a:PMKL_F16; const lda:PMKL_INT64; const b:PMKL_F16; const ldb:PMKL_INT64; const 
              beta:PMKL_F16; const c:PMKL_F16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  function HGEMM_PACK_GET_SIZE_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure HGEMM_PACK_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_F16; const src:PMKL_F16; const ld:PMKL_INT64; const dest:PMKL_F16);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure HGEMM_COMPUTE_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_F16; const lda:PMKL_INT64; const b:PMKL_F16; const ldb:PMKL_INT64; const beta:PMKL_F16; const 
              c:PMKL_F16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}
  { Lower case declaration  }
  { BLAS Level1  }
{$ifdef LOWERCASE_DECL}
  function scabs1_64(const c:PMKL_Complex8):single;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function sasum_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure saxpy_64(const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure saxpby_64(const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const beta:Psingle; const 
              y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure saxpyi_64(const nz:PMKL_INT64; const a:Psingle; const x:Psingle; const indx:PMKL_INT64; const y:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function scasum_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function scnrm2_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure scopy_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  function sdot_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};





  function sdoti_64(const nz:PMKL_INT64; const x:Psingle; const indx:PMKL_INT64; const y:Psingle):single;_CALLING external {$ifdef libmkl} libmkl{$endif};







  function sdsdot_64(const n:PMKL_INT64; const sb:Psingle; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const 
             incy:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure sgthr_64(const nz:PMKL_INT64; const y:Psingle; const x:Psingle; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};



  procedure sgthrz_64(const nz:PMKL_INT64; const y:Psingle; const x:Psingle; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function snrm2_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64):single;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure srot_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64; const 
              c:Psingle; const s:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};

  procedure srotg_64(const a:Psingle; const b:Psingle; const c:Psingle; const s:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure sroti_64(const nz:PMKL_INT64; const x:Psingle; const indx:PMKL_INT64; const y:Psingle; const c:Psingle; const 
              s:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure srotm_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64; const 
              param:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};


  procedure srotmg_64(const d1:Psingle; const d2:Psingle; const x1:Psingle; const y1:Psingle; const param:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure sscal_64(const n:PMKL_INT64; const a:Psingle; const x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure ssctr_64(const nz:PMKL_INT64; const x:Psingle; const indx:PMKL_INT64; const y:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure sswap_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function isamax_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function isamin_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure caxpy_64(const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure caxpby_64(const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const 
              y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure caxpyi_64(const nz:PMKL_INT64; const a:PMKL_Complex8; const x:PMKL_Complex8; const indx:PMKL_INT64; const y:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure ccopy_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure cdotc_64(const pres:PMKL_Complex8; const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure cdotci_64(const pres:PMKL_Complex8; const nz:PMKL_INT64; const x:PMKL_Complex8; const indx:PMKL_INT64; const y:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure cdotu_64(const pres:PMKL_Complex8; const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure cdotui_64(const pres:PMKL_Complex8; const nz:PMKL_INT64; const x:PMKL_Complex8; const indx:PMKL_INT64; const y:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure cgthr_64(const nz:PMKL_INT64; const y:PMKL_Complex8; const x:PMKL_Complex8; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};



  procedure cgthrz_64(const nz:PMKL_INT64; const y:PMKL_Complex8; const x:PMKL_Complex8; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};


  procedure crotg_64(const a:PMKL_Complex8; const b:PMKL_Complex8; const c:Psingle; const s:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure cscal_64(const n:PMKL_INT64; const a:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure csctr_64(const nz:PMKL_INT64; const x:PMKL_Complex8; const indx:PMKL_INT64; const y:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure csrot_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const incy:PMKL_INT64; const 
              c:Psingle; const s:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure csscal_64(const n:PMKL_INT64; const a:Psingle; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure cswap_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function icamax_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function icamin_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};


  function dcabs1_64(const z:PMKL_Complex16):double;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function dasum_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure daxpy_64(const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure daxpby_64(const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const beta:Pdouble; const 
              y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure daxpyi_64(const nz:PMKL_INT64; const a:Pdouble; const x:Pdouble; const indx:PMKL_INT64; const y:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure dcopy_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  function ddot_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};






  function dsdot_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const y:Psingle; const incy:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};





  function ddoti_64(const nz:PMKL_INT64; const x:Pdouble; const indx:PMKL_INT64; const y:Pdouble):double;_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure dgthr_64(const nz:PMKL_INT64; const y:Pdouble; const x:Pdouble; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};



  procedure dgthrz_64(const nz:PMKL_INT64; const y:Pdouble; const x:Pdouble; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function dnrm2_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure drot_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64; const 
              c:Pdouble; const s:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};

  procedure drotg_64(const a:Pdouble; const b:Pdouble; const c:Pdouble; const s:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure droti_64(const nz:PMKL_INT64; const x:Pdouble; const indx:PMKL_INT64; const y:Pdouble; const c:Pdouble; const 
              s:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure drotm_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64; const 
              param:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};


  procedure drotmg_64(const d1:Pdouble; const d2:Pdouble; const x1:Pdouble; const y1:Pdouble; const param:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure dscal_64(const n:PMKL_INT64; const a:Pdouble; const x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure dsctr_64(const nz:PMKL_INT64; const x:Pdouble; const indx:PMKL_INT64; const y:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure dswap_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function dzasum_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function dznrm2_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64):double;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function idamax_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function idamin_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure zaxpy_64(const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure zaxpby_64(const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const 
              y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure zaxpyi_64(const nz:PMKL_INT64; const a:PMKL_Complex16; const x:PMKL_Complex16; const indx:PMKL_INT64; const y:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure zcopy_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure zdotc_64(const pres:PMKL_Complex16; const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure zdotci_64(const pres:PMKL_Complex16; const nz:PMKL_INT64; const x:PMKL_Complex16; const indx:PMKL_INT64; const y:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure zdotu_64(const pres:PMKL_Complex16; const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  procedure zdotui_64(const pres:PMKL_Complex16; const nz:PMKL_INT64; const x:PMKL_Complex16; const indx:PMKL_INT64; const y:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure zdrot_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const incy:PMKL_INT64; const 
              c:Pdouble; const s:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure zdscal_64(const n:PMKL_INT64; const a:Pdouble; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure zgthr_64(const nz:PMKL_INT64; const y:PMKL_Complex16; const x:PMKL_Complex16; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};



  procedure zgthrz_64(const nz:PMKL_INT64; const y:PMKL_Complex16; const x:PMKL_Complex16; const indx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};


  procedure zrotg_64(const a:PMKL_Complex16; const b:PMKL_Complex16; const c:Pdouble; const s:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure zscal_64(const n:PMKL_INT64; const a:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure zsctr_64(const nz:PMKL_INT64; const x:PMKL_Complex16; const indx:PMKL_INT64; const y:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};




  procedure zswap_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};




  function izamax_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};




  function izamin_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64):MKL_INT64;_CALLING external {$ifdef libmkl} libmkl{$endif};

  { blas level2  }












  procedure sgbmv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const kl:PMKL_INT64; const ku:PMKL_INT64; const 
              alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const 
              beta:Psingle; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure sgemv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const 
              lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const beta:Psingle; const y:Psingle; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure sger_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              y:Psingle; const incy:PMKL_INT64; const a:Psingle; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ssbmv_64(const uplo:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const a:Psingle; const 
              lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const beta:Psingle; const y:Psingle; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure sspmv_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const ap:Psingle; const x:Psingle; const 
              incx:PMKL_INT64; const beta:Psingle; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure sspr_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              ap:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure sspr2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              y:Psingle; const incy:PMKL_INT64; const ap:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure ssymv_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const 
              x:Psingle; const incx:PMKL_INT64; const beta:Psingle; const y:Psingle; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure ssyr_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              a:Psingle; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ssyr2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const 
              y:Psingle; const incy:PMKL_INT64; const a:Psingle; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure stbmv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Psingle; const lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure stbsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Psingle; const lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure stpmv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:Psingle; const 
              x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure stpsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:Psingle; const 
              x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure strmv_64(const uplo:Pchar; const transa:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:Psingle; const 
              lda:PMKL_INT64; const b:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure strsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:Psingle; const 
              lda:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure sgem2vu_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const 
              x1:Psingle; const incx1:PMKL_INT64; const x2:Psingle; const incx2:PMKL_INT64; const beta:Psingle; const 
              y1:Psingle; const incy1:PMKL_INT64; const y2:Psingle; const incy2:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure cgbmv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const kl:PMKL_INT64; const ku:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              beta:PMKL_Complex8; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure cgemv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure cgerc_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const a:PMKL_Complex8; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure cgeru_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const a:PMKL_Complex8; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure chbmv_64(const uplo:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure chemv_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const 
              x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure cher_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              a:PMKL_Complex8; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure cher2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const a:PMKL_Complex8; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure chpmv_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex8; const ap:PMKL_Complex8; const x:PMKL_Complex8; const 
              incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure chpr_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Psingle; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              ap:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure chpr2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const ap:PMKL_Complex8);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ctbmv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ctbsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure ctpmv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:PMKL_Complex8; const 
              x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure ctpsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:PMKL_Complex8; const 
              x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure ctrmv_64(const uplo:Pchar; const transa:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const b:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure ctrsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure cgem2vc_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const 
              x1:PMKL_Complex8; const incx1:PMKL_INT64; const x2:PMKL_Complex8; const incx2:PMKL_INT64; const beta:PMKL_Complex8; const 
              y1:PMKL_Complex8; const incy1:PMKL_INT64; const y2:PMKL_Complex8; const incy2:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure scgemv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:Psingle; const 
              lda:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PMKL_Complex8; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure dgbmv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const kl:PMKL_INT64; const ku:PMKL_INT64; const 
              alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const 
              beta:Pdouble; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure dgemv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const 
              lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const beta:Pdouble; const y:Pdouble; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure dger_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              y:Pdouble; const incy:PMKL_INT64; const a:Pdouble; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure dsbmv_64(const uplo:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const 
              lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const beta:Pdouble; const y:Pdouble; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure dspmv_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const ap:Pdouble; const x:Pdouble; const 
              incx:PMKL_INT64; const beta:Pdouble; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure dspr_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              ap:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure dspr2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              y:Pdouble; const incy:PMKL_INT64; const ap:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure dsymv_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const 
              x:Pdouble; const incx:PMKL_INT64; const beta:Pdouble; const y:Pdouble; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure dsyr_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              a:Pdouble; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure dsyr2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const 
              y:Pdouble; const incy:PMKL_INT64; const a:Pdouble; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure dtbmv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Pdouble; const lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure dtbsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Pdouble; const lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure dtpmv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:Pdouble; const 
              x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure dtpsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:Pdouble; const 
              x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure dtrmv_64(const uplo:Pchar; const transa:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:Pdouble; const 
              lda:PMKL_INT64; const b:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure dtrsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:Pdouble; const 
              lda:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure dgem2vu_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const 
              x1:Pdouble; const incx1:PMKL_INT64; const x2:Pdouble; const incx2:PMKL_INT64; const beta:Pdouble; const 
              y1:Pdouble; const incy1:PMKL_INT64; const y2:Pdouble; const incy2:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure zgbmv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const kl:PMKL_INT64; const ku:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              beta:PMKL_Complex16; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure zgemv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure zgerc_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const a:PMKL_Complex16; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure zgeru_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const a:PMKL_Complex16; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure zhbmv_64(const uplo:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure zhemv_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const 
              x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure zher_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              a:PMKL_Complex16; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure zher2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const a:PMKL_Complex16; const lda:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure zhpmv_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex16; const ap:PMKL_Complex16; const x:PMKL_Complex16; const 
              incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};






  procedure zhpr_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:Pdouble; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              ap:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure zhpr2_64(const uplo:Pchar; const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const ap:PMKL_Complex16);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ztbmv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure ztbsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure ztpmv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:PMKL_Complex16; const 
              x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};







  procedure ztpsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const ap:PMKL_Complex16; const 
              x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure ztrmv_64(const uplo:Pchar; const transa:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const b:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure ztrsv_64(const uplo:Pchar; const trans:Pchar; const diag:Pchar; const n:PMKL_INT64; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure zgem2vc_64(const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const 
              x1:PMKL_Complex16; const incx1:PMKL_INT64; const x2:PMKL_Complex16; const incx2:PMKL_INT64; const beta:PMKL_Complex16; const 
              y1:PMKL_Complex16; const incy1:PMKL_INT64; const y2:PMKL_Complex16; const incy2:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure dzgemv_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:Pdouble; const 
              lda:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PMKL_Complex16; const 
              incy:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

  { blas level3  }












  procedure sgemm_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const 
              beta:Psingle; const c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  function sgemm_pack_get_size_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure sgemm_pack_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Psingle; const src:Psingle; const ld:PMKL_INT64; const dest:Psingle);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure sgemm_compute_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const beta:Psingle; const 
              c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure sgemm_batch_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:Psingle; const a_array:PPsingle; const lda_array:PMKL_INT64; const b_array:PPsingle; const ldb_array:PMKL_INT64; const 
              beta_array:Psingle; const c_array:PPsingle; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure sgemm_batch_strided_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const stridea:PMKL_INT64; const b:Psingle; const 
              ldb:PMKL_INT64; const strideb:PMKL_INT64; const beta:Psingle; const c:Psingle; const ldc:PMKL_INT64; const 
              stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure sgemmt_64(const uplo:Pchar; const transa:Pchar; const transb:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const 
              beta:Psingle; const c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure ssymm_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const 
              a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const beta:Psingle; const 
              c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure ssyr2k_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const 
              a:Psingle; const lda:PMKL_INT64; const b:Psingle; const ldb:PMKL_INT64; const beta:Psingle; const 
              c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure ssyrk_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const 
              a:Psingle; const lda:PMKL_INT64; const beta:Psingle; const c:Psingle; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure ssyrk_batch_64(const uplo_array:Pchar; const trans_array:Pchar; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const alpha_array:Psingle; const 
              a_array:PPsingle; const lda_array:PMKL_INT64; const beta_array:Psingle; const c_array:PPsingle; const ldc_array:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ssyrk_batch_strided_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const 
              a:Psingle; const lda:PMKL_INT64; const stridea:PMKL_INT64; const beta:Psingle; const c:Psingle; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure strmm_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const b:Psingle; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure strsm_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const b:Psingle; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure strsm_batch_64(const side_array:Pchar; const uplo_array:Pchar; const transa_array:Pchar; const diag_array:Pchar; const m_array:PMKL_INT64; const 
              n_array:PMKL_INT64; const alpha_array:Psingle; const a_array:PPsingle; const lda_array:PMKL_INT64; const b_array:PPsingle; const 
              ldb:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};














  procedure strsm_batch_strided_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const lda:PMKL_INT64; const stridea:PMKL_INT64; const 
              b:Psingle; const ldb:PMKL_INT64; const strideb:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure cgemm_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure cgemm_batch_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:PMKL_Complex8; const a_array:PPMKL_Complex8; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex8; const ldb_array:PMKL_INT64; const 
              beta_array:PMKL_Complex8; const c_array:PPMKL_Complex8; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure cgemm_batch_strided_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const stridea:PMKL_INT64; const b:PMKL_Complex8; const 
              ldb:PMKL_INT64; const strideb:PMKL_INT64; const beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64; const 
              stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure scgemm_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:Psingle; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure cgemm3m_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure cgemm3m_batch_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:PMKL_Complex8; const a_array:PPMKL_Complex8; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex8; const ldb_array:PMKL_INT64; const 
              beta_array:PMKL_Complex8; const c_array:PPMKL_Complex8; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure cgemmt_64(const uplo:Pchar; const transa:Pchar; const transb:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure chemm_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const beta:PMKL_Complex8; const 
              c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure cher2k_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const beta:Psingle; const 
              c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure cherk_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Psingle; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const beta:Psingle; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure csymm_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const beta:PMKL_Complex8; const 
              c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure csyr2k_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const ldb:PMKL_INT64; const beta:PMKL_Complex8; const 
              c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure csyrk_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const beta:PMKL_Complex8; const c:PMKL_Complex8; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure csyrk_batch_64(const uplo_array:Pchar; const trans_array:Pchar; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const alpha_array:PMKL_Complex8; const 
              a_array:PPMKL_Complex8; const lda_array:PMKL_INT64; const beta_array:PMKL_Complex8; const c_array:PPMKL_Complex8; const ldc_array:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure csyrk_batch_strided_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex8; const 
              a:PMKL_Complex8; const lda:PMKL_INT64; const stridea:PMKL_INT64; const beta:PMKL_Complex8; const c:PMKL_Complex8; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ctrmm_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ctrsm_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const b:PMKL_Complex8; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ctrsm_batch_64(const side_array:Pchar; const uplo_array:Pchar; const transa_array:Pchar; const diag_array:Pchar; const m_array:PMKL_INT64; const 
              n_array:PMKL_INT64; const alpha_array:PMKL_Complex8; const a_array:PPMKL_Complex8; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex8; const 
              ldb:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};














  procedure ctrsm_batch_strided_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const lda:PMKL_INT64; const stridea:PMKL_INT64; const 
              b:PMKL_Complex8; const ldb:PMKL_INT64; const strideb:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure dgemm_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const 
              beta:Pdouble; const c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  function dgemm_pack_get_size_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure dgemm_pack_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Pdouble; const src:Pdouble; const ld:PMKL_INT64; const dest:Pdouble);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure dgemm_compute_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const beta:Pdouble; const 
              c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure dgemm_batch_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:Pdouble; const a_array:PPdouble; const lda_array:PMKL_INT64; const b_array:PPdouble; const ldb_array:PMKL_INT64; const 
              beta_array:Pdouble; const c_array:PPdouble; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure dgemm_batch_strided_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const stridea:PMKL_INT64; const b:Pdouble; const 
              ldb:PMKL_INT64; const strideb:PMKL_INT64; const beta:Pdouble; const c:Pdouble; const ldc:PMKL_INT64; const 
              stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure dgemmt_64(const uplo:Pchar; const transa:Pchar; const transb:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const 
              beta:Pdouble; const c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure dsymm_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const 
              a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const beta:Pdouble; const 
              c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure dsyr2k_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const 
              a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const ldb:PMKL_INT64; const beta:Pdouble; const 
              c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure dsyrk_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const 
              a:Pdouble; const lda:PMKL_INT64; const beta:Pdouble; const c:Pdouble; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure dsyrk_batch_64(const uplo_array:Pchar; const trans_array:Pchar; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const alpha_array:Pdouble; const 
              a_array:PPdouble; const lda_array:PMKL_INT64; const beta_array:Pdouble; const c_array:PPdouble; const ldc_array:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure dsyrk_batch_strided_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const 
              a:Pdouble; const lda:PMKL_INT64; const stridea:PMKL_INT64; const beta:Pdouble; const c:Pdouble; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure dtrmm_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure dtrsm_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const b:Pdouble; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure dtrsm_batch_64(const side_array:Pchar; const uplo_array:Pchar; const transa_array:Pchar; const diag_array:Pchar; const m_array:PMKL_INT64; const 
              n_array:PMKL_INT64; const alpha_array:Pdouble; const a_array:PPdouble; const lda_array:PMKL_INT64; const b_array:PPdouble; const 
              ldb:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};














  procedure dtrsm_batch_strided_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const lda:PMKL_INT64; const stridea:PMKL_INT64; const 
              b:Pdouble; const ldb:PMKL_INT64; const strideb:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure zgemm_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure zgemm_batch_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:PMKL_Complex16; const a_array:PPMKL_Complex16; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex16; const ldb_array:PMKL_INT64; const 
              beta_array:PMKL_Complex16; const c_array:PPMKL_Complex16; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure zgemm_batch_strided_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const stridea:PMKL_INT64; const b:PMKL_Complex16; const 
              ldb:PMKL_INT64; const strideb:PMKL_INT64; const beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64; const 
              stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure dzgemm_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:Pdouble; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure zgemm3m_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure zgemm3m_batch_64(const transa_array:Pchar; const transb_array:Pchar; const m_array:PMKL_INT64; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const 
              alpha_array:PMKL_Complex16; const a_array:PPMKL_Complex16; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex16; const ldb_array:PMKL_INT64; const 
              beta_array:PMKL_Complex16; const c_array:PPMKL_Complex16; const ldc_array:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure zgemmt_64(const uplo:Pchar; const transa:Pchar; const transb:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const 
              beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure zhemm_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const beta:PMKL_Complex16; const 
              c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure zher2k_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const beta:Pdouble; const 
              c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure zherk_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:Pdouble; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const beta:Pdouble; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure zsymm_64(const side:Pchar; const uplo:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const beta:PMKL_Complex16; const 
              c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure zsyr2k_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const ldb:PMKL_INT64; const beta:PMKL_Complex16; const 
              c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};










  procedure zsyrk_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const beta:PMKL_Complex16; const c:PMKL_Complex16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure zsyrk_batch_64(const uplo_array:Pchar; const trans_array:Pchar; const n_array:PMKL_INT64; const k_array:PMKL_INT64; const alpha_array:PMKL_Complex16; const 
              a_array:PPMKL_Complex16; const lda_array:PMKL_INT64; const beta_array:PMKL_Complex16; const c_array:PPMKL_Complex16; const ldc_array:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure zsyrk_batch_strided_64(const uplo:Pchar; const trans:Pchar; const n:PMKL_INT64; const k:PMKL_INT64; const alpha:PMKL_Complex16; const 
              a:PMKL_Complex16; const lda:PMKL_INT64; const stridea:PMKL_INT64; const beta:PMKL_Complex16; const c:PMKL_Complex16; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ztrmm_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ztrsm_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const b:PMKL_Complex16; const 
              ldb:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ztrsm_batch_64(const side_array:Pchar; const uplo_array:Pchar; const transa_array:Pchar; const diag_array:Pchar; const m_array:PMKL_INT64; const 
              n_array:PMKL_INT64; const alpha_array:PMKL_Complex16; const a_array:PPMKL_Complex16; const lda_array:PMKL_INT64; const b_array:PPMKL_Complex16; const 
              ldb:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};














  procedure ztrsm_batch_strided_64(const side:Pchar; const uplo:Pchar; const transa:Pchar; const diag:Pchar; const m:PMKL_INT64; const 
              n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const lda:PMKL_INT64; const stridea:PMKL_INT64; const 
              b:PMKL_Complex16; const ldb:PMKL_INT64; const strideb:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure gemm_s16s16s32_64(const transa:Pchar; const transb:Pchar; const offsetc:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const 
              k:PMKL_INT64; const alpha:Psingle; const a:PMKL_INT16; const lda:PMKL_INT64; const ao:PMKL_INT16; const 
              b:PMKL_INT16; const ldb:PMKL_INT64; const bo:PMKL_INT16; const beta:Psingle; const c:PMKL_INT32; const 
              ldc:PMKL_INT64; const co:PMKL_INT32);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure gemm_s8u8s32_64(const transa:Pchar; const transb:Pchar; const offsetc:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const 
              k:PMKL_INT64; const alpha:Psingle; const a:PMKL_INT8; const lda:PMKL_INT64; const ao:PMKL_INT8; const 
              b:PMKL_UINT8; const ldb:PMKL_INT64; const bo:PMKL_INT8; const beta:Psingle; const c:PMKL_INT32; const 
              ldc:PMKL_INT64; const co:PMKL_INT32);_CALLING external {$ifdef libmkl} libmkl{$endif};





  function gemm_s8u8s32_pack_get_size_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};





  function gemm_s16s16s32_pack_get_size_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure gemm_s8u8s32_pack_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              src:pointer; const ld:PMKL_INT64; const dest:pointer);_CALLING external {$ifdef libmkl} libmkl{$endif};








  procedure gemm_s16s16s32_pack_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              src:PMKL_INT16; const ld:PMKL_INT64; const dest:PMKL_INT16);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure gemm_s8u8s32_compute_64(const transa:Pchar; const transb:Pchar; const offsetc:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const 
              k:PMKL_INT64; const alpha:Psingle; const a:PMKL_INT8; const lda:PMKL_INT64; const ao:PMKL_INT8; const 
              b:PMKL_UINT8; const ldb:PMKL_INT64; const bo:PMKL_INT8; const beta:Psingle; const c:PMKL_INT32; const 
              ldc:PMKL_INT64; const co:PMKL_INT32);_CALLING external {$ifdef libmkl} libmkl{$endif};

















  procedure gemm_s16s16s32_compute_64(const transa:Pchar; const transb:Pchar; const offsetc:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const 
              k:PMKL_INT64; const alpha:Psingle; const a:PMKL_INT16; const lda:PMKL_INT64; const ao:PMKL_INT16; const 
              b:PMKL_INT16; const ldb:PMKL_INT64; const bo:PMKL_INT16; const beta:Psingle; const c:PMKL_INT32; const 
              ldc:PMKL_INT64; const co:PMKL_INT32);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure hgemm_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_F16; const a:PMKL_F16; const lda:PMKL_INT64; const b:PMKL_F16; const ldb:PMKL_INT64; const 
              beta:PMKL_F16; const c:PMKL_F16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};





  function hgemm_pack_get_size_64(const identifier:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64):size_t;_CALLING external {$ifdef libmkl} libmkl{$endif};









  procedure hgemm_pack_64(const identifier:Pchar; const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              alpha:PMKL_F16; const src:PMKL_F16; const ld:PMKL_INT64; const dest:PMKL_F16);_CALLING external {$ifdef libmkl} libmkl{$endif};












  procedure hgemm_compute_64(const transa:Pchar; const transb:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const k:PMKL_INT64; const 
              a:PMKL_F16; const lda:PMKL_INT64; const b:PMKL_F16; const ldb:PMKL_INT64; const beta:PMKL_F16; const 
              c:PMKL_F16; const ldc:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

  { Level1 BLAS batch API  }

{$endif}




{$ifdef UPPERCASE_DECL}
  procedure SAXPY_BATCH_64(const n:PMKL_INT64; const alpha:Psingle; const x:PPsingle; const incx:PMKL_INT64; const y:PPsingle; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}





{$ifdef LOWERCASE_DECL}
  procedure saxpy_batch_64(const n:PMKL_INT64; const alpha:Psingle; const x:PPsingle; const incx:PMKL_INT64; const y:PPsingle; const
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}







{$ifdef UPPERCASE_DECL}
  procedure DAXPY_BATCH_64(const n:PMKL_INT64; const alpha:Pdouble; const x:PPdouble; const incx:PMKL_INT64; const y:PPdouble; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}






{$ifdef LOWERCASE_DECL}
  procedure daxpy_batch_64(const n:PMKL_INT64; const alpha:Pdouble; const x:PPdouble; const incx:PMKL_INT64; const y:PPdouble; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}







{$ifdef UPPERCASE_DECL}
  procedure CAXPY_BATCH_64(const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PPMKL_Complex8; const incx:PMKL_INT64; const y:PPMKL_Complex8; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}






{$ifdef LOWERCASE_DECL}
  procedure caxpy_batch_64(const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PPMKL_Complex8; const incx:PMKL_INT64; const y:PPMKL_Complex8; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
  {$endif}







{$ifdef UPPERCASE_DECL}
  procedure ZAXPY_BATCH_64(const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PPMKL_Complex16; const incx:PMKL_INT64; const y:PPMKL_Complex16; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}






{$ifdef LOWERCASE_DECL}
  procedure zaxpy_batch_64(const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PPMKL_Complex16; const incx:PMKL_INT64; const y:PPMKL_Complex16; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}






{$ifdef UPPERCASE_DECL}
  procedure SCOPY_BATCH_64(const n:PMKL_INT64; const x:PPsingle; const incx:PMKL_INT64; const y:PPsingle; const incy:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}





{$ifdef LOWERCASE_DECL}
  procedure scopy_batch_64(const n:PMKL_INT64; const x:PPsingle; const incx:PMKL_INT64; const y:PPsingle; const incy:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
  {$endif}






{$ifdef UPPERCASE_DECL}
  procedure DCOPY_BATCH_64(const n:PMKL_INT64; const x:PPdouble; const incx:PMKL_INT64; const y:PPdouble; const incy:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}





{$ifdef LOWERCASE_DECL}
  procedure dcopy_batch_64(const n:PMKL_INT64; const x:PPdouble; const incx:PMKL_INT64; const y:PPdouble; const incy:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}






{$ifdef UPPERCASE_DECL}
  procedure CCOPY_BATCH_64(const n:PMKL_INT64; const x:PPMKL_Complex8; const incx:PMKL_INT64; const y:PPMKL_Complex8; const incy:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}





{$ifdef LOWERCASE_DECL}
  procedure ccopy_batch_64(const n:PMKL_INT64; const x:PPMKL_Complex8; const incx:PMKL_INT64; const y:PPMKL_Complex8; const incy:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}






{$ifdef UPPERCASE_DECL}
  procedure ZCOPY_BATCH_64(const n:PMKL_INT64; const x:PPMKL_Complex16; const incx:PMKL_INT64; const y:PPMKL_Complex16; const incy:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}





{$ifdef LOWERCASE_DECL}
  procedure zcopy_batch_64(const n:PMKL_INT64; const x:PPMKL_Complex16; const incx:PMKL_INT64; const y:PPMKL_Complex16; const incy:PMKL_INT64; const 
              group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}








{$ifdef UPPERCASE_DECL}
  procedure SAXPY_BATCH_STRIDED_64(const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              y:Psingle; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}







{$ifdef LOWERCASE_DECL}
  procedure saxpy_batch_strided_64(const n:PMKL_INT64; const alpha:Psingle; const x:Psingle; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              y:Psingle; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}








{$ifdef UPPERCASE_DECL}
  procedure DAXPY_BATCH_STRIDED_64(const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              y:Pdouble; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}







{$ifdef LOWERCASE_DECL}
  procedure daxpy_batch_strided_64(const n:PMKL_INT64; const alpha:Pdouble; const x:Pdouble; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              y:Pdouble; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}








{$ifdef UPPERCASE_DECL}
  procedure CAXPY_BATCH_STRIDED_64(const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}







{$ifdef LOWERCASE_DECL}
  procedure caxpy_batch_strided_64(const n:PMKL_INT64; const alpha:PMKL_Complex8; const x:PMKL_Complex8; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              y:PMKL_Complex8; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}








{$ifdef UPPERCASE_DECL}
  procedure ZAXPY_BATCH_STRIDED_64(const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}







{$ifdef LOWERCASE_DECL}
  procedure zaxpy_batch_strided_64(const n:PMKL_INT64; const alpha:PMKL_Complex16; const x:PMKL_Complex16; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              y:PMKL_Complex16; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}







{$ifdef UPPERCASE_DECL}
  procedure SCOPY_BATCH_STRIDED_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const stridex:PMKL_INT64; const y:Psingle; const 
              incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}






{$ifdef LOWERCASE_DECL}
  procedure scopy_batch_strided_64(const n:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const stridex:PMKL_INT64; const y:Psingle; const 
              incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
  {$endif}







{$ifdef UPPERCASE_DECL}
  procedure DCOPY_BATCH_STRIDED_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const stridex:PMKL_INT64; const y:Pdouble; const 
              incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}






{$ifdef LOWERCASE_DECL}
  procedure dcopy_batch_strided_64(const n:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const stridex:PMKL_INT64; const y:Pdouble; const 
              incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
 {$endif}







{$ifdef UPPERCASE_DECL}
  procedure CCOPY_BATCH_STRIDED_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const stridex:PMKL_INT64; const y:PMKL_Complex8; const 
              incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}






{$ifdef LOWERCASE_DECL}
  procedure ccopy_batch_strided_64(const n:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const stridex:PMKL_INT64; const y:PMKL_Complex8; const 
              incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
  {$endif}







{$ifdef UPPERCASE_DECL}
  procedure ZCOPY_BATCH_STRIDED_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const stridex:PMKL_INT64; const y:PMKL_Complex16; const 
              incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}






{$ifdef LOWERCASE_DECL}
  procedure zcopy_batch_strided_64(const n:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const stridex:PMKL_INT64; const y:PMKL_Complex16; const 
              incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

  { Level2 BLAS batch API  }












  procedure sgemv_batch_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const a:PPsingle; const 
              lda:PMKL_INT64; const x:PPsingle; const incx:PMKL_INT64; const beta:Psingle; const y:PPsingle; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure sgemv_batch_strided_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const 
              lda:PMKL_INT64; const stridea:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              beta:Psingle; const y:Psingle; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure dgemv_batch_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const a:PPdouble; const 
              lda:PMKL_INT64; const x:PPdouble; const incx:PMKL_INT64; const beta:Pdouble; const y:PPdouble; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure dgemv_batch_strided_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const 
              lda:PMKL_INT64; const stridea:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              beta:Pdouble; const y:Pdouble; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure cgemv_batch_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PPMKL_Complex8; const 
              lda:PMKL_INT64; const x:PPMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PPMKL_Complex8; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure cgemv_batch_strided_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const stridea:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              beta:PMKL_Complex8; const y:PMKL_Complex8; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure zgemv_batch_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PPMKL_Complex16; const 
              lda:PMKL_INT64; const x:PPMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PPMKL_Complex16; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure zgemv_batch_strided_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const stridea:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              beta:PMKL_Complex16; const y:PMKL_Complex16; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};









{$endif}

{$ifdef UPPERCASE_DECL}

  procedure SGEMV_BATCH_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const a:PPsingle; const 
              lda:PMKL_INT64; const x:PPsingle; const incx:PMKL_INT64; const beta:Psingle; const y:PPsingle; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure SGEMV_BATCH_STRIDED_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Psingle; const a:Psingle; const 
              lda:PMKL_INT64; const stridea:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              beta:Psingle; const y:Psingle; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DGEMV_BATCH_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const a:PPdouble; const 
              lda:PMKL_INT64; const x:PPdouble; const incx:PMKL_INT64; const beta:Pdouble; const y:PPdouble; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure DGEMV_BATCH_STRIDED_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:Pdouble; const a:Pdouble; const 
              lda:PMKL_INT64; const stridea:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              beta:Pdouble; const y:Pdouble; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CGEMV_BATCH_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PPMKL_Complex8; const 
              lda:PMKL_INT64; const x:PPMKL_Complex8; const incx:PMKL_INT64; const beta:PMKL_Complex8; const y:PPMKL_Complex8; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure CGEMV_BATCH_STRIDED_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex8; const a:PMKL_Complex8; const 
              lda:PMKL_INT64; const stridea:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              beta:PMKL_Complex8; const y:PMKL_Complex8; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZGEMV_BATCH_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PPMKL_Complex16; const 
              lda:PMKL_INT64; const x:PPMKL_Complex16; const incx:PMKL_INT64; const beta:PMKL_Complex16; const y:PPMKL_Complex16; const 
              incy:PMKL_INT64; const group_count:PMKL_INT64; const group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};















  procedure ZGEMV_BATCH_STRIDED_64(const trans:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const alpha:PMKL_Complex16; const a:PMKL_Complex16; const 
              lda:PMKL_INT64; const stridea:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const stridex:PMKL_INT64; const 
              beta:PMKL_Complex16; const y:PMKL_Complex16; const incy:PMKL_INT64; const stridey:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};

{$endif}








{$ifdef LOWERCASE_DECL}
  procedure sdgmm_batch_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PPsingle; const lda:PMKL_INT64; const 
              x:PPsingle; const incx:PMKL_INT64; const c:PPsingle; const ldc:PMKL_INT64; const group_count:PMKL_INT64; const 
              group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure sdgmm_batch_strided_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:Psingle; const lda:PMKL_INT64; const 
              stridea:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const stridex:PMKL_INT64; const c:Psingle; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ddgmm_batch_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PPdouble; const lda:PMKL_INT64; const 
              x:PPdouble; const incx:PMKL_INT64; const c:PPdouble; const ldc:PMKL_INT64; const group_count:PMKL_INT64; const 
              group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ddgmm_batch_strided_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:Pdouble; const lda:PMKL_INT64; const 
              stridea:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const stridex:PMKL_INT64; const c:Pdouble; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure cdgmm_batch_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PPMKL_Complex8; const lda:PMKL_INT64; const 
              x:PPMKL_Complex8; const incx:PMKL_INT64; const c:PPMKL_Complex8; const ldc:PMKL_INT64; const group_count:PMKL_INT64; const 
              group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure cdgmm_batch_strided_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PMKL_Complex8; const lda:PMKL_INT64; const 
              stridea:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const stridex:PMKL_INT64; const c:PMKL_Complex8; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure zdgmm_batch_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PPMKL_Complex16; const lda:PMKL_INT64; const 
              x:PPMKL_Complex16; const incx:PMKL_INT64; const c:PPMKL_Complex16; const ldc:PMKL_INT64; const group_count:PMKL_INT64; const 
              group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure zdgmm_batch_strided_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PMKL_Complex16; const lda:PMKL_INT64; const 
              stridea:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const stridex:PMKL_INT64; const c:PMKL_Complex16; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};


{$endif}






 {$ifdef UPPERCASE_DECL}

  procedure SDGMM_BATCH_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PPsingle; const lda:PMKL_INT64; const 
              x:PPsingle; const incx:PMKL_INT64; const c:PPsingle; const ldc:PMKL_INT64; const group_count:PMKL_INT64; const 
              group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure SDGMM_BATCH_STRIDED_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:Psingle; const lda:PMKL_INT64; const 
              stridea:PMKL_INT64; const x:Psingle; const incx:PMKL_INT64; const stridex:PMKL_INT64; const c:Psingle; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure DDGMM_BATCH_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PPdouble; const lda:PMKL_INT64; const 
              x:PPdouble; const incx:PMKL_INT64; const c:PPdouble; const ldc:PMKL_INT64; const group_count:PMKL_INT64; const 
              group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure DDGMM_BATCH_STRIDED_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:Pdouble; const lda:PMKL_INT64; const 
              stridea:PMKL_INT64; const x:Pdouble; const incx:PMKL_INT64; const stridex:PMKL_INT64; const c:Pdouble; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure CDGMM_BATCH_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PPMKL_Complex8; const lda:PMKL_INT64; const 
              x:PPMKL_Complex8; const incx:PMKL_INT64; const c:PPMKL_Complex8; const ldc:PMKL_INT64; const group_count:PMKL_INT64; const 
              group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure CDGMM_BATCH_STRIDED_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PMKL_Complex8; const lda:PMKL_INT64; const 
              stridea:PMKL_INT64; const x:PMKL_Complex8; const incx:PMKL_INT64; const stridex:PMKL_INT64; const c:PMKL_Complex8; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};











  procedure ZDGMM_BATCH_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PPMKL_Complex16; const lda:PMKL_INT64; const 
              x:PPMKL_Complex16; const incx:PMKL_INT64; const c:PPMKL_Complex16; const ldc:PMKL_INT64; const group_count:PMKL_INT64; const 
              group_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};













  procedure ZDGMM_BATCH_STRIDED_64(const side:Pchar; const m:PMKL_INT64; const n:PMKL_INT64; const a:PMKL_Complex16; const lda:PMKL_INT64; const 
              stridea:PMKL_INT64; const x:PMKL_Complex16; const incx:PMKL_INT64; const stridex:PMKL_INT64; const c:PMKL_Complex16; const 
              ldc:PMKL_INT64; const stridec:PMKL_INT64; const batch_size:PMKL_INT64);_CALLING external {$ifdef libmkl} libmkl{$endif};
{$endif}
implementation


end.
