extends Node2D

var countPosY = {'1':0,'2':0,'3':0,'4':0,'5':0,'6':0,'7':0,'8':0,'9':0,'10':0,
						'11':0,'12':0,'13':0,'14':0,'15':0,'16':0,'17':0,'18':0,'19':0,'20':0}
var allChildrenPosY = [] # Ini berisi seluruh posisi Y area2D

func _update_all_children_pos():
#	Fungsi ini mengisi var allChildrenPosY dengan semua posisi Y yang terisi Piece
	allChildrenPosY = []
	for i in get_children():
		if i is Node2D and i.active == false: 
			for j in i.children_pos.values():
				allChildrenPosY.append(j[1])
	
func _update_has_pos_y():
#	Fungsi ini menghitung posisi y dari 1 - 20 masing-masing punya berapa Piece
	for i in countPosY:
		var count = 0
		for j in allChildrenPosY:
			if int(i) == j:
				count += 1
		countPosY[i] = count

func _boom():
	_update_all_children_pos()
	_update_has_pos_y()
	for i in countPosY:
		if countPosY[i] >= 3:
#			Kita kirim ke children y berapa saja yang akan meledak
			for j in get_children():
				if j is Node2D:
					j._destroy(int(i))
		


		
		

