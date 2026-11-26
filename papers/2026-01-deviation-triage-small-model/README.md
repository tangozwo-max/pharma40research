# 2026-01 · Task-specific fine-tuning of a small AI model for GMP deviation triage

*Effects of LoRA fine-tuning and switchable building blocks on classification accuracy and data integrity*
(Experiment 2 of the pharma|40 virtual factory)

**Status:** working paper, not peer reviewed · **Author:** Alessandro Cancemi · **Licence:** CC BY 4.0

## Abstract

Shift staff describe deviations in short free-text notes; turning a note into a structured triage record
(class, equipment, batch, time, evidence) is a narrow, repetitive task a language model could prepare for a human
reviewer. Two errors matter: a wrong class and an invented value, which in GMP terms is a data-integrity failure.
On a synthetic, generator-labelled data set of 4,286 notes from 150 cause families, five switchable building blocks
around one small open-weight model (Qwen3-8B) and LoRA fine-tuning were tested. Code-side grounding removed invented
values (21.1 % to 0.0 %) without loss of classification; a LoRA adapter trained for 20 minutes raised macro-F1 on
unseen cause families from 94.3 % to 98.2 %, not worse than a large hosted reference model on
unseen families (+1.4 points, not significant) and better on seen families (+3.9). Classification and grounding
are separate problems with separate remedies: training decides the class, code decides whether the values are true.
Results are on synthetic data and await confirmation on real plant notes.

## Contents

| Path | What |
|---|---|
| `paper/` | the article: `Cancemi_2026_Task-specific-fine-tuning-of-a-small-AI-model-for-GMP-deviation-triage.pdf` (11 pages) and its HTML source (`experiment-2.html`) with `paper.css` and the figures |
| `data/` | data set v2 as used in the article (frozen 23.11.2026), see below |
| `CITATION.cff` | citation |

Not published: the data generator, prompts, runner, scorer, run outputs and the trained adapters. They are
available on request.

## Data set v2

Synthetic shift notes about deviations in a fictional oral-solid-dose plant. Equipment, batches and times are
invented. The notes were written by language models from simulated causes; the label is the simulated cause
(generator truth), checked by an independent model, disagreements settled by rules of the author. Label quality is
discussed in the article.

| File | Records | Cause families | Use |
|---|---:|---:|---|
| `train.jsonl` | 2,756 | 90 | training |
| `dev.jsonl` | 270 | 15 | development |
| `eval_unseen.jsonl` | 900 | 45 | test, families not in training |
| `eval_seen.jsonl` | 360 | from training | test, families seen in training, notes written by other models |

`MANIFEST.json` holds record counts, class and writer counts and the SHA-256 checksum of every file.
Train and dev notes come from open-weight models over APIs; the test notes were written by commercial chat models
that took no part in the training data.

One JSON object per line:

| Field | Meaning |
|---|---|
| `id`, `split` | record id and split |
| `family`, `subtype` | cause family (e.g. `EF06`) and optional subtype |
| `style` | writing style: `formal`, `handover`, `sloppy`, `ebr`, `de` (German) |
| `text` | the note |
| `gold.class` | `equipment_failure`, `process_parameter_excursion`, `material_issue`, `documentation_error` or `uncertain_review` |
| `gold.equipment_id`, `gold.batch_id`, `gold.timestamp` | values stated in the note, or `null` |
| `gold.evidence` | quotes from the note that support the class |
| `gold.abstain` | `true` when the note does not allow a class (route to human review) |
| `meta.time_mode`, `meta.red_herring` | how the time is written; a misleading detail planted in the note |
| `prov` | provenance: writer model, checker model and its class, attempts, rulings |

Check the files: `sha256sum data/*.jsonl` and compare with `MANIFEST.json`.

## Versions

- Data set v2, frozen 23.11.2026 – published 24.11.2026.
- Article v1.4 – published 24.11.2026 (earlier versions 1.0–1.3 were internal drafts).
- Article v1.5 – 24.11.2026, after a critical review: pre-study moved into section 2.4, figures renumbered, wording of the comparison with the hosted reference model sharpened.
- Article v1.6 – 24.11.2026: layout and proofreading; headline numbers unchanged.
- Article v1.7 – 26.11.2026: classifier arm added (DeBERTa-v3-base trained on the same notes; threshold pre-registered on dev before one prediction of the test sets): new sections 3.6 and 4.8, Table 8, abstract and conclusion extended; earlier tables 8–9 are now 9–10. Earlier results unchanged.
- Article v1.8 – 26.11.2026: new layout (header with the pharma|40 logo and pharma40.de, author, history and keywords in a left column beside the abstract, footer with page numbers, in-text citations linked to the reference list); content as v1.7.
