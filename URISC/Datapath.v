module Datapath (
    input  wire clk,
    input  wire reset,

    // Sinais de Controle
    input  wire pc_in, pc_out,
    input  wire pc_inc,
    input  wire r_in,
    input  wire mar_in,
    input  wire mdr_in, mdr_out,
    input  wire read_mem, write_mem,
    input  wire comp_alu,
    input  wire save_flags, // <--- NOVO SINAL (Importante!)

    // Saídas para a Unidade de Controle
    output reg flag_z,      // <--- Virou REG (Memória)
    output reg flag_n       // <--- Virou REG (Memória)
);

    wire [15:0] bus;
    wire [15:0] pc_val;
    wire [15:0] r_val;
    wire [15:0] mar_val;
    wire [15:0] mdr_val_out;
    wire [15:0] mem_data_out;
    wire [15:0] alu_result;
    wire [15:0] mdr_data_in;

    // Fios temporários para a saída instantânea da ALU
    wire alu_z_instantaneo;
    wire alu_n_instantaneo;

    assign bus = (pc_out)  ? pc_val :
                 (mdr_out) ? mdr_val_out :
                 16'd0;

    // --- Lógica de Salvamento das Flags ---
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            flag_z <= 0;
            flag_n <= 0;
        end else if (save_flags) begin
            // Tira uma "foto" das flags neste exato momento
            flag_z <= alu_z_instantaneo;
            flag_n <= alu_n_instantaneo;
        end
    end

    // --- Componentes ---
    Register #(.WIDTH(16), .HAS_INC(1)) PC (.clk(clk), .reset(reset), .load(pc_in), .inc(pc_inc), .data_in(bus), .data_out(pc_val));
    Register #(.WIDTH(16), .HAS_INC(0)) R (.clk(clk), .reset(reset), .load(r_in), .inc(1'b0), .data_in(bus), .data_out(r_val));
    Register #(.WIDTH(16), .HAS_INC(0)) MAR (.clk(clk), .reset(reset), .load(mar_in), .inc(1'b0), .data_in(bus), .data_out(mar_val));
    
    assign mdr_data_in = (read_mem) ? mem_data_out : (comp_alu) ? alu_result : bus;
    wire mdr_load_enable = mdr_in | read_mem; 
    Register #(.WIDTH(16)) MDR (.clk(clk), .reset(reset), .load(mdr_load_enable), .data_in(mdr_data_in), .data_out(mdr_val_out));
    
    Memory RAM (.clk(clk), .addr(mar_val), .data_in(mdr_val_out), .write_en(write_mem), .read_en(read_mem), .data_out(mem_data_out));

    // --- ALU Conectada aos Fios Temporários ---
    ALU alu_instance (
        .bus_in(bus),
        .r_in(r_val),
        .comp(comp_alu),
        .result(alu_result),
        .flag_z(alu_z_instantaneo), // Conecta aqui
        .flag_n(alu_n_instantaneo)  // Conecta aqui
    );

endmodule