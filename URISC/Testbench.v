`timescale 1ns / 1ps

module Testbench;

    // 1. Sinais para conectar no Processador
    reg clk;
    reg reset;

    // 2. Instância do Processador (UUT - Unit Under Test)
    Processor uut (
        .clk(clk),
        .reset(reset)
    );

    // 3. Geração de Clock (Periodo = 10ns)
    always #5 clk = ~clk;

    // 4. Bloco de Teste Principal
    initial begin
        // Configuração Inicial (Gera arquivo de onda para visualizar depois)
        $dumpfile("urisc_wave.vcd");
        $dumpvars(0, Testbench);

        // Inicializa sinais
        clk = 0;
        reset = 1;

        // Print de Cabeçalho
        $display("-------------------------------------------------------------");
        $display("Tempo | PC  | Estado | MAR  | MDR  | R (A)| Mem[9] (Var B)");
        $display("-------------------------------------------------------------");

        // Solta o Reset após um tempo
        #10 reset = 0;

        #2000; 
        
        $display("-------------------------------------------------------------");
        $display("FIM DA SIMULACAO");
        $finish;
    end

    // 5. Monitoramento (Imprime no console a cada borda de subida do clock)
    // Acessamos os sinais internos usando o ponto (.) ex: uut.controle.estado_atual
    always @(posedge clk) begin
        if (!reset) begin
            $display("%4t  | %3d |   %2d   | %4x | %4x | %4x |      %4x", 
                $time, 
                uut.caminho.PC.data_out,       // Valor do PC
                uut.controle.estado_atual,     // Estado da FSM
                uut.caminho.MAR.data_out,      // Valor do MAR
                uut.caminho.MDR.data_out,      // Valor do MDR
                uut.caminho.R.data_out,        // Valor de R (Operando A)
                uut.caminho.RAM.ram_block[9]  // Espionando a memória diretamente (Endereço 11)
            );
        end
    end

endmodule