import {  Model  } from '.';
import { parseNonNegInt } from './parsers';

export interface ParseableLearningObjective {
	obj_id?: number | string;
	category_id?: number | string;
	number?: string | number;
	description?: string;
}

export class LearningObjective extends Model {
	private _obj_id = 0;
	private _category_id = 0;
	private _number = 0;
	private _description = '';

	get all_field_names(): string[] {
		return LearningObjective.ALL_FIELDS;
	}

	get param_fields(): string [] { return []; }

	static ALL_FIELDS = ['obj_id', 'category_id', 'number', 'description'];

	constructor(params: ParseableLearningObjective = {}) {
		super();
		this.set(params);
	}

	set(params: ParseableLearningObjective) {
		if (params.obj_id != undefined) this.obj_id = params.obj_id;
		if (params.category_id != undefined) this.category_id = params.category_id;
		if (params.number != undefined) this.number = params.number;
		if (params.description != undefined) this.description = params.description;
	}

	get obj_id(): number { return this._obj_id; }
	set obj_id(value: string | number) {
		this._obj_id = parseNonNegInt(value);
	}

	get category_id(): number { return this._category_id; }
	set category_id(value: string | number) {
		this._category_id = parseNonNegInt(value);
	}

	get number() { return this._number; }
	set number(value: string | number) {
		this._number = parseNonNegInt(value);;
	}

	get description() { return this._description; }
	set description(value: string) {
		this._description = value;
	}

	clone() {
		return new LearningObjective(this.toObject() as ParseableLearningObjective);
	}
}
