// RUN: %dxc -E main -T ps_6_0 -enable-templates -enable-unions %s | FileCheck %s
// RUN: %dxc -E main -T ps_6_0 -HV 202x %s | FileCheck %s

// CHECK:define void @main

template<typename T>
union TS {
  T t;
};

union TS<float4> ts;

float4 main() : SV_Target {
  return ts.t;
}
