# pipeline_diagram.py
from graphviz import Digraph

steps = [
    "Scenario Design",
    "AI-Generated Conversation Corpora\n(Standard + JLPT N3-Constrained)",
    "Tokenization & Grammar Extraction",
    "Frequency Analysis\n(Vocabulary + Grammar)",
    "Coverage & Pattern Analysis",
]

dot = Digraph("Small Pipeline", format="png")
dot.attr(rankdir="TB", bgcolor="white")
dot.attr("node", shape="box", style="rounded,filled", fillcolor="#F4F7FB",
         color="#4A5568", fontname="Helvetica", fontsize="12", margin="0.18")
dot.attr("edge", color="#4A5568", arrowsize="0.8")

for i, step in enumerate(steps):
    dot.node(f"step{i}", step)

for i in range(len(steps) - 1):
    dot.edge(f"step{i}", f"step{i+1}")

dot.render("pipeline_diagram", cleanup=True)
print("Saved as pipeline_diagram.png") 
