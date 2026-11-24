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

The initial section library includes Hero and Call to Action. The admin Pages screen supports adding a registered section and editing its schema-defined fields. The admin also provides Posts and Categories screens. Posts can be drafted, scheduled, published, categorized, and configured with SEO metadata. Page and post edits are captured in a revision history.

## Railway deployment

Deploy the repository using the included Dockerfile. Add a Railway PostgreSQL service and expose its connection string to the web service as `DATABASE_URL`.

Set these variables:
- `RAILS_ENV=production`
- `RAILS_SERVE_STATIC_FILES=true`
- `SECRET_KEY_BASE` (generate a unique secret)
- `ADMIN_EMAIL`
- `ADMIN_PASSWORD`

Run `bin/rails db:seed` once after the first deployment to create the administrator and default design tokens. The Docker start command runs `db:prepare`.

**Storage note:** local Active Storage is for development only. Configure persistent S3-compatible storage (for example Cloudflare R2) before uploading production media. Do not rely on an ephemeral application filesystem.

## Current implementation status

The CMS now includes the initial flexible-content editor, Posts, Categories, SEO fields, and basic revision snapshots. The repository is still not production-ready: Rails boot, migrations, and RSpec must be verified in CI; media storage, revision restore UI, richer field types, and production QA remain outstanding.
