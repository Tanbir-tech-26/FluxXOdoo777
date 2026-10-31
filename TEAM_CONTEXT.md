# FluxXOdoo — Shared Team Technical Context

## 1. Project Overview

- Project: FluxXOdoo
- Client scenario: Brightloop Software
- Repository: https://github.com/Tanbir-tech-26/FluxXOdoo777
- Product: Subscription management platform inspired by Odoo.

## 2. Technology Direction

The primary application currently present on `main` is a Next.js App Router project using TypeScript, Tailwind CSS, and Supabase. The repository also contains a separate experimental Lovable/TanStack Start scaffold on `feature/fluxxodoo-lovable`. These are separate implementations; do not merge or mix their framework conventions without an explicit architecture decision.

The Next.js project uses Next.js 16. Read the relevant guides in `node_modules/next/dist/docs/` before changing Next.js code. Use `src/proxy.ts` for the Next.js 16 proxy convention; do not introduce deprecated Middleware conventions.

## 3. Actual Team Structure — Two Members

There are exactly two team members. Do not assign work to or document a third developer.

### Tanbir — Frontend & Project Lead

- Frontend architecture and implementation.
- Landing page and authentication screens.
- Admin, Staff, and Customer dashboards.
- Responsive shell, navigation, forms, tables, charts, and reusable UI.
- Frontend/API integration and API contract coordination.
- Final integration, deployment, and demo preparation.

### Abhinav — Backend & Billing

- Supabase database architecture and schema.
- Supabase Auth and SSR session handling.
- Server-side authorization and Data Access Layer.
- API route handlers and validation.
- Products and product variants.
- Plans and subscriptions.
- Quotations and invoices.
- Taxes, discounts, payment recording, and billing rules.

Both members coordinate integration, testing, and demo readiness. Do not invent a third developer or reassign either member's work without agreement.

## 4. Core Product Requirements

- Signup, login, password reset, and profile management.
- Admin, Staff, and Customer roles.
- Products and product variants.
- Daily, weekly, monthly, and yearly plans.
- Subscription lifecycle management.
- Quotations and quotation templates where implemented.
- Invoice generation and overdue tracking.
- Tax and discount calculations.
- Payment recording; hackathon payments must be simulated and clearly labelled.
- Admin dashboard, analytics, reports, and customer portal.

## 5. Business and Security Rules

### Authentication and roles
- Each email belongs to one account.
- Password policy should be enforced consistently by the auth layer.
- Only Admin may create Staff accounts.
- Customer access must be limited to records owned by that customer.
- Never trust client-provided role values.
- A user must not be able to elevate or change their own role through profile updates.

### Products and variants
- Products include name, type, sales price, cost price, and optional notes.
- Variants may add a price adjustment.
- Never expose `cost_price` to customers or public catalog responses.

### Plans and subscriptions
- Billing intervals: daily, weekly, monthly, yearly.
- Validate minimum quantity and availability dates.
- Enforce valid lifecycle transitions server-side.
- Subscription pricing must be calculated on the server.

### Invoices and payments
- Generate invoices from eligible subscriptions.
- Calculate totals server-side using decimal-safe arithmetic.
- Prevent duplicate billing for the same subscription period.
- Track paid, outstanding, and overdue balances.
- Payments are simulated for the hackathon; do not collect real money or imply that a real payment provider is connected.

## 6. Database

The recovered Supabase catalog snapshot records these 13 tables:

- profiles
- products
- product_variants
- plans
- subscriptions
- subscription_items
- quotations
- quotation_items
- invoices
- invoice_items
- payments
- discount_rules
- tax_rules

The snapshot is a catalog reconstruction, not a complete database backup. It contains no application data and omits Supabase-managed configuration and secrets. Never run `FluxXOdoo-Supabase-Schema-Recovery/schema_snapshot.sql` against the existing Supabase project; it is a reference for a separately reviewed rebuild only.

## 7. API Conventions

For the Next.js implementation, use App Router Route Handlers under `src/app/api/`.

Potential endpoints include:

- GET/POST `/api/products`
- GET/POST `/api/plans`
- GET/POST `/api/subscriptions`
- POST `/api/subscriptions/[id]/activate`
- POST `/api/subscriptions/[id]/pause`
- POST `/api/subscriptions/[id]/renew`
- GET/POST `/api/quotations`
- GET/POST `/api/invoices`
- POST `/api/invoices/generate`
- POST `/api/payments`
- GET `/api/dashboard/summary`

These are design targets, not claims that every endpoint already exists. Use Zod validation, consistent JSON responses, correct HTTP status codes, server-side role checks, and customer ownership checks.

## 8. Collaboration and Git Safety

- Preserve existing work in both members' local workspaces.
- Do not assume local work has been pushed or that two workspaces are synchronized.
- Agree on API contracts before integration.
- Document schema changes.
- Keep secrets in environment variables; never commit `.env.local`, service-role keys, or API secrets.
- Do not force-push, reset, clean, delete branches, or rewrite published history.
- Do not merge work into `main` without review.
- Keep the standalone `lovable-app/` scaffold isolated unless the team explicitly chooses it as the primary application.
- Verify every push or commit using the returned GitHub SHA; never claim an operation succeeded without confirmation.

## 9. Performance and Quality

- Index frequently filtered foreign keys, dates, and status fields where justified.
- Paginate large lists.
- Avoid sending unnecessary records to the browser.
- Use exact decimal arithmetic for money.
- Enforce authorization on the server and in RLS.
- Test all roles independently.
- Distinguish real backend functionality from mock/demo data.

## 10. MVP Priorities

1. Authentication and role authorization.
2. Products and plans.
3. Subscription management.
4. Quotations and invoice generation.
5. Simulated payment recording.
6. Admin and Staff dashboards.
7. Customer portal.
8. Tax, discount, reporting, and polish.

## 11. Progress Tracking

Keep implementation status evidence-based. Use these labels:

- Working — verified end-to-end.
- Implemented — code exists but has not been fully tested.
- Demo — mock data or simulated functionality.
- Pending — not implemented.
- Blocked — waiting on a dependency or configuration.

Update this document when team responsibilities or architecture decisions change. Do not mark a feature complete merely because a route, component, schema table, or build exists.
