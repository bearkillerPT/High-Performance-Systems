LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY PopCounter8bit;
USE PopCounter8bit.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

LIBRARY arithmetic;
USE arithmetic.all;

ENTITY PopCounter8bit IS
  PORT (d: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        c: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END PopCounter8bit;

ARCHITECTURE structure OF PopCounter8bit IS
  SIGNAL iSg0: STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL iSg1: STD_LOGIC_VECTOR (5 DOWNTO 0);
  COMPONENT halfAdder_1bit
  PORT (a, cI: IN STD_LOGIC;
        s, cO:   OUT STD_LOGIC);
END COMPONENT;
COMPONENT fullAdderWoCI_2bit
  PORT (a, b: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        s: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
        cO: OUT STD_LOGIC);
END COMPONENT;
COMPONENT fullAdderWoCI_3bit
  PORT (a, b: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        s: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        cO: OUT STD_LOGIC);
END COMPONENT;
BEGIN
-- stage 0
  hA00:  halfAdder_1bit PORT MAP (d(1),  d(0),  iSg0(0),  iSg0(1));
  hA01:  halfAdder_1bit PORT MAP (d(3),  d(2),  iSg0(2),  iSg0(3));
  hA02:  halfAdder_1bit PORT MAP (d(5),  d(4),  iSg0(4),  iSg0(5));
  hA03:  halfAdder_1bit PORT MAP (d(7),  d(6),  iSg0(6),  iSg0(7));
-- stage 1
  fA10: fullAdderWoCI_2bit PORT MAP (iSg0(1 DOWNTO 0),   iSg0(3 DOWNTO 2),   iSg1(1 DOWNTO 0),   iSg1(2));
  fA11: fullAdderWoCI_2bit PORT MAP (iSg0(5 DOWNTO 4),   iSg0(7 DOWNTO 6),   iSg1(4 DOWNTO 3),   iSg1(5));
-- stage 2
  fA20: fullAdderWoCI_3bit PORT MAP (iSg1(2 DOWNTO 0),   iSg1(5 DOWNTO 3),    c(2 DOWNTO 0), c(3));
END structure;