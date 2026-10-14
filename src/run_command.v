module main

import os

fn exec_or_exit(path string, args []string) {
    os.execvp(path, args) or {
        eprintln('failed to exec ${path}: ${err}')
        exit(127)
    }
}

fn run_command_root(cmd []string) {
    exec_or_exit(cmd[0], cmd)
}

fn run_command_run0(cfg RootCmd, cmd []string) {
    exec_or_exit(cfg.path, [cfg.path, ...cfg.extra, '--', ...cmd])
}

fn run_command_other(cfg RootCmd, cmd []string) {
    exec_or_exit(cfg.path, [cfg.path, ...cmd])
}

fn run_command(cmd []string) {
	cfg := prepare_rootcmd()

    if cfg.path == '' {
        // already root
		run_command_root(cmd)
    } else if cfg.is_run0 {
		run_command_run0(cfg, cmd)
    } else {
    	run_command_other(cfg, cmd)
	}
}
