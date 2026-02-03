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
		facebook: {
			appId: process.env.FACEBOOK_APP_ID || '',
			appSecret: process.env.FACEBOOK_APP_SECRET || '',
			authUrl: 'https://www.facebook.com/v18.0/dialog/oauth',
			tokenUrl: 'https://graph.facebook.com/v18.0/oauth/access_token',
			userInfoUrl: 'https://graph.facebook.com/v18.0/me',
			redirectUri: `${baseUrl}/api/auth/callback/facebook`,
		},
	};
}
