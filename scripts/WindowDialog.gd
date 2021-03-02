extends WindowDialog

var words = []

func addWords(noOfWords):
	for i in noOfWords:
		var wordInstance = $VBoxContainer/MarginContainer/HBoxContainer/Words1.duplicate()
		get_node("VBoxContainer/MarginContainer/HBoxContainer").add_child_below_node($VBoxContainer/MarginContainer/HBoxContainer/Words1,wordInstance)
		wordInstance.add_to_group("WordsGroup")

func sendAddtlWords():
	print(get_children())
	for member in get_tree().get_nodes_in_group("WordsGroup"):
		words.append(member.get_text())
		
