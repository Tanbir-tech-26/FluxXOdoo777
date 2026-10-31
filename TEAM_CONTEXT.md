# FluxXOdoo — Shared Team Technical Context

## 1. Project Overview

Project: FluxXOdoo
Client scenario: Brightloop Software
Repository: https://github.com/Tanbir-tech-26/FluxXOdoo777

Build a subscription management platform inspired by Odoo.

## 2. Technology Stack

- Next.js App Router
- TypeScript
- Tailwind CSS
- Supabase PostgreSQL
- Supabase Auth
- Zod validation
- Recharts for analytics

## 3. Core Requirements

- Signup, login and password reset
- Admin, Staff and Customer roles
- Products and product variants
- Daily, weekly, monthly and yearly plans
- Subscription lifecycle management
- Quotations and quotation templates
- Automatic invoice generation
- Tax and discount calculations
- Payment recording
- Overdue invoice tracking
- Admin dashboard and analytics
- Customer portal
- Target response time under 2 seconds with thousands of subscriptions

## 4. Team Responsibilities

### Tanbir — Project Lead
- Authentication and authorization
- Role-based access control
- Admin dashboard
- Analytics and reports
- Final integration and deployment

### Abhinav — Backend and Billing
- Database schema and migrations
- Products and variants
- Subscription plans
- Subscription lifecycle
- Quotations
- Invoice generation
- Taxes and discounts
- Payment recording
- Overdue tracking

### Third Developer — Frontend and Customer Portal
- Responsive application layout
- Customer dashboard
- Product and plan screens
- Subscription screens
- Invoice screens
- Payment screens
- API integration

## 5. Suggested Database Tables

- profiles
- products
- product_variants
- plans
- plan_products
- quotation_templates
- quotations
- quotation_items
- subscriptions
- subscription_items
- tax_rules
- discount_rules
- invoices
- invoice_items
- payments

Use UUID primary keys, foreign keys, timestamps and suitable indexes.
Use decimal/numeric types for money, not floating-point types.

## 6. Business Rules

### Authentication
- Each email belongs to one account.
- Password must be more than 8 characters.
- Require uppercase, lowercase and special character.
- Only Admin can create Staff accounts.
- Customers can access only their own records.

### Products and Variants
- Product name, type, sales price, cost price and notes.
- Variants can add price adjustments.
- Example: Odoo brand variant adds 560 to the base price.

### Plans
- Billing intervals: daily, weekly, monthly, yearly.
- Minimum quantity.
- Availability start and end dates.
- Configurable pause, early close, renewal and automatic closure.

### Subscription Lifecycle
Draft → Quotation → Confirmed → Active → Closed

Each subscription has a unique number, customer, plan, dates, payment terms and line items.

### Invoices
- Generate invoices from subscriptions.
- Automatically calculate taxes and discounts.
- Prevent duplicate billing.
- States: Draft, Confirmed, Paid.
- Support confirmation, cancellation, sending and printing.

### Discounts
- Fixed amount or percentage.
- Minimum purchase or quantity.
- Start and end dates.
- Usage limits.
- Product-specific or subscription-wide.

### Payments
- Record method, amount, date and note.
- Link payments to invoices.
- Track paid, outstanding and overdue amounts.
- Use simulated payments for the hackathon. Do not collect real money.

## 7. API Conventions

Use Next.js Route Handlers under src/app/api/.

Suggested endpoints:

- GET/POST /api/products
- GET/POST /api/plans
- GET/POST /api/subscriptions
- POST /api/subscriptions/[id]/activate
- POST /api/subscriptions/[id]/pause
- POST /api/subscriptions/[id]/renew
- GET/POST /api/quotations
- GET/POST /api/invoices
- POST /api/invoices/generate
- POST /api/payments
- GET /api/dashboard/summary

Use Zod validation, consistent JSON responses and correct HTTP status codes.

## 8. Collaboration Rules

- Use the existing Next.js project and src/ directory.
- Never create another nested Next.js project.
- Do not overwrite another member's files.
- Agree on API contracts before frontend integration.
- Document database schema changes.
- Use environment variables for secrets.
- Never commit .env.local or API secrets.
- Coordinate Git pushes to avoid conflicts.
- Pull latest main before contributing.
- Test changes before committing.

## 9. Performance

- Index frequently filtered foreign keys, dates and status fields.
- Paginate large lists.
- Avoid loading thousands of records into the browser.
- Calculate financial totals with exact decimal arithmetic.
- Enforce authorization on the server.
- Target page response under 2 seconds.

## 10. MVP Priorities

1. Authentication and roles
2. Products and plans
3. Subscription management
4. Invoice generation
5. Payment recording
6. Admin dashboard
7. Customer portal
8. Taxes, discounts and advanced reporting

## 11. Team Progress

| Module | Owner | Status |
|---|---|---|
| Authentication and RBAC | Tanbir | Pending |
| Admin dashboard | Tanbir | Pending |
| Analytics | Tanbir | Pending |
| Database and billing APIs | Abhinav | In progress |
| Products and plans | Abhinav | Pending |
| Invoices and payments | Abhinav | Pending |
| Customer portal | Third developer | Pending |
| Subscription UI | Third developer | Pending |
| Integration and deployment | Whole team | Pending |

Update this document whenever a major implementation decision or progress status changes.
