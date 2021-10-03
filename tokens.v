module tokens
import operations { OperationType, KeywordType, ComparativeType }

pub type ArgType = i64

pub type KId = u64

pub struct Operation {
	pub: type_ OperationType [required]
	arg ArgType
}

pub struct Keyword {
	pub:
		type_ KeywordType [required]
		id KId [required]
	pub mut:
		references KId
		otherwise KId
}

pub struct Comparative {
	pub: type_ ComparativeType [required]
}

pub type Token = Operation | Keyword | Comparative

pub fn blank() Operation {
	return Operation{ type_: OperationType.blank }
}

pub fn push(x ArgType) Operation {
	return Operation{type_: OperationType.push, arg: x}
}

pub fn pop() Operation {
	return Operation{ type_: OperationType.pop }
}

pub fn dump_() Operation {
	return Operation{ type_: OperationType.dump_ }
}

pub fn plus() Operation {
	return Operation{ type_: OperationType.plus }
}

pub fn minus() Operation {
	return Operation{ type_: OperationType.minus }
}

pub fn mul() Operation {
	return Operation{ type_: OperationType.mul }
}

pub fn div() Operation {
	return Operation{ type_: OperationType.div }
}

pub fn mod() Operation {
	return Operation { type_: OperationType.mod }
}

pub fn dup() Operation {
	return Operation { type_: OperationType.dup }
}

pub fn swap() Operation {
	return Operation { type_: OperationType.swap }
}

pub fn do(id KId) Keyword {
	return Keyword { type_: KeywordType.do, id: id, references: id, otherwise: id }
}

pub fn end(id KId) Keyword {
	return Keyword { type_: KeywordType.end, id: id, references: id }
}

pub fn while(id KId) Keyword {
	return Keyword { type_: KeywordType.while, id: id, references: id }
}

pub fn else_(id KId) Keyword {
	return Keyword { type_: KeywordType.else_, id: id, references: id  }
}

pub fn defer_(id KId) Keyword {
	return Keyword { type_: KeywordType.defer_, id: id }
}

pub fn and_() Comparative {
	return Comparative { type_: ComparativeType.and_ }
}

pub fn or_() Comparative {
	return Comparative { type_: ComparativeType.or_ }
}

pub fn equal() Comparative {
	return Comparative { type_: ComparativeType.equal }
}

pub fn not_eq() Comparative {
	return Comparative { type_: ComparativeType.not_eq }
}

pub fn greater() Comparative {
	return Comparative { type_: ComparativeType.greater }
}

pub fn less() Comparative {
	return Comparative { type_: ComparativeType.less }
}

pub fn greater_eq() Comparative {
	return Comparative { type_: ComparativeType.greater_eq }
}

pub fn less_eq() Comparative { 
	return Comparative { type_: ComparativeType.less_eq }
}
