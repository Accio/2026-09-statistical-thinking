# Statistical thinking workshop --- build
#
#   make notebook   the participants' notebook (also writes figures + CSV exports)
#   make appendix   the instructor's technical document
#   make slides     an editable PowerPoint deck
#   make handout    the one-page A4 summary
#   make all        everything
#
# The deck and the handout are built from plain Markdown sources in slides/
# and handout/ --- edit those, not the generated files. The deck reuses the
# figures the notebook writes to output/figures/, so `make slides` will build
# the notebook first if the figures are missing or stale.

R           := Rscript
PANDOC      := pandoc
WEASYPRINT  := weasyprint

NOTEBOOK    := 2026-09-workshop-modules
APPENDIX    := 2026-09-statistical-thinking
GENERATOR   := R/simulate_workshop_data.R

OUTDIR      := output
FIGDIR      := $(OUTDIR)/figures
FIGSTAMP    := $(FIGDIR)/m1-threshold-1.png

SLIDES_SRC  := slides/workshop-slides.md
SLIDES_REF  := slides/reference.pptx
SLIDES_OUT  := $(OUTDIR)/2026-09-workshop-slides.pptx

HANDOUT_SRC := handout/one-pager.md
HANDOUT_CSS := handout/one-pager.css
HANDOUT_HTML:= $(OUTDIR)/2026-09-workshop-one-pager.html
HANDOUT_OUT := $(OUTDIR)/2026-09-workshop-one-pager.pdf

.DEFAULT_GOAL := help
.PHONY: all help notebook appendix slides handout reference-doc check-onepage clean distclean

## ---------------------------------------------------------------- targets

all: notebook appendix slides handout

notebook: $(NOTEBOOK).html
appendix: $(APPENDIX).html
slides:   $(SLIDES_OUT)
handout:  $(HANDOUT_OUT)

## ------------------------------------------------------------- R documents

# Rendering the notebook also writes output/figures/*.png and
# output/workshop/*.csv, which the deck and the handout depend on.
$(NOTEBOOK).html: $(NOTEBOOK).Rmd $(GENERATOR)
	$(R) -e 'rmarkdown::render("$<", quiet = TRUE)'

$(APPENDIX).html: $(APPENDIX).Rmd
	$(R) -e 'rmarkdown::render("$<", quiet = TRUE)'

$(FIGSTAMP): $(NOTEBOOK).html
	@test -f $@ || { echo "figures missing after render"; exit 1; }

## ------------------------------------------------------------------ slides

# Editable in PowerPoint, LibreOffice Impress and Google Slides.
# Run `make reference-doc` once to get slides/reference.pptx, restyle it to
# your template, and it is picked up automatically from then on.
$(SLIDES_OUT): $(SLIDES_SRC) $(FIGSTAMP) | $(OUTDIR)
	$(PANDOC) $< --slide-level=2 --resource-path=.:$(FIGDIR) \
	  $(if $(wildcard $(SLIDES_REF)),--reference-doc=$(SLIDES_REF),) \
	  -o $@
	@echo "wrote $@"

reference-doc:
	@mkdir -p slides
	$(PANDOC) --print-default-data-file reference.pptx > $(SLIDES_REF)
	@echo "wrote $(SLIDES_REF) --- restyle it and rebuild with 'make slides'"

## ----------------------------------------------------------------- handout

# One A4 page, from Markdown, via pandoc and WeasyPrint.
$(HANDOUT_OUT): $(HANDOUT_SRC) $(HANDOUT_CSS) | $(OUTDIR)
	$(PANDOC) $< --standalone --embed-resources --css=$(HANDOUT_CSS) \
	  --metadata title="Statistical thinking --- one page" -o $(HANDOUT_HTML)
	$(WEASYPRINT) $(HANDOUT_HTML) $@
	@echo "wrote $@"
	@$(MAKE) --no-print-directory check-onepage

# The handout is only useful if it is genuinely one page.
check-onepage:
	@n=$$($(R) -e 'cat(length(pdftools::pdf_info("$(HANDOUT_OUT)")$$pages))' 2>/dev/null \
	     || pdfinfo $(HANDOUT_OUT) 2>/dev/null | awk '/^Pages:/{print $$2}'); \
	if [ -z "$$n" ]; then echo "  (page count not checked: no pdfinfo/pdftools)"; \
	elif [ "$$n" = "1" ]; then echo "  page count: 1 --- good"; \
	else echo "  WARNING: handout is $$n pages, trim handout/one-pager.md"; fi

$(OUTDIR):
	@mkdir -p $(OUTDIR)

## ------------------------------------------------------------------- admin

clean:
	rm -f $(SLIDES_OUT) $(HANDOUT_OUT) $(HANDOUT_HTML)

distclean: clean
	rm -f $(NOTEBOOK).html $(APPENDIX).html
	rm -rf $(FIGDIR) $(OUTDIR)/workshop

help:
	@echo "Statistical thinking workshop"
	@echo
	@echo "  make notebook   participants' notebook  -> $(NOTEBOOK).html"
	@echo "  make appendix   instructor's document   -> $(APPENDIX).html"
	@echo "  make slides     editable deck           -> $(SLIDES_OUT)"
	@echo "  make handout    one-page A4 summary     -> $(HANDOUT_OUT)"
	@echo "  make all        all of the above"
	@echo
	@echo "  make reference-doc   extract a PowerPoint template to restyle"
	@echo "  make clean           remove the deck and the handout"
	@echo "  make distclean       also remove rendered documents and figures"
