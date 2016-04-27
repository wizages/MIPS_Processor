----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:29:51 04/27/2016 
-- Design Name: 
-- Module Name:    debounce - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           sw : in  STD_LOGIC;
           db : out  STD_LOGIC);
end debounce;

architecture Behavioral of debounce is

constant N: integer:=19; -- 2^N * 20ns ˜ 10ms tick
signal q_reg, q_next: unsigned(N-1 downto 0);
signal m_tick: std_logic;
type eg_state_type is(zero,wait1_1,wait1_2,wait1_3, one,wait0_1,wait0_2,wait0_3);
signal state_reg, state_next: eg_state_type;

begin

process(clk)
	begin
		if (clk'event and clk='1') then
			q_reg <= q_next;
		end if;
end process;

q_next <= q_reg + 1;
m_tick <= '1' when q_reg=0 else '0';

process(clk,reset)
	begin
		if (reset='1') then
			state_reg <= zero;
		elsif (clk'event and clk='1') then
			state_reg <= state_next;
		end if;
end process;process(state_reg,sw,m_tick)
	begin
		state_next <= state_reg; --default: back to -
		--same state
		db <= '0'; -- default 0
		case state_reg is
			when zero =>
				if sw='1' then
					state_next <= wait1_1;
				else state_next <=zero;
				end if;
			when wait1_1 =>
				if sw='0' then
					state_next <= zero;
				else
					if m_tick='1' then
						state_next <= wait1_2;
					end if;
				end if;

			when wait1_2 =>
					if sw='0' then
						state_next <= zero;
					else
						if m_tick='1' then
							state_next <= wait1_3;
						end if;
					end if;
			when wait1_3 =>
					if sw='0' then
						state_next <= zero;
					else
						if m_tick='1' then
							state_next <= one;
						end if;
					end if;
			when one =>
				db <='1';
				if sw='0' then
					state_next <= wait0_1;
				end if;
			when wait0_1 =>
				db <='1';
				if sw='1' then
					state_next <= one;
				else
					if m_tick='1' then
						state_next <= wait0_2;
					end if;
				end if;

			when wait0_2 =>
				db <='1';
				if sw='1' then
					state_next <= one;
				else
					if m_tick='1' then
						state_next <= wait0_3;
					end if;
				end if;
			when wait0_3 =>
				db <='1';
				if sw='1' then
					state_next <= one;
				else
					if m_tick='1' then
						state_next <= zero;
					end if;
				end if;
		end case;
end process;

end Behavioral;

