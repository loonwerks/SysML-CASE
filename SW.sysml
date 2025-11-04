package SW {
    private import DataTypes;
    private import AADL_Project::*;
   
    comment /* ignoring CASE_Properties */
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
    part def AttestationTester_sel4 :> AADL::Process {
        in port attestationRequest : AADL::EventDataPort {
            in :> type : DataTypes::AttestationRequestMsg;
        }
        out port attestationResponse : AADL::EventDataPort {
            out :> type : DataTypes::AttestationResponseMsg;
        }
        part attestationTester : AttestationTester;
        connection c1 : AADL::Connection connect attestationRequest to attestationTester.attestationRequest;
        connection c2 : AADL::Connection connect attestationTester.attestationResponse to attestationResponse;
        attribute :>> Period {
        	:>> num = 500;
        }
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
    part def RadioDriver_sel4 :> AADL::Process {
        out port missionCommand : AADL::EventDataPort {
            out :> type : DataTypes::RF_Msg;
        }
        part radioDriver : RadioDriver;
        connection c1 : AADL::Connection connect radioDriver.missionCommand to missionCommand;
        attribute redefines Period : Time { redefines num = 500; }
    }
    part def FlightPlanner_sel4 :> AADL::Process {
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
    }
    part def FlightController_sel4 :> AADL::Process {
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
    part def RadioDriver_Attestation_sel4 :> AADL::Process {
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
    
    part def SW_sel4 :> AADL::System;
}
