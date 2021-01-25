extends Spatial

const normal_interval = 0.8
const fast_interval = 0.3
const bounds_radius = 12

var timer = 0
var interval = normal_interval
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

func _input(event):
    if over:
        if event.is_action_pressed('ui_accept'):
            $Snake.reset()
            interval = normal_interval
            timer = 0
            $Camera.current = false
            over = false
            $TextBox.visible = false

        get_tree().set_input_as_handled()
    else:
        if event.is_action_pressed('ui_accept'):
            $Snake.set_fast_camera(true)
            interval = fast_interval
        elif event.is_action_released('ui_accept'):
            $Snake.set_fast_camera(false)
            interval = normal_interval

func _on_Snake_collision():
    over = true
    $TextBox.visible = true
    $Camera.current = true


func _on_Snake_apple_eaten():
    $Apple.new_position()
    $Snake.apple_position = $Apple.translation
