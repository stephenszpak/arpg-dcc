extends Node

var udp := PacketPeerUDP.new()
var ws := WebSocketPeer.new()
var player_id: int = 0
var player_ref: Node = null
var last_send_pos: Vector3
var zone_id: int = 1
var ref_counter: int = 0

signal ws_event(data)

func _ready():
	udp.connect_to_host("127.0.0.1", 4000)
	ws.connect_to_url("ws://localhost:4000/socket")
	last_send_pos = Vector3.ZERO
	set_physics_process(true)

func register_player(p):
	player_ref = p
	last_send_pos = p.global_transform.origin

func send_movement(delta_pos: Vector3):
	var dx = clamp(delta_pos.x, -5.0, 5.0)
	var dy = clamp(delta_pos.y, -5.0, 5.0)
	var dz = clamp(delta_pos.z, -5.0, 5.0)
	var pkt := PackedByteArray()
	pkt.append_u32(player_id)
	pkt.append_u16(1)
	pkt.append_float(dx)
	pkt.append_float(dy)
	pkt.append_float(dz)
	udp.put_packet(pkt)
	last_send_pos = player_ref.global_transform.origin

func send_chat(text:String):
	var msg = {
		"topic": "chat:global",
		"event": "new_msg",
		"payload": {"body": text},
		"ref": str(ref_counter)
	}
	ref_counter += 1
	ws.send_text(JSON.stringify(msg))

func _physics_process(delta):
	if ws.get_ready_state() == WebSocketPeer.STATE_CONNECTING:
		ws.poll()
	elif ws.get_ready_state() == WebSocketPeer.STATE_OPEN:
		ws.poll()
		while ws.get_available_packet_count() > 0:
			var msg = ws.get_packet().get_string_from_utf8()
			_handle_ws_message(msg)
	elif ws.get_ready_state() == WebSocketPeer.STATE_CLOSED:
		pass

func _handle_ws_message(msg:String):
	var data = JSON.parse_string(msg)
	if typeof(data) == TYPE_DICTIONARY:
		emit_signal("ws_event", data)
