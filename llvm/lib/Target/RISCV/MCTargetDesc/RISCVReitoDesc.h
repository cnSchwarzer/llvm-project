//
// Created by reito on 2023/3/4.
//

#ifndef LLVM_RISCVREITODESC_H
#define LLVM_RISCVREITODESC_H

#include "llvm/Support/JSON.h"
#include "RISCVBaseInfo.h"
#include <vector>
#include <map>

using namespace llvm;

namespace reito {

enum ReitoFormat {
  FormatInvalid = 1,
  FormatR = 1,
  FormatI,
  FormatIS,
  FormatS,
  FormatB,
  FormatU,
  FormatJ,
};

enum ReitoInst {
  LUI = 100,
  AUIPC = 101,
  JAL = 102,
  JALR = 103,
  BEQ = 104,
  BNE = 105,
  BLT = 106,
  BGE = 107,
  BLTU = 108,
  BGEU = 109,
  LB = 110,
  LH = 111,
  LW = 112,
  LBU = 113,
  LHU = 114,
  SB = 115,
  SH = 116,
  SW = 117,
  ADDI = 118,
  XORI = 119,
  ORI = 120,
  SLTI = 121,
  SLTIU = 122,
  ANDI = 123,
  SLLI = 124,
  SRLI = 125,
  SRAI = 126,
  ADD = 127,
  SUB = 128,
  XOR = 129,
  OR = 130,
  AND = 131,
  SLL = 132,
  SRL = 133,
  SRA = 134,
  SLT = 135,
  SLTU = 136,
  LWU = 137,
  LD = 138,
  SD = 139,
  ADDIW = 140,
  SLLIW = 141,
  SRLIW = 142,
  SRAIW = 143,
  SLLW = 144,
  SRLW = 145,
  SRAW = 146,
  ADDW = 147,
  SUBW = 148
};

struct OpcodeInfo {
  uint32_t Opcode;
  ReitoFormat Format;
  ReitoInst Instruction;
};

class RISCVReitoDesc {
  std::map<uint32_t, OpcodeInfo> Opcodes;

public:
  static RISCVReitoDesc* get();

};

}

#endif // LLVM_RISCVREITODESC_H
