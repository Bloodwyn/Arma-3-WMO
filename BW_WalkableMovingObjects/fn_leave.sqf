/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	Description:
	Fly, when you jump off
*/

_oldAnker = param [0, BW_anker, [objNull]];
if (isNull _oldAnker)exitWith{};

//systemChat "leave called";

BW_anker = objNull;
BW_WMO_exit apply {_oldAnker call _x;};


_leaveOffset = _oldAnker worldToModel (getposatl player);
_vel = (velocity player vectoradd velocity _oldAnker);
_vel set [2,0];
player setVelocity _vel;


waitUntil {
	if((_oldAnker modelToWorld _leaveOffset)distance(getPosATL player) > 10 )exitWith{	// && (vectorMagnitude velocity player) isEqualTo 0
		BW_WMO_collision = true;
		[_oldAnker,true] call BW_WMO_fnc_collision;
		if (isMultiplayer && !(local _oldAnker))then{
        	[player,_oldAnker]remoteExecCall ["enableCollisionWith",_oldAnker];
    	};
	};
	if(_oldAnker isEqualTo BW_anker or (isNull _oldAnker))exitWith{true;};
	false;
};
