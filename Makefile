# Statistical thinking workshop --- build
#
#   make notebook   the participants' notebook (also writes figures + CSV exports)
#   make appendix   the instructor's technical document
#   make slides     an editable PowerPoint deck
#   make handout    the one-page A4 summary
#   make poster     the A4 poster of the nine questions
#   make survey     the A4 feedback form
#   make all        everything
#   make tools      show which R / pandoc / PDF engine was picked up here
#
# The deck and the handout are built from plain Markdown sources in slides/
# and handout/ --- edit those, not the generated files. The deck reuses the
# figures the notebook writes to output/figures/, so `make slides` will build
# the notebook first if the figures are missing or stale.

## -------------------------------------------------------------- toolchain
#
# The build has to run in two places: a laptop, where Rscript, pandoc and
# weasyprint are all on the PATH, and an HPC login node, where R and pandoc
# come from environment modules and WeasyPrint is not installed at all.
# Everything below is detected at parse time; `make tools` shows what was
# found, and R / PANDOC / HTML-to-PDF can each be overridden on the command
# line, e.g. `make handout WEASYPRINT=/path/to/weasyprint`.

SHELL := /bin/bash

# lastword: a login shell may print a banner on stdout before the path.
detect = $(lastword $(shell command -v $(1) 2>/dev/null))

R ?= $(call detect,Rscript)
ifneq ($(R),)
  R_DESC := $(R)
else
  # HPC: R comes from environment modules and needs that whole environment,
  # not just its binary on the PATH, so every call goes through the loader.
  R_LOADER := $(wildcard $(HOME)/scripts/load-bioinfo-R.bash)
  ifneq ($(R_LOADER),)
    R      := bash -lc 'source $(R_LOADER) >/dev/null 2>&1; exec Rscript "$$@"' --
    R_DESC := Rscript via $(R_LOADER)
  else
    R      := Rscript
    R_DESC := NOT FOUND
  endif
endif

PANDOC ?= $(call detect,pandoc)
ifeq ($(PANDOC),)
  PANDOC := $(lastword $(shell bash -lc 'module load Pandoc >/dev/null 2>&1 && command -v pandoc' 2>/dev/null))
endif

# rmarkdown::render() needs to find pandoc too, not just this Makefile.
ifneq ($(PANDOC),)
  PANDOC_DIR := $(patsubst %/,%,$(dir $(PANDOC)))
  export RSTUDIO_PANDOC := $(PANDOC_DIR)
  export PATH := $(PANDOC_DIR):$(PATH)
endif

# HTML -> PDF: WeasyPrint if present, otherwise headless Chrome, which
# honours the same @page rules in handout/one-pager.css.
WEASYPRINT ?= $(call detect,weasyprint)
CHROME     ?= $(firstword $(foreach c,google-chrome chromium chromium-browser,$(call detect,$(c))))
CHROME_FLAGS := --headless --disable-gpu --no-sandbox --no-pdf-header-footer --log-level=3

ifneq ($(WEASYPRINT),)
  PDF_ENGINE := weasyprint
  # $(1) input HTML, $(2) output PDF
  html2pdf    = $(WEASYPRINT) '$(1)' '$(2)'
else ifneq ($(CHROME),)
  PDF_ENGINE := $(notdir $(CHROME)) --headless
  # Chrome resolves both paths against its own cwd, and chatters on stderr.
  html2pdf    = $(CHROME) $(CHROME_FLAGS) --print-to-pdf='$(abspath $(2))' '$(abspath $(1))' 2>/dev/null; test -s '$(2)'
else
  PDF_ENGINE := none found
  html2pdf    = { echo "ERROR: need weasyprint or a Chrome/Chromium binary to make the PDF handout."; \
	            echo "       the HTML version is in $(HANDOUT_HTML)"; exit 1; }
endif

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

# The poster is the handout minus the answers, extracted from the same source.
POSTER_AWK  := handout/poster.awk
POSTER_CSS  := handout/poster.css
POSTER_SRC  := $(OUTDIR)/poster.md
POSTER_HTML := $(OUTDIR)/2026-09-workshop-poster.html
POSTER_OUT  := $(OUTDIR)/2026-09-workshop-poster.pdf

# The feedback form. handout/survey.md is plain text; survey.awk turns the
# rating rows and the write-in lines into markup Markdown cannot express.
SURVEY_MD   := handout/survey.md
SURVEY_AWK  := handout/survey.awk
SURVEY_CSS  := handout/survey.css
SURVEY_SRC  := $(OUTDIR)/survey-form.md
SURVEY_HTML := $(OUTDIR)/2026-09-workshop-survey.html
SURVEY_OUT  := $(OUTDIR)/2026-09-workshop-survey.pdf

.DEFAULT_GOAL := help
.PHONY: all help tools require-pandoc notebook appendix slides handout poster \
        survey reference-doc check-onepage clean distclean

## ---------------------------------------------------------------- targets

all: notebook appendix slides handout poster survey

notebook: $(NOTEBOOK).html
appendix: $(APPENDIX).html
slides:   $(SLIDES_OUT)
handout:  $(HANDOUT_OUT)
poster:   $(POSTER_OUT)
survey:   $(SURVEY_OUT)

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
$(SLIDES_OUT): $(SLIDES_SRC) $(FIGSTAMP) | $(OUTDIR) require-pandoc
	$(PANDOC) $< --slide-level=2 --resource-path=.:$(FIGDIR) \
	  $(if $(wildcard $(SLIDES_REF)),--reference-doc=$(SLIDES_REF),) \
	  -o $@
	@echo "wrote $@"

reference-doc: require-pandoc
	@mkdir -p slides
	$(PANDOC) --print-default-data-file reference.pptx > $(SLIDES_REF)
	@echo "wrote $(SLIDES_REF) --- restyle it and rebuild with 'make slides'"

## ----------------------------------------------------------------- handout

# One A4 page, from Markdown, via pandoc and whichever PDF engine is around.
$(HANDOUT_OUT): $(HANDOUT_SRC) $(HANDOUT_CSS) | $(OUTDIR) require-pandoc
	$(PANDOC) $< --standalone --embed-resources --css=$(HANDOUT_CSS) \
	  --metadata title="Statistical thinking --- one page" -o $(HANDOUT_HTML)
	$(call html2pdf,$(HANDOUT_HTML),$@)
	@echo "wrote $@ (via $(PDF_ENGINE))"
	@$(MAKE) --no-print-directory check-onepage PDF=$@ CSS=$(HANDOUT_CSS)

## ------------------------------------------------------------------ poster

# The nine questions on one A4 sheet, for the wall. Generated from the
# handout source so the wording is guaranteed to be the same.
$(POSTER_SRC): $(HANDOUT_SRC) $(POSTER_AWK) | $(OUTDIR)
	awk -f $(POSTER_AWK) $< > $@

$(POSTER_OUT): $(POSTER_SRC) $(POSTER_CSS) | $(OUTDIR) require-pandoc
	$(PANDOC) $< --standalone --embed-resources --css=$(POSTER_CSS) \
	  --metadata title="Statistical thinking --- poster" -o $(POSTER_HTML)
	$(call html2pdf,$(POSTER_HTML),$@)
	@echo "wrote $@ (via $(PDF_ENGINE))"
	@$(MAKE) --no-print-directory check-onepage PDF=$@ CSS=$(POSTER_CSS)

## ------------------------------------------------------------------ survey

# The feedback form, one A4 page to print and hand out at the end.
$(SURVEY_SRC): $(SURVEY_MD) $(SURVEY_AWK) | $(OUTDIR)
	awk -f $(SURVEY_AWK) $< > $@

$(SURVEY_OUT): $(SURVEY_SRC) $(SURVEY_CSS) | $(OUTDIR) require-pandoc
	$(PANDOC) $< --standalone --embed-resources --css=$(SURVEY_CSS) \
	  --metadata title="Statistical thinking --- survey" -o $(SURVEY_HTML)
	$(call html2pdf,$(SURVEY_HTML),$@)
	@echo "wrote $@ (via $(PDF_ENGINE))"
	@$(MAKE) --no-print-directory check-onepage PDF=$@ CSS=$(SURVEY_CSS)

## ------------------------------------------------------------- page check

# A one-page sheet is only useful if it is genuinely one page, and how much
# space the text takes depends on which fonts the machine has, so this is
# measured after every build rather than assumed. The free-space figure is
# the headroom you have for enlarging the type.
check-onepage:
	@n=$$(pdfinfo $(PDF) 2>/dev/null | awk '/^Pages:/{print $$2}'); \
	if [ -z "$$n" ]; then \
	  n=$$($(R) -e 'cat(length(pdftools::pdf_info("$(PDF)")$$pages))' 2>/dev/null); \
	fi; \
	if [ -z "$$n" ]; then \
	  echo "  (page count not checked: no pdfinfo, no pdftools)"; \
	elif [ "$$n" = "1" ]; then \
	  free=$$(pdftotext -f 1 -l 1 -bbox $(PDF) - 2>/dev/null \
	          | grep -o 'yMax="[0-9.]*"' | grep -o '[0-9.]*' | sort -g | tail -1 \
	          | awk '{printf " (%.0f mm free at the foot)", (841.89-$$1)*25.4/72}'); \
	  echo "  page count: 1 --- good$$free"; \
	else \
	  echo "  ERROR: $(PDF) came out as $$n pages."; \
	  echo "         Lower 'html { font-size }' in $(CSS) by 0.2pt and"; \
	  echo "         rebuild --- that one value scales the whole sheet."; \
	  exit 1; \
	fi

$(OUTDIR):
	@mkdir -p $(OUTDIR)

## ------------------------------------------------------------------- admin

# What the build resolved to here. Run this first if a target fails.
tools:
	@echo "Rscript    : $(R_DESC)"
	@echo "pandoc     : $(if $(PANDOC),$(PANDOC),NOT FOUND --- try 'module load Pandoc')"
	@echo "HTML -> PDF: $(PDF_ENGINE)"

require-pandoc:
	@test -n "$(PANDOC)" || { \
	  echo "ERROR: pandoc not found."; \
	  echo "       laptop: install it; HPC: 'module load Pandoc', or pass PANDOC=/path/to/pandoc"; \
	  exit 1; }

clean:
	rm -f $(SLIDES_OUT) $(HANDOUT_OUT) $(HANDOUT_HTML) \
	      $(POSTER_OUT) $(POSTER_HTML) $(POSTER_SRC) \
	      $(SURVEY_OUT) $(SURVEY_HTML) $(SURVEY_SRC)

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
	@echo "  make poster     A4 poster of questions  -> $(POSTER_OUT)"
	@echo "  make survey     A4 feedback form        -> $(SURVEY_OUT)"
	@echo "  make all        all of the above"
	@echo
	@echo "  make tools           show the detected R / pandoc / PDF engine"
	@echo "  make reference-doc   extract a PowerPoint template to restyle"
	@echo "  make clean           remove the deck, the handout and the poster"
	@echo "  make distclean       also remove rendered documents and figures"
	@echo
	@echo "  toolchain: $(PDF_ENGINE) for the PDF; pandoc $(if $(PANDOC),ok,MISSING)"
