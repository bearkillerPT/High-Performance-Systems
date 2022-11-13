
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

-- decoder of one bit
ENTITY bit_decoder IS
  PORT (i_x0, i_x1, i_x2, i_x3, i_x4, i_x5, i_x6, i_x7: IN  STD_LOGIC;
        o_m: OUT STD_LOGIC;
		  o_v: OUT STD_LOGIC);
END bit_decoder;

ARCHITECTURE structure OF bit_decoder IS

	-- signals
	SIGNAL mc: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL mAnd01, mAnd23, mOr01, mOr23: STD_LOGIC;
	SIGNAL mNAnd01, mNAnd23, mNOr01, mNOr23: STD_LOGIC;
	SIGNAL mOneC1, mOneC2, mZeroC1, mZeroC2 : STD_LOGIC;
	SIGNAL mZero, mOne : STD_LOGIC;
	
	-- gates
	COMPONENT gateXor2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT gateNor2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;	
	COMPONENT gateNand2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT gateAnd2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT gateOr2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT gateNot
		PORT (x: IN  STD_LOGIC;
				y:	OUT STD_LOGIC);
	END COMPONENT;
	
BEGIN

	-- beginning xor operations
	mc0    : gateXor2  PORT MAP (i_x0, i_x1, mc(0));
	mc1    : gateXor2  PORT MAP (i_x2, i_x3, mc(1));
	mc2    : gateXor2  PORT MAP (i_x4, i_x5, mc(2));
	mc3    : gateXor2  PORT MAP (i_x6, i_x7, mc(3));

	-- C3-0 equations calculations for one
	m_And01 : gateAnd2  PORT MAP (mc(1), mc(0), mAnd01);
	m_And23 : gateAnd2  PORT MAP (mc(2), mc(3), mAnd23);
	m_Or01  : gateOr2	  PORT MAP (mc(1), mc(0), mOr01);
	m_Or23  : gateOr2	  PORT MAP (mc(2), mc(3), mOr23);
	
	-- C3-0 equations calculations for zero
	m_NAnd01 : gateNot PORT MAP (mAnd01, mNAnd01);
	m_NAnd23 : gateNot PORT MAP (mAnd23, mNAnd23);
	m_NOr01  : gateNot PORT MAP (mOr01,  mNOr01);
	m_NOr23  : gateNot PORT MAP (mOr23,  mNOr23);
	
	-- One calculations
	m1C1 	 : gateAnd2  PORT MAP (mAnd01, mOr23,  mOneC1);
	m1C2 	 : gateAnd2  PORT MAP (mAnd23, mOr01,  mOneC2);
	m1		 : gateOr2	 PORT MAP (mOneC1, mOneC2, mOne);
		
	-- Zero calculations
	m0C1 	 : gateAnd2  PORT MAP (mNAnd01, mNOr23,  mZeroC1);
	m0C2 	 : gateAnd2  PORT MAP (mNAnd23, mNOr01,  mZeroC2);
	m0		 : gateOr2	 PORT MAP (mZeroC1, mZeroC2, mZero);
	
	-- check validity
	mvalid : gateXor2	 PORT MAP (mZero, mOne, o_v);
	
	-- forward one signal
	o_m <= mOne;
	
END structure;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

LIBRARY Parallel4BitEncoder;
USE Parallel4BitEncoder.all;

LIBRARY PopCounter8bit;
USE PopCounter8bit.all;


ENTITY m3_bit_decoder IS
	PORT (m     : IN STD_LOGIC_VECTOR(3 downto 0);
			y     : IN STD_LOGIC_VECTOR(7 downto 0);
			m3    : OUT STD_LOGIC;
			valid : IN STD_LOGIC);
END m3_bit_decoder;

ARCHITECTURE structure OF m3_bit_decoder IS

	SIGNAL c: STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL Z: STD_LOGIC_VECTOR (7 downto 0);
	SIGNAL PopCounter: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL XorC2C3: STD_LOGIC;
	SIGNAL XorValidC2C3: STD_LOGIC;
	SIGNAL XorZ0Y0, XorZ1Y1, XorZ2Y2, XorZ3Y3, XorZ4Y4, XorZ5Y5, XorZ6Y6, XorZ7Y7: STD_LOGIC;
	
	
	COMPONENT gateAnd2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT gateXor2
		PORT (x1, x2 : IN  STD_LOGIC;
				y:			OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT Parallel4BitEncoder
		PORT (m: IN  STD_LOGIC_VECTOR(3 downto 0);
				x:	OUT STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;
	
	COMPONENT PopCounter8bit
		PORT (d : IN  STD_LOGIC_VECTOR(7 downto 0);
				c : OUT STD_LOGIC_VECTOR(3 downto 0));
	END COMPONENT;

BEGIN
	
	
	z_e : Parallel4BitEncoder PORT MAP (m,z);
	
	m_XorZ0Y0 : gateXor2 PORT MAP(z(7),y(7),XorZ7Y7);
	m_XorZ1Y1 : gateXor2 PORT MAP(z(6),y(6),XorZ6Y6);
	m_XorZ2Y2 : gateXor2 PORT MAP(z(5),y(5),XorZ5Y5);
	m_XorZ3Y3 : gateXor2 PORT MAP(z(4),y(4),XorZ4Y4);
	m_XorZ4Y4 : gateXor2 PORT MAP(z(3),y(3),XorZ3Y3);
	m_XorZ5Y5 : gateXor2 PORT MAP(z(2),y(2),XorZ2Y2);
	m_XorZ6Y6 : gateXor2 PORT MAP(z(1),y(1),XorZ1Y1);
	m_XorZ7Y7 : gateXor2 PORT MAP(z(0),y(0),XorZ0Y0);
	
	 
	PopCounter <= XorZ7Y7 & XorZ6Y6 & XorZ5Y5 & XorZ4Y4 & XorZ3Y3 & XorZ2Y2 & XorZ1Y1 & XorZ0Y0;
	
	m_c : PopCounter8bit PORT MAP(PopCounter,c);
	
	m_XorC2C3 : gateXor2 PORT MAP(c(3),c(2),XorC2C3);
	
	m_XorValidC2C3 :  gateXor2 PORT MAP(valid,XorC2C3,m3);
	
END structure;


-- complete decoder
LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY simpleLogic;
USE simpleLogic.all;

ENTITY Parallel4BitDecoder IS
  PORT (x: IN STD_LOGIC_VECTOR(7 downto 0);
        m: OUT STD_LOGIC_VECTOR(3 downto 0);
		  v: OUT STD_LOGIC);
END Parallel4BitDecoder;

-- m3 bit

ARCHITECTURE structure OF Parallel4BitDecoder IS
	
	-- decoding computation bits for m3
	SIGNAL m3_o: STD_LOGIC;
	SIGNAL m3_V: STD_LOGIC;
	
	-- decoding computation bits for m2
	SIGNAL m2_o: STD_LOGIC;
	SIGNAL m2_V: STD_LOGIC;
	
	-- decoding computation bits for m1
	SIGNAL m1_o: STD_LOGIC;
	SIGNAL m1_V: STD_LOGIC;
	
	-- decoding computation bits for m0
	SIGNAL m0_o: STD_LOGIC;
	SIGNAL m0_V: STD_LOGIC;
	
	-- gate component
	COMPONENT gateAnd4
		PORT (x1, x2, x3, x4: IN  STD_LOGIC;
				y				  : OUT STD_LOGIC);
	END COMPONENT;
	
	-- concat components
	COMPONENT concatenator4to1
		PORT(x1, x2, x3, x4 : IN  STD_LOGIC;
			  y				  : OUT STD_LOGIC_VECTOR(3 downto 0));
	END COMPONENT;
	
	-- mbit decoder component
	COMPONENT bit_decoder
		PORT (i_x0, i_x1, i_x2, i_x3, i_x4, i_x5, i_x6, i_x7: IN  STD_LOGIC;
				o_m: OUT STD_LOGIC;
				o_v: OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT m3_bit_decoder
	PORT (m     : IN STD_LOGIC_VECTOR(3 downto 0);
			y     : IN STD_LOGIC_VECTOR(7 downto 0);
			m3    : OUT STD_LOGIC;
			valid : IN STD_LOGIC);
	END COMPONENT;
BEGIN

	-- m3 computations
	m3 : bit_decoder PORT MAP (x(0), x(1), x(2), x(3), x(4), x(5), X(6), x(7), m3_o, m3_v);

	-- m2 computations
	m2	: bit_decoder PORT MAP (x(0), x(2), x(1), x(3), x(4), x(6), x(5), x(7), m2_o, m2_v);

	-- m1 computations
	m1	: bit_decoder PORT MAP (x(0), x(4), x(1), x(5), x(2), x(6), x(3), x(7), m1_o, m1_v);

	-- m0 computations
	m0 : m3_bit_decoder PORT MAP (m3_o & m2_o & m1_o & '0', x, m0_o, m0_v);
	-- final results
	m <= m3_o & m2_o & m1_o & m0_o;
	valid		: gateAnd4 PORT MAP(m3_v, m2_v, m1_v, m0_v, v);
	
END structure;
