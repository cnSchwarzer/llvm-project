//
// Created by reito on 2023/3/4.
//

#include "RISCVReitoDesc.h"
#include "RISCVMCTargetDesc.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/Support/CommandLine.h"
#include <iostream>
#include <random>
#include <sstream>

using namespace reito;

namespace {
// Global Instance
RISCVReitoDesc ReitoDesc;
}

static cl::opt<std::string> OutputFilename("reito", cl::desc("Specify reito output filename"), cl::value_desc("filename"));

RISCVReitoDesc *RISCVReitoDesc::get() { return &ReitoDesc; }

void RISCVReitoDesc::replaceOpcode(const MCInst &MI, uint64_t &Inst) {
  Lock.lock();

  std::mt19937 Gen;
  auto IOp = MI.getOpcode();
  //std::cout << MCII->getName(IOp).str() << std::endl;

  const MCInstrDesc &Desc = MCII->get(IOp);
  auto ReitoFrm = (ReitoFormat) RISCVII::getReitoFormat(Desc.TSFlags);
  auto ReitoInstr = (ReitoInst) RISCVII::getReitoInst(Desc.TSFlags);

  InstrCount[ReitoInstr]++;
  auto &Alias = InstrOpcodes[ReitoInstr];

  // Increase random space on demand
  if (InstrCount[ReitoInstr] > Alias.size() * 2 && Opcodes.size() < ReitoInstOpcodeSize) {
    std::uniform_int_distribution AliasDist((int)ReitoInstRandomBegin, (int)ReitoInstRandomEnd);
regenerate:
    auto AliasOp = (uint32_t)AliasDist(Gen);
    if (Opcodes.contains(AliasOp))
      goto regenerate;
    //Add To Opcodes
    Opcodes[AliasOp] = {AliasOp, ReitoFrm, ReitoInstr};
    Alias.push_back(AliasOp);
  }

  if (Alias.size() > 0) {
    std::uniform_int_distribution AliasDist(0, (int)Alias.size() - 1);
    uint64_t ObfusInst = Alias[AliasDist(Gen)];
    Inst = (ObfusInst << 37) | (Inst & 0xffff001fffffffff);
  } else {
    llvm_unreachable("Unexpected Reito Q Empty Alias");
  }

  Lock.unlock();
}

RISCVReitoDesc::RISCVReitoDesc() { init(); }

RISCVReitoDesc::~RISCVReitoDesc() { save(); }

void RISCVReitoDesc::save() {
  auto Root = json::Object();

  auto OpcodesArray = json::Array();
  for (const auto &It : Opcodes) {
    auto Opc = json::Object();

    Opc["opcode"] = It.second.Opcode;
    Opc["format"] = (int)It.second.Format;
    Opc["instr"] = (int)It.second.ActualInst;

    OpcodesArray.push_back(std::move(Opc));
  }

  Root["opcodes"] = json::Value(std::move(OpcodesArray));

  std::string Str;
  raw_string_ostream Os(Str);
  Os << std::move(Root);

  std::cout << Str;
}

void RISCVReitoDesc::init() {
  MCII = std::unique_ptr<MCInstrInfo>(llvm::createRISCVMCInstrInfo());

  // For debug purpose, use the value from InstrFormats as instr default opcode.
  for (auto I = 0; I < MCII->getNumOpcodes(); ++I) {
    auto Name = MCII->getName(I);
    if (Name.starts_with("ReitoQ_")) {
      const MCInstrDesc &Desc = MCII->get(I);
      auto ReitoFrm = (ReitoFormat) RISCVII::getReitoFormat(Desc.TSFlags);
      auto ReitoInstr = RISCVII::getReitoInst(Desc.TSFlags);
      Opcodes[ReitoInstr] = {ReitoInstr, ReitoFrm, (ReitoInst)ReitoInstr};
      InstrOpcodes[(ReitoInst)ReitoInstr].push_back(ReitoInstr);
    }
  }
}