# Railway Deployment

## 1. Create the project

- Create a Railway project.
- Deploy this GitHub repository from the `develop` branch for preview.
- Select Dockerfile as the build method (the repository includes `Dockerfile` and `railway.toml`).

## 2. Add PostgreSQL

- Add a Railway PostgreSQL service.
- Reference its connection URL from the Rails web service using Railway variable references.
- Set `DATABASE_URL` on the web service.

## 3. Configure variables

Required:
- `RAILS_ENV=production`
- `RAILS_SERVE_STATIC_FILES=true`
- `DATABASE_URL`
- `SECRET_KEY_BASE`
- `ADMIN_EMAIL`
- `ADMIN_PASSWORD`

Generate `SECRET_KEY_BASE` securely. Never commit secrets to Git.

## 4. Deploy and initialize

The Docker startup command runs `rails db:prepare`. After the first successful deployment, open a Railway shell or run a one-off command:

```bash
bin/rails db:seed
```

Then open `/users/sign_in` and sign in using the administrator credentials configured before seeding.

## 5. Production storage

Before production media uploads, configure an S3-compatible Active Storage service and use a persistent object store such as Cloudflare R2. Local disk storage inside a container is not durable across replacement deployments.

## 6. Current limitations

The initial app foundation is still under development. Background workers, production object storage, complete field types, revisions, SEO, and full production QA are not yet complete.
