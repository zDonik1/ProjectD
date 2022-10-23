extends Node

func _init():
	if OS.has_environment("PROJECT_D_LOG_LEVEL"):
		Logger.set_logger_level(Logger._get_logger_level_by_name(OS.get_environment("PROJECT_D_LOG_LEVEL")))
		
	if OS.has_environment("PROJECT_D_LOG_FORMAT"):
		Logger.set_logger_format(Logger._get_logger_format_by_name(OS.get_environment("PROJECT_D_LOG_FORMAT")))
		
	if OS.has_environment("PROJECT_D_ONLY_FILE_LOGGER"):
		Logger.logger_appenders.clear()
		Logger.add_appender(FileAppender.new("user://logs/log.txt"))
