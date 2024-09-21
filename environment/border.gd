extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var line_poly = Geometry2D.offset_polyline($Polygon2D.polygon, 1.0)
	for poly in line_poly:
		var col = CollisionPolygon2D.new()
		col.polygon = poly
		add_child(col)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
