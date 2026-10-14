module main

import os

fn check() {
	if os.getuid() == 0 {
		println(r"we're already running as root!")
		exit(0)
	}
	for prog in escalators {
        path := os.find_abs_path_of_executable(prog) or { '' }
        if path != '' && os.is_executable(path) {
            println('found ${prog}: ${path}')
        } else {
            println(r"didn't find" + ' ${prog}')
        }
    }

}
