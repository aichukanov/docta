import { defineStore } from 'pinia';
import type { SchemaOrg } from '~/types/schema-org';

export const useSchemaOrgStore = defineStore('schemaOrg', () => {
	const schemas = ref<SchemaOrg[]>([]);

	const setSchemas = (newSchemas: SchemaOrg | SchemaOrg[]) => {
		schemas.value = Array.isArray(newSchemas) ? newSchemas : [newSchemas];
	};

	const clearSchemas = () => {
		schemas.value = [];
	};

	return {
		schemas,
		setSchemas,
		clearSchemas,
	};
});
