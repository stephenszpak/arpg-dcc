extends CanvasLayer

@onready var chat_log = get_node_or_null("ChatLog")
@onready var chat_input = get_node_or_null("ChatInput")

func add_chat_message(msg:String):
    if chat_log:
        chat_log.add_text(msg + "\n")

func _on_chat_input_text_submitted(text):
    add_chat_message("You: " + text)
    chat_input.text = ""
    if get_node("../NetworkManager"):
        get_node("../NetworkManager").send_chat(text)
