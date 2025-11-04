package MC {
	private import AADL;
	private import SW;
	private import Resolute::*;
	private import CASE_Requirements::*;
	private import CASE_Assurance::*;
	
	part def Radio :> AADL::Device {
		port mca : AADL::BusAccess;
		port rfa : AADL::BusAccess;
		in port recvIn : AADL::EventDataPort;
		out port recvOut : AADL::EventDataPort {
			out :> type : CASE_Model_Transformation::CASE_RF_Msg;
		}
		in port sendIn : AADL::EventDataPort {
			in :> type : CASE_Model_Transformation::CASE_RF_Msg;
		}
		out port sendOut : AADL::EventDataPort;
	}
	
	part def UART :> AADL::Device {
		port mca : AADL::BusAccess;
		port rfa : AADL::BusAccess;
		in port recvIn : AADL::EventDataPort;
		out port recvOut : AADL::EventDataPort {
			out :> type : CASE_Model_Transformation::CASE_UART_Msg;
		}
		in port sendIn : AADL::EventDataPort {
			in :> type : CASE_Model_Transformation::CASE_UART_Msg;
		}
		out port sendOut : AADL::EventDataPort;
	}
	
	part def MC_Proc :> AADL::Processor {
		port mca : AADL::BusAccess;
	}
	
	part def MC_Mem :> AADL::Memory {
		port mca : AADL::BusAccess;
	}
	
	part def MC_Bus :> AADL::Bus;
	
	part def MissionComputer :> AADL::System {
		in port radioRecv : AADL::EventDataPort;
		out port radioSend : AADL::EventDataPort;
		in port uartRecv : AADL::EventDataPort;
		out port uartSend : AADL::EventDataPort;
		port uarta : AADL::BusAccess;
		port rfa : AADL::BusAccess;
		
		part radio_hw : Radio;
		part uart_hw : UART;
		part proc_hw : MC_Proc;
		part mem_hw : MC_Mem;
		part bus_hw : MC_Bus;
		part sw : SW::SW_sel4;
	
		connection c1 : AADL::PortConnection
			connect radioRecv to radio_hw.recvIn;
		connection c2 : AADL::PortConnection 
			connect radio_hw.sendOut to radioSend;
		connection c3 : AADL::PortConnection
			connect uartRecv to uart_hw.recvIn;
		connection c4 : AADL::PortConnection
			connect uart_hw.sendOut to uartSend;
		
		// unsure how to implement bus accesses
		
		connection apb : Deployment_Properties::Actual_Processor_Binding
			connect sw to proc_hw; 
		connection amb : Deployment_Properties::Actual_Memory_Binding
			connect sw to mem_hw;
			
		#argue constraint idk : MissionComputer_cyber_resilient {
			in redefines sys = this;
		}
	}
	
	#goal constraint def MissionComputer_cyber_resilient {
		
		in sys : AADL::System;
		security_requirements_complete(sys) and MissionComputer_security_requirements_satisfied(sys)
	}
	
	#goal constraint def MissionComputer_security_requirements_satisfied {
		in sys : AADL::System;
		MissionComputer_security_requirements_satisfied_in_model() and security_requirements_satisfied_in_implementation(sys)
	}
	
	#goal constraint def MissionComputer_security_requirements_satisfied_in_model {
		Req_Attestation() and Req_Filter() and Req_Monitor() and Req_Separation()
	}
}