// RUN: %dxc -spirv -T cs_6_7 %s | FileCheck %s
// RUN: %dxc -spirv -T cs_6_7 -DALIGN_16 %s | FileCheck %s
// RUN: %dxc -spirv -T cs_6_7 -DNO_PC %s | FileCheck %s

// Was getting bogus type errors with the defined changes

#ifdef ALIGN_16
typedef vk::BufferPointer<uint, 16> BufferType;
#else
typedef vk::BufferPointer<uint, 32> BufferType;
#endif
#ifndef NO_PC
struct PushConstantStruct {
  BufferType push_buffer;
};
[[vk::push_constant]] PushConstantStruct push_constant;
#endif

RWStructuredBuffer<uint> output;

[numthreads(1, 1, 1)]
void main() {
  uint64_t addr = 123;
  //BufferType test = BufferType(addr);
  vk::BufferPointer<uint, 32> test = vk::BufferPointer<uint, 32>(addr);
  output[0] = test.Get();
}
