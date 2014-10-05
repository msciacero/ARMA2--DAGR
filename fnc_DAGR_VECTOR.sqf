#include "script_component.hpp"
private ["_rfweapon", "_check", "_myPos", "_lazInfo", "_myLaz"];
if !(local player) exitwith {};

_rfweapon = "ACE_Rangefinder_OD";
_check = EMP_RF_STA;
NODAGRDISPLAY = true;

while {true} do {
	if (!alive player) then {
		NODAGRDISPLAY = true;
		waitUntil {alive player};
	};
	waituntil {(currentWeapon player) == _rfweapon || !(alive player)};
	waituntil {!DAGR_EMPTYVECTOR || !(alive player)};
	while {((currentWeapon player == _rfweapon) && (alive player) && (cameraView == "GUNNER") && !(EMP_RF_BRK) && !(EMP_RF_STP)) || (EMP_RF_HLD)} do {
		_myPos = getPosASL player;
		_lazInfo = call ace_sys_rangefinder_fnc_findLT;
		_myLaz = _lazInfo select 0;
		if (!isNull _myLaz) then {
			DAGRLAZPOS = getPosASL _myLaz;
			DAGRLAZDIST = _myPos distance _myLaz;
			DAGRLAZDIST = floor (DAGRLAZDIST);
			DAGRLazHeading = player weaponDirection _rfweapon;
			NODAGRDISPLAY = false;
		};
		sleep 0.1;
	};
	sleep 1; // Loops without sleep are not recommended!
};
