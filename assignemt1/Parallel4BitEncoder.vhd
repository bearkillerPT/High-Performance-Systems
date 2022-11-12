LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Parallel4BitEncoder IS
  PORT (m: IN STD_LOGIC_VECTOR(3 downto 0);
        x:   OUT STD_LOGIC_VECTOR(7 downto 0));
END Parallel4BitEncoder;

ARCHITECTURE structure OF Parallel4BitEncoder IS
SIGNAL s0, s1, s2, s3, s4, s5, s6, s7: STD_LOGIC;
BEGIN
	s7 <= m(0);
	s6 <= m(0) xor m(3);
	s5 <= m(0) xor m(2);
	s4 <= s5 xor m(3);
	s3 <= m(0) xor m(1);
	s2 <= s3 xor m(3);
	s1 <= s3 xor m(2);
	s0 <= s1 xor m(3);
	x <= s7 & s6 & s5 & s4 & s3 & s2 & s1 & s0;
END structure;