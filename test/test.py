# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
  dut._log.info("Start")
  
  # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 10)
  dut.rst_n.value = 1

  # Load fib program
  dut.ui_in.value = 0x01
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x03
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x13
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x23
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x13
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x03
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x13
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x23
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x33
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x15
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x45
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x15
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x05
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x95
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x25
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x85
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x75
  await ClockCycles(dut.clk, 1)
  dut.ui_in.value = 0x01
  await ClockCycles(dut.clk, 1)

  # Run
  assert dut.uo_out.value == 0x00
  dut.ui_in.value = 0x07
  await ClockCycles(dut.clk, 1)  # outputs are a phase behind
  await ClockCycles(dut.clk, 1)  # Exec 0: Load acc =  1
  assert dut.uo_out.value == 0x11
  await ClockCycles(dut.clk, 1)  # Exec 1: Store [4]= 1
  assert dut.uo_out.value == 0x21
  await ClockCycles(dut.clk, 1)  # Exec 2: Add acc= 1, 1
  assert dut.uo_out.value == 0x32
  await ClockCycles(dut.clk, 1)  # Exec 3: Store [0]= 2
  assert dut.uo_out.value == 0x42
  await ClockCycles(dut.clk, 1)  # Exec 4: Load acc =  1
  assert dut.uo_out.value == 0x51
  await ClockCycles(dut.clk, 1)  # Exec 5: Store [2]= 1
  assert dut.uo_out.value == 0x61
  await ClockCycles(dut.clk, 1)  # Exec 6: Add acc= 1, 8
  assert dut.uo_out.value == 0x79
  await ClockCycles(dut.clk, 1)  # Exec 7: Bz  7 skipped
  assert dut.uo_out.value == 0x09
  await ClockCycles(dut.clk, 1)  # Exec 0: Load acc =  2
  assert dut.uo_out.value == 0x12
  await ClockCycles(dut.clk, 1)  # Exec 1: Store [4]= 2
  assert dut.uo_out.value == 0x22
  await ClockCycles(dut.clk, 1)  # Exec 2: Add acc= 2, 1
  assert dut.uo_out.value == 0x33
  await ClockCycles(dut.clk, 1)  # Exec 3: Store [0]= 3
  assert dut.uo_out.value == 0x43
  await ClockCycles(dut.clk, 1)  # Exec 4: Load acc =  2
  assert dut.uo_out.value == 0x52
  await ClockCycles(dut.clk, 1)  # Exec 5: Store [2]= 2
  assert dut.uo_out.value == 0x62
  await ClockCycles(dut.clk, 1)  # Exec 6: Add acc= 2, 8
  assert dut.uo_out.value == 0x7a
  await ClockCycles(dut.clk, 1)  # Exec 7: Bz  7 skipped
  assert dut.uo_out.value == 0x0a
  await ClockCycles(dut.clk, 1)  # Exec 0: Load acc =  3
  assert dut.uo_out.value == 0x13
  await ClockCycles(dut.clk, 1)  # Exec 1: Store [4]= 3
  assert dut.uo_out.value == 0x23
  await ClockCycles(dut.clk, 1)  # Exec 2: Add acc= 3, 2
  assert dut.uo_out.value == 0x35
  await ClockCycles(dut.clk, 1)  # Exec 3: Store [0]= 5
  assert dut.uo_out.value == 0x45
  await ClockCycles(dut.clk, 1)  # Exec 4: Load acc =  3
  assert dut.uo_out.value == 0x53
  await ClockCycles(dut.clk, 1)  # Exec 5: Store [2]= 3
  assert dut.uo_out.value == 0x63
  await ClockCycles(dut.clk, 1)  # Exec 6: Add acc= 3, 8
  assert dut.uo_out.value == 0x7b
  await ClockCycles(dut.clk, 1)  # Exec 7: Bz  7 skipped
  assert dut.uo_out.value == 0x0b
  await ClockCycles(dut.clk, 1)  # Exec 0: Load acc =  5
  assert dut.uo_out.value == 0x15
  await ClockCycles(dut.clk, 1)  # Exec 1: Store [4]= 5
  assert dut.uo_out.value == 0x25
  await ClockCycles(dut.clk, 1)  # Exec 2: Add acc= 5, 3
  assert dut.uo_out.value == 0x38
  await ClockCycles(dut.clk, 1)  # Exec 3: Store [0]= 8
  assert dut.uo_out.value == 0x48
  await ClockCycles(dut.clk, 1)  # Exec 4: Load acc =  5
  assert dut.uo_out.value == 0x55
  await ClockCycles(dut.clk, 1)  # Exec 5: Store [2]= 5
  assert dut.uo_out.value == 0x65
  await ClockCycles(dut.clk, 1)  # Exec 6: Add acc= 5, 8
  assert dut.uo_out.value == 0x7d
  await ClockCycles(dut.clk, 1)  # Exec 7: Bz  7 skipped
  assert dut.uo_out.value == 0x0d
  await ClockCycles(dut.clk, 1)  # Exec 0: Load acc =  8
  assert dut.uo_out.value == 0x18
  await ClockCycles(dut.clk, 1)  # Exec 1: Store [4]= 8
  assert dut.uo_out.value == 0x28
  await ClockCycles(dut.clk, 1)  # Exec 2: Add acc= 8, 5
  assert dut.uo_out.value == 0x3d
  await ClockCycles(dut.clk, 1)  # Exec 3: Store [0]=13
  assert dut.uo_out.value == 0x4d  # <<<< 0xd == 13, the final value
  await ClockCycles(dut.clk, 1)  # Exec 4: Load acc =  8
  assert dut.uo_out.value == 0x58
  await ClockCycles(dut.clk, 1)  # Exec 5: Store [2]= 8
  assert dut.uo_out.value == 0x68
  await ClockCycles(dut.clk, 1)  # Exec 6: Add acc= 8, 8
  assert dut.uo_out.value == 0x70
  await ClockCycles(dut.clk, 1)  # Exec 7: Bz  7 taken DONE!
  assert dut.uo_out.value == 0x70
