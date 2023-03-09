//
// Created by reito on 2023/3/8.
//
#include "llvm/Support/CommandLine.h"
#include <iostream>

using namespace llvm;

namespace {
struct ReitoDescOutputOpt {
  void operator=(const std::string &Val) const {
    std::cout << Val;
  }
};

static ReitoDescOutputOpt ReitoDescOutputOptLoc;

struct CreateReitoDescOutput {
  static void *call() {
    return new cl::opt<ReitoDescOutputOpt, true, cl::parser<std::string>>(
        "reito-desc",
        cl::desc("Reito description output"),
        cl::NotHidden, cl::value_desc("path"),
        cl::location(ReitoDescOutputOptLoc), cl::Optional);
  }
};

static ManagedStatic<cl::opt<ReitoDescOutputOpt, true, cl::parser<std::string>>,
                     CreateReitoDescOutput>
    ReitoDescOutput;
}

namespace llvm {
void initReitoOptions() {
  *ReitoDescOutput;
}
}