params ["_unit", "_selectionName", "_damage", "_source", "_projectile", "_hitPartIndex", "_instigator"];

if (!local _unit) exitwith {};
if (isNull BW_anker && BW_WMO_collision) exitwith {};

if(_source isEqualTo player && _projectile isEqualTo "" && isnull _instigator)then{
	   0;
}else{
	_damage;
};