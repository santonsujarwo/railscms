# RailsCMS

A custom Ruby on Rails CMS built around ACF-inspired Hybrid Flexible Content.

## Architecture

- Ruby on Rails 8 server-rendered public website
- Rails admin with Hotwire and Stimulus
- PostgreSQL with JSONB flexible content
- Developer-defined section registry with configurable field definitions
- Per-section content, layout, style, and responsive JSON documents
- Global design tokens
- Posts and hierarchical categories
- Per-page and per-post SEO metadata (title, description, canonical URL, noindex)
- Content revision snapshots for pages and posts
- Media Library with image validation and S3-compatible object storage
- Docker deployment target for Railway

The visual drag-and-drop builder is intentionally excluded from v1.

## Requirements

- Ruby 3.3+
- PostgreSQL 14+
- Node.js is not required for the importmap-based application frontend

## Local setup

1. Copy `.env.example` to `.env`.
2. Configure `DATABASE_URL`, `SECRET_KEY_BASE`, and `ADMIN_PASSWORD`.
3. Install dependencies: `bundle install`.
4. Prepare the database: `bin/rails db:prepare`.
5. Seed initial section definitions and global styles: `bin/rails db:seed`.
6. Start the server: `bin/rails server`.

The admin includes Pages, Posts, Categories, Media Library, Sections, and Global Styles. Posts can be drafted, scheduled, published, categorized, and configured with SEO metadata. Page and post edits are captured in a revision history. The Media Library accepts JPEG, PNG, WebP, GIF, and AVIF images up to 15 MB.

## Railway deployment

Deploy the repository using the included Dockerfile. Add a Railway PostgreSQL service and expose its connection string to the web service as `DATABASE_URL`.

Set these variables:
- `RAILS_ENV=production`
- `RAILS_SERVE_STATIC_FILES=true`
- `SECRET_KEY_BASE` (generate a unique secret)
- `ADMIN_EMAIL`
- `ADMIN_PASSWORD`
- `ACTIVE_STORAGE_SERVICE=r2`
- `R2_ACCESS_KEY_ID`
- `R2_SECRET_ACCESS_KEY`
- `R2_BUCKET`
- `R2_ENDPOINT` (Cloudflare R2 endpoint, e.g. `https://<account-id>.r2.cloudflarestorage.com`)

The production storage service defaults to R2 so uploads are not silently written to Railway's ephemeral container filesystem. Keep the R2 bucket private unless public delivery is intentionally configured.

Run `bin/rails db:seed` once after the first deployment to create the administrator and default design tokens. The Docker start command runs `db:prepare`.

## Current implementation status

The CMS includes the initial flexible-content editor, Posts, Categories, SEO fields, basic revision snapshots, and an initial Media Library. It is not yet production-ready: CI must pass, revision restore UI, richer field types, media picker integration, and production QA remain outstanding.
