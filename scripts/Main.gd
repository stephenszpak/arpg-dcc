extends Node

# Entry point for world scene. Sets up connections if needed.

func _ready():
    # Example: connect player movement to network manager
    var network = $NetworkManager
    var player = $Player
    network.player_id = 1 # placeholder until login
    network.register_player(player)
