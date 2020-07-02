


/// An accelarator interface.
interface cmd #(
  parameter ACC_DATA_WIDTH = 64,
  parameter ACC_INSTR_WIDTH = 32

);// the cmd interface

 

  typedef logic [ACC_INSTR_WIDTH-1:0]  instr_t;
  typedef logic [ACC_DATA_WIDTH-1:0]  data_t;
  
  instr_t  cmd_instr;
  data_t   cmd_rs1;
  data_t   cmd_rs2;
  logic    cmd_ready;
  logic    cmd_valid;

  modport core (
    input cmd_ready,
    output cmd_instr,cmd_rs1,cmd_rs2,cmd_valid
  );//modport for ariane

  modport acc (
    output cmd_ready,
    input cmd_instr,cmd_rs1,cmd_rs2,cmd_valid
  );//modport for accelerator

endinterface


//interface for accelarator response
interface resp
#(
  parameter ACC_DATA_WIDTH = 64,
  parameter ACC_REG_ADDR_WIDTH = 5
);

  typedef logic [ACC_DATA_WIDTH-1:0]  data_t;
  typedef logic [ACC_REG_ADDR_WIDTH-1:0] reg_addr_t;

  logic resp_valid;
  logic resp_ready;
  data_t resp_data;
  reg_addr_t resp_rd;

  modport core (
    input resp_data,resp_valid,resp_rd,
    output resp_ready
  );

  modport acc (
    output resp_data,resp_valid,resp_rd,
    input resp_ready
  );

endinterface

/*
//interface to req directly from memory
interface mem_req #(
  
);

  

  modport mmu ();

  modport acc ();

  

endinterface

// respond from memory to accelartor
interface mem_resp #(
  
);

  

  modport mmu ();

  modport acc ();

  

endinterface
*/
