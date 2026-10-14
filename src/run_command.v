module main

import os

fn run_command(cmd []string) {
    cfg := prepare_rootcmd()

    if cfg.path == '' {
        // already root
        os.execvp(cmd[0], cmd) or {
            eprintln('failed to exec ${cmd[0]}: ${err}')
            exit(127)
        }
    } else if cfg.is_run0 {
        os.execvp(cfg.path, [cfg.path, ...cfg.extra, '--', ...cmd]) or {
            eprintln('failed to exec ${cfg.path}: ${err}')
            exit(127)
        }
    } else {
        os.execvp(cfg.path, [cfg.path, ...cmd]) or {
            eprintln('failed to exec ${cfg.path}: ${err}')
            exit(127)
        }
    }
}
