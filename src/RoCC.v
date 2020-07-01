module RoCC (
    input  logic                     clk_i,
    input  logic                     rst_ni,
    input  logic                     flush_i,


    input  rocc_data_t               rocc_data_i,
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





endmodule