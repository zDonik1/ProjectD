class_name SubSceneTree extends Node

var st


func make_scene_tree():
	return SceneTree.new()


func _ready():
	st = make_scene_tree()
	st.init()


func _process(delta):
	st.idle(delta)


func _exit_tree():
	st.finish()
