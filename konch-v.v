module main

import os

import tokens { Token }

import parser { read_program_file, parse_program }
import interpreter { simulate_program }

fn main() {
	// println(os.args)
	// program := [Token(tokens.push(i64(69))), Token(tokens.dump_())]
	// simulate_program(program)
	if os.args.len != 2 {
		panic("You must run produce program file path and nothing else")
	}
	file_path := os.args[1]
	lexical_tokens := read_program_file(file_path) or {panic("some err happened")}
	// println(lexical_tokens)
	parsed_program := parse_program(lexical_tokens) or { panic(err.msg) }
	// println(parsed_program)
	simulate_program(parsed_program)
}
