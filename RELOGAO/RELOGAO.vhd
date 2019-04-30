LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY RELOGAO is
	port(
		barulhinho: out std_logic;
		clock, reset, comeco: in std_logic := '0';
		SwitchDorSEGUNDOS, SwitchDorMINUTOS, SwitchDorHORA: in std_logic;
		SegAla, MinAla, HorAla, pushAla: in std_logic := '0';
		GMT: in std_LOGIC_VECTOR(3 downto 0);
		VERAOUNAO, alarme, para: in std_logic;
		ledAlarmeS: out std_logic := '0';
		piscaLed: out std_logic_vector(17 downto 0) := "000000000000000000";
		Saida: out std_logic_vector(55 downto 0);
		LCD_RS, LCD_E          		: OUT STD_LOGIC;
		LCD_RW                 		: OUT   STD_LOGIC;
		LCD_ON                 		: OUT STD_LOGIC;
		LCD_BLON               		: OUT STD_LOGIC;
		DATA_BUS              		: INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0)		
	);
end RELOGAO;

architecture arch_Reloginho of RELOGAO is
signal SaidaS1, SaidaS2, salvarAlarme: std_logic_vector(41 downto 0) := "000000100000010000001000000100000010000001";
signal seg1, seg2, min1, min2, hora1, hora2: std_logic_vector(3 downto 0) := "0000";
signal seg1A, seg2A, min1A, min2A, hora1A, hora2A: std_logic_vector(3 downto 0) := "0000";
SIGNAL display0, display1, display2, display3, display4, display5: std_LOGIC_VECTOR(3 downto 0);
SIGNAL display0s, display1s, display2s, display3s, display4s, display5s: std_LOGIC_VECTOR(3 downto 0);
SIGNAL tempo, salvaTempo, tempos: integer := 0;
signal pisca, clock_alarme, ledAlarme: std_logic := '0';
signal controle: std_LOGIC := '0';

component Divisor_Freq
	 port (
		 CLK: in std_logic;
		 sel: in std_logic;
		 COUT: out std_logic
		 );
 end component; 

component Contador_Sincrono_Dividido
	port(
		reset: in std_logic;
		clock, comeco: in std_logic;
		Ain, Bin, Cin, Din, Ein, Fin: in std_LOGIC_VECTOR(3 downto 0);
		Q0, Q1, Q2, Q3, Q4, Q5: out std_logic_vector(3 downto 0);
		controle: out std_LOGIC
	);
end component;

component Definir_TIME
port(
	clock, botao, reset, sel, controle: in std_logic;
	Q0, Q1: out std_logic_vector(3 downto 0)
	);
end component;

component display_7
port(
		A: in std_logic_vector(3 downto 0);
		S: out std_logic_vector(6 downto 0)	
	);
end component;

component Display_LCD
	PORT(
		tempo                  		: IN INTEGER;
		min1, min2, hora1, hora2	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		reset, CLOCK_50        		: IN  STD_LOGIC;
		LCD_RS, LCD_E          		: OUT STD_LOGIC;
		LCD_RW                 		: OUT   STD_LOGIC;
		LCD_ON                 		: OUT STD_LOGIC;
		LCD_BLON               		: OUT STD_LOGIC;
		DATA_BUS              		: INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0)		
	);
end component;

begin

lCdzinho: Display_LCD
	port map(tempo => tempo, min1 => min1A, min2 => min2A, hora1 => hora1A, hora2 => hora2A, reset => reset, CLOCK_50 => clock, LCD_RS => LCD_RS, LCD_E => LCD_E, LCD_RW => LCD_RW, LCD_ON => LCD_ON, LCD_BLON => LCD_BLON, DATA_BUS => DATA_BUS);

Saida(48 downto 42) <= "1111111";
Saida(55 downto 49) <= "1111111";

process(clock, GMT)
begin
	if clock'EVENT and clock = '1' then
		case GMT is
			when "0000" => tempos <= 0;
			when "0001" => tempos <= 1;
			when "0010" => tempos <= 2;
			when "0011" => tempos <= 3;
			when "0100" => tempos <= 4;
			when "0101" => tempos <= 5;
			when "0110" => tempos <= -1;
			when "0111" => tempos <= -2;
			when "1000" => tempos <= -3;
			when "1001" => tempos <= -4;
			when others => tempos <= NULL;
		end case;
	end if;
end process;

ClockAla: Divisor_Freq
	port map(CLK => clock, sel => '1', COUT => clock_alarme);

TEMPOSEG: Definir_TIME
	port map(controle => controle, clock => clock, botao => SwitchDorSEGUNDOS, reset => reset, Q0 => seg1, Q1 => seg2, sel => '0');

TEMPOMIN: Definir_TIME
	port map(controle => controle, clock => clock, botao => SwitchDorMINUTOS, reset => reset, Q0 => min1, Q1 => min2, sel => '0');
	
TEMPOHORA: Definir_TIME
	port map(controle => controle, clock => clock, botao => SwitchDorHORA, reset => reset, Q0 => hora1, Q1 => hora2, sel => '1');
	
Contador: Contador_Sincrono_Dividido
	port map(clock => clock, comeco => comeco, reset => reset, Ain => seg1, Bin => seg2, Cin => min1, Din => min2, Ein => hora1, Fin => hora2, Q0 => display0, Q1 => display1, Q2 => display2, Q3 => display3, Q4 => display4, Q5 => display5, controle => controle);

	--Alarme
process(alarme, reset, pushAla, clock_alarme)
begin
	if(reset = '0')then
		Saida(41 downto 0) <= "111111011111101111110111111011111101111110";
		ledAlarme <= '0';
		pisca <= '0';
		seg1A <= "0000";
		seg2A <= "0000";
		min1A <= "0000";
		min2A <= "0000";
		hora1A <= "0000";
		hora2A <= "0000";
	elsif(alarme = '1')then
		seg1A <= seg1;
		seg2A <= seg2;
		min1A <= min1;
		min2A <= min2;
		hora1A <= hora1;
		hora2A <= hora2;
		Saida(41 downto 0) <= SaidaS1;
	else
		Saida(41 downto 0) <= SaidaS1;
	end if;
	
	if(pushAla = '0')then
		salvarAlarme <= SaidaS2;
		ledAlarme <= '1';
	end if;
	
	if(ledAlarme = '1' and salvarAlarme = SaidaS1)then
		pisca <= '1';
	end if;
	if pisca = '1' then
		barulhinho <= clock_alarme;
	else
		barulhinho <= '0';
	end if;
	if((clock_alarme = '1') and (pisca = '1'))then
		piscaLed <= "111111111111111111";
	else
		piscaLed <= "000000000000000000";
	end if;
	if para = '0' then
		barulhinho <= '0';
		pisca <= '0';
		ledAlarme <= '0';
	end if;
	ledAlarmeS <= ledAlarme;
end process;
	
	
	--Process para calcular o GMT
process(display0, display1, display2, display3, display4, display5, tempo)
variable display0v, display1v, display2v, display3v, display4v, display5v: std_LOGIC_VECTOR(3 downto 0);
begin
	if(VERAOUNAO = '1')then
		tempo <= tempos + 1;
	else
		tempo <= tempos;
	end if;
	if(tempo /= 0)then
		display0v := display0;
		display1v := display1;
		display2v := display2;
		display3v := display3;
		display4v := display4 + tempo;
		display5v := display5;
		if(display5v = "0010")then
			if(display4v = "0100")then
				display5v := "0000";
				display4v := "0000";
			elsif(display4v = "0101")then
				display5v := "0000";
				display4v := "0001";
			elsif(display4v = "0110")then
				display5v := "0000";
				display4v := "0010";
			elsif(display4v = "0111")then
				display5v := "0000";
				display4v := "0011";
			elsif(display4v = "1000")then
				display5v := "0000";
				display4v := "0100";
			elsif(display4v = "1001")then
				display5v := "0000";
				display4v := "0101";
			elsif(display4v = "1111")then
				display5v := "0001";
				display4v := "1001";
			elsif(display4v = "1110")then
				display5v := "0001";
				display4v := "1000";
			elsif(display4v = "1101")then
				display5v := "0001";
				display4v := "0111";	
			elsif(display4v = "1100")then
				display5v := "0001";
				display4v := "0110";
			elsif(display4v = "1011")then
				display5v := "0001";
				display4v := "0101";
			end if;
		elsif(display5v = "0001")then
			if(tempo < 0)then
				if(display4v = "1111")then
					display5v := "0000";
					display4v := "1001";
				elsif(display4v = "1110")then
					display5v := "0000";
					display4v := "1000";
				elsif(display4v = "1101")then
					display5v := "0000";
					display4v := "0111";	
				elsif(display4v = "1100")then
					display5v := "0000";
					display4v := "0110";
				end if;
			elsif(tempo > 0)then
				if(display4v = "1010")then
					display5v := "0010";
					display4v := "0000";
				elsif(display4v = "1011")then
					display5v := "0010";
					display4v := "0001";
				elsif(display4v = "1100")then
					display5v := "0010";
					display4v := "0010";
				elsif(display4v = "1101")then
					display5v := "0010";
					display4v := "0011";
				elsif(display4v = "1110")then
					display5v := "0000";
					display4v := "0000";	
				elsif(display4v = "1111")then
					display5v := "0000";
					display4v := "0001";
				end if;
			end if;
		elsif(display5v = "0000")then
			if(tempo > 0)then
				if(display4v = "1010")then
					display5v := "0001";
					display4v := "0000";
				elsif(display4v = "1011")then
					display5v := "0001";
					display4v := "0001";
				elsif(display4v = "1100")then
					display5v := "0001";
					display4v := "0010";
				elsif(display4v = "1101")then
					display5v := "0001";
					display4v := "0011";
				elsif(display4v = "1110")then
					display5v := "0001";
					display4v := "0100";	
				elsif(display4v = "1111")then
					display5v := "0001";
					display4v := "0101";
				end if;
			elsif(tempo < 0)then
				if(display4v = "1111")then
					display5v := "0010";
					display4v := "0011";
				elsif(display4v = "1110")then
					display5v := "0010";
					display4v := "0010";
				elsif(display4v = "1101")then
					display5v := "0010";
					display4v := "0001";	
				elsif(display4v = "1100")then
					display5v := "0010";
					display4v := "0000";
				end if;
			end if;
		end if;
		display0s <= display0v;
		display1s <= display1v;
		display2s <= display2v;
		display3s <= display3v;
		display4s <= display4v;
		display5s <= display5v;
	else
		display0s <= display0;
		display1s <= display1;
		display2s <= display2;
		display3s <= display3;
		display4s <= display4;
		display5s <= display5;
	end if;
end process;
	
SEGUNDOS: display_7
	port map(A => display0s, S => SaidaS1(6 downto 0));
SEGUNDOS2: display_7
	port map(A => display1s, S => SaidaS1(13 downto 7));
MINUTOS: display_7
	port map(A => display2s, S => SaidaS1(20 downto 14));
MINUTOS2: display_7
	port map(A => display3s, S => SaidaS1(27 downto 21));
HORAS: display_7
	port map(A => display4s, S => SaidaS1(34 downto 28));
HORAS2: display_7
	port map(A => display5s, S => SaidaS1(41 downto 35));
	
SEGUNDOSA: display_7
	port map(A => seg1A, S => SaidaS2(6 downto 0));
SEGUNDOS2A: display_7
	port map(A => seg2A, S => SaidaS2(13 downto 7));
MINUTOSA: display_7
	port map(A => min1A, S => SaidaS2(20 downto 14));
MINUTOS2A: display_7
	port map(A => min2A, S => SaidaS2(27 downto 21));
HORASA: display_7
	port map(A => hora1A, S => SaidaS2(34 downto 28));
HORAS2A: display_7
	port map(A => hora2A, S => SaidaS2(41 downto 35));	

end arch_Reloginho;