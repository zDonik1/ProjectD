extends GutHookScript

func run():
	if gut.get_summary().get_totals().risky > 0:
		Logger.error("Risky tests found")
		set_exit_code(1)