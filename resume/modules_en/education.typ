// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvEntry, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Education")

#cvEntry(
  title: [Bachelor’s Degree in Computer Science],
  society: [Universidad Europea de Madrid],
  date: [2015 – 2022],
  location: [Spain],
  description: list(
    [Graduated with GPA: 9.5/10],
    [Thesis: Self-hosted AI-driven platform for security camera monitoring using edge computing],
  ),
)