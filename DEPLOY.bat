@echo off
setlocal
cd /d "%~dp0"

set "HOST=flightpath-vps"
set "REMOTE=/var/www/virender.in"
set "NGINX_CONF=/opt/platform/nginx/virender.conf"

echo ============================================================
echo   DEPLOY virender.in — Full Portfolio
echo ============================================================

ssh -o BatchMode=yes -o ConnectTimeout=15 %HOST% "echo ok" >nul 2>&1
if errorlevel 1 (
  echo SSH not configured. Run SETUP-SSH-KEY.bat in vps-platform first.
  pause
  exit /b 1
)

echo [1/5] Creating remote directories...
ssh %HOST% "mkdir -p %REMOTE%/public/images %REMOTE%/public/certificates %REMOTE%/css %REMOTE%/js %REMOTE%/case-studies %REMOTE%/blog"

echo [2/5] Uploading site files...
scp -o BatchMode=yes index.html sitemap.xml robots.txt %HOST%:%REMOTE%/
scp -o BatchMode=yes -r css js public case-studies blog %HOST%:%REMOTE%/

echo [3/5] Installing nginx config...
scp -o BatchMode=yes ..\vps-platform\nginx\virender.conf %HOST%:%NGINX_CONF%
ssh %HOST% "cp %NGINX_CONF% /etc/nginx/sites-available/virender.in && ln -sf /etc/nginx/sites-available/virender.in /etc/nginx/sites-enabled/virender.in && nginx -t && systemctl reload nginx"

echo [4/5] Setting permissions...
ssh %HOST% "chmod -R 755 %REMOTE% && chown -R www-data:www-data %REMOTE%"

echo [5/5] Verifying...
ssh %HOST% "curl -sf -o /dev/null -w 'HTTPS %%{http_code}\n' https://virender.in/ && curl -sf -o /dev/null -w 'Sitemap %%{http_code}\n' https://virender.in/sitemap.xml"

echo.
echo ============================================================
echo   Deploy complete!  https://virender.in
echo.
echo   To move to a new server:
echo     1. Copy this entire virender-portfolio folder
echo     2. Point DNS A record to new server IP
echo     3. Copy nginx/virender.conf to /etc/nginx/sites-available/
echo     4. Run: certbot --nginx -d virender.in -d www.virender.in
echo ============================================================
pause
