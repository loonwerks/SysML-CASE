package CASE_Requirements {
	private import Resolute::goal;
	private import CASE_Model_Transformation::*;
	#goal constraint def Req_Attestation {
		//context 
		//requirement doc
		add_attestation_manager(//"MC::MissionComputer.SW.RadioDriver", // inconsistent with other def
			"MC::MissionComputer.SW.AttestationManager",
			"MC::MissionComputer.SW.AttestationGate")
	}
	
	#goal constraint def Req_Filter {
		//req doc
		//context
		agree_property_checked("MC::MissionComputer.SW.FlightPlanner", "Req_Filter") and 
		add_filter("MC::MissionComputer.SW.FlightPlanner",
			"MC::MissionComputer.SW.Filter", 
			"MC::MissionComputer.SW.c7", 
			"Data_Types::RF_Msg") //not a string in the original
	}
	
	#goal constraint def Req_Monitor {
		//req doc
		//context
		add_monitor_gate(// "MC::MissionComputer.Impl.SW.FlightPlanner", //inconsistent with other def I found
			"MC::MissionComputer.Impl.SW.Monitor", 
			"MC::MissionComputer.Impl.SW.Monitor.Alert", 
			"MC::MissionComputer.Impl.SW.FlightController", 
			"Data_Types::Mission")
	}
	
	#goal constraint def Req_Separation {
		//req doc
		//context
		sel4_transform("MC::MissionComputer.Impl.SW")
	}
}