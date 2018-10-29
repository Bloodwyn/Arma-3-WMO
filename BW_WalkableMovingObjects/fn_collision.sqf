/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	Description:
	enables or disables collision with the anchor object

*/

_obj = param [0, BW_anker, [objNull]];
_enable = param [1,false,[true]];

if (isNull _obj)exitWith{};


if (_enable)then{
	player enableCollisionWith _obj;
	//systemChat ("ec "+str (getmodelinfo _obj select 0));
}else{
	player disableCollisionWith _obj;
	//systemChat ("dc "+str (getmodelinfo _obj select 0));
};

{[_x,_enable] call BW_WMO_fnc_collision;}foreach (attachedObjects _obj);