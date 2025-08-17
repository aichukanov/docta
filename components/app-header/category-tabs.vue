<template>
	<div class="category-tabs">
		<el-tabs
			v-model="activeCategory"
			@tab-change="handleTabChange"
			class="category-tabs__inner"
		>
			<el-tab-pane :label="t('Doctors')" name="doctors" />
			<el-tab-pane :label="t('Pharmacies')" name="pharmacies" />
		</el-tabs>
	</div>
</template>

<script setup lang="ts">
const { t } = useI18n();

const activeCategory = ref('doctors');

const emit = defineEmits<{
	categoryChange: [category: string];
}>();

const handleTabChange = (category: string | number) => {
	emit('categoryChange', String(category));
};
</script>

<i18n lang="json">
{
	"en": {
		"Doctors": "Doctors",
		"Pharmacies": "Pharmacies"
	},
	"ru": {
		"Doctors": "Доктора",
		"Pharmacies": "Аптеки"
	},
	"sr": {
		"Doctors": "Lekari",
		"Pharmacies": "Apoteke"
	},
	"ba": {
		"Doctors": "Lekari",
		"Pharmacies": "Apoteke"
	},
	"me": {
		"Doctors": "Ljekari",
		"Pharmacies": "Apoteke"
	},
	"de": {
		"Doctors": "Ärzte",
		"Pharmacies": "Apotheken"
	},
	"tr": {
		"Doctors": "Doktorlar",
		"Pharmacies": "Eczaneler"
	}
}
</i18n>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.category-tabs {
	display: flex;
	justify-content: center;
	padding: 0 @base-padding;
	box-sizing: border-box;

	:deep(.category-tabs__inner) {
		.el-tabs__header {
			margin: 0;
			border-bottom: none;
		}

		.el-tabs__nav-wrap::after {
			display: none;
		}

		.el-tabs__nav {
			border: 1px solid @light-gray-color;
			border-radius: 24px;
			overflow: hidden;
			background: white;
		}

		.el-tabs__item {
			height: 48px;
			line-height: 48px;
			padding: 0 32px;
			border: none;
			color: @dark-gray-color;
			font-weight: 500;
			transition: all 0.2s ease;

			&.is-active {
				background: @primary-color;
				color: white;
			}

			&:hover:not(.is-active) {
				background: rgba(75, 70, 229, 0.04);
			}
		}

		.el-tabs__active-bar {
			display: none;
		}
	}
}

@media only screen and (max-width: 600px) {
	.category-tabs {
		padding: 0 @base-offset;
	}
}
</style>
