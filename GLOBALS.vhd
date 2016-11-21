
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package GLOBALS is
constant J:			integer :=3; --number of parallelizations
constant N:			integer :=10;
constant Nbit: 		integer :=8;

--type reg_link_t is array((N/J) downto 0) of std_logic_vector(Nbit-1 downto 0);
type reg_link_type_0 is array(11 downto 0) of signed(Nbit-1 downto 0);				--signal from the  first and second input x[3k],x[3k+1]
type reg_link_type_1 is array(12 downto 0) of signed(Nbit-1 downto 0);					--signal from the  second input x[3k+1]
type reg_link_type_2 is array(13 downto 0) of signed(Nbit-1 downto 0);					--signal from the  second input x[3k+1]
type add_type  is array (((N)*J)-1 downto 0) of signed((2*Nbit)+N-1 downto 0);
type mult_type  is array (((N+1)*J)-1 downto 0) of signed((2*Nbit)-1 downto 0);
end GLOBALS;