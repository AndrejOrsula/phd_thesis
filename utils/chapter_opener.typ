#let chapter-opener(number) = {
  let graphics = (
    "../figures/artwork/01_introduction.svg",
    "../figures/artwork/02_background.svg",
    "../figures/artwork/03_foundation.svg",
    "../figures/artwork/04_bench.svg",
    "../figures/artwork/05_autonomy.svg",
    "../figures/artwork/06_validation.svg",
    "../figures/artwork/07_conclusion.svg",
  )

  if number >= 1 and number <= graphics.len() {
    move(dy: -14pt, image(graphics.at(number - 1), width: 116pt))
  }
}
