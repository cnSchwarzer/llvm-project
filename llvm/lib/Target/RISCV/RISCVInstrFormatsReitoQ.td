//===----------------------------------------------------------------------===//
// Instruction generics
//===----------------------------------------------------------------------===//

class ReitoFormat<bits<5> val> {
  bits<5> Value = val;
}
def ReitoFormatInvalid : ReitoFormat<0>;
def ReitoFormatR       : ReitoFormat<1>;
def ReitoFormatI       : ReitoFormat<2>;
def ReitoFormatIS5     : ReitoFormat<3>;
def ReitoFormatIS6     : ReitoFormat<4>;
def ReitoFormatS       : ReitoFormat<5>;
def ReitoFormatB       : ReitoFormat<6>;
def ReitoFormatU       : ReitoFormat<7>;
def ReitoFormatJ       : ReitoFormat<8>;

let Predicates = [HasVendorXReitoQ] in {
class RVInstReitoQ : Instruction {
  let DecoderNamespace = "ReitoQ";
}

// Since these are still draft, implement here.
class RVInst48<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr,
                list<dag> pattern, InstFormat format, ReitoFormat reitoFormat>
    : RVInstReitoQ {
  field bits<48> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  field bits<48> SoftFail = 0;
  let Size = 6;

  let Namespace = "RISCV";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;

  let Inst{5-0} = 0b011111;
  let Inst{47-37} = opcode;

  let TSFlags{4-0} = format.Value;
  let TSFlags{63-59} = reitoFormat.Value;
  let TSFlags{58-48} = opcode;
}

class RVInst64<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr,
                list<dag> pattern, InstFormat format, ReitoFormat reitoFormat>
    : RVInstReitoQ {
  field bits<64> Inst;
  // SoftFail is a field the disassembler can use to provide a way for
  // instructions to not match without killing the whole decode process. It is
  // mainly used for ARM, but Tablegen expects this field to exist or it fails
  // to build the decode table.
  field bits<64> SoftFail = 0;
  let Size = 8;

  let Namespace = "RISCV";

  dag OutOperandList = outs;
  dag InOperandList = ins;
  let AsmString = opcodestr # "\t" # argstr;
  let Pattern = pattern;

  let Inst{6-0} = 0b0111111;

  let TSFlags{4-0} = format.Value;
  let TSFlags{63-59} = reitoFormat.Value;
  let TSFlags{58-48} = opcode;
}
}

//===----------------------------------------------------------------------===//
// Instruction generic classes
//===----------------------------------------------------------------------===//

let Predicates = [HasVendorXReitoQ] in {
class RVInstReitoQRawR<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr>
    : RVInst48<opcode, outs, ins, opcodestr, argstr, [], InstFormatR, ReitoFormatR> {
  bits<5> rs2;
  bits<5> rs1;
  bits<5> rd;

  let Inst{36-22} = 0;
  let Inst{21-17} = rs2;
  let Inst{16-12} = rs1;
  let Inst{11} = 0;
  let Inst{10-6} = rd;
}

class RVInstReitoQRawI<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr>
    : RVInst48<opcode, outs, ins, opcodestr, argstr, [], InstFormatI, ReitoFormatI> {
  bits<12> imm12;
  bits<5> rs1;
  bits<5> rd;

  let Inst{36-32} = 0;
  let Inst{31-20} = imm12;
  let Inst{19-17} = 0;
  let Inst{16-12} = rs1;
  let Inst{11} = 0;
  let Inst{10-6} = rd;
}

class RVInstReitoQRawIShift<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr>
    : RVInst48<opcode, outs, ins, opcodestr, argstr, [], InstFormatI, ReitoFormatIS6> {
  bits<6> shamt; // Shift amount, in case you forgot it.
  bits<5> rs1;
  bits<5> rd;

  let Inst{36-26} = 0;
  let Inst{25-20} = shamt;
  let Inst{19-17} = 0;
  let Inst{16-12} = rs1;
  let Inst{11} = 0;
  let Inst{10-6} = rd;
}

class RVInstReitoQRawIShiftW<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr>
    : RVInst48<opcode, outs, ins, opcodestr, argstr, [], InstFormatI, ReitoFormatIS5> {
  bits<5> shamt; // Shift amount, in case you forgot it.
  bits<5> rs1;
  bits<5> rd;

  let Inst{36-25} = 0;
  let Inst{24-20} = shamt;
  let Inst{19-17} = 0;
  let Inst{16-12} = rs1;
  let Inst{11} = 0;
  let Inst{10-6} = rd;
}

class RVInstReitoQRawS<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr>
    : RVInst48<opcode, outs, ins, opcodestr, argstr, [], InstFormatS, ReitoFormatS> {
  bits<12> imm12;
  bits<5> rs2;
  bits<5> rs1;

  let Inst{36-32} = 0;
  let Inst{31-25} = imm12{11-5};
  let Inst{24-22} = 0;
  let Inst{21-17} = rs2;
  let Inst{16-12} = rs1;
  let Inst{11-7} = imm12{4-0};
  let Inst{6} = 0;
}

class RVInstReitoQRawB<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr>
    : RVInst48<opcode, outs, ins, opcodestr, argstr, [], InstFormatB, ReitoFormatB> {
  bits<12> imm12;
  bits<5> rs2;
  bits<5> rs1;

  let Inst{36-32} = 0;
  let Inst{31} = imm12{11};
  let Inst{30-25} = imm12{9-4};
  let Inst{24-22} = 0;
  let Inst{21-17} = rs2;
  let Inst{16-12} = rs1;
  let Inst{11-8} = imm12{3-0};
  let Inst{7} = imm12{10};
  let Inst{6} = 0;
}

class RVInstReitoQRawU<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr>
    : RVInst48<opcode, outs, ins, opcodestr, argstr, [], InstFormatU, ReitoFormatU> {
  bits<20> imm20;
  bits<5> rd;

  let Inst{36-32} = 0;
  let Inst{31-12} = imm20;
  let Inst{11} = 0;
  let Inst{10-6} = rd;
}

class RVInstReitoQRawJ<bits<11> opcode, dag outs, dag ins, string opcodestr, string argstr>
    : RVInst48<opcode, outs, ins, opcodestr, argstr, [], InstFormatJ, ReitoFormatJ> {
  bits<20> imm20;
  bits<5> rd;

  let Inst{36-32} = 0;
  let Inst{31} = imm20{19};
  let Inst{30-21} = imm20{9-0};
  let Inst{20} = imm20{10};
  let Inst{19-12} = imm20{18-11};
  let Inst{11} = 0;
  let Inst{10-6} = rd;
}
}

//===----------------------------------------------------------------------===//
// Instruction classes
//===----------------------------------------------------------------------===//

let Predicates = [HasVendorXReitoQ] in {

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstReitoQBranchCC<bits<11> opcode, string opcodestr>
    : RVInstReitoQRawB<opcode, (outs),
              (ins GPR:$rs1, GPR:$rs2, simm13_lsb0:$imm12),
              opcodestr, "$rs1, $rs2, $imm12">,
      Sched<[WriteJmp, ReadJmp, ReadJmp]> {
  let isBranch = 1;
  let isTerminator = 1;
}

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
class RvInstReitoQLoadRI<bits<11> opcode, string opcodestr>
    : RVInstReitoQRawI<opcode, (outs GPR:$rd), (ins GPRMem:$rs1, simm12:$imm12),
              opcodestr, "$rd, ${imm12}(${rs1})">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
class RvInstReitoQStoreRRI<bits<11> opcode, string opcodestr>
    : RVInstReitoQRawS<opcode, (outs),
              (ins GPR:$rs2, GPRMem:$rs1, simm12:$imm12),
              opcodestr, "$rs2, ${imm12}(${rs1})">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstReitoQAluRR<bits<11> opcode, string opcodestr, bit Commutable = 0>
    : RVInstReitoQRawR<opcode, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
              opcodestr, "$rd, $rs1, $rs2"> {
  let isCommutable = Commutable;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstReitoQAluWRR<bits<11> opcode, string opcodestr, bit Commutable = 0>
    : RVInstReitoQRawR<opcode, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
              opcodestr, "$rd, $rs1, $rs2"> {
  let isCommutable = Commutable;
}

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstReitoQAluRI<bits<11> opcode, string opcodestr>
    : RVInstReitoQRawI<opcode, (outs GPR:$rd), (ins GPR:$rs1, simm12:$imm12),
              opcodestr, "$rd, $rs1, $imm12">,
      Sched<[WriteIALU, ReadIALU]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstReitoQShiftRI<bits<11> opcode, string opcodestr>
    : RVInstReitoQRawIShift<opcode, (outs GPR:$rd),
                   (ins GPR:$rs1, uimmlog2xlen:$shamt), opcodestr,
                   "$rd, $rs1, $shamt">,
      Sched<[WriteShiftImm, ReadShiftImm]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class RvInstReitoQShiftWRI<bits<11> opcode, string opcodestr>
    : RVInstReitoQRawIShift<opcode, (outs GPR:$rd),
                   (ins GPR:$rs1, uimm5:$shamt), opcodestr,
                   "$rd, $rs1, $shamt">,
      Sched<[WriteShiftImm32, ReadShiftImm32]>;

} // Predicates
