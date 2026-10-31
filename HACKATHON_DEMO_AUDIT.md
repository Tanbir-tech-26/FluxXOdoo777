# FluxXOdoo — Remote Repository Audit

Audit date: 2026-10-31  
Repository: https://github.com/Tanbir-tech-26/FluxXOdoo777  
Audit branch: `codex/final-demo-audit`  
Base commit: `c89a4268c2d0ea889aef45a2863c03b18d222069`

This is a read-only audit of the remote branches plus a small documentation correction on this isolated branch. It does not inspect uncommitted files on either team member's Mac.

## Executive summary

The remote repository does not yet contain a complete hackathon demo. The default branch contains a Next.js starter and Supabase client/test code, while the separately pushed Lovable branch contains a TanStack Start scaffold whose home route is explicitly a placeholder. The previously discussed Tanbir frontend dashboard implementation exists in the local workspace but was not present in the remote branch inventory at audit time.

Do not treat the local and remote workspaces as synchronized.

## Remote branch inventory

| Branch | Observed contents | Assessment |
|---|---|---|
| `main` | Next.js 16 starter, Supabase client/test, schema recovery docs | Base project; not a complete demo |
| `develop` | README only | No app implementation observed |
| `feature/admin-dashboard` | README only | No dashboard implementation observed |
| `feature/fluxxodoo-lovable` | Separate TanStack Start app under `lovable-app/` | Scaffold only; home route is a placeholder |
| `feature/tanbir-frontend` | Not returned by remote branch listing | Local frontend branch not verified on GitHub |

The Lovable roadmap says to keep that app separate from the Next.js implementation. Do not merge it into the Next.js app without an explicit architecture decision.

## Verified application gaps on remote main

- `src/app/page.tsx` is the default Next.js starter page.
- `src/app/layout.tsx` still has the title `Create Next App`.
- No dashboard, auth, or business-module routes were present in the main branch tree inventory.
- `src/app/supabase-test/page.tsx` statically imports the Supabase test module at page scope. That imports the Supabase client during prerender. If the public Supabase URL is absent at build time, `createClient` can throw `supabaseUrl is required`.
- The main branch Supabase client uses non-null assertions for public environment variables. A non-null assertion does not provide runtime validation.
- The schema snapshot records 13 tables and 20 RLS policies, but is explicitly a reconstructed catalog snapshot, not a full backup.

## Database and authorization risks

Based on the committed RLS policy inventory:

1. Products and product variants have internal-user management policies, but no customer-facing SELECT policy is shown. A customer plan/catalog flow therefore needs a reviewed public/authenticated read policy or a server-side safe catalog endpoint.
2. The `is_internal_user()` helper groups Admin and Staff. The recovered policies do not implement a separate Admin-versus-Staff permission matrix.
3. Profiles have a read-own-or-internal SELECT policy. The inventory does not show a profile UPDATE policy or a dedicated admin-only Staff creation policy.
4. `cost_price` exists on products. It must never be returned to customers or exposed through a customer catalog response.
5. Invoice and payment read policies use ownership checks through customer_id. Every server query and RLS policy must preserve ownership boundaries.
6. Subscription items have no variant_id in the recovered columns.
7. The recovered subscription schema has no next_billing_date column.
8. Quotations have no subscription_id relation in the recovered columns.
9. The snapshot does not establish idempotent invoice generation for a billing period.
10. The schema snapshot is not a migration to run against the existing Supabase project. Its README explicitly warns against doing so.

These are evidence-based review findings from the committed snapshot, not proof that no additional controls exist outside the exported public policies (for example, grants, auth settings, or server-side application logic).

## Team ownership correction

The team has two members:

- Tanbir: frontend, project lead, auth screens, dashboards, forms/tables/charts, integration, deployment.
- Abhinav: backend, Supabase, SSR/auth/DAL/API, products, plans, subscriptions, quotations, invoices, taxes, discounts, and payments.

The previous `TEAM_CONTEXT.md` incorrectly named a third developer. It has been corrected on this audit branch. Do not assign work to a third developer.

## Demo readiness matrix

| Capability | Remote evidence | Status |
|---|---|---|
| Branded landing page | Starter page remains | Pending |
| Login/signup/password reset | No routes observed on main | Pending |
| Admin dashboard | No route observed on main | Pending remotely; local Tanbir work exists separately |
| Staff dashboard | No route observed on main | Pending remotely; local Tanbir work exists separately |
| Customer portal | No route observed on main | Pending |
| Product/plan management | Schema tables only; no UI/API routes observed on main | Pending |
| Subscription lifecycle | Schema tables only; no UI/API routes observed on main | Pending |
| Quotations | Schema tables only; no UI/API routes observed on main | Pending |
| Invoice generation | Schema tables only; no UI/API routes observed on main | Pending |
| Simulated payment | Schema column default indicates simulated method; no workflow observed | Pending |
| RLS | 20 policies recorded in snapshot | Implemented in DB snapshot; requires live security testing |
| Production build | Not tested through this remote audit | Unverified |

## Recommended order of work

1. Choose the Next.js implementation as the single hackathon demo target if continuing the existing Tanbir local work. Keep the Lovable scaffold isolated.
2. Reconcile the local Tanbir branch with GitHub safely; first inspect local status, nested repository, remotes, and branch ancestry. Do not overwrite local work or merge automatically.
3. Integrate the actual frontend routes and components; create every route used by navigation or replace missing links with intentional, clearly labelled demo placeholders.
4. Verify the landing page, login/demo entry, role dashboards, and role-specific navigation.
5. Coordinate backend API contracts with Abhinav. Do not edit his Supabase SSR, proxy, DAL, or API files without coordination.
6. Complete and test customer-safe catalog access, role separation, profile role protection, record ownership, and cost-price isolation.
7. Implement the core happy path: product/plan → subscription → quotation (if required) → invoice → simulated payment.
8. Run lint, TypeScript, production build, and browser walkthrough for all roles. Test with real Supabase configuration only in the local environment; never commit secrets.
9. Deploy only after the chosen branch passes the checks and the team confirms the deployment target.

## Git safety

This audit branch is isolated from `main`. No branch was merged and no existing branch was force-pushed, reset, cleaned, or deleted. The audit does not claim the local uncommitted dashboard files were uploaded.
