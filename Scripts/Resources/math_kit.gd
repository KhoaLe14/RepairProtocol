extends Resource
class_name MathKit

static func flow_clampi(n:int, min:int, max:int) -> int:
	var range = max - min + 1
	return posmod(n - min, range) + min
