extends Spatial

const multiplier = 1.5

var weight = 0
var fov = 80
var head

func _ready():
    head = get_parent().get_node("Head")

func _process(delta):
    if weight > 1:
        weight = 1
    else:
        weight += multiplier * delta

    $Camera.fov = $Camera.fov * (1 - weight) + fov * weight
    transform = transform.interpolate_with(head.transform, weight)

func move():
    weight = 0
