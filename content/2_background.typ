#import "../utils/all.typ": *

= Background and Related Work <ch:background>

This chapter provides the foundational context necessary to situate the contributions of this thesis within the broader landscape of space robotics and robot learning. It begins by exploring the domain of space robotics, tracing its historical evolution and outlining the unique challenges that motivate the need for advanced autonomy. Next, it reviews the fundamental principles of robot control for both mobility and manipulation, with a particular focus on the distinction between kinematic and compliant control strategies. The chapter then delves into the paradigm of robot learning. It introduces the mathematical framework of the @MDP and discusses the core concepts of @RL, @LfD, and the critical @sim-to-real challenge. Finally, it surveys the ecosystem of robotics simulation and highlights the role of procedural generation and standardized benchmarks in driving progress. The chapter culminates in a synthesis that clearly identifies the research gap this thesis aims to fill.

== Domain of Space Robotics <sec:background:robotics>

Space robotics is a specialized field of robotics concerned with the design, development, and operation of robotic systems capable of functioning in extraterrestrial environments. These systems are instrumental in performing tasks that are too dangerous, repetitive, or precise for humans. They also operate in locations that are entirely inaccessible to direct human presence. From the earliest automated probes to the sophisticated rovers currently exploring Mars, robots have been fundamental to humanity's quest to understand and venture into the cosmos.

=== Evolution of Automation in Space <ssec:background:robotics:evolution>

The history of space robotics is deeply intertwined with the history of space exploration itself. The first robotic systems in space were simple, automated spacecraft that followed pre-programmed trajectories and executed basic commands~@verma2005survey. Manipulation tasks were initially performed by human astronauts using hand tools, as illustrated in @fig:background:apollo_hand_tong. These early missions relied entirely on human dexterity for complex interactions, highlighting the capability gap that modern autonomous robotics aims to fill. Over the decades, the level of automation has steadily increased. The Viking landers featured a robotic arm capable of scooping Martian soil~@soffen1977viking. The actions of this arm were meticulously sequenced and uploaded from Earth. The Sojourner rover represented a significant step forward with its limited ability to autonomously navigate around obstacles~@stevenson1997mars.

#place(auto, float: true)[
  #v(-0.5em)
  #figure(
    caption: dynamic-caption(
      [A photograph of the Apollo 12 mission displaying the use of a manual tool for collecting lunar rock samples~@nasa1969as12.],
      [Apollo 12 astronaut collecting a lunar rock sample],
    ),
    image("../figures/2_background/apollo12_lunar_hand_tong.png", width: 100%),
  ) <fig:background:apollo_hand_tong>
]

More recent missions, such as the Spirit, Opportunity, and Curiosity rovers, have demonstrated progressively more sophisticated autonomous navigation and instrument placement capabilities~@grotzinger2012mars. The Perseverance rover, currently active on Mars, leverages advanced vision-based navigation to traverse challenging terrain more quickly than its predecessors~@jpl2024enabling. In orbit, the Canadarm on the Space Shuttle and its successor, Canadarm2 on the @ISS, have been crucial for satellite deployment, station assembly, and support for @EVA:pl. These systems, however, still rely heavily on human operators to guide their actions. The evolution has been one of gradual delegation. It moved from pre-programmed sequences to teleoperated control, and finally to supervised autonomy, where high-level goals are commanded from Earth~@doyle2021recent. The next logical step in this evolution is the transition to truly adaptive autonomy. This transition is the central focus of this thesis.

=== Unique Challenges of Extraterrestrial Environments <ssec:background:robotics:challenges>

The environments beyond Earth present a set of challenges that are fundamentally different from, and more severe than, those encountered in any terrestrial setting. These challenges affect every aspect of a robot's design and operation. Communication latency is a primary driver for autonomy. The round-trip communication latency to the Moon is a few seconds. This is manageable for high-level supervision but disruptive for continuous direct control. At Mars distances, real-time Earth-based teleoperation is impractical. Communication delays constrain continuous feedback but do not make teleoperation impossible for every intricate task. An unexpected event, such as a manipulator encountering an obstacle or a tool getting stuck, may require an immediate response that cannot wait for a signal from Earth.

The physical environment itself is hostile. Extreme temperature variations between illuminated and shadowed areas can cause thermal stresses on materials and electronics. Persistent exposure to cosmic and solar radiation can degrade components over time, leading to unexpected hardware failures~@dilillo2022space. This necessitates the use of radiation-hardened electronics, which are often generations behind their terrestrial counterparts in computational power. This creates a challenging paradox. The need for greater autonomy demands more onboard computation, while the environment restricts the available computational resources.

#place(top, float: true)[
  #v(-1.0em)
  #figure(
    caption: dynamic-caption(
      [The rugged landscape of Mars' Jezero Crater delta, where rovers must navigate through a hazardous mix of steep inclines, loose @regolith, and boulder fields~@nasa2022jezero.],
      [The challenging terrain of Mars' Jezero Crater delta],
    ),
    image("../figures/2_background/mars_jezero_crater_delta.png", width: 100%),
  ) <fig:background:unstructured_terrain>
]

In orbital environments, the vacuum affects heat dissipation and can lead to phenomena like cold welding. @Microgravity fundamentally alters the dynamics of all physical interactions. An object that is released does not fall but drifts, and any force exerted by a manipulator will produce an equal and opposite reaction on its spacecraft base. As illustrated in @fig:background:unstructured_terrain, planetary surfaces are often covered in fine, abrasive @regolith that can infiltrate mechanical joints, obscure sensors, and create unpredictable traction conditions for rovers. Furthermore, these environments are largely unstructured and unmapped. A robot must constantly contend with novelty and uncertainty in a domain where every component is a safety-critical asset.

#v(-0.05em)

=== Vision for Future Robotic Missions <ssec:background:robotics:vision>

The ambition of future space missions necessitates a leap in robotic capabilities. The vision extends far beyond simple exploration to encompass large-scale construction, industrial-style resource utilization, and permanent human habitation. Initiatives like @NASA's Artemis program aim to establish a sustainable human presence on the Moon. This goal relies on robots to perform preparatory work such as site surveying, habitat construction, and infrastructure deployment before the arrival of astronauts~@nasa2020artemis. A cornerstone of this vision is @ISRU~@moses2016frontier, where robots will excavate @regolith to extract resources like water ice and minerals. These resources can then be used for construction, propellant production, and life support.

In orbit, the concept of @ISAM is gaining traction~@zhihui2021review. This involves robots that can refuel and repair existing satellites to extend their operational lifespan, assemble large structures like telescopes or solar power stations from components launched separately, and even manufacture parts directly in space~@esa2023servicing @rognant2019autonomous. For deep-space exploration, a new generation of autonomous science laboratories on wheels or propellers will be needed to explore ocean worlds or methane lakes, where communication is severely limited and mission risk is high~@stonge2020planetary. The complexity of these missions may require heterogeneous teams of robots working collaboratively to achieve common goals~@schuster2020arches. In all these envisioned futures, as depicted in @fig:background:future_missions, robots are not just tools but foundational infrastructure. They will work persistently and adaptively to create and maintain a human foothold beyond Earth. This vision can only be realized if these robotic systems are endowed with a level of autonomy that far surpasses the state of the art today.

#place(top, float: true)[
  #v(-0.5em)
  #subfigure(
    gutter: 0.25em,
    figure(
      image("../figures/2_background/srb_inspection.png", height: 25%),
      caption: text(
        size: 9pt,
      )[Orbital inspection],
    ),
    <fig:background:future_missions:inspection>,
    figure(
      image("../figures/2_background/srb_gateway.png", height: 25%),
      caption: text(
        size: 9pt,
      )[Autonomous manipulation],
    ),
    <fig:background:future_missions:gateway>,
    figure(
      image("../figures/2_background/srb_perseverance.png", height: 25%),
      caption: text(
        size: 9pt,
      )[Planetary exploration],
    ),
    <fig:background:future_missions:perseverance>,
    columns: 3,
    caption: dynamic-caption(
      [The vision for future robotic missions across multiple domains.],
      [The vision for future robotic missions across multiple domains],
    ),
    label: <fig:background:future_missions>,
  )
]

== Foundation of Robot Control <sec:background:control>

The ability of a robot to perform useful work in its environment is predicated on its capacity for controlled motion. Robot control is the discipline concerned with calculating the necessary actuator commands to achieve a desired state or behavior. This section provides a brief overview of the fundamental control concepts relevant to this thesis. It focuses on the distinct but often intertwined challenges of mobility and manipulation.

=== Mobility <ssec:background:control:mobility>

Mobility refers to a robot's ability to move its entire body through an environment. For space robotics, this encompasses a wide range of platforms with vastly different control requirements that are heavily influenced by the operational domain. The approaches to achieving stable and efficient locomotion on a planetary surface are fundamentally different from those required for maneuvering in the vacuum of space.

Planetary mobility presents challenges of traction, stability, and navigation over unstructured terrain. The control of wheeled rovers often involves kinematic models like skid-steer or Ackermann steering. These models map desired chassis velocities to individual wheel speeds. Their effectiveness is complicated by the interaction with deformable terrain, a field known as @terramechanics~@zhou2014simulations. The unpredictable nature of wheel slip on loose @regolith makes precise odometry and path following a persistent challenge. Legged robots, such as quadrupeds or humanoids, offer the potential for greater mobility in extreme terrain but introduce a more complex control problem. Due to their many degrees of freedom and the need to maintain dynamic stability, their control is typically hierarchical. #box(width: 100%)[A high-level planner determines footstep locations while a low-level controller calculates the joint torques or positions required to execute stable locomotion~@gu2025humanoid. A third mode of planetary mobility is aerial. The Ingenuity helicopter on Mars demonstrated the feasibility of flight in a thin atmosphere. Its control involves precisely modulating the pitch of its rotor blades to generate the necessary lift and thrust for controlled flight, which offers a unique vantage point for reconnaissance and exploration.]

In orbital environments, mobility is governed by orbital mechanics and the principles of rocket propulsion. Spacecraft control involves the precise firing of thrusters to achieve a desired change in velocity. This is used for fundamental operations like station-keeping, trajectory correction, and orbital insertion, while more complex operations include rendezvous and docking. These tasks require an @agent to maneuver a spacecraft to approach and precisely match the full 6-#gls("DoF", long: false) pose of a target object in #gls("SE3", long: false). The challenge is magnified when the target is uncooperative, such as a piece of tumbling debris, as this requires the chasing spacecraft to predict its motion and execute a complex intercept trajectory. In all orbital maneuvers, the control problem is constrained by fuel optimization, as propellant is a finite and mission-critical resource. Across all these diverse platforms, the objective of the mobility controller is to accurately track a desired trajectory for the robot's base while navigating the specific physical constraints of its domain.

=== Manipulation <ssec:background:control:manipulation>

Manipulation involves the control of a robotic arm and its @EE to interact with objects in the environment. This is the primary focus of the complex tasks addressed in this thesis, such as assembly and excavation. The core problem of manipulator control is to move the @EE to a desired pose in space by actuating the manipulator's joints. The approaches for solving this problem can be broadly categorized into kinematic and compliant control. A quintessential example of a contact-rich manipulation task is the peg-in-hole problem. Its apparent simplicity contrasts with a complex control challenge that is fundamental to nearly all assembly operations. It has been a subject of extensive research for decades~@jasim2017contact @lee2022contact @xu2019compare.

==== Kinematic Control <sssec:background:control:manipulation:kinematic>

Kinematic control focuses on the geometry of motion without considering the forces or torques that cause it. The most common problem in this domain is @IK. Given a desired @EE pose, @IK calculates the corresponding set of joint angles required to achieve that pose. For manipulators with many #gls("DoF", long: true, plural: true), there can be multiple or even infinitely many solutions to this problem.

A common approach for real-time control is differential @IK, which relates @EE velocities to joint velocities through a matrix known as the @Jacobian~@beeson2015tracik. By (pseudo-)inverting the @Jacobian, a controller can compute the necessary joint velocities to achieve a desired @EE velocity. This method forms the basis for many standard robot control interfaces. However, a key limitation of purely kinematic control is its rigidity. It commands the robot to achieve a specific position or velocity without regard for external forces. If the robot's path is obstructed or it makes an unexpected contact, a rigid kinematic controller will continue to drive the motors. This can potentially generate large forces that could damage the robot or its environment. This brittleness makes it ill-suited for tasks involving contact-rich interactions in unstructured settings, a limitation that became evident in the foundational study of this thesis, @pub:orsula2022learning.

==== Compliant Control <sssec:background:control:manipulation:compliant>

Compliant control addresses the limitations of rigid kinematic control by allowing a robot to safely interact with its environment. Instead of commanding a strict position, a compliant controller specifies a relationship between the robot's position and the external forces it experiences. This enables the robot to adjust its control when it encounters resistance. This mimics the natural @compliance of human motion.

One powerful framework for implementing compliant behavior is @OSC~@khatib1987osc, which formulates the control problem directly in the robot's @task-space. It allows the designer to specify the desired dynamic behavior of the @EE as if it were a mass-spring-damper system. By setting the controller gains for @stiffness and @damping, one can define how the @EE should react to external forces. Low @stiffness allows the robot to be very compliant and easily moved by external contacts, whereas high @stiffness makes it behave more rigidly. @OSC provides a principled way to manage forces during interaction. This makes it highly suitable for contact-rich tasks like assembly and excavation. As explored in @pub:orsula2025learningtool, this thesis demonstrates that the ability to dynamically modulate these @compliance parameters through @MBRL provides a powerful mechanism for achieving adaptive and robust manipulation~@peters2006learning @wong2022oscar.

== Paradigm of Robot Learning <sec:background:learning>

Robot learning is a subfield of machine learning that focuses on endowing robots with the ability to acquire new skills and adapt their behavior through experience~@kroemer2021review. It represents a fundamental departure from traditional programming, where a behavior is explicitly defined by a human engineer. Instead of following a fixed set of instructions, a learning robot improves its performance over time by interacting with its @environment or by observing demonstrations. This paradigm is particularly well-suited for the unstructured and unpredictable domain of space, as it is impossible to pre-program a robot for every possible contingency.

=== Markov Decision Process <ssec:background:learning:mdp>

Many problems in robot learning are formalized using the mathematical framework of the #gls("MDP", long: true)~@sutton2018reinforcement. An @MDP provides a model for sequential decision-making in an @environment where outcomes are at least partially under the control of an @agent. An @MDP is defined by a set of states $cal(S)$, a set of actions $cal(A)$, and a set of rewards $cal(R)$. The dynamics of the @MDP are defined by a probability distribution $p$:

$
  p(s', r | s, a)
$ <eq:background:dynamics>

This function specifies the probability of transitioning to state $s'$ and receiving reward $r$, given that the @agent was in state $s$ and took action $a$. Throughout, capital letters such as $S_t$, $A_t$, $R_t$, and $G_t$ denote random variables, while lowercase letters denote their specific values.

#block(breakable: false, width: 100%)[
  The @agent's goal is to learn a @policy, denoted as $pi(a | s)$, which defines a mapping from states to probabilities of selecting each possible action. The objective is to find an optimal @policy $pi^*$ that maximizes the expected cumulative sum of future rewards, known as the return. For a continuing task, the discounted return at timestep $t$ is defined as:
]

$
  G_t = sum_(k=0)^infinity gamma^k R_(t+k+1)
$ <eq:background:return>

where $gamma in [0, 1)$ is the discount factor. This factor determines the present value of future rewards. Values closer to 0 prioritize immediate rewards while values closer to 1 emphasize long-term gains. The core assumption is the Markov property, which states that the state $S_t$ provides all necessary information for the @agent to make an optimal decision, independent of the history of states, actions, and rewards that came before it. For example, in a robotic manipulation task, the full state might include the precise joint angles and velocities of the arm, the poses and velocities of all objects in the scene, and their mutual interaction forces.

However, in many real-world robotics problems, the @agent does not have access to the complete state of the @environment. This situation is known as partial observability and is more accurately described by a @POMDP. A @POMDP extends the @MDP with a set of observations and an observation probability distribution $O(o | s', a)$. This gives the probability of receiving observation $o$ after the @agent took action $a$ and the @environment transitioned to state $s'$. In a @POMDP, the @agent receives an observation, such as an image from a camera, which may be a noisy or incomplete representation of the true state. It must often rely on a history of past observations to infer the underlying state and make informed decisions, a core challenge addressed in @pub:orsula2024leveraging.

=== Reinforcement Learning <ssec:background:learning:rl>

#gls("RL", long: true, capitalize: true) is a learning paradigm centered on the @MDP framework. It is concerned with how an intelligent @agent should take actions in an @environment to maximize cumulative reward, without being explicitly told which actions to take~@sutton2018reinforcement. The learning process is driven by trial and error. The @agent explores the @environment by taking actions and observing the resulting states and rewards. It uses this feedback to update its @policy in an effort to maximize expected return. Whether learning converges, and to what solution, depends on the algorithm and its assumptions; convergence to an optimal strategy is not guaranteed for deep @RL in general. The fundamental interaction loop of @RL is depicted in @fig:background:rl_loop.

#figure(
  caption: dynamic-caption(
    [The fundamental interaction loop of @RL. The @agent takes an action in the @environment, which transitions to a new state and emits a reward. The @agent uses this information to update its @policy and inform future actions.],
    [The interaction loop of reinforcement learning],
  ),
  image("../figures/2_background/rl_loop.svg", width: 65%),
) <fig:background:rl_loop>

Modern @RL algorithms are often combined with deep neural networks as function approximators, giving rise to the field of deep @RL. This allows @agent:pl to learn complex @policy:pl directly from high-dimensional sensory inputs and to control robots with high-dimensional action spaces. Many prominent deep @RL algorithms employ an @actor-critic architecture, illustrated in @fig:background:actor_critic. In this setup, an actor network learns a parameterized @policy $pi_theta (a | s)$, while a critic network learns a @value-function to evaluate the actor's actions by estimating their long-term value. One common
@value-function is the action-value function, which estimates the expected return for taking action $a$ in state $s$ and thereafter following @policy $pi$:

$
  q_pi (s, a) = E_pi [G_t | S_t = s, A_t = a]
$ <eq:background:q_function>

The critic, with parameters $phi$, learns an approximation $q_phi (s, a) approx q_pi (s, a)$. Its evaluation is then used to update the actor's parameters $theta$, typically by moving them in the direction of improved performance.

The algorithms can be broadly categorized as model-free or model-based. Model-free algorithms learn a @policy and/or a @value-function directly from experience without explicitly learning a model of the @environment's dynamics. They are often robust and can achieve high performance. Prominent model-free methods include @on-policy algorithms like @PPO~@schulman2017proximal, known for their training stability, and @off-policy algorithms like @TD3~@fujimoto2018addressing and @SAC~@haarnoja2018soft, which often exhibit greater @sample-efficiency. However, a common drawback of model-free approaches is that they can require millions or even billions of environment interactions to learn a complex task.

#figure(
  caption: dynamic-caption(
    [The interaction loop of @actor-critic @RL. The actor (policy) selects an action, and the critic (@value-function) evaluates the quality of that action. The critic's feedback is then used to update the actor, guiding it toward more rewarding behaviors.],
    [The interaction loop of actor-critic reinforcement learning],
  ),
  image("../figures/2_background/actor_critic_loop.svg", width: 65%),
) <fig:background:actor_critic>
==== Model-Based Reinforcement Learning <sssec:background:learning:rl:model_based>

#gls("MBRL", long: true, capitalize: true) approaches aim to improve @sample-efficiency by employing a model of the @environment's dynamics alongside the @policy~@polydoros2017survey. A learned @world-model, parameterized by~$psi$, is a function $p_psi$ that approximates the true dynamics $p$ of the @MDP:

$
  (s', r) tilde p_psi (dot | s, a)
$ <eq:background:world_model>

This learned model acts as a surrogate for the real @environment. It allows the @agent to predict the consequences of its actions without having to physically execute them. The @agent can use this model for planning or to generate large quantities of simulated experience to train its @policy, as illustrated in @fig:background:mbrl_loop. Research in the area of @MBRL has demonstrated significant gains in data efficiency on robotic control problems through algorithms like PILCO~@deisenroth2011pilco.
Modern algorithms like @DreamerV3 have demonstrated remarkable success by learning a compact model of the world in @latent-space directly from high-dimensional observations~@hafner2025mastering. The @agent can then learn a @policy entirely within the imagined trajectories of its learned model. This process can be significantly faster and more data-efficient than interacting with the real or even a simulated @environment. This ability to learn a predictive @world-model is particularly promising for space robotics. It provides a mechanism for planning and reasoning that is crucial for tackling complex, long-horizon tasks. This thesis heavily leverages the @MBRL paradigm due to its potential for efficient learning and its inherent suitability for adaptation.

#figure(
  caption: dynamic-caption(
    [The interaction loop of @MBRL. The @agent learns a @world-model from real-world interactions. It then uses this model for planning or to generate imagined trajectories, which are used to efficiently update the @policy without requiring further real-world interaction.],
    [The interaction loop of model-based reinforcement learning],
  ),
  image("../figures/2_background/rl_loop_model_based.svg", width: 65%),
) <fig:background:mbrl_loop>
=== Learning from Demonstration <ssec:background:learning:demonstration>

While @RL offers a powerful framework for discovering behaviors through exploration, the process can be slow and undirected, especially for tasks with sparse rewards or complex action spaces where successful outcomes are rare. #gls("LfD", long: true, capitalize: true) provides an alternative or complementary approach that leverages existing data to accelerate and guide the learning process~@osa2018algorithmic. Instead of relying solely on trial and error, the @agent learns by observing how a task should be performed. This data can be collected from human @teleoperation, scripted @policy:pl, or the rollouts of a previously trained @agent.

==== Imitation Learning <sssec:background:learning:demonstration:imitation>

The most direct form of @LfD is @IL. In this paradigm, the problem is framed as a supervised learning task where the @agent learns a @policy that mimics the actions of an expert. The simplest approach, @BC, trains a @policy to map states to actions from expert trajectories. Despite its simplicity, @BC has been successfully applied to complex robotic manipulation tasks~@zhang2018deep. Several works have also combined it with @RL to learn contact-rich assembly skills~@cho2020learning @wang2023learning.

While straightforward, @BC can suffer from issues like covariate shift. This occurs when small errors in the learned @policy cause the @agent to drift into states not seen in the expert data. Once off the expert's trajectory, the @agent has no data to guide its recovery, which often leads to compounding failures. More advanced @IL methods exist to mitigate this issue. For example, some techniques involve querying the expert for corrective actions from states the @agent has visited. A fundamental constraint of pure @IL remains. The learned @policy's performance is ultimately bounded by the quality and coverage of the expert demonstrations. The @agent can only learn to replicate what it has seen and cannot discover novel or better strategies on its own.

==== Offline Reinforcement Learning <sssec:background:learning:demonstration:offline_rl>

#gls("offline-RL", long: true, capitalize: true) bridges the gap between @RL and @IL. It aims to learn a @policy from a fixed, pre-existing dataset of transitions without any further interaction with the @environment. Unlike pure @IL, it does not assume that the data comes from an expert. The dataset can be a mix of optimal, suboptimal, and purely random behaviors. @Offline-RL algorithms use dynamic programming or model-based methods to stitch together the best parts of the trajectories in the dataset. This allows them to learn a @policy that can potentially outperform the best trajectory seen in the data.

This paradigm is highly relevant for space robotics, where online data collection is expensive or dangerous. The primary challenge in @offline-RL is distributional shift. This occurs when the learned @policy favors out-of-distribution actions for which the
@value-function is poorly estimated, often leading to erroneously high value estimates. Modern @offline-RL algorithms mitigate this issue using various forms of @policy constraints or conservatism. This ensures the @agent primarily utilizes actions and states that are well-supported by the dataset. The progress in this area is fueled by the availability of large-scale robotics datasets~@openx2023embodiment. Although not investigated in this work, the capability of @SRB to collect teleoperated data and record trajectories from trained @RL @agent:pl provides the necessary infrastructure for future research into creating similar datasets for the space domain.

=== Sim-to-Real Challenge <ssec:background:learning:sim_to_real>

A central premise of this thesis is that simulation provides a practical and scalable @environment for training the complex robotic skills required for space. Yet real-world applicability is the ultimate goal. This reliance on simulation introduces a fundamental obstacle known as the @sim-to-real gap. This gap refers to the discrepancy between the simulated @environment and the real world, as illustrated in @fig:background:sim_to_real_gap from @pub:orsula2022learning. A simulation is always an approximation of reality, no matter how high its fidelity. Differences in visual appearance, object dynamics, friction, sensor noise, and actuator behavior can cause a @policy that performs perfectly in simulation to fail completely when deployed on a physical robot. Bridging this @sim-to-real gap is one of the most significant challenges in modern robot learning research.

#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [A conceptual illustration of the @sim-to-real gap, taken from the foundational study of @pub:orsula2022learning. A @policy trained exclusively in a simulation domain may fail when deployed in the real world due to discrepancies in physics, visuals, and other unmodeled effects.],
      [The sim-to-real gap between simulation and reality],
    ),
    image("../figures/2_background/sim_and_real.svg", width: 100%),
  ) <fig:background:sim_to_real_gap>
]

==== Domain Adaptation <sssec:background:learning:sim_to_real:adaptation>

Domain adaptation techniques aim to make the simulation more closely resemble the real world or to make the learned @policy less sensitive to the differences between the two~@bousmalis2018using. This can involve a range of methods. For example, system identification can be used to measure the physical parameters of a real robot and its @environment, such as joint friction or actuation delays. These parameters can then be used to fine-tune the simulator's physics engine. Other approaches involve fine-tuning a @policy that was pre-trained in simulation with a small amount of data collected from the real world. While these methods can be effective, they often require access to the target real-world domain during the training process. This dependency on real-world data makes them challenging to apply in space robotics, where the target @environment is remote, poorly characterized, and largely inaccessible.

#v(-0.5em)

==== Domain Randomization <sssec:background:learning:sim_to_real:randomization>

#gls("DR", long: true, capitalize: true) takes a different approach. Instead of trying to create a perfect replica of one specific real-world scenario, it aims to make the simulation so diverse that the real world appears to the @policy as just another variation~@tobin2017domain. This is achieved by systematically adjusting the simulation parameters during training, as shown in @fig:background:domain_randomization. @DR can include varying visual aspects like lighting, textures, and camera perspectives. It also includes randomizing physical properties like inertia, friction coefficients, and actuator dynamics.

#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [An example of @DR, where each training @episode features a unique combination of graspable object models, textures, and illumination conditions. This encourages the @agent to learn a generalizable grasping strategy~@orsula2021deep.],
      [An example of domain randomization],
    ),
    image("../figures/2_background/domain_randomization.png", width: 100%),
  ) <fig:background:domain_randomization>
]

By exposing the @agent to a vast range of conditions, @DR is intended to encourage the @policy to become robust to these variations. Its empirical benefit depends on whether the randomized conditions capture relevant variations in the target @environment. The @agent may learn to ignore superficial and irrelevant features of the @environment and instead focus on the underlying physical principles required to solve the task. This process can act as a form of implicit regularization that discourages the @policy from @overfit:pl to simulation-specific artifacts. More advanced techniques allow the @agent to learn to make the simulation more challenging for itself, which can further enhance robustness~@mehta2019active. Although domain knowledge is beneficial, this approach does not require any data from the target real-world @environment. It is thus highly suitable for space applications where conditions are unpredictable. The methodology in this thesis relies heavily on @DR as a core strategy for pursuing robust @generalization.

== Ecosystem of Robotics Simulation <sec:background:simulation>

The development and validation of robotic systems are increasingly dependent on simulation. Simulators provide a safe, cost-effective, and scalable @environment for prototyping algorithms, training learning-based @agent:pl, and testing system behavior under a wide range of conditions. This section surveys the landscape of available robotics simulators, discusses the transformative potential of procedural generation, and highlights the critical role of standardized benchmarks in the advancement of the field.

#show footnote.entry: it => {
  layout(size => context v(-measure(it, ..size).height + 0.125em))
}
#set page(footer-descent: 0%, footer: context {
  let footnotes = query(footnote).filter(x => {
    x.location().page() == here().page()
  })
  set text(9pt)
  set block(below: footnote.entry.gap)
  show: columns.with(2)
  for chunk in footnotes.chunks(calc.max(1, int(footnotes.len() / 2))) {
    for x in chunk {
      show: block
      h(footnote.entry.indent)
      let n = super(numbering(
        x.numbering,
        ..counter(footnote).at(x.location()),
      ))
      link(x.location(), n)
      h(0.05em)
      x.body
    }
    colbreak()
  }
})

=== Proprietary and Open-Source Landscape <ssec:background:simulation:landscape>

The ecosystem of robotics simulation is diverse. It encompasses both proprietary commercial software and community-driven open-source projects. Each category presents distinct advantages and trade-offs. Open-source simulators like Gazebo~@koenig2004design and physics engines such as MuJoCo~@todorov2012mujoco and DART~@lee2018dart offer great flexibility, transparency, and accessibility. They allow researchers to modify and extend the software to suit their specific needs, which fosters a collaborative development environment. However, they have sometimes lagged behind their commercial counterparts in terms of rendering fidelity and computational performance.

#v(-1.0em)

In recent years, the line between these two categories has begun to blur. Powerful platforms have emerged that blend proprietary core technology with open access and @API:pl for the research community. @Isaac-Sim, the platform upon which the framework in this thesis is built, is a prominent example. It provides GPU-accelerated physics and @PBR capabilities that were largely exclusive to high-end proprietary software while also offering an extensible Python-based workflow. This shift has been instrumental in democratizing access to high-fidelity simulation. A comparison of several prominent simulators is provided in @tab:background:simulators.

#place(bottom, float: true)[
  #v(-2em)
  #figure(
    table(
      align: (left + horizon, left + horizon, left + horizon),
      columns: 3,
      table.header(
        [Simulator],
        table.cell(align: center)[*Key Strengths*],
        table.cell(align: center)[*Primary Limitations*],
      ),

      [CoppeliaSim#footnote(link("https://coppeliarobotics.com"))],
      [
        - User-friendly
      ],
      [
        - Not optimized for scalability
        - Lower visual and physics fidelity
      ],

      [Drake#footnote(link("https://drake.mit.edu"))],
      [
        - High-fidelity physics
        - Excellent for model-based control
      ],
      [
        - Not optimized for scalability
      ],

      [Gazebo#footnote(link("https://gazebosim.org"))],
      [
        - Large community
        - Close @ROS integration
      ],
      [
        - Not optimized for scalability
      ],

      [Isaac Sim#footnote(link("https://developer.nvidia.com/isaac/sim"))],
      [
        - Scalable
        - Realistic rendering
      ],
      [
        - Vendor-locked hardware requirements
      ],

      [MuJoCo#footnote(link("https://mujoco.org"))],
      [
        - Scalable
        - High-fidelity physics
      ],
      [
        - Lower visual fidelity
      ],

      [PyBullet#footnote(link("https://pybullet.org"))],
      [
        - User-friendly
        - Lightweight
      ],
      [
        - Lower visual fidelity
      ],

      [SAPIEN#footnote(link("https://sapien.ucsd.edu"))],
      [
        - Scalable
        - Realistic rendering
      ],
      [
        - Not general enough
      ],

      [Unity#footnote(link("https://unity.com"))],
      [
        - Large community
        - Realistic rendering
      ],
      [
        - High integration effort for robotics
      ],

      [Unreal Engine#footnote(link("https://unrealengine.com"))],
      [
        - Large community
        - Realistic rendering
      ],
      [
        - High integration effort for robotics
      ],

      [Webots#footnote(link("https://cyberbotics.com"))],
      [
        - User-friendly
      ],
      [
        - Not optimized for scalability
        - Lower visual fidelity
      ],
    ),
    caption: dynamic-caption(
      [A comparison of prominent robotics simulators and game engines, qualitatively evaluating each platform in the context of developing learning-based autonomous systems.],
      [A comparison of robotics simulators],
    ),
  ) <tab:background:simulators>
  #v(-0.5em)
]

Despite the capabilities of these general-purpose platforms, they exhibit a profound terrestrial bias. Consequently, the challenge lies not merely in selecting a simulator but in constructing a domain-specific framework that leverages high-performance physics and rendering to generate the massive, diverse, and physically accurate experience that is essential for bridging the @sim-to-real gap prevalent in space robotics.

=== Space Simulation Frameworks <ssec:background:simulation:space_frameworks>

Simulation is a cornerstone of space mission development, traditionally used for high-fidelity verification of astrodynamics via tools like GMAT~@hughes2014verification and Basilisk~@kenneally2020basilisk. However, space robotics introduces challenges that require physically realistic models of contact dynamics and complex terrains. To meet these needs, a new generation of specialized simulators has emerged, often developed by space agencies for specific missions, such as VIPER RSIM~@stukes2021innovative or Astrobee Sim~@coltin2019astrobee.

#v(-0.5em)

These mission-specific simulators are invaluable for their intended purpose of @VandV but are ill-suited for the broader needs of robot learning research. They are designed to model a static, singular reality with maximum fidelity, which is misaligned with the massive data generation and environmental diversity required by modern learning algorithms. In response, the research community has developed several learning-focused simulators for specific domains, including rover navigation~@mortensen2024rlroverlab, spacecraft rendezvous~@el2023rans, and orbital manipulation~@wang2022collision. While these platforms are crucial steps forward, they are often tightly coupled to their original research objectives and a single robotic platform, making it difficult to study @generalization across different robots or applications. @tab:background:simulator_comparison summarizes this diverse landscape. @SRB is designed for multi-domain autonomy with a focus on high scalability and extensibility, enabled by its combined @PCG and @DR approach for the @sim-to-real challenge.

#place(bottom + center, float: true)[
  #v(-1em)
  #figure(
    table(
      columns: 5,
      align: (left, left, center, center, center),
      table.header(
        [Simulator], [Primary Focus], [Sim-to-Real], [Scalability], [Gymnasium]
      ),

      [GMAT @hughes2014verification],
      [Orbital Mechanics],
      [Digital Twin],
      [Low],
      [No],

      [Basilisk @kenneally2020basilisk],
      [Orbital Mechanics],
      [Digital Twin],
      [Medium],
      [#h(6.5mm)Yes @stephenson2024bskrl],

      [VIPER RSIM @stukes2021innovative],
      [Rover @VandV],
      [Digital Twin],
      [Low],
      [No],

      [Astrobee Sim @coltin2019astrobee],
      [Free-Flyer @VandV],
      [Digital Twin],
      [Low],
      [No],

      [Int-Ball2 Sim @Hirano2025IntBall2],
      [Free-Flyer @VandV],
      [Digital Twin],
      [Low],
      [No],

      [HeliCAT-DARTS @largescale2024heli],
      [Rotorcraft @VandV],
      [Digital Twin],
      [Low],
      [No],

      [EELS-DARTS @hardeers2024eelsdarts],
      [Snake Robot @VandV],
      [Digital Twin],
      [Low],
      [No],

      [OmniLRS @antoine2024omnilrs],
      [Planetary Navigation],
      [Photorealism],
      [Medium],
      [No],

      [RLRoverLAB @mortensen2024rlroverlab],
      [Planetary Navigation],
      [@DR],
      [High],
      [Yes],

      [RANS @el2023rans], [Spacecraft Navigation], [@DR], [High], [Yes],

      [SpaceRobotEnv @wang2022collision],
      [Orbital Manipulation],
      [@DR],
      [Low],
      [Yes],

      [GraspPlanetary (@pub:orsula2022learning)],
      [Planetary Manipulation],
      [@DR+@PCG],
      [Low],
      [Yes],

      [@SRB (@pub:orsula2025space)], [Multi-Domain], [@DR+@PCG], [High], [Yes],
    ),
    caption: dynamic-caption(
      [A comparison of existing space simulation frameworks.],
      [A comparison of existing space simulation frameworks],
    ),
  ) <tab:background:simulator_comparison>
]
=== Power of Procedural Content Generation <ssec:background:simulation:pcg>

A key technique for enhancing the diversity and scalability of simulation @environment:pl is #gls("PCG", long: true), which encompasses a set of algorithms for creating data automatically rather than manually. While widely adopted in the gaming industry to create vast and varied game worlds, its application in robotics simulation is still emerging. Traditionally, robotics simulation @environment:pl have been built using manually created assets. This limits their variety and makes the creation of large-scale, diverse scenarios a labor-intensive process.

@PCG offers a solution to this bottleneck. By using parametric pipelines, a near-infinite number of unique 3D assets can be generated on demand. This approach is not only efficient but also enables a level of environmental diversity that is unattainable through manual design. As argued throughout this thesis, diversity is a critical requirement for training truly generalizable robot learning @policy:pl~@cobbe2020leveraging. By forcing the @agent to succeed across a wide distribution of scenarios, @PCG effectively regularizes the learned @policy and prevents it from @overfit:pl to simulation-specific artifacts. Furthermore, @PCG can be used to facilitate curriculum learning, where the complexity of the generated content is gradually increased to guide the @agent's learning process from simple to more challenging tasks~@narvekar2020curriculum. The pipeline used in this thesis leverages @Blender's Geometry Nodes to create a flexible and powerful system for on-demand asset creation, as introduced in @pub:orsula2025advancing.

=== Role of Benchmarks in Driving Progress <ssec:background:simulation:benchmarks>

Standardized benchmarks have played a crucial role in accelerating progress in machine learning. A benchmark provides a common set of tasks, @environment:pl, and evaluation metrics that allow researchers to directly compare the performance of their algorithms in a reproducible manner. This is particularly important in @RL, where subtle differences in implementation can lead to significant variations in results, making reproducibility a persistent challenge~@henderson2018deep.

In robotics, benchmarks like RLBench~@james2020rlbench, Meta-World~@yu2020meta, ManiSkill3~@tao2024maniskill3, robosuite~@zhu2020robosuite, and RoboHive~@kumar2023robohive have been instrumental in advancing research in terrestrial manipulation. Other benchmarks have focused on more specialized domains, such as long-horizon assembly in FurnitureBench~@heo2023furniturebench, dexterous manipulation with RoboPianist~@zakka2023robopianist, and humanoid locomotion via HumanoidBench~@sferrazza2024humanoidbench. While invaluable, these existing benchmarks are Earth-centric. They do not capture the unique challenges of space robotics, such as @microgravity dynamics, unstructured planetary terrains, or the specific tasks relevant to space missions. #box(width: 100%)[This highlights a critical gap in the available tools for the community, a gap that @pub:orsula2025space aims to fill. The development of a dedicated, open-source benchmark for space robotics is therefore a primary motivation for this thesis.]

== Synthesis and Research Gap <sec:background:gap>

The preceding sections have traced the parallel and intersecting paths of space robotics, robot control, and robot learning. The synthesis of these fields reveals a clear and compelling need for a new approach to developing autonomous systems for space. The vision for future space exploration demands robots with a high degree of adaptive autonomy. Traditional control methods lack the necessary robustness for unstructured and remote environments. Robot learning, particularly deep @MBRL, offers a promising paradigm for acquiring the required adaptive behaviors. However, its application to space robotics is severely hampered by the @sim-to-real challenge and the unique constraints of the domain.

This review of the state of the art exposes a critical research gap. The space robotics community has developed high-fidelity simulators but lacks an open platform designed for the data-intensive needs of modern robot learning~@hughes2014verification @kenneally2020basilisk. The robot learning community has produced powerful algorithms and benchmarks but has focused on terrestrial applications that do not capture the unique physics of space~@james2020rlbench @heo2023furniturebench. There is a clear need for a bridge between these two worlds.

This thesis aims to fill this gap by addressing three specific deficiencies. First, there is a lack of a comprehensive, open-source benchmark for robot learning in space that integrates diverse, procedurally generated @environment:pl with high-fidelity physics. Second, there is insufficient understanding of how to best train @agent:pl for robust @generalization in contact-rich manipulation tasks, particularly with respect to learning compliant behaviors. Third, there is no systematic evaluation of state-of-the-art learning algorithms against a standardized suite of space-relevant tasks. This work directly confronts these issues by developing the necessary simulation infrastructure and a novel learning methodology to advance the state of adaptive autonomy for robots beyond Earth.
