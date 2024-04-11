/*
 * Copyright (c) 2024 Tommy Thorn
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none
`default_nettype none

// Instructions
`define Load 0
`define Store 1
`define Add 2
`define Bz 3

// Commands
`define Reset 0
`define LoadCode 1
`define LoadData 2
`define Run 3

module tt_um_tommythorn_4b_cpu_v2 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  assign uio_out = 0;
  assign uio_oe  = 0;

   // State
   reg [1:0]   code[7:0];
   reg [3:0]   data[7:0];
   reg [2:0]   pc;
   reg [3:0]   acc;

   wire [2:0]  npc = pc + 1;

   assign uo_out = {1'd0, pc, acc};
   wire [3:0]  arg = data[pc];

   always @(posedge clk)
       if (rst_n == 0) begin
           $display("        Reset");
           pc <= ui_in[6:4];
           acc <= 0;
       end else case (ui_in[2:1])
        `Reset: begin // XXX This is now redundant
           $display("        Reset");

           $display("%d %d %d", ui_in, ui_in[7:4], ui_in[7:4]);

           pc <= ui_in[6:4];
           acc <= 0;
        end
        `LoadCode: begin
           $display("        LoadCode %d: Insn %d", pc, ui_in[7:4]);
           code[pc] <= ui_in[5:4];
           pc <= npc;
        end
        `LoadData: begin
           $display("        LoadData %d: Data %d", pc, ui_in[7:4]);
           data[pc] <= ui_in[7:4];
           pc <= npc;
        end
        `Run: begin
           case (code[pc])
             `Load: begin
                $display("        Exec %d: Load acc = %d", pc, arg);
                acc <= arg; pc <= npc;
             end
             `Store: begin
                $display("        Exec %d: Store [%d]=%d", pc, arg[2:0], acc);
                data[arg[2:0]] <= acc; pc <= npc;
             end
             `Add: begin
                $display("        Exec %d: Add acc=%d,%d", pc, acc, arg);
                acc <= acc + arg; pc <= npc;
             end
             `Bz: begin
                if (acc == 0)
                  $display("        Exec %d: Bz %d taken", pc, arg);
                else
                  $display("        Exec %d: Bz %d skipped", pc, arg);
                pc <= acc == 0 ? arg[2:0] : npc;
             end
           endcase
           end
      endcase
endmodule

`ifdef TB
module tb;
   wire [7:0] ui_in;    // Dedicated inputs
   wire [7:0] uo_out;   // Dedicated outputs
   wire [7:0] uio_in;   // IOs: Input path
   wire [7:0] uio_out;  // IOs: Output path
   wire [7:0] uio_oe = 0;// IOs: Enable path (active high: 0=input; 1=output)
   wire       ena = 1;  // will go high when the design is enabled
   reg        clk = 1;  // clock
   wire       rst_n = 1;// reset_n - low to reset

   always #5 clk = !clk;

   reg [1:0] cmd;
   reg [3:0] cmdarg;

   assign ui_in = {cmdarg, 1'b0, cmd, clk};

   tt_um_tommythorn_4b_cpu_v2 inst_4b_cpu_v2
     (ui_in,    // Dedicated inputs
      uo_out,   // Dedicated outputs
      uio_in,   // IOs: Input path
      uio_out,  // IOs: Output path
      uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
      ena,      // will go high when the design is enabled
      clk,      // clk
      rst_n);   // reset_n - low to reset

   initial begin
      //$monitor("%05d  pc %d acc %d", $time, inst_4b_cpu_v2.pc, inst_4b_cpu_v2.acc);
      cmd = `Reset; cmdarg = 0;
      @(negedge clk)
      cmd = `LoadCode;

      cmdarg = `Load; @(negedge clk)
      cmdarg = `Store; @(negedge clk)

      cmdarg = `Add; @(negedge clk)
      cmdarg = `Store; @(negedge clk)

      cmdarg = `Load; @(negedge clk)
      cmdarg = `Store; @(negedge clk)

      cmdarg = `Add; @(negedge clk)
      cmdarg = `Bz; @(negedge clk)

      cmd = `LoadData;

      cmdarg = 1; @(negedge clk)
      cmdarg = 4; @(negedge clk)

      cmdarg = 1; @(negedge clk)
      cmdarg = 0; @(negedge clk)

      cmdarg = 9; @(negedge clk)
      cmdarg = 2; @(negedge clk)

      cmdarg = 8; @(negedge clk)
      cmdarg = 7; @(negedge clk)

      cmd = `Reset; cmdarg = 0;

      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;
      @(negedge clk) cmd = `Run;

      #100 $display("The End");
      $finish;
   end
endmodule
`endif
