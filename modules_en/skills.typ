// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvSkill, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)

#cvSection("Skills")

#cvSkill(
  type: [Langs],
  info: [English, Spanish],
)

#cvSkill(
  type: [Prog Langs],
  info: [Python, Java, Go, Rust, NodeJS, C, HTML/CSS/JavaScript],
)

#cvSkill(
  type: [DBs],
  info: [SQL Server, MySQL, PostgreSQL, MongoDB, AWS Athena, Cassandra, Redis],
)

#cvSkill(
  type: [DevOps],
  info: [Docker, Kubernetes, Terraform, Terragrunt, ArgoCD, Git, CI/CD, GitHub Actions, Prometheus, Grafana],
)

#cvSkill(
  type: [Data Eng],
  info: [PySpark, Pandas, Airflow, Databricks, DBT, Kafka, FastApi],
)

#cvSkill(
  type: [Cloud],
  info: [AWS, GCP, Azure],
)

#cvSkill(
  type: [Interests],
  info: [Hiking, Reading, Traveling, Photography, Cooking, Music, Programming, Gaming, Gardening, Cats],
)
