// Imports
#import "@preview/brilliant-cv:2.0.7": cvSection, cvSkill, hBar
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)


#cvSection("Skills")

#cvSkill(
  type: [Nationality],
  info: [Spain (EU)],
)

#cvSkill(
  type: [Languages],
  info: [English (business fluent), Spanish (native)],
)

#cvSkill(
  type: [Coding],
  info: [Python, Rust, Java, Go, TypeScript, C, JavaScript, HTML/CSS],
)

#cvSkill(
  type: [Cloud & Infra],
  info: [AWS (Redshift, S3, Glue, Lambda, SageMaker), Azure, GCP, Terraform, Docker, Kubernetes],
)

#cvSkill(
  type: [Data Engineering],
  info: [PySpark, Pandas, Databricks, Airflow, DBT, Kafka, MLflow, FastAPI],
)

#cvSkill(
  type: [DevOps],
  info: [CI/CD, GitHub Actions, ArgoCD, Terragrunt, Prometheus, Grafana],
)

#cvSkill(
  type: [Databases],
  info: [SQL Server, PostgreSQL, MySQL, MongoDB, Athena, Cassandra, Redis],
)

#cvSkill(
  type: [Interests],
  info: [Hiking, Reading, Photography, Cooking, Gaming, Music production, Cats],
)
