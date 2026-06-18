# Hostinger Web Deployment

## Quick build (root domain)

If your site is at `https://yourdomain.com/` (root), run:

```bash
flutter pub get
flutter build web --release
```

Upload everything inside `build/web/` to your Hostinger `public_html` folder.

## Subfolder deployment

If your site is at `https://yourdomain.com/portfolio/`, build with:

```bash
flutter build web --release --base-href="/portfolio/"
```

Or use the script:

```powershell
.\scripts\build_web.ps1 -BaseHref "/portfolio/"
```

## Hostinger steps

1. Log in to **Hostinger hPanel**
2. Open **File Manager** → `public_html`
3. Delete old files (if any) or upload to a subfolder
4. Upload all contents from `build/web/` (not the folder itself)
5. Ensure `index.html` is directly in `public_html` (or your subfolder)

## Required files after upload

```
public_html/
  index.html
  flutter_bootstrap.js
  main.dart.js
  flutter.js
  assets/
  canvaskit/
  icons/
  manifest.json
  favicon.png
  .htaccess   (optional, for SPA routing)
```

## SPA routing (.htaccess)

If you add client-side routes later, create `.htaccess` in `public_html`:

```apache
<IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\.html$ - [L]
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteRule . /index.html [L]
</IfModule>
```

For subfolder deployment, change `RewriteBase /` to `RewriteBase /portfolio/`.

## Update content

Edit `lib/data/portfolio_data.dart` to change:
- GitHub / LinkedIn URLs
- Play Store links
- Contact info
- Projects and experience

Then rebuild and re-upload.

## Run locally

```bash
flutter run -d chrome
```

## Mobile app

```bash
flutter run -d android
flutter run -d ios
```
