#import "../utils/all.typ": *

= Introduction <ch:introduction>

Space, once a realm of mythology and distant contemplation, is rapidly evolving into a dynamic domain for scientific discovery, sustained human presence, and resource exploitation as humanity actively architects its multiplanetary future. The vision of permanent settlements on the Moon and Mars is no longer confined to science fiction~@nasa2020artemis. It has become a tangible objective pursued by a global consortium of space agencies and pioneering private ventures. This new era is driven by ambitious missions that aim to unlock the secrets of our solar system, harness extraterrestrial resources, and pave the way for human expansion into the universe~@jpl2024enabling @rognant2019autonomous @zhihui2021review.

Embarking on this transformative journey beyond Earth requires more than human courage and ingenuity alone. The environment is extreme, and the communication distances are vast. Consequently, sophisticated robotic systems are emerging not merely as tools but as indispensable enablers of this expansion. They are tasked with diverse operations from scouting planetary surfaces and assembling orbital megastructures to maintaining life-support systems in off-world outposts. The sheer scale and complexity of these missions demand more than mechanically proficient machines. The impracticality of constant human oversight mandates a fundamental shift toward autonomous systems capable of intelligent decision-making and adaptive behavior. Yet, traditional robotic control paradigms, which rely on pre-programmed execution under nominal conditions, are insufficient when confronted with the dynamic, unstructured, and often poorly understood environments of space~@doyle2021recent. This capability gap highlights an urgent need for data-driven control approaches that can learn from experience to develop robust strategies and adapt to unforeseen challenges.
#place(bottom, float: true)[
  #figure(
    caption: dynamic-caption(
      [The procedural paradigm at the core of this thesis leverages programmatically generated scenarios for large-scale @policy training in a parallelized simulation, which is a methodology validated by its successful zero-shot @sim-to-real transfer to a physical robot.],
      [The procedural paradigm for achieving adaptive autonomy],
    ),
    image("../figures/1_introduction/concept.svg", width: 100%),
  ) <fig:introduction:paradigm_shift>
]

Unlocking the full potential of robot learning in space necessitates more than just algorithmic advancements. The current landscape is characterized by a significant scarcity of relevant data, the prohibitive cost of comprehensive technology demonstrations, and limited access to representative simulations. These constraints render many terrestrial development methodologies impractical for the unique requirements of extraterrestrial missions. This thesis directly confronts these critical challenges by proposing a new paradigm of achieving robustness not through the pursuit of a single digital twin, but through the mastery of immense procedural diversity. It introduces a comprehensive framework centered on this principle that leverages large-scale simulation and data-efficient learning to achieve the @generalization required for space operations. The core of this work lies in establishing a scalable and diverse virtual testbed that facilitates the efficient training and systematic benchmarking of autonomous systems across a wide range of space-relevant scenarios. Building upon this foundational framework, the thesis further explores the applications of a novel robot learning methodology designed to equip @agent:pl with the robust, compliant, and generalizable behaviors required for complex tasks across diverse robotic platforms and application domains. The complete procedural paradigm, from scenario generation to @sim-to-real validation, is conceptually illustrated in @fig:introduction:paradigm_shift.

== Motivation <sec:introduction:motivation>

The human ambition to explore and establish a sustainable presence beyond Earth is a powerful catalyst for technological innovation. Future space missions envisioned by agencies as well as commercial entities are predicated on complex operations conducted in environments far removed from direct human intervention. For instance, the scientific exploration of the Moon and Mars by #gls("ESA", long: false) and #gls("NASA", long: false) requires autonomous rovers capable of traversing vast, hazardous terrains to independently collect diverse samples and perform sophisticated in-situ analyses~@zhang2019progress. Concurrently, robotic manipulators are becoming indispensable for building and maintaining orbital infrastructure, including next-generation space stations and advanced telescopes~@rognant2019autonomous @zhihui2021review. These systems will need to assemble large structures from smaller components, extend the operational lives of existing satellites through servicing~@esa2023servicing, and tackle the escalating problem of space debris. The development of such systems is under way through technology demonstrations of robots like those developed by GITAI, as shown in @fig:introduction:technology_demonstration.

#place(bottom, float: true)[
  #v(-0.5em)
  #subfigure(
    gutter: 0.25em,
    columns: 2,
    figure(
      image("../figures/1_introduction/gitai_lunar_assembly.png", width: 100%),
      caption: text(
        size: 9pt,
      )[Demonstration of GITAI R1 inside a #gls("JAXA", long: false) facility~@gitai2022jaxa],
    ),
    <fig:introduction:technology_demonstration:r1>,
    figure(
      image("../figures/1_introduction/gitai_excavation.png", width: 100%),
      caption: text(
        size: 9pt,
      )[Demonstration inside a GITAI @regolith chamber~@gitai2023excavation],
    ),
    <fig:introduction:technology_demonstration:excavation>,
    figure(
      image("../figures/1_introduction/gitai_iss_assembly.png", width: 100%),
      caption: text(
        size: 9pt,
      )[Demonstration of GITAI S1 inside the #gls("ISS", long: false)~@gitai2021iss],
    ),
    <fig:introduction:technology_demonstration:s1>,
    figure(
      image("../figures/1_introduction/gitai_iss_outside.png", width: 100%),
      caption: text(
        size: 9pt,
      )[Demonstration of GITAI S2 outside the @ISS~@gitai2024iss],
    ),
    <fig:introduction:technology_demonstration:s2>,

    caption: dynamic-caption(
      [Technology demonstrations of GITAI for in-space operations that illustrate the manipulation skills required for both planetary and orbital domains.],
      [Technology demonstrations for planetary and orbital operations],
    ),
    label: <fig:introduction:technology_demonstration>,
  )
]

Furthermore, a cornerstone of sustainable presence is the ability to exploit local resources through @ISRU~@moses2016frontier. This entails robots capable of excavating @regolith, extracting water ice, and converting indigenous materials into vital resources for construction, propellant production, and life support. Ultimately, as our presence extends further into space, robots will play a crucial role in supporting astronaut activities. They will assist with @EVA:pl, undertake hazardous tasks, and perform routine maintenance to improve crew safety and mission productivity. These applications share a common, critical need for robots that can operate with minimal human supervision and adapt to novel situations. This thesis is deeply motivated by addressing this capability gap and advancing robot learning techniques tailored to the unique challenges of space robotics.

=== Rise of Robots Beyond Earth <ssec:introduction:motivation:robots>

The expansion of human endeavor into space depends critically on a new generation of robotic autonomy. The vast distances of space missions introduce substantial communication delays that range from seconds for lunar operations to many minutes for Mars. These delays constrain continuous feedback, while real-time Earth-based teleoperation is impractical for Mars missions. Intricate tasks can still be teleoperated when operators can accommodate the communication delays. Even within @cislunar space, continuous human oversight is a scarce and valuable resource that limits the scope and pace of operations. Consequently, robots are no longer mere extensions of human capability. They are becoming essential and independent @agent:pl tasked with navigating and acting in these remote domains.

However, sending robots beyond Earth immerses them in environments far more demanding and less forgiving than any terrestrial setting. Extraterrestrial domains are often poorly characterized. They present highly unstructured terrains where unexpected events are the norm. These events can range from sudden micrometeoroid impacts to the gradual degradation of hardware. The success of pioneering missions like the Perseverance rover on Mars showcases the potential of robotic exploration. It also highlights current limitations, as its operations remain constrained by meticulous planning cycles and delayed communication~@jpl2024enabling. Robots in these conditions must therefore possess the intrinsic ability to perceive their surroundings, make intelligent decisions in the face of uncertainty, and adapt their strategies without constant human guidance.

These operational demands are compounded by a unique combination of environmental extremes. Robots must endure drastic temperature fluctuations and persistent cosmic radiation. Orbital environments introduce the complexities of vacuum and @microgravity, which fundamentally alter object dynamics and heat dissipation. Planetary surfaces present different gravity magnitudes that influence locomotion and manipulation in non-intuitive ways. Abrasive @regolith and rock fragments can damage mechanical systems and alter interaction #box(width: 100%)[dynamics, as shown in @fig:introduction:wheel_damage. The safety-critical nature of space missions, where failures can lead to catastrophic losses, further underscores the need for exceptionally robust systems. All of this must be achieved under severe constraints on available energy, computational power, and communication bandwidth.]

#v(-0.75em)

#figure(
  caption: dynamic-caption(
    [Damage to the wheel of the @NASA Curiosity rover on Mars. This image highlights the challenges posed by hazardous planetary terrains, where sharp rocks can cause significant hardware degradation over time~@rankin2022assessing.],
    [Damage to the wheel of the NASA Curiosity rover],
  ),
  image("../figures/1_introduction/curiosity_wheel_damage.png", width: 100%),
) <fig:introduction:wheel_damage>

=== Versatility of General-Purpose Robotics <ssec:introduction:motivation:general_purpose>

The dynamic and evolving demands of future space missions make the deployment of highly specialized, single-task robots both logistically and economically infeasible. In a prospective lunar base, a single robotic system may be tasked with excavating @regolith, assembling habitat modules, and later deploying scientific instruments. Developing, launching, and maintaining a distinct robot for each activity would introduce prohibitive complexity and cost. This operational reality gives rise to modular robotic architectures. An example is a common mobile platform equipped with a manipulator and various @EE:pl.

This hardware versatility exposes a more profound software challenge. A physically adaptable robot remains functionally inert if its control system cannot accommodate a new tool or an unfamiliar task. Manually engineering control @policy:pl for every hardware configuration and mission objective is a brittle strategy that does not scale. The key to unlocking true versatility lies not in pre-programming a robot for one specific mission but in equipping it with a learned set of fundamental, transferable skills. Instead of a monolithic @policy for a complete construction project, a truly general-purpose robot must master foundational primitives such as reliable navigation, grasping, and precision insertion. This approach abstracts a complex problem to its underlying physical components. For instance, a learned peg-in-hole sequence is a foundational motion applicable to structural assembly, spacecraft docking, and electrical connector mating.

Achieving this level of transferability, as depicted in @fig:introduction:transferable_skills, requires that learned skills be fundamentally agnostic to hardware specifics. The methodology in this thesis pursues this goal by learning control @policy:pl in the robot's @task-space. For instance, the high-level @policy would command @EE motion rather than specific joint torques. This ensures a @policy can be deployed across manipulators with different kinematic structures. By leveraging standardized or abstract sensory representations, the system also becomes invariant to the precise type or placement of its sensors. This approach transforms a general-purpose robot from a mere collection of reconfigurable parts into a truly adaptable @agent capable of applying its learned knowledge to novel challenges. This adaptable intelligence is the cornerstone of sustainable and scalable in-space operations. The pursuit of @generalization does not exclude the need for specialization. Safety-critical sequences like a planetary landing will likely continue to depend on platform-specific @policy:pl. Yet, the vision of general-purpose versatility is to build a broad foundation of composable skills to solve the vast majority of tasks encountered during a mission.

#place(auto, float: true)[
  #v(-0.5em)
  #figure(
    caption: dynamic-caption(
      [The conceptual idea of acquiring skills that can be transferred among different application domains of space robotics. A single learned skill, such as peg-in-hole insertion, could be deployed to diverse tasks across planetary and orbital environments, enabling a general-purpose robot to adapt to various mission objectives.],
      [Concept of transferable skills for space robotics],
    ),
    image("../figures/1_introduction/transferable_skills.svg", width: 77%),
  ) <fig:introduction:transferable_skills>
]

=== Promise of Learning-Based Autonomy <ssec:introduction:motivation:autonomy>

The quest for versatile and truly autonomous space robots necessitates a departure from traditional control paradigms that depend on precise environmental models and pre-programmed behaviors. These methods inherently struggle when confronted with the unmodeled dynamics and fundamental uncertainties of extraterrestrial operations. Robot learning offers a transformative pathway to provide robots with the adaptive intelligence required for these challenges~@kroemer2021review. Among the available paradigms, @RL has gained popularity due to its suitability for solving sequential decision-making problems~@sutton2018reinforcement. By learning from direct interaction with its surroundings, an @RL @agent can acquire a sophisticated understanding of physics and task dynamics.

This process embodies two capabilities that are critical for space missions. First, @RL @agent:pl can discover non-intuitive yet effective strategies for interacting with their @environment. An example is learning to use environmental contacts to guide a misaligned part into place. These emergent behaviors are often difficult, if not impossible, for a human to explicitly program. Second, and central to the promise of this thesis, they can achieve @generalization. When trained across thousands of diverse simulation instances, an @RL @policy should become invariant to irrelevant details such as the exact shape of a rock or the intensity of ambient illumination, and instead distill the underlying principles of the task. Although the application of advanced learning techniques to space robotics is still limited, their success in tackling complex terrestrial problems, including superhuman performance in games, signals their profound potential~@silver2017mastering @vinyals2019grandmaster. This thesis argues that the synergy of modern @RL algorithms with a comprehensive and diverse simulation framework is the key to transforming this promise into demonstrable, reliable autonomy for the next generation of space exploration.

=== Role of High-Fidelity Simulation <ssec:introduction:motivation:simulation>

The promise of robot learning for space depends in part on high-fidelity simulation as an enabling technology. The extreme cost and safety-critical nature of conducting the millions of trials required for modern robot learning make simulation a practical and scalable setting for large-scale training. Terrestrial analog facilities remain valuable, even though they cannot fully replicate the unique physics of different gravitational fields or the vast topographies of other worlds. Simulation provides a safe, cost-effective, and scalable @environment to develop and validate the next generation of autonomous systems.

The success of this paradigm relies on bridging the critical gap between the virtual and real worlds. This is not a simple @sim-to-real problem but a more complex sim-to-lab-to-space challenge. A @policy must first prove its efficacy by transferring from a virtual @environment to a physical robot in a laboratory. It must then be robust enough to generalize to the far more unstructured conditions of its final extraterrestrial deployment. This dual challenge exposes the inadequacy of many existing space-grade simulators for robot learning. Traditionally, these tools were designed for mission verification, with the aim of testing a predetermined plan under specific, nominal conditions~@hughes2014verification @kenneally2020basilisk. They were not built for the open-ended discovery and @generalization that @RL requires. To train a truly adaptive @agent, a simulation must be more than a mere digital twin of a single scenario. It must become a universe of possibilities. It must expose the @agent to a near-infinite variety of environmental conditions, object configurations, and potential failure modes. The lack of a simulation framework that integrates these learning-centric principles with high-fidelity space physics represents a major bottleneck to progress. Addressing this critical void is the primary focus of the research presented in this thesis.

== Problem Statement <sec:introduction:problem>

While the motivation for autonomous space robotics is compelling, its realization is obstructed by a set of fundamental and interconnected challenges. The successful deployment of learning-based systems beyond Earth is not just an engineering effort. It is a scientific problem that lies at the intersection of @generalization, standardization, and safety. This thesis is constructed to directly address the following critical problem areas that currently impede progress in the field.

=== Challenge of Generalization <ssec:introduction:problem:generalization>

The central technical problem confronting robot learning in space is the profound challenge of @generalization. An autonomous @agent must perform reliably not just in the specific conditions under which it was trained. It must perform across the full, unpredictable spectrum of scenarios it will encounter during a mission. Extraterrestrial environments represent the ultimate out-of-distribution test case. A rover trained on simulated Martian terrain must contend with real-world @regolith whose mechanical properties differ from any training sample. A manipulator arm learning to assemble a structure must handle components whose dimensions may have subtly changed due to thermal expansion or launch-induced vibrations.

This demand for robustness is where many contemporary robot learning approaches falter. @Policy:pl trained on limited or static datasets, even those of high fidelity, tend to @overfit to the particularities of their training @environment~@henderson2018deep. They may learn to exploit subtle visual or physical artifacts in the simulation that do not exist in reality. Consequently, when deployed, such @policy:pl often exhibit brittle behavior and fail catastrophically in the face of even minor novelty~@bousmalis2018using. This discrepancy between performance in training and performance in operation reveals a critical @generalization gap. Closing this gap is the foremost challenge. A @policy that cannot generalize beyond its training data is fundamentally unsuitable for the unstructured and evolving nature of space.

=== Lack of Standardized Benchmarks <ssec:introduction:problem:benchmarks>

The challenge of @generalization is exacerbated by a significant infrastructural problem, namely the absence of standardized benchmarks tailored for robot learning in space. Scientific progress in fields like computer vision and @RL has historically been driven by the availability of common testbeds that allow researchers to rigorously compare methodologies, reproduce results, and build upon each other's work. The domain of space robotics currently lacks such a unifying platform.

Existing space simulators like GMAT~@hughes2014verification and Basilisk~@kenneally2020basilisk focus primarily on astrodynamics and are typically employed for mission @VandV of pre-planned trajectories. They are often narrow in scope and ill-suited for the unique demands of robot learning research, which requires thousands of diverse and randomized simulations in parallel. Recent efforts have produced learning-focused simulators for specific tasks like rover navigation~@mortensen2024rlroverlab or spacecraft rendezvous~@el2023rans, but a comprehensive platform is missing. Conversely, established robot learning benchmarks, such as RLBench~@james2020rlbench, Meta-World~@yu2020meta, FurnitureBench~@heo2023furniturebench, and ManiSkill3~@tao2024maniskill3, are overwhelmingly terrestrial. They focus on tabletop manipulation or indoor navigation tasks. Their underlying physics and operational constraints do not capture the complexities of variable gravity, orbital dynamics, or large-scale unstructured terrains. This lack of a suitable and accessible testbed raises the barrier to entry for researchers and stifles innovation. Without a common ground for evaluation, the community cannot effectively measure progress toward achieving robust, generalizable autonomy.

#v(-0.2em)

=== Safety-Critical Nature of Space Operations <ssec:introduction:problem:safety>

Finally, all solutions must be developed under the immense pressure of the safety-critical nature of space operations. Robotic systems in space are multimillion-dollar assets, and mission failure is not an acceptable outcome. A @policy that is not robust or generalizable is inherently unsafe. An autonomous system that executes unpredictable, jerky, or overly rigid motions poses a direct threat to itself, to other mission-critical hardware, and potentially to human astronauts.

This problem is particularly acute for the contact-rich manipulation tasks that are central to this thesis, such as assembly and excavation. Traditional kinematic controllers like @IK are often brittle when unexpected contact occurs, potentially generating large forces that damage the robot or its @environment. True safety in interaction requires not just positional accuracy but also physical @compliance. The robot must be able to gracefully yield to unmodeled forces and adapt its physical behavior in response to contact. The problem, therefore, extends beyond mere task success. It is a question of how to learn @policy:pl that are not only effective but also inherently smooth, stable, and compliant, thereby ensuring the safety and integrity of the entire mission.

== Research Questions <sec:introduction:questions>

The preceding problem statement gives rise to a set of fundamental research questions that this thesis aims to answer. These questions are designed to systematically deconstruct the overarching challenge of achieving adaptive autonomy in space. They address the issues of @generalization, learning methodology, and algorithmic limitations in a structured manner. The investigation of these questions forms the core intellectual pursuit of this work.

#research-question(
  num: 1,
  body: [How can simulation @environment:pl be leveraged to effectively train robotic @policy:pl that generalize across the diverse and unpredictable conditions of space?],
)

At the heart of this thesis lies the challenge of @generalization. Training a robot directly in space is infeasible, so simulation offers a practical and scalable approach to large-scale training. This question explores the nature of the simulation required for this purpose, moving beyond the idea of a single, high-fidelity digital twin. Instead, it investigates the construction of a virtual training ground that supports the development of robust and adaptable @policy:pl. The central hypothesis is that exposure to immense diversity is the key to @generalization. This leads to an inquiry into the most effective techniques for generating this diversity, focusing on a combination of @PCG for creating a near-infinite variety of physical assets~@cobbe2020leveraging and extensive @DR of physical and visual parameters~@tobin2017domain. By training an @agent within this constantly shifting world, the aim is to encourage it to learn the underlying principles of a task, rather than to @overfit to the superficial details of any single scenario.

#research-question(
  num: 2,
  body: [What learning methodologies and control representations unlock the adaptive and compliant behaviors necessary for complex operations in space?],
)

This question addresses the learning process itself. It probes which algorithmic and control-theoretic choices are best suited to producing the kind of behavior needed for space robotics. The inquiry compares different @RL paradigms, particularly model-free approaches like @PPO~@schulman2017proximal, @TD3~@fujimoto2018addressing, and @SAC~@haarnoja2018soft, with @MBRL approaches like @DreamerV3~@hafner2025mastering, to determine which offers superior @sample-efficiency and @generalization capabilities. The question then delves into the representation of actions, challenging the sufficiency of standard @IK for contact-rich tasks. It specifically explores @OSC as a framework for providing software-defined @compliance~@khatib1987osc. The core of this inquiry is to determine whether an @agent can learn not only where to move #box(width: 100%)[but also how to physically interact with its @environment by dynamically modulating its own @stiffness and @damping. The goal is to discover a synergistic combination of learning algorithm and control representation that yields @policy:pl that are not just successful, but also inherently adaptive and compliant.]

#research-question(
  num: 3,
  body: [What are the key failure modes and limitations of state-of-the-art robot learning algorithms when faced with the unstructured complexities of space-relevant scenarios?],
)

This final question adopts a critical and empirical perspective, seeking to systematically identify the breaking points of current state-of-the-art techniques. By developing a standardized benchmark, this thesis provides the means to rigorously probe the capabilities of existing algorithms. The investigation aims to answer practical questions: How does performance degrade with increasing environmental complexity? What is the performance gap between learning from privileged state and learning from raw pixel data? At what point do long-horizon tasks with sparse rewards become intractable? By identifying these failure modes, this research aims to provide a clear assessment of where the current state of the art stands, establishing a concrete roadmap for future work.

#v(-1.25em)

== Research Objectives <sec:introduction:objectives>

To answer the stated research questions, this thesis pursues a set of specific and actionable research objectives. These objectives form a structured plan for the development, implementation, and validation of the concepts explored in this work.

#research-objective(
  num: 1,
  body: [Design and implement an open-source simulation framework for robot learning in space.],
)

The first objective is to create the necessary infrastructure for this research. This involves the design and implementation of a novel, open-source simulation framework built to address the limitations of existing tools. The framework must be highly parallelizable, integrate @PCG and @DR as core features, and provide standardized interfaces like the @Gymnasium #gls("API", long: false)~@towers2024gymnasium and @ROS~2~@macenski2022ros2 to make it accessible to the broader research community.

#research-objective(
  num: 2,
  body: [Establish a standardized suite of benchmark tasks within the developed simulation framework to rigorously evaluate the @generalization and adaptation capabilities of robot learning algorithms in space-relevant scenarios.],
)

Building upon the core framework, the second objective is to populate it with a suite of meaningful and challenging benchmark tasks. This involves carefully designing tasks that test the specific capabilities required for future space missions, from mobility and manipulation to complex, long-horizon assembly. The objective is to create a standardized testbed that allows for the systematic evaluation of learning algorithms to quantify performance, measure @generalization, and identify failure modes.

#research-objective(
  num: 3,
  body: [Investigate and develop a learning methodology for robust adaptive control.],
)

With the framework and benchmark in place, the third objective is to develop a learning methodology capable of producing adaptive and compliant behaviors. This involves a comparative analysis of @RL algorithms and an exploration of control representations suited for contact-rich interaction. The goal is to formulate a blueprint for learning adaptive control that combines the strengths of world modeling through @MBRL @agent:pl with the stability and expressiveness of learned compliant control via @OSC.

#research-objective(
  num: 4,
  body: [Validate the proposed framework and methodology via @sim-to-real transfer in a terrestrial analog facility.],
)

The final objective is to bridge the gap between simulation and physical reality. This entails validating the key principles and learned @policy:pl on physical robotic hardware within specialized terrestrial analog facilities, such as the LunaLab~@ludivig2020building. The goal is to demonstrate successful @zero-shot-transfer from the simulation framework to real robots. This will provide a validation of the entire approach and its potential applicability to future space missions.

== Key Contributions <sec:introduction:contributions>

This thesis makes several significant contributions to the fields of robot learning and space robotics. These contributions are organized into primary and secondary categories. The primary contributions represent the core, novel advancements that form the central pillars of this work.

=== Primary Contributions <ssec:introduction:contributions:primary>

The research presented in this thesis yields contributions that directly address the stated research objectives and provide novel solutions to the core problems identified.

The foundation of this work was laid through @pub:orsula2022learning, which introduced several novel concepts for robot learning in space. This research explored a simulation-centric approach to learn an @end-to-end @RL @policy from high-dimensional visual inputs and established the feasibility of @zero-shot-transfer to a physical robot. This initial work demonstrated the potential of procedural asset generation and highlighted the importance of @PCG for enhancing the @generalization capabilities of learned policies.

Following this, the systematic investigation of @PCG and @DR across multiple @RL algorithms in @pub:orsula2024leveraging demonstrated their effectiveness in enhancing @generalization. The findings provide strong empirical evidence that exposure to a wide distribution of training data is a critical strategy for closing the @generalization gap.

The primary artifact of this thesis is the @SRB, first conceptualized in @pub:orsula2024towards before being fully introduced in @pub:orsula2025space. It is a comprehensive open-source simulation framework designed specifically for robot learning in space. @SRB provides a standardized and highly configurable platform that integrates high-fidelity physics with extensive @DR and streamlined @PCG pipelines, as proposed in @pub:orsula2025advancing. Its @sim-to-real capabilities were further validated in @pub:orsula2025sim2dust by demonstrating the successful transfer of learned policies to a rover operating in a dusty lunar-analog facility.

A key methodological contribution is the development of a novel learning methodology for adaptive compliant control, as detailed in @pub:orsula2025learningtool. This methodology integrates @MBRL with @OSC to enable robots to learn to dynamically adjust their physical interaction properties. The work demonstrates that an @agent can learn to modulate its own @stiffness and @damping in response to environmental interactions, which is essential for safe and reliable operations in space.

#v(-0.55em)

=== Secondary Contributions <ssec:introduction:contributions:secondary>

In the course of pursuing the primary objectives, this research also produced several valuable secondary contributions. Leveraging the @SRB framework, a system for autonomous visual inspection of orbital targets was developed in a collaborative effort presented in~@pub:el2025reinforcement. This application served as a powerful external validation of the framework's utility and modularity, demonstrating that the core @MBRL methodology could be effectively applied by other researchers to control a spacecraft for complex 6-#gls("DoF", long: false) maneuvers around larger targets under @microgravity.

#block(breakable: false, width: 100%)[
  Participation in the Robot Air Hockey Challenge 2023 resulted in a novel application of an @MBRL algorithm to a highly dynamic and competitive task. The approach leveraged @self-play to acquire a robust @policy and ultimately achieved second place, followed by a successful @sim-to-real deployment. A retrospective analysis of all solutions is presented in @pub:liu2024retrospective.
]

Beyond these applications, this thesis provides a broad contribution to the research community by establishing extensive algorithmic benchmarks. Although minuscule in comparison to large-scale terrestrial datasets~@openx2023embodiment, the evaluation performed on @SRB tasks represents one of the largest studies of @RL algorithms on space-relevant problems to date, highlighting the strengths and weaknesses of different learning paradigms. Finally, the research is underpinned by significant open-source contributions. These include the @SRB framework itself with its hundreds of unique assets and robot configurations, the framework-agnostic @SimForge engine for @PCG, and various utilities for robotics and @RL research.

== Thesis Outline <sec:introduction:outline>

The remainder of this thesis is structured to systematically build upon the motivation and problems articulated in this introduction. The chapters are organized to first establish the necessary background, then present the core contributions, and finally provide a thorough validation and discussion of the results. The logical progression of these core themes is illustrated in @fig:introduction:thesis_structure.

#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [A visual representation of the thesis structure, mapping the main chapters to their core themes and showing the progression from foundational work to empirical validation.],
      [Visual outline of the thesis structure],
    ),
    image("../figures/1_introduction/thesis_structure.svg", width: 100%),
  ) <fig:introduction:thesis_structure>
  #v(1em)
]

A comprehensive review of the related work and foundational concepts that underpin this thesis is provided in @ch:background. It covers the domain of space robotics, the principles of robot control, the paradigm of robot learning with a focus on @RL and the @sim-to-real challenge, and the existing ecosystem of robotics simulation. This chapter concludes by synthesizing this information to precisely define the research gap that this work addresses.

@ch:foundation details the initial investigation from @pub:orsula2022learning that laid the groundwork for the main contributions of this thesis. It describes a simulation-centric approach to learning robotic grasping on the Moon and establishes the core concepts of @PCG and the use of 3D observations. The chapter recounts the successful @sim-to-real transfer of a learned @policy to a physical robot in a terrestrial analog facility. These outcomes served as the foundation for the subsequent research, providing critical insights that highlighted the limitations of existing infrastructure and set the stage for the development of a more comprehensive framework.

#block(breakable: false, width: 100%)[
  @SRB, the core artifact of this thesis, is presented in @ch:bench. This chapter offers a deep dive into the design philosophy, architecture, and capabilities of the open-source simulation framework. It details the suite of benchmark tasks, the diverse robotic fleet, the procedural generation engine @SimForge, and the integrations with the broader robotics and machine learning ecosystems.
]

@ch:autonomy presents the methodological contribution, revolving around a novel learning methodology for achieving adaptive autonomy. This chapter details the investigation into different @RL paradigms and control representations. It presents the algorithmic baselines, demonstrates the benefits of world modeling, and introduces the framework for learning compliant manipulation. It also explores the influence of robot @embodiment and tool-awareness on learned strategies.

#block(breakable: false, width: 100%)[
  The empirical validation for the proposed framework and methodology is provided in @ch:validation. This chapter presents a series of in-depth case studies on key applications, including adaptive traversal and tool-aware @regolith excavation, to provide robust evidence of the @generalization and adaptation capabilities of the developed @agent:pl.
]

Finally, @ch:conclusion summarizes the findings of this research. It revisits the research questions and objectives outlined in this chapter and demonstrates how they have been addressed and fulfilled. The chapter discusses the broader implications of this work, acknowledges its limitations, and proposes promising directions for future research.

Throughout the chapters, this thesis synthesizes a body of research that has been presented in a series of peer-reviewed publications. To maintain a clear and cohesive narrative focused on the central scientific arguments, the following content presents the primary methodologies and principal findings of this work. Consequently, certain implementation details, such as exhaustive hyperparameter lists, minor variations in experimental setups, and supplementary results, have been omitted for brevity. For a complete and detailed account of any specific study, the reader is respectfully directed to the original publication.
