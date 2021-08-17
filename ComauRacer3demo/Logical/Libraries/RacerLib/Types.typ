
TYPE
	R3AutomaticModeErrorEnum : 
		(
		LOAD_PROGRAM_ERROR := 1,
		UNLOAD_PROGRAM_ERROR := 2,
		EXECUTE_PROGRAM_ERROR := 3,
		NO_ERROR := 0
		);
	R3AutomaticModeCmds : 	STRUCT  (*Automatic mode commands*)
		LoadProgram : MC_BR_LoadProgram;
		ExecuteProgram : MC_BR_MoveProgram;
		UnloadProgram : MC_BR_UnloadProgram;
	END_STRUCT;
	R3AutomaticModeState : 
		( (*Automatic mode state machine*)
		autoSTATE_LOAD, (*loading program*)
		autoSTATE_WAIT, (*waiting for instruction*)
		autoSTATE_EXECUTE, (*executing program*)
		autoSTATE_DONE, (*execution done*)
		autoSTATE_ERROR, (*error state*)
		autoSTATE_UNLOAD (*Unloading program state*)
		);
	R3AutomaticModePara : 	STRUCT  (*Automatic mode parameters*)
		ProgramName : STRING[260]; (*Program name to load/execute*)
		Load : BOOL;
		Execute : BOOL;
		Unload : BOOL;
		ErrorReset : BOOL; (*Resets errors*)
		Abort : BOOL; (*Aborts execution.*)
		UnloadAll : BOOL; (*tells the program to unload all programs from memory*)
		Interrupt : BOOL;
		Continue : BOOL;
		Continuous : BOOL;
	END_STRUCT;
	R3AutomaticModeInfo : 	STRUCT 
		CurrentState : R3AutomaticModeState; (*Current automode state*)
		AxesGroup : McAxesGroupType; (*AxesGroup to execute program on*)
		Error : R3AutomaticModeErrorEnum;
		ErrorID : DINT;
	END_STRUCT;
	R3AutomaticModeType : 	STRUCT  (*Automatic mode main structure*)
		Parameters : R3AutomaticModePara;
		Info : R3AutomaticModeInfo;
		Cmds : R3AutomaticModeCmds;
	END_STRUCT;
	R3ManualModeType : 	STRUCT  (*Manual mode type*)
		AxisButton : R3AxisBtnType; (*Stores button states for select coordinate system*)
		CoordinateSystem : McCoordinateSystemEnum; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		Direction : INT; (*Stores which direction should the axis be moved (1 - POSITIVE, -1 - NEGATIVE)*)
		JogVelocity : REAL; (*Stores the velocity of axis*)
		PathLimits : McJogPathLimitsType; (*Stores set limits of acceleration and deceleration, velocity and jerk*)
		ActivateMove : BOOL; (*Enables or disables current move execution*)
		ExitManual : BOOL; (*Exits Manual Mode on True*)
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
		( (*Currently unused*)
		POSITIVE := 1,
		NEGATIVE := -1
		);
	R3StateMachineEnum : 
		(
		STATE_ERROR, (*Error state*)
		STATE_INIT, (*Initialisation state*)
		STATE_POWER_ON, (*Powering on state*)
		STATE_READY, (*Ready for commands*)
		STATE_MANUAL_CONTROL, (*Manual mode*)
		STATE_SEMI_AUTOMATIC, (*Semi automatic mode*)
		STATE_AUTOMATIC, (*Automatic mode (script execution)*)
		STATE_CALIBRATION, (*Calibration mode*)
		STATE_HOMING (*Homing mode*)
		);
	R3CalibrationType : 	STRUCT 
		CalibrationState : R3CalibrationStateEnum; (*State machine used to control Calibration behaviour*)
		CalibrationModePara : R3ManualModeType; (*same type used for manual mode (slightly different code handling)*)
		AxisCalibrated : ARRAY[0..5]OF BOOL := [6(0)]; (*Saves which axes have been calibrated (defaults to 0 upon creation)*)
		AxisSaveBtn : BOOL; (*Button to save current position as calibrated*)
		Axis5To6Para : R3Axis5To6Type; (*Stores axis 5 settings for axis 6 calibration*)
	END_STRUCT;
	R3CalibrationStateEnum : 
		(
		STATE_START,
		STATE_CALIBRATE_Q1,
		STATE_CALIBRATE_Q2,
		STATE_CALIBRATE_Q3,
		STATE_CALIBRATE_Q4,
		STATE_CALIBRATE_Q5,
		STATE_CALIBRATE_Q6,
		STATE_RESTORE_Q5
		);
	R3Axis5To6Type : 	STRUCT  (*Type for storing axis 5 setting for axis 6 calibration*)
		Axis5MovedToCalAxis6 : BOOL; (*Stores whether axis 5 has been moved in order to calibrate axis 6*)
		Axis5Velocity : REAL; (*Velocity of axis 5*)
		Axis5Angle : LREAL; (*Angle of axis 5 to be set*)
		Axis5Return : BOOL; (*Flag to be set by a button to restore axis 5's position after calibrating axis 6*)
		Axis5Restored : BOOL; (*Axis 5 has been restored to previous position*)
	END_STRUCT;
	R3SemiAutoEnumType : 
		(
		INIT := 0,
		START := 1,
		UPDATE := 2,
		GO := 3
		);
	R3SemiAutoModeType : 	STRUCT 
		AxisDistance : R3AxisDistanceType; (*Stores given axis distance for relative move*)
		Flag : BOOL; (*Flag between READY and SEMIAUTO*)
		Mode : BOOL; (*Switches between relative and absolute modes, 1 for Relative, 0 for Absolute*)
		UpdatePending : BOOL; (*if UpdatePending then updates before starting move*)
		State : R3SemiAutoEnumType; (*state selector for state machine*)
		ModeForThisMove : BOOL; (*makes sure that switching mode in time of moving doesnt bugs out move*)
		CoordinateSystem : McCoordinateSystemEnum; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		PathMode : BOOL; (*Switches between direct and linear path mode, 1 for linear , 0 for direct*)
		PathModeForThisMove : BOOL;
	END_STRUCT;
	ControlSelectEnum : 
		(
		ManualJog := 1,
		SemiAutomatic := 2,
		Automatic := 3,
		None := 0
		);
	R3AxisDistanceType : 	STRUCT  (*todo axis position for absolute*)
		Q2 : REAL;
		Q3 : REAL;
		Q4 : REAL;
		Q5 : REAL;
		Q6 : REAL;
		Q1 : REAL;
	END_STRUCT;
	R3CalibrationMainType : 	STRUCT 
		Info : CalibrationInfo; (*Information portion of calibration.*)
		Cmds : CalibrationCmds; (*Calibration commands*)
		Para : CalibrationPara; (*Calibration parameters*)
	END_STRUCT;
	CalibrationPara : 	STRUCT 
		Parameters : R3CalibrationType;
		HomingParameters : McAcpAxHomingParType;
		FakeHomingModeEnum : ARRAY[0..14]OF McHomingModeEnum := [15(mcHOMING_DIRECT)];
		Positions : ARRAY[0..14]OF LREAL := [15(0.0)];
		HomingModeEnum : ARRAY[0..14]OF McHomingModeEnum := [15(mcHOMING_INIT)];
	END_STRUCT;
	CalibrationCmds : 	STRUCT 
		Mode : R3CalibrationMode;
		InitHome : MC_BR_InitHome_AcpAx;
		GroupHome : MC_BR_GroupHome_15;
	END_STRUCT;
	CalibrationInfo : 	STRUCT 
		CurrentState : OuterCalibrationState;
	END_STRUCT;
	OuterCalibrationState : 
		(
		STATE_BEGIN,
		STATE_FAKE_HOME,
		STATE_MOVING,
		STATE_SAVING_POSITION,
		STATE_DONE
		);
END_TYPE
