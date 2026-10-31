"use client";

import { useEffect, useState } from "react";
import { testSupabaseConnection } from "@/lib/supabase/test";

export default function SupabaseTest() {
  const [status, setStatus] = useState("Testing connection...");

  useEffect(() => {
    testSupabaseConnection()
      .then(() => setStatus("Check browser console for result."))
      .catch(() => setStatus("Connection test failed."));
  }, []);

  return (
    <main className="p-10">
      <h1 className="text-2xl font-bold">Supabase Connection Test</h1>
      <p>{status}</p>
    </main>
  );
}