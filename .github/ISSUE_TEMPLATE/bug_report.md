---
name: Bug report
about: Create a report to help us improve ElectroCat
title: 'fix: '
labels: 'bug'
assignees: ''

---

## Bug Description
A clear and concise description of what the bug is.

## To Reproduce
Steps to reproduce the behavior:
1. Import/load data: '...'
2. Run function/method: '...'
3. Expected vs actual output: '...'
4. See error

**Minimal code example:**
```python
# Please provide a minimal code snippet that reproduces the issue
import ecat

# Your code here that reproduces the bug
```

## Expected Behavior
A clear and concise description of what you expected to happen.

## Actual Behavior
What actually happened, including any error messages or unexpected outputs.

## Environment Information
Please complete the following information:
- **ElectroCat version:** [e.g., 0.1.0]
- **Python version:** [e.g., 3.12.1]
- **Operating System:** [e.g., Ubuntu 22.04, macOS 14.0, Windows 11]
- **Installation method:** [e.g., pip, conda, uv, from source]

**Key dependencies (if relevant):**
- ASE version: [if using ASE]
- NumPy version: [if relevant]
- Other relevant packages: [list versions]

## Input Data/Files (if applicable)
- **File format:** [e.g., VASP POSCAR, XYZ, CIF]
- **System type:** [e.g., molecular catalyst, surface, solvated system]
- **Data size:** [e.g., number of atoms, frames]

If possible, please attach or provide a link to the input files that cause the issue.

## Error Output
If applicable, paste the full error traceback:
```
Paste the complete error message and traceback here
```

## Additional Context
- Is this a regression (worked in a previous version)?
- Any workarounds you've found?
- Related to specific computational chemistry codes (VASP, CP2K, etc.)?
- Any other context about the problem

---

**Note for maintainers:** When fixing this bug, please use conventional commit format:
- `fix: <description>` for bug fixes
- `fix!: <description>` for breaking changes
- Include scope when relevant: `fix(analysis): <description>`
