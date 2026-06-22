# Hostinger Web Deployment

## CI/CD (GitHub Actions → Hostinger)

Repo: [github.com/bisVivek/portfolio-flutter](https://github.com/bisVivek/portfolio-flutter)

**Live site:** `https://vbportfolio.nextechzz.com`  
**FTP folder:** `domains/nextechzz.com/public_html/portfolio/`

### Workflows

| File | Trigger | Action |
|------|---------|--------|
| `.github/workflows/ci.yml` | PR + push to `main` | `analyze` + `test` |
| `.github/workflows/deploy.yml` | push to `main` | build web + FTP deploy |

### One-time GitHub secrets setup

GitHub repo → **Settings → Secrets and variables → Actions → New repository secret**

| Secret | Example / value |
|--------|-----------------|
| `FTP_SERVER` | `ftp.nextechzz.com` (from Hostinger → FTP Accounts) |
| `FTP_USERNAME` | `u478424824` |
| `FTP_PASSWORD` | your FTP password |
| `FTP_SERVER_DIR` | `domains/nextechzz.com/public_html/portfolio/` |

Find FTP details in **Hostinger hPanel → Files → FTP Accounts**.

If deploy uploads to the wrong folder, try one of these for `FTP_SERVER_DIR`:

- `domains/nextechzz.com/public_html/portfolio/`
- `public_html/portfolio/`

### Manual deploy trigger

GitHub → **Actions → Deploy to Hostinger → Run workflow**

### After setup

Every push to `main` will:

1. Run tests
2. Build `flutter build web --release --base-href="/"`
3. Upload `build/web/` to Hostinger via FTP

---

## Subdomain — `vbportfolio.nextechzz.com`

Use this when the site lives on its **own subdomain**, not a folder on the main domain.

### 1. Create subdomain in Hostinger

1. Log in to **Hostinger hPanel**
2. Go to **Domains** → **Subdomains** (or **Website** → **Subdomains**)
3. Create subdomain, e.g. `portfolio`
4. Full URL becomes: `https://portfolio.yourdomain.com`
5. Note the **document root** Hostinger creates, usually one of:
   - `public_html/portfolio`
   - `domains/portfolio.yourdomain.com/public_html`

### 2. Build Flutter for subdomain

Subdomain = site root, so **base-href is `/`**:

```bash
flutter pub get
flutter build web --release --base-href="/"
```

Or on Windows:

```powershell
.\scripts\build_web.ps1 -BaseHref "/"
```

### 3. Upload to Hostinger

1. Open **File Manager** in hPanel
2. Open the subdomain **document root** folder (from step 1)
3. Delete old files inside (if re-deploying)
4. Upload **all contents** of `build/web/` into that folder
5. Confirm `index.html` is directly inside the document root

### 4. SSL (HTTPS)

1. hPanel → **Security** → **SSL**
2. Enable free SSL for the subdomain (or whole domain)
3. Wait a few minutes, then open `https://portfolio.yourdomain.com`

### 5. DNS (if subdomain does not open)

Usually Hostinger sets DNS automatically. If not:

- Type: **A** or **CNAME**
- Name: `portfolio`
- Points to: Hostinger server IP (shown in hPanel → DNS)

---

## Quick build (main/root domain)

If your site is at `https://yourdomain.com/` (root), run:

```bash
flutter pub get
flutter build web --release
```

Upload everything inside `build/web/` to your Hostinger `public_html` folder.

## Subfolder deployment (NOT subdomain)

If your site is at `https://yourdomain.com/portfolio/` (folder on main domain), build with:

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
