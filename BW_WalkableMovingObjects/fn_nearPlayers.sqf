/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	Description:
	searches for players within the given distance (for remoteexec)
*/

_obj = param [0, objNull, [ObjNull]];
_distance = param [1, 0];
_ret = [];
{if (_x distance _obj < _distance)then{_ret pushBack _x};}foreach allplayers;
_ret;