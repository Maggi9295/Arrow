# Arrow
# Game Narrative Design Tool
# Mor. H. Golkar

# Jump Graph Node
extends GraphNode

@onready var Main = get_tree().get_root().get_child(0)

@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE") var _node_id
@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE") var _node_resource

var This = self

@onready var Destination = $Display/Destination
@onready var Description = $Display/Description

const DESTINATION_FORMAT_STRING = (
	"{target_name}" if Settings.FORCE_UNIQUE_NAMES_FOR_NODES else "{target_name} ({target_uid})"
)
const UNSET_SCENE_NAME = "SCENE_NODE_UNSET_SCENE_NAME" # Translated ~ "Unset"
const UNSET_DESCRIPTION_MESSAGE = "SCENE_NODE_UNSET_DESCRIPTION_MSG" # Translated ~ "No Reason"
const HIDE_DESCRIPTION_IF_UNSET = true

#func _ready() -> void:
#	register_connections()
#	pass

#func register_connections() -> void:
#	# e.g. SOME_CHILD.connect("the_signal", self, "the_handler_on_self", [], CONNECT_DEFERRED)
#	pass

func _gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.is_double_click():
			if event.is_alt_pressed() == true:
				if _node_resource.has("data"):
					var data = _node_resource.data
					if data.has("target") && (data.target is int) && data.target >= 0:
						Main.Mind.call_deferred("locate_node_on_grid", data.target)
	pass

func _update_node(data:Dictionary) -> void:
	var destination = { "target_name": UNSET_SCENE_NAME, "target_uid": "-1" }
	if data.has("scene") && (data.scene is int) && data.scene >= 0:
		destination.target_uid = data.scene
		var target_scene = Main.Mind.lookup_resource(data.scene, "scenes")
		if (target_scene is Dictionary) && target_scene.has("name") && (target_scene.name is String):
			destination.target_name = target_scene.name
	Destination.set_deferred("text", DESTINATION_FORMAT_STRING.format(destination))
	if data.has("description") && (data.description is String) && data.description.length() > 0:
		Description.set_deferred("text", data.description)
		Description.set_deferred("visible", true)
	else:
		Description.set_deferred("text", UNSET_DESCRIPTION_MESSAGE)
		Description.set_deferred("visible", (!HIDE_DESCRIPTION_IF_UNSET))
	pass
