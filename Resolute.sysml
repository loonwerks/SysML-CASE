package Resolute {
	public import ResoluteLibs::*;
	private import SysML;
	private import AADL::*;
	
	private import ScalarValues::Boolean;
	private import ScalarValues::String;
	
	metadata def <ruleset> ResoluteRuleset;
	metadata def <rule>;
	metadata def <error>;
	metadata def <warning>;
	
	metadata def <argue> ResoluteArgue;
    metadata def <resolutedefine> ResoluteDefine;

    metadata def <goal> ResoluteGoal {
    	:> annotatedElement : SysML::ConstraintDefinition;
    }
    metadata def <strategy> ResoluteStrategy {
    	:> annotatedElement : SysML::ConstraintDefinition;
    }
    
    metadata def <resolute>;
    
    // idk where yet
    calc def all_components { return : Collections::Set; }
    
    calc def all_processes { return : Collections::Set; }
    
    calc def all_processors { return : Collections::Set; }
    
    calc def all_threads { return : Collections::Set; }
    
    calc def as_list { in coll : Collections::Set; return : Collections::List; }
        
    calc def confidence_in_agree_results { return : Boolean; }
    
    comment /* connections seems to be overloaded for components and features/ports */
    calc def connections { in comp : Component; return : Collections::Set; }
    
    calc def contained { in feat : Feature; in comp : Component; return : Boolean; }
    
    calc def destination { in conn : Connection; return : Component; }
    
    calc def destination_component { in conn : Connection; return : Component; }
    
    calc def empty_set { return : Collections::Set; }
    
    calc def end_to_end_flows { in comp : Component; return : Collections::Collection; }
    
    
    comment /* How do we type these higher order functions? */
    constraint def exists { in coll : Collections::Collection; in calc f; }

	calc def flatten { in input : Collections::Collection; return : Collections::Collection; }
	
	
    calc def flow_specifications { in comp : Component;	return : Collections::Collection; }
      
	constraint def forall { in coll : Collections::Collection; in calc f; }
    
    calc def has_modes { in c : Component; return : Boolean; }
    
    calc def has_property { in comp : Component; in prop : String; return : Boolean; }
     
    calc def has_type { in conn : Connection; return : Boolean; }
    
    calc def head { in coll : Collections::List; }
    
    calc def id { in x;	x }
    
    calc def intersect { 
    	in s : Collections::Set; in t : Collections::Set; return : Collections::Set;
    }
    
    calc def is_bound_to { in comp : Component; in comp2 : Component; return : Boolean; }
    
    calc def is_destination_component { 
    	in conn : Connection; in comp : Component; return : Boolean;
    }
    
    constraint def is_of_case_type { in something; in kind : ScalarValues::String; }
    
    calc def is_port_connection { in comp : Connection ; return : Boolean; }
    
    calc def is_process { in comp : Component; return : Boolean; }
    
    calc def is_processor { in comp : Component; return : Boolean; } 
   
    calc def is_seL4_processor { in comp : Component; return : Boolean; }
    
    calc def is_source_component { in conn : Connection; in comp : Component; return : Boolean; }
    
    calc def is_system { in comp : Component; return : Boolean; }
    
    calc def is_thread { in comp : Component; return : Boolean; }
       
    calc def is_thread_group { in comp : Component; return : Boolean; }
    
    calc def is_virtual_processor { in comp : Component; return : Boolean; }
	
	comment /* probably needs to be more general */
    calc def member { in elm; in set : Collections::Set; return : Boolean; }
    
    calc def name { in comp : Component; return : String; }
   
	calc def parent { in comp : Component; return : Component; }

    calc def property { in comp : Component; in prop : String; return : String; } 
    
    comment /* effectively useless without ability to pass functions by name  */
    calc def ret_true { in _; return : Boolean; true } 
    
    constraint def resolint { in sys : System; }
    
    constraint run_analysis { in name : String; in tool : String; }
    
//    calc def security_requirements_satisfied_in_implementation { in sys; }
    
    calc def set_builder {
    	in input : Collections::Set;
    	in predicate;
    	in transform;
    	return : Collections::Set;
    }  
    
    calc def singleton { in input; return : Collections::Set; }
    
    calc def size { in coll : Collections::Collection; return : ScalarValues::Natural; }
    
    calc def source_component { in conn : Connection; return : Component; }
    
    calc def subcomponents { in comp : Component; return : Collections::Set; }
    
    calc def type { in comp : Component; return : String; }
    
    calc def union {
    	in s : Collections::Set; in t : Collections::Set;
    	return : Collections::Set;
    } 
    
    
    
    
}
