//===----------------------------------------------------------------------===//
// Instruction generics
//===----------------------------------------------------------------------===//

let Predicates = [HasVendorXReitoR] in {
class RVInstReitoRb : Instruction {
}

// Since these are still draft, implement here.
class RVInstReitoR<dag outs, dag ins, string opcodestr, string argstr,
                list<dag> pattern, RISCVOpcode opcode>
    : Instruction {
  field bits<32> Inst;
  field bits<32> SoftFail = 0;
  let Size = 4;

  let Namespace = "RISCV";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;

  let Inst{6-0} = opcode.Value;
  let DecoderNamespace = "ReitoR";
}

class RVInstReitoRRawR<bits<7> funct7, bits<3> x, RISCVOpcode opcode, string opcodestr>
    : RVInstReitoR<(outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2), opcodestr, "$rd, $rs1, $rs2", [], opcode> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd; 

  let Inst{31-25} = funct7;
  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
  let Inst{14-12} = x;
  let Inst{11-7} = rd;
}
}

//===----------------------------------------------------------------------===//
// Instruction classes
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstReitoRAluRR<bits<7> funct7, RISCVOpcode opcode, string opcodestr, bit Commutable = 0>
      : RVInstReitoRRawR<funct7, 0b111, opcode, opcodestr> {
  let isCommutable = Commutable;
}
