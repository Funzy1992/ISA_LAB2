library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned 
use ieee.std_logic_unsigned.all;
use work.globals.all;
entity TB_Unf_FIR_pipe is 
end TB_Unf_FIR_pipe; 

architecture TEST of TB_Unf_FIR_pipe is
-----component-------------------------
component Unfolded_FIR_pipe is
	generic(Nbit: 		integer :=8);
	port(	
			--input control signals
				CLK:		in 		std_logic;
				RESET:		in 		std_logic;
				VIN:		in 		std_logic;
			-- coefficients mult
				B0:			in 		signed(Nbit-1 downto 0);
				B1:			in 		signed(Nbit-1 downto 0);
				B2:			in 		signed(Nbit-1 downto 0);
				B3:			in 		signed(Nbit-1 downto 0);
				B4:			in 		signed(Nbit-1 downto 0);
				B5:			in 		signed(Nbit-1 downto 0);
				B6:			in 		signed(Nbit-1 downto 0);
				B7:			in 		signed(Nbit-1 downto 0);
				B8:			in 		signed(Nbit-1 downto 0);
				B9:			in 		signed(Nbit-1 downto 0);
				B10:		in 		signed(Nbit-1 downto 0);				
			--Data I/O
				DIN_0: 		in 		std_logic_vector(Nbit-1 downto 0);			--sample x[3k]
				DIN_1: 		in 		std_logic_vector(Nbit-1 downto 0);			--sample x[3k+1]
				DIN_2: 		in 		std_logic_vector(Nbit-1 downto 0);			--sample x[3k+2]
				DOUT_0: 		out 	std_logic_vector(Nbit-1 downto 0);		--sample y[3k]
				DOUT_1: 		out 	std_logic_vector(Nbit-1 downto 0);		--sample y[3k+1]
				DOUT_2: 		out 	std_logic_vector(Nbit-1 downto 0);		--sample y[3k+2]
			--output control signal	
				VOUT:		out 	std_logic
		);
end component;

-------signals---------------------------
signal	   CLK:  std_logic:= '0';
signal   RESET:  std_logic:='1';
signal     B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10:  signed(Nbit-1 downto 0);
signal  X0,X1,X2:  std_logic_vector(7 downto 0);
signal  Y0,Y1,Y2:  std_logic_vector(Nbit-1 downto 0);
signal   VIN:  std_logic:='0';
signal   VOUT:  std_logic;

---------start---------------------------
Begin

B0  <= to_signed(-1,Nbit);--std_logic_vector(to_signed(-1,Nbit));
B1  <= to_signed(-2,Nbit);--std_logic_vector(to_signed(-2,Nbit));
B2  <= to_signed(-4,Nbit);--std_logic_vector(to_signed(-4,Nbit));
B3  <= to_signed(8,Nbit);--std_logic_vector(to_signed(8,Nbit));
B4  <= to_signed(35,Nbit);--std_logic_vector(to_signed(35,Nbit));
B5  <= to_signed(50,Nbit);--std_logic_vector(to_signed(50,Nbit));
B6  <= to_signed(35,Nbit);--std_logic_vector(to_signed(35,Nbit));
B7  <= to_signed(8,Nbit);--std_logic_vector(to_signed(8,Nbit));
B8  <= to_signed(-4,Nbit);--std_logic_vector(to_signed(-4,Nbit));
B9  <= to_signed(-2,Nbit);--std_logic_vector(to_signed(-2,Nbit));
B10 <= to_signed(-1,Nbit);--std_logic_vector(to_signed(-1,Nbit));

-- Instanciate the ADDER version 1
  UADDER1: Unfolded_FIR_pipe 	   
	   port map (CLK, RESET,VIN,B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,X0,X1,X2,Y0,Y1,Y2,VOUT);
  
 VIN <='1' after 50 ns, '0' after 75 ns, '1' after 100 ns; 
  RESET<='0' after 3 ns, '1' after 5 ns; 
 STIMULUS1: process(CLK,RESET)
 variable cnt:integer:=0;
 begin
 CLK<=not(CLK) after 0.5 ns;
  if RESET'event and RESET='1' then
 cnt:=0;
      	X0<=std_logic_vector(to_signed (0,X0'length));
		X1<=std_logic_vector(to_signed (0,X1'length));
		X2<=std_logic_vector(to_signed (0,X2'length));
 end if;
 if CLK'event and CLK='1' then

 cnt:=cnt+1;
	case cnt is
   when 1 =>
     	X0<=std_logic_vector(to_signed (0,X0'length));
		X1<=std_logic_vector(to_signed (39,X1'length));
		X2<=std_logic_vector(to_signed (0,X2'length));
   when 2 =>
     	X0<=std_logic_vector(to_signed (103,X0'length));
		X1<=std_logic_vector(to_signed (0,X1'length));
		X2<=std_logic_vector(to_signed (127,X2'length));
   when 3 =>
     	X0<=std_logic_vector(to_signed (-1,X0'length));
		X1<=std_logic_vector(to_signed (103,X1'length));
		X2<=std_logic_vector(to_signed (-1,X2'length));
   when 4 =>
     	X0<=std_logic_vector(to_signed (39,X0'length));
		X1<=std_logic_vector(to_signed (-1,X1'length));
		X2<=std_logic_vector(to_signed (-40,X2'length));
   when 5 =>
     	X0<=std_logic_vector(to_signed (-1,X0'length));
		X1<=std_logic_vector(to_signed (-104,X1'length));
		X2<=std_logic_vector(to_signed (-1,X2'length));
   when 6 =>
     	X0<=std_logic_vector(to_signed (-128,X0'length));
		X1<=std_logic_vector(to_signed (0,X1'length));
		X2<=std_logic_vector(to_signed (-104,X2'length));
   when 7 =>
     	X0<=std_logic_vector(to_signed (0,X0'length));
		X1<=std_logic_vector(to_signed (-40,X1'length));
		X2<=std_logic_vector(to_signed (0,X2'length));
   when 8 =>
     	X0<=std_logic_vector(to_signed (39,X0'length));
		X1<=std_logic_vector(to_signed (0,X1'length));
		X2<=std_logic_vector(to_signed (103,X2'length));
   when others => 
		 X0<="00000000";
		 X1<="00000000";
		 X2<="00000000";
end case;
end if;


 end process;

end TEST;