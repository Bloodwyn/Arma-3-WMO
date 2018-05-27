
if!(vehicle player isEqualTo player)exitWith{BW_WMO_help setpos [0,0,0];};

_line = lineIntersectsSurfaces [
	(getposasl player)vectoradd [0,0,upH],
	(getposasl player)vectoradd [0,0,downH],
	player,
	BW_WMO_help,
	true,
	-1,
	"GEOM",
	"NONE"
];

_best = [];
{
	if((_x select 1 select 2)> .45 )exitWith{_best = _x};
}foreach _line;

if (count _best isEqualTo 0)exitWith {BW_WMO_help setPosASL [0,0,0]};

_pos = _best select 0;
_no = _best select 1;
_obj = _best select 2;

if (isNull _obj) exitWith {BW_WMO_help setPosASL [0,0,0]};

BW_WMO_help setPosASL (_pos vectoradd [0,0,(_no select 2)*-1+1+upadd]);
if(withNo)then{BW_WMO_help setVectorUp _no};
_obj disableCollisionWith BW_WMO_help;