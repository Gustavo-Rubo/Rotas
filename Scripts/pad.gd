extends Node2D

export (int) var grid_x
export (int) var grid_y
var radius

var connected_to_net = false
var net_number = null

var recursive_checked = false

var circle_points = PoolVector2Array()

# Pads can have diferent internal shapes according to their net numbers:
# 0 - circle
# 1 - square
# 2 - triangle
# 3 - diamond
# 4 - pentagon
# 5 - star

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = Globals.GRID_SIZE * 0.8
	position = Globals.GRID_SIZE * Vector2(grid_x, grid_y)
	$Area2D/CollisionShape2D.shape.set("radius", radius)
	
	for i in range(0, 20):
		circle_points.append(Vector2(sin(i*PI/10), cos(i*PI/10)))
	
func _draw():
	# We use the draw_colored_polygon function because the draw_circle has no antialiasing
#	draw_colored_polygon(circle_points, Globals.green_base, PoolVector2Array(), null, null, true)
	draw_circle_aa(Vector2(0,0), radius, Globals.green_base)
	
	if (net_number == 0): draw_circle_aa(Vector2(0, 0), radius / 2, Globals.blue_background)
	if (net_number == 1): draw_square(Vector2(0, 0), radius / 2, Globals.blue_background)
	if (net_number == 2): draw_triangle(Vector2(0, 0), radius / 2, Globals.blue_background)
	if (net_number == 3): draw_diamond(Vector2(0, 0), radius / 2, Globals.blue_background)
	if (net_number == 4): draw_pentagon(Vector2(0, 0), radius / 2, Globals.blue_background)
	if (net_number == 5): draw_star(Vector2(0, 0), radius / 2, Globals.blue_background)

# We use this because draw_circle has no anti-aliasing 
func draw_circle_aa(center, radius, color):
	var circle_points_radius = PoolVector2Array()
	for c in circle_points:
		circle_points_radius.append(c * radius)
	draw_colored_polygon(circle_points_radius, color, PoolVector2Array(), null, null, true)
	
func draw_square(pos, r, color):
	r = r*1.2
	var points = PoolVector2Array([
		Vector2(0, -r).rotated(PI*1/4),
		Vector2(0, -r).rotated(PI*3/4),
		Vector2(0, -r).rotated(PI*5/4),
		Vector2(0, -r).rotated(PI*7/4)])
	draw_colored_polygon(points, color, PoolVector2Array(), null, null, true)

func draw_triangle(pos, r, color):
	r = r*1.2
	var points = PoolVector2Array([
		Vector2(0, -r).rotated(0),
		Vector2(0, -r).rotated(PI*2/3),
		Vector2(0, -r).rotated(PI*4/3)])
	draw_colored_polygon(points, color, PoolVector2Array(), null, null, true)
	
func draw_diamond(pos, r, color):
	r = r*1.2
	var points = PoolVector2Array([
		Vector2(0, r),
		Vector2(r, 0),
		Vector2(0, -r),
		Vector2(-r, 0)])
	draw_colored_polygon(points, color, PoolVector2Array(), null, null, true)
	
func draw_pentagon(pos, r, color):
	r = r*1.2
	var points = PoolVector2Array([
		Vector2(0, -r).rotated(0),
		Vector2(0, -r).rotated(PI*2/5),
		Vector2(0, -r).rotated(PI*4/5),
		Vector2(0, -r).rotated(PI*6/5),
		Vector2(0, -r).rotated(PI*8/5)])
	draw_colored_polygon(points, color, PoolVector2Array(), null, null, true)
	
func draw_star(pos, r, color):
	r = r*1.2
	var points = PoolVector2Array([
		Vector2(0, -r).rotated(0),
		Vector2(0, -r/2).rotated(PI*1/5),
		Vector2(0, -r).rotated(PI*2/5),
		Vector2(0, -r/2).rotated(PI*3/5),
		Vector2(0, -r).rotated(PI*4/5),
		Vector2(0, -r/2).rotated(PI*5/5),
		Vector2(0, -r).rotated(PI*6/5),
		Vector2(0, -r/2).rotated(PI*7/5),
		Vector2(0, -r).rotated(PI*8/5),
		Vector2(0, -r/2).rotated(PI*9/5)])
	draw_colored_polygon(points, color, PoolVector2Array(), null, null, true)
	
# Check if a point is inside of the pad
func check_click(pos):
	return position.distance_to(pos) <= radius

#func _on_Area2D_input_event(_viewport, event, _shape_idx):
#	if event is InputEventMouseButton:
#		if event.pressed:
#			print("press on pad")
