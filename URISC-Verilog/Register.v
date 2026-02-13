module Register #(
    parameter WIDTH = 16,
    parameter HAS_INC = 0 // 0 = Registrador Comum, 1 = Registrador com Soma
)(
    input  wire clk,
    input  wire reset,
    input  wire load,       // Carga paralela (ex: Pulo/Branch)
    input  wire inc,
    input  wire [WIDTH-1:0] data_in,
    output reg  [WIDTH-1:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 0;
        end else if (load) begin
            data_out <= data_in;
        end else if (HAS_INC && inc) begin
            // Só compila essa lógica se HAS_INC = 1
            data_out <= data_out + 1;
        end
    end

endmodule