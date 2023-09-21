module cursor

import math
import esc

pub enum CursorMode as u8 {
	go_home                     = 72 // H
	go_to_xy                    = 102 // f
	move_up                     = 65 // A
	move_down                   = 66 // B
	move_right                  = 67 // C
	move_left                   = 68 // D
	move_down_and_start_of_line = 69 // E
	move_up_and_start_of_line   = 70 // F
	go_column                   = 71 // G
	get_position                = 110 // 6n // just n
	scroll_up                   = 77 // M
	dec_save_pos                = 55 // 7
	dec_restore_saved_pos       = 56 // 8
	sco_save_pos                = 115 // s
	sco_restore_saved_pos       = 117 // u
}

fn (e CursorMode) str() string {
	return u8(e).ascii_str()
}

fn cursor(mode CursorMode, args ?esc.Args) {
	print(esc.csi(mode.str(), args))
}

pub fn home() {
	cursor(.go_home, none)
}

pub fn go_to(x u16, y ?u16) {
	if y != none {
		cursor(.go_to_xy, [y or { 0 } + 1, x + 1])
	} else {
		cursor(.go_column, [x + 1])
	}
}

pub fn move_y_and_start_of_line(dy i16) {
	up := dy < 0

	abs_dy := u16(math.abs(dy))
	move_y := if up {
		CursorMode.move_up_and_start_of_line
	} else {
		CursorMode.move_down_and_start_of_line
	}

	cursor(move_y, [abs_dy])
}

pub fn move(dx i16, dy i16) {
	left := dx < 0
	up := dy < 0

	if dx != 0 {
		abs_dx := u16(math.abs(dx))
		move_x := if left { CursorMode.move_left } else { CursorMode.move_right }

		cursor(move_x, [abs_dx])
	}
	if dy != 0 {
		abs_dy := u16(math.abs(dy))
		move_y := if up { CursorMode.move_up } else { CursorMode.move_down }

		cursor(move_y, [abs_dy])
	}
}

pub fn scroll_up() {
	print(esc.no_seq(CursorMode.scroll_up.str(), none))
}

pub fn dec_save_pos() {
	print(esc.no_seq(CursorMode.dec_save_pos.str(), none))
}

pub fn dec_restore_saved_pos() {
	print(esc.no_seq(CursorMode.dec_restore_saved_pos.str(), none))
}

pub fn sco_save_pos() {
	cursor(.sco_save_pos, none)
}

pub fn sco_restore_saved_pos() {
	cursor(.sco_restore_saved_pos, none)
}

// write position to stdin
pub fn request_pos() {
	cursor(.get_position, [u8(6)])
}
