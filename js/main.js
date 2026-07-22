(() => {
  const nav = document.getElementById('nav');
  const navToggle = document.getElementById('navToggle');
  const navLinks = document.getElementById('navLinks');
  if (!nav || !navToggle || !navLinks) return;

  let ticking = false;
  window.addEventListener(
    'scroll',
    () => {
      if (ticking) return;
      ticking = true;
      requestAnimationFrame(() => {
        nav.classList.toggle('scrolled', window.scrollY > 40);
        ticking = false;
      });
    },
    { passive: true }
  );

  navToggle.addEventListener('click', () => {
    navLinks.classList.toggle('open');
  });

  navLinks.addEventListener('click', (e) => {
    if (e.target.closest('a')) navLinks.classList.remove('open');
  });

  const stats = document.querySelectorAll('.stat-number[data-target]');
  if (!stats.length || !('IntersectionObserver' in window)) return;

  const animate = (el, target) => {
    const start = performance.now();
    const duration = 900;
    const tick = (now) => {
      const t = Math.min((now - start) / duration, 1);
      el.textContent = String(Math.floor((1 - Math.pow(1 - t, 3)) * target));
      if (t < 1) requestAnimationFrame(tick);
      else el.textContent = String(target);
    };
    requestAnimationFrame(tick);
  };

  const io = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        animate(entry.target, parseInt(entry.target.dataset.target, 10) || 0);
        io.unobserve(entry.target);
      });
    },
    { threshold: 0.4 }
  );
  stats.forEach((el) => io.observe(el));
})();
