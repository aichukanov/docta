import { fixUrlRegionalParams } from '../common/redirect/regional-settings';
import { checkLabTestRedirect } from '../common/redirect/lab-test-redirects';
import { checkDoctorRedirect } from '../common/redirect/doctor-redirects';
import { checkMedicalServiceRedirect } from '../common/redirect/medical-service-redirects';
import { sendSitemap } from '../common/sitemap/utils';
import { generateSitemapPage } from '../common/sitemap/sitemap';
import { requireAdmin } from '../common/auth';

export default defineEventHandler(async (event) => {
	const { pathname, searchParams } = getRequestURL(event);

	const pathArray = pathname.split('/').slice(1); // remove a leading slash

	if (pathArray[0] === 'sitemap.xml') {
		return sendSitemap(event, await generateSitemapPage());
	} else if (
		pathArray[0] === 'api' ||
		pathArray[0] === 'ads' ||
		pathArray[0] === 'search' ||
		pathArray[0].includes('a1b2c3d4e5f6789012345678901234567890abcd') ||
		pathArray[0].includes('cdn-cgi') ||
		pathArray[0].includes('robots')
	) {
		// ignore these calls
	} else if (pathArray[0] === 'admin') {
		requireAdmin(event);
	} else {
		// Проверяем редиректы для объединённых сущностей
		const labTestRedirect = await checkLabTestRedirect(event, pathArray);
		if (labTestRedirect) {
			await sendRedirect(event, labTestRedirect.url, labTestRedirect.status);
			return;
		}

		const doctorRedirect = await checkDoctorRedirect(event, pathArray);
		if (doctorRedirect) {
			await sendRedirect(event, doctorRedirect.url, doctorRedirect.status);
			return;
		}

		const medicalServiceRedirect = await checkMedicalServiceRedirect(
			event,
			pathArray,
		);
		if (medicalServiceRedirect) {
			await sendRedirect(
				event,
				medicalServiceRedirect.url,
				medicalServiceRedirect.status,
			);
			return;
		}

		const queryParamsRedirect = await fixUrlRegionalParams(event);
		if (queryParamsRedirect) {
			await sendRedirect(
				event,
				queryParamsRedirect.url,
				queryParamsRedirect.status,
			);
			return;
		}
	}
});
