# Quality UC

Based on the [Eclipse Tractus-X project](https://projects.eclipse.org/projects/automotive.tractusx) we provide a
technical demonstration for the Manufacturing-X Stack combining:

- Industry 4.0 Components using the Asset Administration Shell (BaSyx)
- A Data Space Protocol enabled application (Tractus-X Connector)
- A Decentralized Claims Protocol enabled application (Tractus-X Connector, mocked Credential Service)

It uses the Catena-X quality use case and applies it closer to the Catena-X digital twin and industry core pattern.
It especially ignores mass data transfers.

Spin up and run via [INSTALL.md](./deployment/INSTALL.md

## Test Data

### Digital Twins

The following table illustrates the distribution of twins and the specific asset IDs used for resistration and 
discovery.

> **NOTE**
> 
> The digital twin for the quality task ON SUPPLIER SIDE has not been created in this demonstration. It would be a 
> distributed / shared digital twin following the respective pattern of the [Digital Twin KIT](https://eclipse-tractusx.github.io/docs-kits/kits/Digital%20Twin%20Kit/Software%20Development%20View/dt-kit-interaction-patterns).


| Industry Core Pendant     | Digital Twin Car                                                                                                                                                                                              | Quality Task (OEM)                                                 | Digital Twin Control Unit                                                                                                                                                                                     | Quality Task (Supplier)                       |
|---------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| Partner                   | OEM                                                                                                                                                                                                           | OEM                                                                | Supplier                                                                                                                                                                                                      | Supplier                                      |
| Industry Core pendant     | [Part Instance](https://eclipse-tractusx.github.io/docs-kits/kits/Industry%20Core%20Kit/Software%20Development%20View/Digital%20Twins%20Development%20View%20Industry%20Core%20Kit#property-specificassetids) | unstandardized process / concept twin                              | [Part Instance](https://eclipse-tractusx.github.io/docs-kits/kits/Industry%20Core%20Kit/Software%20Development%20View/Digital%20Twins%20Development%20View%20Industry%20Core%20Kit#property-specificassetids) | unstandardized process / concept twin         |
| van                       | 3747429FGH382923974682                                                                                                                                                                                        | None (don't use)                                                   | None (don't use)                                                                                                                                                                                              | None (don't use)                              |
| globalAssetId / catenaxId | urn:uuid:580d3adf-1981-44a0-a214-13d6ceed9379                                                                                                                                                                 | urn:uuid:c5162db2-57ab-4728-a02a-7831be99d95b                      | urn:uuid:c5162db2-57ab-4728-a02a-7831be99d95b                                                                                                                                                                 | urn:uuid:430f56d3-1234-1234-1234-efab12341234 |
| manufacturerId            | BPNL4444444444XX (customerBPNL)                                                                                                                                                                               | BPNL1234567890ZZ (= supplierBPNL)                                  | BPNL1234567890ZZ (= supplierBPNL)                                                                                                                                                                             | BPNL1234567890ZZ (supplierBPNL)               |
| manufacturerPartId        | 689-G8                                                                                                                                                                                                        | ECU-2025.02                                                        | ECU-2025.02                                                                                                                                                                                                   | ECU20646005020221                             |
| customerPartId            | None (don't use)                                                                                                                                                                                              | ECU4711                                                            | ECU4711                                                                                                                                                                                                       | ECU4711                                       |
| partInstanceId            | 3747429FGH382923974682 (= van)                                                                                                                                                                                | ECU20646005020221                                                  | ECU20646005020221                                                                                                                                                                                             | ECU20646005020221 (= partInstanceId)          |
| intrinsicId               | 3747429FGH382923974682 (= van)                                                                                                                                                                                | ECU20646005020221 (= partInstanceId)                               | ECU20646005020221                                                                                                                                                                                             | ECU20646005020221 (= manufacturerPartId)      |
| digitalTwinType           | PartInstance                                                                                                                                                                                                  | QualityTask                                                        | PartInstance                                                                                                                                                                                                  | QualityTask                                   |
| qualityTaskId             | None                                                                                                                                                                                                          | urn:uuid:e16460c0-c351-4de2-91a8-99518445f468 (to be searched for) | None                                                                                                                                                                                                          | None                                          |

### Semantic Models

The following smenatic models are created for the digital twins.

| Partner  | semanticId with link                                                                                                                           | Digital Twin |
|----------|------------------------------------------------------------------------------------------------------------------------------------------------|--------------|
| OEM      | [urn:samm:io.catenax.quality_task:2.0.0](https://github.com/eclipse-tractusx/sldt-semantic-models/tree/main/io.catenax.quality_task/2.0.0)     | Quality Task |
| OEM      | [urn:samm:io.catenax.fleet.vehicles:3.0.0](https://github.com/eclipse-tractusx/sldt-semantic-models/tree/main/io.catenax.fleet.vehicles/3.0.0) | CAR          |
| OEM      | [urn:samm:io.catenax.fleet.vehicles:3.0.0](https://github.com/eclipse-tractusx/sldt-semantic-models/tree/main/io.catenax.fleet.vehicles/3.0.0) | Quality Task |
| Supplier | [urn:samm:io.catenax.manufactured_parts_quality_analysis:2.1.0](https://github.com/eclipse-tractusx/sldt-semantic-models/tree/main/io.catenax.manufactured_parts_quality_information/2.1.0)                                                                               | Control Unit   |

Note other models are not used as it's only a tech demo. The Industry Core Models would be suitable for master data.

### Partners

The following lists give an overview about the partners used in the demonstration.

#### OEM

Overall the customer has the following information:

- BPNL: BPNL4444444444XX
- Name: Car Manufacturer
- Site
    - BPNS: BPNS4444444444XX
    - Site Name: Production Site
    - Site Address:
        - BPNA: BPNA4444444444AA
        - Street and Number: 13th Street 47
        - Zip Code, City: 10011 New York
        - Country: USA

#### Supplier

Overall the supplier has the following information:

- BPNL: BPNL1234567890ZZ
- Name: Control Unit Supplier
- Site 1
    - BPNS: BPNS1234567890ZZ
    - Site Name: Production Site
    - Site Address:
        - BPNA: BPNA1234567890AA
        - Street and Number: Wall Street 101
        - Zip Code, City: 10001 New York
        - Country: USA

## Potential Enhancements

- [ ] Add digital twin for supplier's quality task.
- [ ] If Identity Hub works, we can try it out, too.
- [ ] Add notifications.

## NOTICE

This work is licensed under the [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0).

- SPDX-License-Identifier: Apache-2.0
- SPDX-FileCopyrightText: 2025 Fraunhofer ISST, Fraunhofer Institute for Software and Systems Engineering
- Source URL: https://github.com/FraunhoferISST/Quality-Use-Case-Demonstration