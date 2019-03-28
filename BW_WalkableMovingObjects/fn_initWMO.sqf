/*
	Author: Bloodwyn http://steamcommunity.com/profiles/76561198055205907/

	Description:
	what does an init do?
*/

if !(hasInterface)exitWith{};

diag_log "-----Starting WMO-----";

if (isNil "WMO_specialObjects")then{WMO_specialObjects=[]}; //for objects that are not typeOf car/air/ship Now also works with classname or modelinfo select 1

if (isNil "WMO_noRoadway")then{WMO_noRoadway=[]}; //for objects that are not typeOf car/air/ship Now also works with classname or modelinfo select 1

0 spawn{
    waitUntil {time > 1};
    if !(isNil "babe_em_fnc_walkonstuff")then{
        ["EH_em_walkonstuff"] call babe_core_fnc_removeEH;
        babe_em_help setposasl [0,0,0];
    };
    WMO_noRoadway = WMO_noRoadway + ["NonSteerable_Parachute_F","Steerable_Parachute_F","B_Parachute_02_F","O_Parachute_02_F","I_Parachute_02_F"];
    if !(isNull (configfile >> "CfgPatches" >> "acex_sitting"))then{
        WMO_noRoadway = WMO_noRoadway + ["Land_OfficeChair_01_F","Land_ChairWood_F","Land_RattanChair_01_F","Land_CampingChair_V2_F","Land_CampingChair_V2_white_F","Land_ChairPlastic_F","Land_CampingChair_V1_F","Land_Bench_01_F","Land_Bench_02_F","Land_Bench_03_F","Land_Bench_04_F","Land_Bench_05_F"];
    };
    //["walkHandler","onEachFrame",BW_WMO_fnc_setPosi] call BIS_fnc_addStackedEventHandler;
    addMissionEventHandler ["EachFrame",BW_WMO_fnc_setPosi];//because of exile. Thanks NiiRoZz
};

if (isNil "BW_WMO_enter")then{BW_WMO_enter=[]};
if (isNil "BW_WMO_exit")then{BW_WMO_exit=[]};

BW_WMO_help = "BW_roadway_obj" createVehicleLocal [0,0,0];
BW_WMO_help setMass 0;
BW_anker = objNull;

BW_WMO_collision = true;
BW_WMP_dmgEvh = player addEventHandler ["HandleDamage", BW_WMO_fnc_handleDamage];


diag_log "-----WMO init done-----";

//fall = 0.25;
//h = 0;

//upH = 0.3;
//downH = -1.5;

//geoH = 0.5;
//geoD = 0.5;
//geoB = -0.02;

//geoL = 1;
//geoG = 30;

//downvel = 0.4;

//upadd = .1;
