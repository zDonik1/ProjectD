class_name IntegTest
extends GutTest

########################
# ---- UTILITIES ----- #
########################


func add_sub_scene_tree_as_child() -> SubSceneTree:
	return add_child_autofree(SubSceneTree.new())
