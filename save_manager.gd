extends Node


const default_config = {
	speedIndex = 2, #the index of the value, not the value of speed
	timeUnit = 1000,
	BPM = "",
	Time = "",
	Hz = ""
}


var config = {}


func load_config():
	config = default_config
	
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://config.bin", File.READ, "BPMHelper")
	
	if !err:
		config = f.get_var()
	
	if config == null:
		config = default_config
	else:
		for option in default_config:
			if !config.has(option):
				config[option] = default_config[option]
	
	f.close()
	print(config)


func save_config():
	var f = File.new()
	var err = f.open_encrypted_with_pass("res://config.bin", File.WRITE, "BPMHelper")
	f.store_var( config )
	f.close()
