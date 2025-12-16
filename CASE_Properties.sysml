package Case_Properties {
    private import AADL;
    enum def Component_Type {
        FILTER;
        ATTESTATION;
        MONITOR;
        VIRTUAL_MACHINE;
        COMM_DRIVER;
        SEL4;
        SWITCH;
    }
    attribute def Component_Impl :> ScalarValues::String;
    attribute def Component_Spec :> Collections::List;
    
    
}
