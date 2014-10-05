#include "script_component.hpp"

disableSerialization;

private ["_pos", "_x", "_y", "_xgrid", "_ygrid", "_lastY", "_lastX", "_xcoord", "_ycoord", "_sec", "_min", "_hour", "_time", "_display", "_speed", "_vic", "_dagrHeading", "_WPHeading", "_dagrGrid", "_bearing"];

if (local player) then {
	
	cutRsc ["DAGR_DISPLAY", "plain down"];
	_display = (uiNameSpace getVariable "DAGR_DISPLAY");

	_gridControl = _display displayCtrl 266851;
	_speedControl = _display displayCtrl 266858;
	_elevationControl = _display displayCtrl 266857;
	_headingControl = _display displayCtrl 266854;
	_timeControl = _display displayCtrl 266859;
	_background = _display displayCtrl 266856;
	
	_background ctrlSetText QUOTE(PATHTOF(data\dagr_wp.paa));

	while {DAGR_RUN} do {
		if (Dagr_Map_Info == "default") exitwith {_gridControl ctrlSetText "ERROR"};
		//GRID
		_pos = getPos player;
		_x = _pos select 0;
		_y = _pos select 1;

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

		//WP Grid
		_xgrid2 = floor (DAGR_WP_INFO / 10000);
		_ygrid2 = DAGR_WP_INFO - _xgrid2 * 10000;

		_xcoord2 =
			if (_xgrid2 >= 1000) then {
				str _xgrid2;
			} else {
				if (_xgrid2 >= 100) then {
					"0" + str _xgrid2;
				} else {
					if (_xgrid2 >= 10) then {
						"00" + str _xgrid2;
					}else{
						"000" + str _xgrid2;
					};
				};
			};

		_ycoord2 =
			if (_ygrid2 >= 1000) then {
				str _ygrid2;
			} else {
				if (_ygrid2 >= 100) then {
					"0" + str _ygrid2;
				} else {
					if (_ygrid2 >= 10) then {
						"00" + str _ygrid2;
					}else{
						"000" + str _ygrid2;
					};
				};
			};	
	
		_dagrGrid2 = _xcoord2 + " " + _ycoord2;

		//Distance

		_WPpos = [[_xcoord2, _ycoord2], true] call CBA_fnc_mapGridToPos;
		_MYpos = [[_xcoord, _ycoord], true] call CBA_fnc_mapGridToPos;
		_distance = _MYpos distance _WPpos;
		_distance = floor (_distance * 10);
		_distance = _distance / 10;
		_dagrDistance = str _distance + "m";
		

		//Player Heading
		if (vehicle player != player) then {
			_vic = vehicle player;
			_dagrHeading = floor (direction _vic);
		}else{
			_dagrHeading = floor (direction player);
		};

		//WP Heading		
		_x = ((_WPpos select 0) - (_MYpos select 0));
		_y = ((_WPpos select 1) - (_MYpos select 1));

		if (_distance == 0) then {
			_bearing = 0;
		} else {
			_bearing = _x / _distance;
			if (_bearing >= 1) then {_bearing = 1;};
			if (_bearing <= -1) then {_bearing = -1;};
			_bearing = acos _bearing;
			_bearing = floor (_bearing);
			if (_x >= 0 && _y >= 0) then {_bearing = 0 - _bearing + 90;};
			if (_x < 0 && _y >= 0) then {_bearing = 0 - _bearing + 450;};
			if (_x < 0 && _y < 0) then {_bearing = _bearing + 90;};
			if (_x >= 0 && _y < 0) then {_bearing = _bearing +90;};
		};

		//output
		_gridControl ctrlSetText format ["%1", _dagrGrid];
		_speedControl ctrlSetText format ["%1", _bearing];
		_elevationControl ctrlSetText format ["%1", _dagrGrid2];
		_headingControl ctrlSetText format ["%1", _dagrHeading];
		_timeControl ctrlSetText format ["%1", _dagrDistance];

		sleep DAGRSLEEP;
	};
};