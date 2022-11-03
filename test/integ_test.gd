class_name IntegTest
extends GutTest


########################
# ---- UTILITIES ----- #
########################


const MainScene := preload("res://scenes/main.tscn")


func add_sub_scene_tree_as_child() -> SubSceneTree:
	return add_child_autofree(SubSceneTree.new())


func instantiate_server_with_name(name: String) -> Node:
	return _make_main_with_player_name_and_call_signal_on_main(
		name, "create_server_pressed"
	)


func instantiate_client_with_name(name: String) -> Node:
	return _make_main_with_player_name_and_call_signal_on_main(
		name, "join_server_pressed"
	)


func make_main_in_sub_st(sub_st: SubSceneTree) -> Node:
	var main := MainScene.instance()
	sub_st.st.root.add_child(main)
	return main


func _make_main_with_player_name_and_call_signal_on_main(
	name: String, signal_name: String
) -> Node:
	var main := make_main_in_sub_st(add_sub_scene_tree_as_child())
	main.get_node("MainMenu").player_name = name
	main.get_node("MainMenu").emit_signal(signal_name)
	return main