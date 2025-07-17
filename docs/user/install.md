# Installation 🔧

**ElectroCat** is tested with `python 3.12.9` and works well inside a `conda` or `uv` environment.

## 1. Clone the repository

```bash
git clone https://github.com/skethirajan/electrocat.git
cd electrocat
```

## 2. Create dev environment

[Makefile](https://github.com/skethirajan/ElectroCat/blob/main/Makefile) is provided to create a nested Conda + `uv` environment for development.

```bash
make create-conda
conda activate ecat
make setup-dev
```

## 3. Build the docs

To build the documentation, we make use of `mkdocs` and `mkdocs-material`. Documentation will be live at `http://localhost:8000`

```bash
make docs-serve
```
