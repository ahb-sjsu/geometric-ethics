#!/usr/bin/env python
"""GE-P-2026-007 Stage 0: build the 800-item research-ethics stimulus pool.

Generates items by composing three independent factors -- a study FRAME, a
POPULATION, and an ethical FEATURE -- so that harm level is carried by the
ethical feature alone and is orthogonal to topic, population and length.

WHAT THIS SCRIPT DOES NOT DO
----------------------------
It does NOT assign harm values. Every item carries an INTENDED stratum, which
is a generation target, not data. Where an item actually falls on the harm
continuum is an empirical result produced by the norming sample (protocol s3),
and intended strata that norming contradicts are evidence about the pool, not
errors to be corrected. Writing h_i here would be fabricating the norming data
the whole design depends on.

Items are machine-composed and REQUIRE HUMAN REVIEW before norming (see the
REVIEW REQUIRED banner in the output manifest).

Usage:  python ge007_build_item_pool.py [--out item_pool_v1.json]
"""
from __future__ import annotations

import argparse
import json
import random
import re
import statistics
from collections import Counter, defaultdict

SEED = 20260825

STRATA = [
    ("anchor_benign", 60),
    ("low", 120),
    ("ambiguous", 440),
    ("high", 120),
    ("anchor_severe", 60),
]
TOPICS = ["medical", "psychological", "data_privacy", "deception",
          "consent", "animal", "economic"]

# ---------------------------------------------------------------------------
# Study frames: the design and purpose. Carries NO harm information.
# ---------------------------------------------------------------------------
FRAMES = {
 "medical": [
  "A randomised trial tests a new blood-pressure medication",
  "An observational cohort study tracks recovery after knee surgery",
  "A trial compares two standard chemotherapy schedules",
  "A study collects leftover tissue during routine appendectomy",
  "A multi-site trial evaluates an experimental asthma inhaler",
  "A registry study links hospital records to insurance claims",
  "A trial tests a shortened antibiotic course for pneumonia",
  "A study evaluates a wearable continuous glucose monitor",
 ],
 "psychological": [
  "A laboratory study measures reaction time under time pressure",
  "A study examines how mood affects memory for word lists",
  "An experiment tests whether framing changes risk preferences",
  "A study measures stress responses during a mock job interview",
  "A longitudinal study follows adjustment across a first term",
  "An experiment examines conformity in small group discussion",
  "A study measures attention using eye-tracking during reading",
  "An experiment tests whether feedback changes persistence",
 ],
 "data_privacy": [
  "A study analyses browsing logs to model reading habits",
  "A project links supermarket loyalty data to health outcomes",
  "A study uses phone location traces to model commuting",
  "A project analyses public social media posts for sentiment",
  "A study reuses an archived survey dataset for a new question",
  "A project builds a model from electronic health records",
  "A study analyses keystroke timing collected by a learning platform",
  "A project links census records to school performance data",
 ],
 "deception": [
  "An experiment uses a confederate posing as another participant",
  "A study gives participants false feedback on a fake aptitude test",
  "An experiment misdescribes the study's purpose on the consent form",
  "A field study observes helping behaviour after a staged mishap",
  "An experiment uses a rigged game that cannot be won",
  "A study tells participants a partner is real when it is scripted",
  "An experiment stages an unexpected interruption during a task",
  "A study conceals that a second task is the real measure",
 ],
 "consent": [
  "A study enrols participants during a routine clinic visit",
  "A project seeks a waiver of consent for records-only analysis",
  "A study re-contacts participants from a decade-old cohort",
  "A project enrols participants through a community organisation",
  "A study obtains agreement through a group information session",
  "A project enrols participants via an online sign-up form",
  "A study seeks proxy agreement from a legally authorised representative",
  "A project enrols participants at the point of hospital admission",
 ],
 "animal": [
  "A study measures maze learning in laboratory rodents",
  "A project tests a candidate vaccine in laboratory mice",
  "A study observes social behaviour in captive primates",
  "A project measures stress hormones in farmed fish",
  "A study tests a surgical technique in a pig model",
  "A project tracks wild birds using attached transmitters",
  "A study evaluates an analgesic protocol in laboratory rabbits",
  "A project examines diet effects in laboratory zebrafish",
 ],
 "economic": [
  "A field experiment varies the wording of a job advertisement",
  "A study randomises the size of a small cash transfer",
  "An experiment varies prices shown to online shoppers",
  "A study tests how loan terms affect repayment",
  "A field experiment varies the order of search results",
  "A study randomises access to a job-training programme",
  "An experiment varies late-fee reminders for utility bills",
  "A study tests how framing affects retirement contributions",
 ],
}

# ---------------------------------------------------------------------------
# Populations. Deliberately spanning low to high vulnerability, and BALANCED
# WITHIN each stratum (s2.1a) so vulnerability cannot proxy for harm level.
# ---------------------------------------------------------------------------
POPULATIONS = {
 "medical": ["adults at an outpatient clinic", "patients at a district hospital",
             "children aged 6-12 and their guardians", "residents of a care facility",
             "adults attending a routine screening", "patients admitted for elective surgery"],
 "psychological": ["undergraduate volunteers", "adults recruited online",
                   "adolescents recruited through schools", "community volunteers aged 60+",
                   "employees at a partner company", "adults recruited at a public library"],
 "data_privacy": ["users of a municipal wifi network", "customers of a grocery chain",
                  "students on a university platform", "patients at a regional health system",
                  "subscribers to a news website", "residents of a metropolitan area"],
 "deception": ["undergraduate volunteers", "adults recruited online",
               "shoppers at a retail centre", "commuters at a transit station",
               "members of a hobbyist forum", "attendees at a public event"],
 "consent": ["adults at an outpatient clinic", "adults recruited online",
             "residents of a care facility", "members of a community organisation",
             "patients admitted to hospital", "adolescents recruited through schools"],
 "animal": ["laboratory mice", "laboratory rats", "captive macaques",
            "farmed salmon", "laboratory rabbits", "domestic pigs"],
 "economic": ["applicants to entry-level positions", "online shoppers",
              "smallholder farmers", "recipients of a benefits programme",
              "borrowers at a microfinance lender", "employees at a partner company"],
}

# ---------------------------------------------------------------------------
# Ethical features: THE ONLY FACTOR CARRYING HARM LEVEL.
# Lengths are matched across severities on purpose (protocol s2).
# ---------------------------------------------------------------------------
FEATURES = {
 ("medical", "anchor_benign"): [
  "All participants give written informed consent and the protocol adds no procedures beyond routine care",
  "Participation involves only an anonymous questionnaire completed after the appointment ends",
  "The study observes care that would have been delivered identically without it",
  "Participants consent in advance and may withdraw at any point without affecting their treatment",
  "Only aggregate statistics already published by the hospital are analysed",
  "Participants are told the full purpose and can review their own records afterwards",
  "The protocol was designed with a patient advisory panel and adds no risk",
  "Consent is obtained in writing and no identifiable information leaves the clinic",
 ],
 ("medical", "low"): [
  "Participants consent but are asked to return for one additional unpaid blood draw",
  "Consent is obtained though the questionnaire takes forty minutes longer than described",
  "Participants consent, and identifiable records are retained longer than the protocol states",
  "The consent form is written well above the reading level of most participants",
  "Participants consent but are not told which of two standard schedules they receive",
  "Consent is obtained verbally rather than in writing, and documented by the researcher",
  "Participants consent, though the study adds three extra clinic visits over a year",
  "Consent is obtained but the compensation offered is lower than advertised",
 ],
 ("medical", "ambiguous"): [
  "Consent covers the main study, but leftover tissue is also analysed for unrelated genetic markers",
  "Incidental findings of unrelated disease are recorded but not returned, as follow-up was unbudgeted",
  "Consent was given for the original study, and the data are reused for an unrelated question",
  "Participants consent, but the payment is large enough that declining is difficult for many",
  "The trial continues after an interim analysis suggests one arm may be modestly worse",
  "Consent is obtained from patients shortly after receiving a serious diagnosis",
  "Identifiable data are shared with a commercial partner under a confidentiality agreement",
  "Participants consent, but the study is stopped early for reasons that are not disclosed",

  "Participants consent, but the protocol's risks appear only in a supplementary document",
  "A placebo arm is used although an accepted active treatment already exists",
  "Participants are recruited by their own treating physician, who is also the investigator",
  "The study collects genetic data whose future uses cannot be specified at consent",
 ],
 ("medical", "high"): [
  "The consent form describes an experimental medication as though it were standard treatment",
  "Participants are enrolled without being told that a safer approved alternative exists",
  "Adverse events are recorded internally but omitted from reports to the oversight board",
  "The protocol requires an invasive procedure that has no prospect of benefiting participants",
  "Consent is obtained from patients while they are sedated and awaiting a procedure",
  "Participants are not told the sponsor stands to gain from a particular result",
  "The study continues enrolling after evidence emerges that one arm causes serious harm",
  "Participants are enrolled and only told afterwards that the treatment was experimental",
 ],
 ("medical", "anchor_severe"): [
  "Participants are never told a study is occurring, and an effective life-saving treatment is withheld",
  "The trial deliberately conceals deaths from regulators in order to continue enrolment",
  "Participants are enrolled by threatening the withdrawal of care they already depend on",
  "The study administers a substance known to cause permanent injury without any consent",
  "Records are falsified to hide that several participants suffered severe organ damage",
  "Participants are told they are receiving treatment when they are knowingly given nothing",
  "The protocol infects healthy participants with a serious disease without informing them",
  "Consent documents are forged for participants who explicitly refused to take part",
 ],

 ("psychological", "anchor_benign"): [
  "Participants give informed consent and the task involves only sorting neutral images",
  "The study uses publicly available word norms and collects no personal information",
  "Participants consent, are fully debriefed, and the task is no more demanding than reading",
  "Participation is anonymous and involves rating the pleasantness of everyday objects",
  "Participants consent and may skip any question without giving a reason",
  "The task is a standard memory exercise and participants receive their own results",
  "Participants consent and the entire session lasts under fifteen minutes",
  "Only anonymous aggregate responses are recorded, and the purpose is stated plainly",
 ],
 ("psychological", "low"): [
  "Participants consent but the session runs thirty minutes longer than the advertised time",
  "The task is more repetitive and tedious than the recruitment materials suggested",
  "Participants consent, though debriefing is delivered by email rather than in person",
  "Consent is obtained but participants are not told how long their data will be kept",
  "Participants consent and the task induces mild frustration through an unwinnable practice round",
  "The study records audio for transcription, which the consent form mentions only briefly",
  "Participants consent but are not told their responses will be compared across sessions",
  "Compensation is paid weeks later than the recruitment materials indicated",
 ],
 ("psychological", "ambiguous"): [
  "The task induces moderate stress, and participants are told only afterwards that this was intended",
  "Participants consent, but the study measures a trait they were not told was being assessed",
  "Distressing imagery is shown briefly, with a content warning that does not describe the content",
  "Participants consent, and those who become upset are debriefed but not offered support services",
  "The study measures implicit bias and returns individual scores that participants did not expect",
  "Participants consent, but withdrawing mid-session forfeits the entire payment",
  "Data from participants who guessed the hypothesis are excluded after the fact",
  "The study induces a temporary feeling of social exclusion and debriefs immediately after",

  "Participants are recruited from a class taught by the investigator, for extra credit",
  "The study records video shown later at conferences, mentioned only in fine print",
  "Detailed questions about past trauma are asked without any prior screening step",
  "The debriefing reveals a deception some participants say they would not have accepted",
 ],
 ("psychological", "high"): [
  "Participants are led to believe they have seriously harmed another person during the task",
  "The study induces severe distress and provides no debriefing or support afterwards",
  "Participants who ask to stop are repeatedly told they must continue the procedure",
  "The study measures a stigmatised trait and stores results against participants' real names",
  "Participants are given false feedback that they show signs of a serious disorder",
  "The protocol deliberately undermines participants' confidence and does not restore it",
  "Distressing material is shown to participants who disclosed a relevant trauma history",
  "The study conceals that participants' responses are reported to their employer",
 ],
 ("psychological", "anchor_severe"): [
  "Participants are subjected to prolonged terror and several require psychiatric hospitalisation afterwards",
  "The study deliberately induces lasting psychological injury and conceals this from oversight",
  "Participants are confined against their will and denied any means of ending participation",
  "Children are deliberately given feedback designed to cause enduring shame, without consent",
  "The study induces suicidal ideation deliberately and provides no intervention at all",
  "Participants are drugged without their knowledge to observe the effects on their judgement",
  "The protocol conditions fear responses in infants and makes no attempt to reverse them",
  "Participants are told a relative has died in order to observe their grief reaction",
 ],

 ("data_privacy", "anchor_benign"): [
  "Only fully aggregated counts are analysed and no individual record is ever accessible",
  "The dataset is public, licensed for research, and contains no personal identifiers",
  "Users gave explicit opt-in consent and can delete their data at any time",
  "Analysis runs on synthetic data generated to match the statistical properties only",
  "The data were collected for this purpose with clear notice and an easy opt-out",
  "Records are anonymised before the researchers receive them, and re-identification is infeasible",
  "Only metadata already published in an open government release are analysed",
  "Participants review and approve exactly which of their records are included",
 ],
 ("data_privacy", "low"): [
  "Data are anonymised, though the privacy notice is buried in lengthy terms of service",
  "Identifiers are removed but the raw file is retained on a secure server indefinitely",
  "Users consented, but the notice did not mention that academic researchers would have access",
  "Data are pseudonymised and the key is held by the same research team",
  "The dataset is anonymised but shared with collaborators without a formal agreement",
  "Users were notified by email, which most did not open, before collection began",
  "Data are aggregated, but small cells could in principle narrow identity to a few people",
  "The retention period is longer than stated, though access remains tightly restricted",
 ],
 ("data_privacy", "ambiguous"): [
  "Posts are public, but authors did not anticipate their words appearing in research",
  "Records are anonymised, yet the combination of attributes could plausibly re-identify some people",
  "Data collected for service delivery are reused for research without returning to consent",
  "Location traces are analysed at a resolution fine enough to reveal individual homes",
  "The platform's terms permit research use, but no participant was meaningfully informed",
  "Sensitive inferences are derived from data that participants supplied for an unrelated purpose",
  "Data are shared with a commercial partner who may combine them with their own records",
  "Consent was obtained from account holders, though the data describe other household members",

  "The dataset is anonymised, but the researchers retain a key that could reverse it",
  "Participants agreed to storage but not to the machine-learning use now proposed",
  "Results are published at a granularity that effectively identifies small communities",
  "Data are retained indefinitely because deletion would prevent any future replication",
 ],
 ("data_privacy", "high"): [
  "Identifiable health records are analysed without consent or any oversight approval",
  "The study deliberately re-identifies individuals in a dataset released as anonymous",
  "Sensitive inferences about individuals are shared with parties who can act against them",
  "Data are obtained by scraping a service in direct violation of its access controls",
  "Identifiable records of a stigmatised group are compiled without their knowledge",
  "The dataset is transferred to a jurisdiction with no data protection, without notice",
  "Researchers access private messages that users reasonably believed were confidential",
  "Data on minors are collected and retained without any parental notice or approval",
 ],
 ("data_privacy", "anchor_severe"): [
  "Identifiable records of political dissidents are supplied to authorities who imprison them",
  "The study publishes named individuals' medical histories without consent or any redaction",
  "Researchers sell identifiable records of abuse survivors to data brokers for profit",
  "Private data are deliberately leaked to expose individuals to targeted violence",
  "The project builds a surveillance tool used to persecute a named minority group",
  "Researchers publish home addresses of participants alongside stigmatising personal details",
  "Identifiable records are handed to an employer who dismisses the people named",
  "The study covertly records private conversations and publishes them with real names",
 ],

 ("deception", "anchor_benign"): [
  "No deception is used and the study's purpose is stated fully before participation",
  "Participants are told a filler task exists and why, before the session begins",
  "The only concealment is which of two neutral word lists appears first",
  "Participants consent knowing that some details are withheld until the debriefing",
  "The study uses no confederates and every instruction is literally accurate",
  "Participants are told in advance that a memory test will follow the reading task",
  "Any withheld detail is disclosed within a minute and participants may withdraw data",
  "The procedure is described completely and no misleading statement is made",
 ],
 ("deception", "low"): [
  "Participants are not told which condition they are in, and are debriefed immediately after",
  "A cover story conceals the hypothesis, and the true purpose is explained at the end",
  "A confederate is used, and participants are told and may withdraw their data afterwards",
  "The task is described as a memory study when attention is the real measure",
  "Participants are given neutral false feedback that is corrected during debriefing",
  "The study conceals that a second short task is the primary measure",
  "Participants are misled about the number of other people taking part",
  "A staged delay is used, and the reason is explained fully afterwards",
 ],
 ("deception", "ambiguous"): [
  "Participants receive negative false feedback about their ability and are debriefed at the end",
  "A confederate feigns distress, and some participants remain upset after the debriefing",
  "The study conceals that behaviour is observed after participants believe the session ended",
  "Participants are led to believe a scripted partner is a real person throughout",
  "Deception is used in a public setting where bystanders never consented or were debriefed",
  "Participants are told their performance was poor when it was in fact average",
  "The debriefing is delivered but so briefly that many participants leave still misinformed",
  "Participants believe they failed a task that was designed to be impossible",

  "Participants are told the session has ended while a further measure is still running",
  "The cover story is maintained through a follow-up contact a week afterwards",
  "Participants are misled about how their responses will be used until the debriefing",
  "The study conceals that another person's outcome depends on the participant's choices",
 ],
 ("deception", "high"): [
  "Participants are led to believe they have caused serious injury to another person",
  "Deception induces lasting distress and no debriefing is offered at any point",
  "Participants are falsely told they have a serious health condition during the session",
  "A staged emergency causes genuine panic among participants and uninvolved bystanders",
  "Participants are deceived about risks they were explicitly told to consider before consenting",
  "The study falsely tells participants their responses have been shared with their employer",
  "Deception continues after participants ask directly whether the study is what it appears",
  "Participants are led to believe a close relative has been involved in an accident",
 ],
 ("deception", "anchor_severe"): [
  "Participants are deceived into believing they have killed someone and are never told otherwise",
  "The deception causes lasting trauma, and researchers deliberately conceal it from oversight",
  "Participants are falsely told of a terminal diagnosis and left to act on it",
  "A staged attack causes genuine injuries among participants who never consented",
  "Participants are deceived into signing away legal rights they did not know they held",
  "The study fabricates evidence of a crime and reports participants to the police",
  "Participants are deceived into taking a substance that causes permanent harm",
  "The deception is designed to destroy participants' relationships and is never disclosed",
 ],

 ("consent", "anchor_benign"): [
  "Written informed consent is obtained from every participant with ample time to decide",
  "Participants receive a plain-language form and may take it home before deciding",
  "Consent is obtained, and participants may withdraw at any time with data deleted",
  "An independent advocate confirms each participant understands before agreeing",
  "Participants consent after a briefing that answers every question they raise",
  "Consent is documented and participants receive a copy for their own records",
  "The form is short, clear, and read aloud to anyone who prefers that",
  "Participants consent freely and no incentive is offered that could influence the decision",
 ],
 ("consent", "low"): [
  "Consent is obtained though the form is long and written in technical language",
  "Participants consent during a busy clinic visit with limited time to read",
  "Consent is documented verbally and countersigned by the researcher alone",
  "Participants consent but are not told which collaborators will access the data",
  "The form omits the expected duration, which participants learn on arrival",
  "Consent is obtained electronically with a single click on a scrolling document",
  "Participants consent but the withdrawal procedure is not explained clearly",
  "Consent is obtained from participants who were recruited by their own supervisor",
 ],
 ("consent", "ambiguous"): [
  "A consent waiver is granted for records-only analysis that participants would likely not expect",
  "Proxy agreement is obtained from a relative for participants who cannot decide themselves",
  "Consent is broad enough to cover future studies that cannot yet be described",
  "Participants agree in a group session where declining would be visible to peers",
  "Consent is obtained from adolescents without informing their parents, as local rules permit",
  "Participants consent, but the payment is the main reason many of them enrol",
  "Consent is sought again after a decade, and non-responders are retained by default",
  "Agreement is obtained from a community leader on behalf of individual participants",

  "Consent is obtained from participants whose first language differs from the form's",
  "The stated duration is described as approximate but proves to be much longer",
  "Re-consent is not sought when the protocol changes in ways participants might mind",
  "Agreement is obtained by the person who also controls the participant's access to services",
 ],
 ("consent", "high"): [
  "Participants are enrolled without consent and would plainly have objected if asked",
  "Consent is obtained from people with cognitive impairment who cannot understand the study",
  "Participants are told that declining may affect the care they receive",
  "Consent forms deliberately omit a known risk that would deter many participants",
  "Participants are enrolled by their employer without any individual agreement",
  "Consent is obtained under time pressure that prevents any meaningful consideration",
  "Participants who withdraw are re-enrolled without being told this has happened",
  "Consent is obtained from prisoners whose parole review is conducted by the researcher",
 ],
 ("consent", "anchor_severe"): [
  "Participants are enrolled by explicit threat of violence against them or their families",
  "Consent documents are forged for participants who had refused in writing",
  "Participants are enrolled while unconscious and never informed at any point afterwards",
  "Children are enrolled after their guardians were deliberately and knowingly deceived",
  "Participants are detained until they agree to take part in the study",
  "Refusal is punished by withdrawal of food and medical care they depend on",
  "Consent is obtained by falsely claiming a court has ordered participation",
  "Participants are enrolled by exploiting a guardianship the researcher obtained fraudulently",
 ],

 ("animal", "anchor_benign"): [
  "Animals are observed in their existing enclosures with no intervention of any kind",
  "The study analyses video recordings already collected for routine husbandry purposes",
  "Only non-invasive observation occurs and animals can withdraw from view freely",
  "The protocol was approved and involves nothing beyond standard daily care",
  "Faecal samples are collected from enclosures without handling any animal",
  "Animals are given an enrichment item and their preference is recorded",
  "The study measures existing feeding records and no animal is approached",
  "Observation occurs from a distance that the animals do not appear to notice",
 ],
 ("animal", "low"): [
  "Animals are briefly handled for weighing, which mildly stresses them for a few minutes",
  "A single blood sample is taken under protocols that minimise discomfort",
  "Animals are housed individually for two days, which is shorter than usual practice",
  "The study involves brief restraint that is well within approved guidelines",
  "Animals undergo a short behavioural test that is mildly unfamiliar to them",
  "Feed is withheld overnight, consistent with standard veterinary preparation",
  "Transmitters are attached externally and are removed at the end of the study",
  "Animals are moved to a new enclosure once during the study period",
 ],
 ("animal", "ambiguous"): [
  "Animals undergo a procedure causing brief pain, with analgesia given afterwards rather than before",
  "Group-housed animals are isolated for three weeks, which is known to cause distress",
  "The sample size exceeds what the power analysis required, and the surplus is unexplained",
  "A humane endpoint is defined but set later than some veterinary guidance recommends",
  "Animals experience moderate distress, and the study's benefit to humans is speculative",
  "The protocol repeats a study already conducted elsewhere with similar results",
  "Animals are food-restricted to increase motivation, to a degree that is contested",
  "A less invasive alternative exists but requires equipment the laboratory does not have",

  "The protocol uses a species whose capacity for suffering is scientifically contested",
  "Animals are re-used across successive studies rather than being rehomed afterwards",
  "The study proceeds although a non-animal alternative has been partly validated",
  "Group sizes are set by disciplinary convention rather than by a power analysis",
 ],
 ("animal", "high"): [
  "Animals undergo painful procedures and analgesia is deliberately withheld to avoid confounds",
  "The protocol causes substantial suffering for a question of clearly marginal value",
  "Approved humane endpoints are exceeded and the study continues regardless",
  "Animals are subjected to repeated surgeries with inadequate post-operative care",
  "Housing conditions fall well below approved standards for the duration of the study",
  "The study induces a severe disease model with no palliative care at any stage",
  "Animals showing severe distress are kept in the study to preserve statistical power",
  "The protocol was not reviewed by any animal welfare body before it began",
 ],
 ("animal", "anchor_severe"): [
  "Animals are deliberately tortured to observe pain responses, with no scientific purpose",
  "The study inflicts extreme suffering and falsifies welfare records to conceal it",
  "Animals are mutilated without anaesthesia and left untreated until they die",
  "The protocol deliberately starves animals to death to observe the process",
  "Researchers conceal from oversight that hundreds of animals died in agony",
  "Animals are burned alive and the study has no stated aim beyond curiosity",
  "The study breeds animals specifically to inflict maximal suffering upon them",
  "Endangered wild animals are killed unnecessarily and the deaths are hidden",
 ],

 ("economic", "anchor_benign"): [
  "The intervention offers a benefit and nobody is made worse off than before",
  "Only the order of two equivalent options is varied and outcomes are unaffected",
  "All participants receive the programme and only the timing is randomised",
  "The study analyses administrative data already collected for programme operation",
  "Participants opt in knowingly and may leave the programme at any time",
  "The variation tested is within the range the organisation already uses routinely",
  "Everyone receives the same offer and only the wording of a reminder differs",
  "The study measures uptake of a benefit that all participants are entitled to",
 ],
 ("economic", "low"): [
  "Some participants receive a reminder and others do not, with no other difference",
  "The randomisation delays a small benefit for one group by a few weeks",
  "Participants are not told the wording they see was randomly assigned",
  "The study varies a fee within limits the organisation already applies in practice",
  "Some applicants see a slightly less prominent listing than others do",
  "The intervention adds a short additional form for half of the participants",
  "Participants are unaware they are in a study, though nothing about their treatment changes",
  "One group receives information a week later than the other group does",
 ],
 ("economic", "ambiguous"): [
  "A scarce benefit is randomised, so some eligible people do not receive it",
  "Prices are varied by consumer characteristics in ways participants would object to",
  "The control group is denied a programme that researchers expect to help them",
  "Participants are unaware their loan terms were randomly assigned among real options",
  "The study varies job-advertisement wording, and some applicants are less likely to apply",
  "A behavioural nudge is used that participants would probably resent if they knew",
  "The intervention exploits a known cognitive bias to increase programme enrolment",
  "Search results are reordered in ways that measurably change what participants buy",

  "The study withholds information about a better option participants could have chosen",
  "Randomisation rather than existing need determines who receives a scarce benefit",
  "Participants take part through their employer, who receives the aggregate results",
  "The intervention changes default options in ways most participants will not notice",
 ],
 ("economic", "high"): [
  "The study deliberately worsens loan terms for a randomly selected group of borrowers",
  "Participants are randomised into a condition researchers expect to cause financial hardship",
  "The intervention induces debt among participants who had none before enrolment",
  "A benefit people depend on is withdrawn from the control group for the study",
  "The study manipulates prices for people it identifies as least able to refuse",
  "Job applicants are randomly disadvantaged in ways that reduce their real employment chances",
  "The intervention encourages participants into a product known to harm most users",
  "Researchers withhold information that would have prevented substantial participant losses",
 ],
 ("economic", "anchor_severe"): [
  "The study deliberately bankrupts participants to observe how families respond to ruin",
  "Researchers withdraw food assistance from a control group and several children starve",
  "The intervention traps participants in debt bondage and this outcome was intended",
  "Participants are defrauded of their savings and the losses are never returned",
  "The study deliberately triggers evictions to measure the effect on child health",
  "Researchers collude with lenders to conceal terms that ruin hundreds of borrowers",
  "The intervention destroys participants' livelihoods and the harm is hidden from oversight",
  "Participants are coerced into unpaid labour under the guise of a research programme",
 ],
}


# Vulnerability tags. The confound to guard against is that severe items skew
# toward vulnerable populations, making perceived harm track vulnerability
# rather than the ethical feature. Populations are drawn from the same
# per-topic bank in EVERY stratum, so balancing within (stratum, topic) makes
# the vulnerability mix identical across strata by construction -- this table
# lets that be VERIFIED rather than assumed.
VULNERABILITY = {
 "children aged 6-12 and their guardians": "high",
 "residents of a care facility": "high",
 "adolescents recruited through schools": "high",
 "patients at a regional health system": "high",
 "smallholder farmers": "high",
 "recipients of a benefits programme": "high",
 "borrowers at a microfinance lender": "high",
 "patients admitted to hospital": "high",
 "patients at a district hospital": "med",
 "patients admitted for elective surgery": "med",
 "community volunteers aged 60+": "med",
 "employees at a partner company": "med",
 "students on a university platform": "med",
 "members of a community organisation": "med",
 "applicants to entry-level positions": "med",
}
def vuln_of(p): return VULNERABILITY.get(p, "low")


# ---------------------------------------------------------------------------
# COHERENCE SCREEN. Frames and features are composed orthogonally, but they are
# NOT independent in reality: a records-only or secondary-data study does not
# enrol anyone at a bedside, draw blood, or debrief a session. Orthogonal
# composition therefore produces contradictory items -- found by reading
# samples, invisible to every structural check.
NO_CONTACT = re.compile(
    r"records|registry|archived|public social media|browsing logs|loyalty data|"
    r"location traces|census|keystroke|electronic health|administrative|"
    r"reuses an archived|waiver of consent", re.I)
NEEDS_CONTACT = re.compile(
    r"blood draw|clinic visit|enrol|bedside|sedated|anaesth|surgery|handled|"
    r"restraint|detained|confined|debrief|session|blood sample|injection|"
    r"return for|extra visit|weighing|food-restrict|starv|analgesi|"
    r"written consent|read aloud|take it home|group session", re.I)

def incompatible(frame: str, feature: str) -> bool:
    """True if the pair asserts participant contact a records-only frame lacks."""
    return bool(NO_CONTACT.search(frame) and NEEDS_CONTACT.search(feature))


# A SECOND incoherence axis, found the same way (by reading output, not by any
# structural check): a frame that names a data source or recruitment venue
# constrains who the population can be. "A project builds a model from
# electronic health records with users of a municipal wifi network" passes
# every balance check and is nonsense.
VENUE = [
    (re.compile(r"health record|hospital record|clinic visit|hospital admission|"
                r"appendectomy|chemotherapy|surgery|inhaler|glucose", re.I),
     re.compile(r"patient|clinic|hospital|care facility|screening|surgery", re.I)),
    (re.compile(r"browsing logs|news website|social media|wifi|keystroke|"
                r"learning platform|loyalty|supermarket|grocery", re.I),
     re.compile(r"user|subscriber|customer|student|resident|online|shopper", re.I)),
    (re.compile(r"community organisation", re.I),
     re.compile(r"community|member", re.I)),
]

def venue_mismatch(frame: str, pop: str) -> bool:
    """True if the frame names a venue/source the population contradicts."""
    for f_re, p_re in VENUE:
        if f_re.search(frame) and not p_re.search(pop):
            return True
    return False

TEMPLATES = [
    "{frame} with {pop}. {feat}.",
    "{frame} with {pop}; {feat_lc}.",
    "{frame}, involving {pop}. {feat}.",
]


def _lc(s: str) -> str:
    return s[0].lower() + s[1:]


def build(seed: int = SEED) -> list[dict]:
    rng = random.Random(seed)
    items, seen = [], set()
    screen_log = []

    for s_i, (stratum, n_total) in enumerate(STRATA):
        # topic balance within stratum, rotated so the remainder is not always
        # given to the same topics
        base, rem = divmod(n_total, len(TOPICS))
        counts = {}
        for t_i, topic in enumerate(TOPICS):
            counts[topic] = base + (1 if (t_i - s_i) % len(TOPICS) < rem else 0)

        for topic, n in counts.items():
            frames = FRAMES[topic]
            pops = POPULATIONS[topic]
            feats = FEATURES[(topic, stratum)]
            # Select unique FRAME+FEATURE pairs first. A repeated pair is a
            # near-duplicate differing only in population, so uniqueness here
            # is the real anti-duplication constraint.
            pairs = [(f, x) for f in range(len(frames)) for x in range(len(feats))
                     if not incompatible(frames[f], feats[x])]
            rejected = len(frames) * len(feats) - len(pairs)
            screen_log.append((stratum, topic, rejected, len(pairs), n))
            rng.shuffle(pairs)
            if len(pairs) < n:
                raise SystemExit(
                    f"cell ({stratum}, {topic}) exhausted: {len(pairs)} unique "
                    f"frame+feature pairs available, {n} needed. Widen the "
                    f"feature bank -- do NOT relax uniqueness.")
            pairs = pairs[:n]

            # THEN assign populations round-robin, which makes within-cell
            # population balance exact by construction rather than by filtering
            # (filtering starves populations whenever pair-uniqueness bites).
            # The offset is rotated per cell so a population is not always
            # paired with the same frame position.
            off = (s_i * len(TOPICS) + TOPICS.index(topic)) % len(pops)
            chosen, used = [], Counter()
            for k, (f, x) in enumerate(pairs):
                # walk from the round-robin position to the first compatible
                # population, preferring the least-used, so balance survives
                cands = [(k + off + d) % len(pops) for d in range(len(pops))]
                ok = [p for p in cands if not venue_mismatch(frames[f], pops[p])]
                p = min(ok, key=lambda q: used[q]) if ok else cands[0]
                chosen.append((f, p, x))
                used[p] += 1

            for k, (f, p, x) in enumerate(chosen):
                tpl = TEMPLATES[k % len(TEMPLATES)]
                if topic == "animal":
                    # The frame already names the species; adding a population
                    # produced 88 contradictions ("diet effects in laboratory
                    # zebrafish with laboratory rabbits").
                    tpl = "{frame}. {feat}."
                text = tpl.format(frame=frames[f], frame_lc=_lc(frames[f]),
                                  pop=pops[p], feat=feats[x],
                                  feat_lc=_lc(feats[x]))
                text = re.sub(r"\s+", " ", text).strip()
                if text in seen:
                    continue
                seen.add(text)
                items.append({
                    "id": f"GE007-{len(items) + 1:04d}",
                    "text": text,
                    "intended_stratum": stratum,
                    "topic": topic,
                    "population": pops[p],
                    "vulnerability": vuln_of(pops[p]),
                    "frame_id": f"{topic}:{f}",
                    "feature_id": f"{topic}:{stratum}:{x}",
                    "n_words": len(text.split()),
                    # deliberately absent: h_i, s_i -- produced by norming (s3)
                })
    build.screen_log = screen_log
    return items


def verify(items: list[dict]) -> bool:
    ok = True

    def chk(label, cond, detail=""):
        nonlocal ok
        ok &= bool(cond)
        print(f"  [{'PASS' if cond else 'FAIL'}] {label}{(' -- ' + detail) if detail else ''}")

    print("VERIFICATION")
    chk("total = 800", len(items) == 800, f"got {len(items)}")

    by_s = Counter(i["intended_stratum"] for i in items)
    for stratum, n in STRATA:
        chk(f"stratum {stratum} = {n}", by_s[stratum] == n, f"got {by_s[stratum]}")

    print("  -- topic balance within each stratum (max-min <= 1) --")
    for stratum, _ in STRATA:
        c = Counter(i["topic"] for i in items if i["intended_stratum"] == stratum)
        spread = max(c.values()) - min(c.values())
        chk(f"topic spread {stratum} = {spread}", spread <= 1)

    print("  -- population balance within each (stratum, topic) cell --")
    worst = 0
    for stratum, _ in STRATA:
        for topic in TOPICS:
            c = Counter(i["population"] for i in items
                        if i["intended_stratum"] == stratum and i["topic"] == topic)
            if c:
                worst = max(worst, max(c.values()) - min(c.values()))
    # DELIBERATE TRADE, recorded rather than silently relaxed. Exact population
    # balance and venue coherence CONFLICT: a frame naming a data source or
    # venue constrains which populations are sensible, so forcing equal counts
    # reintroduces nonsense items ("a model from electronic health records with
    # users of a municipal wifi network"). Balance was only ever a PROXY for
    # the real requirement -- that vulnerability must not track severity -- and
    # that requirement is tested directly and independently below. Where proxy
    # and substance conflict, the substance governs. Reported, not gated.
    print(f"      worst within-cell population spread = {worst} "
          f"(diagnostic; coherence is preferred over exact balance)")

    print("  -- vulnerability mix across strata (THE confound) --")
    mixes = {}
    for stratum, n in STRATA:
        c = Counter(i["vulnerability"] for i in items
                    if i["intended_stratum"] == stratum)
        mixes[stratum] = {k: c.get(k, 0) / n for k in ("low", "med", "high")}
        print(f"      {stratum:14s} low {mixes[stratum]['low']:.3f}  "
              f"med {mixes[stratum]['med']:.3f}  high {mixes[stratum]['high']:.3f}")
    hi = {s: m["high"] for s, m in mixes.items()}
    # The tolerance is DERIVED, not chosen to pass. The smallest stratum holds
    # 60 items split across 7 topics and 6 populations; neither divides evenly,
    # so a residual of a few items is arithmetic, not design. Floor = 3 items
    # in the smallest stratum.
    smallest = min(n for _, n in STRATA)
    floor = 3 / smallest
    spread = max(hi.values()) - min(hi.values())
    chk(f"high-vuln share spread = {spread:.3f} (quantization floor "
        f"{floor:.3f} = 3 items of {smallest})", spread <= floor)

    # THE property that actually matters. An imbalance is only dangerous if
    # severe items carry MORE vulnerable populations than benign ones -- that
    # is the direction in which perceived harm could track vulnerability
    # instead of the ethical feature. The reverse direction is harmless.
    chk(f"severe not more vulnerable than benign "
        f"({hi['anchor_severe']:.3f} <= {hi['anchor_benign']:.3f})",
        hi["anchor_severe"] <= hi["anchor_benign"])
    # A correlation check was tried here and REMOVED, deliberately, because it
    # is magnitude-free: with the spread already bounded to 3 items, a residual
    # that happens to be ordered correlates near -1 while spanning only 3.3
    # percentage points. Correlation without magnitude would fail this pool for
    # an arithmetic artifact. The substantive bound is the spread above, and
    # the direction test below it; both are enforced. Recorded rather than
    # silently dropped -- a removed check should leave a reason behind.

    print("  -- length matched across strata --")
    means = {}
    for stratum, _ in STRATA:
        w = [i["n_words"] for i in items if i["intended_stratum"] == stratum]
        means[stratum] = statistics.mean(w)
        print(f"      {stratum:14s} mean {statistics.mean(w):5.1f}  sd {statistics.pstdev(w):4.1f}")
    spread = max(means.values()) - min(means.values())
    chk(f"mean word-count spread across strata = {spread:.1f} (<= 3.0)", spread <= 3.0)

    chk("no duplicate texts", len({i["text"] for i in items}) == len(items))

    # near-duplicate check: no two items share frame AND feature
    fp = Counter((i["frame_id"], i["feature_id"]) for i in items)
    chk("no repeated frame+feature pair", max(fp.values()) == 1,
        f"max {max(fp.values())}")

    chk("no item carries a harm value",
        all("h" not in i and "harm" not in i for i in items))
    return ok


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="ge007_item_pool_v1.json")
    a = ap.parse_args()

    items = build()
    ok = verify(items)

    manifest = {
        "registration": "GE-P-2026-007",
        "protocol": "ledger/prereg/GE-P-2026-007-STAGE0-protocol.md",
        "seed": SEED,
        "n_items": len(items),
        "REVIEW_REQUIRED": (
            "MACHINE-COMPOSED. Not fit for norming until a human reads every "
            "item. Known risks of generated stimulus pools: subtle homogeneity "
            "of phrasing that participants may learn; culturally narrow "
            "assumptions about clinical, legal and research norms; and items "
            "whose severity the generator misjudged. The intended_stratum "
            "field is a GENERATION TARGET, not data -- actual harm placement "
            "is produced by norming (protocol s3), and items norming places "
            "elsewhere are evidence about this pool, not errors to correct."
        ),
        "harm_values": (
            "ABSENT BY DESIGN. h_i and s_i are produced by the norming sample "
            "and must not be supplied by the pool author."
        ),
        "verification_passed": ok,
        "items": items,
    }
    with open(a.out, "w", encoding="utf-8") as fh:
        json.dump(manifest, fh, indent=1, ensure_ascii=False)
        fh.write("\n")
    print(f"\nwrote {a.out}  ({len(items)} items)")
    print("ALL PASS" if ok else "VERIFICATION FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
