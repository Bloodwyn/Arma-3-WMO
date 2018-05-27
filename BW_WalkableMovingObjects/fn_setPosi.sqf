/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Main handler for WMO
*/
if !(vehicle player isEqualTo player)exitWith{if !(isNull BW_anker)then{[BW_anker,true] call BW_WMO_fnc_collision;BW_anker = objNull;}};

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
        _posWorld = getPosWorld player;
        //_temp = (_new_pos_anker vectorAdd (_new_pos_anker vectordiff prev_pos_anker) vectorAdd ([visiblePositionASL player vectordiff _new_pos_anker,_dirDiff]call BIS_fnc_rotateVector2D));
        _temp = (_posWorld vectoradd (((BW_anker modelToWorldVisualWORLD prevOffset) vectordiff  prevPlayerPos)));
       // if({_x>0.001}count((_temp vectordiff _posWorld)select [0,2])<1)then{//avoid dead slow sliding
        //    _temp = _posWorld;
        //};

         _pos = getPosWorld player vectoradd [0,0,geoH];
        _vel = velocity player;
        _vel set [2,0];

        _pos2 = eyepos player;
        //sorry for that check. Its the collsion stuff
        if(
           ({!isNull (_x select 2) && (_x select 0)distance _pos < geoD} count (
                (lineIntersectsSurfaces [_pos,_pos vectoradd _vel,player,objNull,true,1,"GEOM"])+
                (lineIntersectsSurfaces [_pos,_pos vectoradd ([_vel,30]call BIS_fnc_rotateVector2D),player,objNull,true,1,"GEOM"])+
                (lineIntersectsSurfaces [_pos,_pos vectoradd ([_vel,-30]call BIS_fnc_rotateVector2D),player,objNull,true,1,"GEOM"])+

                (lineIntersectsSurfaces [_pos2,_pos2 vectoradd _vel,player,objNull,true,1,"GEOM"])+
                (lineIntersectsSurfaces [_pos2,_pos2 vectoradd ([_vel,-30]call BIS_fnc_rotateVector2D),player,objNull,true,1,"GEOM"])+
                (lineIntersectsSurfaces [_pos2,_pos2 vectoradd ([_vel,-30]call BIS_fnc_rotateVector2D),player,objNull,true,1,"GEOM"])
            )>0)
           )then{
            _temp = _temp vectoradd (_vel vectorMultiply -geoB);
        };

       _h = (getposasl BW_WMO_help select 2);
        if((_temp select 2) - _h < fall)then{
            _temp set [2,_h-h];
        }else{
            _temp set [2,(_temp select 2)-2.8/diag_FPS];
        };
        _dirDiff = prevDirAnker - getDir BW_anker;
        _dir = direction player - _dirDiff;
        if (vectorMagnitude(velocity BW_anker) < 9)then{
            player setVelocityTransformation [_temp,_temp,[0,0,0],[0,0,-downvel],vectordir player,[sin _dir,cos _dir,0],[0,0,1],[0,0,1],1];
        }else{
            player setPosWorld _temp;
            player setDir _dir;
            player setVelocity [0,0,-downvel];
        };
        prevOffset = BW_anker worldToModelVisual (if(getTerrainHeightASL position player>0)then{(getposAtl player)}else{(getposAslw player)});//I never got how this shit works
        prevPlayerPos = _temp;
        prevDirAnker = getDir BW_anker;
    };
    if ([_obj] call BW_WMO_fnc_isWmoObject)exitWith{
        _exit = false;
        BW_anker = _obj;
        if (isMultiplayer && !(local _obj) && _obj isEqualTo BW_anker)then{
            [player,_obj]remoteExecCall ["disableCollisionWith",_obj];
        };
        [BW_anker,false] call BW_WMO_fnc_collision;

        prevOffset = BW_anker worldToModelVisual (if(getTerrainHeightASL position player>0)then{(getposAtl player)}else{(getposAslw player)});//I never got how this shit works
        prevPlayerPos = getPosWorld player;
        prevDirAnker = getDir BW_anker;
    };
}forEach _line;

if (_exit)then{
    if !(isNull BW_anker)then{
        [BW_anker] spawn BW_WMO_fnc_leave;
        BW_anker = objNull;
    };
};