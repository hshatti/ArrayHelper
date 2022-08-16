unit mkl_service;
interface
uses mkl_types;

{$include mkl.inc}
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}

const 
        MKL_BLACS_CUSTOM   = 0;
        MKL_BLACS_MSMPI    = 1;
        MKL_BLACS_INTELMPI = 2;
        MKL_BLACS_MPICH2   = 3;
        MKL_BLACS_LASTMPI  = 4;



  procedure MKL_Get_Version(ver:PMKLVersion);cdecl;external;

  procedure MKL_Get_Version_String(buffer:Pchar; len:longint);cdecl;external;

  procedure MKL_Free_Buffers;cdecl;external;

  procedure MKL_Thread_Free_Buffers;cdecl;external;

  function MKL_Mem_Stat(nbuffers:Plongint):int64;cdecl;external;

  function MKL_Peak_Mem_Usage(reset:longint):int64;cdecl;external;

  function MKL_malloc(size:size_t; align:longint):pointer;cdecl;external;

  function MKL_calloc(num:size_t; size:size_t; align:longint):pointer;cdecl;external;

  function MKL_realloc(ptr:pointer; size:size_t):pointer;cdecl;external;

  procedure MKL_free(ptr:pointer);cdecl;external;

  function MKL_Disable_Fast_MM:longint;cdecl;external;

  procedure MKL_Get_Cpu_Clocks(_para1:Pqword);cdecl;external;

  function MKL_Get_Cpu_Frequency:double;cdecl;external;

  function MKL_Get_Max_Cpu_Frequency:double;cdecl;external;

  function MKL_Get_Clocks_Frequency:double;cdecl;external;

  function MKL_Set_Num_Threads_Local(nth:longint):longint;cdecl;external;

  procedure MKL_Set_Num_Threads(nth:longint);cdecl;external;

  function MKL_Get_Max_Threads:longint;cdecl;external;

  procedure MKL_Set_Num_Stripes(nstripes:longint);cdecl;external;

  function MKL_Get_Num_Stripes:longint;cdecl;external;

  function MKL_Domain_Set_Num_Threads(nth:longint; MKL_DOMAIN:longint):longint;cdecl;external;

  function MKL_Domain_Get_Max_Threads(MKL_DOMAIN:longint):longint;cdecl;external;

  procedure MKL_Set_Dynamic(bool_MKL_DYNAMIC:longint);cdecl;external;

  function MKL_Get_Dynamic:longint;cdecl;external;

//  function MKL_PROGRESS(thread:Plongint; _step:Plongint; stage:Pchar; lstage:longint):longint;cdecl;external;

//  function MKL_PROGRESS_(thread:Plongint; _step:Plongint; stage:Pchar; lstage:longint):longint;cdecl;external;

  function mkl_progress(thread:Plongint; _step:Plongint; stage:Pchar; lstage:longint):longint;cdecl;external;

//  function mkl_progress_(thread:Plongint; _step:Plongint; stage:Pchar; lstage:longint):longint;cdecl;external;

  function MKL_Enable_Instructions(_para1:longint):longint;cdecl;external;

  function MKL_Set_Interface_Layer(code:longint):longint;cdecl;external;

  function MKL_Set_Threading_Layer(code:longint):longint;cdecl;external;


  type

    XerblaEntry = procedure (const Name:Pchar;const Num:Plongint;const Len:longint);cdecl;

  function mkl_set_xerbla(xerbla:XerblaEntry):XerblaEntry;cdecl;external;


  type

    ProgressEntry = function (thread:Plongint; step:Plongint; stage:Pchar; stage_len:longint):longint;cdecl;

  function mkl_set_progress(progress:ProgressEntry):ProgressEntry;cdecl;external;


  type

    PardisopivotEntry = function (aii:Pdouble; bii:Pdouble; eps:Pdouble):longint;cdecl;

  function mkl_set_pardiso_pivot(pardiso_pivot:PardisopivotEntry):PardisopivotEntry;cdecl;external;

  function MKL_CBWR_Get(_para1:longint):longint;cdecl;external;

  function MKL_CBWR_Set(_para1:longint):longint;cdecl;external;

  function MKL_CBWR_Get_Auto_Branch:longint;cdecl;external;

  function MKL_Set_Env_Mode(_para1:longint):longint;cdecl;external;

  function MKL_Verbose(_para1:longint):longint;cdecl;external;

  function MKL_Verbose_Output_File(const fname:Pchar):longint;cdecl;external;


  type

    MKLExitHandler = procedure (why:longint);cdecl;

  procedure MKL_Set_Exit_Handler(h:MKLExitHandler);cdecl;external;
    function MKL_Set_mpi(vendor:longint; custom_library_name:Pchar):longint;cdecl;external;

    function MKL_Set_Memory_Limit(mem_type:longint; limit:size_t):longint;cdecl;external;

    procedure MKL_Finalize;cdecl;external;


implementation


end.
