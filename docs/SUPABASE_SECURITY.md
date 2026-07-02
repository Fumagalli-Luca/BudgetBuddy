# Supabase Security Notes

## Principi

- Ogni tabella con dati utente ha RLS attiva.
- Gli utenti leggono e modificano solo i propri dati personali.
- Nei gruppi si condividono solo dati social minimizzati: percentuali, badge, livello, streak.
- Le statistiche aggregate admin passano dalla funzione `get_admin_aggregate_stats`.
- Il ruolo `admin` o `moderator` è gestito in `profiles.role` e protetto da trigger anti escalation.

## Tabelle personali

- `expenses`
- `savings_goals`
- `goal_transactions`
- `insights`
- `notifications`
- `user_settings`

Policy: `user_id = auth.uid()` oppure `public.is_admin()`.

## Tabelle social

- `groups`
- `group_members`
- `challenges`
- `challenge_participants`
- `user_badges`

Policy: membership verificata con funzioni security definer come `is_group_member` e `shares_group_with`. Le leaderboard non espongono importi.

## Moderazione

- `reports`: creazione da utenti autenticati, aggiornamento solo admin/moderator.
- `admin_audit_logs`: lettura e scrittura solo admin/moderator.
- Admin panel: deve usare Supabase Auth e verificare ruolo prima di mostrare contenuti sensibili.

## Account deletion

La Edge Function `delete_user_account`:

1. verifica JWT;
2. richiede `confirmation = "DELETE"`;
3. marca il profilo come cancellato;
4. chiama `auth.admin.deleteUser`, facendo cascata sui dati collegati via FK.

Prima dello store, aggiungere export dati utente e retention policy legale.

## Storage

Bucket `avatars`:

- lettura pubblica;
- upload/update/delete solo nella cartella `auth.uid()/`.

Usare file piccoli e validare MIME type lato client e bucket.
