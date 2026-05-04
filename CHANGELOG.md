# Changelog

All notable changes to Shareholder Catalyst (this repo, AKA Arcis in some
internal docs) are tracked here. Format loosely follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); no tagged
releases yet.

## Unreleased

### Added
- `Makefile` with `setup`, `run`, `test`, `test-setup`, `lint` targets
- Real README hook calling out the LandingAI Hackathon top-20 finish, with
  accurate architecture diagram, capabilities list, and stack table

### Changed
- Peer comparator computes EV/Revenue upside from peer percentile rather
  than hardcoding a flat 15% headroom assumption
- `analyst_agent`, `governance_agent`, `thesis_generator`,
  `ratio_calculator`: dropped unused `json` / `Optional` imports
- `orchestrator.py`: tool and agent imports hoisted to module level
- `ade_extractor.py`: `re` imports hoisted to module level
- `test_setup.py`: dependency check loop simplified to a list iteration

### Fixed
- LandingAI API key no longer hardcoded in `test_key_decoding` and the
  other test scripts — pulled from `LANDINGAI_API_KEY` env var (rotate
  the previously-leaked key out-of-band before publishing)
- `market_data.py` no longer issues a runtime `pip install` on import —
  installs are an infra concern, not a runtime side-effect
- SEC ATOM feed parser: corrected `accession-number` typo that prevented
  the latest 10-K from being matched on some tickers
- `_try_alternate_url`: bare `except` replaced with `except Exception` so
  KeyboardInterrupt / SystemExit propagate
- `save_results`: missing AI outputs now serialize as `None` sentinels
  rather than empty strings (downstream code distinguished the two)
