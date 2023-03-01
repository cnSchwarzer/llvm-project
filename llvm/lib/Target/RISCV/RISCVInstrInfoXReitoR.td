//===----------------------------------------------------------------------===//
// Instruction Formats
//===----------------------------------------------------------------------===//

include "RISCVInstrFormatsReitoR.td"

// This is an ugly hack to ensure this instruction matcher is matched before original instruction
class ReitoRPat<dag pattern, dag result> : Pat<pattern, result> {
    let AddedComplexity = 99999;
}

let Predicates = [HasVendorXReitoR] in {
class ReitoRPatGprGpr<SDPatternOperator Inst, RVInstReitoR Custom>
    : ReitoRPat<(Inst GPR:$rs1, GPR:$rs2), (Custom GPR:$rs1, GPR:$rs2)>;
}

//===----------------------------------------------------------------------===//
// Operand definitions.
//===----------------------------------------------------------------------===//

// Begin with very basic instructions
// ADD SUB XOR OR AND
def ReitoR_ADD  : RvInstReitoRAluRR<0, OPC_CUSTOM_0, "rr.add", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_SUB  : RvInstReitoRAluRR<1, OPC_CUSTOM_0, "rr.sub">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_XOR  : RvInstReitoRAluRR<2, OPC_CUSTOM_0, "rr.xor", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_OR   : RvInstReitoRAluRR<3, OPC_CUSTOM_0, "rr.or", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_AND  : RvInstReitoRAluRR<4, OPC_CUSTOM_0, "rr.and", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def : ReitoRPatGprGpr<add, ReitoR_ADD>;
def : ReitoRPatGprGpr<sub, ReitoR_SUB>;
def : ReitoRPatGprGpr<xor, ReitoR_XOR>;
def : ReitoRPatGprGpr<or, ReitoR_OR>;
def : ReitoRPatGprGpr<and, ReitoR_AND>;

// SLL SRL SRA
def ReitoR_SLL  : RvInstReitoRAluRR<5, OPC_CUSTOM_0, "rr.sll">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def ReitoR_SRL  : RvInstReitoRAluRR<6, OPC_CUSTOM_0, "rr.srl">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def ReitoR_SRA  : RvInstReitoRAluRR<7, OPC_CUSTOM_0, "rr.sra">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def : ReitoRPatGprGpr<shiftop<shl>, ReitoR_SLL>;
def : ReitoRPatGprGpr<shiftop<srl>, ReitoR_SRL>;
def : ReitoRPatGprGpr<shiftop<sra>, ReitoR_SRA>;

// Compare rs1 rs2 set result to rd
// SLT SLTU
let IsSignExtendingOpW = 1 in {
def ReitoR_SLT  : RvInstReitoRAluRR<8, OPC_CUSTOM_0, "rr.slt">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_SLTU : RvInstReitoRAluRR<9, OPC_CUSTOM_0, "rr.sltu">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
}
def : ReitoRPatGprGpr<setlt, ReitoR_SLT>;
def : ReitoRPatGprGpr<setult, ReitoR_SLTU>;

// SLLW SRLW SRAW
def ReitoR_SLLW : RvInstReitoRAluRR<10, OPC_CUSTOM_0, "rr.sllw">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def ReitoR_SRLW : RvInstReitoRAluRR<11, OPC_CUSTOM_0, "rr.srlw">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def ReitoR_SRAW : RvInstReitoRAluRR<12, OPC_CUSTOM_0, "rr.sraw">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def ReitoR_ADDW : RvInstReitoRAluRR<13, OPC_CUSTOM_0, "rr.addw", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_SUBW : RvInstReitoRAluRR<14, OPC_CUSTOM_0, "rr.subw">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;


