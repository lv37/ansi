module graphics

import esc

pub fn color(color Colors, layer Layer) !string {
	match color {
		Colors8 { return color8(color, layer) }
		Color256ID { return color256(color, layer) }
		RGB { return rgb(color, layer)! }
	}
}

pub fn rgb(rgb RGB, layer Layer) !string {
	if rgb.len != 3 {
		return error('rgb must be in format [r,g,b]u8')
	}

	match layer {
		.both {
			return
				esc.csi(GraphicsMode.graphics.str(), [u8(Layer.fg), 2, rgb[0], rgb[1], rgb[2]]) +
				esc.csi(GraphicsMode.graphics.str(), [u8(Layer.bg), 2, rgb[0], rgb[1], rgb[2]])
		}
		else {}
	}

	return esc.csi(GraphicsMode.graphics.str(), [u8(layer), 2, rgb[0], rgb[1], rgb[2]])
}

pub fn color256(color Color256ID, layer Layer) string {
	return esc.csi(GraphicsMode.graphics.str(), [u8(layer), 5, color % 256])
}

pub fn color8(color Colors8, layer Layer) string {
	color_u8 := u8(color)
	if !((color_u8 >= 30 && color_u8 <= 37) || (color_u8 >= 40 && color_u8 <= 47)
		|| color_u8 == 39 || color_u8 == 49) {
		panic('invalid id') // should be impossible
	}

	mut typed_color_id := color_u8

	if color_u8 >= 40 {
		match layer {
			.fg, .both { typed_color_id -= 10 }
			else {}
		}
	} else {
		match layer {
			.bg { typed_color_id += 10 }
			else {}
		}
	}

	mut out := esc.csi(GraphicsMode.graphics.str(), [typed_color_id])

	match layer {
		.both { out += esc.csi(GraphicsMode.graphics.str(), [typed_color_id + 10]) }
		else {}
	}

	return out
}

pub fn style(g Styles) string {
	return esc.csi(GraphicsMode.graphics.str(), [u8(g)])
}

pub fn clear(opt ClearModeOpt, mode ClearMode) {
	mut args := []u8{}
	opt_arg := opt.arg()
	if opt_arg != none {
		args << opt_arg
	}
	print(esc.csi(mode.str(), args))
}
