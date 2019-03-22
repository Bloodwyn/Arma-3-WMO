/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	Description:
	Roadway or not?
*/

_obj = param [0, objNull, [objNull]];

if(isNull _obj)exitWith{false};

if (_obj in WMO_noRoadway)exitWith{false};

if ((typeof _obj) in WMO_noRoadway)exitWith{false};

if (((getModelInfo _obj) select 1) in WMO_noRoadway)exitWith{false};

true;