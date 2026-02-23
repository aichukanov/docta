<script setup lang="ts">
const { t } = useI18n({
	useScope: 'local',
	messages: {
		en: { title: 'My Clinics', desc: 'This section is under development' },
		ru: { title: 'Мои клиники', desc: 'Этот раздел находится в разработке' },
		sr: { title: 'Moje klinike', desc: 'Ovaj odeljak je u razvoju' },
		de: { title: 'Meine Kliniken', desc: 'Dieser Abschnitt ist in Entwicklung' },
		tr: { title: 'Kliniklerim', desc: 'Bu bölüm geliştirme aşamasındadır' },
		'sr-cyrl': { title: 'Моје клинике', desc: 'Овај одељак је у развоју' },
	},
});
</script>

<template>
	<div class="coming-soon-card">
		<div class="coming-soon-card__icon">
			<IconClinic :size="40" />
		</div>
		<h2 class="coming-soon-card__title">{{ t('title') }}</h2>
		<p class="coming-soon-card__desc">{{ t('desc') }}</p>
	</div>
</template>

<style scoped>
.coming-soon-card {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	border: 1px solid var(--color-border-secondary);
	box-shadow: var(--shadow-sm);
	padding: var(--spacing-3xl) var(--spacing-2xl);
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: var(--spacing-lg);
	text-align: center;
	min-height: 280px;
	justify-content: center;
}

.coming-soon-card__icon {
	width: 80px;
	height: 80px;
	border-radius: var(--border-radius-full);
	background: var(--color-primary-bg);
	color: var(--color-primary);
	display: flex;
	align-items: center;
	justify-content: center;
}

.coming-soon-card__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.coming-soon-card__desc {
	font-size: var(--font-size-md);
	color: var(--color-text-muted);
	margin: 0;
}
</style>
