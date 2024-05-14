# Set Kubernetes CLI

[kubectl](https://kubernetes.io/docs/reference/kubectl/)  is used to set up the kubectl command-line tool in your GitHub Actions workflow. kubectl is the Kubernetes command-line tool that allows you to run commands against Kubernetes clusters. By using this action, you can automate the process of installing and configuring kubectl in your CI/CD pipelines.
This action also guarantees that the kubectl version matches the Kubernetes cluster version.


## Example

```yaml
- name: Set kubectl
  uses: DFE-Digital/github-actions/set-kubectl@master
  ```
