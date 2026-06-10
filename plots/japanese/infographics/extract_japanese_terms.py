from pathlib import Path
import pandas as pd
from janome.tokenizer import Tokenizer
from collections import Counter

# -----------------------------
# Paths
# -----------------------------
BASE_DIR = Path(__file__).resolve().parent

CSV_FILE = BASE_DIR / "data_science_sentences.csv"
OUTPUT_CSV = BASE_DIR / "data_science_terms.csv"

# -----------------------------
# Settings
# -----------------------------
KEEP_POS = {"名詞", "動詞", "形容詞"}

STOPWORDS = {
    "する", "いる", "ある", "こと", "これ", "それ", "ため", "よう",
    "行う", "行い", "現在", "今週", "来週", "毎日", "毎年", "先月",
    "られる", "これら", "この", "まま", "その", "前年", "去年",
    "あの", "ごと", "できる", "おる", "れる", "なる", "さら", "せる",
    "その後", "ひる", "たち", "やすい", "三つ", "くださる", "青い",
    "時間", "週末", "先生", "一時"
}

# -----------------------------
# Load data
# -----------------------------
df = pd.read_csv(CSV_FILE)

if "text" not in df.columns:
    raise ValueError("CSV must contain a 'text' column.")

combined_text = "\n".join(df["text"].dropna().astype(str))

# rest of your code...
