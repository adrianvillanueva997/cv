// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvEntry, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Education")

#cvEntry(
  title: [Computer science],
  society: [Universidad Europea, Madrid],
  date: [2015- 2022],
  location: [Spain],
  description: list([Thesis: Building a self-hosted AI driven platform for security cameras monitoring using edge computing #hBar() GPA: 9.5/10]),
)
