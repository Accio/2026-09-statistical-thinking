# Build the poster source out of the one-pager source: keep the title, the
# byline and the standfirst, keep the module questions, and drop the answers.
# The poster therefore cannot drift from the handout.
#
# Two things the poster says differently, both set here: it shows the breaks,
# which the handout does not, and it signs off with its own line instead of
# the handout's.

BEGIN {
  split("III VI", after, " "); for (i in after) pause[after[i]] = 1
  closing = "Please bring your questions - see you there!"
}

/^::: \{\.agenda\}/        { inside = 1; print "::: {.questions}"; next }
inside && /^:::[ \t]*$/    { inside = 0; past = 1; print ":::"; next }
inside && /^\*\*Module/ {
  print; print ""
  numeral = $0
  sub(/^\*\*Module /, "", numeral)
  sub(/\*\*.*$/, "", numeral)
  if (numeral in pause) {
    print "::: {.pause}"
    print "10-minute break"
    print ":::"
    print ""
  }
  next
}
inside                     { next }
past                       { next }   # the handout's sign-off, replaced below
                           { print }

END { if (past) { print ""; print closing } }
