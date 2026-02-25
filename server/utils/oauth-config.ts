/**
 * OAuth provider configuration
 */

import { getBaseUrl } from './base-url';

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
	facebook: {
		appId: string;
		appSecret: string;
		authUrl: string;
		tokenUrl: string;
		userInfoUrl: string;
		redirectUri: string;
	};
}

export function getOAuthConfig(): OAuthConfig {
	const baseUrl = getBaseUrl();
	const config = useRuntimeConfig();

	return {
		google: {
			clientId: config.googleClientId,
			clientSecret: config.googleClientSecret,
			authUrl: 'https://accounts.google.com/o/oauth2/v2/auth',
			tokenUrl: 'https://oauth2.googleapis.com/token',
			userInfoUrl: 'https://www.googleapis.com/oauth2/v2/userinfo',
			redirectUri: `${baseUrl}/api/auth/callback/google`,
		},
		telegram: {
			botToken: config.telegramBotToken,
			botUsername: config.telegramBotUsername,
		},
		facebook: {
			appId: config.facebookAppId,
			appSecret: config.facebookAppSecret,
			authUrl: 'https://www.facebook.com/v18.0/dialog/oauth',
			tokenUrl: 'https://graph.facebook.com/v18.0/oauth/access_token',
			userInfoUrl: 'https://graph.facebook.com/v18.0/me',
			redirectUri: `${baseUrl}/api/auth/callback/facebook`,
		},
	};
}
