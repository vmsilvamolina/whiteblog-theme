# Changelog

All notable changes to this project will be documented in this file.

## [0.4.1] - 2026-06-21

### Fixed
- Disqus script not loading after comments consolidation into `comments.html`

### Added
- Auto-generated meta description, OG and Twitter description from post excerpt
- JSON-LD `description` field now uses post excerpt as primary source

## [0.4.0] - 2026-06-18

### Fixed
- Command injection in `previews.rb` — replaced backtick shell interpolation with `system()` array args and `Dir.tmpdir`
- Analytics condition — GA4 no longer loads when `tracking_id` is empty
- Malformed `mailto:` link in sidebar (stray space after colon)
- Invalid Liquid syntax in `allposts.html` date format assignment
- Category page: invalid `id` with literal `#`, deprecated `<a name>`, inline hardcoded color, skipped heading levels (`h5` → `h2`)
- Theme toggle icon off-center — removed manual `padding-bottom` hack, now uses `display: flex`

### Added
- Skip to main content link (WCAG 2.4.1)
- `sr-only` utility class for screen-reader-only text
- `aria-label` on back-to-top, prev/next post navigation and search results container
- `<label>` for search input (WCAG 1.3.1)
- Accessible pagination — disabled items replaced with non-focusable `<span>`, `aria-current="page"` on active item
- `aria-hidden="true"` on all decorative SVGs in sidebar and share buttons
- `rel="noreferrer"` on all external `target="_blank"` links
- `display: flex` on theme toggle button for proper icon centering
- `jekyll-sitemap` plugin — `sitemap.xml` now generated on build

### Changed
- Post listing headings changed from `h1` to `h2` (single `h1` per page, injected as `sr-only`)
- Primary color adjusted for WCAG AA contrast (light: `#923DB5`, dark: `#CE80EF`)
- Inline code color adjusted for WCAG AA contrast (light: `#C01979`)
- Search script now uses `defer` and `relative_url`

## [0.3.2] - 2026-06-14

### Added
- Giscus comments sync with blog dark/light toggler via `postMessage`

## [0.3.1] - 2026-06-14

### Added
- Comments dispatcher via `case/when` supporting multiple providers (`disqus`, `cusdis`, `giscus`) cleanly from a single template

## [0.3.0] - 2026-05-06

### Added
- Giscus comments provider support via `comments.provider: giscus` in `_config.yml`

### Fixed
- Cusdis guard condition to prevent rendering when provider is not set

### Performance
- Sidebar avatar served as WebP with `loading="lazy"`
- Copy-success CSS class extracted from inline JS

### Style
- Removed `!important` from non-accessibility CSS rules

## [0.2.0] - 2026-04-09

### Added
- JSON-LD `BlogPosting` schema in post layout for structured data
- Complete Open Graph tags: `og:type`, `og:title`, `og:description`, `og:url`, `og:article:published_time`, `og:article:author`
- Twitter card tags: `twitter:title`, `twitter:description`
- OG image fallback to author avatar when no post preview exists
- `robots.txt` with sitemap URL

## [0.1.7] - 2026-04-08

### Fixed
- `<title>` and favicon `<link>` were placed outside of `<head>` — moved into `head.html`
- Title tag now shows `page.title | site.title` instead of only `site.title`

### Added
- `<meta name="description">` using `page.description` with fallback to `site.description`
- `defer` attribute to JS scripts to avoid blocking HTML parsing
- `try/catch` in clipboard API call with visible error feedback
- Sitemap `<link>` declaration in `<head>`
- WebP version of `bio-photo` image (125KB → 27KB, -78%)
- `<picture>` element in about page with WebP/JPG fallback and `loading="lazy"`
- `description` field in `_config.yml`

## [0.1.6] - 2026-01-06

### Fixed
- List indentation in post content

## [0.1.5] - 2025-12-08

### Fixed
- Notice block styling
- Dark mode background and code block colors

## [0.1.4] - 2025-07-25

### Fixed
- CSS improvements

## [0.1.3] - 2025-07-23

### Added
- Old post warning message

### Fixed
- Multiline link hover effect
- Highlighted `<pre>` background color

## [0.1.2] - 2025-07-15

### Added
- Dark/light theme toggle with system preference detection and localStorage persistence
- Preview image generation plugin
- New social media links in sidebar

### Fixed
- Responsive menu background
- Title hover effect
- Avatar sizing

## [0.1.0] - 2025-03-08

### Fixed
- Footer position
- Sidebar and pages layout
