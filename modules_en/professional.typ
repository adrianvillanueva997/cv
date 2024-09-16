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
    [Leading an engineering team to build a scalable data platform on AWS using Terraform, Terragrunt, and Databricks],
    [Implementation of internal libraries and tools for data engineering and data science teams to improve productivity in Python, Java, Typescript, and Rust],
    [Design and implement CI/CD pipelines for data engineering and data science projects to deploy and monitor data pipelines and models in Databricks],
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
  ),
)

#cvEntry(
  title: [Data Engineer],
  society: [Ahold Delhaize],
  date: [2022 - 2024],
  location: [Amsterdam, Netherlands],
  description: list(
    [Analyze datasets with SQL/Python, collaborate for insights],
    [Streamline CI/CD pipelines],
    [Develop Python solutions with Kusto for automation/auditing],
    [Create ETL pipelines on Databricks],
    [Design internal tools for auditing/monitoring with Python],
    [Maintain Terraform modules and CI/CD on GitHub Actions],
    [Deploy resources on Azure/Kubernetes with ArgoCD],
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
    [Infrastructure as Code (IaC) with Terraform on AWS, design and implement scripts for service deployments],
    [Maintain and optimize legacy Apache Airflow components in Python],
    [Deploy and optimize Docker images using buildkit, caching, and multi-stage builds],
    [Collaborate and mentor team, design and deploy production-ready datalake on AWS],
    [Redesign and implement DevOps strategies for faster workflows],
  ),
  tags: ("Terraform", "AWS", "Python", "Apache Airflow", "Docker", "DevOps"),
)


#cvEntry(
  title: [Software Engineer],
  society: [Ernst & Young (EY)],
  date: [2019 - 2020],
  location: [Madrid, Spain],
  description: list(
    [Assisted with data cleaning, processing, and analysis using Python and Excel, participated in team meetings and contributed to project planning and execution],
    [Contributed to software development for automation and ETL tasks using SQL, Python, Java, and Talend],
    [Managed Linux systems, including Ubuntu and CentOS, ensuring stability and security],
    [Developed and prototyped machine learning models for predictive analytics and data engineering],
    [Full-stack web development],
  ),
  tags: (
    "Python",
    "Excel",
    "SQL",
    "Java",
    "Talend",
    "Linux",
    "Machine Learning",
    "Full-stack",
  ),
)
