# Deploy GitHub Pages

Questo workflow pubblica il pannello admin Flutter web da `apps/admin` su GitHub Pages.

## Setup una tantum

1. Apri il repository su GitHub.
2. Vai in `Settings` -> `Pages`.
3. In `Build and deployment`, scegli `GitHub Actions`.
4. Fai push su `main` oppure avvia manualmente il workflow `Deploy Admin to GitHub Pages`.

## URL

Per un repository normale, l'URL sara:

```text
https://OWNER.github.io/REPOSITORY/
```

Per un repository `OWNER.github.io`, l'URL sara:

```text
https://OWNER.github.io/
```

Il workflow calcola automaticamente il `base-href`, quindi Flutter carica correttamente asset e routing anche sotto `/REPOSITORY/`.

## Cosa viene deployato

- App: `apps/admin`
- Output: `apps/admin/build/web`
- Artifact Pages: generato dal workflow

## Cambiare app deployata

Per pubblicare un'altra app Flutter web, modifica `FLUTTER_APP_DIR` in `.github/workflows/deploy-github-pages.yml`.

Esempio:

```yaml
env:
  FLUTTER_APP_DIR: apps/mobile
```

Prima di farlo, assicurati che l'app scelta abbia la cartella `web/`.
