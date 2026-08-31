<script setup lang="ts">
import type { ClinicAdmin } from '~/interfaces/clinic-admin';

const props = defineProps<{ clinicId: number }>();

interface UserListItem {
	id: number;
	email: string;
	name: string;
}

const admins = ref<ClinicAdmin[]>([]);
const isLoading = ref(false);
const isSaving = ref(false);
const statusMessage = ref('');
const selectedUserId = ref<number | null>(null);

// Remote search, как в привязке пользователя к врачу: рендерить тысячи
// el-option разом нельзя
const userSearchResults = ref<{ label: string; value: number }[]>([]);
const isSearchingUsers = ref(false);

const formatUserOption = (user: UserListItem) => ({
	label: `id = "${user.id}" | email = "${user.email}" | name = "${user.name}"`,
	value: user.id,
});

const searchUsers = async (query: string) => {
	if (!query || query.length < 2) {
		userSearchResults.value = [];
		return;
	}
	isSearchingUsers.value = true;
	try {
		const users = await $fetch<UserListItem[]>('/api/users/list', {
			method: 'POST',
			body: { query },
		});
		userSearchResults.value = users.map(formatUserOption);
	} catch (error) {
		console.error('Failed to search users:', error);
	} finally {
		isSearchingUsers.value = false;
	}
};

const showStatus = (message: string) => {
	statusMessage.value = message;
	setTimeout(() => (statusMessage.value = ''), 3000);
};

const loadAdmins = async () => {
	isLoading.value = true;
	try {
		const data = await $fetch<{ admins: ClinicAdmin[] }>(
			'/api/clinics/admins/list',
			{ method: 'POST', body: { clinicId: props.clinicId } },
		);
		admins.value = data?.admins || [];
	} catch (error) {
		console.error('Failed to load clinic admins:', error);
		admins.value = [];
	} finally {
		isLoading.value = false;
	}
};

const addAdmin = async () => {
	if (selectedUserId.value == null) {
		alert('Выберите пользователя');
		return;
	}
	if (admins.value.some((admin) => admin.userId === selectedUserId.value)) {
		alert('У этого пользователя уже есть доступ');
		return;
	}

	isSaving.value = true;
	try {
		const data = await $fetch<{ admins: ClinicAdmin[] }>(
			'/api/clinics/admins/add',
			{
				method: 'POST',
				body: { clinicId: props.clinicId, userId: selectedUserId.value },
			},
		);
		admins.value = data?.admins || [];
		selectedUserId.value = null;
		userSearchResults.value = [];
		showStatus('Доступ выдан');
	} catch (error) {
		console.error('Failed to add clinic admin:', error);
		alert('Ошибка выдачи доступа');
	} finally {
		isSaving.value = false;
	}
};

const removeAdmin = async (admin: ClinicAdmin) => {
	const who = admin.email || admin.name || `id ${admin.userId}`;
	if (!confirm(`Забрать у ${who} доступ к кабинету клиники?`)) {
		return;
	}

	try {
		const data = await $fetch<{ admins: ClinicAdmin[] }>(
			'/api/clinics/admins/delete',
			{
				method: 'POST',
				body: { clinicId: props.clinicId, userId: admin.userId },
			},
		);
		admins.value = data?.admins || [];
		showStatus('Доступ отозван');
	} catch (error) {
		console.error('Failed to remove clinic admin:', error);
		alert('Ошибка отзыва доступа');
	}
};

const formatDate = (value: string | null) => {
	if (!value) return '';
	const date = new Date(value);
	return Number.isNaN(date.getTime())
		? value
		: date.toLocaleDateString('ru-RU');
};

watch(() => props.clinicId, loadAdmins, { immediate: true });
</script>

<template>
	<div class="admins-section">
		<div class="section-header">
			<h4>Администраторы клиники</h4>
			<span v-if="statusMessage" class="admins-status">{{
				statusMessage
			}}</span>
		</div>

		<p class="admins-hint">
			Эти аккаунты видят клинику в своём кабинете (/profile/clinics), правят её
			данные, публикуют и покупают платные услуги. Их может быть несколько.
		</p>

		<div v-if="isLoading" class="admins-loading">Загрузка...</div>
		<div v-else class="admins-list">
			<div v-for="admin in admins" :key="admin.userId" class="admin-item">
				<div class="admin-item-body">
					<div class="admin-item-title">
						<span>{{ admin.name || 'Без имени' }}</span>
						<span v-if="admin.isCreator" class="admin-item-badge">
							создал клинику
						</span>
					</div>
					<div class="admin-item-meta">
						<span>id {{ admin.userId }}</span>
						<span v-if="admin.email">· {{ admin.email }}</span>
						<span v-else>· без email</span>
						<span v-if="admin.createdAt">
							· доступ с {{ formatDate(admin.createdAt) }}
						</span>
					</div>
				</div>
				<el-button size="small" type="danger" @click="removeAdmin(admin)">
					Забрать доступ
				</el-button>
			</div>
			<div v-if="!admins.length" class="admins-empty">
				Ни у кого нет доступа — клиникой управляют только админы сайта
			</div>
		</div>

		<div class="admins-form">
			<el-select
				v-model="selectedUserId"
				filterable
				remote
				clearable
				:remote-method="searchUsers"
				:loading="isSearchingUsers"
				placeholder="Найдите пользователя по email, имени или id"
				class="admins-select"
			>
				<el-option
					v-for="user in userSearchResults"
					:key="user.value"
					:label="user.label"
					:value="user.value"
				/>
			</el-select>
			<el-button type="primary" :loading="isSaving" @click="addAdmin">
				Выдать доступ
			</el-button>
		</div>
	</div>
</template>

<style scoped lang="less">
.admins-section {
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

.admins-status {
	color: var(--kit-color-success-dark);
	font-size: var(--kit-font-size-sm);
}

.admins-hint {
	margin: 0;
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.admins-loading,
.admins-empty {
	color: var(--kit-color-text-muted);
	font-size: var(--kit-font-size-sm);
}

.admins-list {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
}

.admin-item {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-md);
	padding: var(--kit-spacing-sm) var(--kit-spacing-md);
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-md);
	background: var(--kit-color-surface-secondary);
	flex-wrap: wrap;
}

.admin-item-body {
	flex: 1;
	min-width: 200px;
}

.admin-item-title {
	display: flex;
	align-items: baseline;
	gap: var(--kit-spacing-sm);
	font-weight: var(--kit-font-weight-semibold);
	flex-wrap: wrap;
}

.admin-item-badge {
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-normal);
	color: var(--kit-color-text-muted);
}

.admin-item-meta {
	display: flex;
	flex-wrap: wrap;
	gap: var(--kit-spacing-xs);
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.admins-form {
	display: flex;
	gap: var(--kit-spacing-sm);
	align-items: center;
	padding-top: var(--kit-spacing-md);
	border-top: 1px solid var(--kit-color-border-secondary);
	flex-wrap: wrap;
}

.admins-select {
	flex: 1;
	min-width: 280px;
}
</style>
