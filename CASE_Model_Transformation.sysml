package CASE_Model_Transformation {
	private import AADL::*;
	private import Resolute::*;
	private import ScalarValues::String;
	
	part def CASE_RF_Msg;
	part def CASE_UART_Msg;
	
	#strategy constraint def add_filter { 
    	in comp_context : String; in afilter : String; in conn : String; in msg_type : String;
    	
    	part ctx : Component = ModelAccess::getComponent(comp_context);
    	part flt : Component = ModelAccess::getComponent(afilter);
    	part cnx : Connection = ModelAccess::getConnection(conn);
    	
    	filter_exists(flt, ctx, cnx) and component_not_bypassed(flt, ctx, msg_type) and
    	component_implemented(flt, "SPLAT")
    }
    
    #strategy constraint def add_attestation_manager {
        in comm_driver : String; in attestation_manager : String; in attestation_gate : String;
        
        comment /* getComponent was capitalized. Resolute doesn't care about capitalization? */
        part driver : Component = ModelAccess::getComponent(comm_driver);
        part manager : Component = ModelAccess::getComponent(attestation_manager);
        part gate : Component = ModelAccess::getComponent(attestation_gate);
        
        attestation_manager_exists(driver, manager) and 
        attestation_components_not_bypassed(driver, manager, gate) and
        component_implemented(manager, "attestation") and
        component_implemented(gate, "SPLAT")
    }
    
    #strategy  constraint def add_virtualization {
    	in bound_components : String; in virtual_machine : String;
    	
    	vm_comps : Collections::Set = ModelAccess::getComponentSet(bound_components);
    	vm : Component = ModelAccess::getComponent(virtual_machine);
    	
    	vm_bound_to_processor(vm) and 
    	components_bound_to_vm(vm_comps, vm) and 
    	subcomponents_not_bound_to_other_processors(vm_comps, vm)
    }
    
    #strategy constraint def add_monitor {
 		in comp_context : String; in monitor : String; in alert_port : String;
 		
 		ctx : Component = ModelAccess::getComponent(comp_context);
 		mon : Component = ModelAccess::getComponent(monitor);
		alert : Feature = ModelAccess::getPort(alert_port);
		
 		component_exists(mon, "CASE_Properties::Monitoring") and 
 		alert_connected(mon, alert) and
 		independent_reset(mon, ctx) and 
 		component_implemented(mon, "SPLAT")
 	}
 	
 	#strategy constraint def add_monitor_gate { 
 		in comp_context : String; in monitor : String; in alert_port : String; 
 		in gate_context : String; in message_type : String;
 		
 		ctx : Component = ModelAccess::getComponent(comp_context);
		mon : Component = ModelAccess::getComponent(monitor);
		alert : Feature = ModelAccess::getPort(alert_port);
		gate : Component = ModelAccess::getComponent(gate_context);
 		
 		component_exists(mon, "MONITOR") and 
 		alert_connected(mon) and 
 		independent_reset(mon, ctx) and 
 		component_not_bypassed(mon, gate, message_type) and 
 		component_implemented(mon)
 	}
 	
 	#strategy constraint def add_switch {
 		in comp_context : String; in switch : String; in message_type : String;
 		
 		ctx : Component = ModelAccess::getComponent(comp_context);
		gate : Component = ModelAccess::getComponent(switch);
		
		component_exists(gate, "CASE_Properties::Gating") and 
		component_not_bypassed(gate, ctx, message_type) and 
		component_implemented(gate, "SPLAT")
 	}
 	
 	#strategy constraint def sel4_transform { 
 		in comp_context : String;
		ctx : Component = ModelAccess::getComponent(comp_context);
		each_thread_in_separate_process(ctx)
	}
	
	comment /* SUB CLAIMS */
    
    #goal constraint def agree_property_checked {
        in c : String; in property_id : String;
        agree_passes_on_current_model(c, property_id) and confidence_in_agree_results()
        
    }
    
    #goal constraint def agree_passes_on_current_model {
    	in c : String; in property_id : String;
    	comp : Component = ModelAccess::getComponent(c);
    	
    	AgreeLib::hasAgreeProperty(comp, property_id) and 
    	run_analysis("AgreeCheck", type(parent(comp)))
    }
    
    calc def filter_exists {
    	in afilter : Component;	in comp_context : Component; in conn : Connection;
    	
    	filters : Collections::Set = recursive_backwards_filter_reach(singleton(comp_context));
		filter_parents : Collections::Set = set_builder();
		//{(component)parent(f) for (f : filters) | has_parent(f) and (parent(f) instanceof component) and has_mitigation_type((component)parent(f), CASE_Properties::Filtering)};
		all_filters : Collections::Set = union(filters, filter_parents);		
		has_mitigation_type(afilter, "CASE_Properties::Filtering") and 
		member(afilter, all_components()) and 
		exists(all_components(), {in c; is_source_component(conn,c)})
    }
    
   calc def recursive_backwards_filter_reach {
   	   in curr : Collections::Set;
   	   return : Collections::Set;
   	  
   	   p_reach : Collections::Set = set_builder(prev_reach(curr), {in c; has_mitigation_type(c, "CASE_Properties::Filtering")}, {in c; c}); 
	   prev : Collections::Set = union(curr, p_reach); 
	   if prev == curr ? curr else recursive_backwards_filter_reach(prev)
	}
	
	comment /* in AADL syntax no goal keyword but uses <= indicating its a requirement. Also property seemed to be indexed by int */
	#goal constraint def component_exists {
		in comp : Component; in mitigation_type : String;
			
		has_mitigation_type(comp, mitigation_type) and exists(all_components(), {in x; x == comp})
	}
	
    #goal constraint def component_not_bypassed {
    	in comp : Component; in comp_context : Component; in msg_type : String;
    	comp_srcs : Collections::Set = get_filter_sources(comp_context, comp, msg_type);
    	non_comp_srcs : Collections::Set = get_non_filter_sources(comp_context, comp, msg_type);
    	size(intersect(comp_srcs, non_comp_srcs)) == 0
    }
      
    #goal constraint def component_implemented {
    	in comp : Component; in tool : String;
    	implementation_language_assurance(comp) and
    	component_proof_checked(comp, tool)
    }
    
    #goal constraint def component_proof_checked {
    	in comp : Component; in tool : String;
		is_seL4_component(comp) implies run_analysis("ToolCheck", tool)
	}
	
	comment /* mitigation_type is a property name in AADL  */
	calc def has_mitigation_type {
		in comp : Component; in mitigation_type : String; return : ScalarValues::Boolean;
		has_property(comp, mitigation_type) and property(comp, mitigation_type) == 100
	}
	
	calc def is_comm_driver {
		in comp: Component; return: ScalarValues::Boolean;
		has_property(comp, "CASE_Properties::Comm_Driver") and property(comp, "CASE_Properties::Comm_Driver") == true
	}
	
	calc def get_non_filter_sources {
		in target : Component; in flter : Component; in msg_type : String; return : Collections::Set;
		srcs : Collections::Set = set_builder(
				set_builder(connections(target), {in conn; has_type(conn) and type(conn) == msg_type and not is_source_component(conn, flter) and not is_source_component(conn,target)}, {in x; x}),
				{in x; true},
				{in x; source_component(x)});
		//{c for (conn : connections(target)) (c : source_component(conn)) | has_type(conn) and type(conn) = msg_type and not is_source_component(conn, filter) and not is_source_component(conn, target)}; 
		recursive_backwards_reach(srcs)
	}
	
	calc def get_filter_sources {
		in target : Component; in flter : Component; in msg_type : String; return : Collections::Set;
		srcs : Collections::Set = set_builder(
			set_builder(connections(target), {in conn; has_type(conn) and type(conn) == msg_type and is_source_component(conn, flter)}, {in x; x}),
			{in x; true},
			{in x; source_component(x)});
			// {c for (conn : connections(target)) (c : source_component(conn)) | has_type(conn) and type(conn) = msg_type and is_source_component(conn, filter)};
			prev_reach(srcs)
	}
	
	calc def recursive_backwards_reach {
		in curr : Collections::Set; return : Collections::Set;
		prev : Collections::Set = union(curr, prev_reach(curr));
		if prev == curr ? curr else recursive_backwards_reach(prev)
	}
	
	calc def prev_reach {
		in curr : Collections::Set; return : Collections::Set;
		flatten(set_builder(curr, {in x; true}, {in x; backwards_reachable_components(x)}))
		//{y for (x : curr) (y : backwards_reachable_components(x))}		
	}
	
	calc def backwards_reachable_components {
		in comp : Component; return : Collections::Set;
		flatten(set_builder(connections(comp), {in x; true}, {in conn; backwards_reachable_components_via_connection(comp, conn)}))
	}
	
	calc def backwards_reachable_components_via_connection {
		in comp : Component; in conn : Connection; return : Collections::Set;
		if is_port_connection(conn) and is_destination_component(conn, comp) and not is_source_component(conn, comp) ?
			singleton(source_component(conn))
		else
			empty_set()
	}
	
	comment /* Again not marked as a goal but uses <= */
    #goal constraint def attestation_manager_exists {
    	in comm_driver : Component;	in attestation_manager : Component;
    	is_comm_driver(comm_driver) and has_mitigation_type(attestation_manager, "CASE_Properties::Attesting")
    }
    
    #goal constraint def attestation_components_not_bypassed {
    	in comm_driver : Component;	in attestation_manager : Component; in attestation_gate : Component;
    	
    	out_conns : Collections::Set = set_builder(connections(comm_driver), {in conn; source_component(conn) == comm_driver and not (destination_component(conn) == parent(comm_driver))});
    	forall({in conn :> out_conns; (not is_software_component(destination_component(conn))) or 
    								has_mitigation_type(destination_component(conn), "CASE_Properties::Attesting") or has_mitigation_type(destination_component(conn), "CASE_Properties::Gating")})
    								
    	
    }
    
    #goal constraint def vm_bound_to_processor {
    	in virtual_machine : Component;
    	has_mitigation_type(virtual_machine, "CASE_Properties::Isolating") and exists(all_processors(), {in p; is_bound_to(virtual_machine, p) })
    }
    
    #goal constraint def components_bound_to_vm {
     	in bound_components : Collections::Set; in virtual_machine : Component;
     	forall(bound_components, {in c; check_vm_binding(c, virtual_machine)})
    }
 
 	#goal constraint def check_vm_binding {
 		in c : Component; in virtual_machine : Component;
 		is_bound_to(c, virtual_machine)
 	}
 	
 	
 	#goal constraint def subcomponents_not_bound_to_other_processors {
 		in bound_components : Collections::Set; in virtual_machine : Component;
 		subs : Collections::Set = get_subcomponents(next_subcomponent(bound_components));
 		forall(subs, {in s; not exists(all_components(), {in v; is_bound_to_processor(s, v) and not (v == virtual_machine)})})
 	}
 	
 	calc def get_subcomponents {
 		in curr : Collections::Set; return : Collections::Set;
 		next : Collections::Set = union(curr, next_subcomponent(curr));
 		if next == curr ?
 			curr
 		else
 			get_subcomponents(next)
 	}
 	
 	calc def next_subcomponent {
 		in curr : Collections::Set; return : Collections::Set;
 		flatten(set_builder(curr, {in x; true}, {in x; subcomponents(x)}))
 	}
 	
 	#goal constraint def implementation_language_assurance {
 		in comp : Component;
 		is_seL4_component(comp) implies is_cakeml_component(comp)
 	}
 	
 	calc def is_cakeml_component {
 		in comp : Component; return : ScalarValues::Boolean;
 		if is_thread(comp) ? has_property(comp, "CASE_Properties::Component_Language") and property(comp, "CASE_Properties::Component_Language") == "CakeML"
 		else if is_process(comp) ? size(subcomponents(comp)) > 0 and forall(subcomponents(comp), {in s; is_cakeml_component(s)})
 		else false
 	}
 	
 	calc def is_seL4_component {
 		in comp : Component; return : ScalarValues::Boolean;
 		proc : Collections::Set = set_builder(singleton(comp), {in c; is_bound_to_processor(comp, c)}, {in x;x});
 		size(proc) > 0 and forall(proc, {in p; has_property(p, "CASE_Properties::OS") and property(p, "CASE_Properties::OS") == "seL4"})
 	}
 	
 	calc def is_bound_to_processor {
 		in c : Component; in p : Component; return : ScalarValues::Boolean;
 		is_bound_to(c, p) and (is_processor(p) or is_virtual_processor(p))
 	}
 	
 	#goal constraint def alert_connected {
 		in monitor : Component; in alert_port : Feature;
 		contained(alert_port, monitor) and size(connections(alert_port)) > 0 // size is length in the original spec
 	}
 	
 	#goal constraint def independent_reset {
 		in monitor : Component; in comp_context : Component;
 		reset_ancestors : Collections::Set = flatten(set_builder(
 			set_builder(connections(monitor), 
 				{in conn; destination_component(conn) == monitor and name(destination(conn)) == "Reset"}, 
 				{in x; x}
 			),
 			{in x; true},
 			{in conn; recursive_backwards_reach(singleton(source_component(conn)))}));
 		size(intersect(reset_ancestors, singleton(comp_context))) == 0
 	}
 	
 	calc def is_software_component {
 		in comp : Component; return : ScalarValues::Boolean;
 		is_process(comp) or is_thread_group(comp) or is_thread(comp)
 	}
 	
 	calc def is_high_assurance_component {
 		in comp : Component; return : ScalarValues::Boolean;
 		has_mitigation_type(comp, "CASE_Properties::Filtering") or 
 		has_mitigation_type(comp, "CASE_Properties::Monitoring") or 
 		has_mitigation_type(comp, "CASE_Properties::Gating")
 	}
 	
 	#goal constraint def each_thread_in_separate_process {
 		in root : Component;
 		comps : Collections::Set = get_subcomponents(singleton(root));
 		forall(comps, {in c; (is_system(c) or is_thread(c) or is_process(c)) and is_process(c) implies (size(subcomponents(c)) == 1 and is_thread(head(as_list(subcomponents(c)))))})
 	}
    
    
}