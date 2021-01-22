extends Spatial

const multiplier = 1

var weight = 0
var head

func _ready():
    head = get_parent().get_node("Head")

func _process(delta):
    if weight > 1:
        weight = 1
    else:
        weight += multiplier * delta

    transform = transform.interpolate_with(head.transform, weight)

func move():
    weight = 0
