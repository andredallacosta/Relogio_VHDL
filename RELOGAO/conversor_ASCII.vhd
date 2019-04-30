LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity conversor_ASCII is
	port(
		num: in std_logic_vector(3 downto 0);
		linha: out std_logic_vector(3 downto 0);
		coluna: out std_logic_vector(3 downto 0)
	);
end conversor_ASCII;

Architecture arch_conversor_ASCII of conversor_ASCII is
begin

	linha <= 
		"0011" WHEN num="0000" ELSE
		"0011" WHEN num="0001" ELSE
		"0011" WHEN num="0010" ELSE
		"0011" WHEN num="0011" ELSE
		"0011" WHEN num="0100" ELSE
		"0011" WHEN num="0101" ELSE
		"0011" WHEN num="0110" ELSE
		"0011" WHEN num="0111" ELSE
		"0011" WHEN num="1000" ELSE
		"0011" WHEN num="1001";
		
	coluna <=
		"0000" WHEN num="0000" ELSE
		"0001" WHEN num="0001" ELSE
		"0010" WHEN num="0010" ELSE
		"0011" WHEN num="0011" ELSE
		"0100" WHEN num="0100" ELSE
		"0101" WHEN num="0101" ELSE
		"0110" WHEN num="0110" ELSE
		"0111" WHEN num="0111" ELSE
		"1000" WHEN num="1000" ELSE
		"1001" WHEN num="1001";
		
end arch_conversor_ASCII;
			