# Build the poster source out of the one-pager source: keep the title, the
# byline, the standfirst and the closing line, keep the module questions, and
# drop the answers. The poster therefore cannot drift from the handout.
#
# The poster also shows the breaks, which the handout does not: list the
# module each break follows here, by its Roman numeral.

BEGIN { split("III VI", after, " "); for (i in after) pause[after[i]] = 1 }

/^::: \{\.agenda\}/        { inside = 1; print "::: {.questions}"; next }
inside && /^:::[ \t]*$/    { inside = 0; print ":::"; next }
inside && /^\*\*Module/ {
  print; print ""
  numeral = $0
  sub(/^\*\*Module /, "", numeral)
  sub(/\*\*.*$/, "", numeral)
  if (numeral in pause) {
    print "::: {.pause}"
    print "15-minute break"
    print ":::"
    print ""
  }
  next
}
inside                     { next }
                           { print }
