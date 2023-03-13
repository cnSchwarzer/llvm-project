add_llvm_component_library(LLVMRISCVDesc
  RISCVAsmBackend.cpp
  RISCVBaseInfo.cpp
  RISCVELFObjectWriter.cpp
  RISCVInstPrinter.cpp
  RISCVMCAsmInfo.cpp
  RISCVMCCodeEmitter.cpp
  RISCVMCExpr.cpp
  RISCVMCObjectFileInfo.cpp
  RISCVMCTargetDesc.cpp
  RISCVMatInt.cpp
  RISCVTargetStreamer.cpp
  RISCVELFStreamer.cpp
  RISCVReitoDesc.cpp

  LINK_COMPONENTS
  MC
  RISCVInfo
  Support
  TargetParser
  Core

  ADD_TO_COMPONENT
  RISCV
)
