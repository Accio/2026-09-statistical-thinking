# Turn the plain-text survey into a form. The rating rows and the write-in
# rules are markup Markdown cannot express -- a run of spaces collapses, so
# "Poor  1  2  3 ... Excellent" would come out as one line of prose -- so they
# are rebuilt here as tagged spans and empty rules. Everything else passes
# through untouched, which keeps handout/survey.md readable on its own.

/^Question [0-9]+:/ { sub(/^Question [0-9]+:/, "**&**"); print; next }

# a rating row: two labels with the scale points between them
match($0, /[0-9]+([ \t]+[0-9]+)+/) {
  low  = substr($0, 1, RSTART - 1)
  high = substr($0, RSTART + RLENGTH)
  gsub(/^[ \t]+|[ \t]+$/, "", low)
  gsub(/^[ \t]+|[ \t]+$/, "", high)
  n = split(substr($0, RSTART, RLENGTH), point, /[ \t]+/)

  row = "[" low "]{.lo}"
  for (i = 1; i <= n; i++) row = row " [" point[i] "]{.pt}"
  row = row " [" high "]{.hi}"

  print "::: {.scale}"
  print row
  print ":::"
  next
}

# a write-in line
/^_+[ \t]*$/ { print "::: {.rule}"; print ":::"; next }

{ print }
