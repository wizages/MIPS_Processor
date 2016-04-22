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
			clk : in std_logic
		);
end MPU;

architecture Behavioral of MPU is

--type ALU_state_type is (idle,op_complete, ALU_add , ALU_sub , ALU_and , ALU_Or, ALU_beq);
--type reg_file_type is array ( 31 downto 0) of std_logic_vector (31 downto 0);


-- the 32 , 32 bit registers
signal reg, reg_next : reg_file_type;
--the current instruction register
signal instruction_reg, instruction_reg_next : std_logic_vector (31 downto 0);
--the program counter
signal pc,pc_next : unsigned(31 downto 0);
signal ALU_done_tick , ALU_ready_tick: std_logic;
signal ALU_result : std_logic_vector(31 downto 0);

begin

ALU : entity work.ALU(Behavioral)
	
	port map ( 	registers => reg,
					instruction => instruction_reg,
					result => ALU_result,
					ready_tick => ALU_ready_tick,
					done_tick => ALU_done_tick,
					clk => clk);

end Behavioral;

