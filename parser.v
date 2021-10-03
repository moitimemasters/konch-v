module parser

import os

import tokens { Keyword, Operation, Comparative, Token, KId, ArgType } 
import operations { KeywordType }
// pub type LexicalToken = string

struct KWPair {
	pub mut:
		kw  Keyword [required]
		pos int [required]
}

pub fn parse_operation(token string) ?Operation {
	match token {
		'pop' { return tokens.pop() }
		'dup' { return tokens.dup() }
		'swap' { return tokens.swap() }
		'dump' { return tokens.dump_() }
		'+' { return tokens.plus() }
		'-' { return tokens.minus() }
		'*' { return tokens.mul() }
		'div' { return tokens.div() }
		'mod' { return tokens.mod() }
		'blank' { return tokens.blank() }
		else { return none }
	}
	return none
}

pub fn parse_comparative(token string) ?Comparative {
	match token {
		'==' { return tokens.equal() }
		'!=' { return tokens.not_eq() }
		'>' { return tokens.greater() }
		'<' { return tokens.less() }
		'>=' { return tokens.greater_eq() }
		'<=' { return tokens.less_eq() }
		'and' { return tokens.and_() }
		'or' { return tokens.or_() }
		else { return none }
	}
}

pub fn parse_keyword(token string, id KId) ?Keyword {
	match token {
		'do' { return tokens.do(id) }
		'end' { return tokens.end(id) }
		'while' { return tokens.while(id) }
		'else' { return tokens.else_(id) }
		'defer' { return tokens.defer_(id) }
		else { return none }
	}
}

pub fn read_program_file(filename string) ?[]string {
	file := os.read_file(filename) or { panic(err.msg) }
	only_space_delimeter := file.replace_each(['\n', ' ', '\t', ' ', '\r', ' '])
	return only_space_delimeter.split(' ').filter(it != '')
	//return ["not implemeted yet"]
}

pub fn parse_argument(token string) ?Operation {
	if token.bytes().all(it.is_digit()) {
		return tokens.push(ArgType(token.i64()))
	} else {
		return none
	}
}

pub fn parse_program(lexical_tokens []string) ?[]Token {
	mut program := []Token{}
	mut keywords_stack := []int{}
	mut current_keyword := i64(0)
	for i, token in lexical_tokens {
		// mut parse_ok := true
		if parsed := parse_argument(token) {
			program << parsed
		} else if parsed := parse_operation(token) {
			program << parsed
		} else if parsed := parse_comparative(token) {
			program << parsed
		} else if parsed := parse_keyword(token, current_keyword) {
			mut p := parsed
			match token {
				'while', 'do', 'else' {
					keywords_stack << i
					current_keyword++
					program << parsed
				}
				'end' {
					last_keyword_pos := keywords_stack.pop()
					mut last_keyword := program[last_keyword_pos] as Keyword
					if int(last_keyword.type_) == int(KeywordType.else_) {
						last_keyword.references = parsed.id
						//program[last_keyword_pos] = last_keyword
						do_keyword_pos := keywords_stack.pop()
						mut do_keyword := program[do_keyword_pos] as Keyword
						if int(do_keyword.type_) == int(KeywordType.do) {
							do_keyword.otherwise = last_keyword.id
							last_keyword.references = parsed.id
						} else {
							error("Expected `do` keyword before `else` ")
						}
						program[do_keyword_pos] = do_keyword
					//	program[last_keyword_pos] = last_keyword
					} else if int(last_keyword.type_) == int(KeywordType.do) {
						last_keyword.otherwise = parsed.id
						if keywords_stack.len > 0 {
							while_keyword_pos := keywords_stack.pop()
							mut while_keyword := program[while_keyword_pos] as Keyword
							if int(while_keyword.type_) == int(KeywordType.while) {
								p.references = while_keyword.id
							} else {
								keywords_stack << while_keyword_pos
							}
						}
					} else {
						error("Expected `do` or `else` before `end`")
					}
					program[last_keyword_pos] = last_keyword
					current_keyword++
					program << p
				}
				else {
					program << parsed
					current_keyword++
				}
			}
		} else {
			return error("unexpected ident `${token}`")
		}

	}
	return program
}
