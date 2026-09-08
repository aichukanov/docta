import { defineStore } from 'pinia';
import type { SchemaOrg } from '~/types/schema-org';

export const useSchemaOrgStore = defineStore('schemaOrg', () => {
	// shallowRef: массив схем всегда заменяется целиком (setSchemas/clearSchemas),
	// внутрь узлов никто не пишет — app.vue только читает их и сериализует в
	// JSON-LD. Глубокая реактивность оборачивала бы в прокси весь вложенный граф
	// schema.org (Organization, offers, breadcrumbs) на каждой странице ради
	// одной подписки на замену массива.
	const schemas = shallowRef<SchemaOrg[]>([]);

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
