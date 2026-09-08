/**
 * Подписи для контролов дизайн-системы (`Clear`, `Loading`, `NothingFound`,
 * `Close`). Они живут в глобальном словаре `i18n/ui.ts`, потому что нужны
 * на любой странице.
 *
 * Зачем отдельный композабл, а не обычный `t` компонента: большинство
 * компонентов проекта подключают i18n локальной областью
 * (`useI18n(someI18n)` / `useI18n({ useScope: 'local', messages })`), и
 * глобальные ключи оттуда НЕ видны — проверено, vue-i18n пишет в консоль
 * «[intlify] Not found 'NothingFound' key». Поэтому здесь свой `t`
 * с глобальной областью.
 *
 *     const { uiText } = useUiText();
 *     <KitSelect :no-data-text="uiText('NothingFound')" />
 */
export function useUiText() {
	const { t } = useI18n({ useScope: 'global' });
	return { uiText: t };
}
