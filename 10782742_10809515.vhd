library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity project_reti_logiche is
	port(
		i_clk	: in std_logic;
		i_rst	: in std_logic;
		i_start	: in std_logic;
		i_add	: in std_logic_vector(15 downto 0);
		i_k	:in std_logic_vector(9 downto 0);
		
		o_done	: out std_logic;
		
		o_mem_addr	: out std_logic_vector(15 downto 0);
		i_mem_data	: in std_logic_vector(7 downto 0);
		o_mem_data	: out std_logic_vector(7 downto 0);
		o_mem_we	: out std_logic;
		o_mem_en	: out std_logic
	);
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

type state_type is (rst, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, final);
signal state: state_type;

signal mem_c: std_logic_vector(7 downto 0) := (others=>'0');
signal counter: std_logic_vector(9 downto 0):= (others=>'0');
signal address_curr: std_logic_vector(15 downto 0):= (others=>'0'); 
signal ultimo_valido: std_logic_vector (7 downto 0):= (others=>'0');

begin

process(i_clk, i_rst)	

begin

if i_rst = '1' then
	o_mem_en <= '0';
	o_mem_we <= '0';
	o_done <= '0';
	o_mem_addr <= (others=>'0');
	o_mem_data <= (others=>'0');
	
	mem_c <= (others=>'0');
	counter <= (others=>'0');
	address_curr <= (others=>'0');
	ultimo_valido <= (others=>'0');
	state <= rst;
	
elsif i_clk'event and i_clk = '1' then

	if state = rst then
		if i_start='1' then
		  o_mem_en <= '1';
		  address_curr <= i_add;
		  counter <= i_k;
		  state <= s0;
		else 
		  state <= rst;
	end if;
	
	elsif state = s0 then
	   if counter = "0000000000" then
	       state <= final;
	       o_mem_en <= '0';
	   else	       
	       o_mem_en <= '1';    
	       o_mem_addr <= address_curr;
	       state <= s1;
       end if;
       
	elsif state = s1 then	   
	   counter <= counter - "0000000001";
	   state<= s2;
	
	elsif state = s2 then
	   if i_mem_data = "00000000" then
	       address_curr <= address_curr + "0000000000000010";
	       state<= s0;
	   else 
	       address_curr<= address_curr + "0000000000000001";
	       mem_c <= "00011111";
	       ultimo_valido <= i_mem_data;
	       state<= s3;
	   end if;            
		  
	elsif state = s3 then	   
	   o_mem_we <='1';
	   o_mem_addr <= address_curr;
	   o_mem_data<= mem_c;
	   state<= s4;

	elsif state = s4 then	   
	   address_curr<= address_curr + "0000000000000001"; 
	   state<= s5;  
	   	
	elsif state = s5 then
	   if counter = "0000000000" then 
	       o_done<= '1';
	       state <= final;
	       o_mem_en <= '0';
	   else 
	       o_mem_we <='0';
	       o_mem_addr <= address_curr;
	       state<=s6;
	   end if;
	   	
	elsif state = s6 then	   
	   counter <= counter - "0000000001";
	   state<= s7; 
			  
	elsif state = s7 then	   
	   if i_mem_data = "00000000" then 
	       mem_c <= mem_c - "00000001";
	       state <= s8;
	   else 
	       address_curr<= address_curr + "0000000000000001";
	       ultimo_valido <= i_mem_data;
	       state<= s3;
	   end if;
		
	elsif state = s8 then	   
	   o_mem_we <= '1';
	   o_mem_data <= ultimo_valido;
	   state <= s9;
	
	elsif state = s9 then	   
	   address_curr <= address_curr + "0000000000000001";
	   state <= s10;
	
	elsif state = s10 then	   
	   o_mem_addr <= address_curr;
	   o_mem_data <= mem_c;
	   state <= s11;
	
	elsif state = s11 then
	   address_curr <= address_curr + "0000000000000001";
	   state <= s12;
	
	elsif state = s12 then	   
	   if counter = "0000000000" then 
	       o_done<= '1';
	       state <= final;
	       o_mem_en <= '0';
	   else 
	       o_mem_we <='0';
	       o_mem_addr <= address_curr;
	       state<=s13;
	   end if;
	
	elsif state = s13 then	   
	   counter <= counter - "0000000001";
	   state <= s14;
	
	elsif state = s14 then	   
	   if i_mem_data = "00000000" then 
	       mem_c <= mem_c - "00000001";
	       state <= s8;
	   else 
	       mem_c <="00011111";
	       address_curr <= address_curr + "0000000000000001";
	       ultimo_valido <= i_mem_data;
	       state <= s3;
	      end if;
	
	elsif state = final then	   
	   if i_start = '0' then
	       o_done <= '0';
	       state <= rst;
	   end if;
  end if; 
end if; 
end process;
end Behavioral; 