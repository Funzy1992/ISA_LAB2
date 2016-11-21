library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use work.globals.all;
library std;
use std.textio.all;

entity data_maker is  
  port (
    CLK     : in  std_logic;
    RST_n   : in  std_logic;
	VOUT    : out std_logic;
  DOUT_0    : out std_logic_vector(Nbit-1 downto 0);
  DOUT_1    : out std_logic_vector(Nbit-1 downto 0);
  DOUT_2    : out std_logic_vector(Nbit-1 downto 0);
    H0      : out signed(Nbit-1 downto 0);
    H1      : out signed(Nbit-1 downto 0);
    H2      : out signed(Nbit-1 downto 0);
    H3      : out signed(Nbit-1 downto 0);
	H4      : out signed(Nbit-1 downto 0);
	H5      : out signed(Nbit-1 downto 0);
	H6      : out signed(Nbit-1 downto 0);
	H7		: out signed(Nbit-1 downto 0);
	H8      : out signed(Nbit-1 downto 0);
	H9      : out signed(Nbit-1 downto 0);
	H10     : out signed(Nbit-1 downto 0);
	
    END_SIM : out std_logic);
end data_maker;

architecture beh of data_maker is

  constant tco : time := 1 ns;

  signal sEndSim : std_logic;
  signal END_SIM_i : std_logic_vector(0 to 10);  

begin  -- beh

	H0 	<= conv_std_logic_vector(-1,Nbit);
	H1	<= conv_std_logic_vector(-2,Nbit);
	H2 	<= conv_std_logic_vector(-4,Nbit);
	H3 	<= conv_std_logic_vector(8,Nbit);  
	H4 	<= conv_std_logic_vector(35,Nbit); 
	H5 	<= conv_std_logic_vector(50,Nbit); 
	H6 	<= conv_std_logic_vector(35,Nbit); 
	H7 	<= conv_std_logic_vector(8,Nbit); 
	H8 	<= conv_std_logic_vector(-4,Nbit); 
	H9 	<= conv_std_logic_vector(-2,Nbit); 
	H10	<= conv_std_logic_vector(-1,Nbit); 
	
	
  process (CLK, RST_n)
    file fp_in : text open READ_MODE is "./samples.txt";
    variable line_in : line;
    variable x0,x1,x2 : integer;
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      DOUT_0 <= (others => '0') after tco; 
      DOUT_1 <= (others => '0') after tco;
	  DOUT_2 <= (others => '0') after tco;
      VOUT <= '0' after tco;
      sEndSim <= '0' after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if not endfile(fp_in) then
        readline(fp_in, line_in);
        read(line_in, x0);
		readline(fp_in, line_in);
        read(line_in, x1);
		readline(fp_in, line_in);
        read(line_in, x2);
        DOUT_0 <= conv_std_logic_vector(x0, Nbit) after tco;
		DOUT_1 <= conv_std_logic_vector(x1, Nbit) after tco;
		DOUT_2 <= conv_std_logic_vector(x2, Nbit) after tco;
        VOUT <= '1' after tco;
        sEndSim <= '0' after tco;
      else
        VOUT <= '0' after tco;        
        sEndSim <= '1' after tco;
      end if;
    end if;
  end process;

  process (CLK, RST_n)
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      END_SIM_i <= (others => '0') after tco;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      END_SIM_i(0) <= sEndSim after tco;
      END_SIM_i(1 to 10) <= END_SIM_i(0 to 9) after tco;
    end if;
  end process;

  END_SIM <= END_SIM_i(10);  

end beh;
