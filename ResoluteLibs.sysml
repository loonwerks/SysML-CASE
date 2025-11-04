package ResoluteLibs {
	private import AADL::*;
	private import Resolute;
	package AgreeLib {
		constraint def hasAgreeProperty {
			in c : Component;
			in prop_id : ScalarValues::String;
		}
	}
	
	package BriefCASE {
		constraint def security_requirements_review;
		constraint def security_requirements_imported_or_omitted_with_rationale;
		constraint def security_analysis_performed_on_current_model;
		constraint def security_analysis_produces_no_applicable_requirements;
		constraint def agree_results_review;
		constraint def requirements_stated_in_terms_of_interface { in comp : Component; }
		constraint def tool_generated_apis_correctly_derived_from_model { in comp : Component; }
		constraint def application_code_uses_tool_generated_apis { in comp: Component; }
		constraint def library_usage_has_no_effect_outside_of_component_boundary { in comp : Component; }
		constraint def application_code_runs_to_completion { in comp : Component; }
		constraint def component_output_satisfies_contract_on_every_dispatch { in comp : Component; }
		constraint def component_output_satisfies_information_flow_specifications_on_every_dispatch {
			in comp : Component;
		}		
		constraint def component_execution_time_conforms_to_specified_wcet_on_every_dispatch {
			in comp : Component;
		}		
		constraint def component_infrastructure_code_satisfies_aadl_semantics {
			in comp : Component;
		}		
		constraint def identifiable_component_platform_deployment {
			in comp : Component;
		}		
		constraint def application_infrastructure_deployment_interface_identification {
			in comp : Component;
		}		
		constraint def port_correspondence_traceability {
			in comp : Component;
		}
		constraint def component_dispatch {
			in comp : Component;
		}
		constraint def infrastructure_application_non_interference {
			in comp : Component;
		}
		constraint def specified_information_flow_directionality_enforced_by_deployment {
			in comp : Component;
		}
		constraint def deployed_component_satisfies_functional_requirements {
			in comp : Component;
		}
		constraint def deployed_component_satisfies_intra_component_flows {
			in comp : Component;
		}
		constraint def platform_components_guarantee_required_properties { in sys : System; }
		constraint def system_implementation_satisfies_security_requirements { in sys : System; }
	}
	
	package ModelAccess {
		private import ScalarValues::String;
		
		calc def getComponent {
			in str : ScalarValues::String;
			return : Component;
		}
		
		calc def getConnection {
			in str : ScalarValues::String;
			return : Connection;
		}
		
		calc def getComponentSet {
			in str : String;
			return : Collections::Set;
		}
		
		calc def getPort {
			in str : String;
			return : Feature;
		}
	}
	
}