# FluxXOdoo Supabase schema recovery snapshot

Generated: 2026-10-31  
Source: six CSV exports taken from the existing Supabase project's PostgreSQL catalog.

## Recovered inventory

- 13 public tables
- 98 columns
- 47 constraints: 13 primary keys, 14 foreign keys, 16 check constraints, 4 unique constraints
- 26 indexes (including indexes backing constraints)
- 20 RLS policies
- 2 public functions
- 1 trigger on `auth.users`

## Files

- `schema_snapshot.sql` — reconstructed SQL snapshot of tables, constraints, non-constraint indexes, functions, RLS enablement, policies, and the auth trigger.
- `01_columns.csv` through `06_triggers.csv` — raw catalog exports used to build the snapshot.

## Important safety notes

1. This is a recovery snapshot reconstructed from catalog exports, not an official Supabase backup.
2. **Do not run `schema_snapshot.sql` against the existing project.** The existing project already contains these tables, policies, indexes, functions, and trigger. Running it there can cause duplicate-object errors or unwanted changes.
3. The SQL is intended as a reviewed starting point for rebuilding a separate, empty Supabase project. Supabase-managed roles, extensions, grants, auth configuration, storage, secrets, and other project settings are not included.
4. Review the script before using it. The catalog exports provide the current definitions, but this is not a full point-in-time database backup and contains no table data.
5. The current RLS policy inventory shows admin and staff share the `is_internal_user()` access path. This does not implement a separate admin/staff permission matrix.
6. Do not put service-role keys or other secrets in this repository.

## Verified table list

`profiles`, `products`, `product_variants`, `plans`, `subscriptions`, `subscription_items`, `quotations`, `quotation_items`, `invoices`, `invoice_items`, `payments`, `discount_rules`, `tax_rules`.
