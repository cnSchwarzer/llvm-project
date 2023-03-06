//
// Created by reito on 2023/3/4.
//

#include "RISCVReitoDesc.h"

using namespace reito;

static RISCVReitoDesc ReitoDesc;

RISCVReitoDesc *RISCVReitoDesc::get() {
  return &ReitoDesc;
}
