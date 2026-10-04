class_name TweenUtil

## Dictionary of nodes to dictionaries of strings to tweens
static var tweens: Dictionary

## Gets a new, blank tween unique to the property on a target node
## Kills any existing tween that might have been there
static func get_new_tween(target: Node, property: String) -> Tween:
	var target_tweens = get_tweens_under_target(target)
	var tween: Tween = target_tweens.get(property)
	if tween:
		tween.kill()
	var new_tween: Tween = target.create_tween()
	target_tweens.set(property, new_tween)
	tweens.set(target, target_tweens)
	return new_tween
static func get_tweens_under_target(target: Node) -> Dictionary:
	var dict = tweens.get_or_add(target, {})
	return dict

#region TWEEN TECHNIQUES

## Tween the scale to the desired target scale
static func scale_to(target: CanvasItem, scale: Vector2, duration: float = 0.5, transition_type: Tween.TransitionType = Tween.TRANS_EXPO, ease_type: Tween.EaseType = Tween.EASE_IN) -> Tween:
	var tween = get_new_tween(target, "scale")
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	tween.tween_property(target, "scale", scale, duration)
	return tween

## Set scale, then tween back to one
static func pop(target: CanvasItem, scale: Vector2, duration: float = 0.5, transition_type: Tween.TransitionType = Tween.TRANS_EXPO) -> Tween:
	target.scale = scale
	var tween = get_new_tween(target, "scale")
	tween.set_trans(transition_type)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", Vector2.ONE, duration)
	return tween

## Add scale, then tween back to one
static func pop_delta(target: CanvasItem, scale_delta: Vector2, duration: float = 0.5, transition_type: Tween.TransitionType = Tween.TRANS_EXPO) -> Tween:
	target.scale += scale_delta
	var tween = get_new_tween(target, "scale")
	tween.set_trans(transition_type)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", Vector2.ONE, duration)
	return tween

## Tween to another location
static func whoosh(target: CanvasItem, position: Vector2, duration: float = 0.5, transition_type: Tween.TransitionType = Tween.TRANS_EXPO, ease_type: Tween.EaseType = Tween.EASE_OUT) -> Tween:
	var tween = get_new_tween(target, "position")
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	tween.tween_property(target, "position", position, duration)
	return tween

## Tween opacity
static func fade(target: CanvasItem, opacity: float, duration: float = 0.5, transition_type: Tween.TransitionType = Tween.TRANS_SINE) -> Tween:
	var tween = get_new_tween(target, "opacity")
	tween.set_trans(transition_type)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(target, "modulate:a", opacity, duration)
	return tween

## Skew +[code]skew[/code] degrees, -[code]skew[/code] degrees, then go back to 0 skew
static func shake_skew(target: CanvasItem, skew: float, duration: float = 0.5, transition_type: Tween.TransitionType = Tween.TRANS_EXPO, ease_type: Tween.EaseType = Tween.EASE_OUT) -> Tween:
	var right_skew = deg_to_rad(skew)
	var left_skew = -deg_to_rad(skew)
	var tween = get_new_tween(target, "skew")
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	tween.tween_property(target, "skew", right_skew, duration / 4.0)
	tween.tween_property(target, "skew", left_skew, duration / 2.0)
	tween.tween_property(target, "skew", 0.0, duration / 4.0)
	return tween

#endregion
