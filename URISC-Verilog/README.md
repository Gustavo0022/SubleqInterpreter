# URISC VERILOG

Este é um projeto de um processador URISC (Ultimate Reduced Instruction Set Computer) de 16 bits desenvolvido em Verilog. 
O processador opera com uma única instrução (subtração com desvio condicional se menor ou igual a zero).

## Estrutura dos Módulos

- **Processor (URISC.v)**: O módulo de topo que conecta a Unidade de Controle ao Datapath.

- **Control Unit (controlUnit.v)**: Implementa uma Máquina de Estados Finitos (FSM) que orquestra o fluxo de dados

- **Datapath (Datapath.v)**: Contém os componentes de armazenamento e processamento, incluindo PC, MAR, MDR, R e a Memória.


- **ALU (Alu.v)**: Unidade Lógica e Aritmética que realiza a subtração via Complemento de 2 e gera as flags Zero e Negativo.

- **Register (Register.v)**: Módulo de registrador genérico com suporte a carga paralela e incremento.

O código no programa.hex tenta simular uma maquina de Minsky, ele possui um endereço A e B em que A possui um valor inicial e B é 0 
o código irá subtrair 1 de A e adicionar 1 em B em em loop até que A seja 0. Será possível observar esse valores mudando ao executar a simulação.


**Use 

```sh
make
```
 
 e 
 
 ```sh
 make wave
 ``` 
 
 neste diretório para visualizar o código rodando no URISC.**


