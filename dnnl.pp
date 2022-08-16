
unit dnnl;
interface

uses cl;
{$MACRO ON}
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


  {******************************************************************************
  * Copyright 2016-2021 Intel Corporation
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  *
  *     http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  ****************************************************************************** }
  {/ @file }
  {/ C API }

  const
    DNNL_VERSION_MAJOR = 2;    
  {/ Minor version }
    DNNL_VERSION_MINOR = 5;    
  {/ Patch version }
    DNNL_VERSION_PATCH = 0;    
  {/ Git commit hash }
    DNNL_VERSION_HASH = '8421da27a692c39af4d0dee2f0c2ae539b2b433d';    
  { clang-format on }

type
    psize_t = ^size_t;
    size_t = SizeInt;
    Pint8_t = ^int8_t;
    int8_t = int8;
    Puint8_t = ^uint8_t;
    uint8_t = byte;
    PPint32_t = ^Pint32_t;
    Pint32_t = ^int32_t;
    int32_t = int32;
    int64_t = int64;
    PPuint32_t = ^Puint32_t;
    Puint32_t = ^uint32_t;
    uint32_t = longword;
    Puint64_t = ^uint64_t;
    uint64_t = qword;
    dnnl_status_t = (dnnl_success := 0,dnnl_out_of_memory := 1,
    dnnl_invalid_arguments := 2,dnnl_unimplemented := 3,
    dnnl_iterator_ends := 4,dnnl_runtime_error := 5,
    dnnl_not_required := 6);
  {/ @ dnnl_api_utils }
  {/ @addtogroup dnnl_api_memory }
  {/ @ }
  {/ Data type specification }
  {/ Undefined data type, used for empty memory descriptors. }
  {/ 16-bit/half-precision floating point. }
  {/ non-standard 16-bit (bfloat16 w/ 7 bit mantissa) floating point. }
  {/ 32-bit/single-precision floating point. }
  {/ 32-bit signed integer. }
  {/ 8-bit signed integer. }
  {/ 8-bit unsigned integer. }

    dnnl_data_type_t = (dnnl_data_type_undef := 0,dnnl_f16 := 1,
      dnnl_bf16 := 2,dnnl_f32 := 3,dnnl_s32 := 4,
      dnnl_s8 := 5,dnnl_u8 := 6);
  {/ Memory format kind }
  {/ Undefined memory format kind, used for empty memory descriptors. }
  {/ Unspecified format kind. }
  {/ The primitive selects a format automatically. }
  {/ A tensor in a generic format described by the stride and blocking }
  {/ values in each dimension. See @ref dnnl_blocking_desc_t for more }
  {/ information. }
  {/ Weights format used in 8bit Winograd convolution }
  {/ Packed weights format used in RNN }

    dnnl_format_kind_t = (dnnl_format_kind_undef := 0,dnnl_format_kind_any,
      dnnl_blocked,dnnl_format_kind_wino,dnnl_format_kind_rnn_packed
      );
  {/ Memory format tag specification. }
  {/ }
  {/ oneDNN formats describe physical data layout. The physical layout }
  {/ is described as a sequence of the dimensions as they are laid out in the }
  {/ memory (from the outer-most to the inner-most). Note that this order }
  {/ doesn't affect the logical order of the dimensions that is kept in the }
  {/ `dims` field of the dnnl_memory_desc_t structure. The logical order of the }
  {/ dimensions is specified by the primitive that uses the tensor. }
  {/ }
  {/ For example, CNN 5D tensor always has its logical dimensions in the order }
  {/ `(batch, channels, depth, height, width)`, while the physical layout might be }
  {/ `NCDHW` (corresponds to #dnnl_ncdhw format tag) or }
  {/ `NDHWC` (corresponds to #dnnl_ndhwc format tag). }
  {/ }
  {/ ~~~cpp }
  {/ int batch = 2, channels = 16, depth = 13, height = 13, width = 13; }
  {/ }
  {/ int ndims = 5; // 5D tensor }
  {/ dnnl_dims_t dims = batch, channels, depth, height, width; }
  {/ dnnl_memory_desc_t data_in_ncdhw; }
  {/ dnnl_memory_desc_init_by_tag( }
  {/      &data_in_ncdhw, 5, dims, dnnl_f32, dnnl_ncdhw); }
  {/ }
  {/ // note that in both cases dims passed are the same }
  {/ dnnl_memory_desc_t data_in_ndhwc; }
  {/ dnnl_memory_desc_init_by_tag( }
  {/      &data_in_ndhwc, 5, dims, dnnl_f32, dnnl_ndhwc); }
  {/ ~~~ }
  {/ }
  {/ Memory format tags can be further divided into two categories: }
  {/  - Domain-agnostic names, i.e. names the do not depend on the tensor usage }
  {/    in the specific primitive. These names use letters from `a` to `l` to }
  {/    denote logical dimension from 1 to 12, and form the order in which the }
  {/    dimensions are laid in memory. For instance, #dnnl_ab is used to denote }
  {/    2D tensor where the second logical dimension (aka `b`) is the innermost, }
  {/    i.e. has stride = 1, and the first logical dimension (`a`) laid out in }
  {/    memory with stride equal to the size of second dimension. On the other }
  {/    hand, #dnnl_ba is just transposed version of the same tensor: the }
  {/    first dimension (`a`) becomes the innermost one. }
  {/  - Domain-specific names, i.e. names that make sense only in the context of }
  {/    a certain domain, such as CNN. This names are just aliases to the }
  {/    corresponding domain-agnostic tags and used mostly for the convenience. }
  {/    For example, #dnnl_nc is used to denote 2D CNN activations tensor }
  {/    memory format, where channels are the innermost dimension and batch is an }
  {/    outermost one. Moreover, #dnnl_nc is just an alias to #dnnl_ab, }
  {/    since for oneDNN CNN primitives the logical dimensions of }
  {/    activations tensors come in order: batch, channels, spatial. }
  {/    In other words, batch corresponds to the first logical dimension (`a`), }
  {/    channels correspond to the second one (`b`). }
  {/ }
  {/ The following domain-specific notation applies to memory format tags: }
  {/  - @c 'n' denotes the mini-batch dimension }
  {/  - @c 'c' denotes a channels dimension }
  {/  - When there are multiple channel dimensions (for example, in convolution }
  {/    weights tensor), @c 'i' and @c 'o' denote dimensions of input and output }
  {/    channels }
  {/  - @c 'd', @c 'h', and @c 'w' denote spatial depth, height, and width }
  {/    respectively }
  {/ }
  {/ Upper-case letters indicate that the data is laid out in blocks for a }
  {/ particular dimension. In such cases, the format name contains both upper- }
  {/ and lower-case letters for that dimension with a lower-case letter preceded }
  {/ by the block size. For example: #dnnl_nChw8c describes a format where the }
  {/ outermost dimension is mini-batch, followed by the channel block number, }
  {/ followed by the spatial height and width, and finally followed by 8-element }
  {/ channel blocks. }
  {/ }
  {/ @sa @ref dev_guide_understanding_memory_formats }
  {/ Undefined memory format tag }
  {/ Undefined memory format tag. }
  {/ The primitive selects a format automatically. }
  { Semantic agnostic section }
  { The physical order of dimensions is defined by the permutation of the }
  { characters, assuming that ab..z defines the natural order. }
  { Plain formats }
  {/< plain 1D tensor }
  {/< plain 2D tensor }
  {/< plain 3D tensor }
  {/< plain 4D tensor }
  {/< plain 4D tensor }
  {/< plain 5D tensor }
  {/< plain 6D tensor }
  {/< plain 7D tensor }
  {/< plain 8D tensor }
  {/< plain 9D tensor }
  {/< plain 10D tensor }
  {/< plain 11D tensor }
  {/< plain 12D tensor }
  { Permuted plain formats }
  {/< permuted 4D tensor }
  {/< permuted 5D tensor }
  {/< permuted 3D tensor }
  {/< permuted 5D tensor }
  {/< permuted 6D tensor }
  {/< permuted 4D tensor }
  {/< permuted 5D tensor }
  {/< permuted 2D tensor }
  {/< permuted 3D tensor }
  {/< permuted 4D tensor }
  {/< permuted 5D tensor }
  {/< permuted 3D tensor }
  {/< permuted 4D tensor }
  {/< permuted 5D tensor }
  {/< permuted 3D tensor }
  {/< permuted 4D tensor }
  {/< permuted 4D tensor }
  {/< permuted 5D tensor }
  {/< permuted 5D tensor }
  {/< permuted 6D tensor }
  {/< permuted 5D tensor }
  {/< permuted 6D tensor }
  {/< permuted 7D tensor }
  {/< permuted 8D tensor }
  {/< permuted 9D tensor }
  {/< permuted 10D tensor }
  {/< permuted 11D tensor }
  {/< permuted 12D tensor }
  { Opaque blocked formats }
  {/ 3D tensor blocked by 2nd dimension with block size 16 }
  {/ 3D tensor blocked by 2nd dimension with block size 32 }
  {/ 3D tensor blocked by 2nd dimension with block size 4 }
  {/ 3D tensor blocked by 2nd dimension with block size 8 }
  {/ 4D tensor blocked by 2nd dimension with block size 16 }
  {/ 4D tensor blocked by 2nd dimension with block size 32 }
  {/ 4D tensor blocked by 2nd dimension with block size 4 }
  {/ 4D tensor blocked by 2nd dimension with block size 8 }
  {/ 4D tensor blocked by 1st and 2nd dimension with block size 8 }
  {/ 4D tensor blocked by 3rd dimension with block size 4 }
  {/ 5D tensor blocked by 1st dimension with block size 16 }
  {/ 5D tensor blocked by 1st dimension with block size 8 }
  {/ 5D tensor blocked by 2nd dimension with block size 16 }
  {/ 5D tensor blocked by 2nd dimension with block size 32 }
  {/ 5D tensor blocked by 2nd dimension with block size 4 }
  {/ 5D tensor blocked by 2nd dimension with block size 8 }
  {/ 5D tensor blocked by 3rd dimension with block size 4 }
  {/ 6D tensor blocked by 2nd dimension with block size 16 }
  {/ 6D tensor blocked by 2nd dimension with block size 8 }
  {/ 6D tensor blocked by 3rd dimension with block size 4 }
  {/ 6D tensor blocked by 2nd dimension with block size 4 }
  {/< permuted 6D tensor }
  {/< permuted 6D tensor }
  {/ Just a sentinel, not real memory format tag. Must be changed after new }
  {/ format tag is added. }
  { Aliases }
  {/ 1D tensor, an alias to #dnnl_a }
  {/ 2D CNN activations tensor, an alias to #dnnl_ab }
  {/ 2D CNN activations tensor, an alias to #dnnl_ba }
  {/ 2D RNN statistics tensor, an alias to #dnnl_ab }
  {/ 2D RNN statistics tensor, an alias to #dnnl_ba }
  {/ 3D CNN activations tensor, an alias to #dnnl_abc }
  {/ 3D CNN activations tensor, an alias to #dnnl_acb }
  {/ 4D CNN activations tensor, an alias to #dnnl_abcd }
  {/ 4D CNN activations tensor, an alias to #dnnl_acdb }
  {/ 4D CNN activations tensor, an alias to #dnnl_bcda }
  {/ 5D CNN activations tensor, an alias to #dnnl_abcde }
  {/ 5D CNN activations tensor, an alias to #dnnl_acdeb }
  {/ 2D CNN weights tensor, an alias to #dnnl_ab }
  {/ 2D CNN weights tensor, an alias to #dnnl_ba }
  {/ 3D CNN weights tensor, an alias to #dnnl_abc }
  {/ 3D CNN weights tensor, an alias to #dnnl_acb }
  {/ 3D CNN weights tensor, an alias to #dnnl_cba }
  {/ 3D CNN weights tensor, an alias to #dnnl_bca }
  {/ 4D CNN weights tensor, an alias to #dnnl_abcd }
  {/ 4D CNN weights tensor, an alias to #dnnl_cdba }
  {/ 4D CNN weights tensor, an alias to #dnnl_acdb }
  {/ 4D CNN weights tensor, an alias to #dnnl_bcda }
  {/ 4D CNN weights tensor, an alias to #dnnl_bacd }
  {/ 5D CNN weights tensor, an alias to #dnnl_abcde }
  {/ 5D CNN weights tensor, an alias to #dnnl_bacde }
  {/ 5D CNN weights tensor, an alias to #dnnl_cdeba }
  {/ 5D CNN weights tensor, an alias to #dnnl_acdeb }
  {/ 5D CNN weights tensor, an alias to #dnnl_bcdea }
  {/ 4D CNN weights tensor (incl. groups), an alias to #dnnl_abcd }
  {/ 4D CNN weights tensor (incl. groups), an alias to #dnnl_abdc }
  {/ 4D CNN weights tensor (incl. groups), an alias to #dnnl_dcab }
  {/ 5D CNN weights tensor (incl. groups), an alias to #dnnl_abcde }
  {/ 5D CNN weights tensor (incl. groups), an alias to #dnnl_abdec }
  {/ 5D CNN weights tensor (incl. groups), an alias to #dnnl_decab }
  {/ 5D CNN weights tensor (incl. groups), an alias to #dnnl_acbde }
  {/ 6D CNN weights tensor (incl. groups), an alias to #dnnl_abcdef }
  {/ 6D CNN weights tensor (incl. groups), an alias to #dnnl_abdefc }
  {/ 6D CNN weights tensor (incl. groups), an alias to #dnnl_acbdef }
  {/ 6D CNN weights tensor (incl. groups), an alias to #dnnl_defcab }
  {/ 3D RNN data tensor in the format (seq_length, batch, input channels), }
  {/ an alias to #dnnl_abc. }
  {/ 3D RNN data tensor in the format (batch, seq_length, input channels), }
  {/ an alias to #dnnl_bac. }
  {/ 4D RNN states tensor in the format (num_layers, num_directions, }
  {/ batch, state channels), an alias to #dnnl_abcd. }
  {/ 5D RNN weights tensor in the format (num_layers, num_directions, }
  {/ input_channels, num_gates, output_channels), an alias to #dnnl_abcde. }
  {/ }
  {/  - For LSTM cells, the gates order is input, forget, candidate }
  {/    and output gate. }
  {/  - For GRU cells, the gates order is update, reset and output gate. }
  {/ 5D RNN weights tensor in the format (num_layers, num_directions, }
  {/ num_gates, output_channels, input_channels), an alias to #dnnl_abdec. }
  {/ }
  {/  - For LSTM cells, the gates order is input, forget, candidate }
  {/    and output gate. }
  {/  - For GRU cells, the gates order is update, reset and output gate. }
  {/ 4D LSTM projection tensor in the format (num_layers, num_directions, }
  {/ num_channels_in_hidden_state, num_channels_in_recurrent_projection), }
  {/ an alias to #dnnl_abcd. }
  {/ 4D LSTM projection tensor in the format (num_layers, num_directions, }
  {/ num_channels_in_recurrent_projection, num_channels_in_hidden_state), }
  {/ an alias to #dnnl_abdc. }
  {/ 4D RNN bias tensor in the format (num_layers, num_directions, }
  {/ num_gates, output_channels), an alias to #dnnl_abcd. }
  {/ }
  {/  - For LSTM cells, the gates order is input, forget, candidate }
  {/    and output gate. }
  {/  - For GRU cells, the gates order is update, reset and output gate. }
  {/ 5D LSTM projection tensor }
  {/ 6D RNN weights tensor }
  { Opaque data types, are not to be used explicitly }
  { data }
  {/ 5D CNN activations tensor blocked by channels with block size 32, }
  {/ an alias to #dnnl_aBcde32b }
  {/ 5D CNN activations tensor blocked by channels with block size 16, }
  {/ an alias to #dnnl_aBcde16b }
  {/ 5D CNN activations tensor blocked by channels with block size 4, }
  {/ an alias to #dnnl_aBcde4b }
  {/ 5D CNN activations tensor blocked by channels with block size 8, }
  {/ an alias to #dnnl_aBcde8b }
  {/ 4D CNN activations tensor blocked by channels with block size 32, }
  {/ an alias to #dnnl_aBcd32b }
  {/ 4D CNN activations tensor blocked by channels with block size 16, }
  {/ an alias to #dnnl_aBcd16b }
  {/ 4D CNN activations tensor blocked by channels with block size 4, }
  {/ an alias to #dnnl_aBcd4b }
  {/ 4D CNN activations tensor blocked by channels with block size 8, }
  {/ an alias to #dnnl_aBcd8b }
  {/ 3D CNN activations tensor blocked by channels with block size 32, }
  {/ an alias to #dnnl_aBc32b }
  {/ 3D CNN activations tensor blocked by channels with block size 16, }
  {/ an alias to #dnnl_aBc16b }
  {/ 3D CNN activations tensor blocked by channels with block size 4, }
  {/ an alias to #dnnl_aBc4b }
  {/ 3D CNN activations tensor blocked by channels with block size 8, }
  {/ an alias to #dnnl_aBc8b }
  { weights, 2D }
  { weights, 3D }
  { weights, 4D }
  { weights, 5D }
  { weights w/ groups, 3D }
  { weights w/ groups, 4D }
  { weights w/ groups, 6D }
  { weights, 3D }
  { weights, 4D }
  { weights, 5D }

      dnnl_format_tag_t = (dnnl_format_tag_undef := 0,dnnl_format_tag_any,
      dnnl_a,dnnl_ab,dnnl_abc,dnnl_abcd,dnnl_acbd,
      dnnl_abcde,dnnl_abcdef,dnnl_abcdefg,dnnl_abcdefgh,
      dnnl_abcdefghi,dnnl_abcdefghij,dnnl_abcdefghijk,
      dnnl_abcdefghijkl,dnnl_abdc,dnnl_abdec,
      dnnl_acb,dnnl_acbde,dnnl_acbdef,dnnl_acdb,
      dnnl_acdeb,dnnl_ba,dnnl_bac,dnnl_bacd,dnnl_bacde,
      dnnl_bca,dnnl_bcda,dnnl_bcdea,dnnl_cba,
      dnnl_cdba,dnnl_dcab,dnnl_cdeba,dnnl_decab,
      dnnl_defcab,dnnl_abced,dnnl_abcdfe,dnnl_abcdegf,
      dnnl_abcdefhg,dnnl_abcdefgih,dnnl_abcdefghji,
      dnnl_abcdefghikj,dnnl_abcdefghijlk,dnnl_Abc16a,
      dnnl_ABc16a16b,dnnl_ABc32a32b,dnnl_ABc4a4b,
      dnnl_aBc16b,dnnl_ABc16b16a,dnnl_Abc4a,
      dnnl_aBc32b,dnnl_aBc4b,dnnl_ABc4b16a4b,
      dnnl_ABc2b8a4b,dnnl_ABc16b16a4b,dnnl_ABc16b16a2b,
      dnnl_ABc4b4a,dnnl_ABc8a16b2a,dnnl_ABc8a8b,
      dnnl_ABc8a4b,dnnl_aBc8b,dnnl_ABc8b16a2b,
      dnnl_BAc8a16b2a,dnnl_ABc8b8a,dnnl_Abcd16a,
      dnnl_Abcd8a,dnnl_ABcd16a16b,dnnl_Abcd32a,
      dnnl_ABcd32a32b,dnnl_aBcd16b,dnnl_ABcd16b16a,
      dnnl_aBCd16b16c,dnnl_aBCd16c16b,dnnl_Abcd4a,
      dnnl_aBcd32b,dnnl_aBcd4b,dnnl_ABcd4b16a4b,
      dnnl_ABcd16b16a4b,dnnl_ABcd16b16a2b,dnnl_ABcd4b4a,
      dnnl_ABcd4a4b,dnnl_aBCd2c4b2c,dnnl_aBCd4b8c2b,
      dnnl_aBCd4c16b4c,dnnl_aBCd2c8b4c,dnnl_aBCd16c16b4c,
      dnnl_aBCd16c16b2c,dnnl_aBCd4c4b,dnnl_aBCd4b4c,
      dnnl_ABcd8a16b2a,dnnl_ABcd2b8a4b,dnnl_ABcd8a8b,
      dnnl_ABcd8a4b,dnnl_aBcd8b,dnnl_aBCd4c8b2c,
      dnnl_ABcd8b16a2b,dnnl_aBCd8b16c2b,dnnl_BAcd8a16b2a,
      dnnl_ABcd8b8a,dnnl_aBCd8b8c,dnnl_aBCd8b4c,
      dnnl_aBCd8c16b2c,dnnl_ABcde8a16b2a,dnnl_aCBd8b16c2b,
      dnnl_aBCd8c8b,dnnl_Abcde16a,dnnl_Abcde32a,
      dnnl_ABcde16a16b,dnnl_BAcde8a16b2a,dnnl_aBCd2b4c2b,
      dnnl_ABcde4b16a4b,dnnl_ABcde2b8a4b,dnnl_aBcde16b,
      dnnl_ABcde16b16a,dnnl_aBCde16b16c,dnnl_aBCde16c16b,
      dnnl_aBCde2c8b4c,dnnl_Abcde4a,dnnl_aBcde32b,
      dnnl_aBcde4b,dnnl_ABcde4b4a,dnnl_ABcde4a4b,
      dnnl_aBCde4b4c,dnnl_aBCde2c4b2c,dnnl_aBCde4b8c2b,
      dnnl_aBCde4c16b4c,dnnl_aBCde16c16b4c,
      dnnl_aBCde16c16b2c,dnnl_aBCde4c4b,dnnl_Abcde8a,
      dnnl_ABcde8a8b,dnnl_ABcde8a4b,dnnl_BAcde16b16a,
      dnnl_aBcde8b,dnnl_ABcde8b16a2b,dnnl_aBCde8b16c2b,
      dnnl_aBCde4c8b2c,dnnl_aCBde8b16c2b,dnnl_ABcde8b8a,
      dnnl_ABcde32a32b,dnnl_aBCde8b8c,dnnl_aBCde8b4c,
      dnnl_ABc4a8b8a4b,dnnl_ABcd4a8b8a4b,dnnl_ABcde4a8b8a4b,
      dnnl_BAc4b8a8b4a,dnnl_BAcd4b8a8b4a,dnnl_BAcde4b8a8b4a,
      dnnl_ABcd2a8b8a2b,dnnl_aBCd4b8c8b4c,dnnl_aBCde4b8c8b4c,
      dnnl_aBCde2b8c8b2c,dnnl_aBCde8c16b2c,
      dnnl_aBCde8c8b,dnnl_aBCde2b4c2b,dnnl_aBcdef16b,
      dnnl_aBCdef16b16c,dnnl_aBCdef16c16b,dnnl_aBCdef4c16b4c,
      dnnl_aBCdef2c8b4c,dnnl_aBCdef4c8b2c,dnnl_aBCdef2b4c2b,
      dnnl_aBcdef4b,dnnl_aBCdef4c4b,dnnl_aBCdef4b4c,
      dnnl_aBCdef2c4b2c,dnnl_aBCdef4b8c2b,dnnl_aBCdef8b8c,
      dnnl_aBCdef8b4c,dnnl_aBCdef8c16b2c,dnnl_aBCdef4b8c8b4c,
      dnnl_aBCdef8b16c2b,dnnl_aCBdef8b16c2b,
      dnnl_aBCdef8c8b,dnnl_aBdc16b,dnnl_aBdC16b2c,
      dnnl_aBdC16b4c,dnnl_aBdc4b,dnnl_aBdc8b,
      dnnl_aBdec16b,dnnl_aBdeC16b2c,dnnl_aBdeC16b4c,
      dnnl_aBdec32b,dnnl_aBdec4b,dnnl_aBdec8b,
      dnnl_aBdefc16b,dnnl_aBdefC16b2c,dnnl_aCBdef16c16b,
      dnnl_aBdefc4b,dnnl_aBdefc8b,dnnl_Abcdef16a,
      dnnl_Abcdef32a,dnnl_aBedc16b,dnnl_Acb16a,
      dnnl_AcB16a2b,dnnl_AcB16a4b,dnnl_Acb4a,
      dnnl_Acb8a,dnnl_aCBd16b16c,dnnl_aCBd16c16b,
      dnnl_aCBde16b16c,dnnl_aCBde16c16b,dnnl_Acdb16a,
      dnnl_AcdB16a2b,dnnl_AcdB16a4b,dnnl_Acdb32a,
      dnnl_Acdb4a,dnnl_Acdb8a,dnnl_Acdeb16a,
      dnnl_AcdeB16a2b,dnnl_Acdeb4a,dnnl_Acdeb8a,
      dnnl_Adcb16a,dnnl_BAc16a16b,dnnl_BAc16b16a,
      dnnl_BAcd16a16b,dnnl_BAcd16b16a,dnnl_aCBd4c8b8c4b,
      dnnl_aCBde4c8b8c4b,dnnl_aCBdef4c8b8c4b,
      dnnl_BAcde16a16b,dnnl_aCBdef16b16c,dnnl_abdfce,
      dnnl_abdefc,dnnl_ABc16b32a,dnnl_ABc16b64a,
      dnnl_ABc4b32a4b,dnnl_ABc4b64a4b,dnnl_ABc8b32a2b,
      dnnl_ABc8b64a2b,dnnl_AB16b16a,dnnl_AB16b32a,
      dnnl_AB16b64a,dnnl_AB8b16a2b,dnnl_AB8b32a2b,
      dnnl_AB8b64a2b,dnnl_AB4b16a4b,dnnl_AB4b32a4b,
      dnnl_AB4b64a4b,dnnl_AB16b16a4b,dnnl_ABcd16b32a,
      dnnl_ABcd16b64a,dnnl_ABcd4b32a4b,dnnl_ABcd4b64a4b,
      dnnl_ABcd8b32a2b,dnnl_ABcd8b64a2b,dnnl_ABcde4b32a4b,
      dnnl_ABcde4b64a4b,dnnl_ABcde16b16a4b,
      dnnl_ABcde16b16a2b,dnnl_ABcde16b32a,dnnl_ABcde16b64a,
      dnnl_ABcde8b32a2b,dnnl_ABcde8b64a2b,dnnl_aBCdef16c16b4c,
      dnnl_aBCdef16c16b2c,dnnl_AB32a32b8a4b,
      dnnl_AB8a4b,dnnl_AB32a32b8a2b,dnnl_AB8a2b,
      dnnl_abDc32d,dnnl_abDC32d4c,dnnl_abdEc32e,
      dnnl_abdEC32e2c,dnnl_abdEC32e4c,dnnl_aBdefC16b4c,
      dnnl_AcdeB16a4b,dnnl_ABcd16a16b2a,dnnl_ABc16a16b2a,
      dnnl_aBCd16b16c2b,dnnl_aBCde16b16c2b,
      dnnl_Acb32a,dnnl_AcB32a2b,dnnl_AcB32a4b,
      dnnl_Acb48a,dnnl_AcB48a2b,dnnl_AcB48a4b,
      dnnl_Acb64a,dnnl_AcB64a2b,dnnl_AcB64a4b,
      dnnl_cBa2b,dnnl_cBa4b,dnnl_aBdc32b,dnnl_aBdC32b2c,
      dnnl_aBdC32b4c,dnnl_aBdc48b,dnnl_aBdC48b2c,
      dnnl_aBdC48b4c,dnnl_aBdc64b,dnnl_aBdC64b2c,
      dnnl_aBdC64b4c,dnnl_adcb,dnnl_adCb2c,dnnl_adCb4c,
      dnnl_AcdB32a2b,dnnl_AcdB32a4b,dnnl_Acdb48a,
      dnnl_AcdB48a2b,dnnl_AcdB48a4b,dnnl_Acdb64a,
      dnnl_AcdB64a2b,dnnl_AcdB64a4b,dnnl_cdBa2b,
      dnnl_cdBa4b,dnnl_aBdeC32b2c,dnnl_aBdeC32b4c,
      dnnl_aBdec48b,dnnl_aBdeC48b2c,dnnl_aBdeC48b4c,
      dnnl_aBdec64b,dnnl_aBdeC64b2c,dnnl_aBdeC64b4c,
      dnnl_adecb,dnnl_adeCb2c,dnnl_adeCb4c,dnnl_Acdeb32a,
      dnnl_AcdeB32a2b,dnnl_AcdeB32a4b,dnnl_Acdeb48a,
      dnnl_AcdeB48a2b,dnnl_AcdeB48a4b,dnnl_Acdeb64a,
      dnnl_AcdeB64a2b,dnnl_AcdeB64a4b,dnnl_cdeBa2b,
      dnnl_cdeBa4b,dnnl_aBdefc32b,dnnl_aBdefC32b2c,
      dnnl_aBdefC32b4c,dnnl_aBdefc48b,dnnl_aBdefC48b2c,
      dnnl_aBdefC48b4c,dnnl_aBdefc64b,dnnl_aBdefC64b2c,
      dnnl_aBdefC64b4c,dnnl_adefcb,dnnl_adefCb2c,
      dnnl_adefCb4c,dnnl_AB16b32a4b,dnnl_AB16b48a4b,
      dnnl_AB16b64a4b,dnnl_AB16b16a2b,dnnl_AB16b32a2b,
      dnnl_AB16b48a2b,dnnl_AB16b64a2b,dnnl_ABc16b32a4b,
      dnnl_ABc16b48a4b,dnnl_ABc16b64a4b,dnnl_ABc16b32a2b,
      dnnl_ABc16b48a2b,dnnl_ABc16b64a2b,dnnl_ABcd16b32a4b,
      dnnl_ABcd16b48a4b,dnnl_ABcd16b64a4b,dnnl_ABcd16b32a2b,
      dnnl_ABcd16b48a2b,dnnl_ABcd16b64a2b,dnnl_ABcde16b32a4b,
      dnnl_ABcde16b48a4b,dnnl_ABcde16b64a4b,
      dnnl_ABcde16b32a2b,dnnl_ABcde16b48a2b,
      dnnl_ABcde16b64a2b,dnnl_ABc32a16b,dnnl_ABcd32a16b,
      dnnl_ABcde32a16b,dnnl_AB48a16b,dnnl_AB48a32b,
      dnnl_ABc40a16b,dnnl_ABc40a32b,dnnl_aBC48b16c,
      dnnl_aBC48b32c,dnnl_ABcd40a16b,dnnl_ABcd40a32b,
      dnnl_abCd32c,dnnl_abdCe32c,dnnl_abdCE32c2e,
      dnnl_BA16a16b2a,dnnl_BA16a32b2a,dnnl_BA16a48b2a,
      dnnl_BA16a64b2a,dnnl_BA16a16b4a,dnnl_BA16a32b4a,
      dnnl_BA16a48b4a,dnnl_BA16a64b4a,dnnl_ABcd8a2b,
      dnnl_aBdeC16c16b2c,dnnl_aBdeC16c16b4c,
      dnnl_aBdefC16c16b2c,dnnl_AcB16b16a2b,
      dnnl_AcB16b16a4b,dnnl_AcdB16b16a2b,dnnl_AcdB16b16a4b,
      dnnl_AcdeB16b16a2b,dnnl_aBdefC16c16b4c,
      dnnl_AcdeB16b16a4b,dnnl_AcB16b32a2b,dnnl_AcB16b32a4b,
      dnnl_AcB16b48a2b,dnnl_AcB16b48a4b,dnnl_AcB16b64a2b,
      dnnl_AcB16b64a4b,dnnl_aBdC16c16b2c,dnnl_aBdC16c16b4c,
      dnnl_aBdC16c32b2c,dnnl_aBdC16c32b4c,dnnl_aBdC16c48b2c,
      dnnl_aBdC16c48b4c,dnnl_aBdC16c64b2c,dnnl_aBdC16c64b4c,
      dnnl_AcdB16b32a2b,dnnl_AcdB16b32a4b,dnnl_AcdB16b48a2b,
      dnnl_AcdB16b48a4b,dnnl_AcdB16b64a2b,dnnl_AcdB16b64a4b,
      dnnl_aBdeC16c32b2c,dnnl_aBdeC16c32b4c,
      dnnl_aBdeC16c48b2c,dnnl_aBdeC16c48b4c,
      dnnl_aBdeC16c64b2c,dnnl_aBdeC16c64b4c,
      dnnl_AcdeB16b32a2b,dnnl_AcdeB16b32a4b,
      dnnl_AcdeB16b48a2b,dnnl_AcdeB16b48a4b,
      dnnl_AcdeB16b64a2b,dnnl_AcdeB16b64a4b,
      dnnl_aBdefC16c32b2c,dnnl_aBdefC16c32b4c,
      dnnl_aBdefC16c48b2c,dnnl_aBdefC16c48b4c,
      dnnl_aBdefC16c64b2c,dnnl_aBdefC16c64b4c,
      dnnl_decbA16a,dnnl_ABc4a2b,dnnl_ABc8a2b,
      dnnl_aBCd8b2c,dnnl_ABcde4a2b,dnnl_ABcde8a2b,
      dnnl_ABcde40a16b,dnnl_ABcde40a32b,dnnl_aBCde8b2c,
      dnnl_ABcde4a8b8a2b,dnnl_ABcd4a8b8a2b,
      dnnl_ABc4a8b8a2b,dnnl_aBCdef4b8c8b2c,
      dnnl_aBCde4b8c8b2c,dnnl_aBCd4b8c8b2c,
      dnnl_BAcde4b8a8b2a,dnnl_BAcd4b8a8b2a,
      dnnl_BAc4b8a8b2a,dnnl_aCBdef4c8b8c2b,
      dnnl_aCBde4c8b8c2b,dnnl_aCBd4c8b8c2b,
      dnnl_aBCdef8b2c,dnnl_AB32a16b,dnnl_AB32a32b,
      dnnl_BA4b8a8b2a,dnnl_BA4b8a8b4a,dnnl_aBC32b16c,
      dnnl_aBC32b32c,dnnl_aCB4c8b8c2b,dnnl_aCB4c8b8c4b,
      dnnl_ABcd4a2b,dnnl_ABc2b8a16b4a,dnnl_ABcd2b8a16b4a,
      dnnl_ABcde2b8a16b4a,dnnl_ABc2a8b16a4b,
      dnnl_ABc2a8b16a2b,dnnl_ABc2b32a8b,dnnl_ABcd2a8b16a4b,
      dnnl_ABcd2a8b16a2b,dnnl_aCBd2c8b16c2b,
      dnnl_ABcd2b32a8b,dnnl_aBCd2c8b16c2b,dnnl_ABcde2a8b16a4b,
      dnnl_ABcde2a8b16a2b,dnnl_aCBde2c8b16c2b,
      dnnl_ABcde2b32a8b,dnnl_aBC2b8c16b2c,dnnl_aBCd2b8c16b2c,
      dnnl_aBCde2b8c16b2c,dnnl_aBCdef2b8c16b2c,
      dnnl_BAcde2b8a16b4a,dnnl_BAcd2b8a16b4a,
      dnnl_BAc2b8a16b4a,dnnl_BAcde2b8a16b2a,
      dnnl_BAcd2b8a16b2a,dnnl_BAc2b8a16b2a,
      dnnl_aBCde2c8b16c2b,dnnl_aBCdef2c8b16c2b,
      dnnl_aCBdef2c8b16c2b,dnnl_aBCd2b8c16b4c,
      dnnl_aBCde2b8c16b4c,dnnl_BA4b8a16b2a,
      dnnl_BA4b8a16b4a,dnnl_aCB4c8b16c2b,dnnl_aCB4c8b16c4b,
      dnnl_BA16a16b,dnnl_BA16a32b,dnnl_BA16a48b,
      dnnl_BA16a64b,dnnl_format_tag_last,dnnl_x := dnnl_a,
      dnnl_nc := dnnl_ab,dnnl_cn := dnnl_ba,dnnl_tn := dnnl_ab,
      dnnl_nt := dnnl_ba,dnnl_ncw := dnnl_abc,dnnl_nwc := dnnl_acb,
      dnnl_nchw := dnnl_abcd,dnnl_nhwc := dnnl_acdb,dnnl_chwn := dnnl_bcda,
      dnnl_ncdhw := dnnl_abcde,dnnl_ndhwc := dnnl_acdeb,dnnl_oi := dnnl_ab,
      dnnl_io := dnnl_ba,dnnl_oiw := dnnl_abc,dnnl_owi := dnnl_acb,
      dnnl_wio := dnnl_cba,dnnl_iwo := dnnl_bca,dnnl_oihw := dnnl_abcd,
      dnnl_hwio := dnnl_cdba,dnnl_ohwi := dnnl_acdb,dnnl_ihwo := dnnl_bcda,
      dnnl_iohw := dnnl_bacd,dnnl_oidhw := dnnl_abcde,dnnl_iodhw := dnnl_bacde,
      dnnl_dhwio := dnnl_cdeba,dnnl_odhwi := dnnl_acdeb,dnnl_idhwo := dnnl_bcdea,
      dnnl_goiw := dnnl_abcd,dnnl_gowi := dnnl_abdc,dnnl_wigo := dnnl_dcab,
      dnnl_goihw := dnnl_abcde,dnnl_gohwi := dnnl_abdec,dnnl_hwigo := dnnl_decab,
      dnnl_giohw := dnnl_acbde,dnnl_goidhw := dnnl_abcdef,dnnl_godhwi := dnnl_abdefc,
      dnnl_giodhw := dnnl_acbdef,dnnl_dhwigo := dnnl_defcab,dnnl_tnc := dnnl_abc,
      dnnl_ntc := dnnl_bac,dnnl_ldnc := dnnl_abcd,dnnl_ldigo := dnnl_abcde,
      dnnl_ldgoi := dnnl_abdec,dnnl_ldio := dnnl_abcd,dnnl_ldoi := dnnl_abdc,
      dnnl_ldgo := dnnl_abcd,dnnl_ldOi32o := dnnl_abDc32d,dnnl_ldOI32o4i := dnnl_abDC32d4c,
      dnnl_ldIo32i := dnnl_abCd32c,dnnl_ldgOi32o := dnnl_abdEc32e,
      dnnl_ldgOI32o2i := dnnl_abdEC32e2c,dnnl_ldgOI32o4i := dnnl_abdEC32e4c,
      dnnl_ldgIo32i := dnnl_abdCe32c,dnnl_ldgIO32i2o := dnnl_abdCE32c2e,
      dnnl_nCdhw32c := dnnl_aBcde32b,dnnl_nCdhw16c := dnnl_aBcde16b,
      dnnl_nCdhw4c := dnnl_aBcde4b,dnnl_nCdhw8c := dnnl_aBcde8b,
      dnnl_nChw32c := dnnl_aBcd32b,dnnl_nChw16c := dnnl_aBcd16b,
      dnnl_nChw4c := dnnl_aBcd4b,dnnl_nChw8c := dnnl_aBcd8b,dnnl_nCw32c := dnnl_aBc32b,
      dnnl_nCw16c := dnnl_aBc16b,dnnl_nCw4c := dnnl_aBc4b,dnnl_nCw8c := dnnl_aBc8b,
      dnnl_NCw16n16c := dnnl_ABc16a16b,dnnl_NCdhw16n16c := dnnl_ABcde16a16b,
      dnnl_NChw16n16c := dnnl_ABcd16a16b,dnnl_NCw32n16c := dnnl_ABc32a16b,
      dnnl_NChw32n16c := dnnl_ABcd32a16b,dnnl_NCdhw32n16c := dnnl_ABcde32a16b,
      dnnl_NCw32n32c := dnnl_ABc32a32b,dnnl_NChw32n32c := dnnl_ABcd32a32b,
      dnnl_NCdhw32n32c := dnnl_ABcde32a32b,dnnl_OI16i16o := dnnl_AB16b16a,
      dnnl_OI16i32o := dnnl_AB16b32a,dnnl_OI16i64o := dnnl_AB16b64a,
      dnnl_OI8i16o2i := dnnl_AB8b16a2b,dnnl_OI8i32o2i := dnnl_AB8b32a2b,
      dnnl_OI8i64o2i := dnnl_AB8b64a2b,dnnl_OI4i16o4i := dnnl_AB4b16a4b,
      dnnl_OI4i32o4i := dnnl_AB4b32a4b,dnnl_OI4i64o4i := dnnl_AB4b64a4b,
      dnnl_OI16i16o4i := dnnl_AB16b16a4b,dnnl_IOw16o16i := dnnl_BAc16a16b,
      dnnl_IOw16i16o := dnnl_BAc16b16a,dnnl_OIw16i16o := dnnl_ABc16b16a,
      dnnl_OIw16i32o := dnnl_ABc16b32a,dnnl_OIw16i64o := dnnl_ABc16b64a,
      dnnl_OIw16o16i := dnnl_ABc16a16b,dnnl_Oiw16o := dnnl_Abc16a,
      dnnl_OIw4i16o4i := dnnl_ABc4b16a4b,dnnl_OIw4i32o4i := dnnl_ABc4b32a4b,
      dnnl_OIw4i64o4i := dnnl_ABc4b64a4b,dnnl_OIw2i8o4i := dnnl_ABc2b8a4b,
      dnnl_OIw16i16o4i := dnnl_ABc16b16a4b,dnnl_OIw16i16o2i := dnnl_ABc16b16a2b,
      dnnl_OIw16o16i2o := dnnl_ABc16a16b2a,dnnl_OIw4i4o := dnnl_ABc4b4a,
      dnnl_OIw4o4i := dnnl_ABc4a4b,dnnl_Oiw4o := dnnl_Abc4a,dnnl_OIw8i16o2i := dnnl_ABc8b16a2b,
      dnnl_OIw8i32o2i := dnnl_ABc8b32a2b,dnnl_OIw8i64o2i := dnnl_ABc8b64a2b,
      dnnl_OIw8i8o := dnnl_ABc8b8a,dnnl_OIw8o16i2o := dnnl_ABc8a16b2a,
      dnnl_IOw8o16i2o := dnnl_BAc8a16b2a,dnnl_OIw8o8i := dnnl_ABc8a8b,
      dnnl_OIw8o4i := dnnl_ABc8a4b,dnnl_Owi16o := dnnl_Acb16a,
      dnnl_OwI16o2i := dnnl_AcB16a2b,dnnl_OwI16o4i := dnnl_AcB16a4b,
      dnnl_Owi4o := dnnl_Acb4a,dnnl_Owi8o := dnnl_Acb8a,dnnl_IOhw16i16o := dnnl_BAcd16b16a,
      dnnl_IOhw16o16i := dnnl_BAcd16a16b,dnnl_Ohwi16o := dnnl_Acdb16a,
      dnnl_OhwI16o2i := dnnl_AcdB16a2b,dnnl_OhwI16o4i := dnnl_AcdB16a4b,
      dnnl_Ohwi32o := dnnl_Acdb32a,dnnl_Ohwi4o := dnnl_Acdb4a,
      dnnl_Ohwi8o := dnnl_Acdb8a,dnnl_OIhw16i16o := dnnl_ABcd16b16a,
      dnnl_OIhw16i32o := dnnl_ABcd16b32a,dnnl_OIhw16i64o := dnnl_ABcd16b64a,
      dnnl_OIhw16o16i := dnnl_ABcd16a16b,dnnl_Oihw16o := dnnl_Abcd16a,
      dnnl_OIhw4i16o4i := dnnl_ABcd4b16a4b,dnnl_OIhw4i32o4i := dnnl_ABcd4b32a4b,
      dnnl_OIhw4i64o4i := dnnl_ABcd4b64a4b,dnnl_OIhw16i16o4i := dnnl_ABcd16b16a4b,
      dnnl_OIhw16i16o2i := dnnl_ABcd16b16a2b,dnnl_OIhw16o16i2o := dnnl_ABcd16a16b2a,
      dnnl_OIhw4i4o := dnnl_ABcd4b4a,dnnl_OIhw4o4i := dnnl_ABcd4a4b,
      dnnl_Oihw4o := dnnl_Abcd4a,dnnl_OIhw8i16o2i := dnnl_ABcd8b16a2b,
      dnnl_OIhw8i32o2i := dnnl_ABcd8b32a2b,dnnl_OIhw8i64o2i := dnnl_ABcd8b64a2b,
      dnnl_OIhw8i8o := dnnl_ABcd8b8a,dnnl_OIhw8o16i2o := dnnl_ABcd8a16b2a,
      dnnl_OIhw2i8o4i := dnnl_ABcd2b8a4b,dnnl_IOhw8o16i2o := dnnl_BAcd8a16b2a,
      dnnl_OIhw8o8i := dnnl_ABcd8a8b,dnnl_OIhw8o4i := dnnl_ABcd8a4b,
      dnnl_Owhi16o := dnnl_Adcb16a,dnnl_Odhwi16o := dnnl_Acdeb16a,
      dnnl_OdhwI16o2i := dnnl_AcdeB16a2b,dnnl_OdhwI16o4i := dnnl_AcdeB16a4b,
      dnnl_Odhwi4o := dnnl_Acdeb4a,dnnl_Odhwi8o := dnnl_Acdeb8a,
      dnnl_OIdhw16i16o := dnnl_ABcde16b16a,dnnl_OIdhw16i32o := dnnl_ABcde16b32a,
      dnnl_OIdhw16i64o := dnnl_ABcde16b64a,dnnl_OIdhw16o16i := dnnl_ABcde16a16b,
      dnnl_Oidhw16o := dnnl_Abcde16a,dnnl_OIdhw4i4o := dnnl_ABcde4b4a,
      dnnl_OIdhw4o4i := dnnl_ABcde4a4b,dnnl_Oidhw4o := dnnl_Abcde4a,
      dnnl_OIdhw8i16o2i := dnnl_ABcde8b16a2b,dnnl_OIdhw8i32o2i := dnnl_ABcde8b32a2b,
      dnnl_OIdhw8i64o2i := dnnl_ABcde8b64a2b,dnnl_OIdhw8i8o := dnnl_ABcde8b8a,
      dnnl_OIdhw8o16i2o := dnnl_ABcde8a16b2a,dnnl_IOdhw8o16i2o := dnnl_BAcde8a16b2a,
      dnnl_OIdhw4i16o4i := dnnl_ABcde4b16a4b,dnnl_OIdhw4i32o4i := dnnl_ABcde4b32a4b,
      dnnl_OIdhw4i64o4i := dnnl_ABcde4b64a4b,dnnl_OIdhw16i16o4i := dnnl_ABcde16b16a4b,
      dnnl_OIdhw16i16o2i := dnnl_ABcde16b16a2b,dnnl_OIdhw2i8o4i := dnnl_ABcde2b8a4b,
      dnnl_OIdhw8o8i := dnnl_ABcde8a8b,dnnl_OIdhw8o4i := dnnl_ABcde8a4b,
      dnnl_IOdhw16i16o := dnnl_BAcde16b16a,dnnl_OIdhw4o8i8o4i := dnnl_ABcde4a8b8a4b,
      dnnl_IOdhw16o16i := dnnl_BAcde16a16b,dnnl_Goiw16g := dnnl_Abcd16a,
      dnnl_Goiw8g := dnnl_Abcd8a,dnnl_Goiw4g := dnnl_Abcd4a,dnnl_gIOw16o16i := dnnl_aCBd16b16c,
      dnnl_gIOw16i16o := dnnl_aCBd16c16b,dnnl_gOIw16i16o := dnnl_aBCd16c16b,
      dnnl_gOIw16o16i := dnnl_aBCd16b16c,dnnl_gOiw16o := dnnl_aBcd16b,
      dnnl_gOIw4i16o4i := dnnl_aBCd4c16b4c,dnnl_gOIw2i8o4i := dnnl_aBCd2c8b4c,
      dnnl_gOIw16i16o4i := dnnl_aBCd16c16b4c,dnnl_gOIw16i16o2i := dnnl_aBCd16c16b2c,
      dnnl_gOIw16o16i2o := dnnl_aBCd16b16c2b,dnnl_gOIw4i4o := dnnl_aBCd4c4b,
      dnnl_gOIw4o4i := dnnl_aBCd4b4c,dnnl_gOiw4o := dnnl_aBcd4b,
      dnnl_gOIw8i16o2i := dnnl_aBCd8c16b2c,dnnl_gOIw8i8o := dnnl_aBCd8c8b,
      dnnl_gOIw8o16i2o := dnnl_aBCd8b16c2b,dnnl_gIOw8o16i2o := dnnl_aCBd8b16c2b,
      dnnl_gOIw8o8i := dnnl_aBCd8b8c,dnnl_gOIw8o4i := dnnl_aBCd8b4c,
      dnnl_gOwi16o := dnnl_aBdc16b,dnnl_gOwI16o2i := dnnl_aBdC16b2c,
      dnnl_gOwI16o4i := dnnl_aBdC16b4c,dnnl_gOwi4o := dnnl_aBdc4b,
      dnnl_gOwi8o := dnnl_aBdc8b,dnnl_Goiw32g := dnnl_Abcd32a,
      dnnl_gOIw2i4o2i := dnnl_aBCd2c4b2c,dnnl_gOIw2o4i2o := dnnl_aBCd2b4c2b,
      dnnl_gOIw4i8o2i := dnnl_aBCd4c8b2c,dnnl_gOIw4o8i2o := dnnl_aBCd4b8c2b,
      dnnl_gIOhw16i16o := dnnl_aCBde16c16b,dnnl_gIOhw16o16i := dnnl_aCBde16b16c,
      dnnl_gOhwi16o := dnnl_aBdec16b,dnnl_gOhwI16o2i := dnnl_aBdeC16b2c,
      dnnl_gOhwI16o4i := dnnl_aBdeC16b4c,dnnl_gOhwi32o := dnnl_aBdec32b,
      dnnl_gOhwi4o := dnnl_aBdec4b,dnnl_gOhwi8o := dnnl_aBdec8b,
      dnnl_Goihw16g := dnnl_Abcde16a,dnnl_gOIhw16i16o := dnnl_aBCde16c16b,
      dnnl_gOIhw16o16i := dnnl_aBCde16b16c,dnnl_gOihw16o := dnnl_aBcde16b,
      dnnl_gOIhw2i8o4i := dnnl_aBCde2c8b4c,dnnl_gOIhw4i16o4i := dnnl_aBCde4c16b4c,
      dnnl_gOIhw16i16o4i := dnnl_aBCde16c16b4c,dnnl_gOIhw16i16o2i := dnnl_aBCde16c16b2c,
      dnnl_gOIhw16o16i2o := dnnl_aBCde16b16c2b,dnnl_gOIhw4i4o := dnnl_aBCde4c4b,
      dnnl_gOIhw4o4i := dnnl_aBCde4b4c,dnnl_gOihw4o := dnnl_aBcde4b,
      dnnl_Goihw8g := dnnl_Abcde8a,dnnl_Goihw4g := dnnl_Abcde4a,
      dnnl_gOIhw8i16o2i := dnnl_aBCde8c16b2c,dnnl_gOIhw8i8o := dnnl_aBCde8c8b,
      dnnl_gOIhw8o16i2o := dnnl_aBCde8b16c2b,dnnl_gIOhw8o16i2o := dnnl_aCBde8b16c2b,
      dnnl_gOIhw8o8i := dnnl_aBCde8b8c,dnnl_gOIhw8o4i := dnnl_aBCde8b4c,
      dnnl_Goihw32g := dnnl_Abcde32a,dnnl_gOwhi16o := dnnl_aBedc16b,
      dnnl_OIw4o8i8o4i := dnnl_ABc4a8b8a4b,dnnl_OIhw4o8i8o4i := dnnl_ABcd4a8b8a4b,
      dnnl_IOw4i8o8i4o := dnnl_BAc4b8a8b4a,dnnl_IOhw4i8o8i4o := dnnl_BAcd4b8a8b4a,
      dnnl_IOdhw4i8o8i4o := dnnl_BAcde4b8a8b4a,dnnl_OIhw2o8i8o2i := dnnl_ABcd2a8b8a2b,
      dnnl_gOIw4o8i8o4i := dnnl_aBCd4b8c8b4c,dnnl_gOIhw4o8i8o4i := dnnl_aBCde4b8c8b4c,
      dnnl_gOIdhw4o8i8o4i := dnnl_aBCdef4b8c8b4c,dnnl_gIOw4i8o8i4o := dnnl_aCBd4c8b8c4b,
      dnnl_gIOhw4i8o8i4o := dnnl_aCBde4c8b8c4b,dnnl_gIOdhw4i8o8i4o := dnnl_aCBdef4c8b8c4b,
      dnnl_gOIhw2o8i8o2i := dnnl_aBCde2b8c8b2c,dnnl_gOIhw2i4o2i := dnnl_aBCde2c4b2c,
      dnnl_gOIhw2o4i2o := dnnl_aBCde2b4c2b,dnnl_gOIhw4i8o2i := dnnl_aBCde4c8b2c,
      dnnl_gOIhw4o8i2o := dnnl_aBCde4b8c2b,dnnl_gIOdhw16i16o := dnnl_aCBdef16c16b,
      dnnl_gIOdhw16o16i := dnnl_aCBdef16b16c,dnnl_gOdhwi16o := dnnl_aBdefc16b,
      dnnl_gOdhwI16o2i := dnnl_aBdefC16b2c,dnnl_gOdhwI16o4i := dnnl_aBdefC16b4c,
      dnnl_gOdhwi4o := dnnl_aBdefc4b,dnnl_gOdhwi8o := dnnl_aBdefc8b,
      dnnl_gOIdhw16i16o := dnnl_aBCdef16c16b,dnnl_gOIdhw4i16o4i := dnnl_aBCdef4c16b4c,
      dnnl_gOIdhw16i16o4i := dnnl_aBCdef16c16b4c,dnnl_gOIdhw2i8o4i := dnnl_aBCdef2c8b4c,
      dnnl_gOIdhw16i16o2i := dnnl_aBCdef16c16b2c,dnnl_gOIdhw16o16i := dnnl_aBCdef16b16c,
      dnnl_gOidhw16o := dnnl_aBcdef16b,dnnl_gOIdhw4i4o := dnnl_aBCdef4c4b,
      dnnl_gOIdhw4o4i := dnnl_aBCdef4b4c,dnnl_gOidhw4o := dnnl_aBcdef4b,
      dnnl_gOIdhw8i16o2i := dnnl_aBCdef8c16b2c,dnnl_gOIdhw8i8o := dnnl_aBCdef8c8b,
      dnnl_gOIdhw8o16i2o := dnnl_aBCdef8b16c2b,dnnl_gIOdhw8o16i2o := dnnl_aCBdef8b16c2b,
      dnnl_gOIdhw8o8i := dnnl_aBCdef8b8c,dnnl_gOIdhw8o4i := dnnl_aBCdef8b4c,
      dnnl_Goidhw16g := dnnl_Abcdef16a,dnnl_Goidhw32g := dnnl_Abcdef32a,
      dnnl_gOIdhw2i4o2i := dnnl_aBCdef2c4b2c,dnnl_gOIdhw4i8o2i := dnnl_aBCdef4c8b2c,
      dnnl_gOIdhw2o4i2o := dnnl_aBCdef2b4c2b,dnnl_gOIdhw4o8i2o := dnnl_aBCdef4b8c2b,
      dnnl_Owi32o := dnnl_Acb32a,dnnl_OwI32o2i := dnnl_AcB32a2b,
      dnnl_OwI32o4i := dnnl_AcB32a4b,dnnl_Owi48o := dnnl_Acb48a,
      dnnl_OwI48o2i := dnnl_AcB48a2b,dnnl_OwI48o4i := dnnl_AcB48a4b,
      dnnl_Owi64o := dnnl_Acb64a,dnnl_OwI64o2i := dnnl_AcB64a2b,
      dnnl_OwI64o4i := dnnl_AcB64a4b,dnnl_wIo2i := dnnl_cBa2b,
      dnnl_wIo4i := dnnl_cBa4b,dnnl_gOwi32o := dnnl_aBdc32b,dnnl_gOwI32o2i := dnnl_aBdC32b2c,
      dnnl_gOwI32o4i := dnnl_aBdC32b4c,dnnl_gOwi48o := dnnl_aBdc48b,
      dnnl_gOwI48o2i := dnnl_aBdC48b2c,dnnl_gOwI48o4i := dnnl_aBdC48b4c,
      dnnl_gOwi64o := dnnl_aBdc64b,dnnl_gOwI64o2i := dnnl_aBdC64b2c,
      dnnl_gOwI64o4i := dnnl_aBdC64b4c,dnnl_gwio := dnnl_adcb,
      dnnl_gwIo2i := dnnl_adCb2c,dnnl_gwIo4i := dnnl_adCb4c,dnnl_OhwI32o_ := dnnl_Acdb32a,
      dnnl_OhwI32o2i := dnnl_AcdB32a2b,dnnl_OhwI32o4i := dnnl_AcdB32a4b,
      dnnl_Ohwi48o := dnnl_Acdb48a,dnnl_OhwI48o2i := dnnl_AcdB48a2b,
      dnnl_OhwI48o4i := dnnl_AcdB48a4b,dnnl_Ohwi64o := dnnl_Acdb64a,
      dnnl_OhwI64o2i := dnnl_AcdB64a2b,dnnl_OhwI64o4i := dnnl_AcdB64a4b,
      dnnl_hwIo2i := dnnl_cdBa2b,dnnl_hwIo4i := dnnl_cdBa4b,dnnl_gOhwI32o_ := dnnl_aBdec32b,
      dnnl_gOhwI32o2i := dnnl_aBdeC32b2c,dnnl_gOhwI32o4i := dnnl_aBdeC32b4c,
      dnnl_gOhwi48o := dnnl_aBdec48b,dnnl_gOhwI48o2i := dnnl_aBdeC48b2c,
      dnnl_gOhwI48o4i := dnnl_aBdeC48b4c,dnnl_gOhwi64o := dnnl_aBdec64b,
      dnnl_gOhwI64o2i := dnnl_aBdeC64b2c,dnnl_gOhwI64o4i := dnnl_aBdeC64b4c,
      dnnl_ghwio := dnnl_adecb,dnnl_ghwIo2i := dnnl_adeCb2c,dnnl_ghwIo4i := dnnl_adeCb4c,
      dnnl_Odhwi32o := dnnl_Acdeb32a,dnnl_OdhwI32o2i := dnnl_AcdeB32a2b,
      dnnl_OdhwI32o4i := dnnl_AcdeB32a4b,dnnl_Odhwi48o := dnnl_Acdeb48a,
      dnnl_OdhwI48o2i := dnnl_AcdeB48a2b,dnnl_OdhwI48o4i := dnnl_AcdeB48a4b,
      dnnl_Odhwi64o := dnnl_Acdeb64a,dnnl_OdhwI64o2i := dnnl_AcdeB64a2b,
      dnnl_OdhwI64o4i := dnnl_AcdeB64a4b,dnnl_dhwIo2i := dnnl_cdeBa2b,
      dnnl_dhwIo4i := dnnl_cdeBa4b,dnnl_gOdhwi32o := dnnl_aBdefc32b,
      dnnl_gOdhwI32o2i := dnnl_aBdefC32b2c,dnnl_gOdhwI32o4i := dnnl_aBdefC32b4c,
      dnnl_gOdhwi48o := dnnl_aBdefc48b,dnnl_gOdhwI48o2i := dnnl_aBdefC48b2c,
      dnnl_gOdhwI48o4i := dnnl_aBdefC48b4c,dnnl_gOdhwi64o := dnnl_aBdefc64b,
      dnnl_gOdhwI64o2i := dnnl_aBdefC64b2c,dnnl_gOdhwI64o4i := dnnl_aBdefC64b4c,
      dnnl_gdhwio := dnnl_adefcb,dnnl_gdhwIo2i := dnnl_adefCb2c,
      dnnl_gdhwIo4i := dnnl_adefCb4c,dnnl_OI16i32o4i := dnnl_AB16b32a4b,
      dnnl_OI16i48o4i := dnnl_AB16b48a4b,dnnl_OI16i64o4i := dnnl_AB16b64a4b,
      dnnl_OI16i16o2i := dnnl_AB16b16a2b,dnnl_OI16i32o2i := dnnl_AB16b32a2b,
      dnnl_OI16i48o2i := dnnl_AB16b48a2b,dnnl_OI16i64o2i := dnnl_AB16b64a2b,
      dnnl_OIw16i32o4i := dnnl_ABc16b32a4b,dnnl_OIw16i48o4i := dnnl_ABc16b48a4b,
      dnnl_OIw16i64o4i := dnnl_ABc16b64a4b,dnnl_OIw16i32o2i := dnnl_ABc16b32a2b,
      dnnl_OIw16i48o2i := dnnl_ABc16b48a2b,dnnl_OIw16i64o2i := dnnl_ABc16b64a2b,
      dnnl_OIhw16i32o4i := dnnl_ABcd16b32a4b,dnnl_OIhw16i48o4i := dnnl_ABcd16b48a4b,
      dnnl_OIhw16i64o4i := dnnl_ABcd16b64a4b,dnnl_OIhw16i32o2i := dnnl_ABcd16b32a2b,
      dnnl_OIhw16i48o2i := dnnl_ABcd16b48a2b,dnnl_OIhw16i64o2i := dnnl_ABcd16b64a2b,
      dnnl_OIdhw16i32o4i := dnnl_ABcde16b32a4b,dnnl_OIdhw16i48o4i := dnnl_ABcde16b48a4b,
      dnnl_OIdhw16i64o4i := dnnl_ABcde16b64a4b,dnnl_OIdhw16i32o2i := dnnl_ABcde16b32a2b,
      dnnl_OIdhw16i48o2i := dnnl_ABcde16b48a2b,dnnl_OIdhw16i64o2i := dnnl_ABcde16b64a2b,
      dnnl_OwI16i16o2i := dnnl_AcB16b16a2b,dnnl_OwI16i16o4i := dnnl_AcB16b16a4b,
      dnnl_OhwI16i16o2i := dnnl_AcdB16b16a2b,dnnl_OhwI16i16o4i := dnnl_AcdB16b16a4b,
      dnnl_OdhwI16i16o2i := dnnl_AcdeB16b16a2b,dnnl_OdhwI16i16o4i := dnnl_AcdeB16b16a4b,
      dnnl_gOwI16i16o2i := dnnl_aBdC16c16b2c,dnnl_gOwI16i16o4i := dnnl_aBdC16c16b4c,
      dnnl_gOhwI16i16o2i := dnnl_aBdeC16c16b2c,dnnl_gOhwI16i16o4i := dnnl_aBdeC16c16b4c,
      dnnl_gOdhwI16i16o2i := dnnl_aBdefC16c16b2c,dnnl_gOdhwI16i16o4i := dnnl_aBdefC16c16b4c,
      dnnl_OwI16i32o2i := dnnl_AcB16b32a2b,dnnl_OwI16i32o4i := dnnl_AcB16b32a4b,
      dnnl_OwI16i48o2i := dnnl_AcB16b48a2b,dnnl_OwI16i48o4i := dnnl_AcB16b48a4b,
      dnnl_OwI16i64o2i := dnnl_AcB16b64a2b,dnnl_OwI16i64o4i := dnnl_AcB16b64a4b,
      dnnl_gOwI16i32o2i := dnnl_aBdC16c32b2c,dnnl_gOwI16i32o4i := dnnl_aBdC16c32b4c,
      dnnl_gOwI16i48o2i := dnnl_aBdC16c48b2c,dnnl_gOwI16i48o4i := dnnl_aBdC16c48b4c,
      dnnl_gOwI16i64o2i := dnnl_aBdC16c64b2c,dnnl_gOwI16i64o4i := dnnl_aBdC16c64b4c,
      dnnl_OhwI16i32o2i := dnnl_AcdB16b32a2b,dnnl_OhwI16i32o4i := dnnl_AcdB16b32a4b,
      dnnl_OhwI16i48o2i := dnnl_AcdB16b48a2b,dnnl_OhwI16i48o4i := dnnl_AcdB16b48a4b,
      dnnl_OhwI16i64o2i := dnnl_AcdB16b64a2b,dnnl_OhwI16i64o4i := dnnl_AcdB16b64a4b,
      dnnl_gOhwI16i32o2i := dnnl_aBdeC16c32b2c,dnnl_gOhwI16i32o4i := dnnl_aBdeC16c32b4c,
      dnnl_gOhwI16i48o2i := dnnl_aBdeC16c48b2c,dnnl_gOhwI16i48o4i := dnnl_aBdeC16c48b4c,
      dnnl_gOhwI16i64o2i := dnnl_aBdeC16c64b2c,dnnl_gOhwI16i64o4i := dnnl_aBdeC16c64b4c,
      dnnl_OdhwI16i32o2i := dnnl_AcdeB16b32a2b,dnnl_OdhwI16i32o4i := dnnl_AcdeB16b32a4b,
      dnnl_OdhwI16i48o2i := dnnl_AcdeB16b48a2b,dnnl_OdhwI16i48o4i := dnnl_AcdeB16b48a4b,
      dnnl_OdhwI16i64o2i := dnnl_AcdeB16b64a2b,dnnl_OdhwI16i64o4i := dnnl_AcdeB16b64a4b,
      dnnl_gOdhwI16i32o2i := dnnl_aBdefC16c32b2c,dnnl_gOdhwI16i32o4i := dnnl_aBdefC16c32b4c,
      dnnl_gOdhwI16i48o2i := dnnl_aBdefC16c48b2c,dnnl_gOdhwI16i48o4i := dnnl_aBdefC16c48b4c,
      dnnl_gOdhwI16i64o2i := dnnl_aBdefC16c64b2c,dnnl_gOdhwI16i64o4i := dnnl_aBdefC16c64b4c,
      dnnl_hwioG16g := dnnl_decbA16a,dnnl_NCdhw40n16c := dnnl_ABcde40a16b,
      dnnl_NCw40n16c := dnnl_ABc40a16b,dnnl_NChw40n16c := dnnl_ABcd40a16b,
      dnnl_NCw40n32c := dnnl_ABc40a32b,dnnl_NChw40n32c := dnnl_ABcd40a32b,
      dnnl_NCdhw40n32c := dnnl_ABcde40a32b,dnnl_OIdhw4o8i8o2i := dnnl_ABcde4a8b8a2b,
      dnnl_OIhw4o8i8o2i := dnnl_ABcd4a8b8a2b,dnnl_OIw4o8i8o2i := dnnl_ABc4a8b8a2b,
      dnnl_gOIdhw4o8i8o2i := dnnl_aBCdef4b8c8b2c,dnnl_gOIhw4o8i8o2i := dnnl_aBCde4b8c8b2c,
      dnnl_gOIw4o8i8o2i := dnnl_aBCd4b8c8b2c,dnnl_IOdhw4i8o8i2o := dnnl_BAcde4b8a8b2a,
      dnnl_IOhw4i8o8i2o := dnnl_BAcd4b8a8b2a,dnnl_IOw4i8o8i2o := dnnl_BAc4b8a8b2a,
      dnnl_gIOdhw4i8o8i2o := dnnl_aCBdef4c8b8c2b,dnnl_gIOhw4i8o8i2o := dnnl_aCBde4c8b8c2b,
      dnnl_gIOw4i8o8i2o := dnnl_aCBd4c8b8c2b,dnnl_NCw2c32n8c := dnnl_ABc2b32a8b,
      dnnl_NChw2c32n8c := dnnl_ABcd2b32a8b,dnnl_NCdhw2c32n8c := dnnl_ABcde2b32a8b,
      dnnl_OIw2i8o16i4o := dnnl_ABc2b8a16b4a,dnnl_OIhw2i8o16i4o := dnnl_ABcd2b8a16b4a,
      dnnl_OIdhw2i8o16i4o := dnnl_ABcde2b8a16b4a,dnnl_OIw2o8i16o4i := dnnl_ABc2a8b16a4b,
      dnnl_OIw2o8i16o2i := dnnl_ABc2a8b16a2b,dnnl_IOw2i8o16i4o := dnnl_BAc2b8a16b4a,
      dnnl_IOw2i8o16i2o := dnnl_BAc2b8a16b2a,dnnl_OIhw2o8i16o4i := dnnl_ABcd2a8b16a4b,
      dnnl_OIhw2o8i16o2i := dnnl_ABcd2a8b16a2b,dnnl_IOhw2i8o16i4o := dnnl_BAcd2b8a16b4a,
      dnnl_IOhw2i8o16i2o := dnnl_BAcd2b8a16b2a,dnnl_OIdhw2o8i16o4i := dnnl_ABcde2a8b16a4b,
      dnnl_OIdhw2o8i16o2i := dnnl_ABcde2a8b16a2b,dnnl_IOdhw2i8o16i4o := dnnl_BAcde2b8a16b4a,
      dnnl_IOdhw2i8o16i2o := dnnl_BAcde2b8a16b2a,dnnl_gOIw2o8i16o2i := dnnl_aBCd2b8c16b2c,
      dnnl_gIOw2i8o16i2o := dnnl_aCBd2c8b16c2b,dnnl_gIOhw2i8o16i2o := dnnl_aBCde2c8b16c2b,
      dnnl_gIOdhw2i8o16i2o := dnnl_aBCdef2c8b16c2b,dnnl_gOIhw2o8i16o2i := dnnl_aBCde2b8c16b2c,
      dnnl_gOIdhw2o8i16o2i := dnnl_aBCdef2b8c16b2c,dnnl_gOIw2o8i16o4i := dnnl_aBCd2b8c16b4c,
      dnnl_gOIhw2o8i16o4i := dnnl_aBCde2b8c16b4c);
  {/ @ dnnl_api_memory }
  {/ @addtogroup dnnl_api_primitives }
  {/ @ }
  {/ @addtogroup dnnl_api_primitives_common }
  {/ @ }
  {/ Kinds of propagation. }
  { TODO: suggest renames }
  {/ Undefined propagation type. }
  {/ Forward data propagation (training mode). In this mode primitives }
  {/ perform computations necessary for subsequent backward propagation. }
  {/ Forward data propagation (inference mode). In this mode primitives }
  {/ perform only computations that are necessary for inference and omit }
  {/ computations that are necessary only for backward propagation. }
  {/ Forward data propagation (alias for @c dnnl_forward_inference). }
  {/ Forward data propagation (alias for @c dnnl_forward_training). }
  {/ Backward propagation (with respect to all parameters). }
  {/ Backward data propagation. }
  {/ Backward weights propagation. }
  {/ Backward bias propagation. }

    dnnl_prop_kind_t = (dnnl_prop_kind_undef := 0,dnnl_forward_training := 64,
      dnnl_forward_inference := 96,dnnl_forward_scoring := dnnl_forward_inference,
      dnnl_forward := dnnl_forward_training,dnnl_backward := 128,
      dnnl_backward_data := 160,dnnl_backward_weights := 192,
      dnnl_backward_bias := 193);
  {/ Kinds of primitives. Used to implement a way to extend the library with new }
  {/ primitives without changing the ABI. }
  {/ Undefined primitive }
  {/ A reorder primitive. }
  {/ A shuffle primitive. }
  {/ A (out-of-place) concat primitive. }
  {/ A sum primitive. }
  {/ A convolution primitive. }
  {/ A deconvolution primitive. }
  {/ An element-wise primitive. }
  {/ A softmax primitive. }
  {/ A pooling primitive. }
  {/ An LRN primitive. }
  {/ A batch normalization primitive. }
  {/ A layer normalization primitive. }
  {/ An inner product primitive. }
  {/ A rnn primitive. }
  {/ A matrix multiplication primitive (internal). }
  {/ A binary primitive. }
  {/ A logsoftmax primitive. }
  {/ A matrix multiplication primitive. }
  {/ A resampling primitive. }
  {/ A pooling version 2 primitive (pooling with dilation support). }
  {/ A reduction primitive. }
  {/ A PReLU primitive. }
  {/ Parameter to allow internal only primitives without undefined behavior. }
  {/ This parameter is chosen to be valid for so long as sizeof(int) >= 2. }

    dnnl_primitive_kind_t = (dnnl_undefined_primitive,dnnl_reorder,
      dnnl_shuffle,dnnl_concat,dnnl_sum,dnnl_convolution,
      dnnl_deconvolution,dnnl_eltwise,dnnl_softmax,
      dnnl_pooling,dnnl_lrn,dnnl_batch_normalization,
      dnnl_layer_normalization,dnnl_inner_product,
      dnnl_rnn,dnnl_gemm,dnnl_binary,dnnl_logsoftmax,
      dnnl_matmul,dnnl_resampling,dnnl_pooling_v2,
      dnnl_reduction,dnnl_prelu,dnnl_primitive_kind_max := $7fff
      );
  {/ Kinds of algorithms. }
  {/ Direct convolution }
  {/ Winograd convolution }
  {/ Convolution algorithm(either direct or Winograd) is chosen just in time }
  {/ Direct deconvolution }
  {/ Winograd deconvolution }
  {/ Eltwise: ReLU }
  {/ Eltwise: hyperbolic tangent non-linearity (tanh) }
  {/ Eltwise: exponential linear unit (elu) }
  {/ Eltwise: square }
  {/ Eltwise: abs }
  {/ Eltwise: square root }
  {/ Eltwise: linear }
  {/ Eltwise: bounded_relu }
  {/ Eltwise: soft_relu }
  {/ Eltwise: logistic }
  {/ Eltwise: exponent }
  {/ Eltwise: gelu }
  {/ }
  {/ @note Tanh approximation formula is used to approximate }
  {/ the cumulative distribution function of a Gaussian here }
  {/ Eltwise: tanh-based gelu (alias for dnnl_eltwise_gelu_tanh) }
  {/ Eltwise: swish }
  {/ Eltwise: natural logarithm }
  {/ Eltwise: clip }
  {/ Eltwise: clip version 2 }
  {/ Eltwise: pow }
  {/ Eltwise: erf-based gelu }
  {/ Eltwise: round }
  {/ Eltwise: logsigmoid }
  {/ Eltwise: mish }
  {/ Eltwise: hardswish }
  {/ Eltwise: ReLU (dst for backward) }
  {/ Eltwise: hyperbolic tangent non-linearity (tanh) (dst for backward) }
  {/ Eltwise: exponential linear unit (elu) (dst for backward) }
  {/ Eltwise: square root (dst for backward) }
  {/ Eltwise: logistic (dst for backward) }
  {/ Eltwise: exp (dst for backward) }
  {/ Eltwise: clip version 2 (dst for backward) }
  {/ Max pooling }
  {/ Average pooling include padding }
  {/ Average pooling exclude padding }
  {/ Average pooling (alias for #dnnl_pooling_avg_exclude_padding) }
  {/ Local response normalization (LRN) across multiple channels }
  {/ LRN within a single channel }
  {/ RNN cell }
  {/ LSTM cell }
  {/ GRU cell }
  {/ GRU cell with linear before reset }
  {/ }
  {/ Modification of original GRU cell. Differs from #dnnl_vanilla_gru }
  {/ in how the new memory gate is calculated: }
  {/ \f[ c_t = tanh(W_c*x_t + b_c_x + r_t*(U_c*h_t-1+b_c_h)) \f] }
  {/ Primitive expects 4 biases on input: }
  {/ \f$[b_u, b_r, b_c_x, b_c_h]\f$ }
  {/ Binary add }
  {/ Binary mul }
  {/ Binary max }
  {/ Binary min }
  {/ Binary div }
  {/ Binary sub }
  {/ Binary greater or equal }
  {/ Binary greater than }
  {/ Binary less or equal }
  {/ Binary less than }
  {/ Binary equal }
  {/ Binary not equal }
  {/ Nearest Neighbor Resampling Method }
  {/ Linear Resampling Method }
  {/ Reduction using max }
  {/ Reduction using min }
  {/ Reduction using sum }
  {/ Reduction using mul }
  {/ Reduction using mean }
  {/ Reduction using lp norm }
  {/ Reduction using lp norm }
  {/ Reduction using lp norm without final pth-root }
  {/ Reduction using lp norm without final pth-root }

    dnnl_alg_kind_t = (dnnl_alg_kind_undef,dnnl_convolution_direct := $1,
      dnnl_convolution_winograd := $2,dnnl_convolution_auto := $3,
      dnnl_deconvolution_direct := $a,dnnl_deconvolution_winograd := $b,
      dnnl_eltwise_relu := $1f,dnnl_eltwise_tanh := $2f,
      dnnl_eltwise_elu := $3f,dnnl_eltwise_square := $4f,
      dnnl_eltwise_abs := $5f,dnnl_eltwise_sqrt := $6f,
      dnnl_eltwise_linear := $7f,dnnl_eltwise_bounded_relu := $8f,
      dnnl_eltwise_soft_relu := $9f,dnnl_eltwise_logistic := $af,
      dnnl_eltwise_exp := $bf,dnnl_eltwise_gelu_tanh := $cf,
      dnnl_eltwise_gelu := dnnl_eltwise_gelu_tanh,dnnl_eltwise_swish := $df,
      dnnl_eltwise_log := $ef,dnnl_eltwise_clip := $ff,
      dnnl_eltwise_clip_v2 := $10,dnnl_eltwise_pow := $20,
      dnnl_eltwise_gelu_erf := $30,dnnl_eltwise_round := $40,
      dnnl_eltwise_logsigmoid := $50,dnnl_eltwise_mish := $60,
      dnnl_eltwise_hardswish := $70,dnnl_eltwise_relu_use_dst_for_bwd := $100,
      dnnl_eltwise_tanh_use_dst_for_bwd := $101,
      dnnl_eltwise_elu_use_dst_for_bwd := $102,
      dnnl_eltwise_sqrt_use_dst_for_bwd := $103,
      dnnl_eltwise_logistic_use_dst_for_bwd := $104,
      dnnl_eltwise_exp_use_dst_for_bwd := $105,
      dnnl_eltwise_clip_v2_use_dst_for_bwd := $106,
      dnnl_pooling_max := $1ff,dnnl_pooling_avg_include_padding := $2ff,
      dnnl_pooling_avg_exclude_padding := $3ff,
      dnnl_pooling_avg := dnnl_pooling_avg_exclude_padding,dnnl_lrn_across_channels := $aff,
      dnnl_lrn_within_channel := $bff,dnnl_vanilla_rnn := $1fff,
      dnnl_vanilla_lstm := $2fff,dnnl_vanilla_gru := $3fff,
      dnnl_lbr_gru := $4fff,dnnl_binary_add := $1fff0,
      dnnl_binary_mul := $1fff1,dnnl_binary_max := $1fff2,
      dnnl_binary_min := $1fff3,dnnl_binary_div := $1fff4,
      dnnl_binary_sub := $1fff5,dnnl_binary_ge := $1fff6,
      dnnl_binary_gt := $1fff7,dnnl_binary_le := $1fff8,
      dnnl_binary_lt := $1fff9,dnnl_binary_eq := $1fffa,
      dnnl_binary_ne := $1fffb,dnnl_resampling_nearest := $2fff0,
      dnnl_resampling_linear := $2fff1,dnnl_reduction_max,
      dnnl_reduction_min,dnnl_reduction_sum,
      dnnl_reduction_mul,dnnl_reduction_mean,
      dnnl_reduction_norm_lp_max,dnnl_reduction_norm_lp_sum,
      dnnl_reduction_norm_lp_power_p_max,dnnl_reduction_norm_lp_power_p_sum
      );
  {/ Flags for normalization primitives. }
  {/ Use no normalization flags }
  {/ }
  {/ If specified }
  {/  - on forward training propagation mean and variance are computed and }
  {/    stored as output }
  {/  - on backward propagation compute full derivative wrt data }
  {/  - on backward propagation prop_kind == #dnnl_backward_data has the same }
  {/    behavior as prop_kind == #dnnl_backward }
  {/ Use global statistics }
  {/ }
  {/ If specified }
  {/  - on forward propagation use mean and variance provided by user (input) }
  {/  - on backward propagation reduces the amount of computations, since }
  {/    mean and variance are considered as constants }
  {/ }
  {/  If not specified: }
  {/   - on forward propagation mean and variance are computed and stored as }
  {/     output }
  {/   - on backward propagation compute full derivative wrt data }
  {/ Use scale and shift parameters }
  {/ }
  {/ If specified: }
  {/  - on forward propagation use scale and shift (aka scale and bias) for }
  {/    the normalization results }
  {/  - on backward propagation (for prop_kind == #dnnl_backward) compute }
  {/    diff wrt scale and shift (hence one extra output used) }
  {/ }
  {/ If no specified: }
  {/  - on backward propagation prop_kind == #dnnl_backward_data has the }
  {/    same behavior as prop_kind == #dnnl_backward }
  {/ Fuse with ReLU }
  {/ }
  {/ The flag implies negative slope being 0. On training this is the only }
  {/ configuration supported. For inference, to use non-zero negative slope }
  {/ consider using @ref dev_guide_attributes_post_ops. }
  {/ }
  {/ If specified: }
  {/  - on inference this option behaves the same as if the primitive were }
  {/    fused with ReLU using post ops API with zero negative slope. }
  {/  - on training primitive requires workspace (required to be able to }
  {/    perform backward pass) }
  {/ Use scale parameter }
  {/ }
  {/ If specified: }
  {/  - on forward propagation use scale for the normalization results }
  {/  - on backward propagation (for prop_kind == #dnnl_backward) compute }
  {/    diff wrt scale (hence one extra output used) }
  {/ Use shift parameter }
  {/ }
  {/ If specified: }
  {/  - on forward propagation use shift (aka bias) for the normalization }
  {/    results }
  {/  - on backward propagation (for prop_kind == #dnnl_backward) compute }
  {/    diff wrt shift (hence one extra output used) }

    dnnl_normalization_flags_t = (dnnl_normalization_flags_none := $0,
      dnnl_use_global_stats := $1,dnnl_use_scaleshift := $2,
      dnnl_fuse_norm_relu := $4,dnnl_use_scale := $8,
      dnnl_use_shift := $10);
  {/ @ dnnl_api_primitives_common }
  {/ @ dnnl_api_primitives }
  {/ @addtogroup dnnl_api_memory }
  {/ @ }
  {/ Maximum number of dimensions a tensor can have. Only restricts the amount }
  {/ of space used for the tensor description. Individual computational }
  {/ primitives may support only tensors of certain dimensions. }

  const
    DNNL_MAX_NDIMS = 12;    
  {/ A wildcard value for dimensions that are unknown at a primitive creation }
  {/ time. }
  {$define DNNL_RUNTIME_DIM_VAL := INT64_MIN}    
  {/ A `size_t` counterpart of the DNNL_RUNTIME_DIM_VAL. }
  {/ For instance, this value is returned by dnnl_memory_desc_get_size() if }
  {/ either of the dimensions or strides equal to #DNNL_RUNTIME_DIM_VAL. }

  { was #define dname def_expr }
  {$define DNNL_RUNTIME_SIZE_VAL := size_t(DNNL_RUNTIME_DIM_VAL)}    

  {/ @cond DO_NOT_DOCUMENT_THIS }
  {/ Hex representation for a **special** quiet NAN (!= NAN from math.h) }
(* error 
static const union {
 in declarator_list *)
(* error 
    unsigned u;
 in declarator_list *)

//type TDNNL_RUNTIME_F32_VAL_REP = record case byte of 0:(u:DWORD);1:(f:single) end;
const DNNL_RUNTIME_F32_VAL_REP: record case byte of 0:(u:DWORD);1:(f:single) end=(u:$7fc000d0);
(* error 
} DNNL_RUNTIME_F32_VAL_REP = {0x7fc000d0};
in declaration at line 1639 *)
    {/ @endcond }
    {/ A wildcard value for floating point values that are unknown at a primitive }
    {/ creation time. }

{$define DNNL_RUNTIME_F32_VAL := (DNNL_RUNTIME_F32_VAL_REP.f)}      
    {/ @cond DO_NOT_DOCUMENT_THIS }
(* error 
static const int DNNL_RUNTIME_S32_VAL_REP = INT32_MIN;
 in declarator_list *)
{$define DNNL_RUNTIME_S32_VAL_REP := INT32_MIN}
    {/ @endcond }
    {/ A wildcard value for int32_t values that are unknown at a primitive creation }
    {/ time. }
{$define DNNL_RUNTIME_S32_VAL := DNNL_RUNTIME_S32_VAL_REP}      
    {/ A type to describe tensor dimension. }

    type
      dnnl_dim_t = int64_t;
    {/ A type to describe tensor dimensions. }

      dnnl_dims_t = array[0..(DNNL_MAX_NDIMS)-1] of dnnl_dim_t;
    {/ Generic description of blocked data layout for most memory formats. }
    {/ }
    {/ @sa @ref dev_guide_understanding_memory_formats }
    {/ The strides between the outermost blocks. }
    {/ In case of plain (non-blocked) formats the strides between dimensions. }
    { Innermost section }
    { ASSUMPTION: the innermost blocks are always dense }
    {/ The number of innermost blocks, e.g. 3 in case of `OIhw_4i16o4i_` }
    {/ The size of the blocks, e.g. `4, 16, 4` in case of `OIhw_4i16o4i` }
    {/ The logical indices of the blocks, e.g. `1, 0, 1` in case of }
    {/ `4i16o4i`, because `i` is the 1st dim and `o` is the 0st dim }

      dnnl_blocking_desc_t = record
          strides : dnnl_dims_t;
          inner_nblks : longint;
          inner_blks : dnnl_dims_t;
          inner_idxs : dnnl_dims_t;
        end;
    {/ Winograd-specific formats }
    {/ Undefined memory format, used for empty memory descriptors. }
    { Tensors of weights for 2x3 winograd convolutions. }
    {/< Internal weights format for 2x3 Winograd }
    {/< Internal weights format for 2x3 Winograd }
    {/< Internal weights format for 2x3 Winograd }
    { Tensor of weights for 4x3 convolution. }
    {/< Internal weights format for 4x3 Winograd }

      dnnl_wino_memory_format_t = (dnnl_wino_undef := 0,dnnl_wino_wei_aaOIoi,
        dnnl_wino_wei_aaOio,dnnl_wino_wei_aaOBiOo,
        dnnl_wino_wei_OBaaIBOIio);
    {/ Description of tensor of weights for winograd 2x3 convolution. }

      dnnl_wino_desc_t = record
          wino_format : dnnl_wino_memory_format_t;
          r : longint;
          alpha : longint;
          ic : longint;
          oc : longint;
          ic_block : longint;
          oc_block : longint;
          ic2_block : longint;
          oc2_block : longint;
          adj_scale : single;
          size : size_t;
        end;

      dnnl_rnn_packed_memory_format_t = (dnnl_packed_format_undef := 0,dnnl_ldigo_p,
        dnnl_ldgoi_p,dnnl_ldio_p);
    {/ Maximum number of parts of RNN weights tensor that require separate }
    {/ computation. }

    const
      DNNL_RNN_MAX_N_PARTS = 4;      
    {/ Description of tensor of packed weights for rnn. }

    type
      dnnl_rnn_packed_desc_t = record
          format : dnnl_rnn_packed_memory_format_t;
          n_parts : longint;
          n : longint;
          ldb : longint;
          parts : array[0..(DNNL_RNN_MAX_N_PARTS)-1] of longint;
          part_pack_size : array[0..(DNNL_RNN_MAX_N_PARTS)-1] of size_t;
          pack_part : array[0..(DNNL_RNN_MAX_N_PARTS)-1] of dword;
          offset_compensation : size_t;
          size : size_t;
          reserved : array[0..199] of char;
        end;
    {/ Flags for memory special features }
    {/ Indicates the weights have an additional buffer, that depends on the }
    {/ @p compensation_mask. }
    {/ }
    {/ For instance, in 4D case with the compensation mask equals (1 << 0) }
    {/ the additional buffer would consist of OC values: }
    {/ O[oc : 0,OC] = }
    {/  -128 * SUM(ic : 0,IC; kh : 0,KH; kw : 0,KW) weights(oc, ic, kh, kw)  }

      dnnl_memory_extra_flags_t = (dnnl_memory_extra_flag_none := $0,
        dnnl_memory_extra_flag_compensation_conv_s8s8 := $1,
        dnnl_memory_extra_flag_scale_adjust := $2,
        dnnl_memory_extra_flag_rnn_u8s8_compensation := $4,
        dnnl_memory_extra_flag_gpu_rnn_u8s8_compensation := dnnl_memory_extra_flag_rnn_u8s8_compensation,
        dnnl_memory_extra_flag_compensation_conv_asymmetric_src := $8,
        dnnl_memory_extra_flag_rnn_s8s8_compensation := $16
        );
    {/ Description of extra information stored in memory }
    {/ The flags contain arbitrary extra information, such as compensation. }
    {/ @sa dnnl_memory_extra_flags_t }
    {/ Compensation mask }
    {/ Scale applied to the data }
    {/ Compensation mask for asymmetric quantization }
    {/ For future backwards compatibility }

      dnnl_memory_extra_desc_t = record
          flags : uint64_t;
          compensation_mask : longint;
          scale_adjust : single;
          asymm_compensation_mask : longint;
          reserved : array[0..59] of char;
        end;
    {/ Memory descriptor. The description is based on a number of dimensions, }
    {/ dimensions themselves, plus information about elements type and memory }
    {/ format. Additionally, contains format-specific descriptions of the data }
    {/ layout. }
    {/ Number of dimensions }
    {/ Dimensions in the following order: }
    {/ - CNN data tensors: mini-batch, channel, spatial }
    {/   (<code>N, C, [[D,] H,] W</code>) }
    {/ - CNN weight tensors: group (optional), output channel, input channel, }
    {/   spatial (<code>[G,] O, I, [[D,] H,] W</code>) }
    {/ - RNN data tensors: time, mini-batch, channels (<code>T, N, C</code>) }
    {/   or layers, directions, states, mini-batch, channels (<code>L, D, S, N, C</code>) }
    {/ - RNN weight tensor: layers, directions, input channel, gates, output channels }
    {/   (<code>L, D, I, G, O</code>). }
    {/ }
    {/ @note }
    {/    The order of dimensions does not depend on the memory format, so }
    {/    whether the data is laid out in #dnnl_nchw or #dnnl_nhwc }
    {/    the dims for 4D CN data tensor would be <code>N, C, H, W</code>. }
    {/ Data type of the tensor elements. }
    {/ Size of the data including padding in each dimension. }
    {/ Per-dimension offset from the padding to actual data, the top-level }
    {/ tensor with offsets applied must lie within the padding area. }
    {/ Offset from memory origin to the current block, non-zero only in }
    {/ a description of a memory sub-block. }
    {/ Memory format kind. }
    {/ Description of the data layout for memory formats that use }
    {/ blocking. }
    {/ Tensor of weights for integer 8bit winograd convolution. }
    {/ Tensor of packed weights for RNN. }
    { ... other descriptions possible }

      dnnl_memory_desc_t = record
          ndims : longint;
          dims : dnnl_dims_t;
          data_type : dnnl_data_type_t;
          padded_dims : dnnl_dims_t;
          padded_offsets : dnnl_dims_t;
          offset0 : dnnl_dim_t;
          format_kind : dnnl_format_kind_t;
          format_desc : record
              case longint of
                0 : ( blocking : dnnl_blocking_desc_t );
                1 : ( wino_desc : dnnl_wino_desc_t );
                2 : ( rnn_packed_desc : dnnl_rnn_packed_desc_t );
              end;
          extra : dnnl_memory_extra_desc_t;
        end;
    {/ @struct dnnl_memory }
    {/ An opaque structure to describe a memory. }
      dnnl_memory = record
          {undefined structure}
        end;

    {/ A memory handle. }

      dnnl_memory_t = ^dnnl_memory;
    {/ A constant memory handle. }
(* Const before type ignored *)

      const_dnnl_memory_t = ^dnnl_memory;
    {/ Special pointer value that indicates that a memory object should not have }
    {/ an underlying buffer. }

    const DNNL_MEMORY_NONE = nil;      
    {/ Special pointer value that indicates that the library needs to allocate an }
    {/ underlying buffer for a memory object. }

    { was #define dname def_expr }
    {$define DNNL_MEMORY_ALLOCATE := pointer((size_t)-1)}      

  {/ @ dnnl_api_memory }
  {/ @addtogroup dnnl_api_primitives }
  {/ @ }
  {/ @addtogroup dnnl_api_primitives_common }
  {/ @ }
  {/ A pointer to any of the operation descriptors. }

  type
    dnnl_op_desc_t = pointer;
  {/ A pointer to any of the operation descriptors (constant variant). }
(* Const before type ignored *)

    const_dnnl_op_desc_t = pointer;
  {/ @ dnnl_api_primitives_common }
  {/ @ dnnl_api_primitives }
  {/ @addtogroup dnnl_api_primitives }
  {/ @ }
  {/ @addtogroup dnnl_api_convolution }
  {/ @ }
  {/ A descriptor of a convolution operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_convolution. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward_data, }
  {/ #dnnl_backward_weights, and #dnnl_backward_bias. }
  {/ The kind of the convolution algorithm. Possible values: }
  {/ #dnnl_convolution_direct. }
  {/ Source memory descriptor. }
  {/ Source gradient memory descriptor. }
  {/ Weights memory descriptor. }
  {/ Weights gradient memory descriptor. }
  {/ Bias memory descriptor. }
  {/ Bias gradient memory descriptor. }
  {/ Destination memory descriptor. }
  {/ Destination gradient memory descriptor. }
  {/ Convolution strides in each spatial dimension. }
  {/ Convolution dilates in each spatial dimension. }
  {/ Padding in each spatial dimension. padding[0] is a padding in the }
  {/ beginning (@p padding_l), padding[1] is a padding in the end (@p }
  {/ padding_r). }
  {/ The accumulator data type. Initialized automatically. }

    dnnl_convolution_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        alg_kind : dnnl_alg_kind_t;
        src_desc : dnnl_memory_desc_t;
        diff_src_desc : dnnl_memory_desc_t;
        weights_desc : dnnl_memory_desc_t;
        diff_weights_desc : dnnl_memory_desc_t;
        bias_desc : dnnl_memory_desc_t;
        diff_bias_desc : dnnl_memory_desc_t;
        dst_desc : dnnl_memory_desc_t;
        diff_dst_desc : dnnl_memory_desc_t;
        strides : dnnl_dims_t;
        dilates : dnnl_dims_t;
        padding : array[0..1] of dnnl_dims_t;
        accum_data_type : dnnl_data_type_t;
      end;
  {/ @ dnnl_api_convolution }
  {/ @addtogroup dnnl_api_deconvolution }
  {/ @ }
  {/ A descriptor of a deconvolution operation. }

    dnnl_deconvolution_desc_t = dnnl_convolution_desc_t;
  {/ @ dnnl_api_deconvolution }
  {/ @addtogroup dnnl_api_shuffle }
  {/ @ }
  {/ A descriptor of a shuffle operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_shuffle. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, and #dnnl_backward_data. }
  {/ Source and destination memory descriptor, }
  {/ and source and destination gradient memory descriptor. }
  {/ Axis for shuffling. }
  {/ Number of groups. }

    dnnl_shuffle_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        data_desc : dnnl_memory_desc_t;
        axis : longint;
        group_size : dnnl_dim_t;
      end;
  {/ @ dnnl_api_shuffle }
  {/ @addtogroup dnnl_api_eltwise }
  {/ @ }
  {/ A descriptor of a element-wise operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_eltwise. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward, and #dnnl_backward_data. }
  {/ The kind of eltwise algorithm. Possible values: #dnnl_eltwise_relu, }
  {/ #dnnl_eltwise_tanh, #dnnl_eltwise_elu, #dnnl_eltwise_square, }
  {/ #dnnl_eltwise_abs, #dnnl_eltwise_sqrt, #dnnl_eltwise_linear, }
  {/ #dnnl_eltwise_bounded_relu, #dnnl_eltwise_soft_relu, }
  {/ #dnnl_eltwise_logistic, #dnnl_eltwise_exp, #dnnl_eltwise_gelu_tanh, }
  {/ #dnnl_eltwise_swish, #dnnl_eltwise_log, #dnnl_eltwise_clip, }
  {/ #dnnl_eltwise_clip_v2, #dnnl_eltwise_pow, #dnnl_eltwise_gelu_erf, }
  {/ #dnnl_eltwise_round, #dnnl_eltwise_logsigmoid, #dnnl_eltwise_mish, }
  {/ #dnnl_eltwise_hardswish. }
  {/ Possible values for passing destination memory on backward: }
  {/ #dnnl_eltwise_relu_use_dst_for_bwd, #dnnl_eltwise_tanh_use_dst_for_bwd, }
  {/ #dnnl_eltwise_elu_use_dst_for_bwd, #dnnl_eltwise_sqrt_use_dst_for_bwd, }
  {/ #dnnl_eltwise_logistic_use_dst_for_bwd, }
  {/ #dnnl_eltwise_exp_use_dst_for_bwd, }
  {/ #dnnl_eltwise_clip_v2_use_dst_for_bwd. }
  {/ Source and destination memory descriptor. }
  {/ Source and destination gradient memory descriptor. }
  {/ Algorithm specific parameter. }
  {/ Accordance table: }
  {/  - #dnnl_eltwise_relu: @p alpha -- negative slope, @p beta ignored }
  {/  - #dnnl_eltwise_tanh: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_elu: @p alpha -- negative slope, @p beta ignored }
  {/  - #dnnl_eltwise_square: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_abs: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_sqrt: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_linear: @p alpha -- scale, @p beta -- shift }
  {/  - #dnnl_eltwise_bounded_relu: @p alpha -- upper bound, @p beta ignored }
  {/  - #dnnl_eltwise_soft_relu: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_logistic: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_exp: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_gelu_tanh: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_swish: @p alpha -- sigmoid arg scaling, @p beta ignored }
  {/  - #dnnl_eltwise_log: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_clip: @p alpha -- lower bound, @p beta -- upper bound }
  {/  - #dnnl_eltwise_clip_v2: @p alpha -- lower bound, @p beta -- upper bound }
  {/  - #dnnl_eltwise_pow: @p alpha -- scale, @p beta -- exponent }
  {/  - #dnnl_eltwise_gelu_erf: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_round: @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_logsigmoid @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_mish @p alpha and @p beta ignored }
  {/  - #dnnl_eltwise_hardswish @p alpha and @p beta ignored }

    dnnl_eltwise_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        alg_kind : dnnl_alg_kind_t;
        data_desc : dnnl_memory_desc_t;
        diff_data_desc : dnnl_memory_desc_t;
        alpha : single;
        beta : single;
      end;
  {/ @ dnnl_api_eltwise }
  {/ @addtogroup dnnl_api_softmax }
  {/ @ }
  {/ A descriptor of a Softmax operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_softmax. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training and }
  {/ #dnnl_forward_inference. }
  {/ Source and destination memory descriptor. }
  {/ Source and Destination of gradient memory descriptor. }
  {/ The axis along which to perform the softmax. }

    dnnl_softmax_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        data_desc : dnnl_memory_desc_t;
        diff_desc : dnnl_memory_desc_t;
        softmax_axis : longint;
      end;
  {/ @ dnnl_api_softmax }
  {/ @addtogroup dnnl_api_logsoftmax }
  {/ @ }
  {/ A descriptor of a LogSoftmax operation. An alias of Softmax structure, but }
  {/ primitive_kind must be #dnnl_logsoftmax. }

    dnnl_logsoftmax_desc_t = dnnl_softmax_desc_t;
  {/ @ dnnl_api_logsoftmax }
  {/ @addtogroup dnnl_api_pooling }
  {/ @ }
  {/ A descriptor of a pooling operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_pooling. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward, and #dnnl_backward_data. }
  {/ The kind of pooling algorithm. }
  {/ Possible values: #dnnl_pooling_max, }
  {/ #dnnl_pooling_avg_include_padding, and }
  {/ #dnnl_pooling_avg_exclude_padding. }
  {/ Source memory descriptor. }
  {/ Source gradient memory descriptor. }
  {/ Destination memory descriptor. }
  {/ Destination gradient memory descriptor. }
  {/ Pooling kernel strides for spatial dimensions. }
  {/ Pooling kernel spatial dimensions. }
  {/ Padding in each spatial dimension. padding[0] is a padding in the }
  {/ beginning (@p padding_l), padding[1] is a padding in the end (@p }
  {/ padding_r). }
  {/ The accumulator data type. Initialized automatically. }

    dnnl_pooling_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        alg_kind : dnnl_alg_kind_t;
        src_desc : dnnl_memory_desc_t;
        diff_src_desc : dnnl_memory_desc_t;
        dst_desc : dnnl_memory_desc_t;
        diff_dst_desc : dnnl_memory_desc_t;
        strides : dnnl_dims_t;
        kernel : dnnl_dims_t;
        padding : array[0..1] of dnnl_dims_t;
        accum_data_type : dnnl_data_type_t;
      end;
  {/ @ dnnl_api_pooling }
  {/ @addtogroup dnnl_api_pooling_v2 }
  {/ @ }
  {/ A descriptor of a pooling operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_pooling_v2. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward, and #dnnl_backward_data. }
  {/ The kind of pooling algorithm. }
  {/ Possible values: #dnnl_pooling_max, }
  {/ #dnnl_pooling_avg_include_padding, and }
  {/ #dnnl_pooling_avg_exclude_padding. }
  {/ Source memory descriptor. }
  {/ Source gradient memory descriptor. }
  {/ Destination memory descriptor. }
  {/ Destination gradient memory descriptor. }
  {/ Pooling kernel strides for spatial dimensions. }
  {/ Pooling kernel spatial dimensions. }
  {/ Padding in each spatial dimension. padding[0] is a padding in the }
  {/ beginning (@p padding_l), padding[1] is a padding in the end (@p }
  {/ padding_r). }
  {/ The accumulator data type. Initialized automatically. }
  {/ Pooling dilations for spatial dimensions. }

    dnnl_pooling_v2_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        alg_kind : dnnl_alg_kind_t;
        src_desc : dnnl_memory_desc_t;
        diff_src_desc : dnnl_memory_desc_t;
        dst_desc : dnnl_memory_desc_t;
        diff_dst_desc : dnnl_memory_desc_t;
        strides : dnnl_dims_t;
        kernel : dnnl_dims_t;
        padding : array[0..1] of dnnl_dims_t;
        accum_data_type : dnnl_data_type_t;
        dilation : dnnl_dims_t;
      end;
  {/ @ dnnl_api_pooling_v2 }
  {/ @addtogroup dnnl_api_prelu }
  {/ @ }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_prelu. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward }
  {/ Source and destination memory descriptor. }
  {/ Learnable parameter alpha memory descriptor. }
  {/ Alpha describes negative slope. }
  {/ Source and destination gradient memory descriptor. }
  {/ Learnable parameter alpha gradient memory descriptor. }

    dnnl_prelu_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        data_desc : dnnl_memory_desc_t;
        weights_desc : dnnl_memory_desc_t;
        diff_data_desc : dnnl_memory_desc_t;
        diff_weights_desc : dnnl_memory_desc_t;
      end;
  {/ @ dnnl_api_prelu }
  {/ @addtogroup dnnl_api_lrn }
  {/ @ }
  {/ A descriptor of a Local Response Normalization (LRN) operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_lrn. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward, and #dnnl_backward_data. }
  {/ LRN algorithm. Possible values: #dnnl_lrn_within_channel and }
  {/ #dnnl_lrn_across_channels. }
  {/ Source and destination memory descriptor. }
  {/ Source and destination gradient memory descriptor. }
  {/ The number of channels to sum over (for cross-channel LRN) or the side }
  {/ length of the square region to sum over (for within-channel LRN). }
  {/ LRN alpha parameter. }
  {/ LRN beta parameter. }
  {/ LRN k parameter. }

    dnnl_lrn_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        alg_kind : dnnl_alg_kind_t;
        data_desc : dnnl_memory_desc_t;
        diff_data_desc : dnnl_memory_desc_t;
        local_size : dnnl_dim_t;
        lrn_alpha : single;
        lrn_beta : single;
        lrn_k : single;
      end;
  {/ @ dnnl_api_lrn }
  {/ @addtogroup dnnl_api_batch_normalization }
  {/ @ }
  {/ A descriptor of a Batch Normalization operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_batch_normalization. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward, and #dnnl_backward_data. }
  {/ Source and destination memory descriptor. }
  {/ Source and destination gradient memory descriptor. }
  {/ Scale and shift data and gradient memory descriptors. }
  {/ }
  {/ Scaleshift memory descriptor uses 2D #dnnl_nc format[2,Channels]. 1-st }
  {/ dimension contains gamma parameter, 2-nd dimension contains beta }
  {/ parameter. }
  {/ Statistics memory descriptor. }
  {/ }
  {/ Statistics (mean or variance) descriptor use 1D #dnnl_x format[Channels]. }
  {/ Batch normalization epsilon parameter. }

    dnnl_batch_normalization_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        data_desc : dnnl_memory_desc_t;
        diff_data_desc : dnnl_memory_desc_t;
        data_scaleshift_desc : dnnl_memory_desc_t;
        diff_data_scaleshift_desc : dnnl_memory_desc_t;
        stat_desc : dnnl_memory_desc_t;
        batch_norm_epsilon : single;
        flags : dword;
      end;
  {/ @ dnnl_api_batch_normalization }
  {/ @addtogroup dnnl_api_layer_normalization }
  {/ @ }
  {/ A descriptor of a Layer Normalization operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_layer_normalization. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward, and #dnnl_backward_data. }
  {/ Source and destination memory descriptor. }
  {/ Source and destination gradient memory descriptor. }
  {/ Scale and shift data and gradient memory descriptors. }
  {/ }
  {/ Scaleshift memory descriptor uses 2D #dnnl_ab }
  {/ format[2, normalized_dim] where 1-st dimension contains gamma parameter, }
  {/ 2-nd dimension contains beta parameter. Normalized_dim is equal to the }
  {/ last logical dimension of the data tensor across which normalization is }
  {/ performed. }
  {/ Mean and variance data memory descriptors. }
  {/ }
  {/ Statistics (mean and variance) memory descriptor is the k-dimensional tensor }
  {/ where k is equal to data_tensor_ndims - 1 and may have any plain }
  {/ (stride[last_dim] == 1) user-provided format. }
  {/ Layer normalization epsilon parameter. }

    dnnl_layer_normalization_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        data_desc : dnnl_memory_desc_t;
        diff_data_desc : dnnl_memory_desc_t;
        data_scaleshift_desc : dnnl_memory_desc_t;
        diff_data_scaleshift_desc : dnnl_memory_desc_t;
        stat_desc : dnnl_memory_desc_t;
        layer_norm_epsilon : single;
        flags : dword;
      end;
  {/ @ dnnl_api_layer_normalization }
  {/ @addtogroup dnnl_api_inner_product }
  {/ @ }
  {/ A descriptor of an inner product operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_inner_product. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward_data, }
  {/ #dnnl_backward_weights, and #dnnl_backward_bias. }
  {/ Source memory descriptor. }
  {/ Source gradient memory descriptor. }
  {/ Weights memory descriptor. }
  {/ Weights gradient memory descriptor. }
  {/ Bias memory descriptor. }
  {/ Bias gradient memory descriptor. }
  {/ Destination memory descriptor. }
  {/ Destination gradient memory descriptor. }
  {/ The accumulator data type. Initialized automatically. }

    dnnl_inner_product_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        src_desc : dnnl_memory_desc_t;
        diff_src_desc : dnnl_memory_desc_t;
        weights_desc : dnnl_memory_desc_t;
        diff_weights_desc : dnnl_memory_desc_t;
        bias_desc : dnnl_memory_desc_t;
        diff_bias_desc : dnnl_memory_desc_t;
        dst_desc : dnnl_memory_desc_t;
        diff_dst_desc : dnnl_memory_desc_t;
        accum_data_type : dnnl_data_type_t;
      end;
  {/ @ dnnl_api_inner_product }
  {/ @addtogroup dnnl_api_rnn }
  {/ @ }
  {/ Flags for RNN cell. }
  {/ Undefined RNN flags }

    dnnl_rnn_flags_t = (dnnl_rnn_flags_undef := $0);
  {/ A direction of RNN primitive execution. }
  {/ Unidirectional execution of RNN primitive from left to right. }
  {/ Unidirectional execution of RNN primitive from right to left. }
  {/ Bidirectional execution of RNN primitive with concatenation of the }
  {/ results. }
  {/ Bidirectional execution of RNN primitive with summation of the }
  {/ results. }
  {/ Alias for #dnnl_unidirectional_left2right. }

    dnnl_rnn_direction_t = (dnnl_unidirectional_left2right,dnnl_unidirectional_right2left,
      dnnl_bidirectional_concat,dnnl_bidirectional_sum,
      dnnl_unidirectional := dnnl_unidirectional_left2right);
  {/ A descriptor for an RNN operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_rnn. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, and #dnnl_backward. }
  {/ RNN cell kind. Must be one of #dnnl_vanilla_rnn, }
  {/ #dnnl_vanilla_lstm, #dnnl_vanilla_gru, or #dnnl_lbr_gru. }
  {/ The direction of RNN primitive execution. }
  {/ Source layer memory descriptor. }
  {/ Source iteration memory descriptor for hidden state. }
  {/ Source iteration memory descriptor for cell state. }
  {/ Weights layer memory descriptor. }
  {/ Weights iteration memory descriptor. }
  {/ Bias memory descriptor. }
  {/ Destination layer memory descriptor. }
  {/ Destination iter memory descriptor for hidden state. }
  {/ Destination iter memory descriptor for cell state. }
  {/ Weights peephole memory descriptor. }
  {/ This memory descriptor is equal to zero memory descriptor in case of }
  {/ non-peephole LSTMs and other non-LSTM RNNs. }
  {/ Weights projection memory descriptor. }
  {/ This memory descriptor is equal to zero memory descriptor in case of }
  {/ non-projection LSTMs and other non-LSTM RNNs. }
  {/ Source gradient layer memory descriptor. }
  {/ Source gradient iter memory descriptor for hidden state. }
  {/ Source gradient iter memory descriptor for cell state. }
  {/ Weights gradient layer memory descriptor. }
  {/ Weights gradient iter memory descriptor. }
  {/ Bias gradient memory descriptor. }
  {/ Destination gradient layer memory descriptor. }
  {/ Destination gradient iteration memory descriptor for hidden state. }
  {/ Destination gradient iteration memory descriptor for cell state. }
  {/ Weights gradient peephole memory descriptor. }
  {/ This memory descriptor is equal to zero memory descriptor in case of }
  {/ non-peephole LSTMs and other non-LSTM RNNs. }
  {/ Weights gradient projection memory descriptor. }
  {/ This memory descriptor is equal to zero memory descriptor in case of }
  {/ non-projection LSTMs and other non-LSTM RNNs. }
  {/ RNN cell flags }
  {/ Activation function used for vanilla_rnn cell kind. }
  {/ Must be either #dnnl_eltwise_relu or #dnnl_eltwise_tanh. }

    dnnl_rnn_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        cell_kind : dnnl_alg_kind_t;
        direction : dnnl_rnn_direction_t;
        src_layer_desc : dnnl_memory_desc_t;
        src_iter_desc : dnnl_memory_desc_t;
        src_iter_c_desc : dnnl_memory_desc_t;
        weights_layer_desc : dnnl_memory_desc_t;
        weights_iter_desc : dnnl_memory_desc_t;
        bias_desc : dnnl_memory_desc_t;
        dst_layer_desc : dnnl_memory_desc_t;
        dst_iter_desc : dnnl_memory_desc_t;
        dst_iter_c_desc : dnnl_memory_desc_t;
        weights_peephole_desc : dnnl_memory_desc_t;
        weights_projection_desc : dnnl_memory_desc_t;
        diff_src_layer_desc : dnnl_memory_desc_t;
        diff_src_iter_desc : dnnl_memory_desc_t;
        diff_src_iter_c_desc : dnnl_memory_desc_t;
        diff_weights_layer_desc : dnnl_memory_desc_t;
        diff_weights_iter_desc : dnnl_memory_desc_t;
        diff_bias_desc : dnnl_memory_desc_t;
        diff_dst_layer_desc : dnnl_memory_desc_t;
        diff_dst_iter_desc : dnnl_memory_desc_t;
        diff_dst_iter_c_desc : dnnl_memory_desc_t;
        diff_weights_peephole_desc : dnnl_memory_desc_t;
        diff_weights_projection_desc : dnnl_memory_desc_t;
        flags : dword;
        activation_kind : dnnl_alg_kind_t;
        alpha : single;
        beta : single;
      end;
  {/ @ dnnl_api_rnn }
  {/ @addtogroup dnnl_api_binary }
  {/ @ }
  {/ A descriptor of a binary operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_binary. }
  {/ The kind of the binary algorithm. Possible values: }
  {/ #dnnl_binary_add, #dnnl_binary_mul, #dnnl_binary_max, #dnnl_binary_min, }
  {/ #dnnl_binary_div and #dnnl_binary_sub. }
  {/ Source memory descriptors. }
  {/ Destination memory descriptor. }

    dnnl_binary_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        alg_kind : dnnl_alg_kind_t;
        src_desc : array[0..1] of dnnl_memory_desc_t;
        dst_desc : dnnl_memory_desc_t;
      end;
  {/ @ dnnl_api_binary }
  {/ @addtogroup dnnl_api_matmul }
  {/ @ }
  {/ A descriptor of a matrix multiplication operation. }
  {/ }
  {/ 2D case: }
  {/     dst[m, n] = src[m, k] * weights[k, n] + bias[m, n] }
  {/ }
  {/ 3D case: }
  {/     dst[mb, m, n] = src[mb, m, k] * weights[mb, k, n] + bias[mb, m, n] }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_matmul. }
  {/ Source memory descriptor. }
  {/ Weights memory descriptor. }
  {/ Bias memory descriptor. }
  {/ Destination memory descriptor. }
  {/ The accumulator data type. Initialized automatically. }

    dnnl_matmul_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        src_desc : dnnl_memory_desc_t;
        weights_desc : dnnl_memory_desc_t;
        bias_desc : dnnl_memory_desc_t;
        dst_desc : dnnl_memory_desc_t;
        accum_data_type : dnnl_data_type_t;
      end;
  {/ @ dnnl_api_matmul }
  {/ @addtogroup dnnl_api_resampling }
  {/ @ }
  {/ A descriptor of resampling operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_resampling. }
  {/ The kind of propagation. Possible values: #dnnl_forward_training, }
  {/ #dnnl_forward_inference, #dnnl_backward_data, }
  {/ The kind of the resampling algorithm. Possible values: }
  {/ #dnnl_resampling_nearest, #dnnl_resampling_linear. }
  {/ Source memory descriptor. }
  {/ Source gradient memory descriptor. }
  {/ Destination memory descriptor. }
  {/ Destination gradient memory descriptor. }
  {/ Resampling factor in each spatial dimension. }

    dnnl_resampling_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        prop_kind : dnnl_prop_kind_t;
        alg_kind : dnnl_alg_kind_t;
        src_desc : dnnl_memory_desc_t;
        diff_src_desc : dnnl_memory_desc_t;
        dst_desc : dnnl_memory_desc_t;
        diff_dst_desc : dnnl_memory_desc_t;
        factors : array[0..(DNNL_MAX_NDIMS)-1] of single;
      end;
  {/ @ dnnl_api_resampling }
  {/ @addtogroup dnnl_api_reduction }
  {/ @ }
  {/ A descriptor of reduction operation. }
  {/ The kind of primitive. Used for self-identifying the primitive }
  {/ descriptor. Must be #dnnl_reduction. }
  {/ The kind of reduction algorithm. Possible values: }
  {/ #dnnl_reduction_max, #dnnl_reduction_min, #dnnl_reduction_sum, }
  {/ #dnnl_reduction_mul, #dnnl_reduction_mean, #dnnl_reduction_norm_lp_max, }
  {/ #dnnl_reduction_norm_lp_sum, #dnnl_reduction_norm_lp_power_p_max, }
  {/ #dnnl_reduction_norm_lp_power_p_sum. }
  {/ Source memory descriptor. }
  {/ Destination memory descriptor. }
  {/ Algorithm specific parameters. }
  {/ Accordance table: }
  {/ #dnnl_reduction_max: @p p and @p eps are ignored }
  {/ #dnnl_reduction_min: @p p and @p eps are ignored }
  {/ #dnnl_reduction_norm_lp_max: @p p -- power, @p eps -- epsilon }
  {/ #dnnl_reduction_norm_lp_sum: @p p -- power, @p eps -- epsilon }
  {/ #dnnl_reduction_norm_lp_power_p_max: @p p -- power, @p eps -- epsilon }
  {/ #dnnl_reduction_norm_lp_power_p_sum: @p p -- power, @p eps -- epsilon }
  {/ #dnnl_reduction_sum: @p p and @p eps are ignored }
  {/ #dnnl_reduction_mul: @p p and @p eps are ignored }
  {/ #dnnl_reduction_mean: @p p and @p eps are ignored }

    dnnl_reduction_desc_t = record
        primitive_kind : dnnl_primitive_kind_t;
        alg_kind : dnnl_alg_kind_t;
        src_desc : dnnl_memory_desc_t;
        dst_desc : dnnl_memory_desc_t;
        p : single;
        eps : single;
      end;
  {/ @ dnnl_api_reduction }
  {/ @ dnnl_api_primitives }
  {/ @addtogroup dnnl_api_engine }
  {/ @ }
  {/ @brief Kinds of engines. }
  {/ An unspecified engine. }
  {/ CPU engine. }
  {/ GPU engine. }

    dnnl_engine_kind_t = (dnnl_any_engine,dnnl_cpu,dnnl_gpu);
  {/ @struct dnnl_engine }
  {/ @brief An opaque structure to describe an engine. }
    dnnl_engine = record
        {undefined structure}
      end;

  {/ @brief An engine handle. }

    dnnl_engine_t = ^dnnl_engine;
{$if 0}
  { FIXME: looks like this never happens }
  {/ @brief A constant engine handle. }
(* Const before type ignored *)

  type
    const_dnnl_engine_t = ^dnnl_engine;
{$endif}
  {/ @ dnnl_api_engine }
  {/ @addtogroup dnnl_api_primitives }
  {/ @ }
  {/ @addtogroup dnnl_api_primitives_common }
  {/ @ }
  {/ @struct dnnl_primitive_desc_iterator }
  {/ @brief An opaque structure to describe a primitive descriptor iterator. }

  type
    dnnl_primitive_desc_iterator = record
        {undefined structure}
      end;

  {/ @brief A primitive descriptor iterator handle. }

    dnnl_primitive_desc_iterator_t = ^dnnl_primitive_desc_iterator;
  {/ @brief A constant primitive descriptor iterator handle. }
(* Const before type ignored *)

    const_dnnl_primitive_desc_iterator_t = ^dnnl_primitive_desc_iterator;
  {/ @struct dnnl_primitive_desc }
  {/ @brief An opaque structure to describe a primitive descriptor. }
    dnnl_primitive_desc = record
        {undefined structure}
      end;

  {/ @brief A primitive descriptor handle. }

    dnnl_primitive_desc_t = ^dnnl_primitive_desc;
  {/ @brief A constant primitive descriptor handle. }
(* Const before type ignored *)

    const_dnnl_primitive_desc_t = ^dnnl_primitive_desc;
  {/ @ dnnl_api_primitives_common }
  {/ @addtogroup dnnl_api_attributes }
  {/ @ }
  {/ Floating-point math mode }
  {/ Default behavior, no downconversions allowed }
  {/ Implicit f32->bf16 conversions allowed }
  {/ Implicit f32->f16 conversions allowed }
  {/ Implicit f32->f16 or f32->bf16 conversions allowed }

    dnnl_fpmath_mode_t = (dnnl_fpmath_mode_strict,dnnl_fpmath_mode_bf16,
      dnnl_fpmath_mode_f16,dnnl_fpmath_mode_any
      );
  {/ Scratchpad mode }
  {/ The library manages the scratchpad allocation according to the policy }
  {/ specified by the `DNNL_ENABLE_CONCURRENT_EXEC` }
  {/ [build option](@ref dev_guide_build_options) (default). }
  {/ }
  {/ When `DNNL_ENABLE_CONCURRENT_EXEC=OFF` (default), the library }
  {/ scratchpad is common to all primitives to reduce the memory footprint. }
  {/ This configuration comes with limited thread-safety properties, namely }
  {/ primitives can be created and executed in parallel but cannot migrate }
  {/ between threads (in other words, each primitive should be executed in }
  {/ the same thread it was created in). }
  {/ }
  {/ When `DNNL_ENABLE_CONCURRENT_EXEC=ON`, the library scratchpad is }
  {/ private to each primitive. The memory footprint is larger than when }
  {/ using `DNNL_ENABLE_CONCURRENT_EXEC=OFF` but different primitives can be }
  {/ created and run concurrently (the same primitive cannot be run }
  {/ concurrently from two different threads though). }
  {/ The user manages the scratchpad allocation by querying and providing }
  {/ the scratchpad memory to primitives. This mode is thread-safe as long }
  {/ as the scratchpad buffers are not used concurrently by two primitive }
  {/ executions. }

    dnnl_scratchpad_mode_t = (dnnl_scratchpad_mode_library,dnnl_scratchpad_mode_user
      );
  {/ @struct dnnl_primitive_attr }
  {/ @brief An opaque structure for primitive descriptor attributes. }
  {/ }
  {/ Attributes may contain: }
  {/  - output scales (to scale the result prior to storing it to the memory) }
    dnnl_primitive_attr = record
        {undefined structure}
      end;

  {/ @brief A primitive descriptor attributes handle that controls primitive }
  {/ behavior. }

    dnnl_primitive_attr_t = ^dnnl_primitive_attr;
  {/ @brief A constant primitive descriptor attributes handle. }
(* Const before type ignored *)

    const_dnnl_primitive_attr_t = ^dnnl_primitive_attr;
  {/ @struct dnnl_post_ops }
  {/ @brief An opaque structure for a chain of post operations. }
  {/ }
  {/ dnnl_post_ops can be used to perform some (trivial) operations like }
  {/ accumulation or eltwise after certain primitives like convolution. }
  {/ }
  {/ Post operations might be combined together, making a chain of post }
  {/ operations. For instance one can configure convolution followed by }
  {/ accumulation followed by eltwise. This might be especially beneficial }
  {/ for residual learning blocks. }
  {/ }
  {/ @warning }
  {/      Of course not all combinations are supported, so the user should handle }
  {/      errors accordingly. }
  {/ }
  {/ Supported post operations: }
  {/  - accumulation (base primitive: convolution) }
  {/  - eltwise (base primitive: convolution) }
    dnnl_post_ops = record
        {undefined structure}
      end;

  {/ @brief A post operation chain handle. }

    dnnl_post_ops_t = ^dnnl_post_ops;
  {/ @brief A constant post operation chain handle. }
(* Const before type ignored *)

    const_dnnl_post_ops_t = ^dnnl_post_ops;
  {/ @ dnnl_api_attributes }
  {/ @addtogroup dnnl_api_primitives_common }
  {/ @ }
  {/ @struct dnnl_primitive }
  {/ An opaque structure to describe a primitive. }
    dnnl_primitive = record
        {undefined structure}
      end;

  {/ A primitive handle. }

    dnnl_primitive_t = ^dnnl_primitive;
  {/ A constant primitive handle. }
(* Const before type ignored *)

    const_dnnl_primitive_t = ^dnnl_primitive;
  {/ Source argument #0. }

  const
    DNNL_ARG_SRC_0 = 1;    
  {/ A special mnemonic for source argument for primitives that have a }
  {/ single source. An alias for #DNNL_ARG_SRC_0. }
    DNNL_ARG_SRC = DNNL_ARG_SRC_0;    
  {/ A special mnemonic for RNN input vector. An alias for }
  {/ #DNNL_ARG_SRC_0. }
    DNNL_ARG_SRC_LAYER = DNNL_ARG_SRC_0;    
  {/ A special mnemonic for reorder source argument. An alias for }
  {/ #DNNL_ARG_SRC_0. }
    DNNL_ARG_FROM = DNNL_ARG_SRC_0;    
  {/ Source argument #1. }
    DNNL_ARG_SRC_1 = 2;    
  {/ A special mnemonic for RNN input recurrent hidden state vector. An alias }
  {/ for #DNNL_ARG_SRC_1. }
    DNNL_ARG_SRC_ITER = DNNL_ARG_SRC_1;    
  {/ Source argument #2. }
    DNNL_ARG_SRC_2 = 3;    
  {/ A special mnemonic for RNN input recurrent cell state vector. An alias for }
  {/ #DNNL_ARG_SRC_2. }
    DNNL_ARG_SRC_ITER_C = DNNL_ARG_SRC_2;    
  {/ Destination argument #0. }
    DNNL_ARG_DST_0 = 17;    
  {/ A special mnemonic for destination argument for primitives that have a }
  {/ single destination. An alias for #DNNL_ARG_DST_0. }
    DNNL_ARG_DST = DNNL_ARG_DST_0;    
  {/ A special mnemonic for reorder destination argument. An alias for }
  {/ #DNNL_ARG_DST_0. }
    DNNL_ARG_TO = DNNL_ARG_DST_0;    
  {/ A special mnemonic for RNN output vector. An alias for #DNNL_ARG_DST_0. }
    DNNL_ARG_DST_LAYER = DNNL_ARG_DST_0;    
  {/ Destination argument #1. }
    DNNL_ARG_DST_1 = 18;    
  {/ A special mnemonic for RNN input recurrent hidden state vector. An }
  {/ alias for #DNNL_ARG_DST_1. }
    DNNL_ARG_DST_ITER = DNNL_ARG_DST_1;    
  {/ Destination argument #2. }
    DNNL_ARG_DST_2 = 19;    
  {/ A special mnemonic for LSTM output recurrent cell state vector. An }
  {/ alias for #DNNL_ARG_DST_2. }
    DNNL_ARG_DST_ITER_C = DNNL_ARG_DST_2;    
  {/ Weights argument #0. }
    DNNL_ARG_WEIGHTS_0 = 33;    
  {/ A special mnemonic for primitives that have a single weights }
  {/ argument. Alias for #DNNL_ARG_WEIGHTS_0. }
    DNNL_ARG_WEIGHTS = DNNL_ARG_WEIGHTS_0;    
  {/ A special mnemonic for scale and shift argument of normalization }
  {/ primitives. Alias for #DNNL_ARG_WEIGHTS_0. }
    DNNL_ARG_SCALE_SHIFT = DNNL_ARG_WEIGHTS_0;    
  {/ A special mnemonic for RNN weights applied to the layer input. An }
  {/ alias for #DNNL_ARG_WEIGHTS_0. }
    DNNL_ARG_WEIGHTS_LAYER = DNNL_ARG_WEIGHTS_0;    
  {/ Weights argument #1. }
    DNNL_ARG_WEIGHTS_1 = 34;    
  {/ A special mnemonic for RNN weights applied to the recurrent input. }
  {/ An alias for #DNNL_ARG_WEIGHTS_1. }
    DNNL_ARG_WEIGHTS_ITER = DNNL_ARG_WEIGHTS_1;    
  {/ Weights argument #2. }
    DNNL_ARG_WEIGHTS_2 = 35;    
  {/ A special mnemonic for RNN weights applied to the peephole weights. }
  {/ An alias for #DNNL_ARG_WEIGHTS_2. }
    DNNL_ARG_WEIGHTS_PEEPHOLE = DNNL_ARG_WEIGHTS_2;    
  {/ Weights argument #3. }
    DNNL_ARG_WEIGHTS_3 = 36;    
  {/ A special mnemonic for RNN weights applied to the projection weights. }
  {/ An alias for #DNNL_ARG_WEIGHTS_3. }
    DNNL_ARG_WEIGHTS_PROJECTION = DNNL_ARG_WEIGHTS_3;    
  {/ Bias tensor argument. }
    DNNL_ARG_BIAS = 41;    
  {/ Mean values tensor argument. }
    DNNL_ARG_MEAN = 49;    
  {/ Variance values tensor argument. }
    DNNL_ARG_VARIANCE = 50;    
  {/ A special mnemonic for scale argument of normalization primitives. }
    DNNL_ARG_SCALE = 51;    
  {/ A special mnemonic for shift argument of normalization primitives. }
    DNNL_ARG_SHIFT = 52;    
  {/ Workspace tensor argument. Workspace is used to pass information }
  {/ from forward propagation to backward propagation computations. }
    DNNL_ARG_WORKSPACE = 64;    
  {/ Scratchpad (temporary storage) tensor argument. }
    DNNL_ARG_SCRATCHPAD = 80;    
  {/ Gradient (diff) of the source argument #0. }
    DNNL_ARG_DIFF_SRC_0 = 129;    
  {/ A special mnemonic for primitives that have a single diff source argument. }
  {/ An alias for #DNNL_ARG_DIFF_SRC_0. }
    DNNL_ARG_DIFF_SRC = DNNL_ARG_DIFF_SRC_0;    
  {/ A special mnemonic for gradient (diff) of RNN input vector. An alias for }
  {/ #DNNL_ARG_DIFF_SRC_0. }
    DNNL_ARG_DIFF_SRC_LAYER = DNNL_ARG_DIFF_SRC_0;    
  {/ Gradient (diff) of the source argument #1. }
    DNNL_ARG_DIFF_SRC_1 = 130;    
  {/ A special mnemonic for gradient (diff) of RNN input recurrent hidden state }
  {/ vector. An alias for #DNNL_ARG_DIFF_SRC_1. }
    DNNL_ARG_DIFF_SRC_ITER = DNNL_ARG_DIFF_SRC_1;    
  {/ Gradient (diff) of the source argument #2. }
    DNNL_ARG_DIFF_SRC_2 = 131;    
  {/ A special mnemonic for gradient (diff) of RNN input recurrent cell state }
  {/ vector. An alias for #DNNL_ARG_DIFF_SRC_1. }
    DNNL_ARG_DIFF_SRC_ITER_C = DNNL_ARG_DIFF_SRC_2;    
  {/ Gradient (diff) of the destination argument #0. }
    DNNL_ARG_DIFF_DST_0 = 145;    
  {/ A special mnemonic for primitives that have a single diff destination }
  {/ argument. An alias for #DNNL_ARG_DIFF_DST_0. }
    DNNL_ARG_DIFF_DST = DNNL_ARG_DIFF_DST_0;    
  {/ A special mnemonic for gradient (diff) of RNN output vector. An alias for }
  {/ #DNNL_ARG_DIFF_DST_0. }
    DNNL_ARG_DIFF_DST_LAYER = DNNL_ARG_DIFF_DST_0;    
  {/ Gradient (diff) of the destination argument #1. }
    DNNL_ARG_DIFF_DST_1 = 146;    
  {/ A special mnemonic for gradient (diff) of RNN input recurrent hidden state }
  {/ vector. An alias for #DNNL_ARG_DIFF_DST_1. }
    DNNL_ARG_DIFF_DST_ITER = DNNL_ARG_DIFF_DST_1;    
  {/ Gradient (diff) of the destination argument #2. }
    DNNL_ARG_DIFF_DST_2 = 147;    
  {/ A special mnemonic for gradient (diff) of RNN input recurrent cell state }
  {/ vector. An alias for #DNNL_ARG_DIFF_DST_2. }
    DNNL_ARG_DIFF_DST_ITER_C = DNNL_ARG_DIFF_DST_2;    
  {/ Gradient (diff) of the weights argument #0. }
    DNNL_ARG_DIFF_WEIGHTS_0 = 161;    
  {/ A special mnemonic for primitives that have a single diff weights }
  {/ argument. Alias for #DNNL_ARG_DIFF_WEIGHTS_0. }
    DNNL_ARG_DIFF_WEIGHTS = DNNL_ARG_DIFF_WEIGHTS_0;    
  {/ A special mnemonic for diff of scale and shift argument of normalization }
  {/ primitives. Alias for #DNNL_ARG_DIFF_WEIGHTS_0. }
    DNNL_ARG_DIFF_SCALE_SHIFT = DNNL_ARG_DIFF_WEIGHTS_0;    
  {/ A special mnemonic for diff of RNN weights applied to the layer input. An }
  {/ alias for #DNNL_ARG_DIFF_WEIGHTS_0. }
    DNNL_ARG_DIFF_WEIGHTS_LAYER = DNNL_ARG_DIFF_WEIGHTS_0;    
  {/ Gradient (diff) of the weights argument #1. }
    DNNL_ARG_DIFF_WEIGHTS_1 = 162;    
  {/ A special mnemonic for diff of RNN weights applied to the recurrent input. }
  {/ An alias for #DNNL_ARG_DIFF_WEIGHTS_1. }
    DNNL_ARG_DIFF_WEIGHTS_ITER = DNNL_ARG_DIFF_WEIGHTS_1;    
  {/ Gradient (diff) of the weights argument #2. }
    DNNL_ARG_DIFF_WEIGHTS_2 = 163;    
  {/ A special mnemonic for diff of RNN weights applied to the peephole weights. }
  {/ An alias for #DNNL_ARG_DIFF_WEIGHTS_2. }
    DNNL_ARG_DIFF_WEIGHTS_PEEPHOLE = DNNL_ARG_DIFF_WEIGHTS_2;    
  {/ Gradient (diff) of the weights argument #3. }
    DNNL_ARG_DIFF_WEIGHTS_3 = 164;    
  {/ A special mnemonic for diff of RNN weights applied to the projection }
  {/ weights. An alias for #DNNL_ARG_DIFF_WEIGHTS_3. }
    DNNL_ARG_DIFF_WEIGHTS_PROJECTION = DNNL_ARG_DIFF_WEIGHTS_3;    
  {/ Gradient (diff) of the bias tensor argument. }
    DNNL_ARG_DIFF_BIAS = 169;    
  {/ A special mnemonic for scale argument of normalization primitives. }
    DNNL_ARG_DIFF_SCALE = 255;    
  {/ A special mnemonic for shift argument of normalization primitives. }
    DNNL_ARG_DIFF_SHIFT = 256;    
  {/ Output scaling factors provided at execution time. }
    DNNL_ARG_ATTR_OUTPUT_SCALES = 513;    
  {/ Starting index for source arguments for primitives that take a variable }
  {/ number of source arguments. }
    DNNL_ARG_MULTIPLE_SRC = 1024;    
  {/ Starting index for destination arguments for primitives that produce a }
  {/ variable number of destination arguments. }
    DNNL_ARG_MULTIPLE_DST = 2048;    
  {/ Zero points provided at execution time. }
    DNNL_ARG_ATTR_ZERO_POINTS = 4096;    
  {/ Arguments for fused depthwise convolution. }
  {/ See @ref dev_guide_attributes_post_ops_depthwise_fusion }
    DNNL_ARG_ATTR_POST_OP_DW = 8192;    
  {/ Starting point for a binary post operation. }
    DNNL_ARG_ATTR_MULTIPLE_POST_OP_BASE = 16384;    
  {/ Arguments for a binary post operation. Up to 32 arguments are supported. }
  {/ See @ref dev_guide_attributes_post_ops_binary_fusion }
  function DNNL_ARG_ATTR_MULTIPLE_POST_OP(const idx:integer):integer;inline;
const  
(* error 
    (DNNL_ARG_ATTR_MULTIPLE_POST_OP_BASE * ((idx) + 1))
in define line 2816 *)
    {/ Input scaling factors provided at execution time. }
      DNNL_ARG_ATTR_INPUT_SCALES = 1048576;      
    {/ A structure that contains an index and a memory object, and is used to pass }
    {/ arguments to dnnl_primitive_execute(). }
    {/< An argument index, e.g. DNNL_ARG_SRC }
    {/< Input/output memory }

    type
      dnnl_exec_arg_t = record
          arg : longint;
          memory : dnnl_memory_t;
        end;
    {/ @ dnnl_api_primitives_common }
    {/ @addtogroup dnnl_api_primitives_common }
    {/ @ }
    {/ Primitive descriptor query specification }
    {/ }
    {/ For generic function dnnl_primitive_desc_query(), the type of result must }
    {/ agree with the queried argument. The correspondence table: }
    {/ }
    {/ Query kind                      | Type of query result }
    {/ --------------------------------|----------------------------- }
    {/ #dnnl_query_engine              | #dnnl_engine_t * }
    {/ #dnnl_query_scratchpad_engine   | #dnnl_engine_t * }
    {/ #dnnl_query_primitive_kind      | #dnnl_primitive_kind_t * }
    {/ dnnl_query_*_s32                | int * }
    {/ dnnl_query_*_s64                | #dnnl_dim_t * (same as int64_t *) }
    {/ dnnl_query_*_f64                | double * }
    {/ dnnl_query_*_str                | const char ** }
    {/ #dnnl_query_op_d                | #const_dnnl_op_desc_t * }
    {/ dnnl_query_*_md                 | const #dnnl_memory_desc_t ** }
    {/ dnnl_query_*_\<op\>_d           | const dnnl_\<op\>_desc_t ** }
    {/ dnnl_query_*_pd                 | #const_dnnl_primitive_desc_t * }
    {/ }
    {/ @note }
    {/     Rule of thumb: all opaque types and structures are returned by }
    {/     reference. All numbers are returned by value. }
    {/ }
    {/ @warning }
    {/     All returned references point to constant objects and are valid only }
    {/     during the lifetime of the queried primitive descriptor. Returned objects }
    {/     must not be destroyed by the user. If you need to keep the object longer }
    {/     than the lifetime of the queried primitive descriptor, use }
    {/     dnnl_primitive_desc_clone() to make a copy. }
    {/< no query }
    {/< execution engine }
    {/< primitive kind }
    {/< number of inputs expected }
    {/< number of outputs expected }
    {/< runtime estimation (seconds) }
    {/< memory consumption -- extra }
    {/  (scratch) memory, additional to }
    {/  all inputs and outputs memory }
    {/  (bytes) }
    {/< scratchpad engine -- engine to be used }
    {/  for creating scratchpad memory }
    {/< implementation name }
    {/< source engine }
    {/< destination engine }
    {/< propagation kind }
    { memory and op descriptor section }
    {/< stub }
    {/< op descriptor }
    {/< convolution descriptor }
    {/< deconvolution descriptor }
    {/< shuffle descriptor }
    {/< eltwise descriptor }
    {/< softmax descriptor }
    {/< pooling descriptor }
    {/< lrn descriptor }
    {/< batch normalization descriptor }
    {/< layer normalization descriptor }
    {/< inner product descriptor }
    {/< rnn descriptor }
    {/< GEMM descriptor (internal) }
    {/< binary descriptor }
    {/< logsoftmax descriptor }
    {/< matrix multiplication (matmul) descriptor }
    {/< resampling descriptor }
    {/< pooling version 2 descriptor }
    {/< reduction descriptor }
    {/< prelu descriptor }
    { memory descriptor section }
    {/< stub }
    {/< source memory desc }
    {/< source gradient memory desc }
    {/< weights memory descriptor desc }
    {/< weights grad. memory desc }
    {/< destination memory desc }
    {/< destination grad. memory desc }
    {/< workspace memory desc }
    {/< scratchpad memory desc }
    {/< memory desc of an execute argument }
    { Max value to prevent UB for internal use only dnnl_query_t }

      dnnl_query_t = (dnnl_query_undef := 0,dnnl_query_engine,
        dnnl_query_primitive_kind,dnnl_query_num_of_inputs_s32,
        dnnl_query_num_of_outputs_s32,dnnl_query_time_estimate_f64,
        dnnl_query_memory_consumption_s64,
        dnnl_query_scratchpad_engine,dnnl_query_impl_info_str,
        dnnl_query_reorder_src_engine,dnnl_query_reorder_dst_engine,
        dnnl_query_prop_kind,dnnl_query_some_d := 64,
        dnnl_query_op_d,dnnl_query_convolution_d,
        dnnl_query_deconvolution_d,dnnl_query_shuffle_d,
        dnnl_query_eltwise_d,dnnl_query_softmax_d,
        dnnl_query_pooling_d,dnnl_query_lrn_d,
        dnnl_query_batch_normalization_d,dnnl_query_layer_normalization_d,
        dnnl_query_inner_product_d,dnnl_query_rnn_d,
        dnnl_query_gemm_d,dnnl_query_binary_d,
        dnnl_query_logsoftmax_d,dnnl_query_matmul_d,
        dnnl_query_resampling_d,dnnl_query_pooling_v2_d,
        dnnl_query_reduction_d,dnnl_query_prelu_d,
        dnnl_query_some_md := 128,dnnl_query_src_md,
        dnnl_query_diff_src_md,dnnl_query_weights_md,
        dnnl_query_diff_weights_md,dnnl_query_dst_md,
        dnnl_query_diff_dst_md,dnnl_query_workspace_md,
        dnnl_query_scratchpad_md,dnnl_query_exec_arg_md := 255,
        dnnl_query_max := $7fff);
    {/ @ dnnl_api_primitives_common }
    {/ @ dnnl_api_primitives }
    {/ @addtogroup dnnl_api_stream }
    {/ @ }
    {/ @brief Stream flags. }
    { In-order execution. }
    {/ Out-of-order execution. }
    {/ Default stream configuration. }

      dnnl_stream_flags_t = (dnnl_stream_in_order := $1,dnnl_stream_out_of_order := $2,
        dnnl_stream_default_flags := dnnl_stream_in_order);
    {/ @struct dnnl_stream }
    {/ An opaque structure to describe an execution stream. }
      dnnl_stream = record
          {undefined structure}
        end;

    {/ An execution stream handle. }

      dnnl_stream_t = ^dnnl_stream;
    {/ A constant execution stream handle. }
(* Const before type ignored *)

      const_dnnl_stream_t = ^dnnl_stream;
    {/ @ dnnl_api_stream }
    {/ @addtogroup dnnl_api_service }
    {/ @ }
    {/ No runtime (disabled) }

    const
      DNNL_RUNTIME_NONE = 0;      
    {/ Sequential runtime (CPU only) }
      DNNL_RUNTIME_SEQ = 1;      
    {/ OpenMP runtime (CPU only) }
      DNNL_RUNTIME_OMP = 2;      
    {/ TBB runtime (CPU only) }
      DNNL_RUNTIME_TBB = 4;      
    {/ Threadpool runtime (CPU only) }
      DNNL_RUNTIME_THREADPOOL = 8;      
    {/ OpenCL runtime }
      DNNL_RUNTIME_OCL = 256;      
    {/ SYCL runtime }
      DNNL_RUNTIME_SYCL = 512;      
    {/ DPC++ runtime }
      DNNL_RUNTIME_DPCPP = DNNL_RUNTIME_SYCL;      
    {/ Structure containing version information as per [Semantic }
    {/ Versioning](https://semver.org) }
    {/< Major version }
    {/< Minor version }
    {/< Patch version }
(* Const before type ignored *)
    {/< Git hash of the sources (may be absent) }
    {/< CPU runtime }
    {/< GPU runtime }

    type
      Pdnnl_version_t = ^dnnl_version_t;
      dnnl_version_t = record
          major : longint;
          minor : longint;
          patch : longint;
          hash : ^char;
          cpu_runtime : dword;
          gpu_runtime : dword;
        end;
    {/ Disable profiling completely }

    const
      DNNL_JIT_PROFILE_NONE = 0;      
    {/ Enable VTune Amplifier integration }
      DNNL_JIT_PROFILE_VTUNE = 1;      
    {/ Enable Linux perf integration via perfmap files }
      DNNL_JIT_PROFILE_LINUX_PERFMAP = 2;      
    {/ Enable Linux perf integration via jitdump files }
      DNNL_JIT_PROFILE_LINUX_JITDUMP = 4;      
    {/ Instruct Linux perf integration via jitdump files to use TSC. @ref }
    {/ DNNL_JIT_PROFILE_LINUX_JITDUMP must be set too for this to take effect. }
      DNNL_JIT_PROFILE_LINUX_JITDUMP_USE_TSC = 8;      
    {/ Enable Linux perf integration (both jitdump and perfmap) }
      DNNL_JIT_PROFILE_LINUX_PERF = DNNL_JIT_PROFILE_LINUX_JITDUMP or DNNL_JIT_PROFILE_LINUX_PERFMAP;      
    {/ CPU instruction set flags }
    {/ Any ISA (excepting those listed as initial support) }
    {/ Intel Streaming SIMD Extensions 4.1 (Intel SSE4.1) }
    {/ Intel Advanced Vector Extensions (Intel AVX) }
    {/ Intel Advanced Vector Extensions 2 (Intel AVX2) }
    {/ Intel Advanced Vector Extensions 512 (Intel AVX-512) subset }
    {/ for Intel Xeon Phi processors x200 Series. }
    {/ Intel AVX-512 subset }
    {/ for Intel Xeon Phi processors 7235, 7285, 7295 Series. }
    {/ Intel AVX-512 subset for Intel Xeon Scalable processor family }
    {/ and Intel Core processor family. }
    {/ Intel AVX-512 and Intel Deep Learning Boost (Intel DL Boost) support }
    {/ for Intel Xeon Scalable processor family }
    {/ and Intel Core processor family. }
    {/ Intel AVX-512, Intel DL Boost and bfloat16 support }
    {/ for Intel Xeon Scalable processor family }
    {/ and Intel Core processor family. }
    {/ Intel AVX-512, Intel DL Boost and bfloat16 support and }
    {/ Intel AMX with 8-bit integer and bfloat16 support }
    {/ Intel AVX2 and Intel Deep Learning Boost (Intel DL Boost) support }

    type
      dnnl_cpu_isa_t = (dnnl_cpu_isa_all := $0,dnnl_cpu_isa_sse41 := $1,
        dnnl_cpu_isa_avx := $3,dnnl_cpu_isa_avx2 := $7,
        dnnl_cpu_isa_avx512_mic := $f,dnnl_cpu_isa_avx512_mic_4ops := $1f,
        dnnl_cpu_isa_avx512_core := $27,dnnl_cpu_isa_avx512_core_vnni := $67,
        dnnl_cpu_isa_avx512_core_bf16 := $e7,
        dnnl_cpu_isa_avx512_core_amx := $3e7,
        dnnl_cpu_isa_avx2_vnni := $407);
    {/ CPU ISA hints flags }
    {/ No hints (use default features) }
    {/ Prefer to exclusively use Ymm registers for computations }

      dnnl_cpu_isa_hints_t = (dnnl_cpu_isa_no_hints := $0,dnnl_cpu_isa_prefer_ymm := $1
        );

  {/ SYCL Memory allocation kind. }
  {/ USM (device, shared, host, or unknown) memory allocation kind - default. }
  {/ Buffer memory allocation kind. }
    Pdnnl_sycl_interop_memory_kind_t  = ^dnnl_sycl_interop_memory_kind_t;
    dnnl_sycl_interop_memory_kind_t = (dnnl_sycl_interop_usm,dnnl_sycl_interop_buffer);

  {/ Memory allocation kind. }
  {/ USM (device, shared, host, or unknown) memory allocation kind. }
  {/ Buffer memory allocation kind - default. }
    Pdnnl_ocl_interop_memory_kind_t  = ^dnnl_ocl_interop_memory_kind_t;
    dnnl_ocl_interop_memory_kind_t = (dnnl_ocl_interop_usm,dnnl_ocl_interop_buffer);

    PPSingle = ^PSingle;
    Pconst_dnnl_post_ops_t  = ^const_dnnl_post_ops_t;
    Pconst_dnnl_primitive_attr_t  = ^const_dnnl_primitive_attr_t;
    Pconst_dnnl_primitive_desc_t  = ^const_dnnl_primitive_desc_t;
    Pdnnl_alg_kind_t  = ^dnnl_alg_kind_t;
    Pdnnl_batch_normalization_desc_t  = ^dnnl_batch_normalization_desc_t;
    Pdnnl_binary_desc_t  = ^dnnl_binary_desc_t;
    Pdnnl_convolution_desc_t  = ^dnnl_convolution_desc_t;
    Pdnnl_data_type_t  = ^dnnl_data_type_t;
    Pdnnl_deconvolution_desc_t  = ^dnnl_deconvolution_desc_t;
    Pdnnl_dim_t  = ^dnnl_dim_t;
    Pdnnl_eltwise_desc_t  = ^dnnl_eltwise_desc_t;
    Pdnnl_engine_kind_t  = ^dnnl_engine_kind_t;
    Pdnnl_engine_t  = ^dnnl_engine_t;
    Pdnnl_exec_arg_t  = ^dnnl_exec_arg_t;
    Pdnnl_fpmath_mode_t  = ^dnnl_fpmath_mode_t;
    Pdnnl_inner_product_desc_t  = ^dnnl_inner_product_desc_t;
    Pdnnl_layer_normalization_desc_t  = ^dnnl_layer_normalization_desc_t;
    Pdnnl_logsoftmax_desc_t  = ^dnnl_logsoftmax_desc_t;
    Pdnnl_lrn_desc_t  = ^dnnl_lrn_desc_t;
    Pdnnl_matmul_desc_t  = ^dnnl_matmul_desc_t;
    PPdnnl_memory_desc_t = ^Pdnnl_memory_desc_t;
    Pdnnl_memory_desc_t  = ^dnnl_memory_desc_t;
    Pdnnl_memory_t  = ^dnnl_memory_t;
    Pdnnl_pooling_desc_t  = ^dnnl_pooling_desc_t;
    Pdnnl_pooling_v2_desc_t  = ^dnnl_pooling_v2_desc_t;
    Pdnnl_post_ops_t  = ^dnnl_post_ops_t;
    Pdnnl_prelu_desc_t  = ^dnnl_prelu_desc_t;
    Pdnnl_primitive_attr_t  = ^dnnl_primitive_attr_t;
    Pdnnl_primitive_desc_iterator_t  = ^dnnl_primitive_desc_iterator_t;
    Pdnnl_primitive_desc_t  = ^dnnl_primitive_desc_t;
    Pdnnl_primitive_t  = ^dnnl_primitive_t;
    Pdnnl_reduction_desc_t  = ^dnnl_reduction_desc_t;
    Pdnnl_resampling_desc_t  = ^dnnl_resampling_desc_t;
    Pdnnl_rnn_desc_t  = ^dnnl_rnn_desc_t;
    Pdnnl_scratchpad_mode_t  = ^dnnl_scratchpad_mode_t;
    Pdnnl_shuffle_desc_t  = ^dnnl_shuffle_desc_t;
    Pdnnl_softmax_desc_t  = ^dnnl_softmax_desc_t;
    Pdnnl_stream_t  = ^dnnl_stream_t;

{$include dnnl_config.inc}

{%beginregion debugging_fuction} 
// Debugging functions 
  function dnnl_status2str(v:dnnl_status_t):PCHAR;cdecl;external;

  function dnnl_dt2str(v:dnnl_data_type_t):PCHAR;cdecl;external;

  function dnnl_fmt_kind2str(v:dnnl_format_kind_t):PCHAR;cdecl;external;

  function dnnl_fmt_tag2str(v:dnnl_format_tag_t):PCHAR;cdecl;external;

  function dnnl_prop_kind2str(v:dnnl_prop_kind_t):PCHAR;cdecl;external;

  function dnnl_prim_kind2str(v:dnnl_primitive_kind_t):PCHAR;cdecl;external;

  function dnnl_alg_kind2str(v:dnnl_alg_kind_t):PCHAR;cdecl;external;

  function dnnl_rnn_flags2str(v:dnnl_rnn_flags_t):PCHAR;cdecl;external;

  function dnnl_rnn_direction2str(v:dnnl_rnn_direction_t):PCHAR;cdecl;external;

  function dnnl_engine_kind2str(v:dnnl_engine_kind_t):PCHAR;cdecl;external;

  function dnnl_fpmath_mode2str(v:dnnl_fpmath_mode_t):PCHAR;cdecl;external;

  function dnnl_scratchpad_mode2str(v:dnnl_scratchpad_mode_t):PCHAR;cdecl;external;

  function dnnl_cpu_isa2str(v:dnnl_cpu_isa_t):PCHAR;cdecl;external;

  function dnnl_cpu_isa_hints2str(v:dnnl_cpu_isa_hints_t):PCHAR;cdecl;external;

  function dnnl_runtime2str(v:dword):PCHAR;cdecl;external;

{%endregion}


  {/ @addtogroup dnnl_api }
  {/ @ }
  {/ @addtogroup dnnl_api_primitives }
  {/ @ }
  {/ @addtogroup dnnl_api_primitives_common }
  {/ @ }
  {/ Creates a primitive descriptor iterator. }
  {/ }
  {/ @param iterator Output primitive descriptor iterator. }
  {/ @param op_desc Operation descriptor. }
  {/ @param attr Primitive attributes (can be NULL). }
  {/ @param engine Engine to use. }
  {/ @param hint_forward_primitive_desc For backward propagation: primitive }
  {/     descriptor for a respective forward propagation primitive. Pass NULL }
  {/     for forward propagation. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }

  function dnnl_primitive_desc_iterator_create(iterator:Pdnnl_primitive_desc_iterator_t; op_desc:const_dnnl_op_desc_t; attr:const_dnnl_primitive_attr_t; engine:dnnl_engine_t; hint_forward_primitive_desc:const_dnnl_primitive_desc_t):dnnl_status_t;cdecl;external;

  {/ Advances the primitive descriptor iterator to point to the next available }
  {/ implementation. }
  {/ }
  {/ @param iterator A primitive descriptor iterator to advance. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  {/ @returns #dnnl_iterator_ends if no more implementations available. }
  function dnnl_primitive_desc_iterator_next(iterator:dnnl_primitive_desc_iterator_t):dnnl_status_t;cdecl;external;

  {/ Fetches the current primitive descriptor from a primitive descriptor }
  {/ iterator. }
  {/ }
  {/ @note }
  {/     The user is responsible for deleting the resulting primitive }
  {/     descriptor using dnnl_primitive_desc_destroy(). }
  {/ }
  {/ @param iterator A primitive descriptor iterator. }
  {/ @returns A primitive descriptor. }
  function dnnl_primitive_desc_iterator_fetch(iterator:const_dnnl_primitive_desc_iterator_t):dnnl_primitive_desc_t;cdecl;external;

  {/ Destroys a primitive descriptor iterator. }
  {/ }
  {/ @param iterator Primitive descriptor iterator to destroy. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_desc_iterator_destroy(iterator:dnnl_primitive_desc_iterator_t):dnnl_status_t;cdecl;external;

  {/ Creates a primitive descriptor. This function is equivalent to a sequence }
  {/ of #dnnl_primitive_desc_iterator_create() and }
  {/ #dnnl_primitive_desc_iterator_fetch(). In other words, the library will }
  {/ pick the first suitable implementation. }
  {/ }
  {/ @param primitive_desc Output primitive descriptor. }
  {/ @param op_desc Operation descriptor. }
  {/ @param attr Primitive attributes (can be NULL). }
  {/ @param engine Engine to use. }
  {/ @param hint_forward_primitive_desc For backward propagation: primitive }
  {/     descriptor for a respective forward propagation primitive. Pass NULL }
  {/     for forward propagation. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_desc_create(primitive_desc:Pdnnl_primitive_desc_t; op_desc:const_dnnl_op_desc_t; attr:const_dnnl_primitive_attr_t; engine:dnnl_engine_t; hint_forward_primitive_desc:const_dnnl_primitive_desc_t):dnnl_status_t;cdecl;external;

  {/ Clones a primitive descriptor. The resulting primitive descriptor must be }
  {/ destroyed separately. }
  {/ }
  {/ @param primitive_desc Output primitive descriptor. }
  {/ @param existing_primitive_desc Primitive descriptor to clone. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_desc_clone(primitive_desc:Pdnnl_primitive_desc_t; existing_primitive_desc:const_dnnl_primitive_desc_t):dnnl_status_t;cdecl;external;

  {/ Returns a constant reference to the attributes of a primitive descriptor. }
  {/ }
  {/ @warning }
  {/     It is an error to destroy the resulting @p attr. }
  {/ }
  {/ @warning }
  {/     The lifetime of an @p attr is the same as that of a @p }
  {/     primitive_desc, so it is an error to use the @p attr once the @p }
  {/     primitive_desc has been destroyed. }
  {/ }
  {/ @param primitive_desc Primitive descriptor. }
  {/ @param attr Output primitive attributes. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_desc_get_attr(primitive_desc:const_dnnl_primitive_desc_t; attr:Pconst_dnnl_primitive_attr_t):dnnl_status_t;cdecl;external;

  {/ Destroys a primitive descriptor. }
  {/ }
  {/ @param primitive_desc Primitive descriptor to destroy. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_desc_destroy(primitive_desc:dnnl_primitive_desc_t):dnnl_status_t;cdecl;external;

  {/ Queries a primitive descriptor for various pieces of information. }
  {/ }
  {/ The most common use case is to query a primitive descriptor, created with }
  {/ source, weights, and destination memory descriptors with format tags set }
  {/ to #dnnl_format_tag_any, for the corresponding memory descriptors (in this }
  {/ case the @p what is set to #dnnl_query_src_md, #dnnl_query_weights_md, and }
  {/ #dnnl_query_dst_md respectively) so that it is possible to create memory }
  {/ objects and reorder primitives if necessary. }
  {/ }
  {/ Another typical use case is to query a primitive descriptor for workspace }
  {/ memory descriptor (with @p what set to #dnnl_query_workspace_md). If this }
  {/ query returns #dnnl_not_required status, then workspace memory is not }
  {/ required. }
  {/ }
  {/ @note }
  {/     When querying for a memory descriptor for a scratchpad, a workspace, }
  {/     or an optional parameter, the query will return a pointer to a zero }
  {/     memory descriptor if the parameter is not needed. }
  {/ }
  {/ A few other use cases: }
  {/  - query a primitive descriptor for the underlying operation descriptor }
  {/    (#dnnl_query_convolution_d, #dnnl_query_eltwise_d, #dnnl_query_rnn_d, }
  {/    etc.) }
  {/  - query a primitive descriptor for the implementation information string }
  {/    (#dnnl_query_impl_info_str) }
  {/  - query a primitive descriptor for the number of inputs and outputs }
  {/    (#dnnl_query_num_of_inputs_s32 and #dnnl_query_num_of_outputs_s32 }
  {/    respectively) }
  {/ }
  {/ @sa dnnl_query_t for more options }
  {/ }
  {/ @param primitive_desc Primitive descriptor. }
  {/ @param what Parameter to query. }
  {/ @param index Index of the parameter to query for. }
  {/ @param result Output result. The type depends on the query. For example, }
  {/     it must be a @c dnnl_memory_desc_t* if querying for a memory }
  {/     descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_desc_query(primitive_desc:const_dnnl_primitive_desc_t; what:dnnl_query_t; index:longint; result:pointer):dnnl_status_t;cdecl;external;

  {/ Queries primitive descriptor for a memory descriptor. }
  {/ }
  {/ @note }
  {/     This function is a convenience version of }
  {/     #dnnl_primitive_desc_query(). }
  {/ }
  {/ @param primitive_desc Primitive descriptor. }
  {/ @param what Kind of memory descriptor parameter to query for. }
  {/ @param index Index of the parameter to query. }
  {/ @returns A pointer to the requested memory descriptor. }
  {/ @returns A pointer to a zero memory descriptor if the parameter is not }
  {/          needed. }
  {/ @returns NULL in case of any error. }
  {/ }
(* Const before type ignored *)
  function dnnl_primitive_desc_query_md(primitive_desc:const_dnnl_primitive_desc_t; what:dnnl_query_t; index:longint):Pdnnl_memory_desc_t;cdecl;external;

  {/ Queries primitive descriptor for a signed 32bit int. }
  {/ }
  {/ @note }
  {/     This function is a convenience version of }
  {/     #dnnl_primitive_desc_query(). }
  {/ }
  {/ @param primitive_desc Primitive descriptor. }
  {/ @param what Kind of the value to query for. }
  {/ @param index Index of the parameter to query. }
  {/ @returns The requested value. }
  {/ @returns 0 in case of any error (in particular if the queried entity is }
  {/     not of type int32_t). Note that 0 may also be the actual returned }
  {/     value. }
  function dnnl_primitive_desc_query_s32(primitive_desc:const_dnnl_primitive_desc_t; what:dnnl_query_t; index:longint):longint;cdecl;external;

  {/ Creates a primitive. }
  {/ }
  {/ @param primitive Output primitive. }
  {/ @param primitive_desc Primitive descriptor used to create the primitive. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_create(primitive:Pdnnl_primitive_t; primitive_desc:const_dnnl_primitive_desc_t):dnnl_status_t;cdecl;external;

  {/ Executes a primitive. }
  {/ }
  {/ @param primitive Primitive to execute. }
  {/ @param stream Stream to use. }
  {/ @param nargs Number of arguments. }
  {/ @param args Array of arguments. Each argument is an }
  {/     <index, #dnnl_memory_t> pair. The index is one of the `DNNL_ARG_*` }
  {/     values such as `DNNL_ARG_SRC`. Unless runtime shapes are used (see }
  {/     #DNNL_RUNTIME_DIM_VAL), the memory object must have the same memory }
  {/     descriptor as that returned by }
  {/     #dnnl_primitive_desc_query_md(#dnnl_query_exec_arg_md, index). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  {/ @note If any argument in @param args is padded (padded_dims > }
  {/ dims), the primitive execution will assume properly zero-padded }
  {/ input arguments, and produce zero-padded output arguments. }
(* Const before type ignored *)
  function dnnl_primitive_execute(primitive:const_dnnl_primitive_t; stream:dnnl_stream_t; nargs:longint; args:Pdnnl_exec_arg_t):dnnl_status_t;cdecl;external;

  {/ Retrieves a constant reference to the primitive descriptor of a given }
  {/ primitive. }
  {/ }
  {/ @warning }
  {/     It is an error to destroy the returned object. It is owned by the }
  {/     primitive. The @c const qualifier of the returned object prevents }
  {/     such attempts. }
  {/ }
  {/ @param primitive Primitive to query for the primitive descriptor. }
  {/ @param primitive_desc Output primitive descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_get_primitive_desc(primitive:const_dnnl_primitive_t; primitive_desc:Pconst_dnnl_primitive_desc_t):dnnl_status_t;cdecl;external;

  {/ Destroys a primitive. }
  {/ }
  {/ @param primitive The primitive to destroy. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_destroy(primitive:dnnl_primitive_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_primitives_common }
  {/ @addtogroup dnnl_api_attributes }
  {/ @ }
  {/ Creates an empty (default) primitive attributes with all the parameters }
  {/ set to their default values. }
  {/ }
  {/ Empty attributes are implied whenever the respective argument is NULL. }
  {/ }
  {/ @param attr Output primitive attributes. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_create(attr:Pdnnl_primitive_attr_t):dnnl_status_t;cdecl;external;

  {/ Clones primitive attributes. }
  {/ }
  {/ @param attr Output primitive attributes. }
  {/ @param existing_attr Primitive attributes to clone. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_clone(attr:Pdnnl_primitive_attr_t; existing_attr:const_dnnl_primitive_attr_t):dnnl_status_t;cdecl;external;

  {/ Destroys primitive attributes. }
  {/ }
  {/ @param attr Primitive attributes to destroy. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_destroy(attr:dnnl_primitive_attr_t):dnnl_status_t;cdecl;external;

  {/ Returns the floating-point math mode primitive attribute. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param mode Output FP math mode. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_get_fpmath_mode(attr:const_dnnl_primitive_attr_t; mode:Pdnnl_fpmath_mode_t):dnnl_status_t;cdecl;external;

  {/ Sets the floating-point math mode primitive attributes. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param mode FP math mode. The possible values are: }
  {/     #dnnl_fpmath_mode_strict (default), }
  {/     #dnnl_fpmath_mode_bf16, }
  {/     #dnnl_fpmath_mode_f16, }
  {/     #dnnl_fpmath_mode_any. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_set_fpmath_mode(attr:dnnl_primitive_attr_t; mode:dnnl_fpmath_mode_t):dnnl_status_t;cdecl;external;

  {/ Returns the primitive attributes scratchpad mode. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param mode Output scratchpad mode. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_get_scratchpad_mode(attr:const_dnnl_primitive_attr_t; mode:Pdnnl_scratchpad_mode_t):dnnl_status_t;cdecl;external;

  {/ Sets primitive attributes scratchpad mode. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param mode Scratchpad mode. The possible values are: }
  {/     #dnnl_scratchpad_mode_library (default) and }
  {/     #dnnl_scratchpad_mode_user. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_set_scratchpad_mode(attr:dnnl_primitive_attr_t; mode:dnnl_scratchpad_mode_t):dnnl_status_t;cdecl;external;

  {/ Returns primitive attributes output scaling factors correspondence mask }
  {/ and values. }
  {/ }
  {/ @warning }
  {/     The @p scales array is an internal part of the primitive attributes }
  {/     @p attr, so it is an error to modify or destroy the @p scales array. }
  {/ }
  {/ @warning }
  {/     The lifetime of @p scales array is the same as that of the primitive }
  {/     attributes @p attr to which it belongs, so it is an error to use }
  {/     @p scales after @p attr is destroyed. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param count Output length of the array of scaling factors @p scales. }
  {/ @param mask Output scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p scales }
  {/     vector. The set i-th bit indicates that a dedicated output scaling }
  {/     factor is used for each index along that dimension. The mask value of }
  {/     0 implies a common output scaling factor for the whole output tensor. }
  {/ @param scales Output pointer to a constant array of scaling factors. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_get_output_scales(attr:const_dnnl_primitive_attr_t; count:Pdnnl_dim_t; mask:Plongint; scales:PPsingle):dnnl_status_t;cdecl;external;

  {/ Sets output scaling factors correspondence mask and values. }
  {/ }
  {/ @note }
  {/     The order of dimensions does not depend on how elements are laid }
  {/     out in memory. For example: }
  {/     - for a 2D CNN activations tensor the order is always (n, c) }
  {/     - for a 4D CNN activations tensor the order is always (n, c, h, w) }
  {/     - for a 5D CNN weights tensor the order is always }
  {/        (g, oc, ic, kh, kw) }
  {/ }
  {/ Example usage: }
  {/ @code }
  {/     int mb = 32, oc = 32, oh = 14, ow = 14; // convolution output params }
  {/     float scales[oc] =  ... ; // unique output scales per output channel }
  {/     int oc_dim = 1; // mb_dim = 0, channel_dim = 1, height_dim = 2, ... }
  {/ }
  {/     dnnl_convolution_desc_t conv_d; // create a convolution descriptor }
  {/ }
  {/     dnnl_primitive_attr_t attr; }
  {/     dnnl_primitive_attr_create(&attr); // create primitive attributes }
  {/     dnnl_primitive_attr_set_output_scales(attr, oc, 1 << oc_dim, scales); }
  {/ }
  {/     dnnl_primitive_desc_t conv_pd; }
  {/     dnnl_primitive_desc_create(&conv_pd, &conv_d, attr, engine, NULL); }
  {/ @endcode }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param count Length of the array of scaling factors @p scales. }
  {/ @param mask Scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p scales }
  {/     array. The set i-th bit indicates that a dedicated output scaling }
  {/     factor is used for each index along that dimension. The mask value of }
  {/     0 implies a common output scaling factor for the whole output tensor. }
  {/ @param scales Array of output scaling factors. If the output scaling }
  {/     factors are known at the time of this call, this array must contain @p }
  {/     count values and the following equality must hold: }
  {/     \f[count = \prod\limits_d \in mask output.dims[d].\f] }
  {/     Violations can only be detected when the attributes are used to create }
  {/     a primitive descriptor. }
  {/     If the output scaling factors are not known at the time of the call, }
  {/     this array must contain a single #DNNL_RUNTIME_F32_VAL value and the }
  {/     output scaling factors must be passed at execution time as an argument }
  {/     with index #DNNL_ARG_ATTR_OUTPUT_SCALES. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_set_output_scales(attr:dnnl_primitive_attr_t; count:dnnl_dim_t; mask:longint; scales:Psingle):dnnl_status_t;cdecl;external;

  {/ Returns primitive attributes scaling factors correspondence mask and values }
  {/ for a given memory argument. }
  {/ }
  {/ @warning }
  {/     The output @p scales array is an internal part of the primitive }
  {/     attributes @p attr, so it is an error to modify or destroy the @p }
  {/     scales array. }
  {/ }
  {/ @warning }
  {/     The lifetime of the @p scales array is the same as that of the primitive }
  {/     attributes @p attr to which it belongs, so it is an error to use @p }
  {/     scales after @p attr is destroyed. }
  {/ }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param arg Parameter argument index as passed to the }
  {/     dnnl_primitive_execute() call. }
  {/ @param count Output length of the array of scaling factors @p scales. }
  {/ @param mask Output scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales array. The set i-th bit indicates that a dedicated output scaling }
  {/     factor is used for each index along that dimension. The mask value of 0 }
  {/     implies a common scaling factor for the whole output tensor. }
  {/ @param scales Output pointer to a constant array of float scaling factors. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_get_scales(attr:dnnl_primitive_attr_t; arg:longint; count:Pdnnl_dim_t; mask:Plongint; scales:PPsingle):dnnl_status_t;cdecl;external;

  {/ Sets primitive attributes scaling factors for primitive operations for a }
  {/ given memory argument. }
  {/ }
  {/ @sa dnnl_primitive_attr_set_output_scales }
  {/ }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param arg Parameter argument index as passed to the }
  {/     dnnl_primitive_execute() call. }
  {/ @param count Length of the array of scaling factors @p scales. }
  {/ @param mask Scaling factors correspondence mask that defines the }
  {/     correspondence between the tensor dimensions and the @p scales array. }
  {/     The set i-th bit indicates that a dedicated scaling factor is used for }
  {/     each index along that dimension. Set the mask to 0 to use a common }
  {/     scaling factor for the whole output tensor. }
  {/ @param scales Constant array of float scaling factors. This array must }
  {/     contain @p count scales and the following equality must hold: }
  {/     \f[count = \prod\limits_d \in mask output.dims[d].\f] }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_set_scales(attr:dnnl_primitive_attr_t; arg:longint; count:dnnl_dim_t; mask:longint; scales:Psingle):dnnl_status_t;cdecl;external;

  {/ Returns @p count, correspondence zero point @p mask, and a pointer to a }
  {/ constant int32_t array of @p zero_points for given @p attr and memory }
  {/ argument (index), previously set by dnnl_primitive_attr_set_zero_points. }
  {/ }
  {/ @warning }
  {/     The output @p zero_points array is an internal part of the primitive }
  {/     attributes @p attr, so it is an error to modify or destroy the @p }
  {/     zero_points array. }
  {/ }
  {/ @warning }
  {/     The lifetime of @p zero_points array is the same as that of the }
  {/     primitive attributes @p attr to which it belongs, so it is an error }
  {/     to use @p zero_points after @p attr is destroyed. }
  {/ }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param arg Parameter argument index as passed to the }
  {/     dnnl_primitive_execute() call. }
  {/ @param count Output length of the array of zero points @p zero_points. }
  {/ @param mask Output zero points correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     zero_points array. The set i-th bit indicates that a dedicated output }
  {/     zero point is used for each index along that dimension. The mask }
  {/     value of 0 implies a common zero point for the whole output tensor. }
  {/ @param zero_points Output pointer to a constant array of int32_t zero }
  {/     points. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_get_zero_points(attr:const_dnnl_primitive_attr_t; arg:longint; count:Pdnnl_dim_t; mask:Plongint; zero_points:PPint32_t):dnnl_status_t;cdecl;external;

  {/ Sets primitive attributes zero points for primitive operations for a given }
  {/ memory argument. }
  {/ }
  {/ @sa dnnl_primitive_attr_set_output_scales }
  {/ }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param arg Parameter argument index as passed to the }
  {/     dnnl_primitive_execute() call. }
  {/ @param count Length of the array of zero points @p zero_points. }
  {/ @param mask Zero point correspondence mask that defines the }
  {/     correspondence between the tensor dimensions and the @p }
  {/     zero_points array. The set i-th bit indicates that a dedicated }
  {/     zero point is used for each index along that dimension. Set the }
  {/     mask to 0 to use a common zero point for the whole output tensor. }
  {/ @param zero_points Constant array of int32_t zero points. If the zero }
  {/     points are known at the time of this call, this array must contain @p }
  {/     count zero points and the following equality must hold: }
  {/     \f[count = \prod\limits_d \in mask output.dims[d].\f] }
  {/     If the zero points are not known at the time of the call, this array }
  {/     must contain a single #DNNL_RUNTIME_S32_VAL and the zero points must }
  {/     be passed at execution time as an argument with index }
  {/     #DNNL_ARG_ATTR_ZERO_POINTS. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_set_zero_points(attr:dnnl_primitive_attr_t; arg:longint; count:dnnl_dim_t; mask:longint; zero_points:Pint32_t):dnnl_status_t;cdecl;external;

  {/ Returns primitive attributes post-ops. }
  {/ }
  {/ @warning }
  {/     The output @p post_ops points to the internal @p attr field, so it is }
  {/     an error to modify or destroy them. The lifetime of @p post_ops is }
  {/     the same as that of the @p attr it belongs to, so it is an error to }
  {/     use @p post_ops after @p attr has been destroyed. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param post_ops Output post-ops. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_get_post_ops(attr:const_dnnl_primitive_attr_t; post_ops:Pconst_dnnl_post_ops_t):dnnl_status_t;cdecl;external;

  {/ Sets primitive attributes post-ops. }
  {/ }
  {/ @note }
  {/     There is no way to check whether the post-ops would be supported by }
  {/     the target primitive. Any error will be reported by the }
  {/     dnnl_primitive_desc_create() function call. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param post_ops Post-ops to set. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_set_post_ops(attr:dnnl_primitive_attr_t; post_ops:const_dnnl_post_ops_t):dnnl_status_t;cdecl;external;

  {/ Creates empty post-ops sequence. }
  {/ }
  {/ @param post_ops Output post-ops. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_post_ops_create(post_ops:Pdnnl_post_ops_t):dnnl_status_t;cdecl;external;

  {/ Destroys post-ops. }
  {/ }
  {/ @param post_ops Post-ops to destroy. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_post_ops_destroy(post_ops:dnnl_post_ops_t):dnnl_status_t;cdecl;external;

  {/ Returns the length of post-ops. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @returns The number of post-ops entries. }
  function dnnl_post_ops_len(post_ops:const_dnnl_post_ops_t):longint;cdecl;external;

  {/ Returns the kind of a post-op entry. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Post-op entry index. }
  {/ @returns The kind of the post-op with the specified index. }
  {/ @returns #dnnl_undefined_primitive if there is no post-op at the specified }
  {/     index. }
  function dnnl_post_ops_get_kind(post_ops:const_dnnl_post_ops_t; index:longint):dnnl_primitive_kind_t;cdecl;external;

  {/ Appends an accumulation (sum) to post-ops. Prior to accumulating the }
  {/ result, the previous value is multiplied by a scale. }
  {/ }
  {/ The kind of this post-op is #dnnl_sum. }
  {/ }
  {/ This feature may improve performance for cases like residual learning }
  {/ blocks, where the result of convolution is accumulated to the previously }
  {/ computed activations. The parameter @p scale may be used for the }
  {/ integer-based computations when the result and previous activations have }
  {/ different logical scaling factors. }
  {/ }
  {/ In the simplest case where the accumulation is the only post-op, the }
  {/ computations will be: }
  {/ }
  {/     dst[:] <- scale * dst[:] + op(...) // instead of dst[:] <- op(...) }
  {/ }
  {/ @note }
  {/     This post-op executes in-place and does not change the }
  {/     destination layout. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param scale Accumulation scaling factor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_post_ops_append_sum(post_ops:dnnl_post_ops_t; scale:single):dnnl_status_t;cdecl;external;

  {/ Appends an accumulation v2 (sum) to post-ops. Prior to accumulating the }
  {/ result, the previous value is multiplied by a scale. }
  {/ }
  {/ The kind of this post-op is #dnnl_sum. }
  {/ }
  {/ This feature may improve performance for cases like residual learning }
  {/ blocks, where the result of convolution is accumulated to the previously }
  {/ computed activations. The parameter @p scale may be used for the }
  {/ integer-based computations when the result and previous activations have }
  {/ different logical scaling factors. }
  {/ }
  {/ In the simplest case where the accumulation is the only post-op, the }
  {/ computations will be: }
  {/ }
  {/     dst[:] <- scale * dst[:] + op(...) // instead of dst[:] <- op(...) }
  {/ }
  {/ If @p data_type is specified, original dst tensor will be reinterpreted }
  {/ as a tensor with provided data type. Since it is reinterpretation, }
  {/ data_type and dst data type should have the same size. }
  {/ As a result, computations will be: }
  {/ }
  {/     dst[:] <- scale * as_data_type(dst[:]) + op(...) }
  {/                                        // instead of dst[:] <- op(...) }
  {/ @note }
  {/     This post-op executes in-place and does not change the }
  {/     destination layout. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param scale Accumulation scaling factor. }
  {/ @param data_type Accumulation data_type. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_post_ops_append_sum_v2(post_ops:dnnl_post_ops_t; scale:single; data_type:dnnl_data_type_t):dnnl_status_t;cdecl;external;

  {/ Appends an accumulation v3 (sum) to post-ops. Prior to accumulating the }
  {/ result, a zero point is subtracted from the previous value and is }
  {/ multiplied by the scale. }
  {/ }
  {/ The kind of this post-op is #dnnl_sum. }
  {/ }
  {/ This feature may improve performance for cases like dequantize the }
  {/ asymmetrically quantized sum's src1 tensor to f32 domain before performing }
  {/ the sum operation by subtracting the @p zero_point before the scaling. }
  {/ }
  {/ In the simplest case where accumulation is the only post-op, the }
  {/ computations will be: }
  {/ }
  {/     dst[:] <- scale * (dst[:] - zero_point) + op(...) }
  {/                                             // instead of dst[:] <- op(...) }
  {/ }
  {/ If @p data_type is specified, original dst tensor will be reinterpreted }
  {/ as a tensor with provided data type. Since it is reinterpretation, }
  {/ data_type and dst data type should have the same size. }
  {/ As a result, computations will be: }
  {/ }
  {/     dst[:] <- scale * (as_data_type(dst[:]) - zero_point) + op(...) }
  {/                                        // instead of dst[:] <- op(...) }
  {/ @note }
  {/     This post-op executes in-place and does not change the }
  {/     destination layout. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param scale Accumulation scaling factor. }
  {/ @param zero_point Single scalar int32_t value of zero point. }
  {/ @param data_type Accumulation data_type. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_post_ops_append_sum_v3(post_ops:dnnl_post_ops_t; scale:single; zero_point:int32_t; data_type:dnnl_data_type_t):dnnl_status_t;cdecl;external;

  {/ Returns the parameters of an accumulation (sum) post-op. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Index of the sum post-op. }
  {/ @param scale Output accumulation scaling factor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  {/ @returns #dnnl_invalid_arguments if @p index does not refer to a sum }
  {/     post-op. }
  function dnnl_post_ops_get_params_sum(post_ops:const_dnnl_post_ops_t; index:longint; scale:Psingle):dnnl_status_t;cdecl;external;

  {/ Returns the parameters of an accumulation (sum) post-op with }
  {/ a data type parameter. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Index of the sum post-op. }
  {/ @param scale Output accumulation scaling factor. }
  {/ @param data_type Data type for accumulation. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_post_ops_get_params_sum_v2(post_ops:const_dnnl_post_ops_t; index:longint; scale:Psingle; data_type:Pdnnl_data_type_t):dnnl_status_t;cdecl;external;

  {/ Returns the parameters of an accumulation (sum) post-op with }
  {/ zero point and data type parameter. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Index of the sum post-op. }
  {/ @param scale Output accumulation scaling factor. }
  {/ @param zero_point Zero point. }
  {/ @param data_type Data type for accumulation. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_post_ops_get_params_sum_v3(post_ops:const_dnnl_post_ops_t; index:longint; scale:Psingle; zero_point:Pint32_t; data_type:Pdnnl_data_type_t):dnnl_status_t;cdecl;external;

  {/ Appends an elementwise post-op. }
  {/ }
  {/ The kind of this post operation is #dnnl_eltwise. }
  {/ }
  {/ In the simplest case when the elementwise is the only post operation, the }
  {/ computations would be: }
  {/ }
  {/     dst[:] <- scale * eltwise_op (op(...)) // instead of dst[:] <- op(...) }
  {/ }
  {/ where eltwise_op is configured with the given parameters. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param scale Scaling factor. }
  {/ @param alg_kind Elementwise algorithm for the post-op. }
  {/ @param alpha Alpha parameter for the elementwise algorithm. }
  {/ @param beta Beta parameter for the elementwise algorithm. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_post_ops_append_eltwise(post_ops:dnnl_post_ops_t; scale:single; alg_kind:dnnl_alg_kind_t; alpha:single; beta:single):dnnl_status_t;cdecl;external;

  {/ Returns the parameters of an elementwise post-op. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Index of the elementwise post-op. }
  {/ @param scale Output scaling factor. }
  {/ @param alg_kind Output elementwise algorithm kind. }
  {/ @param alpha Output alpha parameter for the elementwise algorithm. }
  {/ @param beta Output beta parameter for the elementwise algorithm. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  {/ @returns #dnnl_invalid_arguments if @p index does not refer to an }
  {/     elementwise post-op. }
  function dnnl_post_ops_get_params_eltwise(post_ops:const_dnnl_post_ops_t; index:longint; scale:Psingle; alg_kind:Pdnnl_alg_kind_t; alpha:Psingle; 
             beta:Psingle):dnnl_status_t;cdecl;external;

  {/ Appends a depthwise post-op convolution with stride 1. }
  {/ }
  {/ This post-op can only be fused with a 2D 1x1 convolution (convolution with }
  {/ weights spatial dimension equal to 1 i.e., kh=kw=1). }
  {/ }
  {/ The kind of this post-op is #dnnl_convolution. }
  {/ }
  {/ The number of outputs for primitive remain same as before. The output size }
  {/ remain same as the original primitive due to stride=1. }
  {/ }
  {/ The Post-op can be defined as: }
  {/ }
  {/      dst[:] <- scales * (conv_dw(conv_1x1)) }
  {/ }
  {/ See @ref dev_guide_attributes_post_ops_depthwise and }
  {/ @ref dev_guide_attributes_post_ops_depthwise_fusion for more info. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param weights_data_type Weights data type of depthwise post-op }
  {/ @param bias_data_type Bias data type of depthwise post-op }
  {/ @param dst_data_type Output data type of depthwise post-op }
  {/ @param count Output length of the array of scaling factors @p scales. }
  {/ @param mask Output scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales array. The set i-th bit indicates that a dedicated output scaling }
  {/     factor is used for each index along that dimension. The mask value of 0 }
  {/     implies a common scaling factor for the whole output tensor. }
  {/ @param scales Output pointer to a constant array of float scaling factors. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise }
(* Const before type ignored *)
  function dnnl_post_ops_append_dw_k3s1p1(post_ops:dnnl_post_ops_t; weights_data_type:dnnl_data_type_t; bias_data_type:dnnl_data_type_t; dst_data_type:dnnl_data_type_t; count:dnnl_dim_t; 
             mask:longint; scales:Psingle):dnnl_status_t;cdecl;external;

  {/ Returns the parameters of an depthwise post-op with stride 1. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Index of the elementwise post-op. }
  {/ @param weights_data_type Weights data type of depthwise post-op }
  {/ @param bias_data_type Bias data type of depthwise post-op }
  {/ @param dst_data_type Output data type of depthwise post-op }
  {/ @param count Output length of the array of scaling factors @p scales. }
  {/ @param mask Output scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales array. The set i-th bit indicates that a dedicated output scaling }
  {/     factor is used for each index along that dimension. The mask value of 0 }
  {/     implies a common scaling factor for the whole output tensor. }
  {/ @param scales Output pointer to a constant array of float scaling factors. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise }
(* Const before type ignored *)
  function dnnl_post_ops_get_params_dw_k3s1p1(post_ops:const_dnnl_post_ops_t; index:longint; weights_data_type:Pdnnl_data_type_t; bias_data_type:Pdnnl_data_type_t; dst_data_type:Pdnnl_data_type_t; 
             count:Pdnnl_dim_t; mask:Plongint; scales:PPsingle):dnnl_status_t;cdecl;external;

  {/ Appends a depthwise post-op convolution with stride 2. }
  {/ }
  {/ This post-op can only be fused with a 2D 1x1 convolution (convolution with }
  {/ weights spatial dimension equal to 1 i.e., kh=kw=1). }
  {/ }
  {/ The kind of this post-op is #dnnl_convolution. }
  {/ }
  {/ The number of outputs for primitive remain same as before. The output }
  {/ spatial size can be derived as below: }
  {/ }
  {/ output_height = ceil(output_height_1x1_convolution, stride) }
  {/ output_width = ceil(output_width_1x1_convolution, stride) }
  {/ }
  {/ The Post-op can be defined as: }
  {/ }
  {/      dst[:] <- scales * (conv_dw(conv_1x1)) }
  {/ }
  {/ See @ref dev_guide_attributes_post_ops_depthwise and }
  {/ @ref dev_guide_attributes_post_ops_depthwise_fusion for more info. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param weights_data_type Weights data type of depthwise post-op }
  {/ @param bias_data_type Bias data type of depthwise post-op }
  {/ @param dst_data_type Output data type of depthwise post-op }
  {/ @param count Output length of the array of scaling factors @p scales. }
  {/ @param mask Output scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales array. The set i-th bit indicates that a dedicated output scaling }
  {/     factor is used for each index along that dimension. The mask value of 0 }
  {/     implies a common scaling factor for the whole output tensor. }
  {/ @param scales Output pointer to a constant array of float scaling factors. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise }
(* Const before type ignored *)
  function dnnl_post_ops_append_dw_k3s2p1(post_ops:dnnl_post_ops_t; weights_data_type:dnnl_data_type_t; bias_data_type:dnnl_data_type_t; dst_data_type:dnnl_data_type_t; count:dnnl_dim_t; 
             mask:longint; scales:Psingle):dnnl_status_t;cdecl;external;

  {/ Returns the parameters of an depthwise post-op with stride 2. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Index of the elementwise post-op. }
  {/ @param weights_data_type Weights data type of depthwise post-op }
  {/ @param bias_data_type Bias data type of depthwise post-op }
  {/ @param dst_data_type Output data type of depthwise post-op }
  {/ @param count Output length of the array of scaling factors @p scales. }
  {/ @param mask Output scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales array. The set i-th bit indicates that a dedicated output scaling }
  {/     factor is used for each index along that dimension. The mask value of 0 }
  {/     implies a common scaling factor for the whole output tensor. }
  {/ @param scales Output pointer to a constant array of float scaling factors. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise }
(* Const before type ignored *)
  function dnnl_post_ops_get_params_dw_k3s2p1(post_ops:const_dnnl_post_ops_t; index:longint; weights_data_type:Pdnnl_data_type_t; bias_data_type:Pdnnl_data_type_t; dst_data_type:Pdnnl_data_type_t; 
             count:Pdnnl_dim_t; mask:Plongint; scales:PPsingle):dnnl_status_t;cdecl;external;

  {/ Appends a binary post-op. }
  {/ }
  {/ The kind of this post operation is #dnnl_binary. }
  {/ }
  {/ In the simplest case when the binary is the only post operation, the }
  {/ computations would be: }
  {/ }
  {/     dst[:] <- binary_op (dst[:], another_input[:]) }
  {/ }
  {/ where binary_op is configured with the given parameters. binary_op supports }
  {/ broadcast semantics for a second operand. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param alg_kind Binary algorithm for the post-op. }
  {/ @param src1_desc Memory descriptor of a second operand. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_post_ops_append_binary(post_ops:dnnl_post_ops_t; alg_kind:dnnl_alg_kind_t; src1_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ Returns the parameters of a binary post-op. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Index of the binary post-op. }
  {/ @param alg_kind Output binary algorithm kind. }
  {/ @param src1_desc Output memory descriptor of a second operand. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  {/ @returns #dnnl_invalid_arguments if @p index does not refer to a binary }
  {/     post-op. }
(* Const before type ignored *)
  function dnnl_post_ops_get_params_binary(post_ops:const_dnnl_post_ops_t; index:longint; alg_kind:Pdnnl_alg_kind_t; src1_desc:PPdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ Appends a prelu forward post-op. }
  {/ }
  {/ The kind of this post-op is #dnnl::primitive::kind::prelu. }
  {/ }
  {/ The post-op can be defined as: }
  {/ }
  {/      dst[:] <- prelu(dst[:], weights[:]) }
  {/      prelu: }
  {/      dst[:] <- dst[:] if dst[:] > 0 }
  {/      dst[:] <- dst[:] * weights[:] if dst[:] <= 0 }
  {/ }
  {/ }
  {/ @note }
  {/     The order of dimensions does not depend on how elements are laid }
  {/     out in memory. For example: }
  {/     - for a 2D CNN activations tensor the order is always (n, c) }
  {/     - for a 4D CNN activations tensor the order is always (n, c, h, w) }
  {/     - for a 5D CNN weights tensor the order is always }
  {/        (g, oc, ic, kh, kw) }
  {/ }
  {/    Prelu weights tensor is passed in runtime execution phase. Prelu }
  {/    weights tensor data type is implicitly assumed as f32 using plain }
  {/    layout (a, ab, acb, acdb, acdeb) }
  {/ @param mask Defines the correspondence between the output tensor }
  {/     dimensions and the prelu weights tensor. The set i-th bit indicates }
  {/     that a dedicated weights value is used for each index along that }
  {/     dimension. Set the mask to 0 to use a common weights value }
  {/     for the whole output tensor. }
  function dnnl_post_ops_append_prelu(post_ops:dnnl_post_ops_t; mask:longint):dnnl_status_t;cdecl;external;

  {/ Returns the parameters of a prelu post-op. }
  {/ }
  {/ @param post_ops Post-ops. }
  {/ @param index Index of the preu post-op. }
  {/ @param mask Mask of the prelu post-op. }
  function dnnl_post_ops_get_params_prelu(post_ops:const_dnnl_post_ops_t; index:longint; mask:Plongint):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_attributes }
  {/ @ dnnl_api_primitives }
  {/ @addtogroup dnnl_api_memory }
  {/ @ }
  {/ Initializes a memory descriptor using dimensions and strides. }
  {/ }
  {/ @note }
  {/     As always, the logical order of dimensions corresponds to the `abc...` }
  {/     format tag, and the physical meaning of the dimensions depends on both }
  {/     the primitive that consumes the memory and the context of that }
  {/     consumption. }
  {/ }
  {/ @param memory_desc Output memory descriptor. }
  {/ @param ndims Number of dimensions }
  {/ @param dims Array of dimensions. }
  {/ @param data_type Elements data type. }
  {/ @param strides Strides in each dimension. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_memory_desc_init_by_strides(memory_desc:Pdnnl_memory_desc_t; ndims:longint; dims:dnnl_dims_t; data_type:dnnl_data_type_t; strides:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a memory descriptor using dimensions and memory format tag. }
  {/ }
  {/ @note }
  {/     As always, the logical order of dimensions corresponds to the `abc...` }
  {/     format tag, and the physical meaning of the dimensions depends on both }
  {/     the primitive that consumes the memory and the context of that }
  {/     consumption. }
  {/ }
  {/ @param memory_desc Output memory descriptor. }
  {/ @param ndims Number of dimensions }
  {/ @param dims Array of dimensions. }
  {/ @param data_type Elements data type. }
  {/ @param tag Memory format tag. Can be #dnnl_format_tag_any which would }
  {/     allow a primitive to chose the final memory format. In this case the }
  {/     format_kind field of the memory descriptor would be set to }
  {/     #dnnl_format_kind_any. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_memory_desc_init_by_tag(memory_desc:Pdnnl_memory_desc_t; ndims:longint; dims:dnnl_dims_t; data_type:dnnl_data_type_t; tag:dnnl_format_tag_t):dnnl_status_t;cdecl;external;

  {/ Initializes a memory descriptor for a region inside an area }
  {/ described by an existing memory descriptor. }
  {/ }
  {/ @warning }
  {/     Some combinations of physical memory layout and/or offsets or dims may }
  {/     result in a failure to create a submemory. }
  { }
  {/ @param memory_desc Output memory descriptor. }
  {/ @param parent_memory_desc An existing memory descriptor. }
  {/ @param dims Sizes of the region. }
  {/ @param offsets Offsets to the region from the encompassing }
  {/     memory object in each dimension }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_memory_desc_init_submemory(memory_desc:Pdnnl_memory_desc_t; parent_memory_desc:Pdnnl_memory_desc_t; dims:dnnl_dims_t; offsets:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a memory descriptor by reshaping an existing one. The new }
  {/ memory descriptor inherits the data type. This operation is valid only for }
  {/ memory descriptors that have format_kind set to #dnnl_blocked or }
  {/ #dnnl_format_kind_any. }
  {/ }
  {/ The operation ensures the transformation of the physical memory format }
  {/ corresponds to the transformation of the logical dimensions. If such }
  {/ transformation is impossible, the function returns #dnnl_invalid_arguments. }
  {/ }
  {/ The reshape operation can be described as a combination of the following }
  {/ basic operations: }
  {/ 1. Add a dimension of size `1`. This is always possible. }
  {/ 2. Remove a dimension of size `1`. This is possible only if the dimension }
  {/    has no padding (i.e. `padded_dims[dim] == dims[dim] && dims[dim] == 1`). }
  {/ 3. Split a dimension into multiple ones. This is possible only if the size }
  {/    of the dimension is exactly equal to the product of the split ones and }
  {/    the dimension does not have padding (i.e. }
  {/    `padded_dims[dim] = dims[dim]`). }
  {/ 4. Joining multiple consecutive dimensions into a single one. As in the }
  {/    cases above, this requires that the dimensions do not have padding and }
  {/    that the memory format is such that in physical memory these dimensions }
  {/    are dense and have the same order as their logical counterparts. This }
  {/    also assumes that these dimensions are not blocked. }
  {/    - Here, dense means: }
  {/      `stride for dim[i] == (stride for dim[i + 1]) * dim[i + 1]`; }
  {/    - And same order means: }
  {/      `i < j` if and only if `stride for dim[j] <= stride for dim[i]`. }
  {/ }
  {/ @warning }
  {/     Some combinations of physical memory layout and/or offsets or }
  {/     dimensions may result in a failure to make a reshape. }
  {/ }
  {/ @param out_memory_desc Output memory descriptor. }
  {/ @param in_memory_desc An existing memory descriptor. Must have format_kind }
  {/     set to #dnnl_blocked or #dnnl_format_kind_any. }
  {/ @param ndims Number of dimensions for the output memory descriptor. }
  {/ @param dims Dimensions for the output memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_memory_desc_reshape(out_memory_desc:Pdnnl_memory_desc_t; in_memory_desc:Pdnnl_memory_desc_t; ndims:longint; dims:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a memory descriptor by permuting axes in an existing one. }
  {/ }
  {/ The physical memory layout representation is adjusted accordingly to }
  {/ maintain the consistency between the logical and physical parts of the }
  {/ memory descriptor. }
  {/ }
  {/ The new memory descriptor inherits the data type. This operation is valid }
  {/ only for memory descriptors that have format_kind set to #dnnl_blocked or }
  {/ #dnnl_format_kind_any. }
  {/ }
  {/ The logical axes will be permuted in the following manner: }
  {/ ``` }
  {/ for (i: 0 .. in_memory_desc->ndims) }
  {/     out_memory_desc->dims[permutation[i]] = in_memory_desc->dims[i]; }
  {/ ``` }
  {/ }
  {/ Example: }
  {/ @code }
  {/     dnnl_memory_desc_t in_md, out_md, expect_out_md; }
  {/ }
  {/     const int permutation[] = 1, 0; // swap the first and the second axes }
  {/ }
  {/     dnnl_dims_t in_dims = 2, 3, out_dims = 3, 2; }
  {/     dnnl_format_tag_t in_tag = dnnl_ab, out_tag = dnnl_ba; }
  {/ }
  {/     dnnl_memory_desc_init_by_tag( }
  {/             &in_md, 2, in_dims, data_type, in_tag); }
  {/     dnnl_memory_desc_init_by_tag( }
  {/             &expect_out_md, 2, out_dims, data_type, out_tag); }
  {/ }
  {/     dnnl_memory_desc_permute_axes(&out_md, in_md, permutation); }
  {/     assert(dnnl_memory_desc_equal(&out_md, &expect_out_md)); }
  {/ @endcode }
  {/ }
  {/ @param out_memory_desc Output memory descriptor. }
  {/ @param in_memory_desc An existing memory descriptor. Must have format_kind }
  {/     set to #dnnl_blocked or #dnnl_format_kind_any. }
  {/ @param permutation Axes permutation (of size `in_memory_desc->ndims`). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_memory_desc_permute_axes(out_memory_desc:Pdnnl_memory_desc_t; in_memory_desc:Pdnnl_memory_desc_t; permutation:Plongint):dnnl_status_t;cdecl;external;

  {/ Compares two memory descriptors. }
  {/ }
  {/ Use this function to identify whether a reorder is required between the }
  {/ two memories }
  {/ }
  {/ @param lhs Left-hand side of the comparison. }
  {/ @param rhs Right-hand side of the comparison. }
  {/ @returns 1 if the descriptors are the same. }
  {/ @returns 0 if the descriptors are different. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_memory_desc_equal(lhs:Pdnnl_memory_desc_t; rhs:Pdnnl_memory_desc_t):longint;cdecl;external;

  {/ Returns the size of a memory descriptor. }
  {/ }
  {/ @param memory_desc Memory descriptor. }
  {/ @returns The number of bytes required for memory described by a memory }
  {/     descriptor. }
(* Const before type ignored *)
  function dnnl_memory_desc_get_size(memory_desc:Pdnnl_memory_desc_t):size_t;cdecl;external;

  {/ Returns the size of data type. }
  {/ }
  {/ @param data_type Data type. }
  {/ @returns The number of bytes occupied by data type. }
  function dnnl_data_type_size(data_type:dnnl_data_type_t):size_t;cdecl;external;

  {/ Creates a memory object. }
  {/ }
  {/ Unless @p handle is equal to DNNL_MEMORY_NONE, the constructed memory }
  {/ object will have the underlying buffer set. In this case, the buffer will }
  {/ be initialized as if dnnl_memory_set_data_handle() had been called. }
  {/ }
  {/ @sa dnnl_memory_set_data_handle() }
  {/ }
  {/ @param memory Output memory object. }
  {/ @param memory_desc Memory descriptor. }
  {/ @param engine Engine to use. }
  {/ @param handle Handle of the memory buffer to use as an underlying storage. }
  {/     - A pointer to the user-allocated buffer. In this case the library }
  {/       doesn't own the buffer. }
  {/     - The DNNL_MEMORY_ALLOCATE special value. Instructs the library to }
  {/       allocate the buffer for the memory object. In this case the library }
  {/       owns the buffer. }
  {/     - DNNL_MEMORY_NONE to create dnnl_memory without an underlying buffer. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_memory_create(memory:Pdnnl_memory_t; memory_desc:Pdnnl_memory_desc_t; engine:dnnl_engine_t; handle:pointer):dnnl_status_t;cdecl;external;

  {/ Returns the memory descriptor for a memory object. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param memory_desc Output memory descriptor (a copy). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_memory_get_memory_desc(memory:const_dnnl_memory_t; memory_desc:PPdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ Returns the engine of a memory object. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param engine Output engine on which the memory is located. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_memory_get_engine(memory:const_dnnl_memory_t; engine:Pdnnl_engine_t):dnnl_status_t;cdecl;external;

  {/ Maps a memory object and returns a host-side pointer to a memory buffer }
  {/ with a copy of its contents. }
  {/ }
  {/ Mapping enables explicit direct access to memory contents for the engines }
  {/ that do not support it implicitly. }
  {/ }
  {/ Mapping is an exclusive operation - a memory object cannot be used in }
  {/ other operations until this memory object is unmapped. }
  {/ }
  {/ @note }
  {/     Any primitives working with @p memory should be completed before }
  {/     the memory is mapped. Use dnnl_stream_wait to synchronize the }
  {/     corresponding execution stream. }
  {/ }
  {/ @note }
  {/     The dnnl_memory_map_data() and dnnl_memory_unmap_data() functions are }
  {/     mainly provided for debug and testing purposes, and their performance }
  {/     may be suboptimal. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param mapped_ptr Output pointer to the mapped buffer. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_memory_map_data(memory:const_dnnl_memory_t; mapped_ptr:Ppointer):dnnl_status_t;cdecl;external;

  {/ Unmaps a memory object and writes back any changes made to the previously }
  {/ mapped memory buffer. The pointer to the mapped buffer must be obtained }
  {/ via the dnnl_memory_map_data() call. }
  {/ }
  {/ @note }
  {/     The dnnl_memory_map_data() and dnnl_memory_unmap_data() functions are }
  {/     mainly provided for debug and testing purposes, and their performance }
  {/     may be suboptimal. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param mapped_ptr Pointer to the mapped buffer that must have been }
  {/     obtained using the dnnl_memory_map_data() function. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_memory_unmap_data(memory:const_dnnl_memory_t; mapped_ptr:pointer):dnnl_status_t;cdecl;external;

  {/ Returns memory object's data handle. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param handle Output data handle. For the CPU engine, the data handle is a }
  {/     pointer to the actual data. For OpenCL it is a cl_mem. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_memory_get_data_handle(memory:const_dnnl_memory_t; handle:Ppointer):dnnl_status_t;cdecl;external;

  {/ Sets the underlying memory buffer. }
  {/ }
  {/ See the description of dnnl_memory_set_data_handle_v2() for more details. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param handle Data handle. For the CPU engine, the data handle is a }
  {/     pointer to the actual data. For OpenCL it is a `cl_mem`. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_memory_set_data_handle(memory:dnnl_memory_t; handle:pointer):dnnl_status_t;cdecl;external;

  {/ Sets the underlying memory buffer. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param handle Data handle. For the CPU engine, the data handle is a }
  {/     pointer to the actual data. For OpenCL it is a `cl_mem`. }
  {/ @param stream Stream to use to execute padding in. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_memory_set_data_handle_v2(memory:dnnl_memory_t; handle:pointer; stream:dnnl_stream_t):dnnl_status_t;cdecl;external;

  {/ Destroys a memory object. }
  {/ }
  {/ @param memory Memory object to destroy. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_memory_destroy(memory:dnnl_memory_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_memory }
  {/ @addtogroup dnnl_api_primitives }
  {/ @ }
  {/ @addtogroup dnnl_api_reorder }
  {/ @ }
  {/ Creates a primitive descriptor for a reorder primitive. }
  {/ }
  {/ @param reorder_primitive_desc Output primitive descriptor. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param src_engine Engine on which the source memory object will be }
  {/     located. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param dst_engine Engine on which the destination memory object }
  {/     will be located. }
  {/ @param attr Primitive attributes to use (can be NULL). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_reorder_primitive_desc_create(reorder_primitive_desc:Pdnnl_primitive_desc_t; src_desc:Pdnnl_memory_desc_t; src_engine:dnnl_engine_t; dst_desc:Pdnnl_memory_desc_t; dst_engine:dnnl_engine_t; 
             attr:const_dnnl_primitive_attr_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_reorder }
  {/ @addtogroup dnnl_api_concat }
  {/ @ }
  {/ Creates a primitive descriptor for an out-of-place concatenation }
  {/ primitive. }
  {/ }
  {/ @param concat_primitive_desc Output primitive descriptor. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param n Number of source parameters. }
  {/ @param concat_dimension Source tensors will be concatenated over }
  {/     dimension with this index. Note that order of dimensions does }
  {/     not depend on memory format. }
  {/ @param src_descs Array of source memory descriptors with @p n elements. }
  {/ @param attr Primitive attributes to use (can be NULL). }
  {/ @param engine Engine to use. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_concat_primitive_desc_create(concat_primitive_desc:Pdnnl_primitive_desc_t; dst_desc:Pdnnl_memory_desc_t; n:longint; concat_dimension:longint; src_descs:Pdnnl_memory_desc_t; 
             attr:const_dnnl_primitive_attr_t; engine:dnnl_engine_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_concat }
  {/ @addtogroup dnnl_api_sum }
  {/ @ }
  {/ Creates a primitive descriptor for an (out-of-place) sum primitive. }
  {/ }
  {/ @param sum_primitive_desc Output primitive descriptor. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param n Number of source parameters. }
  {/ @param scales Vector of scales to multiply data in each source }
  {/     memory by. }
  {/ @param src_descs Array of source memory descriptors having @p n elements. }
  {/ @param attr Primitive attributes to use (can be NULL). }
  {/ @param engine Engine to use. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_sum_primitive_desc_create(sum_primitive_desc:Pdnnl_primitive_desc_t; dst_desc:Pdnnl_memory_desc_t; n:longint; scales:Psingle; src_descs:Pdnnl_memory_desc_t; 
             attr:const_dnnl_primitive_attr_t; engine:dnnl_engine_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_sum }
  {/ @addtogroup dnnl_api_binary }
  {/ @ }
  {/ Initializes a descriptor for a binary primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptor @p dst_desc is allowed to be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @note }
  {/     Both memory descriptors must have the same number of dimensions. }
  {/     Element broadcasting is supported for memory descriptor @p src1_desc }
  {/     and are applied to @ src1_desc dimensions that have size equal to 1. }
  {/ }
  {/ @param binary_desc Output descriptor for a binary primitive. }
  {/ @param alg_kind Algorithm kind. Valid values are #dnnl_binary_add, }
  {/     #dnnl_binary_mul, #dnnl_binary_max, #dnnl_binary_min, #dnnl_binary_div, }
  {/     #dnnl_binary_sub, #dnnl_binary_ge, #dnnl_binary_gt, #dnnl_binary_le, }
  {/     #dnnl_binary_lt, #dnnl_binary_eq and #dnnl_binary_ne. }
  {/ @param src0_desc Source 0 memory descriptor. }
  {/ @param src1_desc Source 1 memory descriptor. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_binary_desc_init(binary_desc:Pdnnl_binary_desc_t; alg_kind:dnnl_alg_kind_t; src0_desc:Pdnnl_memory_desc_t; src1_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_binary }
  {/ @addtogroup dnnl_api_convolution }
  {/ @ }
  {/ Initializes a descriptor for a convolution forward propagation primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p padding_l, and @p padding_r contain values for }
  {/ spatial dimensions only and hence must have the same number of elements as }
  {/ there are spatial dimensions. The order of values is the same as in the }
  {/ tensor: depth (for 3D tensors), height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param conv_desc Output descriptor for a convolution primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind Convolution algorithm. Possible values are }
  {/     #dnnl_convolution_direct, #dnnl_convolution_winograd, }
  {/     #dnnl_convolution_auto. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param bias_desc Bias memory descriptor. Passing NULL, a zero memory }
  {/     descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is assumed to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_convolution_forward_desc_init(conv_desc:Pdnnl_convolution_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; 
             bias_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a dilated convolution forward propagation }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p dilates, @p padding_l, and @p padding_r contain }
  {/ values for spatial dimensions only and hence must have the same number of }
  {/ elements as there are spatial dimensions. The order of values is the same }
  {/ as in the tensor: depth (for 3D tensors), height (for 3D and 2D tensors), }
  {/ and width. }
  {/ }
  {/ @param conv_desc Output descriptor for a convolution primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind Convolution algorithm. Possible values are }
  {/     #dnnl_convolution_direct, #dnnl_convolution_winograd, }
  {/     #dnnl_convolution_auto. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param bias_desc Bias memory descriptor. Passing NULL, a zero memory }
  {/     descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param dilates Array of dilations for spatial dimension. A zero value }
  {/     means no dilation in the corresponding dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_dilated_convolution_forward_desc_init(conv_desc:Pdnnl_convolution_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; 
             bias_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; dilates:dnnl_dims_t; padding_l:dnnl_dims_t; 
             padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a convolution backward propagation primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p padding_l, and @p padding_r contain values for }
  {/ spatial dimensions only and hence must have the same number of elements as }
  {/ there are spatial dimensions. The order of values is the same as in the }
  {/ tensor: depth (for 3D tensors), height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param conv_desc Output descriptor for a convolution primitive. }
  {/ @param alg_kind Convolution algorithm. Possible values are }
  {/     #dnnl_convolution_direct, #dnnl_convolution_winograd, }
  {/     #dnnl_convolution_auto. }
  {/ @param diff_src_desc Diff source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is assumed to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_convolution_backward_data_desc_init(conv_desc:Pdnnl_convolution_desc_t; alg_kind:dnnl_alg_kind_t; diff_src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t; 
             strides:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a dilated convolution backward propagation }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p dilates, @p padding_l, and @p padding_r contain }
  {/ values for spatial dimensions only and hence must have the same number of }
  {/ elements as there are spatial dimensions. The order of values is the same }
  {/ as in the tensor: depth (for 3D tensors), height (for 3D and 2D tensors), }
  {/ and width. }
  {/ }
  {/ @param conv_desc Output descriptor for a convolution primitive. }
  {/ @param alg_kind Convolution algorithm. Possible values are }
  {/     #dnnl_convolution_direct, #dnnl_convolution_winograd, }
  {/     #dnnl_convolution_auto. }
  {/ @param diff_src_desc Diff source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param dilates Array of dilations for spatial dimension. A zero value }
  {/     means no dilation in the corresponding dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_dilated_convolution_backward_data_desc_init(conv_desc:Pdnnl_convolution_desc_t; alg_kind:dnnl_alg_kind_t; diff_src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t; 
             strides:dnnl_dims_t; dilates:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a convolution weights gradient primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p padding_l, and @p padding_r contain values for }
  {/ spatial dimensions only and hence must have the same number of elements as }
  {/ there are spatial dimensions. The order of values is the same as in the }
  {/ tensor: depth (for 3D tensors), height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param conv_desc Output descriptor for a convolution primitive. }
  {/ @param alg_kind Convolution algorithm. Possible values are }
  {/     #dnnl_convolution_direct, #dnnl_convolution_winograd, }
  {/     #dnnl_convolution_auto. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param diff_weights_desc Diff weights memory descriptor. }
  {/ @param diff_bias_desc Diff bias memory descriptor. Passing NULL, a zero }
  {/     memory descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_convolution_backward_weights_desc_init(conv_desc:Pdnnl_convolution_desc_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; diff_weights_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; 
             diff_dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a dilated convolution weights gradient }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p dilates, @p padding_l, and @p padding_r contain }
  {/ values for spatial dimensions only and hence must have the same number of }
  {/ elements as there are spatial dimensions. The order of values is the same }
  {/ as in the tensor: depth (for 3D tensors), height (for 3D and 2D tensors), }
  {/ and width. }
  {/ }
  {/ @param conv_desc Output descriptor for a convolution primitive. }
  {/ @param alg_kind Convolution algorithm. Possible values are }
  {/     #dnnl_convolution_direct, #dnnl_convolution_winograd, }
  {/     #dnnl_convolution_auto. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param diff_weights_desc Diff weights memory descriptor. }
  {/ @param diff_bias_desc Diff bias memory descriptor. Passing NULL, a zero }
  {/     memory descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param dilates Array of dilations for spatial dimension. A zero value }
  {/     means no dilation in the corresponding dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_dilated_convolution_backward_weights_desc_init(conv_desc:Pdnnl_convolution_desc_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; diff_weights_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; 
             diff_dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; dilates:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_convolution }
  {/ @addtogroup dnnl_api_deconvolution }
  {/ @ }
  {/ Initializes a descriptor for a deconvolution forward propagation primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p padding_l, and @p padding_r contain values for }
  {/ spatial dimensions only and hence must have the same number of elements as }
  {/ there are spatial dimensions. The order of values is the same as in the }
  {/ tensor: depth (for 3D tensors), height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param deconv_desc Output descriptor for a deconvolution primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind Deconvolution algorithm. Possible values are }
  {/     #dnnl_deconvolution_direct, #dnnl_deconvolution_winograd. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param bias_desc Bias memory descriptor. Passing NULL, a zero memory }
  {/     descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_deconvolution_forward_desc_init(deconv_desc:Pdnnl_deconvolution_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; 
             bias_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a dilated deconvolution forward propagation }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p dilates, @p padding_l, and @p padding_r contain }
  {/ values for spatial dimensions only and hence must have the same number of }
  {/ elements as there are spatial dimensions. The order of values is the same }
  {/ as in the tensor: depth (for 3D tensors), height (for 3D and 2D tensors), }
  {/ and width. }
  {/ }
  {/ @param deconv_desc Output descriptor for a deconvolution primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind Deconvolution algorithm. Possible values are }
  {/     #dnnl_deconvolution_direct, #dnnl_deconvolution_winograd. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param bias_desc Bias memory descriptor. Passing NULL, a zero memory }
  {/     descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param dilates Array of dilations for spatial dimension. A zero value }
  {/     means no dilation in the corresponding dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_dilated_deconvolution_forward_desc_init(deconv_desc:Pdnnl_deconvolution_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; 
             bias_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; dilates:dnnl_dims_t; padding_l:dnnl_dims_t; 
             padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a deconvolution backward propagation primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p padding_l, and @p padding_r contain values for }
  {/ spatial dimensions only and hence must have the same number of elements as }
  {/ there are spatial dimensions. The order of values is the same as in the }
  {/ tensor: depth (for 3D tensors), height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param deconv_desc Output descriptor for a deconvolution primitive. }
  {/ @param alg_kind Deconvolution algorithm. Possible values are }
  {/     #dnnl_deconvolution_direct, #dnnl_deconvolution_winograd. }
  {/ @param diff_src_desc Diff source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_deconvolution_backward_data_desc_init(deconv_desc:Pdnnl_deconvolution_desc_t; alg_kind:dnnl_alg_kind_t; diff_src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t; 
             strides:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a dilated deconvolution backward propagation }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p dilates, @p padding_l, and @p padding_r contain }
  {/ values for spatial dimensions only and hence must have the same number of }
  {/ elements as there are spatial dimensions. The order of values is the same }
  {/ as in the tensor: depth (for 3D tensors), height (for 3D and 2D tensors), }
  {/ and width. }
  {/ }
  {/ @param deconv_desc Output descriptor for a deconvolution primitive. }
  {/ @param alg_kind Deconvolution algorithm. Possible values are }
  {/     #dnnl_deconvolution_direct, #dnnl_deconvolution_winograd. }
  {/ @param diff_src_desc Diff source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param dilates Array of dilations for spatial dimension. A zero value }
  {/     means no dilation in the corresponding dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_dilated_deconvolution_backward_data_desc_init(deconv_desc:Pdnnl_deconvolution_desc_t; alg_kind:dnnl_alg_kind_t; diff_src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t; 
             strides:dnnl_dims_t; dilates:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a deconvolution weights gradient primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p padding_l, and @p padding_r contain values for }
  {/ spatial dimensions only and hence must have the same number of elements as }
  {/ there are spatial dimensions. The order of values is the same as in the }
  {/ tensor: depth (for 3D tensors), height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param deconv_desc Output descriptor for a deconvolution primitive. }
  {/ @param alg_kind Deconvolution algorithm. Possible values are }
  {/     #dnnl_deconvolution_direct, #dnnl_deconvolution_winograd. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param diff_weights_desc Diff weights memory descriptor. }
  {/ @param diff_bias_desc Diff bias memory descriptor. Passing NULL, a zero }
  {/     memory descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_deconvolution_backward_weights_desc_init(deconv_desc:Pdnnl_deconvolution_desc_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; diff_weights_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; 
             diff_dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a dilated deconvolution weights gradient }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ Arrays @p strides, @p dilates, @p padding_l, and @p padding_r contain }
  {/ values for spatial dimensions only and hence must have the same number of }
  {/ elements as there are spatial dimensions. The order of values is the same }
  {/ as in the tensor: depth (for 3D tensors), height (for 3D and 2D tensors), }
  {/ and width. }
  {/ }
  {/ @param deconv_desc Output descriptor for a deconvolution primitive. }
  {/ @param alg_kind Deconvolution algorithm. Possible values are }
  {/     #dnnl_deconvolution_direct, #dnnl_deconvolution_winograd. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param diff_weights_desc Diff weights memory descriptor. }
  {/ @param diff_bias_desc Diff bias memory descriptor. Passing NULL, a zero }
  {/     memory descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param dilates Array of dilations for spatial dimension. A zero value }
  {/     means no dilation in the corresponding dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_dilated_deconvolution_backward_weights_desc_init(deconv_desc:Pdnnl_deconvolution_desc_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; diff_weights_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; 
             diff_dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; dilates:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_deconvolution }
  {/ @addtogroup dnnl_api_shuffle }
  {/ @ }
  {/ Initializes a descriptor for shuffle forward propagation primitive. }
  {/ }
  {/ @param shuffle_desc Output descriptor for a shuffle primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param axis The axis along which the data is shuffled. }
  {/ @param group_size Shuffle group size. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_shuffle_forward_desc_init(shuffle_desc:Pdnnl_shuffle_desc_t; prop_kind:dnnl_prop_kind_t; data_desc:Pdnnl_memory_desc_t; axis:longint; group_size:dnnl_dim_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for shuffle backward propagation primitive. }
  {/ }
  {/ @param shuffle_desc Output descriptor for a shuffle primitive. }
  {/ @param diff_data_desc Diff source and diff destination memory descriptor. }
  {/ @param axis The axis along which the data is shuffled. }
  {/ @param group_size Shuffle group size. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_shuffle_backward_desc_init(shuffle_desc:Pdnnl_shuffle_desc_t; diff_data_desc:Pdnnl_memory_desc_t; axis:longint; group_size:dnnl_dim_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_shuffle }
  {/ @addtogroup dnnl_api_eltwise }
  {/ @ }
  {/ Initializes a descriptor for eltwise forward propagation primitive. }
  {/ }
  {/ @param eltwise_desc Output descriptor for an eltwise primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind Elementwise algorithm kind. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param alpha The alpha parameter for the elementwise operation. Specific }
  {/     meaning depends on the algorithm. }
  {/ @param beta The beta parameter for the elementwise operation. Specific }
  {/     meaning depends on the algorithm. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_eltwise_forward_desc_init(eltwise_desc:Pdnnl_eltwise_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; data_desc:Pdnnl_memory_desc_t; alpha:single; 
             beta:single):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for eltwise backward propagation primitive. }
  {/ }
  {/ @param eltwise_desc Output descriptor for an eltwise primitive. }
  {/ @param alg_kind Elementwise algorithm kind. }
  {/ @param diff_data_desc Diff source and diff destination memory descriptors. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param alpha The alpha parameter for the elementwise operation. Specific }
  {/     meaning depends on the algorithm. }
  {/ @param beta The beta parameter for the elementwise operation. Specific }
  {/     meaning depends on the algorithm. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_eltwise_backward_desc_init(eltwise_desc:Pdnnl_eltwise_desc_t; alg_kind:dnnl_alg_kind_t; diff_data_desc:Pdnnl_memory_desc_t; data_desc:Pdnnl_memory_desc_t; alpha:single; 
             beta:single):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_eltwise }
  {/ @addtogroup dnnl_api_softmax }
  {/ @ }
  {/ Initializes a descriptor for softmax forward propagation primitive. }
  {/ }
  {/ @param softmax_desc Output descriptor for a softmax primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param softmax_axis Axis over which softmax is computed. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_softmax_forward_desc_init(softmax_desc:Pdnnl_softmax_desc_t; prop_kind:dnnl_prop_kind_t; data_desc:Pdnnl_memory_desc_t; softmax_axis:longint):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for softmax backward propagation primitive. }
  {/ }
  {/ @param softmax_desc Output descriptor for a softmax primitive. }
  {/ @param diff_data_desc Diff source and diff destination memory descriptors. }
  {/ @param data_desc Destination memory descriptor. }
  {/ @param softmax_axis Axis over which softmax is computed. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_softmax_backward_desc_init(softmax_desc:Pdnnl_softmax_desc_t; diff_data_desc:Pdnnl_memory_desc_t; data_desc:Pdnnl_memory_desc_t; softmax_axis:longint):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_softmax }
  {/ @addtogroup dnnl_api_logsoftmax }
  {/ @ }
  {/ Initializes a descriptor for logsoftmax forward propagation primitive. }
  {/ }
  {/ @param logsoftmax_desc Output descriptor for a logsoftmax primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param logsoftmax_axis Axis over which logsoftmax is computed. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_logsoftmax_forward_desc_init(logsoftmax_desc:Pdnnl_logsoftmax_desc_t; prop_kind:dnnl_prop_kind_t; data_desc:Pdnnl_memory_desc_t; logsoftmax_axis:longint):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for logsoftmax backward propagation primitive. }
  {/ }
  {/ @param logsoftmax_desc Output descriptor for a logsoftmax primitive. }
  {/ @param diff_data_desc Diff source and diff destination memory descriptors. }
  {/ @param data_desc Destination memory descriptor. }
  {/ @param logsoftmax_axis Axis over which softmax is computed. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_logsoftmax_backward_desc_init(logsoftmax_desc:Pdnnl_logsoftmax_desc_t; diff_data_desc:Pdnnl_memory_desc_t; data_desc:Pdnnl_memory_desc_t; logsoftmax_axis:longint):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_logsoftmax }
  {/ @addtogroup dnnl_api_pooling }
  {/ @ }
  {/ Initializes a descriptor for pooling forward propagation primitive. }
  {/ }
  {/ Arrays @p strides, @p kernel, @p padding_l, and @p padding_r contain values }
  {/ for spatial dimensions only and hence must have the same number of elements }
  {/ as there are spatial dimensions. The order of values is the same as in the }
  {/ tensor: depth (for 3D tensors), height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param pool_desc Output descriptor for a pooling primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind Pooling algorithm kind: either #dnnl_pooling_max, }
  {/     #dnnl_pooling_avg_include_padding, or #dnnl_pooling_avg (same as }
  {/     #dnnl_pooling_avg_exclude_padding). }
  {/ @param src_desc Source memory descriptor. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param kernel Array of kernel spatial dimensions. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_pooling_forward_desc_init(pool_desc:Pdnnl_pooling_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t; 
             strides:dnnl_dims_t; kernel:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for pooling backward propagation primitive. }
  {/ }
  {/ Arrays @p strides, @p kernel, @p padding_l, and @p padding_r contain values }
  {/ for spatial dimensions only and hence must have the same number of elements }
  {/ as there are spatial dimensions. The order of values is the same as in the }
  {/ tensor: depth (for 3D tensors), height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param pool_desc Output descriptor for a pooling primitive. }
  {/ @param alg_kind Pooling algorithm kind: either #dnnl_pooling_max, }
  {/     #dnnl_pooling_avg_include_padding, or #dnnl_pooling_avg (same as }
  {/     #dnnl_pooling_avg_exclude_padding). }
  {/ @param diff_src_desc Diff source memory descriptor. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param kernel Array of kernel spatial dimensions. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_pooling_backward_desc_init(pool_desc:Pdnnl_pooling_desc_t; alg_kind:dnnl_alg_kind_t; diff_src_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; 
             kernel:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_pooling }
  {/ @addtogroup dnnl_api_pooling_v2 }
  {/ @ }
  {/ Initializes a descriptor for pooling v2 (pooling with dilation support) }
  {/ forward propagation primitive. }
  {/ }
  {/ Arrays @p strides, @p kernel, @p dilation, @p padding_l and @p padding_r }
  {/ contain values for spatial dimensions only and hence must have the same }
  {/ number of elements as there are spatial dimensions. The order of values }
  {/ is the same as in the tensor: depth (for 3D tensors), }
  {/ height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param pool_desc Output descriptor for a pooling primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind Pooling algorithm kind: either #dnnl_pooling_max, }
  {/     #dnnl_pooling_avg_include_padding, or #dnnl_pooling_avg (same as }
  {/     #dnnl_pooling_avg_exclude_padding). }
  {/ @param src_desc Source memory descriptor. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param kernel Array of kernel spatial dimensions. }
  {/ @param dilation Array of dilations for spatial dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_pooling_v2_forward_desc_init(pool_desc:Pdnnl_pooling_v2_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t; 
             strides:dnnl_dims_t; kernel:dnnl_dims_t; dilation:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for pooling v2 (pooling with dilation support) }
  {/ backward propagation primitive. }
  {/ }
  {/ Arrays @p strides, @p kernel, @p dilation, @p padding_l and @p padding_r }
  {/ contain values for spatial dimensions only and hence must have the same }
  {/ number of elements as there are spatial dimensions. The order of values }
  {/ is the same as in the tensor: depth (for 3D tensors), }
  {/ height (for 3D and 2D tensors), and width. }
  {/ }
  {/ @param pool_desc Output descriptor for a pooling primitive. }
  {/ @param alg_kind Pooling algorithm kind: either #dnnl_pooling_max, }
  {/     #dnnl_pooling_avg_include_padding, or #dnnl_pooling_avg (same as }
  {/     #dnnl_pooling_avg_exclude_padding). }
  {/ @param diff_src_desc Diff source memory descriptor. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param strides Array of strides for spatial dimension. }
  {/ @param kernel Array of kernel spatial dimensions. }
  {/ @param dilation Array of dilations for spatial dimension. }
  {/ @param padding_l Array of padding values for low indices for each spatial }
  {/     dimension `([[front,] top,] left)`. }
  {/ @param padding_r Array of padding values for high indices for each spatial }
  {/     dimension `([[back,] bottom,] right)`. Can be NULL in which case }
  {/     padding is considered to be symmetrical. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_pooling_v2_backward_desc_init(pool_desc:Pdnnl_pooling_v2_desc_t; alg_kind:dnnl_alg_kind_t; diff_src_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t; strides:dnnl_dims_t; 
             kernel:dnnl_dims_t; dilation:dnnl_dims_t; padding_l:dnnl_dims_t; padding_r:dnnl_dims_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_pooling_v2 }
  {/ @addtogroup dnnl_api_prelu }
  {/ @ }
  {/ Initializes a descriptor for PReLU }
  {/ (leaky ReLU with trainable alpha parameter) }
  {/ forward propagation primitive. }
  {/ }
  {/ @note }
  {/     weights descriptor is allowed to be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param prelu_desc Output descriptor for a prelu primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param weights_desc Alpha parameters memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_prelu_forward_desc_init(prelu_desc:Pdnnl_prelu_desc_t; prop_kind:dnnl_prop_kind_t; data_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for PReLU }
  {/ (leaky ReLU with trainable alpha parameter) }
  {/ backward propagation primitive. }
  {/ }
  {/ @note }
  {/     weights descriptor and diff_weights descriptor are allowed }
  {/     to be initialized with #dnnl_format_tag_any or with format_kind }
  {/     set to #dnnl_format_kind_any. }
  {/ }
  {/ @param prelu_desc Output descriptor for a prelu primitive. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param weights_desc Alpha parameters memory descriptor. }
  {/ @param diff_data_desc Diff source and destination memory descriptor. }
  {/ @param diff_weights_desc Diff alpha parameters memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_prelu_backward_desc_init(prelu_desc:Pdnnl_prelu_desc_t; data_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; diff_data_desc:Pdnnl_memory_desc_t; diff_weights_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_prelu }
  {/ @addtogroup dnnl_api_lrn }
  {/ @ }
  {/ Initializes a descriptor for LRN forward propagation primitive. }
  {/ }
  {/ @param lrn_desc Output descriptor for a LRN primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind LRN algorithm kind: either #dnnl_lrn_across_channels or }
  {/     #dnnl_lrn_within_channel. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param local_size Regularization local size. }
  {/ @param alpha The alpha regularization parameter. }
  {/ @param beta The beta regularization parameter. }
  {/ @param k The k regularization parameter. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_lrn_forward_desc_init(lrn_desc:Pdnnl_lrn_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; data_desc:Pdnnl_memory_desc_t; local_size:dnnl_dim_t; 
             alpha:single; beta:single; k:single):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for LRN backward propagation primitive. }
  {/ }
  {/ @param lrn_desc Output descriptor for a LRN primitive. }
  {/ @param alg_kind LRN algorithm kind: either #dnnl_lrn_across_channels or }
  {/     #dnnl_lrn_within_channel. }
  {/ @param diff_data_desc Diff source and diff destination memory descriptor. }
  {/ @param data_desc Source memory descriptor. }
  {/ @param local_size Regularization local size. }
  {/ @param alpha The alpha regularization parameter. }
  {/ @param beta The beta regularization parameter. }
  {/ @param k The k regularization parameter. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_lrn_backward_desc_init(lrn_desc:Pdnnl_lrn_desc_t; alg_kind:dnnl_alg_kind_t; diff_data_desc:Pdnnl_memory_desc_t; data_desc:Pdnnl_memory_desc_t; local_size:dnnl_dim_t; 
             alpha:single; beta:single; k:single):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_lrn }
  {/ @addtogroup dnnl_api_batch_normalization }
  {/ @ }
  {/ Initializes a descriptor for a batch normalization forward propagation }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     In-place operation is supported: the dst can refer to the same memory }
  {/     as the src. }
  {/ }
  {/ @param bnrm_desc Output descriptor for batch normalization primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param epsilon Batch normalization epsilon parameter. }
  {/ @param flags Batch normalization flags (@ref dnnl_normalization_flags_t). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_batch_normalization_forward_desc_init(bnrm_desc:Pdnnl_batch_normalization_desc_t; prop_kind:dnnl_prop_kind_t; data_desc:Pdnnl_memory_desc_t; epsilon:single; flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a batch normalization backward propagation }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     In-place operation is supported: the diff_dst can refer to the same }
  {/     memory as the diff_src. }
  {/ }
  {/ @param bnrm_desc Output descriptor for batch normalization primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_backward_data and #dnnl_backward (diffs for all parameters are }
  {/     computed in this case). }
  {/ @param diff_data_desc Diff source and diff destination memory descriptor. }
  {/ @param data_desc Source memory descriptor. }
  {/ @param epsilon Batch normalization epsilon parameter. }
  {/ @param flags Batch normalization flags (@ref dnnl_normalization_flags_t). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_batch_normalization_backward_desc_init(bnrm_desc:Pdnnl_batch_normalization_desc_t; prop_kind:dnnl_prop_kind_t; diff_data_desc:Pdnnl_memory_desc_t; data_desc:Pdnnl_memory_desc_t; epsilon:single; 
             flags:dword):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_batch_normalization }
  {/ @addtogroup dnnl_api_layer_normalization }
  {/ @ }
  {/ Initializes a descriptor for layer normalization forward propagation }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     In-place operation is supported: the dst can refer to the same memory }
  {/     as the src. }
  {/ }
  {/ @param lnrm_desc Output descriptor for layer normalization primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param data_desc Source and destination memory descriptor. }
  {/ @param stat_desc Memory descriptor for mean and variance. If this }
  {/     parameter is NULL, a zero memory descriptor, or a memory descriptor }
  {/     with format_kind set to #dnnl_format_kind_undef, then the memory }
  {/     descriptor for stats is derived from @p data_desc by removing the last }
  {/     dimension. }
  {/ @param epsilon Layer normalization epsilon parameter. }
  {/ @param flags Layer normalization flags (@ref dnnl_normalization_flags_t). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_layer_normalization_forward_desc_init(lnrm_desc:Pdnnl_layer_normalization_desc_t; prop_kind:dnnl_prop_kind_t; data_desc:Pdnnl_memory_desc_t; stat_desc:Pdnnl_memory_desc_t; epsilon:single; 
             flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for a layer normalization backward propagation }
  {/ primitive. }
  {/ }
  {/ @note }
  {/     In-place operation is supported: the diff_dst can refer to the same }
  {/     memory as the diff_src. }
  {/ }
  {/ @param lnrm_desc Output descriptor for layer normalization primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_backward_data and #dnnl_backward (diffs for all parameters are }
  {/     computed in this case). }
  {/ @param diff_data_desc Diff source and diff destination memory descriptor. }
  {/ @param data_desc Source memory descriptor. }
  {/ @param stat_desc Memory descriptor for mean and variance. If this }
  {/     parameter is NULL, a zero memory descriptor, or a memory descriptor }
  {/     with format_kind set to #dnnl_format_kind_undef, then the memory }
  {/     descriptor for stats is derived from @p data_desc by removing the last }
  {/     dimension. }
  {/ @param epsilon Layer normalization epsilon parameter. }
  {/ @param flags Layer normalization flags (@ref dnnl_normalization_flags_t). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_layer_normalization_backward_desc_init(lnrm_desc:Pdnnl_layer_normalization_desc_t; prop_kind:dnnl_prop_kind_t; diff_data_desc:Pdnnl_memory_desc_t; data_desc:Pdnnl_memory_desc_t; stat_desc:Pdnnl_memory_desc_t; 
             epsilon:single; flags:dword):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_layer_normalization }
  {/ @addtogroup dnnl_api_inner_product }
  {/ @ }
  {/ Initializes descriptor for inner product forward propagation. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param ip_desc Output descriptor for inner product primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param bias_desc Bias memory descriptor. Passing NULL, a zero memory }
  {/     descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_inner_product_forward_desc_init(ip_desc:Pdnnl_inner_product_desc_t; prop_kind:dnnl_prop_kind_t; src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; 
             dst_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ Initializes descriptor for inner product backward propagation. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param ip_desc Output descriptor for inner product primitive. }
  {/ @param diff_src_desc Diff source memory descriptor. }
  {/ @param weights_desc Weights memory descriptor. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_inner_product_backward_data_desc_init(ip_desc:Pdnnl_inner_product_desc_t; diff_src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ Initializes descriptor for inner product weights gradient primitive. }
  {/ }
  {/ @note }
  {/     Memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param ip_desc Output descriptor for inner product primitive. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param diff_weights_desc Diff weights memory descriptor. }
  {/ @param diff_bias_desc Diff bias memory descriptor. Passing NULL, a zero }
  {/     memory descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_inner_product_backward_weights_desc_init(ip_desc:Pdnnl_inner_product_desc_t; src_desc:Pdnnl_memory_desc_t; diff_weights_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_inner_product }
  {/ @addtogroup dnnl_api_attributes }
  {/ @ }
  {/ Set quantization scale and shift parameters for RNN data tensors. }
  {/ }
  {/ For performance reasons, the low-precision configuration of the RNN }
  {/ primitives expects input activations to have the unsigned 8-bit integer }
  {/ data type. The scale and shift parameters are used to quantize }
  {/ floating-point data to unsigned integer and must be passed to the RNN }
  {/ primitive using attributes. }
  {/ }
  {/ The quantization formula is `scale * data + shift`. }
  {/ }
  {/ @note }
  {/     Quantization scale and shift are common for src_layer, src_iter, }
  {/     dst_iter, and dst_layer. }
  {/ }
  {/ Example usage: }
  {/ @code }
  {/     // RNN parameters }
  {/     int l = 2, t = 2, mb = 32, sic = 32, slc = 32, dic = 32, dlc = 32; }
  {/     // Activations quantization parameters }
  {/     float scale = 63.f, shift = 64.f; }
  {/ }
  {/     dnnl_primitive_attr_t rnn_attr; }
  {/     // Create default attributes }
  {/     dnnl_primitive_attr_create(&rnn_attr); }
  {/ }
  {/     // Set scale and shift for int8 quantization of activation }
  {/     dnnl_primitive_attr_set_rnn_data_qparams(rnn_attr, scale, shift); }
  {/ }
  {/     // Create and configure rnn op_desc }
  {/     dnnl_rnn_desc_t rnn_d; }
  {/     dnnl_primitive_desc_t rnn_pd; }
  {/     dnnl_primitive_desc_create(&rnn_pd, &rnn_d, attr, engine, NULL); }
  {/ @endcode }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param scale The value to scale the data by. }
  {/ @param shift The value to shift the data by. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_primitive_attr_set_rnn_data_qparams(attr:dnnl_primitive_attr_t; scale:single; shift:single):dnnl_status_t;cdecl;external;

  {/ Returns the quantization scale and shift parameters for RNN data tensors. }
  {/ }
  {/ @note }
  {/     Quantization scale and shift are common for src_layer, src_iter, }
  {/     dst_iter, and dst_layer. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param scale The value to scale the data by. }
  {/ @param shift The value to shift the data by. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_primitive_attr_get_rnn_data_qparams(attr:const_dnnl_primitive_attr_t; scale:Psingle; shift:Psingle):dnnl_status_t;cdecl;external;

  {/ Sets quantization scaling factors for RNN weights tensors. The }
  {/ low-precision configuration of the RNN primitives expects input weights to }
  {/ use the signed 8-bit integer data type. The scaling factors are used to }
  {/ quantize floating-point data to signed integer and must be passed to RNN }
  {/ primitives using attributes. }
  {/ }
  {/ @note }
  {/     The dimension order is always native and does not depend on the actual }
  {/     layout used. For example, five-dimensional weights always have (l, d, }
  {/     i, g, o) logical dimension ordering. }
  {/ }
  {/ @note }
  {/     Quantization scales are common for weights_layer and weights_iteration }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param count Number of elements in the @p scales array. }
  {/ @param mask Scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales vector. The set i-th bit indicates that a dedicated scaling }
  {/     factor should be used for each index along that dimension. Set the }
  {/     mask to 0 to use a common scaling factor for the whole output }
  {/     tensor. }
  {/ @param scales Array of output scaling factors that must contain @p count }
  {/     values and the following equality must hold: }
  {/     \f[count = \prod\limits_d \in mask weights.dims[d].\f] }
  {/     Violations can only be detected when the attributes are used to create }
  {/     a primitive descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_set_rnn_weights_qparams(attr:dnnl_primitive_attr_t; count:dnnl_dim_t; mask:longint; scales:Psingle):dnnl_status_t;cdecl;external;

  {/ Returns the quantization scaling factors for RNN weights tensors. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param count Number of elements in the @p scales array. }
  {/ @param mask Scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales vector. The set i-th bit indicates that a dedicated scaling }
  {/     factor should be used for each index along that dimension. Set the }
  {/     mask to 0 to use a common scaling factor for the whole output }
  {/     tensor. }
  {/ @param scales Array of output scaling factors that contain @p count }
  {/     values and the following equality must hold: }
  {/     \f[count = \prod\limits_d \in mask weights.dims[d].\f] }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_get_rnn_weights_qparams(attr:const_dnnl_primitive_attr_t; count:Pdnnl_dim_t; mask:Plongint; scales:PPsingle):dnnl_status_t;cdecl;external;

  {/ Sets quantization scaling factors for RNN projection weights tensors. The }
  {/ low-precision configuration of the RNN primitives expects input weights to }
  {/ use the signed 8-bit integer data type. The scaling factors are used to }
  {/ quantize floating-point data to signed integer and must be passed to RNN }
  {/ primitives using attributes. }
  {/ }
  {/ @note }
  {/     The dimension order is always native and does not depend on the actual }
  {/     layout used. For example, five-dimensional weights always have (l, d, }
  {/     i, g, o) logical dimension ordering. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param count Number of elements in the @p scales array. }
  {/ @param mask Scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales vector. The set i-th bit indicates that a dedicated scaling }
  {/     factor should be used for each index along that dimension. Set the }
  {/     mask to 0 to use a common scaling factor for the whole output }
  {/     tensor. }
  {/ @param scales Array of output scaling factors that must contain @p count }
  {/     values and the following equality must hold: }
  {/     \f[count = \prod\limits_d \in mask weights.dims[d].\f] }
  {/     Violations can only be detected when the attributes are used to create }
  {/     a primitive descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_set_rnn_weights_projection_qparams(attr:dnnl_primitive_attr_t; count:dnnl_dim_t; mask:longint; scales:Psingle):dnnl_status_t;cdecl;external;

  {/ Returns the quantization scaling factors for RNN projection weights tensors. }
  {/ }
  {/ @param attr Primitive attributes. }
  {/ @param count Number of elements in the @p scales array. }
  {/ @param mask Scaling factors correspondence mask that defines the }
  {/     correspondence between the output tensor dimensions and the @p }
  {/     scales vector. The set i-th bit indicates that a dedicated scaling }
  {/     factor should be used for each index along that dimension. Set the }
  {/     mask to 0 to use a common scaling factor for the whole output }
  {/     tensor. }
  {/ @param scales Array of output scaling factors that contain @p count }
  {/     values and the following equality must hold: }
  {/     \f[count = \prod\limits_d \in mask weights.dims[d].\f] }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_primitive_attr_get_rnn_weights_projection_qparams(attr:const_dnnl_primitive_attr_t; count:Pdnnl_dim_t; mask:Plongint; scales:PPsingle):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_attributes }
  {/ @addtogroup dnnl_api_rnn }
  {/ @ }
  {/ Initializes a descriptor for vanilla RNN forward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc, }
  {/ - @p bias_desc, }
  {/ - @p dst_iter_desc. }
  {/ }
  {/ This would then indicate that the RNN forward propagation primitive should }
  {/ not use them and should default to zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param rnn_desc Output descriptor for vanilla RNN primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param activation Activation kind. Possible values are #dnnl_eltwise_relu, }
  {/     #dnnl_eltwise_tanh or #dnnl_eltwise_logistic. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param flags Unused. }
  {/ @param alpha Negative slope if activation is #dnnl_eltwise_relu. }
  {/ @param beta Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_vanilla_rnn_forward_desc_init(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; activation:dnnl_alg_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; 
             src_iter_desc:Pdnnl_memory_desc_t; weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; 
             dst_iter_desc:Pdnnl_memory_desc_t; flags:dword; alpha:single; beta:single):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for vanilla RNN backward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p diff_src_iter_desc, }
  {/ - @p bias_desc together with @p diff_bias_desc, }
  {/ - @p dst_iter_desc together with @p diff_dst_iter_desc. }
  {/ }
  {/ This would then indicate that the RNN backward propagation primitive should }
  {/ not use the respective data and should use zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param rnn_desc Output descriptor for vanilla RNN primitive. }
  {/ @param prop_kind Propagation kind. Must be #dnnl_backward. }
  {/ @param activation Activation kind. Possible values are #dnnl_eltwise_relu, }
  {/     #dnnl_eltwise_tanh or #dnnl_eltwise_logistic. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param diff_src_layer_desc Memory descriptor for the diff of input vector. }
  {/ @param diff_src_iter_desc Memory descriptor for the diff of input recurrent }
  {/     hidden state vector. }
  {/ @param diff_weights_layer_desc Memory descriptor for the diff of weights }
  {/     applied to the layer input. }
  {/ @param diff_weights_iter_desc Memory descriptor for the diff of weights }
  {/     applied to the recurrent input. }
  {/ @param diff_bias_desc Diff bias memory descriptor. }
  {/ @param diff_dst_layer_desc Memory descriptor for the diff of output }
  {/     vector. }
  {/ @param diff_dst_iter_desc Memory descriptor for the diff of output }
  {/     recurrent hidden state vector. }
  {/ @param flags Unused. }
  {/ @param alpha Negative slope if activation is #dnnl_eltwise_relu. }
  {/ @param beta Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
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
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_vanilla_rnn_backward_desc_init(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; activation:dnnl_alg_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; 
             src_iter_desc:Pdnnl_memory_desc_t; weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; 
             dst_iter_desc:Pdnnl_memory_desc_t; diff_src_layer_desc:Pdnnl_memory_desc_t; diff_src_iter_desc:Pdnnl_memory_desc_t; diff_weights_layer_desc:Pdnnl_memory_desc_t; diff_weights_iter_desc:Pdnnl_memory_desc_t; 
             diff_bias_desc:Pdnnl_memory_desc_t; diff_dst_layer_desc:Pdnnl_memory_desc_t; diff_dst_iter_desc:Pdnnl_memory_desc_t; flags:dword; alpha:single; 
             beta:single):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for LSTM forward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p src_iter_c_desc, }
  {/ - @p bias_desc, }
  {/ - @p dst_iter_desc together with @p dst_iter_c_desc. }
  {/ }
  {/ This would then indicate that the LSTM forward propagation primitive should }
  {/ not use them and should default to zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @sa dnnl_lstm_forward_desc_init_v2 to initialize forward LSTM with and }
  {/     without peephole }
  {/ @sa dnnl_lstm_forward_desc_init_v3 to initialize forward LSTM with and }
  {/     without peephole / recurrent projection layer }
  {/ }
  {/ @param rnn_desc Output descriptor for LSTM primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param src_iter_c_desc Memory descriptor for the input recurrent cell }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param dst_iter_c_desc Memory descriptor for the output recurrent cell }
  {/     state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_lstm_forward_desc_init(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             src_iter_c_desc:Pdnnl_memory_desc_t; weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; 
             dst_iter_desc:Pdnnl_memory_desc_t; dst_iter_c_desc:Pdnnl_memory_desc_t; flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for an LSTM (with or without peephole) forward }
  {/ propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p src_iter_c_desc, }
  {/ - @p weights_peephole_desc, }
  {/ - @p bias_desc, }
  {/ - @p dst_iter_desc together with @p dst_iter_c_desc. }
  {/ }
  {/ This would then indicate that the LSTM forward propagation primitive should }
  {/ not use them and should default to zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with #dnnl_format_tag_any or }
  {/     with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @sa dnnl_lstm_forward_desc_init_v3 to initialize forward LSTM with and }
  {/     without peephole / recurrent projection layer }
  {/ }
  {/ @param rnn_desc Output descriptor for LSTM primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param src_iter_c_desc Memory descriptor for the input recurrent cell }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param weights_peephole_desc Memory descriptor for the weights applied to }
  {/     the cell states (according to the Peephole LSTM formula). }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param dst_iter_c_desc Memory descriptor for the output recurrent cell }
  {/     state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
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
  function dnnl_lstm_forward_desc_init_v2(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             src_iter_c_desc:Pdnnl_memory_desc_t; weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; weights_peephole_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; 
             dst_layer_desc:Pdnnl_memory_desc_t; dst_iter_desc:Pdnnl_memory_desc_t; dst_iter_c_desc:Pdnnl_memory_desc_t; flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for an LSTM (with or without peephole and with }
  {/ or without recurrent projection layer) forward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p src_iter_c_desc, }
  {/ - @p weights_peephole_desc, }
  {/ - @p bias_desc, }
  {/ - @p dst_iter_desc together with @p dst_iter_c_desc. }
  {/ }
  {/ This would then indicate that the LSTM forward propagation primitive should }
  {/ not use them and should default to zero values instead. }
  {/ }
  {/ The @p weights_projection_desc could either be @c NULL or point to a zero }
  {/ memory descriptor. This would then indicate that the LSTM doesn't have }
  {/ recurrent projection layer. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with #dnnl_format_tag_any or }
  {/     with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param rnn_desc Output descriptor for LSTM primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param src_iter_c_desc Memory descriptor for the input recurrent cell }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param weights_peephole_desc Memory descriptor for the weights applied to }
  {/     the cell states (according to the Peephole LSTM formula). }
  {/ @param weights_projection_desc Memory descriptor for the weights applied to }
  {/     the hidden states to get the recurrent projection (according to the }
  {/     Projection LSTM formula). }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param dst_iter_c_desc Memory descriptor for the output recurrent cell }
  {/     state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
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
  function dnnl_lstm_forward_desc_init_v3(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             src_iter_c_desc:Pdnnl_memory_desc_t; weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; weights_peephole_desc:Pdnnl_memory_desc_t; weights_projection_desc:Pdnnl_memory_desc_t; 
             bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; dst_iter_desc:Pdnnl_memory_desc_t; dst_iter_c_desc:Pdnnl_memory_desc_t; flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for an LSTM backward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p src_iter_c_desc, @p diff_src_iter_desc, }
  {/   and @p diff_src_iter_c_desc, }
  {/ - @p bias_desc together with @p diff_bias_desc, }
  {/ - @p dst_iter_desc together with @p dst_iter_c_desc, @p diff_dst_iter_desc, }
  {/   and @p diff_dst_iter_c_desc. }
  {/ }
  {/ This would then indicate that the LSTM backward propagation primitive }
  {/ should not use them and should default to zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @sa dnnl_lstm_backward_desc_init_v2 to initialize backward LSTM with and }
  {/     without peephole }
  {/ @sa dnnl_lstm_backward_desc_init_v3 to initialize backward LSTM with and }
  {/     without peephole / recurrent projection layer }
  {/ }
  {/ @param rnn_desc Output descriptor for LSTM primitive. }
  {/ @param prop_kind Propagation kind. Must be #dnnl_backward. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param src_iter_c_desc Memory descriptor for the input recurrent cell }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param dst_iter_c_desc Memory descriptor for the output recurrent cell }
  {/     state vector. }
  {/ @param diff_src_layer_desc Memory descriptor for the diff of input vector. }
  {/ @param diff_src_iter_desc Memory descriptor for the diff of input recurrent }
  {/     hidden state vector. }
  {/ @param diff_src_iter_c_desc Memory descriptor for the diff of input }
  {/ recurrent cell state vector. }
  {/ @param diff_weights_layer_desc Memory descriptor for the diff of weights }
  {/     applied to the layer input. }
  {/ @param diff_weights_iter_desc Memory descriptor for the diff of weights }
  {/     applied to the recurrent input. }
  {/ @param diff_bias_desc Diff bias memory descriptor. }
  {/ @param diff_dst_layer_desc Memory descriptor for the diff of output }
  {/     vector. }
  {/ @param diff_dst_iter_desc Memory descriptor for the diff of output }
  {/     recurrent hidden state vector. }
  {/ @param diff_dst_iter_c_desc Memory descriptor for the diff of output }
  {/     recurrent cell state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
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
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_lstm_backward_desc_init(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             src_iter_c_desc:Pdnnl_memory_desc_t; weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; 
             dst_iter_desc:Pdnnl_memory_desc_t; dst_iter_c_desc:Pdnnl_memory_desc_t; diff_src_layer_desc:Pdnnl_memory_desc_t; diff_src_iter_desc:Pdnnl_memory_desc_t; diff_src_iter_c_desc:Pdnnl_memory_desc_t; 
             diff_weights_layer_desc:Pdnnl_memory_desc_t; diff_weights_iter_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; diff_dst_layer_desc:Pdnnl_memory_desc_t; diff_dst_iter_desc:Pdnnl_memory_desc_t; 
             diff_dst_iter_c_desc:Pdnnl_memory_desc_t; flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for an LSTM (with or without peephole) backward }
  {/ propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p src_iter_c_desc, @p diff_src_iter_desc, }
  {/   and @p diff_src_iter_c_desc, }
  {/ - @p weights_peephole_desc together with @p diff_weights_peephole_desc, }
  {/ - @p bias_desc together with @p diff_bias_desc, }
  {/ - @p dst_iter_desc together with @p dst_iter_c_desc, @p diff_dst_iter_desc, }
  {/   and @p diff_dst_iter_c_desc. }
  {/ }
  {/ This would then indicate that the LSTM backward propagation primitive }
  {/ should not use them and should default to zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with #dnnl_format_tag_any or }
  {/     with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @sa dnnl_lstm_backward_desc_init_v3 to initialize backward LSTM with and }
  {/     without peephole / recurrent projection layer }
  {/ }
  {/ @param rnn_desc Output descriptor for LSTM primitive. }
  {/ @param prop_kind Propagation kind. Must be #dnnl_backward. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param src_iter_c_desc Memory descriptor for the input recurrent cell }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param weights_peephole_desc Memory descriptor for the weights applied to }
  {/     the cell states (according to the Peephole LSTM formula). }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param dst_iter_c_desc Memory descriptor for the output recurrent cell }
  {/     state vector. }
  {/ @param diff_src_layer_desc Memory descriptor for the diff of input vector. }
  {/ @param diff_src_iter_desc Memory descriptor for the diff of input recurrent }
  {/     hidden state vector. }
  {/ @param diff_src_iter_c_desc Memory descriptor for the diff of input }
  {/ recurrent cell state vector. }
  {/ @param diff_weights_layer_desc Memory descriptor for the diff of weights }
  {/     applied to the layer input. }
  {/ @param diff_weights_iter_desc Memory descriptor for the diff of weights }
  {/     applied to the recurrent input. }
  {/ @param diff_weights_peephole_desc Memory descriptor for the diff of weights }
  {/     applied to the cell states (according to the Peephole LSTM formula). }
  {/ @param diff_bias_desc Diff bias memory descriptor. }
  {/ @param diff_dst_layer_desc Memory descriptor for the diff of output }
  {/     vector. }
  {/ @param diff_dst_iter_desc Memory descriptor for the diff of output }
  {/     recurrent hidden state vector. }
  {/ @param diff_dst_iter_c_desc Memory descriptor for the diff of output }
  {/     recurrent cell state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
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
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_lstm_backward_desc_init_v2(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             src_iter_c_desc:Pdnnl_memory_desc_t; weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; weights_peephole_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; 
             dst_layer_desc:Pdnnl_memory_desc_t; dst_iter_desc:Pdnnl_memory_desc_t; dst_iter_c_desc:Pdnnl_memory_desc_t; diff_src_layer_desc:Pdnnl_memory_desc_t; diff_src_iter_desc:Pdnnl_memory_desc_t; 
             diff_src_iter_c_desc:Pdnnl_memory_desc_t; diff_weights_layer_desc:Pdnnl_memory_desc_t; diff_weights_iter_desc:Pdnnl_memory_desc_t; diff_weights_peephole_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; 
             diff_dst_layer_desc:Pdnnl_memory_desc_t; diff_dst_iter_desc:Pdnnl_memory_desc_t; diff_dst_iter_c_desc:Pdnnl_memory_desc_t; flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for an LSTM (with or without peephole and with or }
  {/ with out recurrent projection layer) backward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p src_iter_c_desc, @p diff_src_iter_desc, }
  {/   and @p diff_src_iter_c_desc, }
  {/ - @p weights_peephole_desc together with @p diff_weights_peephole_desc, }
  {/ - @p bias_desc together with @p diff_bias_desc, }
  {/ - @p dst_iter_desc together with @p dst_iter_c_desc, @p diff_dst_iter_desc, }
  {/   and @p diff_dst_iter_c_desc. }
  {/ }
  {/ This would then indicate that the LSTM backward propagation primitive }
  {/ should not use them and should default to zero values instead. }
  {/ }
  {/ The @p weights_projection_desc together with @p }
  {/ diff_weights_projection_desc could either be @c NULL or point to a zero }
  {/ memory descriptor. This would then indicate that the LSTM doesn't have }
  {/ recurrent projection layer. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with #dnnl_format_tag_any or }
  {/     with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param rnn_desc Output descriptor for LSTM primitive. }
  {/ @param prop_kind Propagation kind. Must be #dnnl_backward. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param src_iter_c_desc Memory descriptor for the input recurrent cell }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param weights_peephole_desc Memory descriptor for the weights applied to }
  {/     the cell states (according to the Peephole LSTM formula). }
  {/ @param weights_projection_desc Memory descriptor for the weights applied to }
  {/     the hidden states to get the recurrent projection (according to the }
  {/     Projection LSTM formula). }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param dst_iter_c_desc Memory descriptor for the output recurrent cell }
  {/     state vector. }
  {/ @param diff_src_layer_desc Memory descriptor for the diff of input vector. }
  {/ @param diff_src_iter_desc Memory descriptor for the diff of input recurrent }
  {/     hidden state vector. }
  {/ @param diff_src_iter_c_desc Memory descriptor for the diff of input }
  {/ recurrent cell state vector. }
  {/ @param diff_weights_layer_desc Memory descriptor for the diff of weights }
  {/     applied to the layer input. }
  {/ @param diff_weights_iter_desc Memory descriptor for the diff of weights }
  {/     applied to the recurrent input. }
  {/ @param diff_weights_peephole_desc Memory descriptor for the diff of weights }
  {/     applied to the cell states (according to the Peephole LSTM formula). }
  {/ @param diff_weights_projection_desc Memory descriptor for the diff of }
  {/     weights applied to the hidden states to get the recurrent projection }
  {/     (according to the Projection LSTM formula). }
  {/ @param diff_bias_desc Diff bias memory descriptor. }
  {/ @param diff_dst_layer_desc Memory descriptor for the diff of output }
  {/     vector. }
  {/ @param diff_dst_iter_desc Memory descriptor for the diff of output }
  {/     recurrent hidden state vector. }
  {/ @param diff_dst_iter_c_desc Memory descriptor for the diff of output }
  {/     recurrent cell state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
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
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_lstm_backward_desc_init_v3(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             src_iter_c_desc:Pdnnl_memory_desc_t; weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; weights_peephole_desc:Pdnnl_memory_desc_t; weights_projection_desc:Pdnnl_memory_desc_t; 
             bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; dst_iter_desc:Pdnnl_memory_desc_t; dst_iter_c_desc:Pdnnl_memory_desc_t; diff_src_layer_desc:Pdnnl_memory_desc_t; 
             diff_src_iter_desc:Pdnnl_memory_desc_t; diff_src_iter_c_desc:Pdnnl_memory_desc_t; diff_weights_layer_desc:Pdnnl_memory_desc_t; diff_weights_iter_desc:Pdnnl_memory_desc_t; diff_weights_peephole_desc:Pdnnl_memory_desc_t; 
             diff_weights_projection_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; diff_dst_layer_desc:Pdnnl_memory_desc_t; diff_dst_iter_desc:Pdnnl_memory_desc_t; diff_dst_iter_c_desc:Pdnnl_memory_desc_t; 
             flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for GRU forward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc, }
  {/ - @p bias_desc, }
  {/ - @p dst_iter_desc. }
  {/ }
  {/ This would then indicate that the GRU forward propagation primitive should }
  {/ not use them and should default to zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param rnn_desc Output descriptor for GRU primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_gru_forward_desc_init(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; dst_iter_desc:Pdnnl_memory_desc_t; 
             flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for GRU backward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p diff_src_iter_desc, }
  {/ - @p bias_desc together with @p diff_bias_desc, }
  {/ - @p dst_iter_desc together with @p diff_dst_iter_desc. }
  {/ }
  {/ This would then indicate that the GRU backward propagation primitive }
  {/ should not use them and should default to zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param rnn_desc Output descriptor for GRU primitive. }
  {/ @param prop_kind Propagation kind. Must be #dnnl_backward. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param diff_src_layer_desc Memory descriptor for the diff of input vector. }
  {/ @param diff_src_iter_desc Memory descriptor for the diff of input recurrent }
  {/     hidden state vector. }
  {/ @param diff_weights_layer_desc Memory descriptor for the diff of weights }
  {/     applied to the layer input. }
  {/ @param diff_weights_iter_desc Memory descriptor for the diff of weights }
  {/     applied to the recurrent input. }
  {/ @param diff_bias_desc Diff bias memory descriptor. }
  {/ @param diff_dst_layer_desc Memory descriptor for the diff of output }
  {/     vector. }
  {/ @param diff_dst_iter_desc Memory descriptor for the diff of output }
  {/     recurrent hidden state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
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
(* Const before type ignored *)
  function dnnl_gru_backward_desc_init(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; dst_iter_desc:Pdnnl_memory_desc_t; 
             diff_src_layer_desc:Pdnnl_memory_desc_t; diff_src_iter_desc:Pdnnl_memory_desc_t; diff_weights_layer_desc:Pdnnl_memory_desc_t; diff_weights_iter_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; 
             diff_dst_layer_desc:Pdnnl_memory_desc_t; diff_dst_iter_desc:Pdnnl_memory_desc_t; flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for LBR GRU forward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc, }
  {/ - @p bias_desc, }
  {/ - @p dst_iter_desc. }
  {/ }
  {/ This would then indicate that the LBR GRU forward propagation primitive }
  {/ should not use them and should default to zero values instead. }
  {/ }
  {/ @param rnn_desc Output descriptor for LBR GRU primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_lbr_gru_forward_desc_init(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; dst_iter_desc:Pdnnl_memory_desc_t; 
             flags:dword):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for LBR GRU backward propagation primitive. }
  {/ }
  {/ The following arguments may either be @c NULL or point to a zero memory }
  {/ descriptor: }
  {/ - @p src_iter_desc together with @p diff_src_iter_desc, }
  {/ - @p bias_desc together with @p diff_bias_desc, }
  {/ - @p dst_iter_desc together with @p diff_dst_iter_desc. }
  {/ }
  {/ This would then indicate that the LBR GRU backward propagation primitive }
  {/ should not use them and should default to zero values instead. }
  {/ }
  {/ @note }
  {/     All memory descriptors can be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ @param rnn_desc Output descriptor for LBR GRU primitive. }
  {/ @param prop_kind Propagation kind. Must be #dnnl_backward. }
  {/ @param direction RNN direction. See @ref dnnl_rnn_direction_t for more }
  {/     info. }
  {/ @param src_layer_desc Memory descriptor for the input vector. }
  {/ @param src_iter_desc Memory descriptor for the input recurrent hidden }
  {/     state vector. }
  {/ @param weights_layer_desc Memory descriptor for the weights applied to the }
  {/     layer input. }
  {/ @param weights_iter_desc Memory descriptor for the weights applied to the }
  {/     recurrent input. }
  {/ @param bias_desc Bias memory descriptor. }
  {/ @param dst_layer_desc Memory descriptor for the output vector. }
  {/ @param dst_iter_desc Memory descriptor for the output recurrent hidden }
  {/     state vector. }
  {/ @param diff_src_layer_desc Memory descriptor for the diff of input vector. }
  {/ @param diff_src_iter_desc Memory descriptor for the diff of input recurrent }
  {/     hidden state vector. }
  {/ @param diff_weights_layer_desc Memory descriptor for the diff of weights }
  {/     applied to the layer input. }
  {/ @param diff_weights_iter_desc Memory descriptor for the diff of weights }
  {/     applied to the recurrent input. }
  {/ @param diff_bias_desc Diff bias memory descriptor. }
  {/ @param diff_dst_layer_desc Memory descriptor for the diff of output }
  {/     vector. }
  {/ @param diff_dst_iter_desc Memory descriptor for the diff of output }
  {/     recurrent hidden state vector. }
  {/ @param flags Unused. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
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
(* Const before type ignored *)
  function dnnl_lbr_gru_backward_desc_init(rnn_desc:Pdnnl_rnn_desc_t; prop_kind:dnnl_prop_kind_t; direction:dnnl_rnn_direction_t; src_layer_desc:Pdnnl_memory_desc_t; src_iter_desc:Pdnnl_memory_desc_t; 
             weights_layer_desc:Pdnnl_memory_desc_t; weights_iter_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_layer_desc:Pdnnl_memory_desc_t; dst_iter_desc:Pdnnl_memory_desc_t; 
             diff_src_layer_desc:Pdnnl_memory_desc_t; diff_src_iter_desc:Pdnnl_memory_desc_t; diff_weights_layer_desc:Pdnnl_memory_desc_t; diff_weights_iter_desc:Pdnnl_memory_desc_t; diff_bias_desc:Pdnnl_memory_desc_t; 
             diff_dst_layer_desc:Pdnnl_memory_desc_t; diff_dst_iter_desc:Pdnnl_memory_desc_t; flags:dword):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_rnn }
  {/ @addtogroup dnnl_api_matmul }
  {/ @ }
  {/ Initializes a matrix multiplication descriptor. }
  {/ }
  {/ @param matmul_desc Output descriptor for matmul primitive. }
  {/ @param src_desc Source memory descriptor (matrix A) }
  {/ @param weights_desc Weights memory descriptor (matrix B) }
  {/ @param bias_desc Bias memory descriptor. Passing NULL, a zero memory }
  {/     descriptor, or a memory descriptor with format_kind set to }
  {/     #dnnl_format_kind_undef disables the bias term. }
  {/ @param dst_desc Destination memory descriptor (matrix C). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_matmul_desc_init(matmul_desc:Pdnnl_matmul_desc_t; src_desc:Pdnnl_memory_desc_t; weights_desc:Pdnnl_memory_desc_t; bias_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_matmul }
  {/ @addtogroup dnnl_api_resampling Resampling }
  {/ @ }
  {/ Initializes a descriptor for a resampling forward propagation primitive. }
  {/ }
  {/ @note }
  {/     Destination memory descriptor is allowed to be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ }
  {/ @param resampling_desc Output descriptor for a resampling primitive. }
  {/ @param prop_kind Propagation kind. Possible values are }
  {/     #dnnl_forward_training and #dnnl_forward_inference. }
  {/ @param alg_kind resampling algorithm kind: either #dnnl_resampling_nearest, }
  {/     or #dnnl_resampling_linear. }
  {/ @param factors Array of scaling factors for spatial dimension. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_resampling_forward_desc_init(resampling_desc:Pdnnl_resampling_desc_t; prop_kind:dnnl_prop_kind_t; alg_kind:dnnl_alg_kind_t; factors:Psingle; src_desc:Pdnnl_memory_desc_t; 
             dst_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ Initializes a descriptor for resampling backward propagation primitive. }
  {/ }
  {/ @param resampling_desc Output descriptor for a resampling primitive. }
  {/ @param alg_kind resamplinging algorithm kind: either }
  {/     #dnnl_resampling_nearest, or #dnnl_resampling_linear. }
  {/ @param diff_src_desc Diff source memory descriptor. }
  {/ @param diff_dst_desc Diff destination memory descriptor. }
  {/ @param factors Array of scaling factors for spatial dimension. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  {/ }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_resampling_backward_desc_init(resampling_desc:Pdnnl_resampling_desc_t; alg_kind:dnnl_alg_kind_t; factors:Psingle; diff_src_desc:Pdnnl_memory_desc_t; diff_dst_desc:Pdnnl_memory_desc_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_resampling }
  {/ @addtogroup dnnl_api_reduction Reduction }
  {/ @ }
  {/ Initializes a descriptor for a reduction primitive. }
  {/ }
  {/ @note }
  {/     Destination memory descriptor is allowed to be initialized with }
  {/     #dnnl_format_tag_any or with format_kind set to #dnnl_format_kind_any. }
  {/ }
  {/ }
  {/ @param desc Output descriptor for a reduction primitive. }
  {/ @param alg_kind reduction algorithm kind. Possible values: }
  {/     #dnnl_reduction_max, #dnnl_reduction_min, #dnnl_reduction_sum, }
  {/     #dnnl_reduction_mul, #dnnl_reduction_mean, #dnnl_reduction_norm_lp_max, }
  {/     #dnnl_reduction_norm_lp_sum, #dnnl_reduction_norm_lp_power_p_max, }
  {/     #dnnl_reduction_norm_lp_power_p_sum. }
  {/ @param p Algorithm specific parameter. }
  {/ @param eps Algorithm specific parameter. }
  {/ @param src_desc Source memory descriptor. }
  {/ @param dst_desc Destination memory descriptor. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  {/ }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_reduction_desc_init(desc:Pdnnl_reduction_desc_t; alg_kind:dnnl_alg_kind_t; src_desc:Pdnnl_memory_desc_t; dst_desc:Pdnnl_memory_desc_t; p:single; 
             eps:single):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_reduction }
  {/ @ dnnl_api_primitives }
  {/ @addtogroup dnnl_api_engine }
  {/ @ }
  {/ Returns the number of engines of a particular kind. }
  {/ }
  {/ @param kind Kind of engines to count. }
  {/ @returns Count of the engines. }
  function dnnl_engine_get_count(kind:dnnl_engine_kind_t):size_t;cdecl;external;

  {/ Creates an engine. }
  {/ }
  {/ @param engine Output engine. }
  {/ @param kind Engine kind. }
  {/ @param index Engine index that should be between 0 and the count of }
  {/     engines of the requested kind. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_engine_create(engine:Pdnnl_engine_t; kind:dnnl_engine_kind_t; index:size_t):dnnl_status_t;cdecl;external;

  {/ Returns the kind of an engine. }
  {/ }
  {/ @param engine Engine to query. }
  {/ @param kind Output engine kind. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_engine_get_kind(engine:dnnl_engine_t; kind:Pdnnl_engine_kind_t):dnnl_status_t;cdecl;external;

  {/ Destroys an engine. }
  {/ }
  {/ @param engine Engine to destroy. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_engine_destroy(engine:dnnl_engine_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_engine }
  {/ @addtogroup dnnl_api_stream }
  {/ @ }
  {/ Creates an execution stream. }
  {/ }
  {/ @param stream Output execution stream. }
  {/ @param engine Engine to create the execution stream on. }
  {/ @param flags Stream behavior flags (@sa dnnl_stream_flags_t). }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_stream_create(stream:Pdnnl_stream_t; engine:dnnl_engine_t; flags:dword):dnnl_status_t;cdecl;external;

  {/ Returns the engine of a stream object. }
  {/ }
  {/ @param stream Stream object. }
  {/ @param engine Output engine on which the stream is created. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_stream_get_engine(stream:const_dnnl_stream_t; engine:Pdnnl_engine_t):dnnl_status_t;cdecl;external;

  {/ Waits for all primitives in the execution stream to finish computations. }
  {/ }
  {/ @param stream Execution stream. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_stream_wait(stream:dnnl_stream_t):dnnl_status_t;cdecl;external;

  {/ Destroys an execution stream. }
  {/ }
  {/ @param stream Execution stream to destroy. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_stream_destroy(stream:dnnl_stream_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_stream }
  {/ @addtogroup dnnl_api_primitive_cache }
  {/ @ }
  {/ Returns the number of primitives that can be held in the primitive cache }
  {/ at the same time. }
  {/ }
  {/ @param capacity Primitive cache capacity to query. Concurrently }
  {/ accessing @p capacity is safe. }
  {/ @returns #dnnl_invalid_arguments/#dnnl::status::invalid_arguments if the }
  {/     @p capacity value is invalid, and #dnnl_success/#dnnl::status::success on }
  {/     success. }
  function dnnl_get_primitive_cache_capacity(capacity:Plongint):dnnl_status_t;cdecl;external;

  {/ Sets a number of primitives that can be held in the primitive cache }
  {/ at a time. }
  {/ }
  {/ @param capacity Primitive cache capacity to set. If a new @p capacity is }
  {/ less than a number of primitives that the primitive cache already has }
  {/ then the excess entries will be evicted. Setting the @p capacity to 0 }
  {/ clears the primitive cache and disables it. Concurrently modifying }
  {/ @p capacity is safe. }
  {/ @returns #dnnl_invalid_arguments/#dnnl::status::invalid_arguments if the }
  {/     @p capacity value is invalid, and #dnnl_success/#dnnl::status::success on }
  {/     success. }
  function dnnl_set_primitive_cache_capacity(capacity:longint):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_primitive_cache }
  {/ @addtogroup dnnl_api_mathmode }
  {/ @ }
  {/ Returns the floating-point math mode that will be used by default }
  {/ for all subsequently created primitives. }
  {/ }
  {/ @param mode Output FP math mode. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_get_default_fpmath_mode(mode:Pdnnl_fpmath_mode_t):dnnl_status_t;cdecl;external;

  {/ Sets the floating-point math mode that will be used by default }
  {/ for all subsequently created primitives. }
  {/ }
  {/ @param mode FP math mode. The possible values are: }
  {/     #dnnl_fpmath_mode_strict, }
  {/     #dnnl_fpmath_mode_bf16, }
  {/     #dnnl_fpmath_mode_f16, }
  {/     #dnnl_fpmath_mode_any. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_set_default_fpmath_mode(mode:dnnl_fpmath_mode_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_mathmode }
  {/ @addtogroup dnnl_api_service }
  {/ @ }
  {/ Configures verbose output to stdout. }
  {/ }
  {/ @note }
  {/     Enabling verbose output affects performance. }
  {/     This setting overrides the DNNL_VERBOSE environment variable. }
  {/ }
  {/ @param level Verbosity level: }
  {/  - 0: no verbose output (default), }
  {/  - 1: primitive information at execution, }
  {/  - 2: primitive information at creation and execution. }
  {/ @returns #dnnl_invalid_arguments/#dnnl::status::invalid_arguments if the }
  {/     @p level value is invalid, and #dnnl_success/#dnnl::status::success on }
  {/     success. }
  function dnnl_set_verbose(level:longint):dnnl_status_t;cdecl;external;

  {/ Configures dumping of JIT-generated code. }
  {/ }
  {/ @note }
  {/     This setting overrides the DNNL_JIT_DUMP environment variable. }
  {/ }
  {/ @param enable Flag value. Set to 0 to disable and set to 1 to enable. }
  {/ @returns #dnnl_invalid_arguments/#dnnl::status::invalid_arguments if the }
  {/     @p flag value is invalid, and #dnnl_success/#dnnl::status::success on }
  {/     success. }
  function dnnl_set_jit_dump(enable:longint):dnnl_status_t;cdecl;external;

  {/ Returns library version information. }
  {/ @returns Pointer to a constant structure containing }
  {/  - major: major version number, }
  {/  - minor: minor version number, }
  {/  - patch: patch release number, }
  {/  - hash: git commit hash. }
(* Const before type ignored *)
  function dnnl_version:Pdnnl_version_t;cdecl;external;

  {/ Sets library profiling flags. The flags define which profilers are }
  {/ supported. }
  {/ }
  {/ @note }
  {/     This setting overrides DNNL_JIT_PROFILE environment variable. }
  {/ }
  {/ @sa @ref dev_guide_profilers }
  {/ }
  {/ @param flags Profiling flags that can contain the following bits: }
  {/     - @ref DNNL_JIT_PROFILE_VTUNE -- integration with VTune Amplifier }
  {/         (on by default) }
  {/     - @ref DNNL_JIT_PROFILE_LINUX_JITDUMP -- produce Linux-specific }
  {/         jit-pid.dump output (off by default). The location of the output }
  {/         is controlled via JITDUMPDIR environment variable or via }
  {/         dnnl_set_jit_profiling_jitdumpdir() function. }
  {/     - @ref DNNL_JIT_PROFILE_LINUX_PERFMAP -- produce Linux-specific }
  {/         perf-pid.map output (off by default). The output is always placed }
  {/         into /tmp. }
  {/ }
  {/     Passing @ref DNNL_JIT_PROFILE_NONE disables profiling completely. }
  {/ }
  {/ @returns #dnnl_invalid_arguments/#dnnl::status::invalid_arguments if the }
  {/     @p flags value is invalid, and #dnnl_success/#dnnl::status::success on }
  {/     success. }
  function dnnl_set_jit_profiling_flags(flags:dword):dnnl_status_t;cdecl;external;

  {/ Sets JIT dump output path. Only applicable to Linux and is only }
  {/ used when profiling flags have DNNL_JIT_PROFILE_LINUX_PERF bit set. }
  {/ }
  {/ After the first JIT kernel is generated, the jitdump output will be placed }
  {/ into temporary directory created using the mkdtemp template }
  {/ 'dir/.debug/jit/dnnl.XXXXXX'. }
  {/ }
  {/ @sa @ref dev_guide_profilers }
  {/ }
  {/ @note }
  {/     This setting overrides JITDUMPDIR environment variable.  If }
  {/     JITDUMPDIR is not set, and this function is never called, the path }
  {/     defaults to HOME. Passing NULL reverts the value to default. }
  {/ }
  {/ @note }
  {/     The directory is accessed only when the first JIT kernel is being }
  {/     created. JIT profiling will be disabled in case of any errors }
  {/     accessing or creating this directory. }
  {/ }
  {/ @param dir JIT dump output path. }
  {/ @returns #dnnl_success/#dnnl::status::success if the }
  {/     output directory was set correctly and an error status otherwise. }
  {/ @returns #dnnl_unimplemented/#dnnl::status::unimplemented on Windows. }
(* Const before type ignored *)
  function dnnl_set_jit_profiling_jitdumpdir(dir:Pchar):dnnl_status_t;cdecl;external;

  {/ Sets the maximal ISA the library can dispatch to on the CPU. See }
  {/ #dnnl_cpu_isa_t and #dnnl::cpu_isa for the list of the values accepted by }
  {/ the C and C++ API functions respectively. }
  {/ }
  {/ This function has effect only once, and returns an error on subsequent }
  {/ calls. It should also be invoked before any other oneDNN API call, otherwise }
  {/ it may return an error. }
  {/ }
  {/ This function overrides the DNNL_MAX_CPU_ISA environment variable. The }
  {/ environment variable can be set to the desired maximal ISA name in upper }
  {/ case and with dnnl_cpu_isa prefix removed. For example: }
  {/ `DNNL_MAX_CPU_ISA=AVX2`. }
  {/ }
  {/ @note }
  {/     The ISAs are only partially ordered: }
  {/         - SSE41 < AVX < AVX2, }
  {/         - AVX2 < AVX512_MIC < AVX512_MIC_4OPS, }
  {/         - AVX2 < AVX512_CORE < AVX512_CORE_VNNI < AVX512_CORE_BF16 }
  {/           < AVX512_CORE_AMX, }
  {/         - AVX2 < AVX2_VNNI. }
  {/ }
  {/ @sa @ref dev_guide_cpu_dispatcher_control for more details }
  {/ }
  {/ @param isa Maximal ISA the library should dispatch to. Pass }
  {/     #dnnl_cpu_isa_all/#dnnl::cpu_isa::all to remove ISA restrictions }
  {/     (except for ISAs with initial support in the library). }
  {/ @returns #dnnl_success/#dnnl::status::success on success and a }
  {/     #dnnl_invalid_arguments/#dnnl::status::invalid_arguments if the @p isa }
  {/     parameter is invalid or the ISA cannot be changed at this time. }
  {/ @returns #dnnl_unimplemented/#dnnl::status::unimplemented if the feature }
  {/     was disabled at build time (see @ref dev_guide_build_options for more }
  {/     details). }
  function dnnl_set_max_cpu_isa(isa:dnnl_cpu_isa_t):dnnl_status_t;cdecl;external;

  {/ Gets the maximal ISA the library can dispatch to on the CPU. See }
  {/ #dnnl_cpu_isa_t and #dnnl::cpu_isa for the list of the values returned by }
  {/ the C and C++ API functions respectively. }
  {/ }
  {/ @sa @ref dev_guide_cpu_dispatcher_control for more details }
  {/ }
  {/ @returns #dnnl_cpu_isa_t value reflecting the maximal ISA the library may }
  {/     dispatch to. }
  function dnnl_get_effective_cpu_isa:dnnl_cpu_isa_t;cdecl;external;

  {/ Sets the hints flag for the CPU ISA. See #dnnl_cpu_isa_hints_t and }
  {/ #dnnl::cpu_isa_hints for the list of the values accepted by the C and C++ }
  {/ API functions respectively. }
  {/ }
  {/ This function has effect only once, and returns an error on subsequent }
  {/ calls. It should also be invoked before any other oneDNN API call, otherwise }
  {/ it may return an error. }
  {/ }
  {/ This function overrides the DNNL_CPU_ISA_HINTS environment variable. }
  {/ @sa @ref dev_guide_cpu_isa_hints for more details }
  {/ }
  {/ @param isa_hints CPU ISA hints to be passed over to the implementation. }
  {/     Pass #dnnl_cpu_isa_no_hints/#dnnl::cpu_isa_hints::no_hints to use }
  {/     default features i.e. no hints. }
  {/ @returns #dnnl_success/#dnnl::status::success on success and a }
  {/     #dnnl_runtime_error/#dnnl::status::runtime_error if the ISA hints cannot }
  {/     be specified at the current time. }
  {/ @returns #dnnl_unimplemented/#dnnl::status::unimplemented if the feature }
  {/     was disabled at build time (see @ref dev_guide_build_options for more }
  {/     details). }
  function dnnl_set_cpu_isa_hints(isa_hints:dnnl_cpu_isa_hints_t):dnnl_status_t;cdecl;external;

  {/ Gets the ISA specific hints that library can follow. See }
  {/ #dnnl_cpu_isa_hints_t and #dnnl::cpu_isa_hints for the list of the values }
  {/  returned by the C and C++ API functions respectively. }
  {/ }
  {/ @sa @ref dev_guide_cpu_isa_hints for more details }
  {/ }
  {/ @returns #dnnl_cpu_isa_hints_t value reflecting the ISA specific hints the }
  {/ library can follow. }
  function dnnl_get_cpu_isa_hints:dnnl_cpu_isa_hints_t;cdecl;external;

  {/ @ dnnl_api_service }
  {/ @addtogroup dnnl_api_blas }
  {/ @ }
  {/ Performs single-precision matrix-matrix multiply. }
  {/ }
  {/ The operation is defined as: }
  {/ }
  {/ `C := alpha * op( A ) * op( B ) + beta * C` }
  {/ }
  {/ where }
  {/  - `op( X ) = X` or `op( X ) = X**T`, }
  {/  - `alpha` and `beta` are scalars, and }
  {/  - `A`, `B`, and `C` are matrices: }
  {/     - `op( A )` is an `MxK` matrix, }
  {/     - `op( B )` is an `KxN` matrix, }
  {/     - `C` is an `MxN` matrix. }
  {/ }
  {/ The matrices are assumed to be stored in row-major order (the elements in }
  {/ each of the matrix rows are contiguous in memory). }
  {/ }
  {/ @note }
  {/     This API does not support XERBLA. Instead, unlike the standard BLAS }
  {/     functions, this one returns a dnnl_status_t value to allow error }
  {/     handling. }
  {/ }
  {/ @param transa Transposition flag for matrix A: 'N' or 'n' means A is not }
  {/     transposed, and 'T' or 't' means that A is transposed. }
  {/ @param transb Transposition flag for matrix B: 'N' or 'n' means B is not }
  {/     transposed, and 'T' or 't' means that B is transposed. }
  {/ @param M The M dimension. }
  {/ @param N The N dimension. }
  {/ @param K The K dimension. }
  {/ @param alpha The alpha parameter that is used to scale the product of }
  {/     matrices A and B. }
  {/ @param A A pointer to the A matrix data. }
  {/ @param lda The leading dimension for the matrix A. }
  {/ @param B A pointer to the B matrix data. }
  {/ @param ldb The leading dimension for the matrix B. }
  {/ @param beta The beta parameter that is used to scale the matrix C. }
  {/ @param C A pointer to the C matrix data. }
  {/ @param ldc The leading dimension for the matrix C. }
  {/ @returns #dnnl_success/#dnnl::status::success on success and a status }
  {/     describing the error otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_sgemm(transa:char; transb:char; M:dnnl_dim_t; N:dnnl_dim_t; K:dnnl_dim_t; 
             alpha:single; A:Psingle; lda:dnnl_dim_t; B:Psingle; ldb:dnnl_dim_t; 
             beta:single; C:Psingle; ldc:dnnl_dim_t):dnnl_status_t;cdecl;external;

  {/ Performs integer matrix-matrix multiply on 8-bit unsigned matrix A, 8-bit }
  {/ signed matrix B, and 32-bit signed resulting matrix C. }
  {/ }
  {/ The operation is defined as: }
  {/ }
  {/ `C := alpha * (op(A) - A_offset) * (op(B) - B_offset) + beta * C + C_offset` }
  {/ }
  {/ where }
  {/  - `op( X ) = X` or `op( X ) = X**T`, }
  {/  - `alpha` and `beta` are scalars, and }
  {/  - `A`, `B`, and `C` are matrices: }
  {/     - `op( A )` is an `MxK` matrix, }
  {/     - `op( B )` is an `KxN` matrix, }
  {/     - `C` is an `MxN` matrix. }
  {/  - `A_offset` is an `MxK` matrix with every element equal the `ao` value, }
  {/  - `B_offset` is an `KxN` matrix with every element equal the `bo` value, }
  {/  - `C_offset` is an `MxN` matrix which is defined by the `co` array of size `len`: }
  {/    - if `offsetc = F`: the `len` must be at least `1`, }
  {/    - if `offsetc = C`: the `len` must be at least `max(1, m)`, }
  {/    - if `offsetc = R`: the `len` must be at least `max(1, n)`, }
  {/ }
  {/ The matrices are assumed to be stored in row-major order (the elements in }
  {/ each of the matrix rows are contiguous in memory). }
  {/ }
  {/ @note }
  {/     This API does not support XERBLA. Instead, unlike the standard BLAS }
  {/     functions, this one returns a dnnl_status_t value to allow error }
  {/     handling. }
  {/ }
  {/ @warning }
  {/     On some architectures saturation may happen during intermediate }
  {/     computations, which would lead to unexpected results. For more }
  {/     details, refer to @ref dev_guide_int8_computations. }
  {/ }
  {/ @param transa Transposition flag for matrix A: 'N' or 'n' means A is not }
  {/     transposed, and 'T' or 't' means that A is transposed. }
  {/ @param transb Transposition flag for matrix B: 'N' or 'n' means B is not }
  {/     transposed, and 'T' or 't' means that B is transposed. }
  {/ @param offsetc Flag specifying how offsets should be applied to matrix C: }
  {/     - 'F' means that the same offset will be applied to each element of }
  {/         the matrix C, }
  {/     - 'C' means that individual offset will be applied to each element }
  {/         within each column, }
  {/     - 'R' means that individual offset will be applied to each element }
  {/         within each row. }
  {/ @param M The M dimension. }
  {/ @param N The N dimension. }
  {/ @param K The K dimension. }
  {/ @param alpha The alpha parameter that is used to scale the product of }
  {/     matrices A and B. }
  {/ @param A A pointer to the A matrix data. }
  {/ @param lda The leading dimension for the matrix A. }
  {/ @param ao The offset value for the matrix A. }
  {/ @param B A pointer to the B matrix data. }
  {/ @param ldb The leading dimension for the matrix B. }
  {/ @param bo The offset value for the matrix B. }
  {/ @param beta The beta parameter that is used to scale the matrix C. }
  {/ @param C A pointer to the C matrix data. }
  {/ @param ldc The leading dimension for the matrix C. }
  {/ @param co An array of offset values for the matrix C. The number of }
  {/     elements in the array depends on the value of @p offsetc. }
  {/ @returns #dnnl_success/#dnnl::status::success on success and a status }
  {/     describing the error otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_gemm_u8s8s32(transa:char; transb:char; offsetc:char; M:dnnl_dim_t; N:dnnl_dim_t; 
             K:dnnl_dim_t; alpha:single; A:Puint8_t; lda:dnnl_dim_t; ao:uint8_t; 
             B:Pint8_t; ldb:dnnl_dim_t; bo:int8_t; beta:single; C:Pint32_t; 
             ldc:dnnl_dim_t; co:Pint32_t):dnnl_status_t;cdecl;external;

  {/ Performs integer matrix-matrix multiply on 8-bit signed matrix A, 8-bit }
  {/ signed matrix B, and 32-bit signed resulting matrix C. }
  {/ }
  {/ The operation is defined as: }
  {/ }
  {/ `C := alpha * (op(A) - A_offset) * (op(B) - B_offset) + beta * C + C_offset` }
  {/ }
  {/ where }
  {/  - `op( X ) = X` or `op( X ) = X**T`, }
  {/  - `alpha` and `beta` are scalars, and }
  {/  - `A`, `B`, and `C` are matrices: }
  {/     - `op( A )` is an `MxK` matrix, }
  {/     - `op( B )` is an `KxN` matrix, }
  {/     - `C` is an `MxN` matrix. }
  {/  - `A_offset` is an `MxK` matrix with every element equal the `ao` value, }
  {/  - `B_offset` is an `KxN` matrix with every element equal the `bo` value, }
  {/  - `C_offset` is an `MxN` matrix which is defined by the `co` array of size `len`: }
  {/    - if `offsetc = F`: the `len` must be at least `1`, }
  {/    - if `offsetc = C`: the `len` must be at least `max(1, m)`, }
  {/    - if `offsetc = R`: the `len` must be at least `max(1, n)`, }
  {/ }
  {/ The matrices are assumed to be stored in row-major order (the elements in }
  {/ each of the matrix rows are contiguous in memory). }
  {/ }
  {/ @note }
  {/     This API does not support XERBLA. Instead, unlike the standard BLAS }
  {/     functions, this one returns a dnnl_status_t value to allow error }
  {/     handling. }
  {/ }
  {/ @warning }
  {/     On some architectures saturation may happen during intermediate }
  {/     computations, which would lead to unexpected results. For more }
  {/     details, refer to @ref dev_guide_int8_computations. }
  {/ }
  {/ @param transa Transposition flag for matrix A: 'N' or 'n' means A is not }
  {/     transposed, and 'T' or 't' means that A is transposed. }
  {/ @param transb Transposition flag for matrix B: 'N' or 'n' means B is not }
  {/     transposed, and 'T' or 't' means that B is transposed. }
  {/ @param offsetc Flag specifying how offsets should be applied to matrix C: }
  {/     - 'F' means that the same offset will be applied to each element of }
  {/         the matrix C, }
  {/     - 'C' means that individual offset will be applied to each element }
  {/         within each column, }
  {/     - 'R' means that individual offset will be applied to each element }
  {/         within each row. }
  {/ @param M The M dimension. }
  {/ @param N The N dimension. }
  {/ @param K The K dimension. }
  {/ @param alpha The alpha parameter that is used to scale the product of }
  {/     matrices A and B. }
  {/ @param A A pointer to the A matrix data. }
  {/ @param lda The leading dimension for the matrix A. }
  {/ @param ao The offset value for the matrix A. }
  {/ @param B A pointer to the B matrix data. }
  {/ @param ldb The leading dimension for the matrix B. }
  {/ @param bo The offset value for the matrix B. }
  {/ @param beta The beta parameter that is used to scale the matrix C. }
  {/ @param C A pointer to the C matrix data. }
  {/ @param ldc The leading dimension for the matrix C. }
  {/ @param co An array of offset values for the matrix C. The number of }
  {/     elements in the array depends on the value of @p offsetc. }
  {/ @returns #dnnl_success/#dnnl::status::success on success and a status }
  {/     describing the error otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_gemm_s8s8s32(transa:char; transb:char; offsetc:char; M:dnnl_dim_t; N:dnnl_dim_t; 
             K:dnnl_dim_t; alpha:single; A:Pint8_t; lda:dnnl_dim_t; ao:int8_t; 
             B:Pint8_t; ldb:dnnl_dim_t; bo:int8_t; beta:single; C:Pint32_t; 
             ldc:dnnl_dim_t; co:Pint32_t):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_blas }
  {/ @ dnnl_api }
  {/ @addtogroup dnnl_api }
  {/ @ }
  {/ @addtogroup dnnl_api_interop }
  {/ @ }
  {/ @addtogroup dnnl_api_sycl_interop }
  {/ @ }
  {/ Creates an engine associated with a SYCL device and a SYCL context. }
  {/ }
  {/ @param engine Output engine. }
  {/ @param device Pointer to the SYCL device to use for the engine. }
  {/ @param context Pointer to the SYCL context to use for the engine. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)

  function dnnl_sycl_interop_engine_create(engine:Pdnnl_engine_t; device:pointer; context:pointer):dnnl_status_t;cdecl;external;

  {/ Returns the SYCL context associated with an engine. }
  {/ }
  {/ @param engine Engine to query. }
  {/ @param context Pointer to the underlying SYCL context of the engine. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_sycl_interop_engine_get_context(engine:dnnl_engine_t; context:Ppointer):dnnl_status_t;cdecl;external;

  {/ Returns the SYCL device associated with an engine. }
  {/ }
  {/ @param engine Engine to query. }
  {/ @param device Pointer to the underlying SYCL device of the engine. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_sycl_interop_engine_get_device(engine:dnnl_engine_t; device:Ppointer):dnnl_status_t;cdecl;external;

  {/ Creates a memory object. }
  {/ }
  {/ Unless @p handle is equal to DNNL_MEMORY_NONE or DNNL_MEMORY_ALLOCATE, the }
  {/ constructed memory object will have the underlying buffer set. In this }
  {/ case, the buffer will be initialized as if: }
  {/ - dnnl_memory_set_data_handle() had been called, if @p memory_kind is equal }
  {/   to dnnl_sycl_interop_usm, or }
  {/ - dnnl_sycl_interop_memory_set_buffer() has been called, if @p memory_kind }
  {/   is equal to dnnl_sycl_interop_buffer. }
  {/ }
  {/ @param memory Output memory object. }
  {/ @param memory_desc Memory descriptor. }
  {/ @param engine Engine to use. }
  {/ @param memory_kind Memory allocation kind to specify the type of handle. }
  {/ @param handle Handle of the memory buffer to use as an underlying storage. }
  {/     - A USM pointer to the user-allocated buffer. In this case the library }
  {/       doesn't own the buffer. Requires @p memory_kind to be equal to }
  {/       dnnl_sycl_interop_usm. }
  {/     - A pointer to SYCL buffer. In this case the library doesn't own the }
  {/       buffer. Requires @p memory_kind be equal to be equal to }
  {/       dnnl_sycl_interop_buffer. }
  {/     - The DNNL_MEMORY_ALLOCATE special value. Instructs the library to }
  {/       allocate the buffer that corresponds to the memory allocation kind }
  {/       @p memory_kind for the memory object. In this case the library }
  {/       owns the buffer. }
  {/     - The DNNL_MEMORY_NONE specific value. Instructs the library to }
  {/       create memory object without an underlying buffer. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
  function dnnl_sycl_interop_memory_create(memory:Pdnnl_memory_t; memory_desc:Pdnnl_memory_desc_t; engine:dnnl_engine_t; memory_kind:dnnl_sycl_interop_memory_kind_t; handle:pointer):dnnl_status_t;cdecl;external;

  {/ Returns the memory allocation kind associated with a memory object. }
  {/ }
  {/ @param memory Memory to query. }
  {/ @param memory_kind Output underlying memory allocation kind of the memory }
  {/     object. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_sycl_interop_memory_get_memory_kind(memory:const_dnnl_memory_t; memory_kind:Pdnnl_sycl_interop_memory_kind_t):dnnl_status_t;cdecl;external;

  {/ Sets a SYCL buffer for a memory object. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param buffer SYCL buffer to be set in the memory object. }
  {/ @param stream Stream to use to execute padding in. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_sycl_interop_memory_set_buffer(memory:dnnl_memory_t; buffer:pointer; stream:dnnl_stream_t):dnnl_status_t;cdecl;external;

  {/ Creates an execution stream for a given engine associated with a SYCL }
  {/ queue. }
  {/ }
  {/ @param stream Output execution stream. }
  {/ @param engine Engine to create the execution stream on. }
  {/ @param queue SYCL queue to use. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_sycl_interop_stream_create(stream:Pdnnl_stream_t; engine:dnnl_engine_t; queue:pointer):dnnl_status_t;cdecl;external;

  {/ Returns the SYCL queue associated with an execution stream. }
  {/ }
  {/ @param stream Execution stream to query. }
  {/ @param queue Output SYCL command queue. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_sycl_interop_stream_get_queue(stream:dnnl_stream_t; queue:Ppointer):dnnl_status_t;cdecl;external;

  {/ Executes computations specified by the primitive in a specified stream and }
  {/ returns a SYCL event. }
  {/ }
  {/ @param primitive Primitive to execute. }
  {/ @param stream Stream to use. }
  {/ @param nargs Number of arguments. }
  {/ @param args Array of arguments. Each argument is an }
  {/     <index, #dnnl_memory_t> pair. The index is one of the `DNNL_ARG_*` }
  {/     values such as `DNNL_ARG_SRC`. Unless runtime shapes are used (see }
  {/     #DNNL_RUNTIME_DIM_VAL), the memory object must have the same memory }
  {/     descriptor as that returned by }
  {/     #dnnl_primitive_desc_query_md(#dnnl_query_exec_arg_md, index). }
  {/ @param deps A pointer to std::vector<sycl::event> that contains }
  {/     dependencies. }
  {/ @param return_event Output event. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_sycl_interop_primitive_execute(primitive:const_dnnl_primitive_t; stream:dnnl_stream_t; nargs:longint; args:Pdnnl_exec_arg_t; deps:pointer; 
             return_event:pointer):dnnl_status_t;cdecl;external;

  { Set target version for OpenCL explicitly to suppress a compiler warning. }
{$ifndef CL_TARGET_OPENCL_VERSION}
  const CL_TARGET_OPENCL_VERSION = 120;    
{$endif}
  {/ @endcond }
  {/ @addtogroup dnnl_api }
  {/ @ }
  {/ @addtogroup dnnl_api_interop }
  {/ @ }
  {/ @addtogroup dnnl_api_ocl_interop }
  {/ @ }
  {/ Creates a memory object. }
  {/ }
  {/ Unless @p handle is equal to DNNL_MEMORY_NONE or DNNL_MEMORY_ALLOCATE, the }
  {/ constructed memory object will have the underlying buffer set. In this }
  {/ case, the buffer will be initialized as if: }
  {/ - dnnl_memory_set_data_handle() has been called, if @p memory_kind is equal }
  {/   to dnnl_ocl_interop_usm, or }
  {/ - dnnl_ocl_interop_memory_set_mem_object() has been called, if @p memory_kind }
  {/   is equal to dnnl_ocl_interop_buffer. }
  {/ }
  {/ @param memory Output memory object. }
  {/ @param memory_desc Memory descriptor. }
  {/ @param engine Engine to use. }
  {/ @param memory_kind Memory allocation kind to specify the type of handle. }
  {/ @param handle Handle of the memory buffer to use as an underlying storage. }
  {/     - A USM pointer to the user-allocated buffer. In this case the library }
  {/       doesn't own the buffer. Requires @p memory_kind to be equal to }
  {/       dnnl_ocl_interop_usm. }
  {/     - An OpenCL buffer. In this case the library doesn't own the buffer. }
  {/       Requires @p memory_kind be equal to be equal to dnnl_ocl_interop_buffer. }
  {/     - The DNNL_MEMORY_ALLOCATE special value. Instructs the library to }
  {/       allocate the buffer that corresponds to the memory allocation kind }
  {/       @p memory_kind for the memory object. In this case the library }
  {/       owns the buffer. }
  {/     - The DNNL_MEMORY_NONE specific value. Instructs the library to }
  {/       create memory object without an underlying buffer. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
(* Const before type ignored *)

  function dnnl_ocl_interop_memory_create(memory:Pdnnl_memory_t; memory_desc:Pdnnl_memory_desc_t; engine:dnnl_engine_t; memory_kind:dnnl_ocl_interop_memory_kind_t; handle:pointer):dnnl_status_t;cdecl;external;

  {/ Returns the memory allocation kind associated with a memory object. }
  {/ }
  {/ @param memory Memory to query. }
  {/ @param memory_kind Output underlying memory allocation kind of the memory }
  {/     object. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_ocl_interop_memory_get_memory_kind(memory:const_dnnl_memory_t; memory_kind:Pdnnl_ocl_interop_memory_kind_t):dnnl_status_t;cdecl;external;

  {/ Returns an OpenCL memory object associated with a memory object. }
  {/ }
  {/ @param memory Memory object. }
  {/ @param mem_object Output OpenCL memory object. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_ocl_interop_memory_get_mem_object(memory:const_dnnl_memory_t; mem_object:Pcl_mem):dnnl_status_t;cdecl;external;

  {/ Sets OpenCL memory object associated with a memory object. }
  {/ }
  {/ For behavioral details, see dnnl_memory_set_data_handle(). }
  {/ }
  {/ @param memory Memory object. }
  {/ @param mem_object OpenCL memory object. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_ocl_interop_memory_set_mem_object(memory:dnnl_memory_t; mem_object:cl_mem):dnnl_status_t;cdecl;external;

  {/ Creates an engine associated with an OpenCL device and an OpenCL context. }
  {/ }
  {/ @param engine Output engine. }
  {/ @param device Underlying OpenCL device to use for the engine. }
  {/ @param context Underlying OpenCL context to use for the engine. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_ocl_interop_engine_create(engine:Pdnnl_engine_t; device:cl_device_id; context:cl_context):dnnl_status_t;cdecl;external;

  {/ Returns the OpenCL context associated with an engine. }
  {/ }
  {/ @param engine Engine to query. }
  {/ @param context Output underlying OpenCL context of the engine. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_ocl_interop_engine_get_context(engine:dnnl_engine_t; context:Pcl_context):dnnl_status_t;cdecl;external;

  {/ Returns the OpenCL device associated with an engine. }
  {/ }
  {/ @param engine Engine to query. }
  {/ @param device Output underlying OpenCL device of the engine. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_ocl_interop_get_device(engine:dnnl_engine_t; device:Pcl_device_id):dnnl_status_t;cdecl;external;

  {/ Creates an execution stream for a given engine associated with }
  {/ an OpenCL command queue. }
  {/ }
  {/ @param stream Output execution stream. }
  {/ @param engine Engine to create the execution stream on. }
  {/ @param queue OpenCL command queue to use. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_ocl_interop_stream_create(stream:Pdnnl_stream_t; engine:dnnl_engine_t; queue:cl_command_queue):dnnl_status_t;cdecl;external;

  {/ Returns the OpenCL command queue associated with an execution stream. }
  {/ }
  {/ @param stream Execution stream to query. }
  {/ @param queue Output OpenCL command queue. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_ocl_interop_stream_get_command_queue(stream:dnnl_stream_t; queue:Pcl_command_queue):dnnl_status_t;cdecl;external;

  {/ @addtogroup dnnl_api }
  {/ @ }
  {/ @addtogroup dnnl_api_interop }
  {/ @ }
  {/ @addtogroup dnnl_api_threadpool_interop }
  {/ @ }
  {/ Creates an execution stream with specified threadpool. }
  {/ }
  {/ @sa @ref dev_guide_threadpool }
  {/ }
  {/ @param stream Output execution stream. }
  {/ @param engine Engine to create the execution stream on. }
  {/ @param threadpool Pointer to an instance of a C++ class that implements }
  {/     dnnl::threapdool_iface interface. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }

  function dnnl_threadpool_interop_stream_create(stream:Pdnnl_stream_t; engine:dnnl_engine_t; threadpool:pointer):dnnl_status_t;cdecl;external;

  {/ Returns a threadpool to be used by the execution stream. }
  {/ }
  {/ @sa @ref dev_guide_threadpool }
  {/ }
  {/ @param astream Execution stream. }
  {/ @param threadpool Output pointer to an instance of a C++ class that }
  {/     implements dnnl::threapdool_iface interface. Set to NULL if the }
  {/     stream was created without threadpool. }
  {/ @returns #dnnl_success on success and a status describing the error }
  {/     otherwise. }
  function dnnl_threadpool_interop_stream_get_threadpool(astream:dnnl_stream_t; threadpool:Ppointer):dnnl_status_t;cdecl;external;

  {/ @copydoc dnnl_sgemm() }
  {/ @param threadpool A pointer to a threadpool interface (only when built with }
  {/     the THREADPOOL CPU runtime). }
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_threadpool_interop_sgemm(transa:char; transb:char; M:dnnl_dim_t; N:dnnl_dim_t; K:dnnl_dim_t; 
             alpha:single; A:Psingle; lda:dnnl_dim_t; B:Psingle; ldb:dnnl_dim_t; 
             beta:single; C:Psingle; ldc:dnnl_dim_t; threadpool:pointer):dnnl_status_t;cdecl;external;

  {/ @copydoc dnnl_gemm_u8s8s32() }
  {/ @param threadpool A pointer to a threadpool interface (only when built with }
  {/     the THREADPOOL CPU runtime). }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_threadpool_interop_gemm_u8s8s32(transa:char; transb:char; offsetc:char; M:dnnl_dim_t; N:dnnl_dim_t; 
             K:dnnl_dim_t; alpha:single; A:Puint8_t; lda:dnnl_dim_t; ao:uint8_t; 
             B:Pint8_t; ldb:dnnl_dim_t; bo:int8_t; beta:single; C:Pint32_t; 
             ldc:dnnl_dim_t; co:Pint32_t; threadpool:pointer):dnnl_status_t;cdecl;external;

  {/ @copydoc dnnl_gemm_s8s8s32() }
  {/ @param threadpool A pointer to a threadpool interface (only when built with }
  {/     the THREADPOOL CPU runtime). }
(* Const before type ignored *)
(* Const before type ignored *)
(* Const before type ignored *)
  function dnnl_threadpool_interop_gemm_s8s8s32(transa:char; transb:char; offsetc:char; M:dnnl_dim_t; N:dnnl_dim_t; 
             K:dnnl_dim_t; alpha:single; A:Pint8_t; lda:dnnl_dim_t; ao:int8_t; 
             B:Pint8_t; ldb:dnnl_dim_t; bo:int8_t; beta:single; C:Pint32_t; 
             ldc:dnnl_dim_t; co:Pint32_t; threadpool:pointer):dnnl_status_t;cdecl;external;

  {/ @ dnnl_api_threadpool_interop }
  {/ @ dnnl_api_interop }
  {/ @ dnnl_api }


implementation
function DNNL_ARG_ATTR_MULTIPLE_POST_OP(const idx:integer):integer;inline;
begin
  DNNL_ARG_ATTR_MULTIPLE_POST_OP := DNNL_ARG_ATTR_MULTIPLE_POST_OP_BASE * ((idx) +1)
end;


end.
