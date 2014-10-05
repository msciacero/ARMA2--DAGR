#include "script_component.hpp"

disableSerialization;

if !(player hasweapon "ACE_DAGR") exitWith {};

if (DAGR_MENU_FIRST) then {	//fsm fails to load properly on very first run
	cutRsc ["Default", "plain down"];

	//KILL DISPLAY FUNCTION
	terminate Dagr_output;
	DAGR_RUN = false;
	DAGR_STP = false;

	DAGR_MENU_RUN = true;
	DAGR_MENU_FIRST = false;
	DAGR_Menu_Handler = [] execFSM QUOTE(PATHTOF(DAGR_MENU.fsm));
	sleep 0.2;
};

if (DAGR_MENU_RUN) then {
	closeDialog 266860;
	DAGR_PWR = true;
	sleep 0.1;
};

cutRsc ["Default", "plain down"];

//KILL DISPLAY FUNCTION
terminate Dagr_output;
DAGR_RUN = false;
DAGR_STP = false;

DAGR_MENU_RUN = true;
DAGR_Menu_Handler = [] execFSM QUOTE(PATHTOF(DAGR_MENU.fsm));
