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
    [Built a scalable AWS + Databricks data platform from the ground up, growing adoption from 0 users to company-wide usage in a data mesh architecture],
    [Designed and implemented a Kafka-based data ingestion SDK with Rust bindings for Python, Java, TypeScript, and Go, distributed company-wide across multiple operating systems and architectures],
    [Led CI/CD pipeline development for data engineering and data science projects, enabling deployment and monitoring of data pipelines and models in Databricks],
    [Contributed to data quality, reconciliation, and data contracts implementation, ensuring reliability and consistency across the platform],
    [Made the data platform accessible as a self-service for developers with clear naming conventions and best practices documentation],
   ),
  tags: (
    "Databricks",
    "Terraform",
    "Python",
    "Java",
    "AWS",
    "Terragrunt",
    "Typescript",
    "GitHub Actions",
    "CI/CD",
    "Rust",
    "kafka",
    "Open Telemetry",
    "MLflow",
    "Go",
  ),
)
#cvEntry(
  title: [Data Engineer],
  society: [Ahold Delhaize],
  date: [2022 - 2024],
  location: [Amsterdam, Netherlands],
  description: list(
    [Maintained and evolved a company-wide data platform, providing Databricks workspaces for multiple data products and teams],
    [Developed and optimized ETL pipelines on Databricks, enabling efficient data processing and analytics at scale],
    [Built and maintained Terraform modules for infrastructure automation on Azure, standardizing deployments across the organization],
    [Created monitoring and auditing tools with Python and Kusto, ensuring platform reliability and governance compliance],
    [Implemented CI/CD pipelines with GitHub Actions and ArgoCD for streamlined deployment of services to Azure and Kubernetes],
  ),
  tags: (
    "Python",
    "SQL",
    "Databricks",
    "Kusto",
    "Terraform",
    "GitHub Actions",
    "Azure",
    "Kubernetes",
    "ArgoCD",
    "kafka",
  ),
)

#cvEntry(
  title: [Data Engineer],
  society: [Dashmote],
  date: [2021 - 2022],
  location: [Amsterdam, Netherlands],
  description: list(
    [Designed and implemented Infrastructure as Code (IaC) with Terraform on AWS, reducing deployment time by 70% and improving reliability],
    [Migrated legacy Apache Airflow pipelines to PySpark, enhancing performance and reducing operational costs],
    [Optimized CI/CD pipelines and Docker image builds using multi-stage techniques, reducing build times and infrastructure costs],
    [Designed and deployed a production-ready data lake on AWS, establishing data governance and enabling self-service analytics],
    [Mentored team members and implemented improved DevOps practices, accelerating development workflows across the organization],
  ),
  tags: ("Terraform", "AWS", "Python", "Apache Airflow", "Docker", "DevOps", "PySpark"),
)

#cvEntry(
  title: [Software Engineer],
  society: [Ernst & Young (EY)],
  date: [2019 - 2020],
  location: [Madrid, Spain],
  description: list(
    [Developed data processing applications using Python, SQL, and Java for automation and ETL tasks, improving operational efficiency],
    [Built and maintained machine learning models for predictive analytics, enhancing data-driven decision making],
    [Managed Linux systems and implemented full-stack web applications for internal data visualization tools],
    [Contributed to project planning and execution, collaborating with cross-functional teams to deliver client solutions],
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