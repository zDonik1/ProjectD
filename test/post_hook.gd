extends GutHookScript

func run():
	if gut.get_summary().get_totals().risky > 0:
		Logger.error("Risky tests found", "TEST_CHECK")
		set_exit_code(1)
	
	if gut.get_orphan_counter().get_counter("total") > 0:
		Logger.error("Orphans created during test", "TEST_CHECK")
		set_exit_code(1)

	if gut.get_logger().get_warnings().size() > 0:
		Logger.error("Warnings issued", "TEST_CHECK")
		set_exit_code(1)

	if gut.get_logger().get_errors().size() > 0:
		Logger.error("Erors issued", "TEST_CHECK")
		set_exit_code(1)