
INPUT=slides.markdown
OUTPUT=code-reuse.html

slideshow:
	pandoc -V theme=moon --to revealjs --smart --standalone --slide-level=2 --highlight-style=zenburn --template=template.revealjs -o ${OUTPUT} ${INPUT}
