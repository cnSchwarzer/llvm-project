//===----------------------------------------------------------------------===//
// Instruction Formats
//===----------------------------------------------------------------------===//

include "RISCVInstrFormatsReito.td"

// This is an ugly hack to ensure this instruction matcher is matched before original instruction
class ReitoPat<dag pattern, dag result> : Pat<pattern, result> {
    let AddedComplexity = 99999;
}

class ReitoPatGprGpr<SDPatternOperator Inst, RVInstCustom Custom>
    : ReitoPat<(Inst GPR:$rs1, GPR:$rs2), (Custom GPR:$rs1, GPR:$rs2)>;

//===----------------------------------------------------------------------===//
// Operand definitions.
//===----------------------------------------------------------------------===//

// Begin with very basic instructions
// ADD SUB XOR OR AND
def REITO_ADD  : RvInstCustomAluRR<0, OPC_CUSTOM_0, "reito.add", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def REITO_SUB  : RvInstCustomAluRR<1, OPC_CUSTOM_0, "reito.sub">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def REITO_XOR  : RvInstCustomAluRR<2, OPC_CUSTOM_0, "reito.xor", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def REITO_OR   : RvInstCustomAluRR<3, OPC_CUSTOM_0, "reito.or", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def REITO_AND  : RvInstCustomAluRR<4, OPC_CUSTOM_0, "reito.and", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def : ReitoPatGprGpr<add, REITO_ADD>;
def : ReitoPatGprGpr<sub, REITO_SUB>;
def : ReitoPatGprGpr<xor, REITO_XOR>;
def : ReitoPatGprGpr<or, REITO_OR>;
def : ReitoPatGprGpr<and, REITO_AND>;

// SLL SRL SRA
def REITO_SLL  : RvInstCustomAluRR<5, OPC_CUSTOM_0, "reito.sll">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def REITO_SRL  : RvInstCustomAluRR<6, OPC_CUSTOM_0, "reito.srl">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def REITO_SRA  : RvInstCustomAluRR<7, OPC_CUSTOM_0, "reito.sra">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def : ReitoPatGprGpr<shiftop<shl>, REITO_SLL>;
def : ReitoPatGprGpr<shiftop<srl>, REITO_SRL>;
def : ReitoPatGprGpr<shiftop<sra>, REITO_SRA>;

// Compare rs1 rs2 set result to rd
// SLT SLTU
let IsSignExtendingOpW = 1 in {
def REITO_SLT  : RvInstCustomAluRR<8, OPC_CUSTOM_0, "reito.slt">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def REITO_SLTU : RvInstCustomAluRR<9, OPC_CUSTOM_0, "reito.sltu">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
}
def : ReitoPatGprGpr<setlt, REITO_SLT>;
def : ReitoPatGprGpr<setult, REITO_SLTU>;

