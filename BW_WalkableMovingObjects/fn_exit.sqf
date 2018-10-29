if !(isNull BW_anker)then{
    BW_WMO_collision = true;
    BW_WMO_exit apply {BW_anker call _x;};
    [BW_anker,true] call BW_WMO_fnc_collision;
    if (isMultiplayer && !(local _oldAnker))then{
        [player,BW_anker]remoteExecCall ["enableCollisionWith",BW_anker];
    };
    BW_anker = objNull;
};