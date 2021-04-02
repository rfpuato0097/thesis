extends Node


func _on_TimerNode_timeout():
	Client.send_data("PING!")
