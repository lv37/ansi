module cursor

import math
import esc

@[inline]
pub fn home() {
	print('\x1b[H')
}

pub fn go_to(x u16, y ?u16) {
	if y != none {
		print('\x1b[' + (y or { 0 } + 1).str() + ';' + (x + 1).str() + 'f')
	} else {
		print('\x1b[' + (x + 1).str() + 'G')
	}
}

pub fn move_y_and_start_of_line(dy i16) {
	up := dy < 0

	abs_dy := u16(math.abs(dy))
	move_y := if up { 'F' } else { 'E' }

	print('\x1b[' + abs_dy.str() + move_y)
}

pub fn move(dx i16, dy i16) {
	left := dx < 0
	up := dy < 0

	if dx != 0 {
		abs_dx := u16(math.abs(dx))
		move_x := if left { 'D' } else { 'C' }

		print('\x1b[' + abs_dx.str() + move_x)
	}
	if dy != 0 {
		abs_dy := u16(math.abs(dy))
		move_y := if up { 'A' } else { 'B' }

		print('\x1b[' + abs_dy.str() + move_y)
	}
}

@[inline]
pub fn scroll_up() {
	print(esc.no_seq('M', none))
}

@[inline]
pub fn dec_save_pos() {
	print(esc.no_seq('7', none))
}

@[inline]
pub fn dec_restore_saved_pos() {
	print(esc.no_seq('8', none))
}

@[inline]
pub fn sco_save_pos() {
	print('\x1b[s')
}

@[inline]
pub fn sco_restore_saved_pos() {
	print('\x1b[u')
}

// write position to stdin
@[inline]
pub fn request_pos() {
	print('\x1b[6n')
}
