-- This file will take in an arithmetic or logical instruction
-- and perform it, and output it.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	PORT (
				instruction : in std_logic_vector(31 downto 0);
				result : out std_logic_vector (31 downto 0)
			);



end ALU;

architecture Behavioral of ALU is

type state_type is (ALU_add , ALU_sub , ALU_and , ALU_Or, ALU_beq);

signal state, state_next : state_type;

begin


end Behavioral;

