# BudgetBuddy Social

BudgetBuddy Social è una codebase MVP free-first per una vera app mobile Flutter, con pannello admin web e backend Supabase. Il prodotto aiuta giovani e studenti a gestire spese manuali, obiettivi di risparmio, challenge individuali o di gruppo e insight educativi non regolamentati.

Nota obbligatoria nel prodotto:

> Le informazioni fornite sono a scopo educativo e organizzativo e non costituiscono consulenza finanziaria.

## Stack

- Flutter + Dart + Material 3
- Riverpod e go_router
- Supabase Free Plan: PostgreSQL, Auth, RLS, Storage, Realtime, Edge Functions
- Firebase Cloud Messaging dietro `NotificationService`, con fallback mock
- AI locale mock dietro `BudgetInsightService`
- Nessun open banking, nessuna API bancaria, nessun pagamento nell'MVP

## Struttura

```text
apps/
  mobile/        App mobile Flutter
  admin/         Admin panel Flutter web
packages/
  budgetbuddy_shared/
supabase/
  migrations/
  functions/
  seed.sql
docs/
  PRODUCT_SPEC.md
  ROADMAP.md
  SUPABASE_SECURITY.md
```

## Avvio locale

1. Installa Flutter stabile, Supabase CLI e Deno.
2. Copia `.env.example` in `.env` e inserisci le chiavi free-tier.
3. Avvia Supabase locale:

```bash
supabase start
supabase db reset
```

4. Avvia l'app mobile:

```bash
cd apps/mobile
flutter pub get
flutter run --dart-define=BB_SUPABASE_URL=http://127.0.0.1:54321 --dart-define=BB_SUPABASE_ANON_KEY=<anon>
```

5. Avvia l'admin panel:

```bash
cd apps/admin
flutter pub get
flutter run -d chrome
```

La UI parte con dati demo locali per permettere sviluppo anche senza Supabase attivo. I servizi sono separati per sostituire i mock con implementazioni reali.

## Account demo locali

- sofia.demo@example.com
- marco.demo@example.com
- giulia.demo@example.com

Password suggerita nei seed locali: `BudgetBuddy123!`.

## Qualità minima

```bash
cd packages/budgetbuddy_shared && dart test
cd apps/mobile && flutter analyze && flutter test
cd apps/admin && flutter analyze && flutter test
```

In questa macchina Flutter/Dart non risultano installati: i comandi sopra sono quelli da eseguire nell'ambiente di sviluppo o in CI.

## Deploy GitHub Pages

Il workflow [deploy-github-pages.yml](.github/workflows/deploy-github-pages.yml) pubblica il pannello admin Flutter web da `apps/admin` su GitHub Pages.

Setup:

1. Su GitHub apri `Settings` -> `Pages`.
2. Seleziona `GitHub Actions` come source.
3. Fai push su `main` oppure lancia manualmente `Deploy Admin to GitHub Pages`.

Dettagli in [docs/DEPLOY_GITHUB_PAGES.md](docs/DEPLOY_GITHUB_PAGES.md).

## Cosa è incluso

- Login mock, onboarding, dashboard, spese, obiettivi, challenge, gruppi, simulatore, insights, profilo, settings, cancellazione account.
- Italiano/inglese, tema chiaro/scuro, consenso notifiche, placeholder privacy/terms.
- Admin panel con utenti, categorie, challenge, contenuti educational, report e statistiche aggregate.
- Migrations Supabase con schema completo, RLS e funzioni helper.
- Edge Functions per statistiche mensili, milestone, badge challenge, riepilogo settimanale mock e cancellazione account.
- Seed demo con 3 utenti, 20 spese, 4 obiettivi, 5 challenge, 1 gruppo e 8 badge.

## Nota prodotto

BudgetBuddy Social non fornisce consulenza finanziaria, non legge conti bancari e non effettua pagamenti. Tutti i dati economici dell'MVP sono inseriti manualmente dall'utente.
