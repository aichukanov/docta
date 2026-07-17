export interface ReviewReply {
	id: number;
	responderType: 'clinic' | 'doctor';
	clinicId?: number;
	doctorId?: number;
	userId?: number;
	originalText?: string;
	originalLanguage: string;
	text: string;
	provider: 'google_maps' | 'facebook' | 'telegram' | 'docta_me';
	likesCount: number;
	publishedAt?: string;
	updatedAt: string;
}

export type ReviewModerationStatus = 'pending' | 'approved' | 'rejected';

export interface Review {
	id: number;
	clinicId?: number;
	doctorId?: number;
	medicalServiceId?: number;
	provider: 'google_maps' | 'facebook' | 'telegram' | 'docta_me';
	providerReviewId?: string;
	rating?: number;
	originalLanguage: string;
	originalText?: string;
	text: string;
	publishedAt?: string;
	likesCount: number;
	/** Визит подтверждён документом, проверенным модератором */
	isVerified?: boolean;
	updatedAt: string;
	replies?: ReviewReply[];
	author?: {
		name: string;
		photoUrl?: string;
		profileUrl?: string;
	};
	/** true if this review belongs to the currently logged-in user */
	isOwn?: boolean;
	/** Только для own-отзыва: статус модерации */
	status?: ReviewModerationStatus;
	/** Только для own-отзыва: причина отклонения */
	rejectionReason?: string | null;
	/** Только для own-отзыва: статус проверки файла верификации */
	verificationStatus?: ReviewModerationStatus | null;
}

export interface ReviewAiSummary {
	sentiment: 'positive' | 'neutral' | 'negative';
	positives: string[];
	negatives: string[];
	recommendations: string | null;
	reviewsCount: number;
	generatedAt: string;
}

export interface Rating {
	averageRating: number | null;
	totalReviews: number;
}
