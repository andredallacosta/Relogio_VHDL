LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;


ENTITY Definir_TIME IS
port(
	clock, botao, reset, sel, controle: in std_logic;
	Q0, Q1: out std_logic_vector(3 downto 0)
	);
end Definir_TIME;

architecture arc_Definir_TIME of Definir_TIME is
signal newclock: std_logic;
signal A, B: std_logic_vector(3 downto 0);

component Divisor_Freq
port(
		 CLK: in std_logic;
		 sel: in std_logic;
		 COUT: out std_logic
	);
end component;

Begin

DIV: Divisor_Freq
	port map(CLK => clock, COUT => newclock, sel => '1');

Process(newclock, reset)
Begin
	if reset = '0' then
		A <= "0000";
		B <= "0000";
		Q0 <= "0000";
		Q1 <= "0000";
	elsif(newclock'EVENT and newclock = '1') then
		if(botao = '1') then
			if sel = '0' then
				A <= A + 1;
				if A = "1001" then
					A <= "0000";
					B <= B + 1;
					if B = "0101" then
						B <= "0000";
					end if;
				end if;
			Q0 <= A;
			Q1 <= B;
			elsif sel = '1' then
				A <= A + 1;
				if B = "0010" and A = "0011" then
						B <= "0000";
						A <= "0000";
				end if;
				if A = "1001" then
					A <= "0000";
					B <= B + 1;
				end if;
			Q0 <= A;
			Q1 <= B;
			end if;
		end if;
	end if;
end process;
end arc_Definir_TIME;