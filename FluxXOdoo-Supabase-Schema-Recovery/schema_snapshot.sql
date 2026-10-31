-- FluxXOdoo Supabase schema snapshot reconstructed from catalog exports.
-- IMPORTANT: Review before use. Intended as a reference/rebuild script for a NEW empty project.
-- Do NOT run on the existing project: tables and policies already exist there.
-- Snapshot generated 2026-10-31 from supplied information_schema/pg_catalog CSV exports.

CREATE TABLE public."discount_rules" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "name" text NOT NULL,
  "discount_type" text NOT NULL,
  "discount_value" numeric(12,2) NOT NULL,
  "minimum_purchase" numeric(12,2) DEFAULT 0,
  "usage_limit" integer,
  "start_date" date,
  "end_date" date,
  "is_active" boolean NOT NULL DEFAULT true,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "discount_rules_discount_type_check" CHECK ((discount_type = ANY (ARRAY['fixed'::text, 'percentage'::text]))),
  CONSTRAINT "discount_rules_discount_value_check" CHECK ((discount_value >= (0)::numeric)),
  CONSTRAINT "discount_rules_pkey" PRIMARY KEY (id)
);

CREATE TABLE public."invoice_items" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "invoice_id" uuid NOT NULL,
  "product_id" uuid,
  "description" text,
  "quantity" integer NOT NULL DEFAULT 1,
  "unit_price" numeric(12,2) NOT NULL DEFAULT 0,
  "tax_amount" numeric(12,2) NOT NULL DEFAULT 0,
  "line_total" numeric(12,2) NOT NULL DEFAULT 0,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "invoice_items_quantity_check" CHECK ((quantity > 0)),
  CONSTRAINT "invoice_items_invoice_id_fkey" FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
  CONSTRAINT "invoice_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id),
  CONSTRAINT "invoice_items_pkey" PRIMARY KEY (id)
);

CREATE TABLE public."invoices" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "invoice_number" text NOT NULL,
  "subscription_id" uuid,
  "customer_id" uuid NOT NULL,
  "issue_date" date NOT NULL DEFAULT CURRENT_DATE,
  "due_date" date,
  "subtotal" numeric(12,2) NOT NULL DEFAULT 0,
  "tax_amount" numeric(12,2) NOT NULL DEFAULT 0,
  "discount_amount" numeric(12,2) NOT NULL DEFAULT 0,
  "total_amount" numeric(12,2) NOT NULL DEFAULT 0,
  "status" text NOT NULL DEFAULT 'draft'::text,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "invoices_status_check" CHECK ((status = ANY (ARRAY['draft'::text, 'confirmed'::text, 'paid'::text, 'overdue'::text, 'cancelled'::text]))),
  CONSTRAINT "invoices_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES profiles(id),
  CONSTRAINT "invoices_subscription_id_fkey" FOREIGN KEY (subscription_id) REFERENCES subscriptions(id),
  CONSTRAINT "invoices_pkey" PRIMARY KEY (id),
  CONSTRAINT "invoices_invoice_number_key" UNIQUE (invoice_number)
);

CREATE TABLE public."payments" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "invoice_id" uuid NOT NULL,
  "amount" numeric(12,2) NOT NULL,
  "payment_method" text NOT NULL DEFAULT 'simulated'::text,
  "payment_date" timestamp with time zone NOT NULL DEFAULT now(),
  "note" text,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "payments_amount_check" CHECK ((amount > (0)::numeric)),
  CONSTRAINT "payments_invoice_id_fkey" FOREIGN KEY (invoice_id) REFERENCES invoices(id),
  CONSTRAINT "payments_pkey" PRIMARY KEY (id)
);

CREATE TABLE public."plans" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "name" text NOT NULL,
  "billing_interval" text NOT NULL,
  "price" numeric(12,2) NOT NULL DEFAULT 0,
  "minimum_quantity" integer NOT NULL DEFAULT 1,
  "start_date" date,
  "end_date" date,
  "auto_close" boolean NOT NULL DEFAULT false,
  "is_active" boolean NOT NULL DEFAULT true,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "plans_billing_interval_check" CHECK ((billing_interval = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly'::text, 'yearly'::text]))),
  CONSTRAINT "plans_minimum_quantity_check" CHECK ((minimum_quantity > 0)),
  CONSTRAINT "plans_price_check" CHECK ((price >= (0)::numeric)),
  CONSTRAINT "plans_pkey" PRIMARY KEY (id)
);

CREATE TABLE public."product_variants" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "product_id" uuid NOT NULL,
  "name" text NOT NULL,
  "price_extra" numeric(12,2) NOT NULL DEFAULT 0,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "product_variants_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  CONSTRAINT "product_variants_pkey" PRIMARY KEY (id)
);

CREATE TABLE public."products" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "name" text NOT NULL,
  "product_type" text NOT NULL DEFAULT 'service'::text,
  "sales_price" numeric(12,2) NOT NULL DEFAULT 0,
  "cost_price" numeric(12,2) NOT NULL DEFAULT 0,
  "notes" text,
  "is_active" boolean NOT NULL DEFAULT true,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "products_sales_price_check" CHECK ((sales_price >= (0)::numeric)),
  CONSTRAINT "products_cost_price_check" CHECK ((cost_price >= (0)::numeric)),
  CONSTRAINT "products_pkey" PRIMARY KEY (id)
);

CREATE TABLE public."profiles" (
  "id" uuid NOT NULL,
  "full_name" text,
  "email" text NOT NULL,
  "role" text NOT NULL DEFAULT 'customer'::text,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "profiles_role_check" CHECK ((role = ANY (ARRAY['admin'::text, 'staff'::text, 'customer'::text]))),
  CONSTRAINT "profiles_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE,
  CONSTRAINT "profiles_pkey" PRIMARY KEY (id),
  CONSTRAINT "profiles_email_key" UNIQUE (email)
);

CREATE TABLE public."quotation_items" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "quotation_id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  "quantity" integer NOT NULL DEFAULT 1,
  "unit_price" numeric(12,2) NOT NULL DEFAULT 0,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "quotation_items_quantity_check" CHECK ((quantity > 0)),
  CONSTRAINT "quotation_items_quotation_id_fkey" FOREIGN KEY (quotation_id) REFERENCES quotations(id) ON DELETE CASCADE,
  CONSTRAINT "quotation_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id),
  CONSTRAINT "quotation_items_pkey" PRIMARY KEY (id)
);

CREATE TABLE public."quotations" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "quotation_number" text NOT NULL,
  "customer_id" uuid NOT NULL,
  "valid_until" date,
  "status" text NOT NULL DEFAULT 'draft'::text,
  "total_amount" numeric(12,2) NOT NULL DEFAULT 0,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "quotations_status_check" CHECK ((status = ANY (ARRAY['draft'::text, 'sent'::text, 'accepted'::text, 'rejected'::text, 'expired'::text]))),
  CONSTRAINT "quotations_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES profiles(id),
  CONSTRAINT "quotations_pkey" PRIMARY KEY (id),
  CONSTRAINT "quotations_quotation_number_key" UNIQUE (quotation_number)
);

CREATE TABLE public."subscription_items" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "subscription_id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  "quantity" integer NOT NULL DEFAULT 1,
  "unit_price" numeric(12,2) NOT NULL DEFAULT 0,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "subscription_items_quantity_check" CHECK ((quantity > 0)),
  CONSTRAINT "subscription_items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES products(id),
  CONSTRAINT "subscription_items_subscription_id_fkey" FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE CASCADE,
  CONSTRAINT "subscription_items_pkey" PRIMARY KEY (id)
);

CREATE TABLE public."subscriptions" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "subscription_number" text NOT NULL,
  "customer_id" uuid NOT NULL,
  "plan_id" uuid,
  "start_date" date,
  "end_date" date,
  "status" text NOT NULL DEFAULT 'draft'::text,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "subscriptions_status_check" CHECK ((status = ANY (ARRAY['draft'::text, 'quotation'::text, 'confirmed'::text, 'active'::text, 'paused'::text, 'closed'::text, 'cancelled'::text]))),
  CONSTRAINT "subscriptions_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES profiles(id),
  CONSTRAINT "subscriptions_plan_id_fkey" FOREIGN KEY (plan_id) REFERENCES plans(id),
  CONSTRAINT "subscriptions_pkey" PRIMARY KEY (id),
  CONSTRAINT "subscriptions_subscription_number_key" UNIQUE (subscription_number)
);

CREATE TABLE public."tax_rules" (
  "id" uuid NOT NULL DEFAULT gen_random_uuid(),
  "name" text NOT NULL,
  "tax_rate" numeric(5,2) NOT NULL,
  "is_active" boolean NOT NULL DEFAULT true,
  "created_at" timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT "tax_rules_tax_rate_check" CHECK ((tax_rate >= (0)::numeric)),
  CONSTRAINT "tax_rules_pkey" PRIMARY KEY (id)
);

CREATE INDEX idx_invoice_items_invoice ON public.invoice_items USING btree (invoice_id);
CREATE INDEX idx_invoices_customer ON public.invoices USING btree (customer_id);
CREATE INDEX idx_invoices_status ON public.invoices USING btree (status);
CREATE INDEX idx_payments_invoice ON public.payments USING btree (invoice_id);
CREATE INDEX idx_variants_product ON public.product_variants USING btree (product_id);
CREATE INDEX idx_quotation_items_quotation ON public.quotation_items USING btree (quotation_id);
CREATE INDEX idx_subscription_items_subscription ON public.subscription_items USING btree (subscription_id);
CREATE INDEX idx_subscriptions_customer ON public.subscriptions USING btree (customer_id);
CREATE INDEX idx_subscriptions_status ON public.subscriptions USING btree (status);

-- Functions
CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.profiles (id, email, full_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', '')
  );
  return new;
end;
$function$;

CREATE OR REPLACE FUNCTION public.is_internal_user()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists (
    select 1 from public.profiles
    where id = (select auth.uid())
    and role in ('admin', 'staff')
  );
$function$;

-- Enable Row Level Security
ALTER TABLE public."discount_rules" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."invoice_items" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."invoices" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."payments" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."plans" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."product_variants" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."products" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."quotation_items" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."quotations" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."subscription_items" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."subscriptions" ENABLE ROW LEVEL SECURITY;
ALTER TABLE public."tax_rules" ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "Internal users manage discounts" ON public."discount_rules" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Internal users manage invoice items" ON public."invoice_items" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Read own or internal invoice items" ON public."invoice_items" AS permissive FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM invoices i
  WHERE ((i.id = invoice_items.invoice_id) AND ((i.customer_id = ( SELECT auth.uid() AS uid)) OR is_internal_user())))));
CREATE POLICY "Internal users manage invoices" ON public."invoices" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Read own or internal invoices" ON public."invoices" AS permissive FOR SELECT TO authenticated USING (((customer_id = ( SELECT auth.uid() AS uid)) OR is_internal_user()));
CREATE POLICY "Internal users manage payments" ON public."payments" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Read own or internal payments" ON public."payments" AS permissive FOR SELECT TO authenticated USING (((EXISTS ( SELECT 1
   FROM invoices
  WHERE ((invoices.id = payments.invoice_id) AND (invoices.customer_id = ( SELECT auth.uid() AS uid))))) OR is_internal_user()));
CREATE POLICY "Internal users manage plans" ON public."plans" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Internal users manage variants" ON public."product_variants" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Internal users manage products" ON public."products" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Read own or internal profiles" ON public."profiles" AS permissive FOR SELECT TO authenticated USING (((id = ( SELECT auth.uid() AS uid)) OR is_internal_user()));
CREATE POLICY "Internal users manage quotation items" ON public."quotation_items" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Read own or internal quotation items" ON public."quotation_items" AS permissive FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM quotations q
  WHERE ((q.id = quotation_items.quotation_id) AND ((q.customer_id = ( SELECT auth.uid() AS uid)) OR is_internal_user())))));
CREATE POLICY "Internal users manage quotations" ON public."quotations" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Read own or internal quotations" ON public."quotations" AS permissive FOR SELECT TO authenticated USING (((customer_id = ( SELECT auth.uid() AS uid)) OR is_internal_user()));
CREATE POLICY "Internal users manage subscription items" ON public."subscription_items" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Read own or internal subscription items" ON public."subscription_items" AS permissive FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM subscriptions s
  WHERE ((s.id = subscription_items.subscription_id) AND ((s.customer_id = ( SELECT auth.uid() AS uid)) OR is_internal_user())))));
CREATE POLICY "Internal users manage subscriptions" ON public."subscriptions" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());
CREATE POLICY "Read own or internal subscriptions" ON public."subscriptions" AS permissive FOR SELECT TO authenticated USING (((customer_id = ( SELECT auth.uid() AS uid)) OR is_internal_user()));
CREATE POLICY "Internal users manage taxes" ON public."tax_rules" AS permissive FOR ALL TO authenticated USING (is_internal_user()) WITH CHECK (is_internal_user());

-- Auth trigger
DROP TRIGGER IF EXISTS "on_auth_user_created" ON auth."users";
CREATE TRIGGER "on_auth_user_created" AFTER INSERT ON auth."users" FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
