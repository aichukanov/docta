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

export interface Review {
	id: number;
	userId?: number;
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
	updatedAt: string;
	replies?: ReviewReply[];
	author?: {
		name: string;
		photoUrl?: string;
		profileUrl?: string;
	};
}

export interface Rating {
	averageRating: number | null;
	totalReviews: number;
}