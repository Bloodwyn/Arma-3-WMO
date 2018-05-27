/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	Description:
	Fly, when you jump off
*/
systemChat "leave called";
_oldAnker = param [0, objNull, [objNull]];

if (isNull _oldAnker)exitWith{};

if (isMultiplayer && !(local _oldAnker))then{
	    [player,_oldAnker]remoteExecCall ["enableCollisionWith",_oldAnker];
};

_leaveOffset = _oldAnker worldToModel (getposatl player);
_vel = (velocity player vectoradd velocity _oldAnker);
_vel set [2,0];
player setVelocity _vel;

_collOn = true;
waitUntil {
	if((_oldAnker modelToWorld _leaveOffset)vectorDistance getPosATL player > 3)exitWith{true;};
	if(_oldAnker isEqualTo BW_anker or (isNull _oldAnker))exitWith{_collOn = false;true;};
	false;
};
if (_collOn)then{
	waitUntil {vectorMagnitude velocity player isEqualTo 0};
	systemChat "collon called";
	[_oldAnker,true] call BW_WMO_fnc_collision;
}