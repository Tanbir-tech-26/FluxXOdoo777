import { supabase } from "./client";

export async function testSupabaseConnection() {
  const { data, error } = await supabase
    .from("products")
    .select("id")
    .limit(1);

  if (error) {
    console.error("Supabase error:", error.message);
    return;
  }

  console.log("Supabase connected successfully!", data);
}