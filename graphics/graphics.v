module graphics

pub fn color(color Colors, layer Layer) !string {
	match color {
		Colors8 { return color8(color, layer) }
		Color256ID { return color256(color, layer) }
		RGB { return rgb(color, layer)! }
	}
}

pub fn rgb(r u8, g u8, b u8, layer Layer) !string {
	return if layer == .both {
		'\x1b[38;2;' + r + ';' + g + ';' + b + 'm' + '\x1b[48;2;' +
			r + ';' + g + ';' + b + 'm'
	} else {
		'\x1b[' + u8(layer).str() + ';2;' + r + ';' + g + ';' + b + 'm'
	}
}

pub fn color256(color Color256ID, layer Layer) string {
	return '\x1b[' + u8(layer).str() + '5' + (color % 256).str() + 'm'
}

pub fn color8(color Colors8, layer Layer) string {
	color_u8 := u8(color)
	return if color_u8 > 39 && color_u8 < 91 {
		if layer == .fg {
			'\x1b[' + (color_u8 - 10).str() + 'm'
		} else if layer == .both {
			'\x1b[' + (color_u8 - 10).str() + 'm\x1b[' + color_u8.str() + 'm'
		} else {
			'\x1b[' + color_u8.str() + 'm'
		}
	} else if layer == .bg {
		'\x1b[' + (color_u8 + 10).str() + 'm'
	} else if layer == .both {
		'\x1b[' + (color_u8 + 10).str() + 'm\x1b[' + color_u8.str() + 'm'
	} else {
		'\x1b[' + color_u8.str() + 'm'
	}
}

pub fn style(g Styles) string {
	return '\x1b[' + u8(g).str() + 'm'
}

pub fn clear(opt ClearModeOpt, mode ClearMode) {
	print('\x1b[' + opt.str() + mode.str())
}

pub fn reset_scroll() {
	print('\x1b[3J')
}
