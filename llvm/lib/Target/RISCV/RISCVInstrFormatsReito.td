class RVInstCustom<bits<7> funct7, bits<3> x, RISCVOpcode opcode, dag outs,
              dag ins, string opcodestr, string argstr>
    : RVInst<outs, ins, opcodestr, argstr, [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd; 

  let Inst{31-25} = funct7;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14} = x{2};
  let Inst{13} = x{1};
  let Inst{12} = x{0};
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
}

//===----------------------------------------------------------------------===//
// Instruction generics
//===----------------------------------------------------------------------===//

class RvInstCustomRsd1d2<bits<7> funct7, RISCVOpcode opcode, string opcodestr>
      : RVInstCustom<funct7, 0b111, opcode, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2), 
                      opcodestr, "$rd, $rs1, $rs2">;

//===----------------------------------------------------------------------===//
// Instruction classes
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstCustomAluRR<bits<7> funct7, RISCVOpcode opcode, string opcodestr, bit Commutable = 0>
      : RvInstCustomRsd1d2<funct7, opcode, opcodestr> {
  let isCommutable = Commutable;
}