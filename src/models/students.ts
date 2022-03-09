
import { RequiredFieldsException, Model  } from '.';
import { parseNonNegInt, parseUsername } from './parsers';

export interface ParseableStudent {
	user_id?: number | string;
	course_id?: number | string;
	username?: string;
	first_name?: string;
	last_name?: string;
	student_id?: string;
}

export class Student extends Model {
	private _user_id = 0;
	private _course_id = 0;
	private _username = '';
	private _first_name = '';
	private _last_name = '';
	private _student_id = '';

	get all_field_names(): string[] {
		return Student.ALL_FIELDS;
	}

	get param_fields() { return []; }

	static ALL_FIELDS = ['user_id', 'course_id', 'username', 'first_name', 'last_name',
		'student_id'];

	constructor(params: ParseableStudent = {}) {
		super();
		this.set(params);
	}

	set(params: ParseableStudent) {
		if (params.user_id != undefined) this.user_id = params.user_id;
		if (params.course_id != undefined) this.course_id = params.course_id;
		if (params.username != undefined) this.username = params.username;
		if (params.first_name != undefined) this.first_name = params.first_name;
		if (params.last_name != undefined) this.last_name = params.last_name;
		if (params.student_id != undefined) this.student_id = params.student_id;
	}

	get user_id(): number { return this._user_id; }
	set user_id(value: string | number) {
		this._user_id = parseNonNegInt(value);
	}


	get course_id(): number { return this._course_id; }
	set course_id(value: string | number) {
		this._course_id = parseNonNegInt(value);
	}

	get username() { return this._username; }
	set username(value: string) {
		this._username = parseUsername(value);
	}

	get first_name() { return this._first_name; }
	set first_name(value: string) {
		this._first_name = value;
	}

	get last_name() { return this._last_name; }
	set last_name(value: string) {
		this._last_name = value;
	}

	get student_id() { return this._student_id; }
	set student_id(value: string) {
		this._student_id = value;
	}


	clone() {
		return new Student(this.toObject() as ParseableStudent);
	}
}
