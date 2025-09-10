
# 🏫 Update Academy Action

**Trigger an academy content update for your organization using the Layer5 Cloud API.**

This action is useful when you want to build and deploy an academy site (powered by Hugo) and then notify the Layer5 platform to pull the latest content for your organization.

---

## 🚀 Usage

```yaml
- name: Trigger Academy Update
  uses: layer5io/academy-build@v1
  with:
    orgId: 'your-org-id'
    token: ${{ secrets.ACADEMY_API_TOKEN }}
    version: 'v1.2.3' # optional, defaults to "latest"
```

You can integrate this into your workflows after building your site or on versioned releases.

---

## 📥 Inputs

| Name      | Required | Description                                                                    |
| --------- | -------- | ------------------------------------------------------------------------------ |
| `orgId`   | ✅ Yes    | The organization ID to update academy content for.                             |
| `token`   | ✅ Yes    | Bearer token for authenticating the API call. Store it securely using secrets. |
| `academy-name` | ❌ No     | The name of the Academy being updated (e.g., Layer5 Academy). Defaults to `"Academy"` if not specified.        |
| `version` | ❌ No     | Module version to be updated. Defaults to `"latest"` if not specified.         |

---

## 📤 Outputs

| Name       | Description                                           |
| ---------- | ----------------------------------------------------- |
| `response` | The JSON response returned by the Academy update API. |

---

## ✅ Example Workflow

This workflow runs on every release and triggers an academy content update with the release version:

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
        uses: actions/checkout@v5

     
      - name: Call Layer5 Academy Update API
        uses: layer5io/academy-build@v0.1.5
        with:
          orgId: 'your-org-id'
          token: ${{ secrets.ACADEMY_API_TOKEN }}
          version: ${{ github.ref_name }}
          academy-name: 'your-academy-name' # Layer5 Academy

      - name: Print API response
        run: echo "${{ steps.update.outputs.response }}"
```

---

## 🔐 Security

Always store the `token` input as a GitHub secret and **never hardcode it** in your workflow YAML.

---

## 🧑‍💻 Maintained by [Layer5](https://layer5.io)

💬 If you encounter issues or want to contribute, please open an issue or pull request at [github.com/layer5io/academy-build](https://github.com/layer5io/academy-build).

---

## 🏷️ Marketplace

To use this action from the [GitHub Marketplace](https://github.com/marketplace/actions), reference it like:

```
uses: layer5io/academy-build@master
```

> Supports [composite run steps](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action) – no runtime required.

---

