{ TConvTensor }

TConvTensor=record helper for TSingleTensor
public
  procedure LoadFromFile(const filename:string;const asGrayScale:boolean=true;const bias:single=-1.0;const scale:single=2.0);
  procedure Draw(const toGraphic: TGraphic);
  procedure Kernel2d(const kernel: TSingleDynArray; const bias: Single;
    const stride: integer; Padding: integer); // if Padding = -1 then output tensor is the same size with 0 padded edges
private
  //class function internalDot(const a,b:PSingle;const count:integer ):Single ;register;static;overload;inline;
end;


