LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Contador_Sincrono_Dividido IS
port(
	reset: in std_logic;
	clock, comeco: in std_logic;
	Ain, Bin, Cin, Din, Ein, Fin: in std_LOGIC_VECTOR(3 downto 0);
	Q0, Q1, Q2, Q3, Q4, Q5: out std_logic_vector(3 downto 0);
	controle: out std_logic
	);
end Contador_Sincrono_Dividido;

architecture arch_Contador_Sincrono_Dividido of Contador_Sincrono_Dividido is
signal new_clock: std_logic := '0';
signal A, B, C, D, E, F: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

component Divisor_Freq
port(
		 CLK: in std_logic;
		 sel: in std_logic;
		 COUT: out std_logic
	);
end component;

begin

Divisor: Divisor_Freq
	port map(CLK => clock, cout => new_clock, sel => '0');

process (new_clock, reset)
variable aux: integer := 0;
begin
	if reset = '0' then
		aux := 0;
		controle <= '0';
		A <= "0000";
		B <= "0000";
		C <= "0000";
		D <= "0000";
		E <= "0000";
		F <= "0000";
	elsif (comeco = '1') and (aux = 0) then
		A <= Ain;
		B <= Bin;
		C <= Cin;
		D <= Din;
		E <= Ein;
		F <= Fin;
		Q0 <= Ain;
		Q1 <= Bin;
		Q2 <= Cin;
		Q3 <= Din;
		Q4 <= Ein;
		Q5 <= Fin;
		aux := 0;
	else
		if (comeco = '0') or (aux = 1) then
			if(new_clock'EVENT and new_clock = '1') then
				aux := 1;
				controle <= '1';
				if F = "0010" and E >= "0011" and D = "0101" and C = "1001" and B = "0101" and A = "1001" then
					F <= "0000";
					E <= "0000";
					D <= "0000";
					C <= "0000";
					B <= "0000";
					A <= "0000";
				else
					A <= A + 1;
					if A = "1001" then
						A <= "0000";
						B <= B + 1;
						if B = "0101" then
							B <= "0000";
							C <= C + 1;
							if C = "1001" then
								C <= "0000";
								D <= D + 1;
								if D = "0101" then
									D <= "0000";
									E <= E + 1;
									if E = "1001" then
										E <= "0000";
										F <= F + 1;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
				Q0 <= A;
				Q1 <= B;
				Q2 <= C;
				Q3 <= D;
				Q4 <= E;
				Q5 <= F;
			end if;
		end if;
	end if;
end process;
end arch_Contador_Sincrono_Dividido;
