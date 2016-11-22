library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.globals.all;

entity Unfolded_FIR_pipe is
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
end Unfolded_FIR_pipe;

architecture BEHAVIOR of Unfolded_FIR_pipe is

	signal    X_3k_0: reg_link_type_0; -- signal from the  first input x[3k]     (first branch)
	signal    X_3k_1: reg_link_type_0; -- signal from the second input x[3k+1]   (second branch)
	signal    X_3k_2: reg_link_type_1; -- signal from the  third input x[3k+2]   (third branch)
	signal   out_add: add_type;--:=(others=>(others=>'0'));			--from 0 to 9 is the first brench, from 10 to 19 is the second one and from 20 to 29 is the third one
	signal  out_mult: mult_type;		--from 0 to 10 is the first brench, from 11 to 21 is the second one and from 22 to 32 is the third one
	signal vin_delay: std_logic_vector(14 downto 0);
	--pipelining
	signal pipe_mult: mult_type; -- delay reg after multiplicators
	signal  pipe_add: add_type;--:=(others=>(others=>'0'));	 --delay reg after adders, the inputs of the adders
begin
		    	    
		  
	--first branch
	
		--multiplications
		out_mult(0)  <= X_3k_0(0) * B0;
		out_mult(1)  <= X_3k_2(1) * B1;	
		out_mult(2)  <= X_3k_1(2) * B2;	
		out_mult(3)  <= X_3k_0(3) * B3;	
		out_mult(4)  <= X_3k_2(5) * B4;	
		out_mult(5)  <= X_3k_1(6) * B5;	
		out_mult(6)  <= X_3k_0(7) * B6;	
		out_mult(7)  <= X_3k_2(9) * B7;	
		out_mult(8)  <= X_3k_1(10) * B8;	
		out_mult(9)  <= X_3k_0(11) * B9;	
		out_mult(10) <= X_3k_2(13) * B10;	
		
		--adders  
		 out_add(0)  <= (resize(pipe_mult(0),out_add(0)'length)  + (resize(pipe_mult(1),out_add(0)'length)));
		 out_add(1)  <= (resize(pipe_mult(2),out_add(1)'length)  + pipe_add(1));
		 out_add(2)  <= (resize(pipe_mult(3),out_add(2)'length)  + pipe_add(2));
		 out_add(3)  <= (resize(pipe_mult(4),out_add(3)'length)  + pipe_add(3));
		 out_add(4)  <= (resize(pipe_mult(5),out_add(4)'length)  + pipe_add(4));
		 out_add(5)  <= (resize(pipe_mult(6),out_add(5)'length)  + pipe_add(5));
		 out_add(6)  <= (resize(pipe_mult(7),out_add(6)'length)  + pipe_add(6));
		 out_add(7)  <= (resize(pipe_mult(8),out_add(7)'length)  + pipe_add(7));
		 out_add(8)  <= (resize(pipe_mult(9),out_add(8)'length)  + pipe_add(8));
		 out_add(9)  <= (resize(pipe_mult(10),out_add(9)'length) + pipe_add(9));
		 
	--second branch
		--multiplications
		out_mult(11)  <= X_3k_1(0) * B0;
		out_mult(12)  <= X_3k_0(0) * B1;
		out_mult(13)  <= X_3k_2(2) * B2;
		out_mult(14)  <= X_3k_1(3) * B3;
		out_mult(15)  <= X_3k_0(4) * B4;
		out_mult(16)  <= X_3k_2(6) * B5;
		out_mult(17)  <= X_3k_1(7) * B6;
		out_mult(18)  <= X_3k_0(8) * B7;
		out_mult(19)  <= X_3k_2(10) * B8;
		out_mult(20)  <= X_3k_1(11) * B9;
		out_mult(21)  <= X_3k_0(12) * B10;		
		
		--adders
		out_add(10)  <= (resize(pipe_mult(11),out_add(10)'length) + (resize(pipe_mult(12),out_add(10)'length)));
		out_add(11)  <= (resize(pipe_mult(13),out_add(11)'length) + pipe_add(11));
		out_add(12)  <= (resize(pipe_mult(14),out_add(12)'length) + pipe_add(12));
		out_add(13)  <= (resize(pipe_mult(15),out_add(13)'length) + pipe_add(13));
		out_add(14)  <= (resize(pipe_mult(16),out_add(14)'length) + pipe_add(14));
		out_add(15)  <= (resize(pipe_mult(17),out_add(15)'length) + pipe_add(15));
		out_add(16)  <= (resize(pipe_mult(18),out_add(16)'length) + pipe_add(16));
		out_add(17)  <= (resize(pipe_mult(19),out_add(17)'length) + pipe_add(17));
		out_add(18)  <= (resize(pipe_mult(20),out_add(18)'length) + pipe_add(18));
		out_add(19)  <= (resize(pipe_mult(21),out_add(19)'length) + pipe_add(19));
		
	--third branch
		--multiplications
		out_mult(22)  <= X_3k_2(0) * B0;	
		out_mult(23)  <= X_3k_1(0) * B1;
		out_mult(24)  <= X_3k_0(1) * B2;
		out_mult(25)  <= X_3k_2(3) * B3;
		out_mult(26)  <= X_3k_1(4) * B4;
		out_mult(27)  <= X_3k_0(5) * B5;
		out_mult(28)  <= X_3k_2(7) * B6;
		out_mult(29)  <= X_3k_1(8) * B7;
		out_mult(30)  <= X_3k_0(9) * B8;
		out_mult(31)  <= X_3k_2(11) * B9;
		out_mult(32)  <= X_3k_1(12) * B10;
		
		--adders		
		out_add(20)  <= (resize(pipe_mult(22),out_add(20)'length) + (resize(pipe_mult(23),out_add(20)'length)));
		out_add(21)  <= (resize(pipe_mult(24),out_add(21)'length) + pipe_add(21));
		out_add(22)  <= (resize(pipe_mult(25),out_add(22)'length) + pipe_add(22));
		out_add(23)  <= (resize(pipe_mult(26),out_add(23)'length) + pipe_add(23));
		out_add(24)  <= (resize(pipe_mult(27),out_add(24)'length) + pipe_add(24));
		out_add(25)  <= (resize(pipe_mult(28),out_add(25)'length) + pipe_add(25));
		out_add(26)  <= (resize(pipe_mult(29),out_add(26)'length) + pipe_add(26));
		out_add(27)  <= (resize(pipe_mult(30),out_add(27)'length) + pipe_add(27));
		out_add(28)  <= (resize(pipe_mult(31),out_add(28)'length) + pipe_add(28));
		out_add(29)  <= (resize(pipe_mult(32),out_add(29)'length) + pipe_add(29));

	process(CLK)
	begin
		if (CLK'event and CLK='1') then
			if reset='0' then
				   X_3k_0 <= (others=>(others=>'0'));
				   X_3k_1 <= (others=>(others=>'0'));
				   X_3k_2 <= (others=>(others=>'0'));
				 pipe_add <= (others=>(others=>'0'));
				pipe_mult <= (others=>(others=>'0'));
				vin_delay <= (others=>'0');
			else
				--data valid
					vin_delay(0) <= VIN;
					for v_del in 1 to 14 loop		
						vin_delay(v_del) <= vin_delay(v_del-1);
					end loop;
					VOUT <= vin_delay(14);
				
				--pipelining
					X_3k_0(0) <= signed(DIN_0);
					X_3k_1(0) <= signed(DIN_1);
					X_3k_2(0) <= signed(DIN_2);
					--first branch
					for br1 in 0 to 11 loop		
						X_3k_0(br1+1)  <= X_3k_0(br1);
					end loop;
					
					--second branch
					for br2 in 0 to 11 loop		
						X_3k_1(br2+1)  <= X_3k_1(br2);
					end loop;		
					
					--third branch
					for br3 in 0 to 12 loop		
						X_3k_2(br3+1)  <= X_3k_2(br3);
					end loop;	
					
					--shift of the registers after the multipliers
					for mr in 0 to ((N+1)*J)-1 loop		
						pipe_mult(mr)  <= out_mult(mr);
					end loop;
					
					--shift of the registers after adders, the 0,10 and 20 index are skipped since those havent an adder before that compute their values and pipe_add coincide with pipe_mult
					for K in 0 to J-1 loop							-- K rapresent the branch take in consideration						 
						for i in (N*K)+1 to (N*(K+1))-1 loop	     --with J=3 (1 to 9 , 11 to 19, 21 to 29)	
							pipe_add(i)  <= out_add(i-1);
						end loop;
					end loop;
	
				--output
					DOUT_0 <= std_logic_vector(out_add(9)(13 downto 6));
					DOUT_1 <= std_logic_vector(out_add(19)(13 downto 6));
					DOUT_2 <= std_logic_vector(out_add(29)(13 downto 6));
			end if;		
		end if;
	end process;
end BEHAVIOR;
