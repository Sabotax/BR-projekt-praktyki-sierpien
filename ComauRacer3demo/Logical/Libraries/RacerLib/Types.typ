
TYPE
	R3ManualModeType : 	STRUCT  (*Manual mode type*)
		AxisButton : R3AxisBtnType; (*Stores button states for select coordinate system*)
		CoordinateSystem : UDINT; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		Direction : R3DirectionEnum; (*Stores which direction should the axis be moved*)
		JogVelocity : REAL; (*Stores the velocity of axis*)
		PathLimits : McJogPathLimitsType;
		JogVelocityActual : REAL; (*Stores the actual velocity to be written to axis*)
	END_STRUCT;
	R3AxisBtnType : 	STRUCT  (*Global Coordinate System Select button*)
		Q1 : BOOL;
		Q2 : BOOL;
		Q3 : BOOL;
		Q4 : BOOL;
		Q5 : BOOL;
		Q6 : BOOL;
	END_STRUCT;
	R3DirectionEnum : 
		(
		POSITIVE,
		NEGATIVE
		);
	R3StateMachineEnum : 
		(
		STATE_ERROR,
		STATE_INIT,
		STATE_POWER_ON,
		STATE_READY,
		STATE_MANUAL_CONTROL,
		STATE_SEMI_AUTOMATIC,
		STATE_AUTOMATIC,
		STATE_CALIBRATION
		);
END_TYPE
