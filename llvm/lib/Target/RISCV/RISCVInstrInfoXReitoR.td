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
def ReitoR_ADD  : RvInstReitoRAluRR<10, OPC_CUSTOM_2, "rr.add", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_SUB  : RvInstReitoRAluRR<11, OPC_CUSTOM_2, "rr.sub">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_XOR  : RvInstReitoRAluRR<12, OPC_CUSTOM_2, "rr.xor", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_OR   : RvInstReitoRAluRR<13, OPC_CUSTOM_2, "rr.or", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoR_AND  : RvInstReitoRAluRR<14, OPC_CUSTOM_2, "rr.and", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def : ReitoRPatGprGpr<add, ReitoR_ADD>;
def : ReitoRPatGprGpr<sub, ReitoR_SUB>;
def : ReitoRPatGprGpr<xor, ReitoR_XOR>;
def : ReitoRPatGprGpr<or, ReitoR_OR>;
def : ReitoRPatGprGpr<and, ReitoR_AND>;


