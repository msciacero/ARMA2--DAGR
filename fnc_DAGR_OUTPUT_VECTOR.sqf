#include "script_component.hpp"

disableSerialization;

private ["_x","_y","_xgrid","_ygrid","_dsp","_dagrGrid"];

if (local player) then {
	
	cutRsc ["DAGR_DISPLAY", "plain down"];
	_display = (uiNameSpace getVariable "DAGR_DISPLAY");

	_gridControl = _display displayCtrl 266851;
	_speedControl = _display displayCtrl 266858;
	_elevationControl = _display displayCtrl 266853;
	_headingControl = _display displayCtrl 266854;
	_timeControl = _display displayCtrl 266855;
	_background = _display displayCtrl 266856;
	
	_background ctrlSetText QUOTE(PATHTOF(data\dagr_vector.paa));

	if (NODAGRDISPLAY) exitwith {};

	if (Dagr_Map_Info == "default") then {
		_dagrGrid = mapGridPosition DAGRLAZPOS;
	} else {
		//find laser position
		_x = DAGRLAZPOS select 0;
		_y = DAGRLAZPOS select 1;

		switch (Dagr_Map_Info) do {
			case "chernarus": {
				_xgrid = floor (_x / 10);
				_ygrid = floor ((15360 - _y) / 10);
			};
			case "utes": {
				_xgrid = floor (_x / 10);
				_ygrid = floor ((5120 - _y) / 10);	
			};
			case "panthera2": {
				_xgrid = floor (_x / 10);
				_ygrid = floor ((10240 - _y) / 10);
			};
			case "namalsk": {
				_xgrid = floor (_x / 10);
				_ygrid = floor ((12800 - _y) / 10);	
			};
		};

		//Incase grids go neg due to 99-00 boundry
		if (_xgrid < 0) then {_xgrid = _xgrid + 9999;};
		if (_ygrid < 0) then {_ygrid = _ygrid + 9999;};

		_xcoord =
			if (_xgrid >= 1000) then {
				str _xgrid;
			} else {
				if (_xgrid >= 100) then {
					"0" + str _xgrid;
				} else {
					if (_xgrid >= 10) then {
						"00" + str _xgrid;
					}else{
						"000" + str _xgrid;
					};	
				};
			};	

		_ycoord =
			if (_ygrid >= 1000) then {
				str _ygrid;
			} else {	
				if (_ygrid >= 100) then {
					"0" + str _ygrid;
				} else {
					if (_ygrid >= 10) then {
						"00" + str _ygrid;
					}else{
						"000" + str _ygrid;
					};
				};
			};	

		_dagrGrid = _xcoord + " " + _ycoord;
	};

	//find target elevation
	_elevation = floor (DAGRLAZPOS select 2);
	_dagrElevation = str _elevation + "m";

	//Time
	_time = daytime;
	_hour = floor (_time);
	_min  = floor ((_time mod 1) * 60);
	

	_hr =
		if (_hour >= 10) then {
			str _hour;
		} else {
			if (_hour >= 1) then {
				"0" + str _hour;
			} else {
				"00" + str _hour;
			};
		};
	_mn =
		if (_min >= 10) then {
			str _min;
		} else {
			"0" + str _min;
		};		

	_dagrTime = _hr + ":" + _mn;

	//Bearing
	_bearing = ((DAGRLazHeading select 0) atan2 (DAGRLazHeading select 1)) + 360;
	if (_bearing >= 360) then {_bearing = _bearing - 360;};


	_bearing = floor (_bearing);

	//Distance
	_dagrDist = str DAGRLAZDIST + "m";


	//OUTPUT
	_gridControl ctrlSetText format ["%1", _dagrGrid];
	_speedControl ctrlSetText format ["%1", _dagrDist]; 
	_elevationControl ctrlSetText format ["%1", _dagrElevation];
	_headingControl ctrlSetText format ["%1", _bearing];
	_timeControl ctrlSetText format ["%1", _dagrTime];		
};