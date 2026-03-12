# Contributing Guide

This repository is maintained by a team of three developers. This document defines the standard workflow to keep development clean and predictable.

## 1) Team workflow

- Keep `main` always deployable and stable.
- Do not commit directly to `main` for feature work.
- Use short-lived branches and open Pull Requests.
- Require at least one review before merge.
- Prefer small PRs focused on one topic.

## 2) Branch strategy

Create branches from `main` using one of these prefixes:

- `feature/<scope>-<short-description>`
- `fix/<scope>-<short-description>`
- `refactor/<scope>-<short-description>`
- `docs/<scope>-<short-description>`
- `chore/<scope>-<short-description>`
- `hotfix/<scope>-<short-description>`

Examples:

- `feature/frontend-auth-refresh-token`
- `feature/backend-deliveries-auto-assign`
- `fix/backend-services-provider-validation`
- `docs/project-team-onboarding`

## 3) Commit conventions

Use concise, semantic commit messages:

- `feat(frontend): add login token refresh`
- `feat(backend): add deliveries auto-assign endpoint`
- `fix(frontend): handle 401 token expiration`
- `refactor(backend): split services serializers`
- `docs: update onboarding and run instructions`
- `chore: update gitignore and env templates`

Rules:

- Keep subject line under ~72 chars when possible.
- Use present tense and imperative mood.
- One logical change per commit.
- Do not use emoji in commit messages.

## 4) Pull Request process

1. Update local `main`.
2. Create a branch from `main`.
3. Commit in logical chunks.
4. Push branch to origin.
5. Open PR to `main`.
6. Request review from at least one teammate.
7. Address feedback.
8. Merge only when checks pass.

## 5) PR size and scope

- Prefer PRs under ~500 changed lines when possible.
- Separate backend/frontend/docs changes into independent PRs unless tightly coupled.
- If a change is large, split into stacked PRs.

## 6) Code quality checks

### Frontend (Flutter)

Run before opening PR:

```powershell
Set-Location frontend
flutter pub get
flutter analyze
flutter test
```

### Backend (Django)

Run before opening PR:

```powershell
Set-Location backend
$c = "c:\Users\Usuario\Documents\runners\.venv\Scripts\python.exe"
& $c manage.py check
& $c manage.py test
```

If tests are not available for a module yet, include clear manual verification steps in the PR description.

## 7) Environment and secrets

- Never commit real secrets.
- Use template files only:
  - `frontend/.env.example`
  - `backend/.env.example`
- Local runtime files are ignored:
  - `frontend/.env`
  - `backend/.env`

## 8) Database and migrations

- Create migrations in the same PR where model changes are introduced.
- Do not edit applied migrations unless absolutely necessary.
- Verify migrations locally:

```powershell
Set-Location backend
$c = "c:\Users\Usuario\Documents\runners\.venv\Scripts\python.exe"
& $c manage.py makemigrations
& $c manage.py migrate
```

## 9) API changes

When changing backend endpoints:

- Update serializers/views/urls consistently.
- Update `backend/runners_api_postman.json` if needed.
- Document breaking changes in PR description.

## 10) Frontend-backend coordination

When a contract changes:

- Backend PR includes API contract details.
- Frontend PR includes updated integration usage.
- Mention required deployment order in PR.

## 11) Merge policy

- Preferred merge method: Squash or Rebase (team decision, keep history readable).
- Delete branch after merge.
- If urgent production issue: use `hotfix/*` and open PR with priority review.

## 12) Quick start for developers

```powershell
# Clone and enter repo
Set-Location "c:\Users\Usuario\Documents"
git clone https://github.com/Karatsuyu/Runners.git
Set-Location Runners

# Backend
Set-Location backend
$c = "c:\Users\Usuario\Documents\runners\.venv\Scripts\python.exe"
& $c manage.py migrate
& $c manage.py seed_data
& $c manage.py runserver 0.0.0.0:8000

# Frontend (new terminal)
Set-Location "c:\Users\Usuario\Documents\runners\frontend"
flutter pub get
flutter run
```

## 13) Ownership and communication

- Assign each PR to one owner and one reviewer.
- Use PR description to explain:
  - What changed
  - Why it changed
  - How it was tested
  - Any risks or follow-up tasks

Keeping this workflow consistent will reduce regressions and make onboarding easier for all developers.
