# Shareholder Catalyst

Top 20, LandingAI Hackathon (Andrew Ng). Live demo: https://financeaihackathon-anshul-sanjana.streamlit.app/

Shareholder Catalyst turns SEC filings into activist investor intelligence. Feed it a ticker, and in ~45 seconds it extracts financial metrics from the 10-K, scores governance risk from the proxy statement, benchmarks the company against peers, and generates a written investment thesis — the kind of analysis that takes a human analyst days.

## The problem

Activist investor research is slow and fragmented by design. An analyst building a position thesis spends days sourcing a 10-K, pulling the proxy, computing 15+ financial ratios, benchmarking against peers, and then writing up a narrative that ties it together. Each step is manual. Most of the time is spent in data wrangling, not reasoning.

The question Shareholder Catalyst answers: can LandingAI's document intelligence pipeline extract structured financial and governance data from SEC filings accurately enough to power automated analysis — and is the resulting LLM-generated thesis useful to an actual investor?

## What it produces

Given a ticker, Shareholder Catalyst outputs:

- **Financial KPIs**: ROE, ROIC, operating margin, cash-to-assets ratio, revenue growth, leverage — sourced from the 10-K via LandingAI extraction
- **Governance risk score**: board tenure diversity, director independence percentage, CEO compensation alignment vs. peers — sourced from the proxy statement
- **Peer benchmarking**: percentile rank across sector peers for each KPI (e.g. "ROE at 95th percentile, revenue growth at 32nd")
- **Activist thesis**: a 3–5 sentence GPT-4o narrative identifying the highest-value catalyst (excess cash, board refresh, capital reallocation) with supporting data
- **Export**: PDF report, Markdown summary, and raw JSON for downstream use

## How it works

```
Ticker input (e.g. AAPL)
        │
        ├──► SEC EDGAR fetch ──► LandingAI document intelligence
        │        10-K, proxy                    │
        │                         Structured financial + governance data
        │
        ├──► Yahoo Finance ──► current price, market cap, shares
        │
        ▼
  Ratio Calculator
  (ROE, ROIC, operating margin, cash efficiency, leverage)
        │
  Peer Comparator
  (percentile ranking vs. sector peers)
        │
  Governance Scorer
  (board tenure, independence, comp alignment)
        │
        ▼
  GPT-4o — activist thesis generation
  ("catalyst identification: excess cash, board refresh, capital reallocation")
        │
        ▼
  Streamlit dashboard  ──►  PDF / Markdown / JSON export
```

Three modules do the heavy lifting: `tools/ratio_calculator.py` computes the financial KPIs, `agents/governance_agent.py` scores the board, and `agents/thesis_generator.py` generates the final investment narrative using GPT-4o grounded in the extracted data.


## Sample output — Apple Inc. (AAPL)

**Financial KPIs**

| Metric | Value | Peer Percentile |
|---|---|---|
| ROE | 147% | 95th |
| ROIC | 28.1% | 88th |
| Operating Margin | 29.8% | 91st |
| Revenue Growth (1Y) | -2.8% | 32nd |
| Cash-to-Assets | 8.5% | — |

**Governance flags**: Board average tenure 15.3 years (imbalance signal). CEO comp at $63M vs. peer median $42M.

**Generated thesis**: “Apple trades at a significant premium to peers on profitability but lags on growth. The $30B cash position (8.5% of assets) earning minimal return is the primary activist target — a buyback acceleration or special dividend would improve capital efficiency without strategic disruption. Secondary opportunity: board tenure concentration warrants a refreshment push at the next proxy cycle.”

## Quickstart

```bash
git clone https://github.com/anshuldani/finance_ai_hackathon
cd finance_ai_hackathon
pip install -r requirements.txt
```

Create a `.env` file:

```env
LANDINGAI_API_KEY=...
OPENAI_API_KEY=sk-...
```

Run the app:

```bash
streamlit run app.py
```

**Demo mode** (no API keys needed): the app ships with pre-loaded data for AAPL, MSFT, and GOOGL. Set `DEMO_MODE = True` in `app.py` (it's the default) to explore the full dashboard without configuring any keys.

## Stack

| Layer | Technology |
|---|---|
| UI | Python, Streamlit |
| Document intelligence | LandingAI Document Intelligence API |
| LLM (thesis generation) | OpenAI GPT-4o |
| Data sources | SEC EDGAR, Yahoo Finance (`yfinance`) |
| Financial computation | Custom `ratio_calculator.py`, `peer_comparator.py` |
| Governance analysis | `governance_agent.py`, `analyst_agent.py` |
| Reporting | ReportLab (PDF), Markdown, JSON |
| Config | `python-dotenv` |

## Notes

- All processing is session-based — no data is stored between runs.
- Average runtime: ~45 seconds per company in live mode; instant in demo mode.
- If LandingAI extraction fails for a filing format, the app falls back to rule-based parsing.

## Built by

Anshul Dani and Sanjana Waghray — Illinois Tech, MS AI / MS Data Science.
Financial modelling, LandingAI integration, GPT-4o thesis layer, and Streamlit dashboard by Anshul Dani.
