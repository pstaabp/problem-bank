import {  Model  } from '.';
import { parseNonNegInt } from './parsers';

export interface ParseableProblem {
	problem_id?: number | string;
	course_id?: number | string;
	source?: string;
	description?: string;
}

export class Problem extends Model {
	private _problem_id = 0;
	private _course_id = 0;
	private _source = '';
	private _description = '';

	get all_field_names(): string[] {
		return Problem.ALL_FIELDS;
	}

	get param_fields() { return []; }

	static ALL_FIELDS = ['problem_id', 'course_id', 'source', 'description'];

	constructor(params: ParseableProblem = {}) {
		super();
		this.set(params);
	}

	set(params: ParseableProblem) {
		if (params.problem_id != undefined) this.problem_id = params.problem_id;
		if (params.course_id != undefined) this.course_id = params.course_id;
		if (params.source != undefined) this.source = params.source;
		if (params.description != undefined) this.description = params.description;
	}

	get problem_id(): number { return this._problem_id; }
	set problem_id(value: string | number) {
		this._problem_id = parseNonNegInt(value);
	}

	get course_id() { return this._course_id; }
	set course_id(value: string | number) {
		this._course_id = parseNonNegInt(value);
	}

	get source() { return this._source; }
	set source(value: string) {
		this._source = value;
	}

	get description() { return this._description; }
	set description(value: string) {
		this._description = value;
	}

	clone() {
		return new Problem(this.toObject() as ParseableProblem);
	}
}
