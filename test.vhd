library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use numeric_std.all;

entity mul is
    port(a,b: in std_logic_vector(3 downto 0);
    clk,load:in std_logic;
    c:out std_logic_vector(7 downto 0);
    ready: out std_logic);
end entity mul;

architecture behav of mul is
begin
    process(clk)
        variable count: integer range 0 to 4;
        variable pa: unsigned(8 downto 0);
        alias p: unsigned(4 downto 0)is pa(8 downto 4);
    begin
        if clk'event and clk='1' then
            if load='1' then
                p:=(others=>0);
                pa(3 downto 0):=unsigned(a);
                count:=4;
                ready<=0;
            elsif count>0 then 
                case std_logic(pa(0)) is
                    when '1'=>
                        p:=p+unsigned(b);
                    when '0'=>
                        null;
                end case;
                pa:=shift_right(pa,1);
                count:=count-1;
            elsif count=0 then
                ready='1'
            end if;
            c<=std_logic_vector(pa(7 downto 0));
        end if;
    end process;
end behav;
