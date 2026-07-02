# BudgetBuddy Social - Product Spec MVP

## Posizionamento

BudgetBuddy Social è un'app motivazionale/social per organizzare spese manuali, obiettivi di risparmio e challenge. Non è una banca, non legge conti correnti e non offre consulenza finanziaria.

Disclaimer obbligatorio:

> Le informazioni fornite sono a scopo educativo e organizzativo e non costituiscono consulenza finanziaria.

## Target

Studenti, giovani lavoratori e persone 16-30 che vogliono risparmiare per obiettivi concreti: viaggi, concerti, affitto, auto, studio, tecnologia, fondo emergenza.

## Funzionalità MVP

- Auth: login/signup Supabase in produzione, login mock in sviluppo locale.
- Onboarding: obiettivo principale, stile risparmio, budget mensile manuale, categorie preferite.
- Dashboard: saldo manuale, spese mese, obiettivo principale, progress, streak, suggerimento del giorno, CTA spesa.
- Spese: creazione spesa, categoria, data, descrizione, pagamento, tag, ricorrenza, lista filtrabile, grafico custom.
- Obiettivi: target, deadline, calcolo risparmio settimanale, milestone, progress bar, movimenti virtuali.
- Challenge: challenge individuali e gruppo, badge, classifica percentuale.
- Gruppi amici: invito codice/link, privacy percentuale-only, commenti, report contenuto.
- Insights AI mock: `BudgetInsightService` locale, tono non giudicante.
- Simulatore: impatto di un acquisto sugli obiettivi, suggerimenti organizzativi.
- Profilo: avatar, livello, badge, streak, obiettivi completati, privacy, cancellazione account.
- Settings: notifiche, lingua, tema, privacy, terms/privacy placeholder.
- Admin: utenti, categorie, challenge, contenuti educational, report, statistiche aggregate anonimizzate.

## Non-obiettivi MVP

- Open banking e API bancarie.
- Pagamenti, abbonamenti o marketplace.
- Consulenza finanziaria personalizzata o regolamentata.
- AI remota o invio dati economici a provider terzi.

## Metriche prodotto

- Activation: onboarding completato + prima spesa inserita.
- Habit: streak settimanale con almeno 3 spese o movimenti virtuali.
- Social: gruppo creato o challenge gruppo iniziata.
- Safety: report risolti entro SLA interno.
- Privacy: percentuale utenti con privacy percentuale-only attiva.
