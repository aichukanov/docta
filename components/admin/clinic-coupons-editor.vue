<script setup lang="ts">
import { isCouponCurrentlyActive } from '~/common/clinic-coupon';
import {
	CLINIC_COUPON_PAYMENT_METHODS,
	CLINIC_COUPON_SCOPES,
	type ClinicCouponAdmin,
	type ClinicCouponPaymentMethod,
	type ClinicCouponScope,
} from '~/interfaces/clinic-coupon';

const props = defineProps<{ clinicId: number }>();

const SCOPE_LABELS: Record<ClinicCouponScope, string> = {
	services: 'Услуги',
	labtests: 'Анализы',
	medications: 'Лекарства',
};

const PAYMENT_LABELS: Record<ClinicCouponPaymentMethod, string> = {
	any: 'Любая оплата',
	cash: 'Только наличными',
	card: 'Только картой',
};

// Пустая форма = создание нового купона; id заполняется при правке
const emptyForm = () => ({
	id: null as number | null,
	discountPercent: 10,
	appliesTo: ['services'] as ClinicCouponScope[],
	paymentMethod: 'any' as ClinicCouponPaymentMethod,
	sourceName: '',
	imageUrl: '',
	code: '',
	validFrom: '',
	validUntil: '',
	isActive: true,
});

const coupons = ref<ClinicCouponAdmin[]>([]);
const form = ref(emptyForm());
const isLoading = ref(false);
const isSaving = ref(false);
const statusMessage = ref('');

const isEditing = computed(() => form.value.id != null);

const loadCoupons = async () => {
	isLoading.value = true;
	try {
		const data = await $fetch<{ coupons: ClinicCouponAdmin[] }>(
			'/api/clinics/coupons/list',
			{ method: 'POST', body: { clinicId: props.clinicId } },
		);
		coupons.value = data?.coupons || [];
	} catch (error) {
		console.error('Failed to load clinic coupons:', error);
		coupons.value = [];
	} finally {
		isLoading.value = false;
	}
};

const resetForm = () => {
	form.value = emptyForm();
};

const editCoupon = (coupon: ClinicCouponAdmin) => {
	form.value = {
		id: coupon.id,
		discountPercent: coupon.discountPercent,
		appliesTo: [...coupon.appliesTo],
		paymentMethod: coupon.paymentMethod,
		sourceName: coupon.sourceName || '',
		imageUrl: coupon.imageUrl || '',
		code: coupon.code || '',
		validFrom: coupon.validFrom || '',
		validUntil: coupon.validUntil || '',
		isActive: coupon.isActive,
	};
};

const showStatus = (message: string) => {
	statusMessage.value = message;
	setTimeout(() => (statusMessage.value = ''), 3000);
};

const saveCoupon = async () => {
	if (form.value.appliesTo.length === 0) {
		alert('Выберите, на что действует скидка');
		return;
	}
	if (
		!Number.isInteger(form.value.discountPercent) ||
		form.value.discountPercent < 1 ||
		form.value.discountPercent > 100
	) {
		alert('Процент скидки — целое число от 1 до 100');
		return;
	}
	if (
		form.value.validFrom &&
		form.value.validUntil &&
		form.value.validUntil < form.value.validFrom
	) {
		alert('Дата окончания раньше даты начала');
		return;
	}

	isSaving.value = true;
	try {
		await $fetch('/api/clinics/coupons/save', {
			method: 'POST',
			body: {
				id: form.value.id ?? undefined,
				clinicId: props.clinicId,
				discountPercent: form.value.discountPercent,
				appliesTo: form.value.appliesTo,
				paymentMethod: form.value.paymentMethod,
				sourceName: form.value.sourceName,
				imageUrl: form.value.imageUrl,
				code: form.value.code,
				validFrom: form.value.validFrom,
				validUntil: form.value.validUntil,
				isActive: form.value.isActive,
			},
		});
		showStatus(isEditing.value ? 'Купон обновлён' : 'Купон добавлен');
		resetForm();
		await loadCoupons();
	} catch (error) {
		console.error('Failed to save clinic coupon:', error);
		alert('Ошибка сохранения купона');
	} finally {
		isSaving.value = false;
	}
};

// Снятие с витрины — это флаг, а не удаление: по купону уже могли прийти
// пациенты, история должна остаться
const toggleActive = async (coupon: ClinicCouponAdmin) => {
	const next = !coupon.isActive;
	if (!confirm(next ? 'Вернуть купон на витрину?' : 'Снять купон с витрины?')) {
		return;
	}
	try {
		await $fetch('/api/clinics/coupons/save', {
			method: 'POST',
			body: {
				id: coupon.id,
				clinicId: props.clinicId,
				discountPercent: coupon.discountPercent,
				appliesTo: coupon.appliesTo,
				paymentMethod: coupon.paymentMethod,
				sourceName: coupon.sourceName,
				imageUrl: coupon.imageUrl,
				code: coupon.code,
				validFrom: coupon.validFrom,
				validUntil: coupon.validUntil,
				isActive: next,
			},
		});
		await loadCoupons();
	} catch (error) {
		console.error('Failed to toggle clinic coupon:', error);
		alert('Ошибка изменения купона');
	}
};

const deleteCoupon = async (coupon: ClinicCouponAdmin) => {
	if (
		!confirm(
			'Удалить купон полностью? Для снятия акции используйте «Снять с витрины».',
		)
	) {
		return;
	}
	try {
		await $fetch('/api/clinics/coupons/delete', {
			method: 'POST',
			body: { couponId: coupon.id },
		});
		if (form.value.id === coupon.id) resetForm();
		await loadCoupons();
	} catch (error) {
		console.error('Failed to delete clinic coupon:', error);
		alert('Ошибка удаления купона');
	}
};

const formatDate = (value: string | null) => {
	if (!value) return '';
	const date = new Date(value);
	return Number.isNaN(date.getTime())
		? value
		: date.toLocaleDateString('ru-RU');
};

const couponPeriod = (coupon: ClinicCouponAdmin) => {
	if (!coupon.validFrom && !coupon.validUntil) return 'Бессрочно';
	const from = coupon.validFrom ? formatDate(coupon.validFrom) : 'сейчас';
	const until = coupon.validUntil ? formatDate(coupon.validUntil) : '∞';
	return `${from} → ${until}`;
};

const couponStatus = (coupon: ClinicCouponAdmin) => {
	if (!coupon.isActive) return 'Снят с витрины';
	if (!isCouponCurrentlyActive(coupon)) return 'Вне срока действия';
	return '';
};

const scopeNames = (scopes: ClinicCouponScope[]) =>
	scopes.map((scope) => SCOPE_LABELS[scope]).join(', ');

watch(() => props.clinicId, loadCoupons, { immediate: true });
</script>

<template>
	<div class="coupons-section">
		<div class="section-header">
			<h4>Купоны на скидку</h4>
			<span v-if="statusMessage" class="coupons-status">{{
				statusMessage
			}}</span>
		</div>

		<div v-if="isLoading" class="coupons-loading">Загрузка...</div>
		<div v-else class="coupons-list">
			<div
				v-for="coupon in coupons"
				:key="coupon.id"
				class="coupon-item"
				:class="{ inactive: !!couponStatus(coupon) }"
			>
				<img
					v-if="coupon.imageUrl"
					:src="coupon.imageUrl"
					alt=""
					class="coupon-item-image"
				/>
				<div class="coupon-item-body">
					<div class="coupon-item-title">
						<span class="coupon-item-percent"
							>−{{ coupon.discountPercent }}%</span
						>
						<span>{{ scopeNames(coupon.appliesTo) }}</span>
					</div>
					<div class="coupon-item-meta">
						<span>{{ couponPeriod(coupon) }}</span>
						<span v-if="coupon.paymentMethod !== 'any'"
							>· {{ PAYMENT_LABELS[coupon.paymentMethod] }}</span
						>
						<span v-if="coupon.sourceName"
							>· партнёр: {{ coupon.sourceName }}</span
						>
						<span v-if="coupon.code">· код: {{ coupon.code }}</span>
					</div>
					<div v-if="couponStatus(coupon)" class="coupon-item-status">
						{{ couponStatus(coupon) }}
					</div>
				</div>
				<div class="coupon-item-actions">
					<el-button size="small" @click="editCoupon(coupon)">
						Редактировать
					</el-button>
					<el-button size="small" @click="toggleActive(coupon)">
						{{ coupon.isActive ? 'Снять с витрины' : 'Вернуть' }}
					</el-button>
					<el-button size="small" type="danger" @click="deleteCoupon(coupon)">
						Удалить
					</el-button>
				</div>
			</div>
			<div v-if="!coupons.length" class="coupons-empty">Купонов пока нет</div>
		</div>

		<div class="coupon-form">
			<h5>{{ isEditing ? `Правка купона #${form.id}` : 'Новый купон' }}</h5>

			<div class="coupon-form-row">
				<label class="coupon-form-label">Скидка, %</label>
				<el-input-number
					v-model="form.discountPercent"
					:min="1"
					:max="100"
					:step="1"
				/>
			</div>

			<div class="coupon-form-row">
				<label class="coupon-form-label">Действует на</label>
				<el-checkbox-group v-model="form.appliesTo">
					<el-checkbox
						v-for="scope in CLINIC_COUPON_SCOPES"
						:key="scope"
						:value="scope"
					>
						{{ SCOPE_LABELS[scope] }}
					</el-checkbox>
				</el-checkbox-group>
			</div>
			<p class="coupon-form-hint">
				Чип «−N%» и баннер показываются только там, где действует скидка: на
				страницах анализов купон на услуги не появится.
			</p>

			<div class="coupon-form-row">
				<label class="coupon-form-label">Оплата</label>
				<el-radio-group v-model="form.paymentMethod">
					<el-radio
						v-for="method in CLINIC_COUPON_PAYMENT_METHODS"
						:key="method"
						:value="method"
					>
						{{ PAYMENT_LABELS[method] }}
					</el-radio>
				</el-radio-group>
			</div>
			<p class="coupon-form-hint">
				Если скидка только за наличные — это условие попадёт в купон и в список
				условий, чтобы пациент не узнал о нём на кассе.
			</p>

			<div class="coupon-form-row">
				<label class="coupon-form-label">Партнёр</label>
				<el-input
					v-model="form.sourceName"
					placeholder="Montenegro Experte — пусто, если купон docta.me"
					maxlength="100"
				/>
			</div>

			<AdminEditableField
				label="Картинка купона (её пациент показывает на ресепшене)"
				type="photo"
				image-category="coupons"
				v-model:value="form.imageUrl"
			/>
			<p class="coupon-form-hint">
				Без картинки сайт рисует свой купон, переведённый на все 6 языков.
			</p>

			<div class="coupon-form-row">
				<label class="coupon-form-label">Кодовое слово</label>
				<el-input
					v-model="form.code"
					placeholder="Пусто, если достаточно показать купон"
					maxlength="50"
				/>
			</div>

			<div class="coupon-form-row">
				<label class="coupon-form-label">Срок действия</label>
				<el-input
					v-model="form.validFrom"
					type="date"
					class="coupon-form-date"
				/>
				<el-input
					v-model="form.validUntil"
					type="date"
					class="coupon-form-date"
				/>
			</div>
			<p class="coupon-form-hint">
				Пустые даты — купон бессрочный и действует сразу.
			</p>

			<div class="coupon-form-row">
				<el-switch
					v-model="form.isActive"
					active-text="На витрине"
					inactive-text="Снят"
				/>
			</div>

			<div class="coupon-form-actions">
				<el-button type="primary" :loading="isSaving" @click="saveCoupon">
					{{ isEditing ? 'Сохранить купон' : 'Добавить купон' }}
				</el-button>
				<el-button v-if="isEditing" @click="resetForm">Отмена</el-button>
			</div>
		</div>
	</div>
</template>

<style scoped lang="less">
.coupons-section {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-md);
	padding: var(--kit-spacing-md);
	border: 1px solid var(--kit-color-border-primary);
	border-radius: var(--kit-border-radius-md);
}

.section-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-md);

	h4 {
		margin: 0;
	}
}

.coupons-status {
	color: var(--kit-color-success-dark);
	font-size: var(--kit-font-size-sm);
}

.coupons-loading,
.coupons-empty {
	color: var(--kit-color-text-muted);
	font-size: var(--kit-font-size-sm);
}

.coupons-list {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
}

.coupon-item {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-md);
	padding: var(--kit-spacing-sm) var(--kit-spacing-md);
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-md);
	background: var(--kit-color-surface-secondary);
	flex-wrap: wrap;

	&.inactive {
		opacity: 0.6;
	}
}

.coupon-item-image {
	width: 80px;
	height: auto;
	border-radius: var(--kit-border-radius-sm);
}

.coupon-item-body {
	flex: 1;
	min-width: 200px;
}

.coupon-item-title {
	display: flex;
	align-items: baseline;
	gap: var(--kit-spacing-sm);
	font-weight: var(--kit-font-weight-semibold);
}

.coupon-item-percent {
	color: var(--kit-color-primary-green);
	font-size: var(--kit-font-size-lg);
}

.coupon-item-meta {
	display: flex;
	flex-wrap: wrap;
	gap: var(--kit-spacing-xs);
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.coupon-item-status {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-warning-dark);
}

.coupon-item-actions {
	display: flex;
	gap: var(--kit-spacing-xs);
	flex-wrap: wrap;
}

.coupon-form {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
	padding-top: var(--kit-spacing-md);
	border-top: 1px solid var(--kit-color-border-secondary);

	h5 {
		margin: 0;
	}
}

.coupon-form-row {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-md);
	flex-wrap: wrap;
}

.coupon-form-label {
	min-width: 140px;
	color: var(--kit-color-text-secondary);
	font-size: var(--kit-font-size-sm);
}

.coupon-form-date {
	max-width: 180px;
}

.coupon-form-hint {
	margin: 0;
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.coupon-form-actions {
	display: flex;
	gap: var(--kit-spacing-sm);
}
</style>
