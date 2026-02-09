module ControlUnit (
    input  wire clk,
    input  wire reset,
    input  wire flag_z,
    input  wire flag_n,

    output reg pc_out, pc_in, pc_inc,
    output reg r_in,
    output reg mar_in,
    output reg mdr_in, mdr_out,
    output reg read_mem, write_mem,
    output reg comp_alu,
    output reg save_flags 
);

    integer estado_atual;

    // --- Máquina de Estados Finitos (FSM) ---
    // Define a coreografia dos dados a cada pulso de clock.
    always @(posedge clk or posedge reset) begin
        if (reset) estado_atual <= 0;
        else begin
            case (estado_atual)
                0: estado_atual <= 1; // Start

                // == FASE 1: BUSCA DO PRIMEIRO OPERANDO (A) ==
                // O URISC usa Indireção: O código contém o ENDEREÇO de A, não o valor.
                // 1-3: Buscamos o ponteiro "A" na memória de programa.
                // 4-5: Usamos esse ponteiro para buscar o DADO real na memória de dados.
                1: estado_atual <= 2; 2: estado_atual <= 3;
                3: estado_atual <= 4; 4: estado_atual <= 5; 5: estado_atual <= 6;

                // == FASE 2: BUSCA DO SEGUNDO OPERANDO (B) ==
                // Mesmo processo: Busca Ponteiro -> Configura Endereço -> Busca Dado.
                // Ao final (Estado 9), o MAR (Registrador de Endereço) aponta para B.
                // Isso é crucial para gravarmos o resultado de volta em B depois.
                6: estado_atual <= 7; 7: estado_atual <= 8; 8: estado_atual <= 9;
                9: estado_atual <= 10;

                // == FASE 3: EXECUÇÃO (ALU) ==
                // Realiza a subtração B - A.
                10: estado_atual <= 11;

                // == FASE 4: WRITEBACK (Escrita) ==
                // Salva o resultado da subtração na memória (sobrescreve B).
                11: estado_atual <= 12;

                // == FASE 5: BUSCA DO DESTINO (C) E BRANCH ==
                // Busca o terceiro operando (C), que é o endereço de pulo.
                // Decide se altera o PC (Pulo) ou apenas incrementa (Próxima instrução).
                12: estado_atual <= 13;
                13: estado_atual <= 14; 
                14: estado_atual <= 1; // Reinicia o ciclo (Loop Infinito)
                default: estado_atual <= 0;
            endcase
        end
    end

    // --- Decodificação dos Sinais de Controle ---
    // Em cada estado, definimos quais "chaves" (tristates) do hardware ligar.
    always @(*) begin
        // Reset dos sinais (Segurança)
        pc_out = 0; pc_in = 0; pc_inc = 0; r_in = 0; mar_in = 0;
        mdr_in = 0; mdr_out = 0; read_mem = 0; write_mem = 0; comp_alu = 0;
        save_flags = 0; 

        case (estado_atual)
            // Lógica de Movimentação de Dados (Busca Indireta)
            1: begin pc_out = 1; mar_in = 1; read_mem = 1; end // PC -> MAR
            2: begin read_mem = 1; end                         // Espera Memória
            3: begin mdr_out = 1; mar_in = 1; end              // Ponteiro A -> MAR
            4: begin read_mem = 1; end                         // Lê Valor A
            5: begin mdr_out = 1; r_in = 1; pc_inc = 1; end    // Valor A -> Reg R (Guarda A)
            
            6: begin pc_out = 1; mar_in = 1; read_mem = 1; end // PC -> MAR (Buscando B)
            7: begin read_mem = 1; end
            8: begin mdr_out = 1; mar_in = 1; end              // Ponteiro B -> MAR
            9: begin read_mem = 1; end                         // Lê Valor B

            // --- PONTO CRÍTICO: A OPERAÇÃO ---
            10: begin
                mdr_out = 1;   // Coloca Valor B no Barramento
                comp_alu = 1;  // Ativa Subtração na ALU (Bus - R)
                mdr_in = 1;    // O resultado volta para o MDR
                read_mem = 0;  // Desliga memória para evitar conflito no barramento
                
                // Salva o estado da ALU (Zero/Negativo) neste exato momento.
                // Se não salvarmos aqui, perderemos essa informação no próximo clock.
                save_flags = 1; 
            end

            // Escrita na Memória
            11: begin write_mem = 1; pc_inc = 1; end // Grava MDR na pos B (MAR ainda aponta p/ B)

            // Preparação para o Pulo
            12: begin pc_out = 1; mar_in = 1; read_mem = 1; end // PC -> MAR (Endereço C)
            13: begin read_mem = 1; end // Lê C

            // --- PONTO CRÍTICO: DECISÃO (BRANCH) ---
            14: begin
                // Consulta as Flags que foram salvas no Estado 10.
                if (flag_z || flag_n) begin 
                    mdr_out = 1; // Coloca endereço C no barramento
                    pc_in = 1;   // Carga Paralela no PC (JUMP)
                end else begin
                    pc_inc = 1;  // Apenas avança PC (PC + 1)
                end
            end
        endcase
    end
endmodule