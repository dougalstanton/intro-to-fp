# Functional Programming

A talk introducing some of the advantages of functional programming in
code re-use. The intent was to motivate an interest in "new languages"
and suggest that code re-use was one area where the mainstream
imperative languages made it really hard to abstract and generalise (but
that technology from the FP camp was changing this, and many specific
instances are being dragged back into Python, C\# etc).

## The talk

**talk.markdown** contains the talk that I wrote for the presentation.
This is what you should read if you want to know what I said.

**code-reuse.markdown** contains the source for the slides, which are
pretty minimalist and won't really illuminate on their own. You could
view them alongside the `talk.markdown` file above.

## Making the slides

You'll need a version of Pandoc later than v1.12 (ie with reveal.js
support) to compile the slides into the intended form.

The Makefile contains instructions to convert the slides into a
Reveal.js slideshow, `code-reuse.html`. You need to unzip the framework
into a local directory called `reveal.js` so the right files can be
found.

The `template.revealjs` is a slightly edited Pandoc template for the
slideshow framework, though right now I can't remember what I edited.
