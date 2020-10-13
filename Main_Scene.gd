extends Control

var is_pressed = false

var button_press_duration = 2
var current_duration = 0

var demon_count = 0

var data = []

var filter_category

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	print("Loading Dataset!")
	var file = File.new()
	file.open("res://Dataset.json", File.READ)
	var lines = []
#	print(lines)
	while not file.eof_reached():
		var line = file.get_line()
		if line.strip_edges() == "":
			print("Empty line!")
			continue
		lines.append(line)
	file.close()
	data = lines
	
	fill_category_list()
#	print(lines)
#	$FileDialog.popup()
	pass # Replace with function body.

func fill_category_list():
	var categories = ["All"]
	
	for line in data:
		var category = line.split("#")[2]
		if not categories.has(category):
			categories.append(category)
	
	print("Categories: %s" % str(categories))
	
	var option_button = $VBoxContainer/Control/OptionButton
	var index = -1
	for category in categories:
		index += 1
		option_button.add_item(category)
		
		

func _process(delta):
	if not is_pressed:
		return
	current_duration += delta
	if current_duration >= button_press_duration:
		toggle_buttons()
		current_duration = 0
		is_pressed = false
	

func toggle_buttons():
	print("Buttons toggled!")
	var option_button = $VBoxContainer/Control/OptionButton
	option_button.visible = !option_button.visible
	
	var label = $VBoxContainer/Control/Label
	label.visible = !label.visible





func roll():
	var random = round(rand_range(0, data.size() - 1))
	print("Rolled: %d" % random) 
	var data_set  = data[random]
	var parts = data_set.split("#")
	var demon_name = parts[0]
	var color_hex = parts[1]
	var category = parts[2]
	if filter_category and not filter_category == "All":
		if category != filter_category:
			roll()
			return
	
	$VBoxContainer/Control/PanelContainer/Result_Label.text = demon_name
	$VBoxContainer/Control/PanelContainer/ColorRect.color = Color(color_hex)
	
	
#	demon_count+= 1
#	var characters = ""
#	for i in demon_count:
#		characters += "ä"
#	$VBoxContainer/Control/PanelContainer/Result_Label.text = "D%smon %d!" % [characters, demon_count]

#	print("Here a demon would be rolled")
#	var demon = get_random_demon()
#	print(demon)


func _on_PanelContainer_gui_input(event):
	
#	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
#		print("Roll")
#	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
#		print("Toggle Buttons")

	if Input.is_action_pressed("ui_touch"):
#		print("Touch Event")
	
#	if event is InputEventMouseButton and event.pressed:
		is_pressed = true
		print("Mouse touch!")
	if Input.is_action_just_released("ui_touch"):

#	if event is InputEventMouseButton and not event.pressed:
		if is_pressed:
			roll()
		is_pressed = false
		current_duration = 0
		print("Mouse released")	



func _on_Button_pressed():
	print("Pressing button from mobile")
	
	pass # Replace with function body.


func _on_OptionButton_item_selected(index):
	var element = $VBoxContainer/Control/OptionButton.get_item_text(index)
	filter_category = element
	print("category %s selected!" % element)
	pass # Replace with function body.
