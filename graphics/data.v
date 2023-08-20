module graphics

pub enum Layer as u8 {
	fg = 38
	bg = 48
	both
}

pub enum GraphicsMode as u8 {
	graphics = 109 // m
}

fn (e GraphicsMode) str() string {
	return u8(e).ascii_str()
}

pub enum Styles as u8 {
	reset_all = 0
	bold = 1
	dim = 2
	italic = 3
	underline = 4
	blink = 5
	reverse = 7
	invisible = 8
	strikethrough = 9
	reset_bold_and_dim = 22
	reset_italic = 23
	reset_underline = 24
	reset_blink = 25
	reset_reverse = 27
	reset_invisible = 28
	reset_strikethrough = 29
}

pub fn id_to_graphics(id u8) !Styles {
	if !((id >= 0 && id <= 5) || (id > 5 && id <= 9) || (id >= 20 && id <= 25)
		|| (id > 25 && id <= 29)) {
		return error('id not in Styles')
	}

	unsafe {
		return Styles(id)
	}
}

pub type RGB = []u8
pub type Color256ID = u8

pub enum Colors8 as u8 {
	black = 30
	dark_red = 31
	dark_green = 32
	dark_yellow = 33
	dark_blue = 34
	dark_magenta = 35
	dark_cyan = 36
	gray = 37
	red = 91
	green = 92
	yellow = 93
	blue = 94
	magenta = 95
	cyan = 96
	white = 97
	default = 39
}

pub type Colors = Color256ID | Colors8 | RGB

pub fn id_to_colors8_and_layer(id u8) !(Colors8, Layer) {
	if !((id >= 30 && id <= 37) || (id >= 40 && id <= 47) || id == 39 || id == 49) {
		return error('id not in Colors8')
	}

	mut layer := Layer.fg
	mut low_id := id

	if id >= 40 {
		layer = .bg
		low_id -= 10
	}

	unsafe {
		return Colors8(low_id), layer
	}
}

pub enum ClearMode as u8 {
	screen = 74 // J
	line = 75 // K
}

fn (e ClearMode) str() string {
	return u8(e).ascii_str()
}

pub enum ClearModeOpt as u8 {
	clear_in = 254
	from_cursor_to_end = 0
	from_cursor_to_start = 1
	all = 2
}

fn (e ClearModeOpt) str() string {
	if e == .clear_in {
		return ''
	}

	return u8(e).str()
}

fn (e ClearModeOpt) arg() ?u8 {
	if e == .clear_in {
		return none
	}

	return u8(e)
}
