-- This file will be the fetch-decode-execute module of the processor
-- We will hold the register file, program counter, instruction register,

--this file will also handle memory addresses for where to store outputs
-- from the ALU

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPU is
	PORT(
			input_byte : in std_logic_vector(7 downto 0);
			load_byte : in std_logic
		);
end MPU;

architecture Behavioral of MPU is

type reg_file is array ( 31 downto 0) of std_logic_vector (31 downto 0);

-- the 32 , 32 bit registers
signal reg, reg_next : reg_file;
--the current instruction register
signal instruction_reg, instruction_reg_next : std_logic_vector (31 downto 0);
--the program counter
signal pc,pc_next : unsigned(31 downto 0);

begin


end Behavioral;

