// Imports
#import "@preview/brilliant-cv:2.0.2": cvSection, cvEntry
#let metadata = toml("../metadata.toml")
#let cvSection = cvSection.with(metadata: metadata)
#let cvEntry = cvEntry.with(metadata: metadata)


#cvSection("Professional Experience")

#cvEntry(
  title: [Data Engineer],
  society: [Woven by Toyota],
  date: [2024 - Present],
  location: [Tokyo, Japan],
  description: list(
    [Built a scalable, cloud-native data mesh platform on AWS and Databricks, adopted company-wide to enable governed, high-quality data sharing across domains],
    [Developed a multi-language Kafka ingestion SDK (Rust core with Python, Java, TypeScript, and Go bindings), deployed org-wide for real-time ingestion across heterogeneous systems],
    [Designed and implemented CI/CD pipelines for ML and data workflows in Databricks, integrating deployment and lifecycle tracking with MLflow],
    [Improved platform resilience through automated data reconciliation, OpenTelemetry instrumentation, and enforcement of data contracts],
    [Led development of self-service capabilities, including automated provisioning of Kafka topics, access control groups, and data product registration, reducing onboarding friction across the org],
    [Created platform documentation, naming conventions, and onboarding guides to support self-serve adoption by engineers, analysts, and ML practitioners],
  ),
  tags: (
    "AWS",
    "Databricks",
    "Rust",
    "Python",
    "Java",
    "Go",
    "TypeScript",
    "Kafka",
    "Terraform",
    "MLflow",
    "CI/CD",
    "OpenTelemetry",
    "Data Mesh",
    "Data Contracts",
    "Self-Service",
  ),
)
#cvEntry(
  title: [Data Engineer],
  society: [Ahold Delhaize],
  date: [2022 - 2024],
  location: [Amsterdam, Netherlands],
  description: list(
    [Managed a company-wide data platform built on Azure and Databricks, supporting large-scale batch and real-time pipelines],
    [Built reusable Terraform modules and automated infrastructure provisioning to reduce deployment time and enforce compliance],
    [Created observability tooling using Python and Kusto to ensure data quality and regulatory compliance across data products],
    [Implemented CI/CD with GitHub Actions and ArgoCD, automating deployment of services and pipelines to Kubernetes clusters],
    [Worked closely with analysts and data scientists to productionize ML pipelines and deploy feature engineering workflows],
  ),
  tags: (
    "Azure",
    "Databricks",
    "Terraform",
    "CI/CD",
    "Python",
    "Kubernetes",
    "GitHub Actions",
    "Kusto",
  ),
)

#cvEntry(
  title: [Data Engineer],
  society: [Dashmote],
  date: [2021 - 2022],
  location: [Amsterdam, Netherlands],
  description: list(
    [Led AWS-based infrastructure migration using Terraform, reducing manual provisioning and enabling reproducible environments],
    [Migrated legacy Airflow pipelines to PySpark for scalable data processing and analytics workflows],
    [Optimized Docker builds and CI pipelines to cut build time and reduce cloud costs by applying multi-stage techniques],
    [Designed and deployed a governed data lake on S3 with robust schema management and access controls],
    [Collaborated with data scientists to automate training data pipelines and streamline model experimentation],
  ),
  tags: (
    "AWS",
    "Terraform",
    "Python",
    "Apache Airflow",
    "PySpark",
    "Docker",
    "CI/CD",
  ),
)

#cvEntry(
  title: [Software Engineer],
  society: [Ernst & Young (EY)],
  date: [2019 - 2020],
  location: [Madrid, Spain],
  description: list(
    [Built ETL pipelines in Python, SQL, and Java to automate financial reporting workflows across global client accounts],
    [Trained and deployed ML models for forecasting and risk scoring in regulated environments],
    [Built and deployed full-stack data visualization tools on Linux for internal analytics teams],
    [Participated in project planning with clients, translating business goals into deliverable data products],
  ),
  tags: (
    "Python",
    "SQL",
    "Java",
    "Talend",
    "Linux",
    "Machine Learning",
    "Full-stack",
  ),
)