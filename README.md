# Layer5 Academy Build Action

**A GitHub Action to trigger academy content updates for your organization using the Layer5 Cloud API.**

The Layer5 Academy Build Action provides a seamless way to integrate academy content updates into your continuous integration and deployment workflows. This action is designed to work with Hugo-powered academy sites and automatically notifies the Layer5 platform to pull the latest content for your organization.

## Overview

This action serves as a bridge between your content management workflows and the Layer5 Cloud platform. When your academy content is built and deployed, this action ensures that the Layer5 platform is notified to refresh and pull the latest educational materials, tutorials, and documentation for your organization.

## Usage

Basic usage in your GitHub Actions workflow:

```yaml
- name: Trigger Academy Update
  uses: layer5io/academy-build@v1
  with:
    orgId: 'your-org-id'
    token: ${{ secrets.ACADEMY_API_TOKEN }}
    version: 'v1.2.3' # optional, defaults to "latest"
```

This action can be integrated into your existing workflows after building your site or triggered on versioned releases to ensure your academy content stays synchronized with your organization's latest materials.

## Inputs

| Name      | Required | Description                                                                    |
| --------- | -------- | ------------------------------------------------------------------------------ |
| `orgId`   | Yes      | The organization ID to update academy content for.                             |
| `token`   | Yes      | Bearer token for authenticating the API call. Store it securely using secrets. |
| `version` | No       | Module version to be updated. Defaults to `"latest"` if not specified.         |

## Outputs

| Name       | Description                                           |
| ---------- | ----------------------------------------------------- |
| `response` | The JSON response returned by the Academy update API. |

## Example Workflow

This comprehensive workflow demonstrates how to use the Academy Build Action in a release-triggered workflow:

```yaml
name: Update Academy on Release

on:
  release:
    types: [published]

jobs:
  update-academy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build academy content
        run: |
          # Your build steps here
          hugo --minify

      - name: Call Layer5 Academy Update API
        id: update
        uses: layer5io/academy-build@v1
        with:
          orgId: 'your-org-id'
          token: ${{ secrets.ACADEMY_API_TOKEN }}
          version: ${{ github.ref_name }}

      - name: Print API response
        run: echo "${{ steps.update.outputs.response }}"
```

## Security Best Practices

**Token Management**: Always store the `token` input as a GitHub secret and never hardcode it in your workflow YAML files. This ensures that your API credentials remain secure and are not exposed in your repository.

**Secret Configuration**: Configure your secrets in your repository settings under Settings > Secrets and variables > Actions, and reference them using the `${{ secrets.SECRET_NAME }}` syntax.

## Advanced Usage

### Conditional Updates

You can conditionally trigger academy updates based on specific criteria:

```yaml
- name: Trigger Academy Update
  if: github.event.release.prerelease == false
  uses: layer5io/academy-build@v1
  with:
    orgId: 'your-org-id'
    token: ${{ secrets.ACADEMY_API_TOKEN }}
    version: ${{ github.ref_name }}
```

### Multiple Organization Support

For organizations managing multiple academy instances:

```yaml
- name: Update Primary Academy
  uses: layer5io/academy-build@v1
  with:
    orgId: 'primary-org-id'
    token: ${{ secrets.ACADEMY_API_TOKEN }}
    version: ${{ github.ref_name }}

- name: Update Secondary Academy
  uses: layer5io/academy-build@v1
  with:
    orgId: 'secondary-org-id'
    token: ${{ secrets.ACADEMY_API_TOKEN }}
    version: ${{ github.ref_name }}
```

## Marketplace

This action is available on the GitHub Marketplace. To use it in your workflows, reference it as:

```
uses: layer5io/academy-build@v1
```

The action supports composite run steps and requires no additional runtime dependencies, making it lightweight and easy to integrate into existing workflows.






- Find us on Twitter: [@layer5](https://twitter.com/layer5), [@mesheryio](https://twitter.com/mesheryio), and [@smp_spec](https://twitter.com/smp_spec)
- Visit us on LinkedIn: [Layer5](https://www.linkedin.com/company/layer5), [Meshery](https://www.linkedin.com/showcase/meshery/), and [Cloud Native Performance](https://www.linkedin.com/showcase/service-mesh-performance)
- Subscribe on [Youtube](http://youtube.com/Layer5io?sub_confirmation=1)

## License

All of Layer5's projects are available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).
