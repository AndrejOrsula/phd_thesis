#import "utils/global.typ": *
#import "utils/chapter_opener.typ": chapter-opener
#import "content/miscellaneous/glossary.typ"
#import "content/miscellaneous/publications.typ"

// `typst compile --input edition=digital` builds the edition for reading on
// screen; the default is the print edition.
#let edition = sys.inputs.at("edition", default: "print")
#assert(
  edition in ("print", "digital"),
  message: "edition must be print or digital, not " + edition,
)

#show bibliography: it => {
  show regex(" {2,}"): " "
  show regex("\b(vol|no|pp|p)\. "): it => it.text.replace(" ", "\u{a0}")
  show regex("\d–\d"): it => it.text.replace("–", "\u{2060}–\u{2060}")
  show regex("\d—\d"): it => it.text.replace("—", "\u{2060}—\u{2060}")
  show regex("\d-DoF"): it => it.text.replace("-", "\u{2011}")
  show "Master's": "Master’s"
  it
}

#show: thesis.with(
  author: "Andrej Orsula",
  title: "Robot Learning Beyond Earth",
  subtitle: "Enabling Adaptive Autonomy in Space",
  degree: "DOCTOR OF PHILOSOPHY",
  degree-subject: "IN COMPUTER SCIENCE",
  faculty: "Faculty of Science, Technology and Medicine",
  department: none,
  doc-id: "PhD-FSTM-2025-122",
  supervisors: (
    (
      title: "Prof.",
      name: "Miguel Olivares-Mendez",
    ),
  ),
  cosupervisors: (
    (
      title: "Prof.",
      name: "Carol Martinez",
    ),
  ),
  committee: (
    (
      title: "Prof.",
      name: "Holger Voos",
    ),
    (
      title: "Prof.",
      name: "Keenan Albee",
    ),
    (
      title: "Dr.",
      name: "Claudio Semini",
    ),
  ),
  date: datetime(day: 30, month: 9, year: 2025),
  defense-date: datetime(day: 19, month: 12, year: 2025),
  defense-location: "Luxembourg",
  cover-author: "Andrej Orsula",
  affidavit: include "content/frontmatter/affidavit.typ",
  figure-index: true,
  table-index: true,
  listing-index: false,
  glossary: glossary.entry_list,
  glossary-group-order: ("Space", "Machine Learning", "Robotics", "Software"),
  preface: include "content/frontmatter/preface.typ",
  epigraph: include "content/frontmatter/epigraph.typ",
  acknowledgements: none,
  abstract: include "content/0_abstract.typ",
  bibliography: bibliography(
    "bibliography.bib",
    title: "Bibliography",
    style: "ieee",
  ),
  publications: publications.entry_list,
  appendix: [],
  chapter-opener: chapter-opener,
  physical-copy: edition == "print",
  accent: unilu-blue,
  front-img: {
    place(top + left, image(
      "figures/logos/frontpage.svg",
      width: 210mm,
      height: 297mm,
    ))
  },
  affidavit-img: image("figures/logos/affidavit.svg"),
  back-img: {
    place(top + left, image(
      "figures/logos/backpage.svg",
      width: 210mm,
      height: 297mm,
    ))
    place(top + center, dy: 32mm, image(
      "figures/artwork/cover_back.svg",
      width: 175mm,
    ))
  },
)

#set par(spacing: 2.1em)
#set text(costs: (hyphenation: 200%))

#set table(fill: (_, y) => if calc.odd(y) { grey-tint })
#set list(marker: ([•], [‣], [–]))

#let sticky-subheading = it => {
  v(2.5em, weak: true)
  block(sticky: true, below: 1.5em, it.body)
}
#show heading.where(level: 4): sticky-subheading
#show heading.where(level: 5): sticky-subheading

#include "content/1_introduction.typ"
#include "content/2_background.typ"
#include "content/3_foundation.typ"
#include "content/4_bench.typ"
#include "content/5_autonomy.typ"
#include "content/6_validation.typ"
#include "content/7_conclusion.typ"
