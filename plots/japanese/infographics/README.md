# Japanese NLP: Technical Term Extraction and Visualization

## Overview

This project demonstrates an end-to-end Natural Language Processing (NLP) workflow for extracting and visualizing technical terminology from Japanese-language text.

Using a synthetic corpus of Japanese data science content, the pipeline:

- Tokenizes Japanese text
- Extracts domain-specific technical terms
- Calculates term frequencies
- Ranks the most relevant concepts
- Automatically generates a visual infographic

The project showcases practical NLP techniques for working with non-English text and transforming unstructured language data into structured analytical outputs.

---

## Why This Matters

Many organizations store valuable information in unstructured text sources such as:

- Customer feedback
- Survey responses
- Technical documentation
- Internal knowledge bases
- Meeting transcripts
- Support tickets

Extracting meaningful information from Japanese text presents additional challenges because words are not typically separated by spaces.

This project demonstrates how language-specific NLP techniques can convert raw Japanese text into structured insights that support analysis, reporting, and decision-making.

---

## Skills Demonstrated

### Natural Language Processing

- Japanese tokenization
- Domain-specific term extraction
- Text preprocessing
- Keyword frequency analysis
- Multilingual text processing

### Data Analysis

- Frequency-based ranking
- Exploratory text analysis
- Structured data generation from unstructured text

### Data Visualization

- Automated infographic creation
- Information design
- Communication of analytical results

### Software Engineering

- Reproducible data pipeline
- Modular Python development
- CSV-driven workflow automation

---

## Tools & Technologies

- Python
- pandas
- NLP
- Text Mining
- Japanese Language Processing
- Data Visualization
- CSV Processing

---

## Technical Challenge

Unlike English, Japanese writing generally does not separate words with spaces.

Before any analysis can be performed, text must first be segmented into meaningful tokens using language-specific processing techniques. Accurate tokenization is a critical step because it directly affects the quality of downstream keyword extraction and analysis.

This project demonstrates a complete workflow for converting raw Japanese text into structured term-frequency data suitable for analytical and visualization tasks.

---

## Workflow

```text
Japanese Text Corpus
        ↓
Text Preprocessing
        ↓
Japanese Tokenization
        ↓
Technical Term Extraction
        ↓
Frequency Analysis
        ↓
Ranking & Aggregation
        ↓
Automated Infographic Generation
```

---

## Results

The workflow successfully identified and ranked recurring data science terminology within the corpus and transformed the output into an automatically generated infographic.

Example extracted concepts include machine learning, statistics, data analysis, visualization, and artificial intelligence terminology commonly found in technical documentation.

The final output provides a concise visual summary that can be used for content exploration, glossary generation, or terminology monitoring.

---

## Business Relevance

The same workflow can be adapted to automatically identify recurring themes, technical terminology, customer concerns, or emerging topics within large collections of Japanese-language documents.

Potential applications include:

- Customer feedback analysis
- Technical glossary generation
- Knowledge-base exploration
- Topic monitoring
- Document classification support
- Internal documentation analysis

---

## Project Structure

### Dataset

Synthetic Japanese corpus used for analysis:

- [data_science_sentences.csv](https://github.com/Federico-CM/visualization_portafolio/blob/main/plots/japanese/infographics/data_science_sentences.csv)

### NLP Processing

Japanese tokenization and term extraction:

- [extract_japanese_terms.py](https://github.com/Federico-CM/visualization_portafolio/blob/main/plots/japanese/infographics/extract_japanese_terms.py)

### Extracted Terms

Structured output containing extracted terms and frequencies:

- [data_science_terms.csv](https://github.com/Federico-CM/visualization_portafolio/blob/main/plots/japanese/infographics/data_science_terms.csv)

### Visualization

Automated infographic generation:

- [daruma_infographic.py](https://github.com/Federico-CM/visualization_portafolio/blob/main/plots/japanese/infographics/daruma_infographic.py)

---

## Key Takeaways

This project demonstrates the ability to:

- Process Japanese-language text data
- Apply NLP techniques to non-space-separated languages
- Extract domain-specific terminology
- Transform unstructured text into structured analytical datasets
- Build reproducible data-processing pipelines
- Communicate results through automated visualizations

The same methodology can be extended to:

- Keyword extraction
- Technical glossary generation
- Customer feedback exploration
- Document keyword monitoring
- Internal knowledge-base analysis
- Multilingual text preprocessing 
