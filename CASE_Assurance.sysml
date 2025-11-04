package CASE_Assurance {
	private import AADL::*;
	private import Resolute::*;
	private import ResoluteLibs::*;
	
	#goal constraint def security_requirements_complete {
		in sys : System;
		security_requirements_reviewed() and 
		security_requirements_imported_or_omitted_with_rationale() and 
		security_analysis_performed(sys)
	}
	
	#goal constraint def security_requirements_reviewed {
		BriefCASE::security_requirements_review()
	}
	
	#goal constraint def security_requirements_imported_or_omitted_with_rationale {
		BriefCASE::security_requirements_imported_or_omitted_with_rationale()
	}

	#goal constraint def security_analysis_performed {
		in sys : System;
		model_complies_with_guidelines(sys) and 
		security_analysis_performed_on_current_model() and 
		security_analysis_produces_no_applicable_requirements()
	}
	
	#goal constraint def model_complies_with_guidelines { 
		in sys : System;
		resolint(sys)
	}
		
	#goal constraint def security_analysis_performed_on_current_model {
		BriefCASE::security_analysis_performed_on_current_model()
	}
	
	#goal constraint def security_analysis_produces_no_applicable_requirements {
		BriefCASE::security_analysis_produces_no_applicable_requirements()
	}
	
	#goal constraint def confidence_in_agree_results {
		BriefCASE::agree_results_review()
	} 
	
	#goal constraint def security_requirements_satisfied_in_implementation {
		in sys : System;
		
		deployed_sw_components_satisfy_requirements(sys) and 
		platform_components_guarantee_required_properties(sys) and 
		system_implementation_satisfies_security_requirements(sys)
	}
	
	comment /* DEFINITION OF INTEREST - FORALL */
	#goal constraint def  deployed_sw_components_satisfy_requirements {
		in sys : System;
		attribute subcomponents = set_builder();
		calc lambda {
			in comp;
			deployed_sw_component_satisfies_requirements(comp)
		}	
		forall(subcomponents, lambda)
	}
		
	#goal constraint def deployed_sw_component_satisfies_requirements {
		in comp : Component;
		requirements_stated_in_terms_of_interface(comp) and 
		application_code_conforms_to_interface_and_requirements(comp) and 
		component_infrastructure_code_satisfies_aadl_semantics(comp) and 
		component_deployment_context_achieves_required_assurance_properties(comp)
	}
	
	#goal constraint def requirements_stated_in_terms_of_interface {
		in comp : Component;
		BriefCASE::requirements_stated_in_terms_of_interface(comp)
	}
	
	#goal constraint def application_code_conforms_to_interface_and_requirements {
		in comp : Component;
		application_code_exclusively_uses_interface_apis(comp) and 
		application_code_runs_to_completion(comp) and 
		component_output_satisfies_contract_on_every_dispatch(comp) and
		((size(flow_specifications(comp)) > 0 or size(end_to_end_flows(comp)) > 0) implies
			 component_output_satisfies_information_flow_specifications_on_every_dispatch(comp)) and
		component_execution_time_conforms_to_specified_wcet_on_every_dispatch(comp)
	}
	
	#goal constraint def application_code_exclusively_uses_interface_apis {
		in comp : Component;
			tool_generated_apis_correctly_derived_from_model(comp) and
			application_code_uses_tool_generated_apis(comp) and
			library_usage_has_no_effect_outside_of_component_boundary(comp)	
	}
	
	#goal constraint def tool_generated_apis_correctly_derived_from_model {
		in comp : Component;
		BriefCASE::tool_generated_apis_correctly_derived_from_model(comp)
	}
	
	#goal constraint def application_code_uses_tool_generated_apis {
		in comp : Component;
		BriefCASE::application_code_uses_tool_generated_apis(comp)
	}
	
	#goal constraint def library_usage_has_no_effect_outside_of_component_boundary {
		in comp : Component;
		BriefCASE::library_usage_has_no_effect_outside_of_component_boundary(comp)
	}
	
	#goal constraint def application_code_runs_to_completion {
		in comp : Component;
		BriefCASE::application_code_runs_to_completion(comp)
	}

	#goal constraint def component_output_satisfies_contract_on_every_dispatch {
		in comp : Component;
		BriefCASE::component_output_satisfies_contract_on_every_dispatch(comp)
	}
	
	#goal constraint def component_output_satisfies_information_flow_specifications_on_every_dispatch {
		in comp : Component;
		BriefCASE::component_output_satisfies_information_flow_specifications_on_every_dispatch(comp)
	}
	
	#goal constraint def component_execution_time_conforms_to_specified_wcet_on_every_dispatch {
		in comp : Component;
		BriefCASE::component_execution_time_conforms_to_specified_wcet_on_every_dispatch(comp)
	}
	
	#goal constraint def component_infrastructure_code_satisfies_aadl_semantics {
		in comp : Component;
		BriefCASE::component_infrastructure_code_satisfies_aadl_semantics(comp)
	}
	
	#goal constraint def component_deployment_context_achieves_required_assurance_properties {
		in comp : Component;
		identifiable_component_platform_deployment(comp) and
		application_infrastructure_deployment_interface_identification(comp) and
		port_correspondence_traceability(comp) and
		component_dispatch(comp) and
		infrastructure_application_non_interference(comp) and
		specified_information_flow_directionality_enforced_by_deployment(comp) and
		deployed_component_satisfies_functional_requirements(comp) and
		(size(flow_specifications(comp)) > 0 or size(end_to_end_flows(comp)) > 0) implies deployed_component_satisfies_intra_component_flows(comp)
	}
	
	#goal constraint def identifiable_component_platform_deployment {
		in comp : Component;
		BriefCASE::identifiable_component_platform_deployment(comp)
	}
	
	#goal constraint def application_infrastructure_deployment_interface_identification {
		in comp : Component;
		BriefCASE::application_infrastructure_deployment_interface_identification(comp)
	}
	
	#goal constraint def port_correspondence_traceability {
		in comp : Component;
		BriefCASE::port_correspondence_traceability(comp)
	}
	
	#goal constraint def component_dispatch {
		in comp : Component;
		BriefCASE::component_dispatch(comp)
	}
	
	#goal constraint def infrastructure_application_non_interference {
		in comp : Component;
		BriefCASE::infrastructure_application_non_interference(comp)
	}
	
	#goal constraint def specified_information_flow_directionality_enforced_by_deployment {
		in comp : Component;
		BriefCASE::specified_information_flow_directionality_enforced_by_deployment(comp)
	}
	
	#goal constraint def deployed_component_satisfies_functional_requirements {
		in comp : Component;
		BriefCASE::deployed_component_satisfies_functional_requirements(comp)
	}
	
	#goal constraint def deployed_component_satisfies_intra_component_flows {
		in comp : Component;
		BriefCASE::deployed_component_satisfies_intra_component_flows(comp)
	}
	
	#goal constraint def platform_components_guarantee_required_properties {
		in sys : System;
		BriefCASE::platform_components_guarantee_required_properties(sys)
	}
	
	#goal constraint def system_implementation_satisfies_security_requirements {
		in sys : System;
		BriefCASE::system_implementation_satisfies_security_requirements(sys)
	}
			
}