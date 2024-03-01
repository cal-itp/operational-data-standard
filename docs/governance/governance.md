# ODS Governance

This page outlines the policies, procedures, and structures that guide the collaborative and transparent development of the transit Operational Data Standard ("ODS"). The ODS is a critical framework enabling effective dispatching and operations management through a standardized data schema. This document is intended for all members of the ODS Community, including the ODS Board of Directors, ODS Managers, ODS Contributors, and ODS Stakeholders. By clearly defining the principles, roles, and policies, we aim to facilitate the efficient, fair, and responsible advancement of the ODS Project.

## Principles

The ODS Governance is designed with the following principles in mind:

**Merit**

- Changes should have a clear purpose.
- Consequences of a change should be evaluated from the perspective of different affected stakeholder groups.
- Changes should be prioritized by the community.

**Openness + Transparency**

- Discussion and decisions about changes should be publicly noticed and accessible.
- Change-making process should be straight-forward and easy to follow.
- Change proposals should have a reliable timeline for being decided on and incorporated.
- Each change (or bundled set of changes) should be identified by assigning a new version number.

**Efficiency**

- Change-making process should be simple for simple changes.
- Complex changes should be made with careful consideration.
- Streamlined, purpose-driven change management should be applied to maximize stakeholder efficiency .
- Changes should be straightforward to incorporate by existing ODS Stakeholders.
- Significant changes, especially those which are not backwards compatible with existing datasets, should be limited in number and in frequency in order to limit the number of times existing processes and tools need to be re-engineered.
- A significant change merits a new version number.

## Definitions

### ODS Project

The ODS Project encompasses:

- [ODS Specification](#operational-data-standard-ods-specification)
- [ODS Tools](#ods-tools)
- [ODS Repository](#ods-repository)
- [ODS Documentation](#ods-documentation)
- [ODS Governance](#ods-governance)

### ODS Governance

Who and how decisions are made about the scope and direction of the ODS Project, including but not limited to the approved [roles and responsibilities](#roles) and the following policies:

- [ODS Change Management and Versioning Policy](#ods-change-management--versioning-policy)
- [ODS Contributor Agreement](#ods-contributor-agreement)
- [ODS Code of Conduct](#ods-code-of-conduct)
- [ODS Use License](#ods-use-license)

### Operational Data Standard (ODS) Specification

The data schema documented on the [ODS Repository](#ods-repository) and [ODS Documentation](#ods-documentation) for the purposes of representing planned transit operations for use is dispatching and operations management software.

### ODS Community

The combined members of [ODS Board](#ods-board-of-directors), [ODS Manager](#ods-manager), [ODS Board Coordinator](#ods-board-coordinator), [ODS Contributors](#ods-contributor) and [ODS Stakeholders](#ods-stakeholder).

### ODS Contributor Agreement

Agreement contributors make when contributing to the [ODS Project](#ods-project) as documented at: [`CLA.md`](policies/CLA.md)

### ODS Code of Conduct

Agreement for behavior within the [ODS Community](#ods-community) which must be abided by by all of [ODS Board](#ods-board-of-directors), [ODS Contributors](#ods-contributor) and the [ODS Manager](#ods-manager) and its representatives as documented at [`code-of-conduct.md`](policies/code-of-conduct.md)

### ODS Change Management + Versioning Policy

How content of the [ODS Specification](#operational-data-standard-ods-specification) may be changed and released as an official [ODS version](policies/change-management-versioning.md#ods-release).

### ODS Documentation

The text and website (and supporting scripts) which describe the [ODS Specification](#operational-data-standard-ods-specification) and its purpose and usage located on the [ODS Repository](#ods-repository).

### ODS Repository

The version control repository containing the [ODS Specification](#operational-data-standard-ods-specification) located at:
<https://github.com/cal-itp/operational-data-standard>

### ODS Repository Organization

The version control organization which contains the [ODS Repository](#ods-repository).

!!! warning "To be migrated"

    The ODS Repository is currently located with the Cal-ITP GitHub organization but will be migrated as part of the process of transitioning management to MobilityData.

### ODS Tools

Any scripts or code released within the [ODS Repository Organization](#ods-repository-organization).

### ODS Use License

The [ODS Specification](#operational-data-standard-ods-specification) is licensed under the [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.txt) (code) and [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) (sample data, specification, and documentation) as defined in LICENSES file in the [main repository](https://github.com/cal-itp/operational-data-standard).

## Roles

Responsibility for the governance of the ODS Project is divided among the following [roles](#roles) as defined here and fulfilled by the following individuals as noted:

| **Role** | **Who** |
| -------- | ----- |
| [ODS Board](#ods-board-of-directors) | <ul><li>[Joshua Fabian](https://www.linkedin.com/in/jfabi/), [MBTA](https://www.mbta.com/</li><li>[Matthias Gruetzner](https://www.linkedin.com/in/matthias-gr%C3%BCtzner-6b469b187/), [INIT](https://www.initse.com/</li><li>Guilhem Hammel, [Giro](https://www.giro.ca/en-us/</li><li>[Erik Jensen](https://www.linkedin.com/in/erik-jensen), [WMATA](https://www.wmata.com/)</li><li>[Bradley Tollison](https://www.linkedin.com/in/bradley-t-0652a2124/), [Transdev](https://www.transdev.com/en/)</li></ul> |
| [ODS Board Coordinator](#ods-board-coordinator) | TBD |
| [ODS Manager](#ods-manager) | [MobilityData](https://mobilitydata.org) |
| [ODS Program Manager](#ods-program-manager) | [Cristhian Hellion](https://github.com/Cristhian-HA), [MobilityData](https://mobilitydata.org) |
| [ODS Contributors](#ods-contributor) |  TBD |
| [ODS Stakeholders](#ods-stakeholder) | Anyone interested in or could be directly affected by the ODS Project. |

## ODS Owner

The ODS Project is collectively owned and overseen by the [ODS Board of Directors](#ods-board-of-directors).

## ODS Board of Directors

The ODS Board of Directors ("ODS Board") governs and collectively owns the [ODS Project](#ods-project).

- The Board MAY select an individual or organization to serve as the [ODS Manager](#ods-manager) to handle the day-to-day management of the [ODS Specification](#operational-data-standard-ods-specification) and [ODS Project](#ods-project).
- The [ODS Board](#ods-board-of-directors) MUST execute a memorandum of understanding with the [ODS Manager](#ods-manager) (if one is chosen) that outlines the roles, responsibilities, and limitations of the management role.
- The [ODS Board](#ods-board-of-directors) MAY change the [ODS Manager](#ods-manager) at any time for any reason.
- In the event that there is not an active agreement with an [ODS Manager](#ods-manager) the [ODS Board](#ods-board-of-directors) MUST assume the [ODS Manager](#ods-manager) responsibilities.
- The [ODS Board](#ods-board-of-directors) SHOULD ask the [ODS Manager](#ods-manager) to select a new [ODS Program Manager](#ods-program-manager) if there is continued failure to perform and meet expectations.
- [ODS Board](#ods-board-of-directors) membership MUST be determined by the [Board Composition Policy](policies/board-composition.md).
- [ODS Board](#ods-board-of-directors) decisionmaking should be consistent with the [Board Decisionmaking Policy](policies/board-decisionmaking.md).

ODS Board [meetings](board-meetings.md) and [actions](actions.md).

## ODS Board Coordinator

Chosen by the ODS Board, this individual is responsible for coordinating the actions and activities of the [ODS Board](#ods-board-of-directors).

- The Board Coordinator MUST schedule, agendize and arrange for Board meetings in consultation with the ODS Board Chair and [ODS Program Manager](#ods-program-manager).
- The Board Coordinator MUST conduct votes by the [ODS Board](#ods-board-of-directors)and document results.
- The Board Coordinator MUST communicate with the [ODS Manager](#ods-manager)r / [ODS Program Manager](#ods-program-manager)r as needed.

## ODS Manager

Responsible for the daily management of the ODS Project at the direction of the [ODS Board](#ods-board-of-directors) including the:

- [ODS Change Management Process](policies/change-management-versioning.md),
- [ODS Repository](#ods-repository),
- ODS Project resource management, and
- Internal and external project communications.

- The [ODS Manager](#ods-manager) MAY be an individual or organization.
- The [ODS Manager](#ods-manager) MUST assign an individual as the [ODS Program Manager](#ods-program-manager).
- The [ODS Manager](#ods-manager) MUST communicate the name of the [ODS Program Manager](#ods-program-manager) to the [ODS Board](#ods-board-of-directors)in writing and notify the Board of any change in this assignment in writing.
- The [ODS Manager](#ods-manager) SHOULD select a new [ODS Program Manager](#ods-program-manager) if asked to do so by the ODS Board.

## ODS Program Manager

Serves as the main contact between the [ODS Board](#ods-board-of-directors) and the [ODS Manager](#ods-manager).

## ODS Contributor

Individuals apply to become Contributors by acknowledging and agreeing to the [ODS Contributor Agreement](#ods-contributor-agreement) and [ODS Code of Conduct](#ods-code-of-conduct).

- An ODS Contributor MUST abide by the [ODS Code of Conduct](#ods-code-of-conduct) or face removal.
- An ODS Contributor MAY create issues, discussions, and pull requests in the [ODS Repository](#ods-repository).
- An ODS Contributor MAY vote in decisions on changes to the ODS spec and other aspects of ODS.

## ODS Stakeholder

Anyone interested in or could be directly affected by the ODS Project. Interested parties may register for the [ODS distribution list](https://groups.google.com/g/ods-stakeholders).

## Document History

### Initial Version

- Initial release of the ODS Governance document.
- Establishment of governance principles, roles, policies, and procedures.
