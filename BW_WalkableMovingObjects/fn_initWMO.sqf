/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	Description:
	what does a init do?
*/

if !(hasInterface)exitWith{};

diag_log "-----Starting WMO-----";

if (isNil "WMO_specialObjects")then{WMO_specialObjects=[]}; //for objects that are not typeOf car/air/ship Now also works with classname or modelinfo select 1

0 spawn{
    waitUntil {time > 0};
    if !(isNil "babe_em_fnc_walkonstuff")then{
        ["EH_em_walkonstuff"] call babe_core_fnc_removeEH;
        babe_em_help setposasl [0,0,0];
    };
};

BW_WMO_help = "BW_roadway_obj" createVehicleLocal [0,0,0];
BW_WMO_help setMass 0;
["road","onEachFrame",{call BW_WMO_fnc_walkonstuff2}] call BIS_fnc_addStackedEventHandler;
//addMissionEventHandler ["EachFrame",{call BW_WMO_fnc_walkonstuff2}];
BW_anker = objNull;

//addMissionEventHandler ["EachFrame",{call BW_WMO_fnc_setPosi}];//because of exile. Thanks NiiRoZz

["walkHandler","onEachFrame",{call BW_WMO_fnc_setPosi}] call BIS_fnc_addStackedEventHandler;

diag_log "-----WMO init done-----";

fall = 0.25;
h = 0.1;

upH = 0.3;
downH = -1;

geoH = 0.5;
geoD = 0.5;
geoB = 0.02;

downvel = 0.4;

upadd = 0.1;

withNo= false;