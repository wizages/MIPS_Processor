-- This file will be the fetch-decode-execute module of the processor
-- We will hold the register file, program counter, instruction register,

--this file will also handle memory addresses for where to store outputs
-- from the ALU

library IEEE;
use work.types.all;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use work.types.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPU is
	PORT(
			input_byte : in std_logic_vector(7 downto 0);
			load_byte : in std_logic;
			clk : in std_logic;
			reset : in std_logic;
			displayOut : out std_logic_vector(7 downto 0)
		);
end MPU;

architecture Behavioral of MPU is

--type ALU_state_type is (idle,op_complete, ALU_add , ALU_sub , ALU_and , ALU_Or, ALU_beq);
--type reg_file_type is array ( 31 downto 0) of std_logic_vector (31 downto 0);


-- the 32 , 32 bit registers
signal reg, reg_next : reg_file_type;
--the current instruction register
signal instruction_reg, instruction_reg_next : std_logic_vector (31 downto 0) := (others =>'0');
--the program counter
signal pc,pc_next : unsigned(31 downto 0) := (others =>'0');
signal db : std_logic;
signal ALU_done_tick , ALU_ready_tick: std_logic;
signal ALU_result : std_logic_vector(31 downto 0) := (others =>'0');
signal displayResult,displayResult_next : std_logic_vector(31 downto 0) := (others=>'0');
type MPU_states is (load1,load1_wait,load2,load2_wait,load3,
					load3_wait,load4,load4_wait,op,op_wait,disp1,disp1_wait,disp2,disp2_wait,disp3,disp3_wait,disp4,disp4_wait);
signal state, state_next : MPU_states := load1;

begin
process (clk,reset)
begin
	if(rising_edge(clk)) then
		state <= state_next;
		pc <= pc_next;
		reg <= reg_next;
		instruction_reg <= instruction_reg_next;
		displayResult <=displayResult_next;
	end if;
	
	
end process;

--declare the alu, input an instruction and output a result on done tick
ALU : entity work.ALU(Behavioral)
	port map ( 	registers => reg,
				instruction => instruction_reg,
					result => ALU_result,
					ready_tick => ALU_ready_tick,
					done_tick => ALU_done_tick,
					clk => clk);
					
Debounce : entity work.debounce(Behavioral) port map ( clk => clk, reset => reset, sw => load_byte, db => db);
					
process(state, db, input_byte, ALU_ready_tick,pc, ALU_done_tick, ALU_result,displayResult)
begin			

state_next <= state;
				
case (state) is
	when load1 => 
		if db='1' then 
			state_next <= load1_wait;
			instruction_reg_next(31 downto 24) <= input_byte;
		end if;
		
	when load1_wait =>
		if db='0' then
			state_next <= load2;
		end if;
		
	when load2 =>
		if db='1' then
			state_next <= load2_wait;
			instruction_reg_next(23 downto 16) <= input_byte;
		end if;
		
	when load2_wait =>
		if db='0' then
			state_next <= load3;
		end if;
		
	when load3 =>
		if db='1' then
			state_next <= load3_wait;
			instruction_reg_next(15 downto 8) <= input_byte;
		end if;
		
	when load3_wait =>
		if db='0' then
			state_next <= load4;
		end if;
		
	when load4 =>
		if db='1' then
			state_next <= load4_wait;
			instruction_reg_next(7 downto 0) <= input_byte;
		end if;
		
	when load4_wait =>
		if db='0' then
			state_next <= op;
		end if;
		
	when op =>
		if  ALU_ready_tick='1' then		
			pc_next <= pc+1;
			state_next <= op_wait;
		end if;
		
when op_wait =>
		if ALU_done_tick='1' then
			displayResult_next <= ALU_result;
			state_next <= disp1;
		end if;
		
	when disp1=>
		if db='1' then
			state_next <= disp1_wait;
			displayOut <= displayResult(31 downto 24);
		end if;
		
when disp1_wait=>
		if db='0' then
			state_next <= disp2;
		end if;
		
	when disp2=>
		if db='1' then
			state_next <= disp2_wait;
			displayOut <= displayResult(23 downto 16);
		end if;
		
	when disp2_wait=>
		if db='0' then
			state_next <= disp3;
		end if;
		
	when disp3=>
		if db='1' then
			state_next <= disp3_wait;
			displayOut <= displayResult(15 downto 8);
		end if;
		
	when disp3_wait=>
		if db='0' then
			state_next <= disp4;
		end if;
		
	when disp4=>
		if db='1' then
			state_next <= disp4_wait;
			displayOut <= displayResult(7 downto 0);
		end if;
		
	when disp4_wait=>
		if db='0' then
			state_next <= load1;
		end if;
		
end case;
end process;

end Behavioral;

