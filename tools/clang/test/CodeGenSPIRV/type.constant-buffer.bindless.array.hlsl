// RUN: %dxc -T vs_6_0 -E main -fcgl  %s -spirv | FileCheck %s

// Used for ConstantBuffer definition.
// CHECK: [[type_CB_PerDraw:%[a-zA-Z0-9_]+]] = OpTypeStruct %mat4v4float
// Used for PerDraw local variable.
// CHECK: [[type_PerDraw:%[a-zA-Z0-9_]+]] = OpTypeStruct %mat4v4float

struct PerDraw {
  float4x4 Transform;
};

// CHECK: [[ptr_type_CB_PerDraw:%[a-zA-Z0-9_]+]] = OpTypePointer Uniform [[type_CB_PerDraw]]
// Used for ConstantBuffer to PerDraw type cast.


ConstantBuffer<PerDraw> PerDraws[];

struct VSInput {
  float3 Position : POSITION;

  [[vk::builtin("DrawIndex")]]
  uint DrawIdx    : DRAWIDX;
};

float4 main(in VSInput input) : SV_POSITION {
// CHECK:        [[ptr:%[a-zA-Z0-9_]+]] = OpAccessChain [[ptr_type_CB_PerDraw]] %PerDraws
// CHECK: [[cb_PerDraw:%[a-zA-Z0-9_]+]] = OpLoad [[type_CB_PerDraw]] [[ptr]]
// CHECK:   [[float4x4:%[a-zA-Z0-9_]+]] = OpCompositeExtract %mat4v4float [[cb_PerDraw]] 0
// CHECK:                       OpCompositeConstruct [[type_PerDraw]] [[float4x4]]
  const PerDraw perDraw = PerDraws[input.DrawIdx];
  return mul(float4(input.Position, 1.0f), perDraw.Transform);
}
