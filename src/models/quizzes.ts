import { RequiredFieldsException, Model  } from '.';
import { parseBoolean, parseNonNegInt } from './parsers';

export interface ParseableQuiz {
	course_id?: number | string;
	quiz_id?: number | string;
	redo_quiz?: number | string | boolean;
	quiz_name?: string;
}

export class Quiz extends Model {
	private _quiz_id = 0;
	private _course_id = 0;
	private _redo_quiz = false;
	private _quiz_name = '';

	get all_field_names(): string[] {
		return Quiz.ALL_FIELDS;
	}

	get param_fields() { return []; }

	static ALL_FIELDS = ['quiz_id', 'course_id', 'redo_quiz', 'quiz_name'];

	constructor(params: ParseableQuiz = {}) {
		super();
		this.set(params);
	}

	set(params: ParseableQuiz) {
		if (params.quiz_id != undefined) this.quiz_id = params.quiz_id;
		if (params.course_id != undefined) this.course_id = params.course_id;
		if (params.quiz_name != undefined) this.quiz_name = params.quiz_name;
		if (params.redo_quiz != undefined) this.redo_quiz = params.redo_quiz;
	}

	get quiz_id(): number { return this._quiz_id; }
	set quiz_id(value: string | number) {
		this._quiz_id = parseNonNegInt(value);
	}

	get course_id(): number { return this._course_id; }
	set course_id(value: string | number) {
		this._course_id = parseNonNegInt(value);
	}

	get redo_quiz() { return this._redo_quiz; }
	set redo_quiz(value: string | number | boolean) {
		this._redo_quiz = parseBoolean(value);
	}

	get quiz_name() { return this._quiz_name; }
	set quiz_name(value: string) {
		this._quiz_name = value;
	}

	clone() {
		return new Quiz(this.toObject() as ParseableQuiz);
	}
}
