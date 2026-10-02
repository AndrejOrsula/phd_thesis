#import "global.typ": *

#let research-question(
  num: none,
  body: none,
) = {
  box(
    stroke: 0.5pt + black,
    fill: unilu-blue-light,
    width: 100%,
    inset: 0.5em,
    radius: 0.25em,
  )[
    #align(center, [
      #heading(level: 3, numbering: none, [Research Question #str(num)])#label(
        "rq:" + str(num),
      )
    ])
    #v(-0.5em)
    #align(
      left,
      body,
    )
  ]
  v(-1.0em)
}

#let research-objective(
  num: none,
  body: none,
) = {
  box(
    stroke: 0.5pt + black,
    fill: unilu-red-light,
    width: 100%,
    inset: 0.5em,
    radius: 0.25em,
  )[
    #align(center, [
      #heading(level: 3, numbering: none, [Research Objective #str(num)])#label(
        "ro:" + str(num),
      )
    ])
    #v(-0.5em)
    #align(
      left,
      body,
    )
  ]
  v(-1.0em)
}
