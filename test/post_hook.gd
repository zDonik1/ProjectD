extends GutHookScript

func run():
	if gut.get_summary().get_totals().risky > 0:
		Logger.error("Risky tests found")
		set_exit_code(1)
	
	if gut.get_orphan_counter().get_counter("total") > 0:
		Logger.error("Orphans created during test")
		set_exit_code(1)