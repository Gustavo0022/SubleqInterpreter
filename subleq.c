#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {

    // Memória representada por um array
    int* mem, quantidade;
    char buffer[256] = "";
    int buf_ptr = 0;

    if (argc <= 1) {
        printf("Digite a quantidade de enderecos: \n");
        scanf("%d", &quantidade);

        mem = (int*) calloc(quantidade,sizeof(int));
        
        for (int i = 0; i < quantidade; i++) {
            printf("%d:", i);
            scanf("%d", &mem[i]);
        }
    }
    else{
        FILE *arquivo = fopen(argv[1], "r");
        fscanf(arquivo,"%d", &quantidade);

        mem = (int*) calloc(quantidade,sizeof(int));
        
        for(int i = 0; i< quantidade; i++){
            fscanf(arquivo,"%d", &mem[i]);
        }
        fclose(arquivo);
    }

    printf("\nMemory map:");
    for(int i = 0; i< quantidade; i+=3){
        printf("\n%d:\t %d\t %d\t %d", i , mem[i], mem[i+1], mem[i+2]);
    }

    printf("\n");

    int pc = 0;
    while (pc >= 0 && pc < 255) {
        
        // Debug da execução atual
        printf("\n%d: %d %d %d", pc, mem[pc], mem[pc+1], mem[pc+2]);
        
        // Verifica se os endereços A e B são válidos
        if (mem[pc] >= 0 && mem[pc+1] >= -1) {
             printf("\t\t@ %d: %d  @ %d: %d", mem[pc], mem[mem[pc]], mem[pc+1], (mem[pc+1] == -1 ? 0 : mem[mem[pc+1]]));
        }

        if (mem[pc+1] == -1) {
            char c = (char)mem[mem[pc]];
            printf("\t\tChar: mem[%d]: %d (%c)", mem[pc], mem[mem[pc]], c);
            
            // Adiciona ao buffer de mensagem (string)
            if (buf_ptr < 255) {
                buffer[buf_ptr++] = c;
                buffer[buf_ptr] = '\0';
            }
            pc = pc + 3;
        } 
        else {
            // Lógica SUBLEQ
            int addrA = mem[pc];
            int addrB = mem[pc+1];
            int targetPC = mem[pc+2];

            printf("\t\t%d - %d = %d", mem[addrB], mem[addrA], mem[addrB] - mem[addrA]);
            
            mem[addrB] = mem[addrB] - mem[addrA];

            if (mem[addrB] <= 0) {
                pc = targetPC;
            } else {
                pc += 3;
            }
            if (pc < 0) {
                printf("\nSystem Halt @ %d: %d %d %d", pc, addrA, addrB, targetPC);
                break;
            }
        }
    }

    printf("\n\nmessage: %s\n", buffer);
    return 0;
}