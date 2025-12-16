package SW {
    private import DataTypes;
    private import AADL_Project::*;
    private import GUMBOLib::*;
    private import GUMBO_Definitions::*;
   
    comment /* ignoring CASE_Properties/Scheduling for now */
    
    part def AttestationTester :> AADL::Thread {
        in port attestationRequest : AADL::EventDataPort;
        out port attestationResponse : AADL::EventDataPort;
        attribute attesting = 100;
        attribute :>> Dispatch_Protocol = Dispatch_Protocol::Periodic;
        attribute :>> Period : Time {:>> num = 500; }
        attribute :>> Compute_Execution_Time {
            ::> minimum : Time { :>> num = 10; }
            ::> maximum : Time { :>> num = 50; }
            ::> delta : Time { :>> num = 1; }
        }
        attribute stack_size = 1048576;
        attribute source_text = "Component_Source/SW_AttestationTester/Pass/user_am.S";
    }
    
    part def AttestationTester_seL4 :> AADL::Process {
    	part attestationTester : AttestationTester;
    	
        in port attestationRequest : AADL::EventDataPort {
            in :> type : DataTypes::AttestationRequestMsg;
        }
        out port attestationResponse : AADL::EventDataPort {
            out :> type : DataTypes::AttestationResponseMsg;
        }
        
        connection c1 : AADL::Connection connect attestationRequest to attestationTester.attestationRequest;
        connection c2 : AADL::Connection connect attestationTester.attestationResponse to attestationResponse;
        attribute :>> Period { :>> num = 500; }
    }
    
    part def RadioDriver :> AADL::Thread {
        out port missionCommand : AADL::EventDataPort {
            out :> type : DataTypes::RF_Msg;
        }
        attribute :>> Dispatch_Protocol = Dispatch_Protocol::Periodic;
        attribute :>> Period {
        	attribute :>> num = 500;
        }
        attribute :>> Compute_Execution_Time {
            :>> minimum : Time { :>> num = 10; }
            :>> maximum : Time { :>> num = 50; }
            :>> delta : Time { :>> num = 1; }
        }
        attribute stack_size = 1048576;
    }
    
    part def FlightPlanner :> AADL::Thread {
        in port missionCommand : AADL::EventDataPort {
            in :> type : DataTypes::RF_Msg;
        }
        out port flightPlan : AADL::EventDataPort {
            out :> type : DataTypes::Mission;
        }
        attribute :>> Dispatch_Protocol = Dispatch_Protocol::Periodic;
        attribute :>> Period : Time { :>> num = 500; }
        attribute :>> Compute_Execution_Time {
         	:>> minimum : Time { :>> num = 10; }
            :>> maximum : Time { :>> num = 50; }
            :>> delta : Time { :>> num = 1; }
        }
        attribute stack_size = 1048576;
        
        #compute #assumption constraint Req_Filter {
        	HasEvent(missionCommand) implies well_formed_mission_command(missionCommand.type)
        }
    }
    
    part def FlightPlanner_seL4 :> AADL::Process {
        in port missionCommand : AADL::EventDataPort {
            in redefines type : DataTypes::RF_Msg;
        }
        out port flightPlan : AADL::EventDataPort {
            out :> type : DataTypes::Mission;
        }
        part flightPlanner : FlightPlanner;
        connection c1 : AADL::Connection connect missionCommand to flightPlanner.missionCommand;
        connection c2 : AADL::Connection connect flightPlanner.flightPlan to flightPlan;
        attribute redefines Period : Time { redefines num = 500; }
        
        // comes from lift contract. Should these ports be the ports belonging to flightPlanner?
        #compute #assumption constraint Req_Filter {
        	HasEvent(missionCommand) implies well_formed_mission_command(missionCommand.type)
        } 
    }
    
    part def FlightController :> AADL::Thread {
        in port alert : AADL::EventPort;
        in port flightPlan : AADL::EventDataPort {
            in :> type : DataTypes::Mission;
        }
        attribute :>> Dispatch_Protocol = Dispatch_Protocol::Periodic;
        attribute :>> Period : Time { :>> num = 500; }
        attribute ::> Compute_Execution_Time {
            :>> minimum : Time { :>> num = 10; }
            :>> maximum : Time { :>> num = 50; }
            :>> delta : Time { :>> num = 1; }
        }
        attribute stack_size = 1048576;
    }
    
    part def SW :> AADL::Process {
        part radioDriver : RadioDriver;
        part flightPlanner : FlightPlanner;
        part flightController : FlightController;
        connection c1 : AADL::Connection connect radioDriver.missionCommand to flightPlanner.missionCommand;
        connection c2 : AADL::Connection connect flightPlanner.flightPlan to flightController.flightPlan;
    }
    
    part def RadioDriver_seL4 :> AADL::Process {
        out port missionCommand : AADL::EventDataPort {
            out :> type : DataTypes::RF_Msg;
        }
        part radioDriver : RadioDriver;
        connection c1 : AADL::Connection connect radioDriver.missionCommand to missionCommand;
        attribute redefines Period : Time { redefines num = 500; }
    }
    
    
    part def FlightController_seL4 :> AADL::Process {
        in port alert : AADL::EventPort;
        in port flightPlan : AADL::EventDataPort {
            in :> type : DataTypes::Mission;
        }
        part flightController : FlightController;
        connection c1 : AADL::Connection connect flightPlan to flightController.flightPlan;
        connection c2 : AADL::Connection connect alert to flightController.alert;
        attribute redefines Period : Time { redefines num = 500; }
    }
    
    part def RadioDriver_Attestation :> AADL::Thread {
        out port missionCommand : AADL::EventDataPort {
            out :> type : DataTypes::RF_Msg;
        }
        in port attestationRequest : AADL::EventDataPort {
            in :> type : DataTypes::AttestationRequestMsg;
        }
        out port attestationResponse : AADL::EventDataPort {
            out :> type : DataTypes::AttestationResponseMsg;
        }
        in port attestationTesterResponse : AADL::EventDataPort {
            in :> type : DataTypes::AttestationResponseMsg;
        }
        out port attestationTesterRequest : AADL::EventDataPort {
            out :> type : DataTypes::AttestationRequestMsg;
        }
        attribute redefines Dispatch_Protocol = Dispatch_Protocol::Periodic;
        attribute redefines Period : Time { redefines num = 500; }
        attribute redefines Compute_Execution_Time {
            redefines minimum : Time { redefines num = 10; }
            redefines maximum : Time { redefines num = 50; }
            redefines delta : Time { redefines num = 1; }
        }
        attribute stack_size = 1048576;
    }
    
    part def RadioDriver_Attestation_seL4 :> AADL::Process {
        out port missionCommand : AADL::EventDataPort {
            out :> type : DataTypes::RF_Msg;
        }
        in port attestationRequest : AADL::EventDataPort {
            in :> type : DataTypes::AttestationRequestMsg;
        }
        out port attestationResponse : AADL::EventDataPort {
            out :> type : DataTypes::AttestationResponseMsg;
        }
        in port attestationTesterResponse : AADL::EventDataPort {
            in :> type : DataTypes::AttestationResponseMsg;
        }
        out port attestationTesterRequest : AADL::EventDataPort {
            out :> type : DataTypes::AttestationRequestMsg;
        }
        part radioDriver : RadioDriver_Attestation;
        connection c1 : AADL::Connection connect radioDriver.missionCommand to missionCommand;
        connection c2 : AADL::Connection connect radioDriver.attestationResponse to attestationResponse;
        connection c3 : AADL::Connection connect attestationRequest to radioDriver.attestationRequest;
        connection c4 : AADL::Connection connect attestationTesterResponse to radioDriver.attestationTesterResponse;
        connection c5 : AADL::Connection connect radioDriver.attestationTesterRequest to attestationTesterRequest;
        attribute redefines Period : Time { redefines num = 500; }
    }
    
    part def AttestationManager :> AADL::Thread {
    	out port attestationRequest : AADL::EventDataPort {
    		out :> type : DataTypes::AttestationRequestMsg;
    	}
    	in port attestationResponse : AADL::EventDataPort {
    		in :> type : DataTypes::AttestationResponseMsg;
    	}
    	out port trustedIds : AADL::EventDataPort {
    		out :> type : DataTypes::AllowList;
    	}
    	attribute redefines Dispatch_Protocol = Dispatch_Protocol::Periodic;
        attribute redefines Period : Time { redefines num = 500[m][s]; }
        attribute redefines Compute_Execution_Time {
            redefines minimum : Time { redefines num = 10[m][s]; }
            redefines maximum : Time { redefines num = 50[m][s]; }
            redefines delta : Time { redefines num = 1[m][s]; }
        }
        attribute stack_size = 1048576[B];
        attribute source_text = "Component_Source/KU_Attestation/build/heli_am.S";
    }
    
    part def AttestationManager_seL4 :> AADL::Process {
    	part attestationManager : AttestationManager;
    	    	
    	out port attestationRequest : AADL::EventDataPort {
    		out :> type : DataTypes::AttestationRequestMsg;
    	}
    	in port attestationResponse : AADL::EventDataPort {
    		in :> type : DataTypes::AttestationResponseMsg;
    	}
    	out port trustedIds : AADL::EventDataPort {
    		out :> type : DataTypes::AllowList;
    	}

    	connection c1 : AADL::Connection connect attestationManager.attestationRequest to attestationRequest;
    	connection c2 : AADL::Connection connect attestationResponse to attestationManager.attestationResponse;
    	connection c3 : AADL::Connection connect attestationManager.trustedIds to trustedIds;
    	
    	:>> Period : Time { :>> num = 500[m][s]; }
    	attribute source_text = "Component_Source/KU_Attestation/build/heli_am.S";
    }
    
    part def AttestationGate :> AADL::Thread {
    	in port missionCommand_in : AADL::EventDataPort {
    		in :> type : DataTypes::RF_Msg;
    	}
    	out port missionCommand_out : AADL::EventDataPort {
    		out :> type : DataTypes::RF_Msg;
    	}
    	in port trustedIds : AADL::EventDataPort {
    		in :> type : DataTypes::AllowList; 
    	}
    	
    	:>> Dispatch_Protocol = Dispatch_Protocol::Periodic;
    	attribute redefines Period : Time { redefines num = 500[m][s]; }
        attribute redefines Compute_Execution_Time {
            redefines minimum : Time { redefines num = 10[m][s]; }
            redefines maximum : Time { redefines num = 50[m][s]; }
            redefines delta : Time { redefines num = 1[m][s]; }    
        }
        attribute stack_size = 1048576[B];
        attribute source_text = ("Component_Source/SW_AttestationGate/AttestationGate.S", "Component_Source/SW_AttestationGate/basis_ffi.c");
        
        // how is -> translated into GUMBO? I'm guessing this is split into an initialize value and a compute value????
        // how is pre translated into GUMBO?
        #statevar part trusted_ids : DataTypes::AllowList;
       	
       	// AGREE: trusted_ids : Data_Types::AllowList.Impl = 
       	// 	   (if event(TrustedIds) then TrustedIds else Data_Types::AllowList.Impl { value = [| 0, 0, 0, 0 |] }) -> 
       	//     (if event(TrustedIds) then TrustedIds else pre(trusted_ids))	
        #initialize #guarantee constraint trusted_ids_initial_value {
        	trusted_ids.listValue.value == (if HasEvent(trustedIds) ? trustedIds.type.value else (0,0,0,0))
        }
        
        #compute #guarantee constraint trusted_ids_next_value {
        	trusted_ids.listValue.value == (if HasEvent(trustedIds) ? trustedIds.type.value else In(trusted_ids.listValue.value))
        }

        #gumbofunction calc def is_trusted { in command : DataTypes::RF_Msg; in ids : DataTypes::AllowList; return : Base_Types::Data_Boolean;
        	: Base_Types::Data_Boolean {
        		:>> value = ExistsIn(ids.listValue.value, { in i; command.header.src.value == i });
        	}
        }
        
        #guarantee constraint attestationGate_missionCommand_out {
        	if (HasEvent(missionCommand_in) and is_trusted(missionCommand_in.type, trusted_ids)) ?
        		(HasEvent(missionCommand_out) and (missionCommand_out == missionCommand_in))
        	else not (HasEvent(missionCommand_out))
        }
    }
    
    part def AttestationGate_seL4 :> AADL::Process {
    	part attestationGate : AttestationGate;
    	
    	in port missionCommand_in : AADL::EventDataPort {
    		in :> type : DataTypes::RF_Msg;
    	}
    	out port missionCommand_out : AADL::EventDataPort {
    		out :> type : DataTypes::RF_Msg;
    	}
    	in port trustedIds : AADL::EventDataPort {
    		in :> type : DataTypes::AllowList; 
    	}
    	
    	connection c1 : AADL::Connection connect missionCommand_in to attestationGate.missionCommand_in;
    	connection c2 : AADL::Connection connect attestationGate.missionCommand_out to missionCommand_out;
    	connection c3 : AADL::Connection connect trustedIds to attestationGate.trustedIds;
    	
    	redefines Period : Time { redefines num = 500[m][s]; }
    }
    
    part def Filter :> AADL::Thread {
    	in port input : AADL::EventDataPort  {
    		in :> type : DataTypes::RF_Msg;
    	}
    	out port output : AADL::EventDataPort {
    		out :> type : DataTypes::RF_Msg;
    	}
    	
    	redefines Dispatch_Protocol = Dispatch_Protocol::Periodic;
        redefines Period : Time { :>> num = 500[m][s]; }
        redefines Compute_Execution_Time {
            redefines minimum : Time { redefines num = 10[m][s]; }
            redefines maximum : Time { redefines num = 50[m][s]; }
            redefines delta : Time { redefines num = 1[m][s]; }
        }
        attribute stack_size = 1048576[B];
        attribute source_text = ("Component_Source/SW_Filter/Filter.S", "Component_Source/SW_Filter/basis_ffi.c");
    }
    
    part def Filter_seL4 :> AADL::Process {
    	part filterThread : Filter; // filter is a keyword in SysML
    	
    	in port input : AADL::EventDataPort  {
    		in :> type : DataTypes::RF_Msg;
    	}
    	out port output : AADL::EventDataPort {
    		out :> type : DataTypes::RF_Msg;
    	}
    	
    	connection c1 : AADL::Connection connect filterThread.output to output;
    	connection c2 : AADL::Connection connect input to filterThread.input;
    	
   		:>> Period : Time { :>> num = 500[m][s]; }
    }
    
    part def Monitor :> AADL::Thread {
    	out port alert : AADL::EventPort;
    	in port observed : AADL::EventDataPort {
    		in :> type : DataTypes::Mission;
    	}
    	out port output : AADL::EventDataPort {
    		out :> type : DataTypes::Mission;
    	}
    	
    	redefines Dispatch_Protocol = Dispatch_Protocol::Periodic;
        redefines Period : Time { :>> num = 500[m][s]; }
        redefines Compute_Execution_Time {
            redefines minimum : Time { redefines num = 10[m][s]; }
            redefines maximum : Time { redefines num = 50[m][s]; }
            redefines delta : Time { redefines num = 1[m][s]; }
        }
        attribute stack_size = 1048576[B];
        attribute source_text = ("Component_Source/SW_Monitor/Monitor.S", "Component_Source/SW_Monitor/basis_ffi.c");
    }
    
  	part def Monitor_seL4 :> AADL::Process {
  		part monitor : Monitor;
  		
  		out port alert : AADL::EventPort;
    	in port observed : AADL::EventDataPort {
    		in :> type : DataTypes::Mission;
    	}
    	out port output : AADL::EventDataPort {
    		out :> type : DataTypes::Mission;
    	}
    	
    	connection c1 : AADL::Connection connect monitor.alert to alert;
    	connection c2 : AADL::Connection connect monitor.output to output;
  		connection c3 : AADL::Connection connect observed to monitor.observed;
  		
  		:>> Period : Time { :>> num= 500[m][s]; }
  	}
    
    part def SW_seL4 :> AADL::System {
    	part radioDriver : RadioDriver_Attestation_seL4;
    	part flightPlanner : FlightPlanner_seL4;
    	part flightController : FlightController_seL4;
    	part attestationManager : AttestationManager_seL4;
    	part attestationGate : AttestationGate_seL4;
    	part filterProc : Filter_seL4;
    	part monitor : Monitor_seL4;
    	part attestationTester : AttestationTester_seL4;
    	
    	connection c1 : AADL::Connection connect attestationGate.missionCommand_out to filterProc.input;
    	connection c2 : AADL::Connection connect monitor.output to flightController.flightPlan;
    	connection c3 : AADL::Connection connect radioDriver.missionCommand to attestationGate.missionCommand_in;
    	connection c4 : AADL::Connection connect attestationManager.trustedIds to attestationGate.trustedIds;
    	connection c5 : AADL::Connection connect attestationManager.attestationRequest to radioDriver.attestationRequest;
    	connection c6 : AADL::Connection connect radioDriver.attestationResponse to attestationManager.attestationResponse;
    	connection c7 : AADL::Connection connect filterProc.output to flightPlanner.missionCommand;
    	connection c8 : AADL::Connection connect flightPlanner.flightPlan to monitor.observed;
    	connection c9 : AADL::Connection connect monitor.alert to flightController.alert;
    	connection c10 : AADL::Connection connect radioDriver.attestationTesterRequest to attestationTester.attestationRequest;
    	connection c11 : AADL::Connection connect attestationTester.attestationResponse to radioDriver.attestationTesterResponse;
    }
}
