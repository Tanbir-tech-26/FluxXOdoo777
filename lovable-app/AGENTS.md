<!-- LOVABLE:BEGIN -->
> [!IMPORTANT]
> This project is connected to [Lovable](https://lovable.dev). Avoid rewriting
> published git history — force pushing, or rebasing/amending/squashing commits
> that are already pushed — as it rewrites history on Lovable's side and the
> user will likely lose their project history.
>
> Commits you push to the connected branch sync back to Lovable and show up in
> the editor, so keep the branch in a working state.
<!-- LOVABLE:END -->

## GitHub sync
- Lovable source is pushed to `Tanbir-tech-26/FluxXOdoo777` branch `feature/fluxxodoo-lovable` under the `lovable-app/` prefix using the GitHub API connector (script `/tmp/github-sync/push.py`, modes initial|update). Why: the repo root holds the untouched Next.js implementation and existing branches must never be modified.
- Pushes are append-only: create the branch from `main` once, then advance it with normal commits (`force: false`). Never force-push, delete, or reset refs; never claim a push without GitHub confirming the commit SHA.

## Architecture
- FluxXOdoo is a standalone TanStack Start app on Lovable Cloud. The Next.js app in the repo is a separate implementation; do not port its framework assumptions into this codebase.

