# Terraform Examples on AWS (Amazon Web Services)

Terraform is a powerful tool used to create, manage, and update infrastructure resources such as physical machines, virtual machines, network switches, containers, and more. Almost any infrastructure type can be represented as a resource in Terraform.

This repository contains Terraform code examples for AWS (Amazon Web Services), inspired by the book **Terraform: Up and Running** by *Yevgeniy Brikman*.

---

## 🚀 Quick Start

Before you begin, ensure you have:

- An **AWS account**
- **Terraform installed** on your machine

The examples are written using **HashiCorp Configuration Language (HCL)**.

All the code can be found inside the `code` folder.

For specific instructions on running each example, refer to the README file within each folder.

---

## 📁 List of Examples

1. **01-hello-world**  
   - A minimal "Hello, World" Terraform script that deploys a single server on AWS with the shortest possible configuration.

2. **02-one-webserver**  
   - A more advanced setup that deploys a web server on AWS, returning "Hello, World" at the root URL (`/`) while listening on port `8080`.

3. **03-webserver-with-vars**  
   - Terraform Web Server with vars: Example of how deploy a single web server on AWS (Amazon Web Services). The web server returns "Hello, World" for the URL / listening on port 8080, which is defined as a variable.

4. **04-web-clusters**  
   - Terraform Cluster Web Server: Example of how deploy a cluster of web servers on AWS (Amazon Web Services) using EC2 and Auto Scaling, as well as a load balancer using ELB. The cluster of web servers returns "Hello, World" for the URL /. The load balancer listens on port 80.

---

## 💡 Notes

- These examples aim to demonstrate basic Terraform principles on AWS and can be extended for more complex infrastructures.
- Always review your AWS costs — even simple examples may incur charges.

---

Happy provisioning! 🚀✨  
