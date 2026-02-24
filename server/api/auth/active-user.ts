import { getCurrentUser } from '~/server/common/auth';

export default defineEventHandler(async (event) => {
	return await getCurrentUser(event);
});
