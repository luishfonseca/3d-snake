extends MultiMeshInstance

signal collision
signal apple_eaten

var last_forward = Vector3.BACK

var apple_position = Vector3.INF

func _unhandled_input(event):
    if event.is_action_pressed("ui_right"):
        $Head.transform.basis *= Basis(Vector3(0, 0, 1), -PI/2)
        $Head.transform.basis = $Head.transform.basis.orthonormalized()
        $View.move()
    elif event.is_action_pressed("ui_left"):
        $Head.transform.basis *= Basis(Vector3(0, 0, 1), PI/2)
        $Head.transform.basis = $Head.transform.basis.orthonormalized()
        $View.move()
    elif event.is_action_pressed("ui_down"):
        $Head.transform.basis *= Basis(Vector3(1, 0, 0), -PI/2)
        if last_forward.is_equal_approx(-$Head.transform.basis.z):
            if $Tail.get_child_count() != 0:
                $Head.transform.basis *= Basis(Vector3(1, 0, 0), PI/2)
        $Head.transform.basis = $Head.transform.basis.orthonormalized()
        $View.move()
    elif event.is_action_pressed("ui_up"):
        $Head.transform.basis *= Basis(Vector3(1, 0, 0), PI/2)
        if last_forward.is_equal_approx(-$Head.transform.basis.z):
            if $Tail.get_child_count() != 0:
                $Head.transform.basis *= Basis(Vector3(1, 0, 0), -PI/2)
        $Head.transform.basis = $Head.transform.basis.orthonormalized()
        $View.move()

func reset():
    $Head.translation = Vector3.ZERO
    $View.weight = 0
    $View.fov = 80
    $View.translation = Vector3.ZERO
    for p in $Tail.get_children():
        p.free()
    generate_mesh()

func set_fast_camera(is_fast):
    if is_fast:
        $View.fov = 50
    else:
        $View.fov = 80

func move():
    var last = $Tail.get_child_count() - 1
    var old_tail_end = $Head.translation
    if last > -1:
        var p = $Tail.get_child(last)
        old_tail_end = p.translation
        p.translation = $Head.translation
        $Tail.move_child(p, 0)

    $Head.translate(Vector3.FORWARD)

    if collides_with_apple():
        var p = Spatial.new()
        p.translation = old_tail_end
        $Tail.add_child(p)
        emit_signal('apple_eaten', $Tail.get_children())

    if collides_with_self() or collides_with_bounds():
        $Head.translate(Vector3.BACK)
        emit_signal('collision')
    else:
        last_forward = $Head.transform.basis.z
        $View.move()
        generate_mesh()

func collides_with_apple():
    return $Head.translation.is_equal_approx(apple_position)

func collides_with_self():
    for p in $Tail.get_children():
        if p.translation.is_equal_approx($Head.translation):
            return true

func collides_with_bounds():
    var r = get_parent().bounds_radius
    var v = $Head.translation.abs().round()
    return v.x > r or v.y > r or v.z > r

func generate_mesh():
    self.multimesh.instance_count = $Tail.get_child_count()
    for i in range($Tail.get_child_count()):
        var t = $Tail.get_child(i).transform
        self.multimesh.set_instance_transform(i, t)
