extends PuzzlePoint
class_name RepairPoint

var condition:int = 0

func status_check():
	status = condition == 0
