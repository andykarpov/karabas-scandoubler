library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity karabas_scandoubler is
port
(
	R_IN        : in std_logic := '1'; -- цифровой RED
	G_IN        : in std_logic := '1'; -- цифровой GREEN
	B_IN        : in std_logic := '1'; -- цифровой BLUE
	I_IN        : in std_logic := '1'; -- цифровой BRIGHT

	KSI_IN      : in std_logic := '1'; -- кадровые синхроимпульсы
	SSI_IN      : in std_logic := '1'; -- строчные синхроимпульсы
	
	F14         : in std_logic := '1'; -- тактовые импульсы частотой 14 МГц
	F14_2       : in std_logic := '1'; -- F14, задержанный с помощью двух инверторов

	R_VGA      : out std_logic := '0'; -- цифровой RED
	G_VGA      : out std_logic := '0'; -- цифровой GREEN
	B_VGA      : out std_logic := '0'; -- цифровой BLUE
	I_VGA      : out std_logic_vector (2 downto 0) := "000"; -- выходы яркости VGA

	VSYNC_VGA  : out std_logic := '1'; -- кадровые синхроимпульсы/синхроимп. SCART
	HSYNC_VGA  : out std_logic := '1'; -- строчные синхроимпульсы/enable RGB SCART

	A          : out std_logic_vector(16 downto 0); -- ША
	WE         : out std_logic := '1'; -- сигнал записи в  ОЗУ  
	OE         : buffer std_logic := '1'; -- сигнал чтения из ОЗУ	
	D          : inout std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ" -- ШД

);
end karabas_scandoubler;

architecture RTL of karabas_scandoubler is

signal SYNC_IN : std_logic := '1';

begin

SYNC_IN <= SSI_IN;

U1: entity work.VGA_PAL
port map(
	R_IN => R_IN,
	G_IN => G_IN,
	B_IN => B_IN,
	I_IN => I_IN,
	
	KSI_IN => SYNC_IN,
	SSI_IN => SYNC_IN,
	F14 => F14,
	F14_2 => F14_2,
	
	-- программные перемычки :)
	INVERSE_RGBI => '1',
	INVERSE_KSI => '1',
	INVERSE_SSI => '1',
	INVERSE_F14MHZ => '0',
	VGA_SCART => '1',
	SET_FK_IN => '0',
	SET_FK_OUT => '1',
	
	R_VGA => R_VGA,
	G_VGA => G_VGA,
	B_VGA => B_VGA,
	I_VGA => I_VGA,
	VSYNC_VGA => VSYNC_VGA,
	HSYNC_VGA => HSYNC_VGA,
	A => A,
	D => D,
	WE => WE,
	OE => OE,
	
	R_VIDEO => open,
	G_VIDEO => open,
	B_VIDEO => open,
	I_VIDEO => open,
	SYNC_VIDEO => open
	
);

end RTL;

