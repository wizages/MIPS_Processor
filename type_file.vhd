--This file will hold all type defs that we use

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

PACKAGE types is


type ALU_state_type is (idle,op_complete, ALU_add , ALU_sub , ALU_and , ALU_Or, ALU_beq);
type reg_file_type is array ( 31 downto 0) of std_logic_vector (31 downto 0);

end package;

package body types is

end package body;
