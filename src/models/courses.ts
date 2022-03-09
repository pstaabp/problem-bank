import { RequiredFieldsException, Model  } from '.';
import { parseNonNegInt } from './parsers';

export interface ParseableCourse {
	course_id?: number | string;
	course_name?: string;
	semester?: string;
}

export class Course extends Model {
	private _course_id = 0;
	private _course_name = '';
	private _semester = '';

	get all_field_names(): string[] {
		return Course.ALL_FIELDS;
	}

	static ALL_FIELDS = ['course_id', 'course_name', 'semester'];

	constructor(params: ParseableCourse = {}) {
		super();
		if (params.course_name == undefined) {
			throw new RequiredFieldsException('course_name');
		}
		this.set(params);
	}

	set(params: ParseableCourse) {
		if (params.course_id != undefined) this.course_id = params.course_id;
		if (params.course_name != undefined) this.course_name = params.course_name;
		if (params.semester != undefined) this.semester = params.semester;
	}

	get course_id(): number { return this._course_id; }
	set course_id(value: string | number) {
		this._course_id = parseNonNegInt(value);
	}

	get course_name() { return this._course_name; }
	set course_name(value: string) {
		this._course_name = value;
	}

	get semester() { return this._semester; }
	set semester(value: string) {
		this._semester = value;
	}

	clone() {
		return new Course(this.toObject() as ParseableCourse);
	}
}
