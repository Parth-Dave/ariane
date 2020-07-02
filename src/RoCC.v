module RoCC (
    input  logic                     clk_i,
    input  logic                     rst_ni,
    input  logic                     flush_i,


    input  logic                     rocc_valid_i,  // Input is valid
    output logic                     rocc_ready_o,  // FU is ready e.g. not busy

    input  fu_data_t                 fu_data_i,
    input  logic [6:0]               rocc_instr_i,
    

    output logic [TRANS_ID_BITS-1:0] rocc_trans_id_o,
    output logic [63:0]              result_o,
    output logic                     rocc_valid_o, 
   
    cmd.core                         rocc_cmd_if,
    resp.core                        rocc_resp_if
);

logic                     cmd_valid_q;
logic [63:0]              cmd_rs1_q;
logic [63:0]              cmd_rs2_q;
logic [31:0]              cmd_instr_q;
logic [TRANS_ID_BITS-1:0] rocc_trans_id_d;

logic                     cmd_valid_d;
logic [63:0]              cmd_rs1_d;
logic [63:0]              cmd_rs2_d;
logic [31:0]              cmd_instr_d;
logic                     rocc_ready_q;
logic [TRANS_ID_BITS-1:0] rocc_trans_id_q;

enum logic {READY, STALL} state_q, state_d;

assign rocc_trans_id_d= fu_data_i.trans_id;




assign cmd_rs1_d  = fu_data_i.operand_a;
assign cmd_rs2_d  = fu_data_i.operand_b;
assign cmd_instr_d =  rocc_instr_i;
assign result_o = rocc_resp_if.resp_data;
    //---------------------------------------------------------
    // Upstream protocol inversion: InValid depends on InReady
    //---------------------------------------------------------

    always_comb begin : send_cmd_FSM
      // Default Values
      rocc_ready_o  = 1'b0;
      rocc_cmd_if.cmd_valid = 1'b0;
      hold_inputs = 1'b0;    // hold register disabled
      use_hold    = 1'b0;    // inputs go directly to unit
      state_d     = state_q; // stay in the same state

      // FSM
      unique case (state_q)
        // Default state, ready for instructions
        READY: begin
          rocc_ready_o  = 1'b1;        // Act as if RoCC ready
          rocc_cmd_if.cmd_valid = rocc_valid_i; // Forward input valid to RoCC
          // There is a transaction but the RoCC can't handle it
          if (rocc_valid_i & ~rocc_cmd_if.cmd_ready) begin
            rocc_ready_o = 1'b0;  // No token given to Issue
            hold_inputs = 1'b1;  // save inputs to the holding register
            state_d     = STALL; // stall future incoming requests
          end
        end
        // We're stalling the upstream (ready=0)
        STALL: begin
          rocc_cmd_if.cmd_valid = 1'b1; // we have data for the RoCC
          use_hold     = 1'b1; // the data comes from the hold reg
          // Wait until it's consumed
          if (rocc_cmd_if.cmd_ready) begin
            rocc_ready_o = 1'b1;  // Give a token to issue
            state_d     = READY; // accept future requests
          end
        end
        // Default: emit default values
        default: ;
      endcase

      // Flushing will override issue and go back to idle
      if (flush_i) begin
        state_d = READY;
      end

    end

     // Buffer register and FSM state holding
    always_ff @(posedge clk_i or negedge rst_ni) begin : rocc_hold_reg
      if(~rst_ni) begin
        state_q         <= READY;
        cmd_rs1_q       <= '0;
        cmd_rs2_q       <= '0;
        cmd_instr_q     <= '0;
        rocc_trans_id_q <= '0;
      end else begin
        state_q       <= state_d;
        // Hold register is [TRIGGERED] by FSM
        if (hold_inputs) begin
          cmd_rs1_q       <= cmd_rs1_d;
          cmd_rs2_q       <= cmd_rs2_d;
          cmd_instr_q     <= cmd_instr_d;
          rocc_trans_id_q <= rocc_trans_id_d;
        end
      end
    end

    /
    assign cmd_rs1  = use_hold ? cmd_rs1_q  : cmd_rs1_d;
    assign cmd_rs2  = use_hold ? cmd_rs2_q  : cmd_rs2_d;
    assign cmd_instr  = use_hold ? cmd_instr_q  : cmd_instr_d;
    assign rocc_trans_id_o = use_hold ? rocc_trans_id_q : rocc_trans_id_d;

  

    assign rocc_cmd_if.cmd_rs1  = cmd_rs1;
    assign rocc_cmd_if.cmd_rs2  = cmd_rs2;
    assign rocc_cmd_if.cmd_instr =  cmd_instr;
    assign rocc_valid_o = rocc_resp_if.resp_valid;

endmodule