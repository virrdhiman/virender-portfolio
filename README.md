# Virender Dhiman — Personal Portfolio (virender.in)

**Live:** https://virender.in

Self-contained static portfolio — copy the entire folder to any web server.

## Structure

```
virender-portfolio/
├── index.html              # Main portfolio page
├── sitemap.xml             # SEO sitemap
├── robots.txt              # Search engine directives
├── css/
│   ├── styles.css          # Core theme
│   └── extras.css          # Photo, testimonials, certs, pages
├── js/main.js              # Animations, nav, counters
├── public/
│   ├── resume.html         # Updated resume (print to PDF)
│   ├── images/profile.png
│   └── certificates/       # 18 verified certificate PDFs
├── case-studies/           # 4 detailed case studies
├── blog/                   # 3 articles
├── DEPLOY.bat              # One-click deploy to VPS
└── nginx/virender.conf     # Nginx config (in vps-platform)
```

## Deploy to Current VPS

Double-click `DEPLOY.bat` or:

```bat
cd primary\virender-portfolio
DEPLOY.bat
```

## Move to a New Server

1. Copy the entire `virender-portfolio` folder to the new server
2. Place files in `/var/www/virender.in/` (or your preferred web root)
3. Copy nginx config from `primary/vps-platform/nginx/virender.conf`
4. Enable site: `ln -sf /etc/nginx/sites-available/virender.in /etc/nginx/sites-enabled/`
5. Point DNS A record for `virender.in` and `www.virender.in` to new server IP
6. Run SSL: `certbot --nginx -d virender.in -d www.virender.in`
7. Reload nginx: `nginx -t && systemctl reload nginx`

## SEO Checklist (included)

- [x] JSON-LD Person schema
- [x] Open Graph + Twitter Card meta tags
- [x] Canonical URLs on all pages
- [x] sitemap.xml with all pages
- [x] robots.txt
- [x] Geo tags (Karnal, Haryana, India)
- [x] Semantic HTML + alt texts
- [x] Mobile responsive
- [x] HTTPS with security headers
- [x] Gzip compression

## Post-Deploy SEO Actions

1. Submit sitemap to [Google Search Console](https://search.google.com/search-console) → `https://virender.in/sitemap.xml`
2. Submit to [Bing Webmaster Tools](https://www.bing.com/webmasters)
3. Add site link to LinkedIn profile
4. Ensure `virender@virender.in` email is configured and receiving

## Update Resume PDF

Open `public/resume.html` in browser → Print → Save as PDF → replace `public/resume.pdf`

## Contact

- Email: virender@virender.in
- Site: https://virender.in
