## Usage

The typical setup for install-postgres-client involves adding a job step using `DFE-Digital/github-actions/install-postgres-client@master`.

      - name: install-postgres-client
        uses: DFE-Digital/github-actions/install-postgres-client@master

```diff
name: Main

on: push

jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
+     - name: install-postgres-client
+       uses: DFE-Digital/github-actions/install-postgres-client@master
```

### Version

You can also specify a particular version of the Postgres Client (defaults to `11`) with `jobs.<job_id>.steps.with.version`.

```diff
name: Main

on: push

jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
+     - name: install-postgres-client
+       uses: DFE-Digital/github-actions/install-postgres-client@master
+       with:
+         version: '12'
```

See [https://www.postgresql.org/download/linux/ubuntu/](https://www.postgresql.org/download/linux/ubuntu/) for a list of supported versions
