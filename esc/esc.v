module esc

pub enum Sequence as u8 {
	csi = 91
	dcs = 80
	osc = 93
}

pub type Args = []u16 | []u8

@[inline]
fn (e Sequence) str() string {
	return u8(e).ascii_str()
}

pub fn esc(seq ?Sequence, mode string, args ?Args) string {
	seq_str := seq.str()
	a := args or { return '\x1b' + seq_str + mode } // compiler bug workaround
	args_str := match a {
		[]u8 { a.map(it.str()).join(';') }
		[]u16 { a.map(it.str()).join(';') }
	}
	return '\x1b' + seq_str + args_str + mode
}

@[inline]
pub fn csi(mode string, args ?Args) string {
	return esc(Sequence.csi, mode, args)
}

@[inline]
pub fn dcs(mode string, args ?Args) string {
	return esc(Sequence.dcs, mode, args)
}

@[inline]
pub fn osc(mode string, args ?Args) string {
	return esc(Sequence.osc, mode, args)
}

@[inline]
pub fn no_seq(mode string, args ?Args) string {
	return esc(none, mode, args)
}
