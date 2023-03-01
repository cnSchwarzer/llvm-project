//===----------------------------------------------------------------------===//
// Instruction generics
//===----------------------------------------------------------------------===//

let Predicates = [HasVendorXReitoR] in {
class RVInstReitoR<bits<7> funct7, bits<3> x, RISCVOpcode opcode, string opcodestr>
    : RVInst<(outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2", [], InstFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd; 

  let Inst{31-25} = funct7;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = x;
  let Inst{11-7} = rd;
  let Opcode = opcode.Value;
}
}

//===----------------------------------------------------------------------===//
// Instruction classes
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstReitoRAluRR<bits<7> funct7, RISCVOpcode opcode, string opcodestr, bit Commutable = 0>
      : RVInstReitoR<funct7, 0b111, opcode, opcodestr> {
  let isCommutable = Commutable;
}
