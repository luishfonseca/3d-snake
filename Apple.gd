extends MeshInstance

var rng = RandomNumberGenerator.new()

func _ready():
    rng.randomize()
    new_position()

func new_position():
    var M = get_parent().bounds_radius
    translation = Vector3(
        rng.randi_range(-M, M),
        rng.randi_range(-M, M),
        rng.randi_range(-M, M)
    )

