package CASE_Modeling_Guidelines {
	private import Resolute::*;
	private import Collections::Set;
	private import ScalarValues::Boolean;
	
	comment /* FAKE */
	calc def lint_check { in x; in y; }
	calc def lint_check_set {in x; in xs; }
	
	comment /* INCOMPLETE */
	#rule constraint def one_process {
		procs : Set = 
			set_builder(
				all_processes(), 
				{in p; exists(all_processes(), {in pr; is_bound_to(p, pr)})},
				{in p; p});
		size(procs) > 0
	}
	
	#rule constraint def one_thread {
		procs : Set = 
			set_builder(
				all_processes(), 
				{in p; size(subcomponents(p))  > 1 and 
					exists(all_processes(), 
						{in pr; is_seL4_processor(pr) and
							is_bound_to(p, pr)})},
				{in p; p});
		lint_check_set(procs, size(procs) == 0)
	}
	
	#rule constraint def modes_ignored {
		forall(all_components(), {in c; lint_check(c, not has_modes(c))})
	}
	
	#rule constraint def flows_ignored {
		forall(all_components(), 
			{in c; lint_check(c, not (size(flow_specifications(c)) + size(end_to_end_flows(c)) > 0))})
	}
	
	#rule constraint def thread_groups_ignored {
		forall(all_components(), {in c; lint_check(c, not is_thread_group(c))})
	}
	
	#rule constraint def dispatch_protocol_specified {
		forall(all_threads(), {in t; lint_check(t, has_property(t, "Thread_Properties::Dispatch_Protocol"))})
	}
	
	#rule constraint def valid_dispatch_protocol {
		forall(all_threads(),
			{in t; lint_check(t, has_property(t, "Thread_Properties::Dispatch_Protocol")) implies 
				property(t, "Thread_Properties::Dispatch_Protocol") == "Sporadic" or property(t, "Thread_Properties::Dispatch_Protocol") == "Periodic"
			}
		)	 
	}
	
	comment /* INCOMPLETE */
	#ruleset package HAMR_Guidelines {
		#error constraint : one_process;
		#warning constraint : thread_groups_ignored;
		
	}
}