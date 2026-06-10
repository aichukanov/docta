<template>
	<component :is="iconComponent" :size="size" />
</template>

<script setup lang="ts">
import type { Component } from 'vue';
import {
	getMedicineFormCategory,
	type MedicineFormCategory,
} from '~/common/medicine-form-icon';
import TabletIcon from './icon/med/tablet.vue';
import CapsuleIcon from './icon/med/capsule.vue';
import SyrupIcon from './icon/med/syrup.vue';
import InjectionIcon from './icon/med/injection.vue';
import DropsIcon from './icon/med/drops.vue';
import TopicalIcon from './icon/med/topical.vue';
import SprayIcon from './icon/med/spray.vue';
import PatchIcon from './icon/med/patch.vue';
import PowderIcon from './icon/med/powder.vue';
import OtherIcon from './icon/med/other.vue';

const ICONS: Record<MedicineFormCategory, Component> = {
	tablet: TabletIcon,
	capsule: CapsuleIcon,
	syrup: SyrupIcon,
	injection: InjectionIcon,
	drops: DropsIcon,
	topical: TopicalIcon,
	spray: SprayIcon,
	patch: PatchIcon,
	powder: PowderIcon,
	other: OtherIcon,
};

interface Props {
	formSrc?: string | null;
	size?: string | number;
}

const props = withDefaults(defineProps<Props>(), {
	formSrc: null,
	size: 24,
});

const iconComponent = computed(
	() => ICONS[getMedicineFormCategory(props.formSrc)],
);
</script>
