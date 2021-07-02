# Purpose
This document is intended to provide information about Operational Data Standard and the Operational Data Standard Working Group to working group participants, invitees, and other interested parties. The Operational Data Standard is intended to address the lack of a standard format for representing transit schedules used by drivers, dispatchers, and planners to carry out transit operations.

# Frequently Asked Questions

## What is the Operational Data Standard?
The Operational Data Standard (ODS) is the working name for a proposed standard format to represent transit operational data. 

“Operational data” refers to everything a transit provider needs to know “behind the scenes” in order to provide service to its riders. Operational data can include the following information: 
Vehicle blocking (which vehicles run which routes),
Driver shift management (which vehicle operators work on which routes),
Vehicle shift start/end time and location (when vehicles pull in and out of service),
Non-revenue vehicle service (deadheading), and
Service disruptions.

## Why is a standard for operational data needed?
Operational data is critical for transit agencies, but currently it exists primarily in proprietary formats created and maintained by various scheduling and CAD/AVL companies. The use of proprietary formats leads to wide disparities in the experiences that agencies might have trying to create a schedule and then to utilize that schedule in a CAD/AVL software. Agencies might find that essential data for their schedules is not supported based on the combination of vendors with which they contract for service. Manual entry of schedule information that wastes agency time is all too common for such a basic element of transit service.

The availability of information in the GTFS standard format has resulted in better information being available to riders, but it has also led to innovation in features and functionality for use by transit agencies themselves. Creating a standard format for operational data will lead to similar benefits for transit agencies, who will benefit from cheaper, easier, and better scheduling functionality.

## Isn’t operational data already covered by … GTFS?
Not entirely. GTFS provides what can be thought of as a rider-centric view of transit service. By that, we mean it is built around trip (or journey) planning and the information that riders need to know to complete a trip. While GTFS contains information about where vehicles should be at specified times, most transit agencies could not determine where a specific driver or operator should be at that time using a standard GTFS feed. Critical information for operators—for example, which driver is scheduled to serve a given trip, when and where to layover, or how deadheads should be completed—is not included in GTFS at present. But just because GTFS doesn’t get us all the way there, that doesn’t mean we are planning to start from scratch: ODS is intended to work with GTFS and could ultimately be developed as an extension to GTFS.

## Isn’t operational data already covered by … NeTEx/SIRI?
Yes. The Network Timetable Exchange, or NeTEx, does cover use cases that are being considered for use in ODS. However, because NeTEx has no foothold in the North American market, a major, coordinated about-face in the industry would be required to move toward the NeTEx/SIRI schema. While NeTEx is one way to represent the operational data that makes up transit schedules, it is neither the only nor even necessarily the easiest way to do so. GTFS is the dominant standard in use for defining transit trips in North America, and research by the California Integrated Travel Project (Cal-ITP) has found that vendors favor GTFS’s flexible and simpler approach to representing transit data. Given the shifts that would need to occur within the industry to move toward NeTEx, Cal-ITP is privileging compatibility with GTFS and taking a GTFS-like approach to developing ODS.

## Isn’t operational data already covered by … TCIP?
Yes. The Transit Communications Interface Profiles (TCIP) is a standard developed by the American Public Transportation Association approximately 20 years ago to serve as a standard interface between transit systems and the individual subsystems, like scheduling and CAD/AVL, that they rely on. TCIP has never achieved significant adoption in the United States or elsewhere and has been surpassed by the popularity of the simpler and more constrained GTFS family of standards. Without adoption, development of TCIP has not kept pace with extensions and proposed extensions of GTFS, nor with broader changes in the mobility landscape as a whole. Given the shifts that would need to occur within the industry to move toward TCIP, Cal-ITP is privileging compatibility with GTFS and taking a GTFS-like approach to developing ODS.

## What is Cal-ITP?
Managed by Caltrans, the California Integrated Travel Project (Cal-ITP) is a statewide initiative designed to unify transit in California with a common fare payment system, real-time data standard, and seamless verification of eligibility for transit discounts.

## What is the ODS Working Group?
The ODS Working Group is an initiative of the California Integrated Travel Project (Cal-ITP). It is a group of stakeholders convened for the purpose of developing and adopting ODS v1.
Who is a stakeholder in the development of ODS?
Cal-ITP is looking for a cross section of the transportation industry who represent a range of companies and organizations that would be directly impacted by the creation and adoption of ODS. These stakeholders include transit schedule firms, CAD/AVL firms, public transit providers, private transit providers, local governments and metropolitan planning organizations (MPOs), labor unions, and manufacturers of integrated on-vehicle hardware solutions (such as Automated Passenger Counting (APC) devices or LED signage).

## Why is Cal-ITP leading this effort?
Cal-ITP developed the ODS initiative in response to feedback from local transit providers and vendors. As Cal-ITP has as its core a mission to improve the quality of mobility data and increase the efficiency of transportation service delivery in the state of California, we have conducted research and conversations with an eye toward identifying existing pain points. The gap that exists between scheduling software and CAD/AVL software was identified by respondents as a major source of friction. Even as GTFS has seen increasingly widespread adoption, operational data is subject to proprietary formats, overlapping use cases, and manual processes that inefficiently transfer data from one system to another. Cal-ITP’s conversations with partners have demonstrated that there is a clear desire among vendors and transit providers to come together around a standard representation of operational data built in the GTFS model.

## Is ODS going to be applicable for agencies outside of the state of California?
Yes. The working group will be focusing on solutions that meet the needs of transit providers irrespective of where they are located. While Cal-ITP is leading the initiative to develop ODS v1, it is doing so with a working group that includes major scheduling and CAD/AVL vendors in the North American market and beyond. When the ODS Working Group winds down, ownership of ODS is intended to transition to a geographically neutral organization.

## When will ODS v1 be released?
Cal-ITP intends for the working group to conclude activities before the end of 2021, coinciding with the release of ODS v1. Upon release, ODS is intended to be transferred to a neutral organization for ownership and ongoing maintenance.

## Does the development of ODS mean my company/transit agency is going to be asked to support another new spec?
The decision as to whether ODS should extend an existing specification or stand on its own will ultimately be made by the ODS Working Group as a whole. However, Cal-ITP and ODS Working Group members will take into account steps that the group can take to facilitate implementation of ODS after release/publication of ODS v1.

## How will my transit agency benefit from using ODS-supporting products?
ODS-supporting products will enable faster, more efficient and seamless data integration from your scheduling software to your CAD/AVL software. ODS will improve the quality of data in both scheduling and CAD/AVL applications by integrating them more closely together. ODS will encourage the development of more sophisticated and user-friendly tools for operators and riders by making operational data easier for application developers to parse.

## Which products or technology components should support ODS?
While the boundaries for ODS v1 will be finalized by the ODS Working Group, it is expected that a range of products and on-vehicle hardware will benefit from supporting ODS. Among these are scheduling software, service planning and analysis software, CAD/AVL software, on-board fareboxes, automated passenger counting (APC) devices, headsign and internal LED displays, and on-board public announcement (PA) or voice annunciation systems.

## How can my transit agency support ODS?
If you represent a transit agency, ask your scheduling software vendor and CAD/AVL vendor if they are participating in the ODS Working Group. Let them know that you are interested in receiving the benefits of ODS, and encourage them to begin planning to implement ODS v1 upon release at the end of 2021.

## Who should I contact for more information?
The ODS Working Group is led by Scott Frazier, Cal-ITP’s Product Manager for Operations Data. Scott can be reached via email at scott@compiler.la. 

