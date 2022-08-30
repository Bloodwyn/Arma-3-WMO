/*
    Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

    Description:
    Main handler for WMO
*/

if !(WMO_Enabled) exitWith BW_WMO_fnc_exit;

if !(vehicle player isEqualTo player) exitWith BW_WMO_fnc_exit; //looks ugly but works. Even Poseidon thinks thats wrong

_posWorld = getPosWorld player;
_line = (lineIntersectsSurfaces [_posWorld vectoradd [0,0,.6],_posWorld vectoradd [0,0,-5],player,BW_WMO_help,true,-1,"GEOM","VIEW"])select {!isNull (_x select 3)};

if (_line isEqualTo []) exitWith {BW_anker spawn BW_WMO_fnc_leave; BW_WMO_help setpos [0,0,0];};


_upmost = _line#0;

_pos = _upmost select 0;
_no = _upmost select 1;
_obj = _upmost select 2;


if !([_obj]call BW_WMO_fnc_getsRoadway) exitWith {call BW_WMO_fnc_exit; BW_WMO_help setpos [0,0,0];};

// Ace Fatigue recovery aid
if(!(isNil "ace_advanced_fatigue_anReserve")) then {
    ace_advanced_fatigue_anReserve = ace_advanced_fatigue_anReserve + (ace_advanced_fatigue_recoveryFactor * 0.8);
    if(ace_advanced_fatigue_anReserve >= 2300) then {
        ace_advanced_fatigue_anReserve = 2300;
    };
};

_helperpos = _pos;
if(!isNull BW_anker)then{
    _f = (_no vectorDotProduct (velocity BW_anker));
    if(_f<0)then{_f=0;};
    _f = (_f*.1)+.1;
    _helperpos = _pos vectoradd (_no vectorMultiply _f);
};


BW_WMO_help setPosASL _helperpos;
BW_WMO_help setVectorup [0,0,1];

_obj = _obj call BW_WMO_fnc_getParent;


if (_obj isEqualTo BW_anker)then{
    _temp = (_posWorld vectoradd (((BW_anker modelToWorldVisualWORLD prevOffset) vectordiff  prevPlayerPos)));

    _vel = velocity player;
    _vel set [2,0];

    _searchCollPos1 = eyepos player;
    _searchCollPos2 = eyepos player;
    if !((animationState player) in ["aovrpercmstpsraswrfldf","aovrpercmstpsnonwnondf","aovrpercmstpslowwrfldf"])then{  //not V hopping
        _searchCollPos1 = _posWorld vectoradd [0,0,0.6];
    };

    //sorry for that check. Its the collsion stuff
    if(
        ({!isNull (_x select 2) && (_x select 0) distance _searchCollPos1 < 0.5 && (_x#1)#2 < .5} count (
            (lineIntersectsSurfaces [_searchCollPos1,_searchCollPos1 vectoradd _vel,player,objNull,true,1,"GEOM"])+
            (lineIntersectsSurfaces [_searchCollPos1,_searchCollPos1 vectoradd ([_vel,-30]call BIS_fnc_rotateVector2D),player,objNull,true,1,"GEOM"])+
            (lineIntersectsSurfaces [_searchCollPos1,_searchCollPos1 vectoradd ([_vel,30]call BIS_fnc_rotateVector2D),player,objNull,true,1,"GEOM"])+
            (lineIntersectsSurfaces [_searchCollPos2,_searchCollPos2 vectoradd _vel,player,objNull,true,1,"GEOM"])//+
            //(lineIntersectsSurfaces [_searchCollPos2,_searchCollPos2 vectoradd ([_vel,30]call BIS_fnc_rotateVector2D),player,objNull,true,1,"GEOM"])+
            //(lineIntersectsSurfaces [_searchCollPos2,_searchCollPos2 vectoradd ([_vel,-30]call BIS_fnc_rotateVector2D),player,objNull,true,1,"GEOM"])
            )
        >0)
    )then{
        _xToCenter = (BW_anker worldToModelVisual _posWorld)#0;
        _vec = BW_anker vectorModelToWorld [-_xToCenter,0,0];
        _line1 = [BW_anker,"GEOM"]intersect[_searchCollPos1,_searchCollPos1 vectoradd _vel] select {(_x#0) find "ladder_" > -1};
        _line2 = [BW_anker,"GEOM"]intersect[_searchCollPos1,_searchCollPos1 vectoradd _vec] select {(_x#0) find "ladder_" > -1};
        if (_line2 isEqualTo [] && _line1 isEqualTo [])then{
            _temp = _temp vectoradd (_vel vectorMultiply -0.02);
        };
    };


    _h = _helperpos#2;
    if((_temp select 2) - _h < .25)then{
        _temp set [2,_h-.1];
    }else{
        _temp set [2,(_temp select 2)-2.8/diag_FPS]; // simulating a fall velocity
    };
    _dirDiff = prevDirAnker - getDir BW_anker;
    _dir = direction player - _dirDiff;
    if (vectorMagnitude(velocity BW_anker) < 12)then{
        player setVelocityTransformation [_temp,_temp,[0,0,0],[0,0,- 0.4],vectordir player,[sin _dir,cos _dir,0],[0,0,1],[0,0,1],1]; //looks smoother in MP when the vehicle is not to fast
    }else{
        player setPosWorld _temp;
        player setDir _dir;
        player setVelocity [0,0,- 0.4];
    };

    prevOffset = BW_anker worldToModelVisual (if(getTerrainHeightASL _posWorld>0)then{(getposAtl player)}else{(getposAslw player)}); //I never really got how this pos shit works
    prevPlayerPos = _temp;
    prevDirAnker = getDir BW_anker;
}else{  //new object beneath
    //systemChat "new";
    BW_WMO_exit apply {BW_anker call _x;};
    if ([_obj] call BW_WMO_fnc_isWmoObject)then{
        BW_anker = _obj;
        BW_WMO_enter apply {_obj call _x;};
        if (isMultiplayer && !(local _obj) && _obj isEqualTo BW_anker)then{
            [player,_obj]remoteExecCall ["disableCollisionWith",_obj];
        };
        [BW_anker,false] call BW_WMO_fnc_collision;
        BW_WMO_collision = false;
        prevOffset = BW_anker worldToModelVisual (if(getTerrainHeightASL _posWorld>0)then{(getposAtl player)}else{(getposAslw player)});
        prevPlayerPos = getPosWorld player;
        prevDirAnker = getDir BW_anker;
    }else BW_WMO_fnc_exit;
};