# pharma40research

Applied AI and technology research for regulated industries, tested on the
[pharma|40 virtual factory](https://pharma40.de): a running virtual pharmaceutical
plant with emulated systems, simulated machines and AI agents.

This repository holds the **working papers** and the data that can be published with them.
The papers are listed at [pharma40.de/papers](https://pharma40.de/papers); how they came
about is told in the [devlog](https://pharma40.de/devlog).

> Working papers, not peer reviewed. All data are synthetic and refer to a fictional plant.

## Papers

| No. | Paper | Folder |
|---|---|---|
| 2026-01 | Task-specific fine-tuning of a small AI model for GMP deviation triage (Experiment 2) | [`papers/2026-01-deviation-triage-small-model`](papers/2026-01-deviation-triage-small-model) |

Each paper has its own folder `papers/YYYY-NN-slug/` with

- `paper/` – the article as PDF and its source (HTML or Markdown),
- `data/` – the published data, with a manifest and checksums,
- `CITATION.cff` – how to cite it,
- `README.md` – abstract, version history and what is (and is not) published.

## Licence

- Papers, text, figures and data: [Creative Commons Attribution 4.0 International](LICENSE-CC-BY-4.0.txt) (CC BY 4.0).
- Code (scripts in this repository): [MIT](LICENSE-MIT).

Please cite the paper you use; each folder has a `CITATION.cff`.

## Sensitive-data check

The repository is public from the first commit. Every push and pull request runs
[`scripts/check-sensitive.sh`](scripts/check-sensitive.sh) (GitHub Action `sensitive-check`),
which fails on IP addresses, `*.ts.net` names, Supabase project IDs or keys, `.env` paths,
server paths, private keys and API tokens – in text files and in the text of PDFs.
Run it locally before committing: `bash scripts/check-sensitive.sh`.

## Contact

Alessandro Cancemi · [pharma40.de](https://pharma40.de) · discussion on [LinkedIn](https://www.linkedin.com/in/alessandro-cancemi-b56331187/)
