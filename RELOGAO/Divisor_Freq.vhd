Library IEEE;
use IEEE.std_logic_1164.all;

 entity Divisor_Freq is
	 port (
		 CLK: in std_logic;
		 sel: in std_logic;
		 COUT: out std_logic
		 );
 end Divisor_Freq; 

 architecture arc_Divider of Divisor_Freq is 
 constant TIMECONST : integer := 69;
 signal count0, count1, count2, count3: integer range 0 to 1000 := 0;
 signal D: std_logic := '0';

 begin 
	process(CLK)
	begin
		if(CLK'EVENT and CLK = '1')then
			if sel = '0' then
				count0 <= count0 + 1;
				if (count0 >= TIMECONST) then
					count0 <= 0;
					count1 <= count1 + 1;
				elsif (count1 >= TIMECONST) then
					count1 <= 0;
					count2 <= count2 + 1;
				elsif (count2 >= TIMECONST) then
					count2 <= 0;
					count3 <= count3 + 1;
				elsif (count3 >= TIMECONST) then
					count3 <= 0;
					D <= not D;
				end if;
			elsif sel = '1' then
				count0 <= count0 + 1 * 4;
				if (count0 >= TIMECONST) then
					count0 <= 0;
					count1 <= count1 + 1;
				elsif (count1 >= TIMECONST) then
					count1 <= 0;
					count2 <= count2 + 1;
				elsif (count2 >= TIMECONST) then
					count2 <= 0;
					count3 <= count3 + 1;
				elsif (count3 >= TIMECONST) then
					count3 <= 0;
					D <= not D;
				end if;
			end if;
		end if;
		COUT <= D;
	end process;
end arc_Divider;
