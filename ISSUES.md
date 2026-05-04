# Follow-up tickets

Open these manually when ready — each is real backlog, not made-up scope.

## 1. Hardcoded API keys were committed to git history

The recent cleanup commits replaced inline `LANDINGAI_API_KEY` literals
with env-var lookups (`5d2803e`, `c38976e`), but the previous values are
still reachable via `git log -p`. Rotate the LandingAI key out-of-band
before announcing the repo, or rewrite history with `git filter-repo`
if rotation isn't possible. The OpenAI key was already env-only — only
LandingAI needs rotation.

## 2. `_fallback_analysis` returns a placeholder when the LLM fails

If the OpenAI call in `agents/analyst_agent.py::analyze` raises, the agent
returns a "Fallback Mode" stub that says "Manual review recommended". That's
fine for a hackathon demo; for the public repo, either:
- propagate the exception so the orchestrator can show a real error to the
  user, or
- compute a deterministic ratio-only analysis from the extracted numbers
  (ROE / ROA / margin / growth) so the fallback is actually useful.

The current behavior pretends the run succeeded with degraded output.

## 3. Industry benchmark is hardcoded to "tech industry, 30-40% operating margins"

`analyst_agent._build_analysis_prompt` instructs the LLM to compare against
"tech industry" benchmarks regardless of the company's actual sector. For a
consumer-staples or financials ticker that's wrong by 20+ percentage points.
The peer benchmarking module already knows the sector — pipe it into the
analyst prompt.

## 4. Streamlit demo URL is in the README but no liveness check

The README links to `financeaihackathon-anshul-sanjana.streamlit.app`. If
the Streamlit free tier puts it to sleep, first-load latency is 30+s, and a
visitor's first impression is "this is broken". Either:
- add a "wake-up" pinger (a 5-min cron hitting the URL), or
- add a "click to wake demo" notice in the README.

## 5. `data/cache/` is unbounded

The orchestrator caches LandingAI extractions to `data/cache/`. There's no
TTL or size cap. After 50 ticker runs the cache will be a few GB. Add
either a max-entries LRU or a TTL-based eviction. Fine to defer until
someone actually fills it up.
