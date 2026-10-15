module main

import os

fn resolve_user_command(cmd []string) []string {
	if cmd.len == 0 {
		eprintln('No command given')
		exit(1)
	}
	name := cmd[0]
	mut resolved := ''
	if name.contains('/') {
		resolved = os.real_path(name)
		if !os.is_executable(resolved) {
			eprintln('runroot: `${name}`: command not found or not executable')
			exit(127)
		}
	} else {
		resolved = os.find_abs_path_of_executable(name) or {
			eprintln('runroot: `${name}`: command not found')
			exit(127)
		}
	}
	return [resolved, ...cmd[1..]]
}
