// Leaflet подключается скриптом и доступен как window.L (см. composables/use-leaflet.ts)
declare global {
	interface Window {
		L: typeof import('leaflet');
	}
}

export {};
