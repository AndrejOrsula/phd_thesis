#import "../utils/all.typ": *

= Conclusion <ch:conclusion>

This thesis began with the grand challenge of creating robotic intelligence that can generalize to the profound uncertainty of extraterrestrial environments. It was guided by the hypothesis that true adaptive autonomy emerges not from the pursuit of perfect fidelity, but from the mastery of immense diversity. The research presented here systematically investigated this principle, delivering the #gls("SRB", long: true), an open-source framework for generating diverse experience at scale, and a learning blueprint that combines predictive @world-model:pl with adaptive compliant control. The resulting body of evidence, culminating in successful real-world hardware deployments, confirms this core hypothesis and offers a new paradigm for developing robust autonomous systems for space.

This final chapter serves as a synthesis of that evidence. It begins by revisiting the research questions that structured the inquiry and providing the definitive answers this work has produced. It demonstrates how each of the initial research objectives was systematically fulfilled. The discussion then abstracts from the specific results to consider their broader implications for the scientific communities of machine learning and robotics, and for the engineering practice of space mission design. The thesis concludes with a critical reflection on its limitations and a forward-looking perspective on the open scientific questions that now lie on the path to a future of autonomy beyond Earth.

#pagebreak()

== Answers to Research Questions <sec:conclusion:answers>

This research was structured as an inquiry into three fundamental questions. The work has produced distinct, evidence-backed answers to each.

#research-question(
  num: 1,
  body: [How can simulation @environment:pl be leveraged to effectively train robotic @policy:pl that generalize across the diverse and unpredictable conditions of space?],
)

The answer provided by this thesis is that simulation must be leveraged not as an attempt to create a single, perfect digital twin, but as a factory for generating a vast and varied distribution of potential realities. The experiments consistently demonstrated that a @policy's robustness is a direct product of the diversity of its training data. The combination of @PCG for structural novelty and @DR for parametric variation proved to be a powerful method for creating a training distribution rich enough to force a learning @agent to discover invariant, generalizable strategies. The successful zero-shot @sim-to-real transfer of the adaptive traversal @policy in @ch:validation serves as the primary evidence, where the @agent trained with procedural diversity vastly outperformed its statically trained counterpart in the physical world.

#research-question(
  num: 2,
  body: [What learning methodologies and control representations unlock the adaptive and compliant behaviors necessary for complex operations in space?],
)

This work concludes that adaptive autonomy can benefit from a methodology that combines predictive models with compliant control. Among the tested configurations, @DreamerV3 performed strongly, supporting the value of an internal @world-model for efficient learning and decision-making under uncertainty. However, abstract prediction alone is insufficient for physical interaction. The integration of learned adaptive @compliance via @OSC provided a way for the @agent to learn not just where to move but how to interact by dynamically modulating its own @stiffness and @damping in response to the world.

#research-question(
  num: 3,
  body: [What are the key failure modes and limitations of state-of-the-art robot learning algorithms when faced with the unstructured complexities of space-relevant scenarios?],
)

Through systematic benchmarking with @SRB, this research identified three primary limitations that define the current frontier of the field. First, there is a clear planning horizon limit. The tested algorithms consistently failed on tasks requiring long, precise action sequences, such as the~`solar_panel_assembly` task, suggesting that current methods for temporal credit assignment and deep exploration are insufficient. Second, a significant perceptual @sim-to-real gap remains. As shown in @ssec:validation:traversal:perception, performance degrades substantially when learning from pixels due to unmodeled sensor noise, indicating that robust representation learning is a major, #box(width: 100%)[unsolved challenge. Third, the most pervasive failure mode is the brittleness of static training. This lack of @generalization, confirmed in every case study, reinforces the conclusion that policies that @overfit to their training conditions are not merely suboptimal but fundamentally unsuitable for the unpredictable nature of real-world robotics.]

== Summary of Fulfilled Objectives <sec:conclusion:objectives>

The pursuit of answers to these questions was operationalized through four research objectives, all of which were achieved.

#research-objective(
  num: 1,
  body: [Design and implement an open-source simulation framework for robot learning in space.],
)

This objective was fulfilled by the creation and open-source release of @SRB. As detailed in @ch:bench, this platform provides the critical infrastructure for this research, integrating a high-performance backend with a powerful procedural engine and accessible robotics and learning interfaces.

#research-objective(
  num: 2,
  body: [Establish a standardized suite of benchmark tasks within the developed simulation framework to rigorously evaluate the @generalization and adaptation capabilities of robot learning algorithms in space-relevant scenarios.],
)

This objective was realized by populating @SRB with a comprehensive suite of mission-relevant benchmark tasks. The tasks, presented in @ch:bench, provide the standardized, challenging testbed that enabled the rigorous empirical evaluations forming the core evidence of this thesis.

#research-objective(
  num: 3,
  body: [Investigate and develop a learning methodology for robust adaptive control.],
)

This objective was realized through the development of the learning blueprint in @ch:autonomy. The tested configurations showed strong results for @DreamerV3, and this work introduced a methodology for learning adaptive @compliance through the integration of @MBRL with @OSC.

#block(breakable: false, width: 100%)[
  #research-objective(
    num: 4,
    body: [Validate the proposed framework and methodology via @sim-to-real transfer in a terrestrial analog facility.],
  )

  This final and most critical objective was met through multiple successful zero-shot @sim-to-real experiments. The foundational grasping study in @ch:foundation and the comprehensive validation of adaptive traversal in @ch:validation provide strong physical evidence that the framework and methodologies developed in this thesis can bridge the @sim-to-real gap.
]

== Broader Implications and Impact <sec:conclusion:impact>

The conclusions of this research have implications that extend beyond the specific domain of space robotics, contributing new tools, methodologies, and insights to the broader scientific and engineering communities.

=== Machine Learning <ssec:conclusion:impact:ml>

For the machine learning community, this work serves as a large-scale case study in embodied intelligence, providing strong empirical evidence that @generalization in physical systems is deeply tied to the diversity of the learning curriculum. @SRB itself is a significant contribution, offering a new, challenging, open-source testbed for research in @RL, representation learning, and long-horizon planning that moves beyond the well-explored domain of tabletop manipulation. The success of the learned @compliance framework reinforces a key idea in embodied AI: true intelligence is not just about abstract reasoning but also about skillful and adaptive physical interaction with the world.

=== Terrestrial Robotics <ssec:conclusion:impact:terrestrial>

The methodologies forged for the extreme unstructured environments of space are directly applicable to the most challenging domains on Earth. The blueprint of combining procedural simulation with learned compliant control can enhance the robustness of robots in fields such as agriculture, construction, disaster response, and logistics, where robots must operate in similarly unpredictable and dynamic conditions. The open-source framework can be adapted to create new benchmarks for these domains, fostering a similar data-driven approach to solving their respective contact-rich challenges.

=== Space Mission Design and Operations <ssec:conclusion:impact:missions>

For the space sector, this research offers a new paradigm for developing and validating autonomous systems. Traditional deterministic verification can be augmented with the methodology presented here. The ability to probabilistically validate control software against thousands of procedurally generated scenarios provides a pathway to building statistical assurance in learning-based systems. This can raise the technology readiness level of autonomous capabilities more efficiently, enable more ambitious mission concepts, facilitate the data-driven co-design of robotic hardware and software, and ultimately accelerate the deployment of the persistent robotic infrastructure needed for a sustainable human presence beyond Earth.

== Limitations <sec:conclusion:limitations>

A rigorous scientific inquiry requires a clear acknowledgment of its boundaries. While this thesis provides a validated pathway toward adaptive autonomy, the findings are subject to several important limitations that define the frontier of current research.

=== The Inescapable Reality of the Sim-to-Real Gap <ssec:conclusion:limitations:sim_to_real>

The entire methodology is simulation-centric. While successful @zero-shot-transfer was demonstrated, this success was achieved in controlled laboratory analogs. A residual gap to the true physics of extraterrestrial environments undoubtedly remains, owing to unmodeled phenomena such as extreme thermal cycles, vacuum effects, and complex @regolith chemistry. The ultimate performance of these policies in space is therefore an extrapolation, contingent on the core assumption that the procedural distribution of simulated realities is broad enough to contain the single reality of the target @environment.

=== Constraints of Space-Grade Hardware <ssec:conclusion:limitations:hardware>

This research focused on developing generalizable software and, as such, did not fully model the severe constraints of flight-certified hardware. The performance of a @policy on a real space robot will be affected by factors like the limited computational power of radiation-hardened processors, different sensor noise profiles, and unique actuator dynamics that were only approximated through randomization. The inference latency of the preferred model-based @agent, while manageable on modern hardware, presents a significant challenge for deployment on current space-grade computers.

=== The Grand Challenge of Verification and Validation <ssec:conclusion:limitations:safety>

The policies evaluated in this thesis have not been formally verified. Their empirical robustness across the tested scenarios does not prove safe behavior under all possible conditions.

== Future Work <sec:conclusion:future>

This thesis provides a solid foundation and a clear direction for future scientific inquiry. The identified limitations motivate several critical and exciting avenues of research that can build directly upon the contributions of this work.

First, the most immediate priority is to continue closing the perceptual @sim-to-real gap. Future work should focus on developing higher-fidelity sensor models within @SRB and on training perception systems that are robust to real-world noise, potentially using techniques that learn to adapt to the sensor domain online.

Second, the long-horizon planning problem remains a major hurdle. The solution will likely require moving toward new algorithmic designs that dynamically create their own abstractions, decompose complex tasks into manageable segments, and automatically pursue short-horizon goals. This could involve integrating the low-level adaptive motor skills developed here with high-level symbolic planners. The data collection capabilities of @SRB make it an ideal platform for exploring how these abstraction hierarchies can be bootstrapped with @LfD.

Third, a transformative avenue is the integration of multimodal foundation models~@rt22023arxiv. Combining the robust control policies from this work with modern vision-language models could enable a new level of semantic understanding and human--robot interaction, allowing astronauts to command robots with natural language.

Fourth, expanding the framework to handle multi-agent coordination is another promising direction. The architecture of @SRB is well suited for research into collaborative robotics, a critical capability for future large-scale construction and exploration missions where teams of robots will need to work together.

Finally, the grand challenge of safety verification must be confronted. Future work must focus on developing methods to make learned policies more interpretable, to formally bound their behavior in uncertain states, and to integrate them with classical safety supervisors that can act as a fail-safe. Solving this problem is the critical final step in transforming adaptive autonomy from a powerful research concept into a trusted and indispensable tool for the future of human presence beyond Earth.
