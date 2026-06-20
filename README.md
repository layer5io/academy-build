<p align="center">
  <img src=".github/welcome/Layer5-celebration.png" alt="Layer5 Celebration">
</p>


##🏫 Update Academy Action

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

---

<p style="clear:both;">
  <img src=".github/readme/images/community.svg"
       width="50"
       alt="Layer5 Community"
       align="left"
       style="margin-right:15px;" />

## Community & Contributions

We warmly welcome all contributors! As you get started, please review this project's [contributing guidelines](CONTRIBUTING.md).
</p>

Contributors are expected to follow the [CNCF Code of Conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md).

<p>
<a href="https://slack.layer5.io">

<picture align="right">
  <source media="(prefers-color-scheme: dark)" srcset=".github/readme/images/slack-dark-128.png">
  <source media="(prefers-color-scheme: light)" srcset=".github/readme/images/slack-128.png">
  <img src=".github/readme/images/slack-128.png"
       width="120"
       align="right"
       style="margin-left:10px;"
       alt="Join Layer5 Slack">
</picture>

</a>

<a href="https://layer5.io/community">
  <img src=".github/readme/images/community.svg"
       width="140"
       align="left"
       style="margin-right:10px;"
       alt="Layer5 Community">
</a>

✔️ <em><strong>Join</strong></em> the <a href="https://slack.layer5.io">Layer5 Slack Community</a>.<br />
✔️ <em><strong>Discuss</strong></em> in the <a href="https://discuss.layer5.io">Community Forum</a>.<br />
✔️ <em><strong>Explore</strong></em> the <a href="https://layer5.io/community/handbook">Community Handbook</a>.<br />
✔️ <em><strong>Start</strong></em> with the <a href="https://layer5.io/community/newcomers">Newcomer's Guide</a>.<br />

</p>

<br clear="both" />


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

