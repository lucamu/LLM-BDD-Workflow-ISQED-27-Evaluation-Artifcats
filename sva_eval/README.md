# SVA track — evaluation results

Generated SystemVerilog Assertions and scoring results for the SVA track: our own
agentic BDD-driven workflow against two external baselines (AssertionForge,
AssertLLM2-plain), on two benchmarks (AssertLLM v1, AssertLLM2). All approaches run
with `claude-sonnet-5` as the backing model, and all outputs — ours and the
baselines' — are scored the same way, through our own JasperGold-based `prove_sva`
pipeline, not through the baselines' self-reported numbers.

## Layout

```
sva_eval/
  assertllm/               15 usable designs, full AssertLLM v1
    agentic_bdd_workflow/      our agentic approach, BDD/Gherkin spec on
    assertionforge_rerun_sonnet5/  AssertionForge, re-run against Sonnet-5, re-scored via our prove_sva pipeline
  assertllm2/               23 designs, stratified across all 13 categories, AssertLLM2
    agentic_bdd_workflow/      our agentic approach, BDD/Gherkin spec on
    assertllm2_plain_rerun_sonnet5/  AssertLLM2-plain, re-run against Sonnet-5, re-scored via our prove_sva pipeline
```

Each `<design>/` folder contains:
- `result.json` — that approach's metrics for this design (proof rate, COI/property
  coverage, property counts, token/cost counters, etc.).
- `dut.v` — the golden reference top-level RTL the SVA was written against (this
  track doesn't generate RTL; a golden DUT is always given).
- `sva.sv` — the generated SystemVerilog assertions.
- `module/` — the complete golden RTL hierarchy this design elaborates against
  (every file JasperGold actually compiles, not just the top-level `dut.v` —
  most of these designs are real multi-file IP cores), sourced from the
  benchmark's own manifest/config (`evaluation/manifests/assertllm.json` for
  AssertLLM v1, `configs/assertllm2_design_configs.json` for AssertLLM2), plus
  the JasperGold `.prove.tcl` script, `.f` filelist, and resulting
  `.coverage.rpt` for that design.
- `spec.feature` — the Gherkin/BDD spec that seeded generation (agentic_bdd_workflow
  only; the baselines don't consume a BDD spec).

`sha3` / `sha3_2` (AssertLLM v1) are two distinct designs that happen to share the
same top-level module name (`keccak`) — different golden RTL, different generated
SVA. Both are disambiguated correctly here (verified by diffing the two `dut.v` /
`sva.sv` pairs); nothing to worry about if you see the same module name inside both.

## Headline results

### AssertLLM v1 — 15 usable designs, full

| | Proof rate | COI coverage | Property coverage |
|---|---|---|---|
| **Agentic BDD Workflow** | **43.2%** | 97% | 44% |
| AssertionForge (Sonnet-5, re-run) | 19.0% | 63% | 37% |

Excludes `hpdmc` (Spartan6 primitives don't elaborate in JasperGold) and `ecg` (too
heavy to prove) from the benchmark's 17-design manifest. `sha3` and `sha3_2` both
collided on `top_module="keccak"` in an earlier pass (whichever design ran second
silently overwrote the other's saved result) — `sha3` was recovered via a dedicated
re-run; both designs' numbers here are the corrected ones.

AssertionForge's own paper (arXiv 2503.19174v2, GPT-4o) reports 4 of these 15 designs
under different names — `ethmac`=our `ethernet`, plus `openMSP430`, `sockit`, `uart`.
Their headline metric is `#Proven / #SVA` (raw generated count as denominator); ours
lint-prunes before scoring, closer to their `#Proven/#SynC` but not confirmed
identical, and their "Functional COI" is a JasperGold simulation-style structural
coverage metric, not confirmed to be the same instrument as our `coi_coverage`. Their
own GPT-4o Functional COI on the 4 overlapping designs (99.1% ethmac, 90.1%
openMSP430, 99.8% sockit, 88.8% uart) is consistently higher than our Sonnet-5
re-run's COI on the same 4 designs (76.5%, 48.2%, 29.9%, 74.7% respectively) — if the
two COI metrics are roughly comparable, GPT-4o's AssertionForge structurally touches
more of the design than Sonnet-5's does. Not a controlled comparison (different
model, different scoring instrument); the trustworthy comparison is our own agentic
workflow vs. our own AssertionForge re-run above, both Sonnet-5, both through our
`prove_sva` pipeline.

### AssertLLM2 — 23 designs, stratified across all 13 categories

| | Coverage | Proof rate | COI coverage | Property coverage |
|---|---|---|---|---|
| **Agentic BDD Workflow** | 23/23 | **43.1%** | 93% | **39%** |
| AssertLLM2-plain (Sonnet-5, re-run) | 23/23 | 67.8% | 100% | 15% |

AssertLLM2-plain's much higher proof rate comes paired with a much lower property
coverage (15% vs. our 39%) — a simpler prompting strategy tends to generate fewer,
safer, more conservatively-scoped assertions that are individually easier to prove,
at the cost of covering less of the design's actual behavior. Proof rate alone
understates that trade-off.

Per-category proof rate (agentic vs. AssertLLM2-plain): `memory_core` 36.2% / 78.6%,
`crypto_core` 28.9% / 50.0%, `communication_controller` 48.1% / 83.8%, `processor`
67.5% / 82.6%, `arithmetic_core` 84.8% / 92.9%, `dsp_core` 77.8% / 16.7%,
`system_controller` 12.7% / 40.0%, `other` 4.7% / 98.1%, `library` 0.0% / 0.0%,
`ecc_core` 52.8% / 81.2%, `video_controller` 51.4% / 71.3%, `system_on_chip` 0.0% /
37.5%, `coprocessor` 46.4% / 97.6%.
