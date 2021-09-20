/**
*	Should not have any effect. Only used to fix render bugs, see:
*	https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/FAQ#What_are_those_strange_flickering_artifacts_in_the_preview?
*/
OVERLAP1 = 0.01;
OVERLAP2 = 2 * OVERLAP1;

/**
*	Dimensions of the box, including its wall thickness
*/
BASE_THICKNESS = 2.4;

BOX_LENGTH = 100;
BOX_WIDTH = 70;
BOX_HEIGHT = 51;

/**
*	Always add some padding to these values
*/
BOLTS_DMTR = 3 + 0.8;
BOLTS_HEAD_HEIGHT = 2.0 + 1.0;
BOLTS_HEAD_DMTR = 6 + 1.5;

THREADED_NUTS_HEIGHT = 2.4 + 0.2;
THREADED_NUTS_DMTR = 5.5 + 1.2;


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
*	Usually not to be changed
*/
HOLDER_THICKNESS = 3.6;
HOLDER_HEIGHT = THREADED_NUTS_DMTR * 1.5;

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

/**
*	Attach single parts
*/
ATTACH_BOTTOM_PLATE = false;

ATTACH_BACK_SIDE = false;
ATTACH_FRONT_SIDE = false;

ATTACH_LEFT_SIDE = false;
ATTACH_RIGHT_SIDE = false;

/**
*	Z position for the holders holes and hexagons
*/
_holders_holes_z = THREADED_NUTS_DMTR / 2 + BASE_THICKNESS + ((HOLDER_HEIGHT - THREADED_NUTS_DMTR) / 2);
_holders_holes_side_margin = BASE_THICKNESS + HOLDER_THICKNESS + (THREADED_NUTS_DMTR / 1.5);

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
		// Plate
		cube([BOX_LENGTH, BOX_WIDTH, BASE_THICKNESS]);

		// Hole for the big red button
		translate([(BOX_LENGTH / 2 + 10), (BOX_WIDTH / 2), 0 - OVERLAP1])
		cylinder(h=BASE_THICKNESS + OVERLAP2, d=MUTE_BUTTON_HOLE_DMTR, center=false);
	}
	
	// Draw plate holders
	DrawPlateHolders();
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
			// Plate
			cube([BOX_LENGTH - (2 * BASE_THICKNESS), BOX_WIDTH - (2 * BASE_THICKNESS), BASE_THICKNESS]);
			
			translate([BASE_THICKNESS * (-1), BASE_THICKNESS * (-1), 0]) {
				difference() {
					// Draw plate holders
					DrawPlateHolders();
					
					// We need some recess for the DCV5
					_recess_width = 20;
					translate([BASE_THICKNESS - OVERLAP1, ((BOX_WIDTH - _recess_width) / 2) - DCV5_DRIFT, BASE_THICKNESS - OVERLAP1])
					cube([HOLDER_THICKNESS + OVERLAP2, 20, HOLDER_HEIGHT + OVERLAP2]);
				}
				
				// Draw the legs
				_leg_drift = HOLDER_HEIGHT / 1.75;
				
				_leg_width = HOLDER_HEIGHT * 1.5;
				_leg_depth = HOLDER_HEIGHT;
				_leg_height = HOLDER_THICKNESS;
				
				for(SIDE = [0, 1]) {
					_y = (SIDE == 0)
						? _leg_drift
						: (BOX_WIDTH - _leg_depth - _leg_drift);
					
					translate([_leg_drift, _y, _leg_height * (-1)])
					cube([_leg_width, _leg_depth, _leg_height]);
					
					translate([BOX_LENGTH - _leg_width - _leg_drift, _y, _leg_height * (-1)])
					cube([_leg_width, _leg_depth, _leg_height]);
				}
			}
		}
	}
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
									cylinder($fn=6, h=THREADED_NUTS_HEIGHT + OVERLAP1, d=THREADED_NUTS_DMTR, center=false);
									
									// Hole for the bolt
									cylinder($fn=20, h=HOLDER_THICKNESS + OVERLAP2, d=BOLTS_DMTR, center=false);
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
		: ([BOX_LENGTH + BOX_HEIGHT + DISASSEMBLED_PARTS_MARGIN, BOX_WIDTH, BASE_THICKNESS]);

	_rotation = (PUT_ALL_TOGETHER || ATTACH_FRONT_SIDE)
		? ([0, 0, 180])
		: ([0, 90, 180]);

	translate(_translation) {
		rotate(_rotation) {
			difference() {
				cube([BASE_THICKNESS, BOX_WIDTH, (BOX_HEIGHT - 1 * BASE_THICKNESS)]);
				
				// Illuminated text
				_top = ((BOX_HEIGHT - 2 * BASE_THICKNESS) / 2) * (-1);
				_left = BOX_WIDTH / 2;
				
				translate([BASE_THICKNESS - 0.4, 0, 0]) {
					rotate([-90, 0, 90]) {
						linear_extrude(BASE_THICKNESS)
						translate([_left, _top, 0])
						text("ON AIR", size=11, font="Bahnschrift:style=Bold", halign="center", valign="center");
						
						_length = (BOX_WIDTH / 1.5);
						translate([(BOX_WIDTH - _length) / 2, (_holders_holes_z + 8) * (-1), 0])
						cube([_length, 2.5, BASE_THICKNESS]);
						
						translate([(BOX_WIDTH - _length) / 2, ((BOX_HEIGHT - 1 * BASE_THICKNESS) - (_holders_holes_z + 8)) * (-1), 0])
						cube([_length, 2.5, BASE_THICKNESS]);
					}
					
				
				}
				
				rotate([90, 0, 90]) {
					// Mouting holes
					_DrawMountingHoles1();
				}
			}
		}
	}
}

/**
*	Left Side
*/
module DrawLeftSide() {
	_translation = (PUT_ALL_TOGETHER || ATTACH_LEFT_SIDE)
		? ([BOX_LENGTH - BASE_THICKNESS, BOX_WIDTH, BASE_THICKNESS])
		: ([BOX_LENGTH - BASE_THICKNESS, BOX_WIDTH + BOX_HEIGHT + DISASSEMBLED_PARTS_MARGIN, BASE_THICKNESS]);

	_rotation = (PUT_ALL_TOGETHER || ATTACH_LEFT_SIDE)
		? ([90, 0, -90])
		: ([0, 90, 180]);

	translate(_translation) {
		rotate(_rotation) {
			difference() {
				cube([BASE_THICKNESS, (BOX_HEIGHT - 1 * BASE_THICKNESS), (BOX_LENGTH - 2 * BASE_THICKNESS)]);
				
				rotate([90, 0, 90]) {
					// Mouting holes
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
				#cube([BASE_THICKNESS, (BOX_HEIGHT - 1 * BASE_THICKNESS), (BOX_LENGTH - 2 * BASE_THICKNESS)]);
				
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
module _DrawMountingHoles1() {
	for(s = [0, 1]) {
		_x = (s == 0)
			? _holders_holes_z - BASE_THICKNESS
			: (BOX_HEIGHT - BASE_THICKNESS - _holders_holes_z);
		_y = _holders_holes_side_margin;
		
		translate([_y, _x, 0 - OVERLAP1]) {
			cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=BOLTS_DMTR, center=false);
			cylinder($fn=20, h=BOLTS_HEAD_HEIGHT + OVERLAP2, d1=BOLTS_HEAD_DMTR, d2=0, center=false);
		}
		
		translate([(BOX_WIDTH - _y), _x, 0 - OVERLAP1]) {
			cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=BOLTS_DMTR, center=false);
			cylinder($fn=20, h=BOLTS_HEAD_HEIGHT + OVERLAP2, d1=BOLTS_HEAD_DMTR, d2=0, center=false);
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
			cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=BOLTS_DMTR, center=false);
			cylinder($fn=20, h=BOLTS_HEAD_HEIGHT + OVERLAP2, d1=BOLTS_HEAD_DMTR, d2=0, center=false);
		}
		
		translate([_x, (BOX_LENGTH - BASE_THICKNESS - _y), 0 - OVERLAP1]) {
			cylinder($fn=20, h=BASE_THICKNESS + OVERLAP2, d=BOLTS_DMTR, center=false);
			cylinder($fn=20, h=BOLTS_HEAD_HEIGHT + OVERLAP2, d1=BOLTS_HEAD_DMTR, d2=0, center=false);
		}
	}
}
