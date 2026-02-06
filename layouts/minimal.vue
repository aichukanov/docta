<template>
	<div class="minimal-page">
		<div class="minimal-container">
			<div class="minimal-card">
				<div class="minimal-card__header">
					<NuxtLink class="minimal-card__logo" to="/" aria-label="Home">
						<img src="/logo-site.png" alt="docta.me" />
					</NuxtLink>
					<LanguageSwitcher smaller />
				</div>

				<slot />
			</div>
		</div>
	</div>
</template>

<style>
body {
	margin: 0;
	font-family: system-ui;
}
</style>

<style scoped>
.minimal-page {
	height: 100vh;
	height: 100dvh;
	display: flex;
	align-items: center;
	justify-content: center;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 20px;
	box-sizing: border-box;
	overflow: auto;
}

.minimal-container {
	width: 100%;
	max-width: 480px;
}

.minimal-card {
	background: white;
	border-radius: 12px;
	padding: 32px;
	box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
}

.minimal-card__header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 24px;
	padding-bottom: 20px;
	border-bottom: 1px solid #f0f0f0;
}

.minimal-card__logo {
	display: flex;
	align-items: center;
	text-decoration: none;
	transition: opacity 0.2s ease;

	&:hover {
		opacity: 0.8;
	}

	img {
		height: 26px;
		width: auto;
	}
}

@media (max-width: 480px) {
	.minimal-card {
		padding: 24px 20px;
	}
}
</style>
