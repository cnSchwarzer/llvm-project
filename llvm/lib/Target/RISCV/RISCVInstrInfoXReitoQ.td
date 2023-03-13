//===----------------------------------------------------------------------===//
// Instruction Formats
//===----------------------------------------------------------------------===//

include "RISCVInstrFormatsReitoQ.td"

let Predicates = [HasVendorXReitoQ] in {
// Q should be in front of R, because some hack use same pattern.
// This is an ugly hack to ensure this instruction matcher is matched before original instruction
class ReitoQPat<dag pattern, dag result> : Pat<pattern, result> {
    let AddedComplexity = 99999;
}

class ReitoQPatGprGpr<SDPatternOperator OpNode, RVInstReitoQ Inst>
    : ReitoQPat<(OpNode GPR:$rs1, GPR:$rs2), (Inst GPR:$rs1, GPR:$rs2)>;

class ReitoQPatGprImm<SDPatternOperator OpNode, RVInstReitoQ Inst, ImmLeaf ImmType>
    : ReitoQPat<(XLenVT (OpNode (XLenVT GPR:$rs1), ImmType:$imm)),
          (Inst GPR:$rs1, ImmType:$imm)>;
class ReitoQPatGprSimm12<SDPatternOperator OpNode, RVInstReitoQ Inst>
    : ReitoQPatGprImm<OpNode, Inst, simm12>;
class ReitoQPatGprUimmLog2XLen<SDPatternOperator OpNode, RVInstReitoQ Inst>
    : ReitoQPatGprImm<OpNode, Inst, uimmlog2xlen>;
}

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
let isReMaterializable = 1, isAsCheapAsAMove = 1 in
def ReitoQ_LUI : RVInstReitoQRawU<0, (outs GPR:$rd), (ins uimm20_lui:$imm20),
                  "rq.lui", "$rd, $imm20">, Sched<[WriteIALU]>;

def ReitoQ_AUIPC : RVInstReitoQRawU<1, (outs GPR:$rd), (ins uimm20_auipc:$imm20),
                    "rq.auipc", "$rd, $imm20">, Sched<[WriteIALU]>;

let isCall = 1 in
def ReitoQ_JAL : RVInstReitoQRawJ<2, (outs GPR:$rd), (ins simm21_lsb0_jal:$imm20),
                  "rq.jal", "$rd, $imm20">, Sched<[WriteJal]>;

let isCall = 1 in
def ReitoQ_JALR : RVInstReitoQRawI<3, (outs GPR:$rd),
                   (ins GPR:$rs1, simm12:$imm12),
                   "rq.jalr", "$rd, ${imm12}(${rs1})">,
           Sched<[WriteJalr, ReadJalr]>;
} // hasSideEffects = 0, mayLoad = 0, mayStore = 0

def ReitoQ_BEQ  : RvInstReitoQBranchCC<4, "rq.beq">;
def ReitoQ_BNE  : RvInstReitoQBranchCC<5, "rq.bne">;
def ReitoQ_BLT  : RvInstReitoQBranchCC<6, "rq.blt">;
def ReitoQ_BGE  : RvInstReitoQBranchCC<7, "rq.bge">;
def ReitoQ_BLTU : RvInstReitoQBranchCC<8, "rq.bltu">;
def ReitoQ_BGEU : RvInstReitoQBranchCC<9, "rq.bgeu">;

def ReitoQ_LB  : RvInstReitoQLoadRI<10, "rq.lb">, Sched<[WriteLDB, ReadMemBase]>;
def ReitoQ_LH  : RvInstReitoQLoadRI<11, "rq.lh">, Sched<[WriteLDH, ReadMemBase]>;
def ReitoQ_LW  : RvInstReitoQLoadRI<12, "rq.lw">, Sched<[WriteLDW, ReadMemBase]>;
def ReitoQ_LBU : RvInstReitoQLoadRI<13, "rq.lbu">, Sched<[WriteLDB, ReadMemBase]>;
def ReitoQ_LHU : RvInstReitoQLoadRI<14, "rq.lhu">, Sched<[WriteLDH, ReadMemBase]>;

def ReitoQ_SB : RvInstReitoQStoreRRI<15, "rq.sb">, Sched<[WriteSTB, ReadStoreData, ReadMemBase]>;
def ReitoQ_SH : RvInstReitoQStoreRRI<16, "rq.sh">, Sched<[WriteSTH, ReadStoreData, ReadMemBase]>;
def ReitoQ_SW : RvInstReitoQStoreRRI<17, "rq.sw">, Sched<[WriteSTW, ReadStoreData, ReadMemBase]>;

// ALU_RIs
let isReMaterializable = 1, isAsCheapAsAMove = 1 in {
def ReitoQ_ADDI  : RvInstReitoQAluRI<18, "rq.addi">;
def ReitoQ_XORI  : RvInstReitoQAluRI<19, "rq.xori">;
def ReitoQ_ORI   : RvInstReitoQAluRI<20, "rq.ori">;
}
def ReitoQ_SLTI  : RvInstReitoQAluRI<21, "rq.slti">;
def ReitoQ_SLTIU : RvInstReitoQAluRI<22, "rq.sltiu">;
def ReitoQ_ANDI  : RvInstReitoQAluRI<23, "rq.andi">;

def ReitoQ_SLLI : RvInstReitoQShiftRI<24, "rq.slli">;
def ReitoQ_SRLI : RvInstReitoQShiftRI<25, "rq.srli">;
def ReitoQ_SRAI : RvInstReitoQShiftRI<26, "rq.srai">;

def ReitoQ_ADD  : RvInstReitoQAluRR<27, "rq.add", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoQ_SUB  : RvInstReitoQAluRR<28, "rq.sub">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoQ_XOR  : RvInstReitoQAluRR<29, "rq.xor", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoQ_OR   : RvInstReitoQAluRR<30, "rq.or", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoQ_AND  : RvInstReitoQAluRR<31, "rq.and", true>,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoQ_SLL  : RvInstReitoQAluRR<32, "rq.sll">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def ReitoQ_SRL  : RvInstReitoQAluRR<33, "rq.srl">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def ReitoQ_SRA  : RvInstReitoQAluRR<34, "rq.sra">,
                 Sched<[WriteShiftReg, ReadShiftReg, ReadShiftReg]>;
def ReitoQ_SLT  : RvInstReitoQAluRR<35, "rq.slt">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;
def ReitoQ_SLTU : RvInstReitoQAluRR<36, "rq.sltu">,
                 Sched<[WriteIALU, ReadIALU, ReadIALU]>;

/// RV64I instructions
def ReitoQ_LWU   : RvInstReitoQLoadRI<37, "rq.lwu">, Sched<[WriteLDW, ReadMemBase]>;
def ReitoQ_LD    : RvInstReitoQLoadRI<38, "rq.ld">, Sched<[WriteLDD, ReadMemBase]>;
def ReitoQ_SD    : RvInstReitoQStoreRRI<39, "rq.sd">, Sched<[WriteSTD, ReadStoreData, ReadMemBase]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def ReitoQ_ADDIW : RVInstReitoQRawI<40, (outs GPR:$rd), (ins GPR:$rs1, simm12:$imm12),
                    "rq.addiw", "$rd, $rs1, $imm12">, Sched<[WriteIALU32, ReadIALU32]>;

def ReitoQ_SLLIW : RvInstReitoQShiftWRI<41, "rq.slliw">;
def ReitoQ_SRLIW : RvInstReitoQShiftWRI<42, "rq.srliw">;
def ReitoQ_SRAIW : RvInstReitoQShiftWRI<43, "rq.sraiw">;

def ReitoQ_SLLW : RvInstReitoQAluWRR<44, "rq.sllw">,
                 Sched<[WriteShiftReg32, ReadShiftReg32, ReadShiftReg32]>;
def ReitoQ_SRLW : RvInstReitoQAluWRR<45, "rq.srlw">,
                 Sched<[WriteShiftReg32, ReadShiftReg32, ReadShiftReg32]>;
def ReitoQ_SRAW : RvInstReitoQAluWRR<46, "rq.sraw">,
                 Sched<[WriteShiftReg32, ReadShiftReg32, ReadShiftReg32]>;
def ReitoQ_ADDW : RvInstReitoQAluWRR<47, "rq.addw", true>,
                 Sched<[WriteIALU32, ReadIALU32, ReadIALU32]>;
def ReitoQ_SUBW : RvInstReitoQAluWRR<48, "rq.subw">,
                 Sched<[WriteIALU32, ReadIALU32, ReadIALU32]>;

//===----------------------------------------------------------------------===//
// Patterns
//===----------------------------------------------------------------------===//

def : InstAlias<"rq.li $rd, $imm",  (ReitoQ_ADDI GPR:$rd, X0, simm12:$imm)>;
def : InstAlias<"rq.mv $rd, $rs",   (ReitoQ_ADDI GPR:$rd, GPR:$rs,       0)>;
def : InstAlias<"rq.not $rd, $rs",  (ReitoQ_XORI GPR:$rd, GPR:$rs,      -1)>;
def : InstAlias<"rq.neg $rd, $rs",  (ReitoQ_SUB  GPR:$rd,      X0, GPR:$rs)>;

def : InstAlias<"rq.negw $rd, $rs",   (ReitoQ_SUBW  GPR:$rd,      X0, GPR:$rs)>;
def : InstAlias<"rq.sext.w $rd, $rs", (ReitoQ_ADDIW GPR:$rd, GPR:$rs,       0)>;

def : InstAlias<"rq.seqz $rd, $rs", (ReitoQ_SLTIU GPR:$rd, GPR:$rs,       1)>;
def : InstAlias<"rq.snez $rd, $rs", (ReitoQ_SLTU  GPR:$rd,      X0, GPR:$rs)>;
def : InstAlias<"rq.sltz $rd, $rs", (ReitoQ_SLT   GPR:$rd, GPR:$rs,      X0)>;
def : InstAlias<"rq.sgtz $rd, $rs", (ReitoQ_SLT   GPR:$rd,      X0, GPR:$rs)>;

def : InstAlias<"rq.sgt $rd, $rs, $rt", (ReitoQ_SLT GPR:$rd, GPR:$rt, GPR:$rs), 0>;
def : InstAlias<"rq.sgtu $rd, $rs, $rt", (ReitoQ_SLTU GPR:$rd, GPR:$rt, GPR:$rs), 0>;

def : InstAlias<"rq.beqz $rs, $offset", (ReitoQ_BEQ GPR:$rs,      X0, simm13_lsb0:$offset)>;
def : InstAlias<"rq.bnez $rs, $offset", (ReitoQ_BNE GPR:$rs,      X0, simm13_lsb0:$offset)>;
def : InstAlias<"rq.blez $rs, $offset", (ReitoQ_BGE      X0, GPR:$rs, simm13_lsb0:$offset)>;
def : InstAlias<"rq.bgez $rs, $offset", (ReitoQ_BGE GPR:$rs,      X0, simm13_lsb0:$offset)>;
def : InstAlias<"rq.bltz $rs, $offset", (ReitoQ_BLT GPR:$rs,      X0, simm13_lsb0:$offset)>;
def : InstAlias<"rq.bgtz $rs, $offset", (ReitoQ_BLT      X0, GPR:$rs, simm13_lsb0:$offset)>;

def : InstAlias<"rq.bgt $rs, $rt, $offset", (ReitoQ_BLT  GPR:$rt, GPR:$rs, simm13_lsb0:$offset), 0>;
def : InstAlias<"rq.ble $rs, $rt, $offset", (ReitoQ_BGE  GPR:$rt, GPR:$rs, simm13_lsb0:$offset), 0>;
def : InstAlias<"rq.bgtu $rs, $rt, $offset", (ReitoQ_BLTU GPR:$rt, GPR:$rs, simm13_lsb0:$offset), 0>;
def : InstAlias<"rq.bleu $rs, $rt, $offset", (ReitoQ_BGEU GPR:$rt, GPR:$rs, simm13_lsb0:$offset), 0>;

def : InstAlias<"rq.j $offset",   (ReitoQ_JAL X0, simm21_lsb0_jal:$offset)>;
def : InstAlias<"rq.jal $offset", (ReitoQ_JAL X1, simm21_lsb0_jal:$offset)>;

def : InstAlias<"rq.jr $rs",                (ReitoQ_JALR      X0, GPR:$rs, 0), 3>;
def : InstAlias<"rq.jr ${offset}(${rs})",   (ReitoQ_JALR      X0, GPR:$rs, simm12:$offset)>;
def : InstAlias<"rq.jalr $rs",              (ReitoQ_JALR      X1, GPR:$rs, 0), 3>;
def : InstAlias<"rq.jalr ${offset}(${rs})", (ReitoQ_JALR      X1, GPR:$rs, simm12:$offset)>;
def : InstAlias<"rq.jalr $rd, $rs",         (ReitoQ_JALR GPR:$rd, GPR:$rs, 0), 2>;
def : InstAlias<"rq.ret",                   (ReitoQ_JALR      X0,      X1, 0), 4>;

def : InstAlias<"rq.jr $rs, $offset",        (ReitoQ_JALR      X0, GPR:$rs, simm12:$offset), 0>;
def : InstAlias<"rq.jalr $rs, $offset",      (ReitoQ_JALR      X1, GPR:$rs, simm12:$offset), 0>;
def : InstAlias<"rq.jalr $rd, $rs, $offset", (ReitoQ_JALR GPR:$rd, GPR:$rs, simm12:$offset), 0>;

let EmitPriority = 0 in {
def : InstAlias<"rq.lb $rd, (${rs1})", (ReitoQ_LB  GPR:$rd, GPR:$rs1, 0)>;
def : InstAlias<"rq.lh $rd, (${rs1})", (ReitoQ_LH  GPR:$rd, GPR:$rs1, 0)>;
def : InstAlias<"rq.lw $rd, (${rs1})", (ReitoQ_LW  GPR:$rd, GPR:$rs1, 0)>;
def : InstAlias<"rq.lbu $rd, (${rs1})", (ReitoQ_LBU  GPR:$rd, GPR:$rs1, 0)>;
def : InstAlias<"rq.lhu $rd, (${rs1})", (ReitoQ_LHU  GPR:$rd, GPR:$rs1, 0)>;

def : InstAlias<"rq.sb $rs2, (${rs1})", (ReitoQ_SB  GPR:$rs2, GPR:$rs1, 0)>;
def : InstAlias<"rq.sh $rs2, (${rs1})", (ReitoQ_SH  GPR:$rs2, GPR:$rs1, 0)>;
def : InstAlias<"rq.sw $rs2, (${rs1})", (ReitoQ_SW  GPR:$rs2, GPR:$rs1, 0)>;

def : InstAlias<"rq.add $rd, $rs1, $imm12", (ReitoQ_ADDI  GPR:$rd, GPR:$rs1, simm12:$imm12)>;
def : InstAlias<"rq.and $rd, $rs1, $imm12", (ReitoQ_ANDI  GPR:$rd, GPR:$rs1, simm12:$imm12)>;
def : InstAlias<"rq.xor $rd, $rs1, $imm12", (ReitoQ_XORI  GPR:$rd, GPR:$rs1, simm12:$imm12)>;
def : InstAlias<"rq.or $rd, $rs1, $imm12", (ReitoQ_ORI  GPR:$rd, GPR:$rs1, simm12:$imm12)>;
def : InstAlias<"rq.sll $rd, $rs1, $shamt", (ReitoQ_SLLI  GPR:$rd, GPR:$rs1, uimmlog2xlen:$shamt)>;
def : InstAlias<"rq.srl $rd, $rs1, $shamt", (ReitoQ_SRLI  GPR:$rd, GPR:$rs1, uimmlog2xlen:$shamt)>;
def : InstAlias<"rq.sra $rd, $rs1, $shamt", (ReitoQ_SRAI  GPR:$rd, GPR:$rs1, uimmlog2xlen:$shamt)>;

def : InstAlias<"rq.lwu $rd, (${rs1})", (ReitoQ_LWU  GPR:$rd, GPR:$rs1, 0)>;
def : InstAlias<"rq.ld $rd, (${rs1})", (ReitoQ_LD  GPR:$rd, GPR:$rs1, 0)>;
def : InstAlias<"rq.sd $rs2, (${rs1})", (ReitoQ_SD  GPR:$rs2, GPR:$rs1, 0)>;

def : InstAlias<"rq.addw $rd, $rs1, $imm12", (ReitoQ_ADDIW  GPR:$rd, GPR:$rs1, simm12:$imm12)>;
def : InstAlias<"rq.sllw $rd, $rs1, $shamt", (ReitoQ_SLLIW  GPR:$rd, GPR:$rs1, uimm5:$shamt)>;
def : InstAlias<"rq.srlw $rd, $rs1, $shamt", (ReitoQ_SRLIW  GPR:$rd, GPR:$rs1, uimm5:$shamt)>;
def : InstAlias<"rq.sraw $rd, $rs1, $shamt", (ReitoQ_SRAIW  GPR:$rd, GPR:$rs1, uimm5:$shamt)>;

def : InstAlias<"rq.slt $rd, $rs1, $imm12", (ReitoQ_SLTI  GPR:$rd, GPR:$rs1, simm12:$imm12)>;
def : InstAlias<"rq.sltu $rd, $rs1, $imm12", (ReitoQ_SLTIU  GPR:$rd, GPR:$rs1, simm12:$imm12)>;
}

def : ReitoQPatGprGpr<add, ReitoQ_ADD>;
def : ReitoQPatGprSimm12<add, ReitoQ_ADDI>;
def : ReitoQPatGprGpr<sub, ReitoQ_SUB>;
def : ReitoQPatGprGpr<or, ReitoQ_OR>;
def : ReitoQPatGprSimm12<or, ReitoQ_ORI>;
def : ReitoQPatGprGpr<and, ReitoQ_AND>;
def : ReitoQPatGprSimm12<and, ReitoQ_ANDI>;
def : ReitoQPatGprGpr<xor, ReitoQ_XOR>;
def : ReitoQPatGprSimm12<xor, ReitoQ_XORI>;

def : ReitoQPatGprUimmLog2XLen<shl, ReitoQ_SLLI>;
def : ReitoQPatGprUimmLog2XLen<srl, ReitoQ_SRLI>;
def : ReitoQPatGprUimmLog2XLen<sra, ReitoQ_SRAI>;

def : ReitoQPatGprGpr<shiftop<shl>, ReitoQ_SLL>;
def : ReitoQPatGprGpr<shiftop<srl>, ReitoQ_SRL>;
def : ReitoQPatGprGpr<shiftop<sra>, ReitoQ_SRA>;

/// FrameIndex calculations
def : ReitoQPat<(FrameAddrRegImm GPR:$rs1, simm12:$imm12), (ReitoQ_ADDI GPR:$rs1, simm12:$imm12)>;

/// HI and ADD_LO address nodes.
def : ReitoQPat<(riscv_hi tglobaladdr:$in), (ReitoQ_LUI tglobaladdr:$in)>;
def : ReitoQPat<(riscv_hi tblockaddress:$in), (ReitoQ_LUI tblockaddress:$in)>;
def : ReitoQPat<(riscv_hi tjumptable:$in), (ReitoQ_LUI tjumptable:$in)>;
def : ReitoQPat<(riscv_hi tconstpool:$in), (ReitoQ_LUI tconstpool:$in)>;

def : ReitoQPat<(riscv_add_lo GPR:$hi, tglobaladdr:$lo), (ReitoQ_ADDI GPR:$hi, tglobaladdr:$lo)>;
def : ReitoQPat<(riscv_add_lo GPR:$hi, tblockaddress:$lo), (ReitoQ_ADDI GPR:$hi, tblockaddress:$lo)>;
def : ReitoQPat<(riscv_add_lo GPR:$hi, tjumptable:$lo), (ReitoQ_ADDI GPR:$hi, tjumptable:$lo)>;
def : ReitoQPat<(riscv_add_lo GPR:$hi, tconstpool:$lo), (ReitoQ_ADDI GPR:$hi, tconstpool:$lo)>;

def : ReitoQPatGprGpr<setlt, ReitoQ_SLT>;
def : ReitoQPatGprSimm12<setlt, ReitoQ_SLTI>;
def : ReitoQPatGprGpr<setult, ReitoQ_SLTU>;
def : ReitoQPatGprSimm12<setult, ReitoQ_SLTIU>;

/// Branches and jumps

// Match `riscv_brcc` and lower to the appropriate RISC-V branch instruction.
multiclass ReitoQBccPat<CondCode Cond, RVInstReitoQRawB Inst> {
  def : ReitoQPat<(riscv_brcc GPR:$rs1, GPR:$rs2, Cond, bb:$imm12),
            (Inst GPR:$rs1, GPR:$rs2, simm13_lsb0:$imm12)>;
  // Explicitly select 0 to X0. The register coalescer doesn't always do it.
  def : ReitoQPat<(riscv_brcc GPR:$rs1, 0, Cond, bb:$imm12),
            (Inst GPR:$rs1, X0, simm13_lsb0:$imm12)>;
}

defm : ReitoQBccPat<SETEQ, ReitoQ_BEQ>;
defm : ReitoQBccPat<SETNE, ReitoQ_BNE>;
defm : ReitoQBccPat<SETLT, ReitoQ_BLT>;
defm : ReitoQBccPat<SETGE, ReitoQ_BGE>;
defm : ReitoQBccPat<SETULT, ReitoQ_BLTU>;
defm : ReitoQBccPat<SETUGE, ReitoQ_BGEU>;

/// Loads Stores

multiclass ReitoQLdPat<PatFrag LoadOp, RVInstReitoQ Inst, ValueType vt = XLenVT> {
  def : ReitoQPat<(vt (LoadOp (AddrRegImm GPR:$rs1, simm12:$imm12))),
            (Inst GPR:$rs1, simm12:$imm12)>;
}

multiclass ReitoQStPat<PatFrag StoreOp, RVInstReitoQ Inst, RegisterClass StTy,
                 ValueType vt> {
  def : ReitoQPat<(StoreOp (vt StTy:$rs2), (AddrRegImm GPR:$rs1, simm12:$imm12)),
            (Inst StTy:$rs2, GPR:$rs1, simm12:$imm12)>;
}

defm : ReitoQLdPat<sextloadi8, ReitoQ_LB>;
defm : ReitoQLdPat<extloadi8, ReitoQ_LB>;
defm : ReitoQLdPat<sextloadi16, ReitoQ_LH>;
defm : ReitoQLdPat<extloadi16, ReitoQ_LH>;
defm : ReitoQLdPat<zextloadi8, ReitoQ_LBU>;
defm : ReitoQLdPat<zextloadi16, ReitoQ_LHU>;

defm : ReitoQStPat<truncstorei8, ReitoQ_SB, GPR, XLenVT>;
defm : ReitoQStPat<truncstorei16, ReitoQ_SH, GPR, XLenVT>;

/// RV64 patterns

def : ReitoQPatGprGpr<shiftopw<riscv_sllw>, ReitoQ_SLLW>;
def : ReitoQPatGprGpr<shiftopw<riscv_srlw>, ReitoQ_SRLW>;
def : ReitoQPatGprGpr<shiftopw<riscv_sraw>, ReitoQ_SRAW>;

// Select W instructions if only the lower 32 bits of the result are used.
def : ReitoQPatGprGpr<binop_allwusers<add>, ReitoQ_ADDW>;
def : ReitoQPatGprSimm12<binop_allwusers<add>, ReitoQ_ADDIW>;
def : ReitoQPatGprGpr<binop_allwusers<sub>, ReitoQ_SUBW>;
def : ReitoQPatGprImm<binop_allwusers<shl>, ReitoQ_SLLIW, uimm5>;

defm : ReitoQLdPat<sextloadi32, ReitoQ_LW, i64>;
defm : ReitoQLdPat<extloadi32, ReitoQ_LW, i64>;
defm : ReitoQLdPat<zextloadi32, ReitoQ_LWU, i64>;
defm : ReitoQLdPat<load, ReitoQ_LD, i64>;

defm : ReitoQStPat<truncstorei32, ReitoQ_SW, GPR, i64>;
defm : ReitoQStPat<store, ReitoQ_SD, GPR, i64>;
