export function useInViewport(rootMargin = '200px') {
	const target = ref<HTMLElement | null>(null);
	const hasBeenVisible = ref(false);

	if (import.meta.server) {
		return { target, hasBeenVisible };
	}

	let observer: IntersectionObserver | null = null;

	const cleanup = () => {
		if (observer) {
			observer.disconnect();
			observer = null;
		}
	};

	watch(target, (el) => {
		cleanup();
		if (!el) return;

		observer = new IntersectionObserver(
			([entry]) => {
				if (entry.isIntersecting) {
					hasBeenVisible.value = true;
					cleanup();
				}
			},
			{ rootMargin },
		);
		observer.observe(el);
	});

	onBeforeUnmount(cleanup);

	return { target, hasBeenVisible };
}
