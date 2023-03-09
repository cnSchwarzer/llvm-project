//
// Created by reito on 2023/3/4.
//

#ifndef LLVM_RISCVREITODESC_H
#define LLVM_RISCVREITODESC_H

#include "llvm/Support/JSON.h"
#include "RISCVBaseInfo.h"
#include <vector>
#include <map>
#include <mutex>

using namespace llvm;

namespace reito {

void initReitoOptions();

enum ReitoFormat {
  FormatInvalid = 0,
  FormatR = 1,
  FormatI,
  FormatIS,
  FormatS,
  FormatB,
  FormatU,
  FormatJ,
};

// Keep Sync With Generator
enum ReitoInst : int {
  LUI = 0,
  AUIPC = 1,
  JAL = 2,
  JALR = 3,
  BEQ = 4,
  BNE = 5,
  BLT = 6,
  BGE = 7,
  BLTU = 8,
  BGEU = 9,
  LB = 10,
  LH = 11,
  LW = 12,
  LBU = 13,
  LHU = 14,
  SB = 15,
  SH = 16,
  SW = 17,
  ADDI = 18,
  XORI = 19,
  ORI = 20,
  SLTI = 21,
  SLTIU = 22,
  ANDI = 23,
  SLLI = 24,
  SRLI = 25,
  SRAI = 26,
  ADD = 27,
  SUB = 28,
  XOR = 29,
  OR = 30,
  AND = 31,
  SLL = 32,
  SRL = 33,
  SRA = 34,
  SLT = 35,
  SLTU = 36,
  LWU = 37,
  LD = 38,
  SD = 39,
  ADDIW = 40,
  SLLIW = 41,
  SRLIW = 42,
  SRAIW = 43,
  SLLW = 44,
  SRLW = 45,
  SRAW = 46,
  ADDW = 47,
  SUBW = 48,
  ReitoInstRandomBegin,
  ReitoInstRandomEnd = 2047,
  ReitoInstOpcodeSize
};

struct OpcodeInfo {
  uint32_t Opcode;
  ReitoFormat Format;
  ReitoInst ActualInst;
};

class RISCVReitoDesc {
  std::unique_ptr<MCInstrInfo> MCII;
  std::map<uint32_t, OpcodeInfo> Opcodes;
  std::map<ReitoInst, std::vector<uint32_t>> InstrOpcodes;
  std::map<ReitoInst, uint32_t> InstrCount;
  std::mutex Lock;

  void save();
  void init();

public:
  RISCVReitoDesc();
  ~RISCVReitoDesc();
  void replaceOpcode(const MCInst &MI, uint64_t& Inst);

public:
  static RISCVReitoDesc* get(); 
};

}

#endif // LLVM_RISCVREITODESC_H
