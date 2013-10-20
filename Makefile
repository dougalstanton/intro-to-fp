
slideshow:
	pandoc -V theme=moon --to revealjs code-reuse.markdown --standalone --self-contained -o code-reuse.html --slide-level=2 --highlight-style=zenburn --template=template.revealjs
