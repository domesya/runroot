module main

import os

const def_color = '48;2;64;0;0'
// const reset_color = '\x1b[0m'
const escalators = ['run0', 'pkexec', 'lxqt-sudo', 'doas', 'sudo']

fn help(prog_name string) {
	println(r"
                             _
  _ _ _  _ _ _  _ _ ___  ___| |_
 | '_| || | ' \| '_/ _ \/ _ \  _|
 |_|  \_,_|_||_|_| \___/\___/\__|
" + "
${prog_name}  --  a utility for running commands as root

[ options ]:
    -h, -H, --help    show this message

[ usage ]:
    Just give a command you want to run as root, examples:

    ${prog_name} echo" + r' "hello from root"' + "
    ${prog_name} apt update
    ${prog_name} nano /etc/hosts
	")
}

fn parse_arguments(prog_name string) {
	args := os.args[1..]

	if args.len == 0 {
		help(prog_name)
		exit(1)
	}

	match args[0] {
		'-h', '-H', '--help' {
			help(prog_name)
			exit(0)
		}
		'--check' {
			check()
			exit(0)
		}
		'--' {
			if args.len == 1 {
				eprintln('error: `--` given but no command')
				exit(1)
			}
			run_command(args[1..])
		}
		else {
			if args[0].starts_with('-') {
				eprintln('error: unknown option `${args[0]}`')
				eprintln('pass --help instead')
				exit(1)
			}
			run_command(args[0..])
		}
	}
}

fn ensure_env(name string, default_val string) {
	if _ := os.getenv_opt(name) {
		return // present, even if '' -> leave alone
	}
	os.setenv(name, default_val, false)
}

fn main() {
	// Get the full path of the running binary
	exe_path := os.executable()
	prog_name := os.file_name(exe_path)
	ensure_env('RUNROOT_BACKGROUND', '${def_color}')
	parse_arguments(prog_name)
}
