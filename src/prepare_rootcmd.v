module main

import os

fn prepare_rootcmd() {
	mut is_run0 := 0
	mut run0_extra := ''
	mut rootcmd := ''
	mut tint := 0

	if _ := os.getenv_opt('NO_COLOR') {
		// it's set, nothing to do
	} else if os.getenv('TERM') != 'dumb' && os.is_atty(1) == 1 {
		match os.getenv('SYSTEMD_TINT_BACKGROUND') {
			'0', 'false', 'no', 'off' { }
			else { tint=1 }
		}
	}
	println('${tint}')
	println('hello gronks')
}
