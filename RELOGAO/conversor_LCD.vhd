LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity conversor_LCD is
port(
	tempo                  		: IN INTEGER;
	min1, min2, hora1, hora2	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	linha0,coluna0, linha1,coluna1, linha2,coluna2, linha3,coluna3, linha4,coluna4,linha5,coluna5, linha6,coluna6,
	linha7,coluna7, linha8,coluna8, linha9,coluna9, linha10,coluna10, linha11,coluna11, linha12,coluna12, linha13,coluna13,
	linha14,coluna14, linha15,coluna15, linha16,coluna16, linha17,coluna17, linha18,coluna18, linha19,coluna19, linha20,coluna20,
	linha21,coluna21, linha22,coluna22, linha23,coluna23, linha24,coluna24, linha25,coluna25, linha26,coluna26, linha27,coluna27,
	linha28,coluna28, linha29,coluna29: out STD_LOGIC_vector (3 downto 0)
	);
end entity;

architecture Behavioral of conversor_LCD is
signal tempo_bin: std_LOGIC_vector(3 downto 0);

component conversor_ASCII
	port(
		num: in std_logic_vector(3 downto 0);
		linha: out std_logic_vector(3 downto 0);
		coluna: out std_logic_vector(3 downto 0)
	);
end component;

begin

min1c: conversor_ASCII
	port map(num => min1, linha => linha14, coluna => coluna14);
min2c: conversor_ASCII
	port map(num => min2, linha => linha13, coluna => coluna13);
hora1c: conversor_ASCII
	port map(num => hora1, linha => linha11, coluna => coluna11);
hora2c: conversor_ASCII
	port map(num => hora2, linha => linha10, coluna => coluna10);
GMT: conversor_ASCII
	port map(num => tempo_bin, linha => linha22, coluna => coluna22);


process(tempo)
begin
	if(tempo > 0)then
		linha21 <= "0010";
		coluna21 <= "1011";
	elsif(tempo < 0)then
		linha21 <= "0010";
		coluna21 <= "1101";
	else
		linha21 <= "0010";
		coluna21 <= "0000";
	end if;
end process;
 
 
	linha0<="0100";	--A
	linha1<="0110";	--l
	linha2<="0110";	--a
	linha3<="0111";	--r
	linha4<="0110";	--m
	linha5<="0110";	--e
	linha6<="0010";	--space
	linha7<="0010";	--(-)
	linha8<="0011";	-->
	linha9<="0010";	--space

	linha12<="0011";	--:


	linha15<="0010";	--space
	
	--segunda linha do display
	linha16<="0100";	--G
	linha17<="0100";	--M
	linha18<="0101";	--T
	linha19<="0011";	--:
	linha20<="0010";	--space


	linha23<="0010";	--space
	linha24<="0010";	--space
	linha25<="0010";	--space
	linha26<="0010";	--space
	linha27<="0010";	--space
	linha28<="0010";	--space
	linha29<="0010";	--space
	
	--primeira linha do display
	coluna0<="0001";	--A
	coluna1<="1100";	--l
	coluna2<="0001";	--a
	coluna3<="0010";	--r
	coluna4<="1101";	--m
	coluna5<="0101";	--e
	coluna6<="0000";	--space
	coluna7<="1101";	--(-)
	coluna8<="1110";	-->
	coluna9<="0000";	--space

	coluna12<="1010";	--:


	coluna15<="0000";	--space
	--segunda linha do display
	coluna16<="0111";	--G
	coluna17<="1101";	--M
	coluna18<="0100";	--T
	coluna19<="1010";	--:
	coluna20<="0000";	--space

	coluna23<="0000";	--space
	coluna24<="0000";	--space
	coluna25<="0000";	--space
	coluna26<="0000";	--space
	coluna27<="0000";	--space
	coluna28<="0000";	--space
	coluna29<="0000";	--space
	
	tempo_bin <=
		"0000" WHEN tempo = 0 ELSE
		"0001" WHEN tempo = 1 ELSE
		"0010" WHEN tempo = 2 ELSE
		"0011" WHEN tempo = 3 ELSE
		"0100" WHEN tempo = 4 ELSE
		"0101" WHEN tempo = 5 ELSE
		"0001" WHEN tempo = -1 ELSE
		"0010" WHEN tempo = -2 ELSE
		"0011" WHEN tempo = -3 ELSE
		"0100" WHEN tempo = -4;
		
end Behavioral;