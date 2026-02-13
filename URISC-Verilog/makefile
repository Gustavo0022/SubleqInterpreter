# --- Configurações do Projeto ---
# Nome do arquivo executável da simulação
SIM_NAME = simulacao

# Lista de todos os seus arquivos Verilog
# A ordem importa pouco aqui, mas é bom listar todos
FILES = Testbench.v \
        URISC.v \
        Datapath.v \
        controlUnit.v \
        memory.v \
        Alu.v \
        Register.v

# Ferramentas (Compilador e Simulador)
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

# --- Regras (Targets) ---

# 1. Regra Padrão (digite apenas 'make' para rodar isso)
all: compile run

# 2. Compilar: Transforma os .v em um executável
compile:
	@echo "Compilando arquivos..."
	$(COMPILER) -o $(SIM_NAME) $(FILES)

# 3. Rodar: Executa a simulação e mostra o output no terminal
run:
	@echo "Rodando simulação..."
	$(SIMULATOR) $(SIM_NAME)

# 4. Ver Ondas: Abre o GTKWave (se você tiver instalado)
wave:
	@echo "Abrindo formas de onda..."
	$(VIEWER) urisc_wave.vcd &

# 5. Limpar: Remove arquivos gerados
clean:
	@echo "Limpando arquivos temporários..."
	rm -f $(SIM_NAME) urisc_wave.vcd

# 6. Ajuda
help:
	@echo "Opções disponíveis:"
	@echo "  make        -> Compila e roda a simulação (Padrão)"
	@echo "  make compile-> Apenas compila o código"
	@echo "  make run    -> Apenas roda o executável já compilado"
	@echo "  make wave   -> Abre o visualizador de ondas GTKWave"
	@echo "  make clean  -> Remove executáveis e arquivos de onda"