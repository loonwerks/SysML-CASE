package DataTypes {
	private import ScalarValues::Real;
	
    part def MsgHeader :> AADL::Data {
    	part src : Base_Types::Unsigned_32;
    	part dst : Base_Types::Unsigned_32;
    }
    
    part def Map :> AADL::Data {
    	:>> value : Collections::Array { :>> elements[0..2] : Coordinate; }	
    }
    
    part def Command :> AADL::Data {
    	part map : Map;
    }
    
    part def RF_Msg :> AADL::Data {
        part header : MsgHeader;
        part payload : Command;
    }
    
    part def KeepInZone :> AADL::Data {
    	:>> value : Collections::Array { :>> elements[0..2] : Coordinate; } // Why is this specifiable? Because elements is a feature which usages are. 
    }
    
    part def Coordinate :> AADL::Data {
        part latitude : Base_Types::Data_Float_32;
        part longitude : Base_Types::Data_Float_32;
        part altitude : Base_Types::Data_Float_32;
    }
    
    part def AttestationRequestMsg :> AADL::Data {
        attribute data_representation : Collections::Array;
        part base_type : Base_Types::Unsigned_8;
        attribute dimension = 16;
    }
    part def AttestationResponseMsg :> AADL::Data {
        attribute data_representation : Collections::Array;
        part base_type : Base_Types::Unsigned_8;
        attribute dimension = 2048;
    }
    part def AddressArray :> AADL::Data {
    	:>> value : Collections::Array { :>> elements[0..4] : Base_Types::Unsigned_32; }
    }
    part def AllowList :> AADL::Data {
       part listValue : AddressArray;
    }
    part def Mission :> AADL::Data {
       :>> value : Collections::Array { :>> elements[0..3] : Coordinate; }
    }
}