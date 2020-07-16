module accelerator (
    ROCC_CMD.acc  acc_cmd_if,
    ROCC_RESP.acc acc_resp_if
);
//Sample accelerator
/*User can either implement their RoCC accelerators here or in a seperate module and replace accelerator module with that module in ariane.sv*/
assign acc_cmd_if.cmd_ready = 1'b1;
assign acc_resp_if.resp_data = 64'b0;
assign acc_resp_if.resp_valid = 1'b1;
assign acc_resp_if.resp_rd = 5'b0;
endmodule