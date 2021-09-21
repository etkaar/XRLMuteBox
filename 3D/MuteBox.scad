/**
*	Should not have any effect. Only used to fix render bugs, see:
*	https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/FAQ#What_are_those_strange_flickering_artifacts_in_the_preview?
*/
OVERLAP1 = 0.01;
OVERLAP2 = 2 * OVERLAP1;

/**
*	Dimensions of the box, including its wall thickness. Depends on
* the material, but 2.2-2.4 mm for PLA is absolute fine.
*/
BASE_THICKNESS = 2.2;

BOX_LENGTH = 100;
BOX_WIDTH = 70;
BOX_HEIGHT = 51;

BOX_COLOR1 = "DarkSlateBlue";
BOX_COLOR2 = "Indigo";

/**
*	Always add some padding to these values
*/
BOLTS_M3_DMTR = 3 + 0.8;
BOLTS_M3_HEAD_HEIGHT = 2.0 + 1.0;
BOLTS_M3_HEAD_DMTR = 6 + 1.5;

THREADED_NUTS_M3_HEIGHT = 2.4 + 0.2;
THREADED_NUTS_M3_DMTR = 5.5 + 1.2;

THREADED_NUTS_M4_HEIGHT = 3.0 + 0.2;
THREADED_NUTS_M4_DMTR = 6.85 + 1.2;

/**
*	Hole diameters for the terminal side
*/
MUTE_BUTTON_HOLE_DMTR = 22 + 1.0;

XLR_IN_HOLE_DMTR = 21.6 + 0.5;
XLR_IN_RECESS_SIZE = 26.5;

XLR_OUT_HOLE_DMTR = 21.6 + 0.5;
XLR_OUT_RECESS_SIZE = 26.5;

XLR_ASSEMBLING_HOLES_DMTR = 2 + 0.7;

DC5V_HOLE_DMTR = 7.8 + 0.5;
DC5V_RECESS_SIZE = 12.5;

// Drift for the DCV5 jack
DCV5_DRIFT = 3;

/**
*	Illuminated front text
*/
FRONT_TEXT = "ON AIR";
FRONT_TEXT_SIZE = 9.0;
FRONT_TEXT_SPACING = 1.05;

FRONT_TEXT_BARS_LENGTH = (BOX_WIDTH / 1.65);

/**
*	NOTE: Only relevant if you don't seperate the front text but
*	decide to print the text as a recess (see SEPARATE_FRONT_TEXT)
*/
FRONT_TEXT_RECESS_DEPTH = BASE_THICKNESS - 0.2;

/**
*	Seperate front text from front side, so you can print
*	the 3D text in white filament and plug it into the
*	front panel with different color.
*/
SEPARATE_FRONT_TEXT = true;
SEPARATE_FRONT_TEXT_PLATE_THICKNESS = 0.8;

/**
*	Usually not to be changed
*/
HOLDER_THICKNESS = 3.2;
HOLDER_HEIGHT = THREADED_NUTS_M3_DMTR * 1.5;

// Chamfers factor
CHAMFERS_RATIO = BASE_THICKNESS * 2.0;

/**
*	Enable recesses for XLR and DC5V jacks.
*
*	BEWARE: Not recommended, because you might be not able to print that if
*	you decide (which is recommended) to print the parts individually.
*/
DRAW_JACK_RECESSES = false;

/**
*	Disable front illumination
*/
DISABLE_FRONT_ILLUMINATION = false;

/**
*	Assemble it to have a better view
*/
PUT_ALL_TOGETHER = false;

/**
*	Margin between disassembled parts
*/
DISASSEMBLED_PARTS_MARGIN = 10;

/**
*	Show or hide parts
*/
HIDE_TOP_PLATE = false;
HIDE_BOTTOM_PLATE = false;

HIDE_BACK_SIDE = false;
HIDE_FRONT_SIDE = false;

HIDE_LEFT_SIDE = false;
HIDE_RIGHT_SIDE = false;

HIDE_SEPARATE_FRONT_TEXT_PLATE = false;

/**
*	Attach single parts
*/
ATTACH_BOTTOM_PLATE = false;

ATTACH_BACK_SIDE = false;
ATTACH_FRONT_SIDE = false;

ATTACH_LEFT_SIDE = false;
ATTACH_RIGHT_SIDE = false;

ATTACH_SEPARATE_FRONT_TEXT_PLATE = true;

/**
*	Z position for the holders holes and hexagons
*/
_holders_holes_z = THREADED_NUTS_M3_DMTR / 2 + BASE_THICKNESS + ((HOLDER_HEIGHT - THREADED_NUTS_M3_DMTR) / 2);
_holders_holes_side_margin = BASE_THICKNESS + HOLDER_THICKNESS + (THREADED_NUTS_M3_DMTR / 1.5);

/**
*	Hide parts
*/
if (!HIDE_TOP_PLATE) {
	difference() {
		DrawTopPlate();
		
		// Chamfers
		translate([0, OVERLAP1 * (-1), CHAMFERS_RATIO * (-1)])
		rotate([0, -45, 0])
		cube([CHAMFERS_RATIO, BOX_WIDTH + OVERLAP2, CHAMFERS_RATIO]);
		
		translate([BOX_LENGTH, OVERLAP1 * (-1), CHAMFERS_RATIO * (-1)])
		rotate([0, -45, 0])
		cube([CHAMFERS_RATIO, BOX_WIDTH + OVERLAP2, CHAMFERS_RATIO]);
	}
}

if (!HIDE_BOTTOM_PLATE) {
	DrawBottomPlate();
}

if (!HIDE_BACK_SIDE) {
	DrawBackSide();
}

if (!HIDE_FRONT_SIDE) {
	DrawFrontSide();
}

if (!HIDE_SEPARATE_FRONT_TEXT_PLATE && !DISABLE_FRONT_ILLUMINATION) {
	DrawSeparateFrontTextPlate();
}

if (!HIDE_LEFT_SIDE) {
	DrawLeftSide();
}

if (!HIDE_RIGHT_SIDE) {
	DrawRightSide();
}

/**
*	Top Plate - With the big red button in it
*/
module DrawTopPlate() {
	difference() {
		/**
		*	Plate
		*/
		color(BOX_COLOR1)
		cube([BOX_LENGTH, BOX_WIDTH, BASE_THICKNESS]);

		/**
		*	Hole for the big red button
		*/
		translate([(BOX_LENGTH / 2 + 10), (BOX_WIDTH / 2), 0 - OVERLAP1])
		cylinder(h=BASE_THICKNESS + OVERLAP2, d=MUTE_BUTTON_HOLE_DMTR, center=false);
	}
	
	/**
	*	Draw plate holders
	*/
	DrawPlateHolders();
	
	// Draw illumination reflecting plate
	if (!DISABLE_FRONT_ILLUMINATION) {
		_drift = _holders_holes_side_margin;
		_thickness = 2.0;
		_width = (BOX_WIDTH - 2 * BASE_THICKNESS - 2 * HOLDER_THICKNESS);
		_height = (BOX_HEIGHT - 2 * BASE_THICKNESS) - HOLDER_HEIGHT - 1;
		
		/*translate([(BOX_LENGTH - 2 * HOLDER_THICKNESS - _drift), (BOX_WIDTH - _width) / 2, BASE_THICKNESS])
		rotate([0, 0, 20])
		#cube([_thickness, _width, _height]);
		
		translate([(BOX_LENGTH - 2 * HOLDER_THICKNESS - _drift), ((BOX_WIDTH - _width) / 2) - 20, BASE_THICKNESS])
		rotate([0, 0, -20])
		#cube([_thickness, _width, _height]);*/
	}
}

/**
*	Bottom Plate
*/
module DrawBottomPlate() {
	_translation = (PUT_ALL_TOGETHER || ATTACH_BOTTOM_PLATE)
		? ([BASE_THICKNESS, BOX_WIDTH - BASE_THICKNESS, BOX_HEIGHT])
		: ([BASE_THICKNESS, BOX_WIDTH + BOX_HEIGHT + (2 * DISASSEMBLED_PARTS_MARGIN), 0]);

	_rotation = (PUT_ALL_TOGETHER || ATTACH_BOTTOM_PLATE)
		? ([180, 0, 0])
		: ([0, 0, 0]);

	translate(_translation) {
		rotate(_rotation) {
			difference() {
				
				_holder_size = THREADED_NUTS_M4_DMTR * 1.5;
				_leg_height = THREADED_NUTS_M4_HEIGHT;
				_holder_drift = HOLDER_THICKNESS * 1.75;
				
				union() {
					/**
					*	Plate
					*/
					color(BOX_COLOR1)
					cube([BOX_LENGTH - (2 * BASE_THICKNESS), BOX_WIDTH - (2 * BASE_THICKNESS), BASE_THICKNESS]);
					
					translate([_holder_drift, _holder_drift, 0])
					#cube([_holder_size, _holder_size, _leg_height], center=false);
				
					/**
					*	Holders for the threaded nuts
					*/
					//translate([HOLDER_THICKNESS * (-1), HOLDER_THICKNESS * (-1), 0]) {						
						/*for(SIDE = [0, 1]) {
							_x = (SIDE == 0)
								? _holder_drift
								: (BOX_LENGTH - _holder_size - _holder_drift);
							
							_y = (SIDE == 0)
								? _holder_drift
								: (BOX_WIDTH - _holder_size - _holder_drift);
							
							translate([_x, _y, 0])
							color(BOX_COLOR2)
							#cube([_holder_size, _holder_size, _leg_height], center=false);
							
							translate([_x, _y, 0])
							color(BOX_COLOR2)
							cube([_holder_size, _holder_size, _leg_height], center=false);
						}*/
					//}
				}
			
				/**
				*	Draw hexagons for the threaded nuts
				*/
				translate([_holder_drift + _holder_size / 2, _holder_drift + _holder_size / 2, 0])
				//cube([10, 10, 20]);
				#cylinder($fn=6, h=40, d=THREADED_NUTS_M4_DMTR, center=false);

			}
				
			translate([BASE_THICKNESS * (-1), BASE_THICKNESS * (-1), 0]) {
				difference() {
					/**
					*	Draw plate holders
					*/
					DrawPlateHolders();
					
					/**
					*	We need some recess for the DCV5
					*/
					_recess_width = 20;
					translate([BASE_THICKNESS - OVERLAP1, ((BOX_WIDTH - _recess_width) / 2) - DCV5_DRIFT, BASE_THICKNESS - OVERLAP1])
					cube([HOLDER_THICKNESS + OVERLAP2, 20, HOLDER_HEIGHT + OVERLAP2]);
				}
			}
		}
	}
	
	//#cylinder($fn=6, h=40, d=THREADED_NUTS_M4_DMTR, center=false);
}

/**
*	Long and short holders with holes (fitted with threaded nuts) to hold the side plates
*/
module DrawPlateHolders() {
	for(SIDE = ["long", "short"]) {
		for(PART = ["1st", "2nd"]) {
			_rotation = (SIDE == "long")
				? ([0, 0, 0])
				: ([0, 0, 90]);
			
			_box_length = (SIDE == "long")
				? (BOX_LENGTH)
				: (BOX_WIDTH);
			
			_box_width = (SIDE == "long")
				? (BOX_WIDTH)
				: (BOX_LENGTH);
			
			_x = (SIDE == "long")
				? (BASE_THICKNESS + HOLDER_THICKNESS)
				: (BASE_THICKNESS);
			
			_y = (PART == "1st")
				? BASE_THICKNESS
				: (_box_width - BASE_THICKNESS - HOLDER_THICKNESS);
			_z = BASE_THICKNESS;
			
			_cube_translation = [_x, _y, _z];
			_cube_length = (SIDE == "long")
				? (_box_length - 2 * BASE_THICKNESS - 2 * HOLDER_THICKNESS)
				: (_box_length - 2 * BASE_THICKNESS);
			
			// Translate and rotate (required for the short side)
			_move_x = (SIDE == "long")
				? (0)
				: (BOX_LENGTH);
				
			translate([_move_x, 0, 0]) {
				rotate(_rotation) {
					
					difference() {
						// Holder
						translate(_cube_translation)
						color(BOX_COLOR2)
						cube([_cube_length, HOLDER_THICKNESS, HOLDER_HEIGHT]);

						// Recesses (hexagons, holes) for the holders
						for(n = [0, 1]) {
							_x = _holders_holes_side_margin;
							_y = BASE_THICKNESS + HOLDER_THICKNESS;
							_z = _holders_holes_z;
							
							_translation = [
								// _x
								(n == 0)
									? _x
									: (_box_length - _x),
							
								// _y
								(PART == "1st")
									? _y + OVERLAP1
									: (_y + (_box_width - (2 * BASE_THICKNESS + 2 * HOLDER_THICKNESS))) - OVERLAP1,
								
								// _z
								_z
							];
							
							_rotation = [
								(PART == "1st")
									? 90
									: 270,
								0,
								0
							];
							
							translate(_translation) {
								rotate(_rotation) {
									// Hexagon for fitting the threaded nut
									cylinder($fn=6, h=THREADED_NUTS_M3_HEIGHT + OVERLAP1, d=THREADED_NUTS_M3_DMTR, center=false);
									
									// Hole for the bolt
									cylinder($fn=20, h=HOLDER_THICKNESS + OVERLAP2, d=BOLTS_M3_DMTR, center=false);
								}
							}
						}
					}
				}
			}
		}
	}
}

/**
*	Back Side - Terminals (XLR and DCV5 jacks)
*/
module DrawBackSide() {
	_translation = (PUT_ALL_TOGETHER || ATTACH_BACK_SIDE)
		? ([0, 0, BASE_THICKNESS])
		: ([DISASSEMBLED_PARTS_MARGIN * (-1), BOX_WIDTH, BASE_THICKNESS]);

	_rotation = (PUT_ALL_TOGETHER || ATTACH_BACK_SIDE)
		? ([0, 0, 0])
		: ([0, 90, 180]);

	translate(_translation) {
		rotate(_rotation) {
			difference() {
				color(BOX_COLOR1)
				cube([BASE_THICKNESS, BOX_WIDTH, (BOX_HEIGHT - 1 * BASE_THICKNESS)]);

				rotate([90, 0, 90]) {
					// XLR > IN
					translate([(XLR_IN_HOLE_DMTR / 2) + 9, (BOX_HEIGHT / 2) - 2.5, 0 - OVERLAP1]) {
						cylinder(h=BASE_THICKNESS + OVERLAP2, d=XLR_IN_HOLE_DMTR, center=false);
						
						// Small recess for the XRL jack
						if (DRAW_JACK_RECESSES) {
							_depth = 1.0;
							translate([0, 0, BASE_THICKNESS + (_depth / 2) - _depth + OVERLAP2])
							cube([XLR_IN_RECESS_SIZE, XLR_IN_RECESS_SIZE, _depth], center=true);
						}
						
						// XLR assembling holes
						for(i = [1, -1]) {
							translate([i * (19.8 / 2), i * (19.8 / 2), 0])
							cylinder($fn=15, h=BASE_THICKNESS + OVERLAP2, d=XLR_ASSEMBLING_HOLES_DMTR, center=false);
						}
					}

					// XLR > OUT
					translate([(BOX_WIDTH - (XLR_OUT_HOLE_DMTR / 2) - 9), (BOX_HEIGHT / 2) - 2.5, 0 - OVERLAP1]) {
						cylinder(h=BASE_THICKNESS + OVERLAP2, d=XLR_OUT_HOLE_DMTR, center=false);
						
						// Small recess for the XRL jack
						if (DRAW_JACK_RECESSES) {
							_depth = 1.0;
							translate([0, 0, BASE_THICKNESS + (_depth / 2) - _depth + OVERLAP2])
							cube([XLR_OUT_RECESS_SIZE, XLR_OUT_RECESS_SIZE, _depth], center=true);
						}
						
						// XLR assembling holes
						for(i = [1, -1]) {
							translate([i * (19.8 / 2), i * (19.8 / 2), 0])
							cylinder($fn=15, h=BASE_THICKNESS + OVERLAP2, d=XLR_ASSEMBLING_HOLES_DMTR, center=false);
						}
					}
					
					// Hole for DC5V
					translate([BOX_WIDTH / 2 + DCV5_DRIFT, BOX_HEIGHT - 11, 0 - OVERLAP1]) {
						cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=DC5V_HOLE_DMTR, center=false);
						
						// Small recess for the DC5V
						if (DRAW_JACK_RECESSES) {
							_depth = 1.0;
							translate([0, 0, BASE_THICKNESS + (_depth / 2) - _depth + OVERLAP2])
							cube([DC5V_RECESS_SIZE, DC5V_RECESS_SIZE, _depth], center=true);
						}
					}
					
					// Mouting holes
					_DrawMountingHoles1();
				}
			}
		}
	}
}

/**
*	Front Side
*/
module DrawFrontSide() {
	_translation = (PUT_ALL_TOGETHER || ATTACH_FRONT_SIDE)
		? ([BOX_LENGTH, BOX_WIDTH, BASE_THICKNESS])
		: ([BOX_LENGTH + BOX_HEIGHT + DISASSEMBLED_PARTS_MARGIN, BOX_WIDTH, (BASE_THICKNESS - SEPARATE_FRONT_TEXT_PLATE_THICKNESS)]);

	_rotation = (PUT_ALL_TOGETHER || ATTACH_FRONT_SIDE)
		? ([0, 0, 180])
		: ([0, 90, 180]);

	translate(_translation) {
		rotate(_rotation) {
			difference() {
				/**
				*	Plate
				*/
				_front_panel_thickness = BASE_THICKNESS - SEPARATE_FRONT_TEXT_PLATE_THICKNESS;
				color(BOX_COLOR1)
				cube([_front_panel_thickness, BOX_WIDTH, (BOX_HEIGHT - 1 * BASE_THICKNESS)]);
				
				/**
				*	Illuminated text
				*/
				if (!DISABLE_FRONT_ILLUMINATION) {
					DrawIlluminationText(_PART=1);
				}
				
				/**
				*	Mounting holes
				*/
				rotate([90, 0, 90]) {
					_DrawMountingHoles1();
				}
			}
		}
	}
}

module DrawIlluminationText(_PART) {
	_recess_depth = (_PART == 1)
		? (!SEPARATE_FRONT_TEXT)
			? FRONT_TEXT_RECESS_DEPTH
			: (BASE_THICKNESS)
		: (0);
	
	_reduction_factor1 = (_PART == 1)
		? 0.2
		: (_PART == 2)
			? -0.2
			: 0.2;
	
	_reduction_factor2 = (_PART == 1)
		? 0.0
		: (_PART == 2)
			? 0.4
			: 0.4;
	
	_illumination_text_top = ((BOX_HEIGHT - 2 * BASE_THICKNESS) / 2) * (-1);
	_illumination_text_left = (BOX_WIDTH / 2);
	
	_illumination_text_thickness = (_PART == 1)
		? (BASE_THICKNESS + OVERLAP2)
		: (_PART == 2)
			? (BASE_THICKNESS + OVERLAP2 - SEPARATE_FRONT_TEXT_PLATE_THICKNESS)
			: (BASE_THICKNESS);
	
	_illumination_text_bars_length = (_PART == 1)
		? FRONT_TEXT_BARS_LENGTH
		: (FRONT_TEXT_BARS_LENGTH - (2 * _reduction_factor2));
	
	_illumination_text_bars_height = (_PART == 1)
		? 2.5
		: (_PART == 2)
			? 1.7
			: 1.3;
	
	_illumination_text_bars_drift = 8;

	/**
	*	Recess for the text
	*/
	translate([_recess_depth, 0, 0]) {
		rotate([-90, 0, 90]) {
			/**
			*	Text
			*/
			translate([_illumination_text_left, _illumination_text_top, OVERLAP1 * (-1)])
			linear_extrude(_illumination_text_thickness)
			offset(delta=_reduction_factor1)
			text(FRONT_TEXT, size=FRONT_TEXT_SIZE, font="Bahnschrift:style=Bold", halign="center", valign="center", spacing=FRONT_TEXT_SPACING);
			
			/**
			*	Draw bars
			*/
			translate([(BOX_WIDTH - _illumination_text_bars_length) / 2, (_holders_holes_z + _illumination_text_bars_drift - _reduction_factor2) * (-1), 0 - OVERLAP1])
			cube([_illumination_text_bars_length, _illumination_text_bars_height, _illumination_text_thickness]);
			
			translate([(BOX_WIDTH - _illumination_text_bars_length) / 2, ((BOX_HEIGHT - 1 * BASE_THICKNESS) - (_holders_holes_z + _illumination_text_bars_drift + _reduction_factor2)) * (-1), 0 - OVERLAP1])
			cube([_illumination_text_bars_length, _illumination_text_bars_height, _illumination_text_thickness]);
		}
	}
}

/**
*	Separate illuminated text
*/
module DrawSeparateFrontTextPlate() {
	_width_reduction = BASE_THICKNESS * 1.5;
	
	_translation = (PUT_ALL_TOGETHER || ATTACH_SEPARATE_FRONT_TEXT_PLATE)
		? ([BOX_LENGTH - BASE_THICKNESS + SEPARATE_FRONT_TEXT_PLATE_THICKNESS, (BOX_WIDTH - _width_reduction), BASE_THICKNESS])
		: ([BOX_LENGTH + 2 * BOX_HEIGHT + 2 * DISASSEMBLED_PARTS_MARGIN, (BOX_WIDTH - _width_reduction), SEPARATE_FRONT_TEXT_PLATE_THICKNESS]);

	_rotation = (PUT_ALL_TOGETHER || ATTACH_SEPARATE_FRONT_TEXT_PLATE)
		? ([0, 0, 180])
		: ([0, 90, 180]);

	translate(_translation) {
		rotate(_rotation) {
			difference() {
				color("White")
				cube([SEPARATE_FRONT_TEXT_PLATE_THICKNESS, (BOX_WIDTH - 2 * _width_reduction), (BOX_HEIGHT - 1 * BASE_THICKNESS)]);
				
				/**
				*	Mounting holes
				*/
				rotate([90, 0, 90]) {
					translate([_width_reduction * (-1), 0, 0])
					_DrawMountingHoles1(countersunks=false);
				}
			}
			
			/**
			*	Illuminated text
			*/
			translate([0, _width_reduction * (-1), 0])
			DrawIlluminationText(_PART=2);
		}
	}
}

/**
*	Left Side
*/
module DrawLeftSide() {
	_translation = (PUT_ALL_TOGETHER || ATTACH_LEFT_SIDE)
		? ([BOX_LENGTH - BASE_THICKNESS + SEPARATE_FRONT_TEXT_PLATE_THICKNESS, BOX_WIDTH, BASE_THICKNESS])
		: ([BOX_LENGTH - BASE_THICKNESS, BOX_WIDTH + BOX_HEIGHT + DISASSEMBLED_PARTS_MARGIN, BASE_THICKNESS]);

	_rotation = (PUT_ALL_TOGETHER || ATTACH_LEFT_SIDE)
		? ([90, 0, -90])
		: ([0, 90, 180]);

	translate(_translation) {
		rotate(_rotation) {
			difference() {
				color(BOX_COLOR1)
				cube([BASE_THICKNESS, (BOX_HEIGHT - 1 * BASE_THICKNESS), (BOX_LENGTH - 2 * BASE_THICKNESS + SEPARATE_FRONT_TEXT_PLATE_THICKNESS)]);
				
				rotate([90, 0, 90]) {
					// Mouting holes
					translate([0, SEPARATE_FRONT_TEXT_PLATE_THICKNESS, 0])
					_DrawMountingHoles2();
				}
			}
		}
	}
}

/**
*	Right Side
*/
module DrawRightSide() {
	_translation = (PUT_ALL_TOGETHER || ATTACH_RIGHT_SIDE)
		? ([BASE_THICKNESS, 0, BASE_THICKNESS])
		: ([BOX_LENGTH - BASE_THICKNESS, 0 - DISASSEMBLED_PARTS_MARGIN, BASE_THICKNESS]);

	_rotation = (PUT_ALL_TOGETHER || ATTACH_RIGHT_SIDE)
		? ([90, 0, 90])
		: ([0, 90, 180]);

	translate(_translation) {
		rotate(_rotation) {
			difference() {
				color(BOX_COLOR1)
				cube([BASE_THICKNESS, (BOX_HEIGHT - 1 * BASE_THICKNESS), (BOX_LENGTH - 2 * BASE_THICKNESS + SEPARATE_FRONT_TEXT_PLATE_THICKNESS)]);
				
				rotate([90, 0, 90]) {
					// Mouting holes
					_DrawMountingHoles2();
				}
			}
		}
	}
}

/**
*	Draw mouting holes and saggings (we use countersunk bolts) on the front/back side
*/
module _DrawMountingHoles1(countersunks=true) {
	for(s = [0, 1]) {
		_x = (s == 0)
			? _holders_holes_z - BASE_THICKNESS
			: (BOX_HEIGHT - BASE_THICKNESS - _holders_holes_z);
		_y = _holders_holes_side_margin;
		
		translate([_y, _x, 0 - OVERLAP1]) {
			cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=BOLTS_M3_DMTR, center=false);
			
			if (countersunks) {
				cylinder($fn=20, h=BOLTS_M3_HEAD_HEIGHT + OVERLAP2, d1=BOLTS_M3_HEAD_DMTR, d2=0, center=false);
			}
		}
		
		translate([(BOX_WIDTH - _y), _x, 0 - OVERLAP1]) {
			cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=BOLTS_M3_DMTR, center=false);
			
			if (countersunks) {
				cylinder($fn=20, h=BOLTS_M3_HEAD_HEIGHT + OVERLAP2, d1=BOLTS_M3_HEAD_DMTR, d2=0, center=false);
			}
		}
	}
}

/**
*	Same as _DrawMountingHoles1(), only _x and _y is switched
*/
module _DrawMountingHoles2() {
	for(s = [0, 1]) {
		_x = (s == 0)
			? _holders_holes_z - BASE_THICKNESS
			: (BOX_HEIGHT - BASE_THICKNESS - _holders_holes_z);
		_y = _holders_holes_side_margin;
		
		translate([_x, _y - BASE_THICKNESS, 0 - OVERLAP1]) {
			cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=BOLTS_M3_DMTR, center=false);
			cylinder($fn=20, h=BOLTS_M3_HEAD_HEIGHT + OVERLAP2, d1=BOLTS_M3_HEAD_DMTR, d2=0, center=false);
		}
		
		translate([_x, (BOX_LENGTH - BASE_THICKNESS - _y), 0 - OVERLAP1]) {
			cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=BOLTS_M3_DMTR, center=false);
			cylinder($fn=20, h=BOLTS_M3_HEAD_HEIGHT + OVERLAP2, d1=BOLTS_M3_HEAD_DMTR, d2=0, center=false);
		}
	}
}
