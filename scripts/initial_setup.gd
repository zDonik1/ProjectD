extends Node

func _init():
	if OS.has_environment("PROJECT_D_LOG_LEVEL"):
		Logger.set_logger_level(Logger._get_logger_level_by_name(OS.get_environment("PROJECT_D_LOG_LEVEL")))
		
	if OS.has_environment("PROJECT_D_LOG_FORMAT"):
		Logger.set_logger_format(Logger._get_logger_format_by_name(OS.get_environment("PROJECT_D_LOG_FORMAT")))
