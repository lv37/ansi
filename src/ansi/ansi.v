module ansi

pub enum Sequence as u8 {
	csi = 91
	dcs = 80
	osc = 93
}

pub type Args = []u8 | []u16

fn (e Sequence) str() string {
	return u8(e).ascii_str()
}

pub fn esc(seq ?Sequence, mode string, args ?Args) string {
	seq_str := seq.str()
	args_str :=
		match typeof(args).name {
			'[]u8' { (args as []u8).map(it.str()).join(';') }
			'[]u16' { (args as []u16).map(it.str()).join(';') }
			else { '' }
		}

	return '\x1b' + seq_str + args_str + mode
}

pub fn csi(mode string, args ?Args) string {
	return esc(Sequence.csi, mode, args)
}

pub fn dcs(mode string, args ?Args) string {
	return esc(Sequence.dcs, mode, args)
}

pub fn osc(mode string, args ?Args) string {
	return esc(Sequence.osc, mode, args)
}

pub fn no_seq(mode string, args ?Args) string {
	return esc(none, mode, args)
}
