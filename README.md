# CodeJudge API

Rails 8 API-only application implementing the [CodeJudge OpenAPI specification](codejudge.yml).

## Stack

- **Ruby** ~> 3.3
- **Rails** ~> 8.0
- **PostgreSQL** 16
- **Redis** 7 (JWT session store via `jwt_sessions`)
- **Docker** + Docker Compose

## Quick start with Docker

1. **Create `.env`** (optional; defaults work with Compose):

   ```bash
   cp .env.example .env
   ```

2. **Start services and run migrations:**

   ```bash
   docker compose up -d db redis
   docker compose run --rm web bundle install
   docker compose run --rm web rails db:create db:migrate
   docker compose up web
   ```

   The image uses an entrypoint that runs `bundle exec` for `rails` and `rake`, so you can type `rails` (no need for `bin/rails` or `bundle exec rails`). If you see an error like `ruby\r: No such file or directory`, the `bin/rails` / `bin/rake` files have Windows CRLF line endings. Fix them with:
   `docker compose run --rm web bash -c "sed -i 's/\r$//' bin/rails bin/rake"`

3. **Seed the database (optional):** `docker compose run --rm web rails db:seed`

4. **API base URL:** `http://localhost:3000/api/v1`

## Running without Docker

- Install Ruby 3.3+, PostgreSQL, Redis.
- Set `DATABASE_HOST`, `REDIS_URL` (e.g. `redis://localhost:6379/0`) and optionally `SECRET_KEY_BASE`, `JWT_ENCRYPTION_KEY`.
- Run `bundle install`, `rails db:create db:migrate`, `rails server`.

## Endpoints (from OpenAPI spec)

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | `/api/v1/auth/register` | No | Register; returns JWT |
| POST | `/api/v1/auth/login` | No | Login; returns JWT |
| GET | `/api/v1/current_user` | Bearer | Current user profile |
| GET | `/api/v1/assignments` | No | List assignments |
| GET | `/api/v1/assignments/:id` | No | Get assignment |
| POST | `/api/v1/assignments` | Bearer | Create assignment |
| PATCH | `/api/v1/assignments/:id` | Bearer | Update assignment |
| DELETE | `/api/v1/assignments/:id` | Bearer | Delete assignment |
| GET | `/api/v1/assignments/:id/test_cases` | Bearer | List test cases |
| POST | `/api/v1/assignments/:id/test_cases` | Bearer | Add test case |
| PATCH | `/api/v1/test_cases/:test_case_id` | Bearer | Update test case |
| DELETE | `/api/v1/test_cases/:test_case_id` | Bearer | Delete test case |
| POST | `/api/v1/assignments/:id/submissions` | Bearer | Submit code (202) |
| GET | `/api/v1/submissions/:submission_id` | Bearer | Submission report |
| PATCH | `/api/v1/submissions/:submission_id` | Bearer | Update submission (comment/score) |
| GET | `/api/v1/leaderboard` | No | Student leaderboard |

Use the returned `access_token` as `Authorization: Bearer <token>` for protected routes.

## Testing mode (chaos injection)

In **development** and **test**, any request can opt into random errors or timeouts so API consumers can test error handling and retries. Add optional query params (no effect if omitted):

| Param | Range | Description |
|-------|--------|-------------|
| `inject_error_pct` | 1–100 | Percentage chance to return a random 4xx/5xx (400, 401, 403, 404, 422, 500, 502, 503). |
| `inject_timeout_pct` | 1–100 | Percentage chance to sleep then return 504 Gateway Timeout. |
| `inject_timeout_sec` | number | Seconds to sleep when timeout is triggered (default: 2; capped at 60). |

Example: `GET /api/v1/assignments?inject_error_pct=20&inject_timeout_pct=10&inject_timeout_sec=3`

In **production**, chaos injection is disabled unless `ENABLE_CHAOS_INJECTION=true` is set.

## Tests

```bash
docker compose run --rm -e RAILS_ENV=test web rails db:create db:migrate
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec
```

Ensure Redis is reachable in test (e.g. `REDIS_URL=redis://redis:6379/1` when using Compose).
