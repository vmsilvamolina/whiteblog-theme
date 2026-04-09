# Changelog

All notable changes to this project will be documented in this file.

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
