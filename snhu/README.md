# SNHU Security Architecture Practice — From Impossible to Possible

Proposal artifacts prepared by **Kenneth P. Barnes** for Southern New Hampshire University's Senior Security Architecture Consultant engagement (via Riptide Technologies and Global Technical Search).

The plan delivers three efforts that normally take a year or more each, together in six months, and leaves SNHU's own architects running all of them:

1. **Establish the practice**: charter, operating model, tiered review process with decision records and exception handling, principles, standards, templates, RACI, staffing model and a 12–18 month roadmap.
2. **Build the secure pattern library**: ten candidate patterns (identity and access, network segmentation, secrets and keys, data protection, logging and monitoring, PaaS integration, application hosting, secure AI and agents, privileged access, hybrid and multi-cloud), each with context, reference diagram, required controls, configuration guidance, framework alignment, IaC modules and an Azure Policy initiative.
3. **Assess and harden Azure**: landing zones, subscriptions, Azure Policy, Defender for Cloud, Entra ID, network controls and IaC, benchmarked against the Microsoft Cloud Security Benchmark, CIS Azure Foundations, the Well-Architected Framework security pillar and the Cloud Adoption Framework, with a phased remediation roadmap.

## Contents

| File | What it is |
|---|---|
| [`index.html`](index.html) | Interactive Security Architecture Command Center: roadmap, practice model, pattern library with reference diagrams and control mappings, Azure assessment plan, policy-as-code guardrails, control spine (NIST CSF 2.0, NIST SP 800-53, CIS v8, Zero Trust, FERPA, GLBA Safeguards Rule, PCI DSS), STRIDE, and the AI / AGI forward look |
| [`KBarnes_SNHU_SecurityArchitecturePractice_Deck.pptx`](KBarnes_SNHU_SecurityArchitecturePractice_Deck.pptx) | 28-slide proposal deck with speaker notes on every slide |

To view the command center, download `index.html` (Raw → save) and open it in any modern browser. It is a single self-contained file.

## Forward look

The AI / AGI section builds on this repository's [10-layer Zero Trust architecture for AI, GI and AGI systems](../README.md): every AI tutor, advisor, copilot or agent is treated as a workload with its own identity, data boundary and pattern, governed through the same control spine as everything else.

## Notes

Plans, targets and effort figures are illustrative proposals to be calibrated with SNHU during Month 1 discovery. Nothing here is SNHU data, an SNHU system or an assessment result. Track-record figures refer to Kenneth P. Barnes's prior engagements.

**Contact:** KBarnes@ucsolutions.com · [linkedin.com/in/drkennethpbarnes](https://www.linkedin.com/in/drkennethpbarnes) · [github.com/kennyb7322](https://github.com/kennyb7322)
