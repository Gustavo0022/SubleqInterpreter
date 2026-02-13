module Processor (
    input wire clk,
    input wire reset
);
    // --- Barramento de Controle (O "Sistema Nervoso") ---
    // Estes fios transportam os comandos da Unidade de Controle para ativar/desativar
    // componentes específicos no Datapath (ex: abrir a porta do PC, gravar na Memória).
    wire ctrl_pc_out, ctrl_pc_in, ctrl_pc_inc;
    wire ctrl_r_in, ctrl_mar_in;
    wire ctrl_mdr_in, ctrl_mdr_out;
    wire ctrl_read_mem, ctrl_write_mem;
    wire ctrl_comp_alu;
    
    // Sinal crítico para arquiteturas sequenciais:
    // Como a decisão de pulo (Branch) ocorre ciclos DEPOIS da subtração,
    // precisamos congelar (salvar) o resultado das Flags Z e N.
    wire ctrl_save_flags; 

    // --- Sinais de Status (Feedback) ---
    // O Datapath informa ao Controle o resultado da última operação matemática.
    wire status_z;
    wire status_n;

    // --- 1. Instância do Cérebro (Unidade de Controle) ---
    // Responsável por orquestrar a sequência de micro-operações.
    // Em URISC, como só há uma instrução, não há "Decodificação de Opcode",
    // apenas uma máquina de estados fixa.
    ControlUnit controle (
        .clk(clk),
        .reset(reset),
        // Entradas: Toma decisões baseadas no estado atual do processador (Flags)
        .flag_z(status_z),
        .flag_n(status_n),
        // Saídas: Comanda os componentes
        .pc_out(ctrl_pc_out), .pc_in(ctrl_pc_in), .pc_inc(ctrl_pc_inc),
        .r_in(ctrl_r_in), .mar_in(ctrl_mar_in),
        .mdr_in(ctrl_mdr_in), .mdr_out(ctrl_mdr_out),
        .read_mem(ctrl_read_mem), .write_mem(ctrl_write_mem),
        .comp_alu(ctrl_comp_alu),
        
        .save_flags(ctrl_save_flags) 
    );

    // --- 2. Instância do Corpo (Datapath) ---
    // Onde os dados realmente fluem e são processados.
    // Contém os Registradores, a ALU e a Memória.
    Datapath caminho (
        .clk(clk),
        .reset(reset),
        // Recebe ordens cegas do Controle
        .pc_out(ctrl_pc_out), .pc_in(ctrl_pc_in), .pc_inc(ctrl_pc_inc),
        .r_in(ctrl_r_in), .mar_in(ctrl_mar_in),
        .mdr_in(ctrl_mdr_in), .mdr_out(ctrl_mdr_out),
        .read_mem(ctrl_read_mem), .write_mem(ctrl_write_mem),
        .comp_alu(ctrl_comp_alu),
        
        .save_flags(ctrl_save_flags),

        // Envia o status do processamento
        .flag_z(status_z),
        .flag_n(status_n)
    );
endmodule