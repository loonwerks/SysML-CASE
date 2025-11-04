package DataTypes {
    part def MsgHeader :> AADL::Data;
    part def Command :> AADL::Data;
    
    part def RF_Msg :> AADL::Data {
        part header : MsgHeader;
        part payload : Command;
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
        attribute data_representation : Collections::Array;
        part base_type : Base_Types::Unsigned_32;
        attribute dimension = 4;
    }
    part def AllowList :> AADL::Data {
       part listValue : AddressArray;
    }
    part def Mission :> AADL::Data {
        attribute data_representation : Collections::Array;
        part base_type : Coordinate;
        attribute dimension = 3;
    }
}