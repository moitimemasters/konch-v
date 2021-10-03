module operations

pub enum OperationType {
	push
	pop
	dump_
	plus
	minus
	mul
	div
	mod
	dup
	swap
	blank
}

pub enum KeywordType {
	while
	do
	end
	else_
	defer_
}

pub enum ComparativeType {
	less
	greater
	equal
	less_eq
	greater_eq
	not_eq
	and_
	or_
}
