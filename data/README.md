# data/

Local working folder for ERP datasets. **Nothing in this folder except this README is committed to Git** (see `.gitignore`).

## Suggested layout

```
data/
├── raw/         # Original exports from the ERP (never edited by hand)
├── interim/     # Temporary intermediate files
└── processed/   # Cleaned outputs ready for loading or analysis
```

Create these subfolders on your own machine; Git will not track them.

## Rules

- Never commit real customer data. Before every commit, run `git status` and make sure no data files are listed.
- Check whether a specific file is ignored: `git check-ignore -v data/raw/<file>`
- Public portfolio examples must use anonymized or synthetic data.
- Share real datasets only through private channels, never through this repository.
