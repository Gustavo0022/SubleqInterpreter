module ALU (
    input  wire [15:0] bus_in,  // Operando B (Vem do Barramento)
    input  wire [15:0] r_in,    // Operando A (Vem do Registrador R)
    input  wire comp,           // Sinal de Controle: 0=Soma, 1=Subtração
    output wire [15:0] result,  // Resultado
    output wire flag_n,         // Flag Negativo (Bit mais significativo)
    output wire flag_z          // Flag Zero (Nor de todos os bits)
);

    // --- Lógica do Complemento de 2 ---
    // Para subtrair A de B (B - A), o hardware faz: B + (~A) + 1
    
    // 1. Inversão (NOT):
    // Se o sinal 'comp' estiver ativo, invertemos todos os bits de A.
    wire [15:0] r_ajustado;
    assign r_ajustado = (comp) ? ~r_in : r_in;

    // 2. Somador (Adder):
    // Somamos B + A_invertido.
    // O trunfo: O sinal 'comp' (que é 1 na subtração) é somado na entrada de Carry In.
    // Isso completa a lógica do "+1" do Complemento de 2.
    assign result = bus_in + r_ajustado + comp;

    // 3. Geração de Flags:
    // Estas flags são geradas combinacionalmente (instantaneamente).
    assign flag_z = (result == 16'd0); 
    assign flag_n = result[15]; // Em complemento de 2, o bit 15 é o sinal.

endmodule