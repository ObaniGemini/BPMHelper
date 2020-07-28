extends Node2D

const speedTexts = [ "w", "h", "q", "e", "s" ]

onready var BPM = $Container/BPM/LineEdit
onready var Time = $Container/Time/LineEdit
onready var Hz = $Container/Hz/LineEdit
onready var Speed = $Speed/current

var speed = 1
var timeUnit = 1


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		SM.config.speed = $Speed/HSlider.value
		SM.config.timeUnit = timeUnit
		SM.config.BPM = BPM.text
		SM.config.Time = Time.text
		SM.config.Hz = Hz.text
		
		SM.save_config()
		get_tree().quit()


func _ready():
	SM.load_config()
	
	set_speed( SM.config.speed )
	timeUnit = SM.config.timeUnit
	BPM.text = SM.config.BPM
	Time.text = SM.config.Time
	Hz.text = SM.config.Hz




func check_validity( text ):
	if( text.is_valid_float() or text == "" ):
		$Error.hide()
		return true
	
	$Error.show()
	return false


func update():
	var bpm = BPM.text.to_float() * speed
	
	if( bpm == 0 ):
		Time.text = ""
		Hz.text = ""
	else:
		Time.text = str( ( 60 * timeUnit ) / bpm ).substr( 0, 7 )
		Hz.text = str( bpm / 60 ).substr( 0, 7 )



func BPM_text_changed( text ):
	text = text.replace( ",", "." )
	
	if( !check_validity( text ) ):
		return
	
	var value = text.to_float() * speed
	
	if( value == 0 ):
		Time.text = ""
	else:
		Time.text = str( ( 60 * timeUnit ) / value ).substr( 0, 7 )
	Hz.text = str( value / 60 ).substr( 0, 7 )


func MS_text_changed( text ):
	text = text.replace( ",", "." )
	
	if( !check_validity( text ) ):
		return
	
	var value = text.to_float() * speed
	
	if( value == 0 ):
		BPM.text = ""
		Hz.text = ""
	else:
		BPM.text = str( ( 60 * timeUnit ) / value ).substr( 0, 7 )
		Hz.text = str( 1 / value ).substr( 0, 7 )


func HZ_text_changed( text ):
	text = text.replace( ",", "." )
	
	if( !check_validity( text ) ):
		return
	
	var value = text.to_float() * speed
	
	BPM.text = str( value * 60 ).substr( 0, 7 )
	if( value == 0 ):
		Time.text = ""
	else:
		Time.text = str( timeUnit / value ).substr( 0, 7 )


func set_speed( value ):
	$Speed/HSlider.value = int( value )
	speed = 0.25 * pow( 2, value )
	Speed.text = speedTexts[ int( value ) ]
	update()


func switchTimeUnit():
	if( timeUnit == 1 ):
		$Container/Time/HBoxContainer/Button.text = "Ms"
		$Container/Time/Sub.text = "Milliseconds"
		timeUnit = 1000
	else:
		$Container/Time/HBoxContainer/Button.text = "S"
		$Container/Time/Sub.text = "Seconds"
		timeUnit = 1
	
	update()
