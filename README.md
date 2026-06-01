# Rubric-Based Evaluation Of PL/SQL Code

This project implements a two-stage, agentic evaluation pipeline for PL/SQL assignments using the local `qwen2.5-coder:14b` Ollama model.

The pipeline follows the report closely:

1. Natural-language problem statement -> schema extraction -> schema validation
2. Validated schema -> mutation-aware RAG retrieval -> test-case synthesis -> rubric scoring

It also adds a few practical upgrades:

- Hybrid mutation retrieval with validation, keyword-aware ranking, and diversity-aware selection
- Static PL/SQL analysis to support procedural checks even when Oracle execution is unavailable
- Disk caching for Ollama responses to reduce repeated model calls
- Unit-tested core modules instead of notebook-only logic
- Notebook frontends with markdown explanations for each pipeline stage

## Project Structure

`plsql_pipeline/`
Core Python package for extraction, validation, retrieval, test generation, execution, and scoring.

`examples/`
Sample bank-domain problem statement and a sample PL/SQL submission.

`data/novel_mutations.jsonl`
Extra mutation records added on top of the existing RAG corpus.

`schema-generator.ipynb`
Stage 1 notebook for schema extraction and validation.

`test-case-generator.ipynb`
Stage 2 notebook for mutation retrieval and test synthesis.

`complete-pipeline.ipynb`
End-to-end notebook for the full evaluation flow.

`run_pipeline.py`
CLI entrypoint for running the full pipeline from files.

## Requirements

- Local Ollama server running on `http://127.0.0.1:11434`
- Model available locally: `qwen2.5-coder:14b`
- Python runtime available in the workspace

The implementation intentionally avoids depending on packages like `ollama`, `requests`, `sklearn`, or `pytest`, because they were not available in the current environment.

## Quick Start

Run the full pipeline on the included example:

```powershell
C:\Users\adith\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe run_pipeline.py --problem-file examples/bank_problem.txt --submission-file examples/sample_student_submission.sql --output-dir artifacts/demo_run
```

Run the unit tests:

```powershell
$env:PYTHONDONTWRITEBYTECODE='1'
C:\Users\adith\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe -m unittest discover -s tests -v
```

## Oracle Execution

The project includes an `OracleExecutionEngine`, but the current workspace did not have `sqlplus` installed. Because of that, the default pipeline uses dry-run execution and still produces:

- extracted schema JSON
- Oracle-style DDL
- retrieved mutation set
- generated test cases
- static procedural analysis
- rubric-style score and markdown report

If Oracle tooling is available later, set `ORACLE_CONNECTION_STRING` and switch to `OracleExecutionEngine`.

## Novelty Highlights

- Schema-aware mutation retrieval rather than plain corpus lookup
- Coverage-aware mutation selection so prompts with multiple procedural intents retrieve a balanced fault set
- Static procedural rubric support for loops, branches, exceptions, and transaction control
- Validation gates that check structure, semantics, and DDL feasibility before downstream generation
