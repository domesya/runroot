module main

import os

struct RootCmd {
	path string
	is_run0 bool
	extra []string
}

fn prepare_rootcmd() RootCmd {
	mut tint := 0

	if _ := os.getenv_opt('NO_COLOR') {
		// it's set, nothing to do
	} else if os.getenv('TERM') != 'dumb' && os.is_atty(1) == 1 {
		match os.getenv('SYSTEMD_TINT_BACKGROUND') {
			'0', 'false', 'no', 'off' { }
			else { tint=1 }
		}
	}

	if os.geteuid() == 0 {
    	// running as root
		return RootCmd{ path: '', is_run0: false, extra: [] }
	}

	for prog in ['run0', 'pkexec', 'lxqt-sudo', 'doas', 'sudo'] {
        path := os.find_abs_path_of_executable(prog) or { continue }
        if prog == 'run0' {
            mut extra := []string{}
            match tint {
                0 { extra << '--background=' }
                1 { extra << '--background=${os.getenv('RUNROOT_BACKGROUND')}' }
                else {}
            }
            extra << '--via-shell'
            return RootCmd{ path: path, is_run0: true, extra: extra }
        }
        return RootCmd{ path: path, is_run0: false, extra: [] }
    }

	eprintln('No tool found, cannot escalate!')
	exit(1)
}
