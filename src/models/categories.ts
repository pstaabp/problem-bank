import {  Model  } from '.';
import { parseNonNegInt } from './parsers';

export interface ParseableCategory {
	category_id?: number | string;
	course_id?: number | string;
	label?: string;
	description?: string;
}

export class Category extends Model {
	private _category_id = 0;
	private _course_id = 0;
	private _label = '';
	private _description = '';

	get all_field_names(): string[] {
		return Category.ALL_FIELDS;
	}

	get param_fields() { return []; }

	static ALL_FIELDS = ['category_id', 'course_id', 'label', 'description'];

	constructor(params: ParseableCategory = {}) {
		super();
		this.set(params);
	}

	set(params: ParseableCategory) {
		if (params.category_id != undefined) this.category_id = params.category_id;
		if (params.course_id != undefined) this.course_id = params.course_id;
		if (params.label != undefined) this.label = params.label;
		if (params.description != undefined) this.description = params.description;
	}

	get category_id(): number { return this._category_id; }
	set category_id(value: string | number) {
		this._category_id = parseNonNegInt(value);
	}

	get course_id() { return this._course_id; }
	set course_id(value: string | number) {
		this._course_id = parseNonNegInt(value);
	}

	get label() { return this._label; }
	set label(value: string) {
		this._label = value;
	}

	get description() { return this._description; }
	set description(value: string) {
		this._description = value;
	}

	clone() {
		return new Category(this.toObject() as ParseableCategory);
	}
}
