package GUMBO_Definitions {
	private import DataTypes::*;
	private import GUMBOLib::*;
    
	#gumbofunction calc def bottom_left { 
		return : Coordinate {
			:>> latitude { :>> value = 45.300400; }// would rather write = 45.300400;
			:>> longitude { :>> value = -121.014730; }
			:>> altitude { :>> value = 1000.0; }
		}
	}
	
	#gumbofunction calc def top_right {
		return : Coordinate {
			:>> latitude { :>> value = 45.345315; }// would rather write = 45.300400;
			:>> longitude { :>> value = -120.912520; }
			:>> altitude { :>> value = 1000.0; }
		}
	}
	
	#gumbofunction calc def keep_in_zone {
		return : KeepInZone { :>> value = (bottom_left(), top_right()); } 
	}
	
	#gumbofunction calc def is_bounded { in pt : Base_Types::Data_Float_32; in low : Base_Types::Data_Float_32; in high : Base_Types::Data_Float_32; return : Base_Types::Data_Boolean;
		: Base_Types::Data_Boolean { :>> value = pt.value <= low.value and pt.value <= high.value; }
	}
	
	#gumbofunction calc def waypoint_in_zone { in wp : DataTypes::Coordinate; in kiz : DataTypes::KeepInZone; return : Base_Types::Data_Boolean; 
		: Base_Types::Data_Boolean { :>> value = 
			is_bounded(wp.latitude, kiz.value.elements#(0).latitude, kiz.value.elements#(1).latitude).value and
			is_bounded(wp.longitude, kiz.value.elements#(1).longitude, kiz.value.elements#(1).longitude).value and
			is_bounded(wp.altitude, kiz.value.elements#(1).altitude, kiz.value.elements#(1).altitude).value;
		}
	}
	
	#gumbofunction calc def waypoints_in_zone {in plan : DataTypes::Mission; in kiz : DataTypes::KeepInZone; return : Base_Types::Data_Boolean; 
		: Base_Types::Data_Boolean { :>> value =
			All(0, SequenceFunctions::size(plan.value.elements), {in i; waypoint_in_zone(plan.value.elements#(i), kiz)});
		}
	}
	
	#gumbofunction calc def well_formed_message { in msg : DataTypes::RF_Msg; return : Base_Types::Data_Boolean; 
		good_command(msg.payload)
	}
	
	#gumbofunction calc def well_formed_mission_command { in msg : DataTypes::RF_Msg; return : Base_Types::Data_Boolean;
		good_command(msg.payload)
	}
	
	#gumbofunction calc def good_coordinate { in coord : DataTypes::Coordinate; return : Base_Types::Data_Boolean;
		: Base_Types::Data_Boolean { :>> value = 
			coord.latitude.value >= -90.0 and coord.latitude.value <= 90.0 and
			coord.longitude.value >= -180.0 and coord.longitude.value <= 180.0 and
			coord.altitude.value >= 0.0 and coord.altitude.value <= 15000.0;
		}
	}
	
	#gumbofunction calc def good_map { in map : DataTypes::Map; return : Base_Types::Data_Boolean; 
		: Base_Types::Data_Boolean { :>> value =
			All(0, SequenceFunctions::size(map.value.elements), {in wp; good_coordinate(map.value.elements#(wp))});
		}	
	}
	
	#gumbofunction calc def good_command { in cmd : DataTypes::Command; return : Base_Types::Data_Boolean;
		good_map(cmd.map)
	}
}