extends ItemList


func get_item_names():
	var result = []
	for i in range(get_item_count()):
		result.append(get_item_text(i))
	return result


func set_item_names(names):
	clear()
	for name in names:
		add_item(name)
