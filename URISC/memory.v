module Memory(
    input  wire clk,
    input  wire [15:0] addr,     // Endereço de 16 bits (Vem do MAR)
    input  wire [15:0] data_in,  // 16 bits de dados (Vem do MDR)
    input  wire write_en,
    input  wire read_en,
    output reg  [15:0] data_out  //16 bits de dados (Vai para o MDR)
);


    reg [15:0] ram_block [0:(1<<10)-1];

    // 2. Escrita
    always @(posedge clk) begin
        if (write_en) begin

            ram_block[addr[9:0]] <= data_in;
        end
    end

    // 3. Leitura
    always @(*) begin
        if (read_en)
            data_out = ram_block[addr[9:0]];
        else
            data_out = 16'd0; // Zera saída 
    end

    // 4. Inicialização
    initial begin
        $readmemh("programa.hex", ram_block);
    end

endmodule