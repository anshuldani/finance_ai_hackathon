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

## Implementation Highlights

1. Document Intelligence

   •	Integrated LandingAI Document Intelligence API to process SEC filings in multiple formats (HTML, PDF, text).

   •	Extracted key metrics including revenue, assets, cash flow, and governance details from proxy statements.
    
2. Financial Analytics

   •	Developed a modular Ratio Calculator to compute KPIs such as ROE, ROIC, and cash efficiency.

   •	Implemented peer benchmarking for relative performance analysis across industries.
    
3. Governance Modelling

   •	Parsed board data to assess tenure diversity, independence, and compensation alignment.

   •	Combined these into a composite governance risk score that feeds into the activist index.
    
4. AI-Generated Thesis

   •	Used large language models to summarize findings into a concise, human-readable investment thesis.

   •	Automatically identifies catalysts such as excess cash, underutilised capital, or leadership concentration.
    
5. Dashboard & Reporting

   •	Built with Streamlit, featuring interactive tabs for Executive Summary, Financials, Governance, and Thesis.

   •	Outputs reports in multiple formats — ideal for investor presentations or internal research reviews.

## Sample Insight

Example: Apple Inc. (AAPL)


Key Catalysts:

•	Excess cash reserves earning minimal return (potential capital reallocation signal).

•   Board tenure imbalance suggesting need for refreshment.

Financial Highlights:

•	ROE: 147% | ROIC: 28% | Operating Margin: 29.8%

•	Market Cap: $2.8T | Revenue Growth: -2.8% YoY

AI Thesis Summary:

“Apple shows exceptional profitability but limited reinvestment efficiency. Activist opportunities may lie in cash redeployment and governance refresh.”

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

## Security & Reliability

•	Uses .env configuration for secure API key management.

•	No permanent data storage — all processing is session-based.

•	Graceful fallbacks for missing API responses.

•	Average runtime: ~45 seconds per company profile.

## Why It Matters

Shareholder Catalyst represents the next step in data-driven governance and financial intelligence.

It showcases how AI can bridge the gap between quantitative rigour and strategic interpretation, transforming how investors uncover value.

By blending document intelligence, financial modelling, and AI reasoning, this project highlights a future where human insight and machine precision work together — not to replace analysts, but to amplify their reach and speed.

“Our goal was to make corporate activism smarter, faster, and more transparent — powered by AI that understands the language of finance.”

## 👥 Contributors

Sanjana Waghray — Data Scientist & AI Engineer

- M.S. Data Science @ Illinois Tech Chicago

- 🔗 sanjanawaghray.com￼

Anshul Dani — Full-Stack & AI Engineer

- M.S. Artificial Intelligence @ Illinois Tech Chicago

- 🔗 anshuldani.com￼
