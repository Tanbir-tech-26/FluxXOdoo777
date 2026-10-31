# FluxXOdoo — Task Roadmap

Master spec: uploaded MASTER_BUILD_PROMPT (subscription-management ERP for Brightloop Software, hackathon MVP).
Framework decision: standalone build on Lovable (TanStack Start); the Next.js app in
Tanbir-tech-26/FluxXOdoo777 stays untouched. Lovable source syncs to branch
`feature/fluxxodoo-lovable` under `lovable-app/` via the GitHub connector (never push to main/develop/feature/admin-dashboard).

## GitHub integration — DONE
- [x] Inspect repo & branches (main = full Next.js app, develop = README, feature/admin-dashboard)
- [x] Link GitHub connector with push access (verified `push: true` on FluxXOdoo777)
- [x] Create `feature/fluxxodoo-lovable` from main; push Lovable scaffold under `lovable-app/`; commit verified via API

## Phase 1 — Inspect & stabilize
- [ ] Enable Lovable Cloud (database + auth)
- [ ] Design system in src/styles.css (enterprise SaaS, Odoo-inspired, no generic AI look)

## Phase 2 — Core UI
- [ ] Landing page (branded hero, features, workflow, login/register)
- [ ] Auth: login, customer registration, forgot/reset password, unauthorized page, profile
- [ ] App shell: sidebar, topbar, mobile nav, breadcrumbs, role-specific navigation
- [ ] Admin / Staff / Customer dashboards with charts (Recharts)

## Phase 3 — Core business modules
- [ ] Database schema: 13 tables (profiles, products, product_variants, plans, subscriptions, subscription_items, quotations, quotation_items, invoices, invoice_items, payments, discount_rules, tax_rules) + RLS + demo data
- [ ] Customers, Products & variants, Plans
- [ ] Subscriptions: lifecycle Draft→Quotation→Confirmed→Active→Closed (+Paused/Cancelled), server-side pricing

## Phase 4 — Billing
- [ ] Quotations (expiry validation, accept/reject, convert to subscription)
- [ ] Invoices (server totals, duplicate-period prevention, overdue detection, printable)
- [ ] Taxes & discounts (decimal-safe arithmetic, nonnegative totals)
- [ ] Simulated payments ("Demo Payment — No real money was collected")

## Phase 5 — Reports & polish
- [ ] Reports (admin + staff) with date/status filters
- [ ] Settings (admin-only)
- [ ] Loading/empty/error states, toasts, responsive refinement

## Phase 6 — QA & demo
- [ ] Auth/authorization/ownership tests (incl. cost-price hiding, role escalation)
- [ ] Subscription lifecycle, quotation, invoice, payment flow tests
- [ ] Demo data reset; demo accounts via secure setup
- [ ] TypeScript/ESLint/build checks; browser walkthrough; final GitHub milestone push

## Guardrails (from user, mandatory)
- Never force-push/reset/clean/delete branches; never overwrite existing work; no merge to main without explicit approval; never claim a push without GitHub confirming the commit.
