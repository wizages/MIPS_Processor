-- This file will take in an arithmetic or logical instruction
-- and perform it, and output it.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use type_definitions.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	PORT (
				registers : in reg_file_type;
				instruction : in std_logic_vector(31 downto 0);
				result : out std_logic_vector (31 downto 0);
				ready : out std_logic;
				done_tick : out std_logic;
				clk : in std_logic
			);



end ALU;

architecture Behavioral of ALU is


signal state, state_next : ALU_state_type;
signal result_reg : unsigned(31 downto 0);
signal done,done_next : std_logic;
signal ready,ready_next : std_logic;

begin

process (clk)
begin

if(rising_edge(clk) ) then
	state <= state_next;
	done <= done_next;
	ready <= ready_next;
end if;


end process;

process(state,result,done_tick)
begin

--insert defaults
state_next <= idle;
result <= (others => '0');
ready_next <= '0';
done_next <='0';

	case state is

		when idle =>	
			if(instruction = (others => '0')) then
				state_next <= idle;
				ready_next <='1';
			elsif (instruction ( 5 downto 0) = "100000") then
				state_next <= ALU_add;
			elsif (instruction ( 5 downto 0) = "100010") then
				state_next <= ALU_sub;
			elsif (instruction (5 downto 0) = "100100") then
				state_next <= ALU_and;
			elsif (instruction (5 downto 0) = "100101") then
				state_next <= ALU_Or;
				
			-- not really sure if this goes in the ALU or not...
			elsif (instruction (5 downto 0) = "100101") then
				state_next <= ALU_beq;	
			end if;

		when ALU_add =>
			result_reg <= registers(unsigned(instruction(25 downto 21))) + registers(unsigned(instruction(20 downto 16)));
			state_next <= op_complete;
		
		when ALU_sub =>
			result_reg <= registers(unsigned(instruction(25 downto 21))) - registers(unsigned(instruction(20 downto 16)));
			state_next <= op_complete;
			
		when ALU_and =>
			result_reg <= registers(unsigned(instruction(25 downto 21))) and registers(unsigned(instruction(20 downto 16)));
			state_next <= op_complete;
			
		when ALU_Or =>
			result_reg <= registers(unsigned(instruction(25 downto 21))) or registers(unsigned(instruction(20 downto 16)));
			state_next <= op_complete;
		
		--again still not sure about the nature of this one
		when ALU_beq =>
		
		when op_complete =>
			result <= std_logic_vector(result_reg);
			done_next <='1';
	end case;

end process;

-- done tick process
process(done)
begin
if(rising_edge(done)) then
	done_tick <= '1';
else
	done_tick <='0';
end if;
end process;

process(ready)
begin
if(rising_edge(done)) then
	ready_tick <= '1';
else
	ready_tick <='0';
end if;
end process;


end Behavioral;

