extends MeshInstance

var rng = RandomNumberGenerator.new()
var all_positions = []

func _ready():
    rng.randomize()

    var r = get_parent().bounds_radius
    for x in range(-r, r + 1):
        for y in range(-r, r + 1):
            for z in range(-r, r + 1):
                all_positions.append(Vector3(x, y, z))

    new_position([])

func new_position(invalid_positions):
    var valid_positions = all_positions.duplicate()
    for p1 in invalid_positions:
        valid_positions.erase(p1)

    var i = rng.randi_range(0, len(valid_positions) - 1)
    translation = valid_positions[i]
