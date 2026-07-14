# RTL track — evaluation results

Generated RTL and scoring results for the RTL track: our own agentic BDD-driven
workflow against three external baselines (VerilogCoder, CodeV, MAGE), on two
benchmarks (VerilogEval Human v2, ChipBench). All approaches run with
`claude-sonnet-5` as the backing model, and all outputs — ours and the baselines' —
are scored the same way, through our own `xrun`-based functional/syntax pipeline,
not through the baselines' self-reported numbers.

## Layout

```
rtl_eval/
  verilogeval_v2/        156 designs, full VerilogEval Human v2
    agentic_bdd_workflow/    our agentic approach, BDD/Gherkin spec on
    verilogcoder_rescore/    VerilogCoder (GPT-4 Turbo), shipped artifacts re-scored via our xrun pipeline
    codev_rerun/             CodeV (Qwen2.5-Coder-7B), run via vLLM, re-scored via our xrun pipeline
    mage_rerun/              MAGE, re-run against Sonnet-5, re-scored via our xrun pipeline
  chipbench/              45 designs, full ChipBench (hierarchical/multi-module)
    agentic_bdd_workflow/    our agentic approach, BDD/Gherkin spec on
    codev_rerun/             CodeV, extended driver for ChipBench, re-scored via our xrun pipeline
    mage_rerun/              MAGE, re-run against Sonnet-5, re-scored via our xrun pipeline
```

Each `<design>/` folder contains:
- `result.json` — that approach's metrics for this design (functional/syntax pass,
  token/cost counters, etc.).
- `dut.v` — the generated RTL (a single merged file per design, even for
  multi-module ChipBench designs).
- `spec.feature` — the Gherkin/BDD spec that seeded generation (agentic_bdd_workflow
  only; the baselines don't consume a BDD spec).

## Headline results

### VerilogEval Human v2 — 156 designs, full

| | Syntax | Functional |
|---|---|---|
| **Agentic BDD Workflow** | 98.7% (154/156) | **89.1% (139/156)** |
| VerilogCoder (GPT-4 Turbo) | 96.6% (142/147) | 90.4% (141/156) |
| CodeV | 85.3% (133/156) | 35.9% (56/156) |
| MAGE (Sonnet-5, re-run) | 99.2% (127/128) | 76.3% (119/156) |

VerilogCoder ships 147/156 artifacts (9 problems have no DUT, counted as functional
failures over the full 156). CodeV was prompted VerilogEval-style and run via vLLM on
a separate GPU host. VerilogCoder and CodeV are both ingested/re-scored via our own
`xrun` pipeline, not reproductions of their papers' own evaluation protocol — the
denominator conventions, functional-pass definitions, and VerilogEval split in
circulation likely differ from their published numbers, so treat any comparison to
their paper numbers as directional, not exact. VerilogCoder's own documented model is
GPT-4 Turbo; CodeV's is a fixed open-weight 7B model — neither runs on Sonnet-5, so
a same-model comparison against our agentic workflow isn't possible for these two.

MAGE (`baselines/mage_driver/`, vendored submodule `baselines/mage`) is a real
multi-agent generation loop (20-candidate sampling, syntax/sim debug retries, a judge
over survivors) re-run ourselves against Sonnet-5, not shipped artifacts or a bare
model call. 28/156 (18%) failed to produce any RTL at all — MAGE's own output parser
does a bare `json.loads()` with zero recovery, and Sonnet-5 occasionally writes
reasoning prose before the JSON block despite an explicit "JSON only" instruction
(confirmed via their source, not a benchmark-content issue). Among the designs that
did complete: 99.2% syntax, 93.0% functional-given-syntax-clean.

### ChipBench — 45 designs, full, hierarchical/multi-module

| | Syntax | Functional |
|---|---|---|
| **Agentic BDD Workflow** | 95.6% (43/45) | **31.1% (14/45)** |
| CodeV | 82.2% (37/45) | 13.3% (6/45) |
| MAGE (Sonnet-5, re-run) | 95.8% (23/24) | 31.1% (14/45) |

CodeV baseline uses the same driver as VerilogEval, extended with `--dataset-dir` for
ChipBench (backward-compatible, zero extra API cost — local vLLM inference).
Per-category: cpu_ip 22.2% (2/9), not_self_contain 16.7% (1/6), self_contain 10.0%
(3/30) — CodeV has no decomposition strategy for multi-module designs, so it isn't
specifically worse on the hierarchical categories, just weak overall relative to its
35.9% on VerilogEval. VerilogCoder has no ChipBench baseline: its shipped artifacts
are VerilogEval-keyed only, and re-running its live pipeline would require real GPT-4
Turbo spend plus carries the same prompt-model-coupling caveat as above.

MAGE on ChipBench: 21/45 (47%) failed to produce any RTL at all, same root cause as
VerilogEval (bare `json.loads()` parser, no recovery from stray reasoning prose).
Notably below MAGE's own paper headline (94.8% Human / 95.7% v2 on VerilogEval,
Claude 3.5 Sonnet backbone) — the gap there is mostly the hard-failure rate, not a
reasoning/capability shortfall on the designs that did complete. Per-category:
cpu_ip 44.4% (4/9, best), not_self_contain 33.3% (2/6), self_contain 26.7% (8/30).

**cross-paper reference points** (not run by us, cited from their own papers, for
context only — not a controlled comparison): ChipBench's own "single-shot" baseline
(30.7%) is Claude Opus 4.5 doing single-shot prompting — the closest same-shape
comparison to our own one-pass no-BDD result (35.6%, not included in this directory,
see the SVA/RTL sweep log). MAGE's own paper citation on ChipBench (37.4% avg,
DeepSeek-V3.2 backbone) scores ~95% on VerilogEval but crashes to 37% here — evidence
that ChipBench's difficulty is real and not backbone-specific.

## Known gaps (not errors)

- **VerilogCoder**: 147/156 designs have `dut.v` — 9 problems ship with no DUT in
  VerilogCoder's own released artifacts, counted as functional failures.
- **MAGE (VerilogEval)**: 128/156 designs have `dut.v` — the other 28 failed to
  produce any parseable RTL (MAGE's own `json.loads()`-based parser, no recovery).
- **MAGE (ChipBench)**: 24/45 designs have `dut.v` — 21 failed the same way, at a
  higher rate on ChipBench's harder multi-module designs.
