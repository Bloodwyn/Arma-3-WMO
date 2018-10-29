/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	Description:
	if this returns true for the object you want to ride, you did it rigth :)
*/

_obj = param [0, objNull, [objNull]];

if (_obj isKindOf "landvehicle" || _obj isKindOf "air" || _obj isKindOf "ship")exitWith{true};

if (_obj in WMO_specialObjects)exitWith{true};

if ((typeof _obj) in WMO_specialObjects)exitWith{true};

if (((getModelInfo _obj) select 1) in WMO_specialObjects)exitWith{true};

false;