extends Node2D

# Jika parent sudah tidak aktif atau active == false maka piece hidup masing-masing
# Tapi hidup masing-masing di daerah parentnya 
# Artinya jika saudara dibawahnya mati dia boleh turun 
# Tapi tidak boleh turun menyamai atau bahkan melewati saudara dibawahnya yang belum mati
# Pokonya jika benar-benar kosong piece dibawahnya maka boleh turun
# Jika masih ada, walaupun bukan tepat dibawahnya maka tidak boleh turun 
func _process(delta):
	_down()

func _down():
	if !get_parent().active:
		var childrenPosValue = get_parent().children_pos.values() # Just this parent children pos 
		var yValues = []
		for i in childrenPosValue:
			yValues.append(i[1])
		var thisChildrenPos = []
		for i in get_parent().children_pos:
			if i == self.name:
				thisChildrenPos = get_parent().children_pos[i]
		if (!childrenPosValue.has([thisChildrenPos[0],thisChildrenPos[1] + 1]) # Jika dibawah tidak ada
			and !childrenPosValue.has([thisChildrenPos[0] + 1,thisChildrenPos[1] + 1]) # Jika dibawah dan dibawah kanan tidak ada
			and !childrenPosValue.has([thisChildrenPos[0] - 1,thisChildrenPos[1] + 1]) # Jika dibawah dan dibawah kiri tidak ada
			and thisChildrenPos[1] < yValues.max()  # Jika posisi masih diatas dari piece plaing bawah
			and thisChildrenPos[1] < 20):# Jika posisi belum sampai bottom
				
			global_position.y += 30
		
