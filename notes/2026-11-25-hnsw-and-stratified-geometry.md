# HNSW and the stratified moral manifold: survey and analysis

Date: 2026-11-25. Status: working note. Book text read: v1.25 (site branch), Chapters 5, 8, 11.

This note follows up the question "would Hierarchical Navigable Small World (HNSW) be a better model than the Whitney-stratified manifold, or a hybrid?" and the first answer to it (hybrid: geometry for moral structure, HNSW for retrieval of precedents, separate retrieval edges from action edges, run a three-arm experiment).

Sources are marked **[V]** (checked at a primary page this session), **[B]** (bibliographic record checked, content from memory), **[M]** (from memory, not checked). Statements about the code come from a read-only scan on 2026-11-25. Nothing was run.

## 1. Conclusions

1. **HNSW is not a competing model of ethics.** It is an index over a distance that someone else supplies. Its layers are random draws and its long edges are routing shortcuts. The first answer was right on this, and the literature is firmer than it said (Section 2).
2. **The hybrid has three distinct jobs for a neighbour graph, not one.** (a) Retrieve precedents. (b) Retrieve the nearest case on the *other side* of a named boundary, which estimates the book's jump function ΔS. (c) Supply the vertices and local edges of the decision complex of §8.10a from stored cases instead of a grid. Jobs (b) and (c) were not in the first answer. Job (c) bears on Theorem 11.2.
3. **Retrieval and action need two distances on the same cases**, and the book already contains both. This makes "retrieval edge" and "action edge" precise (Section 3.1).
4. **Stored cases can give an admissible heuristic**, under a stated condition. The first answer said only that they do not do so automatically (Section 3.4).
5. **The Whitney conditions are not the testable part of the model.** Under the book's own hypothesis they come nearly free, and no method was found that tests them from samples. The testable parts are the step at the gate, the smooth approach to it, and a metric that differs by stratum (Section 4).
6. **Most of the proposal has prior art. The experiment does not.** No published comparison of similarity only, similarity plus gates, and similarity plus gates plus local metric was found (Section 5).
7. **In the code today**: executable strata exist (erisml-compiler). The decision complex and A* search do not exist as code in any scanned repo. There is no case retrieval in the DEME pipeline. turboquant-pro has an HNSW index but no filtered search (Section 6).
8. Four items in the book need attention independent of HNSW (Section 8).

## 2. What an HNSW graph is, and what it preserves

**Layers.** A node's top layer is `floor(-ln(U) * mL)` with U uniform. The authors state that "the layers are not correlated with the spatial positions of the data elements" (Malkov and Yashunin, arXiv:1603.09320) [V]. Layers are therefore not strata, principles, or levels of abstraction. Two later studies find that a flat graph matches HNSW on high-dimensional data and that the routing is done by hub nodes, which arise from data density (Lin and Zhao, arXiv:1904.02077; Munyampirwa et al., arXiv:2412.01940) [V].

**Guarantees.** HNSW has no worst-case guarantee. Its O(log N) argument assumes exact Delaunay graphs, which its own edge heuristic violates [V]. Indyk and Xu (NeurIPS 2023, arXiv:2310.19126) prove a guarantee for slow-preprocessing DiskANN in bounded doubling dimension, and construct instances where HNSW needs about 0.1n steps [V]. The property that makes greedy routing succeed is monotone reachability (Fu et al., arXiv:1707.00143) [V]. That property is about reaching near neighbours. It says nothing about path length.

**Geodesics.** Graph shortest paths approximate geodesics when edges are confined to a small scale and the sampling is dense (Bernstein, de Silva, Langford, Tenenbaum 2000, as restated by Arias-Castro and Le Gouic, arXiv:1706.09441) [V for the restatement]. One long edge across a fold corrupts the estimate (Balasubramanian and Schwartz, Science 2002) [B]. HNSW adds long and cross-cluster edges on purpose. So an HNSW graph does not approximate the moral geodesics of Chapter 10, by design. No result was found saying that it does.

**Hard filters.** If a predicate removes nodes, the surviving subgraph loses degree and can disconnect. Random removal fragments the graph below roughly 1/⟨k⟩ of nodes kept (Qdrant, 2019) [V]. ACORN (SIGMOD 2024, arXiv:2403.04871) repairs this with denser neighbour lists and two-hop expansion, and states that neither it nor HNSW has a connectivity guarantee on arbitrary data [V]. A gate used as a retrieval filter is such a predicate.

**Non-metric distances.** Greedy graph search runs and works in practice without the triangle inequality (Boytsov and Nyberg, arXiv:1910.03534) [V]. The proved guarantees above assume a metric.

**Stratified structure from data.** Local dimension, singular points, and stratum membership can be estimated from samples (Haro et al. 2008; Bendich, Wang, Mukherjee, SODA 2012; Stolz et al., PNAS 2020; von Rohrscheidt and Rieck, ICML 2023) [V]. The one sampling theorem for Whitney-stratified spaces covers two strata and *assumes* Whitney regularity (Mäder and Waas, arXiv:2206.08926) [V]. No method was found that tests Whitney condition (A) or (B) from a point cloud. Read this as "not found in two targeted searches".

**Combination with stratified geometry.** No graph index built over a stratified, multi-chart, or product-manifold geometry was found. The nearest analogues are the filtered indexes (one navigable subgraph per label) and hyperbolic indexes.

## 3. Analysis against the book

### 3.1 Two distances on one set of cases

Definition 8.13 gives the action cost

    w(i,j) = Δaᵀ Σ⁻¹ Δa + Σ_k β_k · 1[boundary k crossed].

Define two distances from it.

- **Retrieval distance** d_ret(i,j): the Mahalanobis term alone, computed on the attributes with the gate features left out.
- **Action distance** d_act(i,j): the Mahalanobis term plus the boundary penalties, with β = ∞ on absorbing and forbidden boundaries.

Three consequences.

1. **A contrast pair** is a pair with small d_ret and different strata. Its d_act is large or infinite. The consent example in the first answer is such a pair. The pair is useful for comparison and gives no permission to act, and the two distances say why.
2. **Within one stratum HNSW is exact for the book's metric.** A constant Σ is a linear change of coordinates (whiten with the Cholesky factor of Σ⁻¹) to plain Euclidean distance.
3. **Across strata no single index fits.** A Type II boundary changes the metric (Definition 8.5), so Σ differs by stratum, and with β = ∞ the action distance disconnects the cases into components. This is the filtered-search failure of Section 2. The workable designs are one index per stratum, or one gate-blind index for d_ret with gates applied afterwards as an explicit check. The second is simpler and is what retrieval of contrast pairs needs.

### 3.2 Contrast retrieval estimates the jump function

§8.5 defines the jump ΔS(p) across a boundary at p, and Definition 8.11 lists it as part of the boundary crossing data. The book gives no estimator. Matched contrast pairs give one. For cases just either side of boundary k, matched on d_ret, the mean difference in judgement estimates ΔS near that point. This is the matching form of a regression-discontinuity design [M for the name]. It also gives the registration pass a way to make Prediction 20.4 (boundary penalty measurement) operational, which the 2026-08-25 pass marked only partly registrable.

**Correction, same day, after a second survey.** Matching on a learned multi-dimensional metric is not a
defensible *estimator* of ΔS. The bootstrap is invalid for matching estimators (Abadie and Imbens,
Econometrica 2008), the bias grows with the number of matching dimensions, and no result covers a
jointly learned metric. The defensible estimator is a cross-fitted doubly robust one in which the
embedding enters the outcome and gate-propensity models (Chernozhukov et al., arXiv 1608.00060; Gui and
Veitch, arXiv 2210.00079, for a treatment that is an attribute of the text). Contrast pairs then serve
as the explanation of the estimate. Regression discontinuity applies only where there is a graded
ladder.

Prior art for using the nearest opposite-outcome case exists (HYPO and CATO distinguishing, Truth-Teller, near misses). No retrieval objective that deliberately fetches the nearest case across a *named* boundary in an embedding index was found.

### 3.3 Stored cases as the decision complex, and what that does to Theorem 11.2

Theorem 11.2 counts a uniform grid, N ∝ (1/ε)⁹ per stratum, and its closing remark says no adaptive scheme avoids sampling that volume. Three observations.

1. **The count depends on the grid and on nine.** §5.3 of v1.25 reports effective rank 5.19 of 8. At rank 5.2 and ε = 0.01 the grid has about 10^10.4 vertices, a size at which neighbour graphs are built routinely.
2. **Sampled roadmaps are the known alternative to grids.** In motion planning, PRM* builds a graph on sampled states, connects near neighbours, checks each edge for feasibility, and its shortest paths converge to the optimum (Karaman and Frazzoli, IJRR 30(7), 2011, arXiv:1105.1186) [V for the result]. The edge feasibility check corresponds to the gate and constraint check here. The same work shows that a fixed number of neighbours k is *not* asymptotically optimal and that k must grow with n, about log n [V that fixed k fails; M for the log n rate]. HNSW uses a fixed M. An HNSW bottom layer is therefore a neighbour *finder* for building the complex and should not be used as the complex.
3. **What survives.** The convergence rate of a sampled roadmap still degrades with dimension, so cost-to-go still has to be approximated and heuristics are still needed. The conclusion of Corollary 11.1 stands in a weaker form. The argument for it should rest on coverage of the case set, since the grid count is not forced.

Action edges must be local (within a small d_ret radius, same stratum or an explicit gate crossing with its β). HNSW's upper layers and cross-cluster edges must never become action edges. This is the same separation as Section 3.1, stated for graph construction.

### 3.4 Precedents and admissibility

Retrieving a similar case does not give an admissible heuristic. Stored cases can give one by the landmark method. If the true cost-to-go from each of a few landmark cases to every vertex of the action graph is stored, the triangle inequality on *graph* distances gives a lower bound on the remaining cost for any vertex, and A* with it returns optimal paths (Goldberg and Harrelson, "Computing the shortest path: A* search meets graph theory", SODA 2005) [V]. This matches the book's own description of obligations as pattern databases (§11.3).

The condition is strict. The stored costs must be true shortest-path costs in the same action graph, including the β penalties. Judged costs from a corpus do not qualify. The registration pass marked Prediction 20.5 (heuristic admissibility) blocked for lack of h*. The landmark method does not remove that block. It narrows it to "true cost from a small number of landmark cases".

### 3.5 Retrieval is a learned reading, so it sits on the semantic side of Theorem 8.6

§8.10b allows a learned model to move a semantic stratum, and Theorem 8.6 forbids any event that is not a system event from entering an authority stratum. A retrieved precedent is a learned model's output. Design rule: a precedent may add watchfulness, propose a comparison, or lower a score. It may never fire a gate into an authority stratum and may never lift a veto. In DEME terms the retrieval module is advisory (`vetoes=False`).

### 3.6 Retrieval must be invariant under redescription

Theorem 11.1b names a fourth failure class, the gauge-variant heuristic, whose output depends on the wording. Retrieval over text embeddings has this failure by construction, and human reminding is known to follow surface similarity while judged soundness follows structure (Gentner, Rattermann, Forbus 1993) [V]. Hubness adds a second bias, in which a few cases become neighbours of very many queries (Radovanović et al., JMLR 2010) [V]. Two requirements follow. Index the canonicalized facts, not the raw text. Measure the overlap of the retrieved set across paraphrases of the same case, and report it beside accuracy.

## 4. The challenge to the Whitney model

The first answer said that discrete boundaries do not by themselves establish Whitney regularity. That is correct. Three further points.

1. **Whitney regularity is nearly free under the book's hypothesis.** Proposition 8.1 assumes semi-algebraic constraint sets, and every semi-algebraic set admits a Whitney stratification. So "Whitney-stratified" adds little content beyond "semi-algebraic boundaries". It cannot be the claim that earns the geometry its place.
2. **It is not testable from data with any method found.** See Section 2.
3. **What Whitney regularity buys is mathematical.** It gives tubular neighbourhoods and controlled retractions, which Definition 8.6 (absorbing strata) and Convention 8.1 use. That is a reason to keep it as a modeling axiom. It is not evidence.

The claims that data can test are these.

| Claim | Where | Test |
|---|---|---|
| Judgement steps at the gate | §8.4 | single-feature flip pairs |
| Judgement varies smoothly up to the gate | §8.2 "controlled approach" | graded ladders within one stratum |
| Trade-off rates differ by stratum | Definition 8.5 | per-stratum metric against one pooled metric |
| Local metric adds prediction beyond gates and precedents | Chapters 6, 9 | arm C against arm B below |

One existing result already bears on the second row. In the sqnd-probe ladder (N = 220, post hoc), Liberty responses were 100% at level 5, 0% at level 6, and 55% at level 7. That is discrete but not monotone in the ladder coordinate, so the ladder coordinate is not a clean normal direction to the boundary.

Two v1.25 facts also favour the simpler reading. The rights axis could not be learned as a graded coordinate and is now a hand-specified hard constraint. Learned coordinates beat the nine-axis chart on Scruples. Gates are carrying weight that the chart's metric is not. The experiment below asks whether a *learned* local metric carries any.

## 5. Prior art and what is new

| Part of the proposal | Closest prior work | Status |
|---|---|---|
| Cases in a similarity space with regions | Peterson, *The Ethics of Technology* (OUP 2017): pairwise similarity ratings, paradigm case per principle, Voronoi regions [V via reviews] | Exists. One flat space, no boundaries, no region-dependent metric, no path search. Criticised for "similar with respect to what" (Shrader-Frechette, NDPR 2017) [V] |
| Cheap retrieval, then structural check | MAC/FAC (Forbus, Gentner, Law 1995) [B]. SIROCCO (McLaren, AIJ 2003): structure beat full-text retrieval in an ablation [V] | Exists |
| A precedent transfers unless distinguished | Horty and Bench-Capon 2012. Prakken 2021: a decision is forced when some precedent has an empty set of relevant differences [V] | Exists, and is the right formal object for the gate check |
| Gate plus similarity in one system | MoralDM (Dehghani et al., AAAI 2008): sacred values switch the mode [V via summaries]. ATRIUM (Erickson and Kruschke 1998): rule and exemplar modules with a learned gate [B] | Exists in outline |
| Memory as a small-world network | Steyvers and Tenenbaum 2005 [V]. Hills, Jones, Todd 2012 [V] | Exists. Abbott, Austerweil, Griffiths 2015 show a random walk reproduces the same recall data, so the data do not identify the search process [B] |
| Human memory or case retrieval as greedy routing on a hierarchical navigable graph | none found | New |
| Retrieval graph and action graph as two edge sets over one moral metric | none found | New |
| Three-arm experiment scored separately on trade-offs, flips, analogies | none found | New |
| Single-feature consent flip set | none found (ETHICS-Contrast has 200 generic minimal pairs) [V abstract] | Must be built |

The cognitive hypothesis in the first answer (local adjustment, associative jumps, regime recognition) is close to existing resource-rational accounts (Levine et al., BBS 2024) [V abstract]. What would be new is a specific retrieval process. Because of Abbott et al., a behavioural test must be designed to separate greedy routing from a random walk. Fluency-style data will not do it.

## 6. What exists in the code (scan of 2026-11-25)

- **Executable strata**: `erisml-compiler/src/erisml_compiler/runtime/strata.py` (`Gate`, `Stratification`, containment and absorption checked at scene load). States are labels and edges are gates. No weights, metric, or costs.
- **Decision complex (§8.10a) and A* (Chapter 11)**: no code found in erisml-lib, erisml-compiler, gtc-prototype, agi-hpc/src, sqnd-probe/src, or turboquant-pro. They exist as book and paper text only.
- **Case retrieval in DEME**: none. `MoralVector.distance` is unweighted (euclidean, manhattan, chebyshev), not Mahalanobis. The only Mahalanobis nearest-neighbour matching is analysis code for the Legal Bond Index paper.
- **Plug point**: a precedent module can implement `EthicsModuleV2` (`erisml-lib/src/erisml/ethics/modules/base.py`) and be placed in a composition stage as advisory, with no pipeline change. `DecisionProof` has no field for the identity of a case base. `feeder_provenance` is the nearest existing pattern.
- **turboquant-pro 2.0.0a3**: `CompressedHNSW` (`hnsw.py`) with a Python API. No `search` takes a filter. `StratifiedIndex` holds one index per k-means area and has no single-area query.
- **Data on disk**: Social-Chem-101 slices (AITA 96,083 lines, Dear Abby 50,301 lines, with judgement columns). Dear Ethicist engineered letters with gate-detection and graded-ladder protocols (37 engineered items). AITA 2.9k labelled posts. Raw Scruples and Moral Machine data are absent locally. ETHICS and MoralExceptQA are absent.
- **Scale**: at 150 thousand cases an exact scan is fast. HNSW is not needed for the experiment. Whether to use it is an engineering choice for a larger case base, separate from the modeling question.

## 7. Proposed experiment

**Question.** Does a local metric add reliable prediction beyond gates and precedents?

**Arms.**

| Arm | Predictor |
|---|---|
| G | gates only, no retrieval (stratum rule gives the verdict) |
| A | k nearest cases by d_ret, vote |
| B | A, keeping only precedents whose set of relevant differences on gate features is empty (Prakken's test) |
| C | B, with a metric learned per stratum and a local fit within the neighbourhood |

All arms use exact nearest-neighbour search. An HNSW run of arm A is a separate check that reports only recall loss and time.

**Held-out families.** (1) Gradual trade-offs within one stratum. (2) Single-feature boundary flips, including a consent set that has to be written. (3) Cross-domain analogies.

**Measures.** Agreement with human judgement, error rate on flips counted separately for wrongly crossing and wrongly refusing, overlap of the retrieved set under paraphrase, and compute.

**Reading the result.**

- B beats A on family 2 and C does not beat B anywhere: gates do the work. A graph with gates deserves to be the working model and the metric is unsupported.
- C beats B on family 1 by a margin set in units of the resampling noise of B: the local metric earns its place.
- G matches B: retrieval adds nothing on this data.

**Rules for a fair test.** Seal thresholds and the item split before fitting. Flip and ladder items must be written by someone blind to the arms, since the Phase-5 mechanism result did not replicate on blind stimuli. Cluster errors by source letter or post, not by item. The metric in arm C is fitted on training cases only, and choosing its rank counts as fitting.

**Not decided here.** The data source for family 3, who writes the consent set, and where it runs (Atlas is occupied by the Lean build as of 2026-11-24).

## 8. Four items in the book, found while reading

Stated as my reading. Each should be checked before any edit.

1. **MORAL-PATHFIND (§11.1, §11.5).** As defined, boundary crossings add a penalty β_k to the path cost and the question is whether a path of cost at most B exists. Additive non-negative penalties fold into edge weights, which leaves an ordinary shortest-path problem solvable in polynomial time. Weight-Constrained Shortest Path is hard because it has a *second*, separate budget. The reduction as described does not establish NP-hardness. A definition with a separate bound on crossings or on a second resource would.
2. **Proposition 8.5(i), marked Proved.** It cites Mémoli and Sapiro (SIAM J. Appl. Math. 65(4), 2005) for convergence of minimum-weight grid paths to geodesics. Per the record found, that paper proves consistency for an eikonal solver in an offset band and contrasts it with Dijkstra on graphs, which it calls not consistent [V from search summary, paper not opened]. On a grid with fixed connectivity (the 3^d − 1 neighbours used in the Chapter 11 appendix), shortest paths keep a direction-dependent error as ε → 0 [M]. Convergence needs the connection radius to grow relative to the spacing, as in the Bernstein et al. conditions.
3. **Proposition 8.1, Step 2.** The step argues that condition (A) holds because the constraint surfaces are smooth. The existence theorem gives a Whitney stratification that *refines* the partition, possibly with extra strata. The partition cut by the gates need not itself be Whitney. The Whitney umbrella x² = zy² with the z-axis as one stratum is the standard example: along y → 0 with y much larger than √z the tangent planes tend to the xy-plane, which does not contain the z-axis, so (A) fails at the origin until the origin is made its own stratum (computed here).
4. **Gate effectiveness figures (§8.4).** `erisml-lib/src/erisml/ethics/defaults/ground_state_loader.py` carries `GROUND_STATE_VERSION = "1.0.0-synthetic"` while its docstring says the values derive from 20,030 Dear Abby letters. The provenance of the 89 to 97% figures in the §8.4 table should be traced to the measured source.

## 9. References

Graph indexes and geometry
- Malkov, Yashunin. Efficient and robust approximate nearest neighbor search using HNSW graphs. arXiv:1603.09320. [V]
- Kleinberg. Navigation in a small world. Nature 406:845, 2000. [V]
- Lin, Zhao. Graph based nearest neighbor search: promises and failures. arXiv:1904.02077. [V]
- Munyampirwa, Lakshman, Coleman. Down with the hierarchy: the "H" in HNSW stands for "hubs". arXiv:2412.01940. [V]
- Indyk, Xu. Worst-case performance of popular approximate nearest neighbor search implementations. NeurIPS 2023, arXiv:2310.19126. [V]
- Fu, Xiang, Wang, Cai. Navigating spreading-out graph. arXiv:1707.00143. [V]
- Patel, Kraft, Guestrin, Zaharia. ACORN. SIGMOD 2024, arXiv:2403.04871. [V]
- Gollapudi et al. Filtered-DiskANN. WWW 2023. [V abstract]
- Vasnetsov. Filtrable HNSW. Qdrant article, 2019. [V]
- Boytsov, Nyberg. Retrieval for complex non-metric data via neighborhood graphs. arXiv:1910.03534. [V]
- Tenenbaum, de Silva, Langford. Science 290:2319, 2000. [B]
- Arias-Castro, Le Gouic. Unconstrained and curvature-constrained shortest-path distances and their approximation. arXiv:1706.09441. [V]
- Balasubramanian, Schwartz. The Isomap algorithm and topological stability. Science 295:7, 2002. [B]
- Niyogi, Smale, Weinberger. Discrete Comput. Geom. 39:419, 2008. [V]
- Bendich, Wang, Mukherjee. Local homology transfer and stratification learning. SODA 2012. [V]
- Haro, Randall, Sapiro. Translated Poisson mixture model for stratification learning. IJCV 80:358, 2008. [V]
- Stolz, Tanner, Harrington, Nanda. Geometric anomaly detection in data. PNAS 117:19664, 2020. [V]
- von Rohrscheidt, Rieck. Topological singularity detection at multiple scales. ICML 2023, arXiv:2210.00069. [V]
- Mäder, Waas. From samples to persistent stratified homotopy types. arXiv:2206.08926. [V]
- Helmer, Nanda. Conormal spaces and Whitney stratifications. arXiv:2106.14555. [V]
- Radovanović, Nanopoulos, Ivanović. Hubs in space. JMLR 11:2487, 2010. [V]
- Karaman, Frazzoli. Sampling-based algorithms for optimal motion planning. IJRR 30(7):846, 2011, arXiv:1105.1186. [V]
- Goldberg, Harrelson. Computing the shortest path: A* search meets graph theory. SODA 2005. [V]
- Mémoli, Sapiro. Distance functions and geodesics on submanifolds of R^d and point clouds. SIAM J. Appl. Math. 65(4):1227, 2005. [V record]

Ethics, law, cognition
- Peterson. The Ethics of Technology: A Geometric Analysis of Five Moral Principles. OUP 2017. [V via reviews]
- Verheyen, Peterson. Can we use conceptual spaces to model moral principles? Rev. Phil. Psych. 12:373, 2021. [V abstract]
- Shrader-Frechette. Review of Peterson. Notre Dame Philosophical Reviews, 2017. [V]
- McLaren. Extensionally defining principles and cases in ethics. Artificial Intelligence 150:145, 2003. [V]
- Dehghani, Tomai, Forbus, Klenk. An integrated reasoning approach to moral decision-making. AAAI 2008. [V via summaries]
- Blass, Forbus. Moral decision-making by analogy. AAAI 2015. [V via summaries]
- Horty, Bench-Capon. A factor-based definition of precedential constraint. AI and Law 20:181, 2012. [V]
- Prakken. A formal analysis of some factor- and precedent-based accounts of precedential constraint. AI and Law 29:559, 2021. [V]
- Gentner, Rattermann, Forbus. Cognitive Psychology 25:524, 1993. [V abstract]
- Forbus, Gentner, Law. MAC/FAC. Cognitive Science 19:141, 1995. [B]
- Steyvers, Tenenbaum. Cognitive Science 29:41, 2005. [V]
- Hills, Jones, Todd. Psychological Review 119:431, 2012. [V]
- Abbott, Austerweil, Griffiths. Psychological Review 122:558, 2015. [B]
- Erickson, Kruschke. Rules and exemplars in category learning. JEP General 127:107, 1998. [B]
- Levine, Chater, Tenenbaum, Cushman. Resource-rational contractualism. Behavioral and Brain Sciences, 2024. [V abstract]
- Baron, Spranca. Protected values. OBHDP 70:1, 1997. [B]
- Demaree-Cotton, Sommers. Cognition 224:105065, 2022. [V abstract]
- Jin et al. When to make exceptions. NeurIPS 2022, arXiv:2210.01478. [V]
