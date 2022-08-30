/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Main handler for WMO
*/

if !(WMO_Enabled) exitWith{if !(isNull BW_anker)then{[BW_anker,true] call BW_WMO_fnc_collision;BW_anker = objNull;}}; // I just want to end it here cause we are not enabled yet

if !(vehicle player isEqualTo player)exitWith{if !(isNull BW_anker)then{[BW_anker,true] call BW_WMO_fnc_collision;BW_anker = objNull;}};

// Ace Fatigue recovery aid
if(!(isNil "ace_advanced_fatigue_anReserve")) then {
    ace_advanced_fatigue_anReserve = ace_advanced_fatigue_anReserve + (ace_advanced_fatigue_recoveryFactor * 0.8);
    if(ace_advanced_fatigue_anReserve >= 2300) then {
        ace_advanced_fatigue_anReserve = 2300;
    };
};

_line=(lineIntersectsSurfaces [getposworld player vectoradd [0,0,0],getposasl player vectoradd [0,0,-1.5],player,objNull,true,-1,"GEOM"])select {!isNull (_x select 3)};

if (count _line isEqualTo 0)exitWith{
    if !(isNull BW_anker)then{
        [BW_anker] spawn BW_WMO_fnc_leave;
        BW_anker = objNull;
    };
};
_exit = true;//not pretty :(
{
    _obj = [_x select 3] call BW_WMO_fnc_getParent;
    if (_obj isEqualTo BW_anker)exitWith{
        _exit = false;
        _new_pos_anker = BW_anker modeltoWorldVisualWorld [0,0,0];
        _dirDiff = prev_dir_anker - getDir BW_anker;

        _temp = (_new_pos_anker vectorAdd (_new_pos_anker vectordiff prev_pos_anker) vectorAdd ([visiblePositionASL player vectordiff _new_pos_anker,_dirDiff]call BIS_fnc_rotateVector2D));
         _pos = getPosWorld player vectoradd [0,0,geoH];
        _vel = ((velocity player));
        _vel set [2,0];

        //sorry for that check. Its the collsion stuff
       if((count((lineIntersectsSurfaces [_pos,_pos vectoradd _vel,player,objNull,true,1,"GEOM"])select {!isNull (_x select 2) && (_x select 0)distance _pos < geoD})>0))then{
            _temp = _temp vectoradd (_vel vectorMultiply -geoB);
        };
        _h = (getposasl BW_WMO_help select 2);
        if((_temp select 2) - _h < fall)then{
            _temp set [2,_h-h];
        }else{
            _temp set [2,(_temp select 2)-2.8/diag_FPS];
        };
        _dir = direction player - _dirDiff;
        if ((abs speed BW_anker) < 35)then{
            if!(BW_anker getVariable ["WMO_coll",true])then{
                [BW_anker,true] call BW_WMO_fnc_collision;
                BW_anker setVariable ["WMO_coll",true];
            };
            player setPosASL _temp;
            player setVelocityTransformation [_temp,_temp,[0,0,0],[0,0,-downvel],vectordir player,[sin _dir,cos _dir,0],[0,0,1],[0,0,1],1];
        }else{
            if(BW_anker getVariable ["WMO_coll",true])then{
                [BW_anker,false] call BW_WMO_fnc_collision;
                BW_anker setVariable ["WMO_coll",false];
            };
            player setPosASL _temp;
            player setDir _dir;
            player setVelocity [0,0,-downvel];
        };

        prev_pos_anker = _new_pos_anker;
        prev_dir_anker = getDir BW_anker;
    };
    if ([_obj] call BW_WMO_fnc_isWmoObject)exitWith{
        _exit = false;
        BW_anker = _obj;
        if (isMultiplayer && !(local _obj) && _obj isEqualTo BW_anker)then{
            [player,_obj]remoteExecCall ["disableCollisionWith",_obj];
        };
        prev_pos_anker = BW_anker modeltoWorldVisualWorld [0,0,0];
        prev_dir_anker = getDir BW_anker;
    };
}forEach _line;

if (_exit)then{
    if !(isNull BW_anker)then{
        [BW_anker] spawn BW_WMO_fnc_leave;
        BW_anker = objNull;
    };
};