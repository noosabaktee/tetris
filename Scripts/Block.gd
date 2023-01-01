extends Node2D

var children_pos = {}
var active = true
var second = 1.0
var _timer = null
var isRight = false
var isLeft = false
var rotate = 0
export var type = ""

func _ready():
	_move()
		
func _input(event):
	_update_children_post()
	_check_is_border()
	if active:
		if event.is_action_pressed("ui_right") and !isRight:
			self.position.x += 30
		elif event.is_action_pressed("ui_left") and !isLeft:
			self.position.x -= 30
		elif event.is_action("ui_down"):
			self.position.y += 30
		elif event.is_action_pressed("ui_up"):
#			Jika type adalah "I" dan posisi berada di ujung
			if type == "I":
#				Jika posisi center tidak berada di ujung atau tidak ada block tepat disampping center maka boleh rotate 
				if !((children_pos["Center"][0] == 1 or _there_is("Left")) or children_pos["Center"][0] == 10 or _there_is("Right")):
#					Jika posisi center ada diatas dan posisi center ada di satu sebelum ujung kiri
					if self.rotation_degrees == 90 and (children_pos["Center"][0] == 2 or _there_is("Left",2)):
							self.position.x += 30
#					Jika posisi center ada dibawah dan posisi center ada di satu sebelum ujung kanan
					elif self.rotation_degrees == 270 and (children_pos["Center"][0] == 9 or _there_is("Right",2)):
							self.position.x -= 30
					
					rotate += fmod(90,360)				
						
			else:
	#			Jika posisi center berada di ujung atau ada block tepat disamping center
				if children_pos["Center"][0] == 1 or _there_is("Left"):
					self.position.x += 30
				elif children_pos["Center"][0] == 10  or _there_is("Right"):
					self.position.x -= 30
				rotate += fmod(90,360)
				
			if rotate > 360:
				rotate -= 360
			self.rotation_degrees = rotate
			
	
func _move():		
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_go_down")
	_timer.set_wait_time(second)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	
func _go_down():
	if active:
		self.position.y += 30
	_update_children_post()
	_check_is_border()
	
func _update_children_post():
	children_pos = {}
	for i in get_children():
		if i is Node2D:
			var pos = [(round(i.global_position.x) - 15) / 30 + 1, (round(i.global_position.y) - 15) / 30 + 1]
			children_pos[i.name] = pos
				
#	Fungsi ini memberi tahu kita bahwa ada block tepat disamping center
#	Agar kita menggeser ketika melakukan rotate
func _there_is(param,distance = 1):
	var allChildrenPos = []
	for i in get_parent().get_children():
		if i is Node2D and i.active == false and i != self: 
			for j in i.children_pos.values():
				allChildrenPos.append(j)
	if param == "Bottom":
		if allChildrenPos.has([children_pos["Center"][0],children_pos["Center"][1] + distance]):
			return true
	elif param == "Left":
		if allChildrenPos.has([children_pos["Center"][0] - distance,children_pos["Center"][1]]):
			return true
	elif param == "Right":
		if allChildrenPos.has([children_pos["Center"][0] + distance,children_pos["Center"][1]]):
			return true
			
func _check_is_border():
	isLeft = false
	isRight = false
	var allChildrenPos = []
	for i in get_parent().get_children():
		if i is Node2D and i.active == false and i != self: 
			for j in i.children_pos.values():
				allChildrenPos.append(j)
	for i in children_pos.values():
#		Jika di kiri sudah mentok atau ada block
		if i[0] == 1 or allChildrenPos.has([i[0] - 1, i[1]]):
			isLeft = true
#		Jika di kanan sudah mentok atau ada block
		if i[0] == 10 or allChildrenPos.has([i[0] + 1, i[1]]):
			isRight = true
#		Jika di bawah sudah mentok atau ada block		
		if i[1] >= 20 or allChildrenPos.has([i[0], i[1] + 1]) and active == true:
			active = false
			get_parent()._boom()
		
func _destroy(y):
#	Disini kita akan menghapus Piece yang memiliki y = y (param)
	for i in children_pos:
		if children_pos[i][1] == y:
#			hapus area
			get_node(i).queue_free()
#	Ubah secondnya agar cepat turun dan panggil fungsi move agar turun
	self.second = 0.001
	self._move()
	_update_children_post()
