_obj = param [0, objNull, [objNull]];
if (isNull _obj)exitWith{_obj};
_parent = attachedTo _obj;
if (isNull _parent)exitWith{_obj};
[_parent] call BW_WMO_fnc_getParent;