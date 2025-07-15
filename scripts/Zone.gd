extends Node

var entities := {}
var idle_timeout := 2.0

func spawn_entity(id: int):
    var npc := CharacterBody3D.new()
    add_child(npc)
    entities[id] = {"node": npc, "last_move": Time.get_ticks_msec()/1000.0}

func remove_entity(id:int):
    if entities.has(id):
        entities[id]["node"].queue_free()
        entities.erase(id)

func move_entity(id:int, pos:Vector3):
    if entities.has(id):
        var info = entities[id]
        info["node"].global_transform.origin = info["node"].global_transform.origin.lerp(pos, 0.25)
        info["last_move"] = Time.get_ticks_msec()/1000.0

func _process(delta):
    var t = Time.get_ticks_msec()/1000.0
    for id in entities.keys():
        var info = entities[id]
        if t - info["last_move"] > idle_timeout:
            # TODO: play idle animation
            pass
