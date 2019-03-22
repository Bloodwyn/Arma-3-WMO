class CfgPatches
{
	class BW_adaptive_roadway
	{
		units[]=
		{
			"BW_roadway_obj"
		};
		requiredVersion=1;
		requiredAddons[]=
		{
			"A3_Modules_F"
		};
		weapons[]={};
	};
};
class CfgFunctions
{
	class BW_WMO
	{
		class BW_WalkableMovingObjects
		{
			file="\BW_WalkableMovingObjects";

			class initWMO{postInit=1;};
			class setPosi{};
			class collision{};
			class handleDamage{};
			class getParent{};
			class isWmoObject{};
			class leave{};
			class exit{};
			class getsRoadway{};
		};
	};
};
class CfgVehicles
{
	class Items_base_F;
	class BW_roadway_obj: Items_base_F
	{
		scope=2;
		author="Bloodwyn";
		model="\BW_WalkableMovingObjects\rw.p3d";
		displayName="Inivisible Roadway LOD for the adaptive roadway";
		vehicleClass="Objects";
		armor=20000;
		icon="iconObject";
		mapSize=0.69999999;
		accuracy=0.2;
	};
	class BW_roadway_obj_debug: Items_base_F
	{
		scope=2;
		author="Bloodwyn";
		model="\BW_WalkableMovingObjects\rw_debug.p3d";
		displayName="Inivisible Roadway LOD for the adaptive roadway";
		vehicleClass="Objects";
		armor=20000;
		icon="iconObject";
		mapSize=0.69999999;
		accuracy=0.2;
	};
};