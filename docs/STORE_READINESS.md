# Store Readiness Checklist

## Obbligatorio prima della pubblicazione

- Sostituire privacy policy e termini placeholder con testi legali reali.
- Collegare Supabase Auth reale a login/signup/password reset.
- Configurare Firebase per Android/iOS e abilitare `BB_ENABLE_FIREBASE_MESSAGING`.
- Aggiungere icone app, splash nativo e screenshot store.
- Generare progetti nativi Flutter con `flutter create --platforms=android,ios .` dentro `apps/mobile` se non presenti.
- Testare cancellazione account end-to-end su Supabase.
- Verificare RLS con utenti reali non-admin.
- Aggiungere flusso report contenuti completo con stati moderazione.
- Aggiungere controllo età/consenso se richiesto dal mercato di distribuzione.
- Verificare accessibilità: contrasto, font scaling, screen reader, touch target.

## Copy safety

Evitare frasi come:

- "investi meglio"
- "consiglio finanziario"
- "garantisce risparmio"

Preferire:

- "organizza"
- "simula impatto"
- "promemoria educativo"
- "dato di consapevolezza"

## Dati e privacy

- Nessun open banking.
- Nessun pagamento.
- Nessuna AI remota in MVP.
- Importi visibili solo al proprietario.
- Nei gruppi: percentuali e badge.

## Release tecnica

- `flutter analyze`
- `flutter test`
- Test manuale login/onboarding/spesa/obiettivo/challenge/delete account.
- Supabase migrations su ambiente staging.
- Edge Functions deployate con `verify_jwt = true`.
