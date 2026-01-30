/**
 * OAuth provider configuration
 */
export interface OAuthConfig {
	google: {
		clientId: string;
		clientSecret: string;
		authUrl: string;
		tokenUrl: string;
		userInfoUrl: string;
		redirectUri: string;
	};
	telegram: {
		botToken: string;
		botUsername: string;
	};
}

export function getOAuthConfig(): OAuthConfig {
	const baseUrl = process.env.BASE_URL || 'http://localhost:3000';

	return {
		google: {
			clientId: process.env.GOOGLE_CLIENT_ID || '',
			clientSecret: process.env.GOOGLE_CLIENT_SECRET || '',
			authUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
			tokenUrl: 'https://oauth2.googleapis.com/token',
			userInfoUrl: 'https://www.googleapis.com/oauth2/v2/userinfo',
			redirectUri: `${baseUrl}/api/auth/callback/google`,
		},
		telegram: {
			botToken: process.env.TELEGRAM_BOT_TOKEN || '',
			botUsername: process.env.TELEGRAM_BOT_USERNAME || '',
		},
	};
}
