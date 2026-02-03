<template>
	<div class="email-preview-page">
		<div class="controls">
			<h1>📧 Email Templates Preview</h1>
			<p class="subtitle">Development только - просмотр всех email шаблонов</p>

			<div class="control-group">
				<label>Тип шаблона:</label>
				<select v-model="selectedType">
					<option value="password-reset">Password Reset</option>
					<option value="email-verification">Email Verification</option>
					<option value="login-notification">Login Notification</option>
					<option value="email-change">Email Change</option>
				</select>
			</div>

			<div class="control-group">
				<label>Язык:</label>
				<select v-model="selectedLocale">
					<option value="sr">🇷🇸 Serbian (Latin)</option>
					<option value="sr-cyrl">🇷🇸 Serbian (Cyrillic)</option>
					<option value="en">🇬🇧 English</option>
					<option value="ru">🇷🇺 Russian</option>
					<option value="de">🇩🇪 German</option>
					<option value="tr">🇹🇷 Turkish</option>
				</select>
			</div>
		</div>

		<div class="preview-container">
			<iframe
				:src="previewUrl"
				frameborder="0"
				class="email-iframe"
			></iframe>
		</div>
	</div>
</template>

<script setup lang="ts">
const selectedType = ref('password-reset');
const selectedLocale = ref('en');

const previewUrl = computed(() => {
	return `/api/test/email-preview?type=${selectedType.value}&locale=${selectedLocale.value}`;
});

// Reload iframe when URL changes
watch(previewUrl, () => {
	// Force reload
});
</script>

<style scoped>
.email-preview-page {
	min-height: 100vh;
	background: #f5f5f5;
	padding: 20px;
}

.controls {
	max-width: 800px;
	margin: 0 auto 20px;
	background: white;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

h1 {
	margin: 0 0 10px;
	font-size: 28px;
	color: #333;
}

.subtitle {
	margin: 0 0 30px;
	color: #666;
	font-size: 14px;
}

.control-group {
	margin-bottom: 20px;
}

.control-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 600;
	color: #555;
}

.control-group select {
	width: 100%;
	padding: 12px;
	border: 2px solid #e0e0e0;
	border-radius: 8px;
	font-size: 16px;
	background: white;
	cursor: pointer;
	transition: border-color 0.2s;
}

.control-group select:hover {
	border-color: #667eea;
}

.control-group select:focus {
	outline: none;
	border-color: #667eea;
	box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.preview-container {
	max-width: 800px;
	margin: 0 auto;
	background: white;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
	overflow: hidden;
}

.email-iframe {
	width: 100%;
	height: 600px;
	display: block;
}
</style>
