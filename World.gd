extends Spatial

const interval = 0.8
const bounds_radius = 12

var timer = 0
var over = false

func _ready():
    var side = bounds_radius * 2 + 1
    $Bounds.mesh.size = Vector3(side, side, side)
    $Snake.apple_position = $Apple.translation

func _process(delta):
    if over:
        return
    timer += delta
    if timer >= interval:
        timer = 0
        $Snake.move()
        #oomph shader (just a zoom synced to beat)

func _input(_event):
    if over:
        get_tree().set_input_as_handled()

func _on_Snake_collision():
    over = true
    $Camera.current = true


func _on_Snake_apple_eaten():
    $Apple.new_position()
    $Snake.apple_position = $Apple.translation
