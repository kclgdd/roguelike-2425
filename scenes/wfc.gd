extends Node

class Tile:
	var id: int
	var possible_tiles: Array
	var collapsed: bool = false
	
	func _init(_id: int, _possible_tiles: Array):
		id = _id
		possible_tiles = _possible_tiles

var grid_size = Vector2(10, 10)
var tiles = []

#var tile_types = [0, 1, 2, 3]
#var adjacency_rules = {
	#0: [],
	#1: [1, 2],
	#2: [1, 3],
	#3: [2, 3]
#}

var tile_types = [0, 1, 2, 3, 4, 5, 6, 7] # Example tile types
var adjacency_rules = {
	0: [1, 2, 3, 4, 5, 6, 7],  # Blank tile (0) connects to all tiles except at the ends of paths
	1: [1, 3, 4, 5, 6, 7],  # Horizontal Path (left-right) can connect with itself, 4-way, and all corner paths
	2: [2, 3, 4, 6, 5, 7],  # Vertical Path (top-bottom) can connect with itself, 4-way, and all corner paths
	3: [1, 2, 3, 4, 5, 6, 7],  # 4-way path connects with all other tiles (horizontal, vertical, corners)
	4: [1, 3, 6, 7],  # Top-left corner (up-left) connects with horizontal, 4-way, bottom-left, and bottom-right corners
	5: [1, 3, 6, 7],  # Top-right corner (up-right) connects with horizontal, 4-way, bottom-left, and bottom-right corners
	6: [2, 3, 4, 1],  # Bottom-left corner (down-left) connects with vertical, 4-way, top-left, and horizontal paths
	7: [2, 3, 5, 1],  # Bottom-right corner (down-right) connects with vertical, 4-way, top-right, and horizontal paths
}

 # Define adjacency rules

func _ready():
	initialize_grid()
	collapse_wave_function()

func initialize_grid():
	for y in range(grid_size.y):
		var row = []
		for x in range(grid_size.x):
			row.append(Tile.new(0, tile_types.duplicate()))
		tiles.append(row)

func collapse_wave_function():
	while has_uncollapsed_tiles():
		var cell = find_lowest_entropy_tile()
		if cell == null:
			print("ERROR: No valid tiles left to collapse!")
			return # Stop the function to prevent an infinite loop
		collapse_tile(cell)
		propagate_constraints()
	print_grid()

func find_lowest_entropy_tile():
	var min_entropy = 99999
	var best_tile = null
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var tile = tiles[y][x]
			if not tile.collapsed and tile.possible_tiles.size() > 0 and tile.possible_tiles.size() < min_entropy:
				min_entropy = tile.possible_tiles.size()
				best_tile = Vector2(x, y)
	return best_tile

func collapse_tile(pos: Vector2):
	var tile = tiles[pos.y][pos.x]
	if tile.possible_tiles.size() > 0:
		tile.id = tile.possible_tiles[randi() % tile.possible_tiles.size()]
		tile.possible_tiles = [tile.id]
		tile.collapsed = true
	else:
		print("ERROR: No possible tiles to collapse at position ", pos)
		return # Handle case where no tiles can be collapsed


func propagate_constraints():
	var stack = []
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			if tiles[y][x].collapsed:
				stack.append(Vector2(x, y))
	
	while stack.size() > 0:  # Fix: Use size() instead of empty()
		var pos = stack.pop_front()
		var tile = tiles[pos.y][pos.x]
		
		for offset in [Vector2(0,1), Vector2(0,-1), Vector2(1,0), Vector2(-1,0)]:
			var neighbor_pos = pos + offset
			if neighbor_pos.x >= 0 and neighbor_pos.x < grid_size.x and neighbor_pos.y >= 0 and neighbor_pos.y < grid_size.y:
				var neighbor = tiles[neighbor_pos.y][neighbor_pos.x]
				if not neighbor.collapsed:
					var new_possibilities = []
					for neighbor_tile in neighbor.possible_tiles:
						if neighbor_tile in adjacency_rules[tile.id]:
							new_possibilities.append(neighbor_tile)
					if new_possibilities.size() == 0:
						print("ERROR: Tile at ", neighbor_pos, " has no valid options left!")
						return # Prevents further infinite processing
					if new_possibilities.size() < neighbor.possible_tiles.size():
						neighbor.possible_tiles = new_possibilities
						stack.append(neighbor_pos)


func has_uncollapsed_tiles():
	for row in tiles:
		for tile in row:
			if not tile.collapsed:
				return true
	return false

func print_grid():
	for row in tiles:
		var row_values = []
		for tile in row:
			row_values.append(tile.id)
		print(row_values)
