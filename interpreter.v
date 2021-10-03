module interpreter

import operations { OperationType, KeywordType, ComparativeType }
import tokens { ArgType, Token, Operation, Keyword, Comparative, KId }

fn map_keywords(program []Token) map[KId]int {
	mut m := map[KId]int{}
	for ct := 0; ct < program.len; ct++ {
		op := program[ct]
		if op is Keyword {
			m[op.id] = ct
		}
	}
	return m
}

pub fn simulate_program(program []Token) {
	mut stack := []ArgType{}
	goto_map := map_keywords(program)
	for current_token := 0; current_token < program.len; current_token++ {
		op := program[current_token]
		// println(stack)
		match op {
			Operation {
				match op.type_ {
					.blank {
						println("")
					}
					.push {
						stack << ArgType(op.arg)
					}
					.pop {
						stack.delete_last()
					}
					.dump_ {
						value := stack.pop()
						println("${i64(value)}")
					}
					.plus {
						a := stack.pop()
						b := stack.pop()
						stack << (b + a)
					}
					.minus {
						a := stack.pop()
						b := stack.pop()
						stack << (b - a)
					}
					.mul {
						a := stack.pop()
						b := stack.pop()
						stack << (b * a)
					}
					.div {
						a := stack.pop()
						b := stack.pop()
						stack << (b / a)
					}
					.mod {
						a := stack.pop()
						b := stack.pop()
						stack << (b % a)
					}
					.dup {
						a := stack.pop()
						stack << a
						stack << a
					}
					.swap {
						a := stack.pop()
						b := stack.pop()
						stack << a
						stack << b
					}
					// else { dump(op) error("this shouldn't have ever happened") }
			}
		}
		Keyword {
			match op.type_ {
				.do {
					a := stack.pop()
					if a != 0 {
						current_token = goto_map[op.references]
					} else {
						current_token = goto_map[op.otherwise]
					}
				}
				.end, .while, .else_ {
					current_token = goto_map[op.references]
				}
				.defer_ {
					println("defer keyword")
					error("defer keyword is not implemented yet(((")
				}
				// else { dump(op) error("this shouldn't have ever happaned") }
			}
		}

		Comparative {
			match op.type_ {
				.equal {
					a := stack.pop()
					b := stack.pop()
					if a == b {
						stack << 1
					} else {
						stack << 0
					}
				}
				.not_eq {
					a := stack.pop()
					b := stack.pop()
					if a == b {
						stack << 0
					} else {
						stack << 1
					}
				}
				.less {
					a := stack.pop()
					b := stack.pop()
					if b < a {
						stack << 1
					} else {
						stack << 0
					}
				}
				.greater {
					a := stack.pop()
					b := stack.pop()
					if b > a {
						stack << 1
					} else {
						stack << 0
					}
				}
				.less_eq {
					a := stack.pop()
					b := stack.pop()
					if b <= a {
						stack << 1
					} else {
						stack << 0
					}
				}
				.greater_eq {
					a := stack.pop()
					b := stack.pop()
					if b >= a {
						stack << 1
					} else {
						stack << 0
					}
				}
				.and_ {
					a := stack.pop()
					b := stack.pop()
					if a != 0 && b != 0 {
						stack << 1
					} else {
						stack << 0
					}
				}
				.or_ {
					a := stack.pop()
					b := stack.pop()
					if b != 0 || a != 0 {
						stack << 1
					} else {
						stack << 0
					}
				}
			}
		}
		// else {}
		}
	}
}
