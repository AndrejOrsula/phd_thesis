#import "../utils/all.typ": *

= Empirical Validation#dynamic-caption("", ": Case Studies") <ch:validation>

The preceding chapters have established the theoretical foundations, developed the simulation framework, and formulated a blueprint for achieving adaptive autonomy. This chapter now moves from principles to practice to provide an empirical validation of the proposed system. Its purpose is to demonstrate, through a series of in-depth case studies, that the integrated framework of @SRB and the adaptive control methodology can successfully solve a range of challenging, mission-relevant tasks.

This validation is not a simple measure of task success under a single set of conditions. Instead, each scenario is designed to specifically probe the key capabilities central to this thesis, namely @generalization, adaptation, and robustness in the face of uncertainty. By leveraging the full power of @PCG and @DR within @SRB, these experiments are designed to answer the critical question of whether the proposed methodology produces @agent:pl that can reliably perform complex tasks not just in a familiar setting, but across a wide distribution of previously unseen @environment:pl and configurations.

The chapter will present detailed results for three distinct scenarios, each chosen to highlight a different aspect of adaptive autonomy. The first case study provides a complete @sim-to-real validation of adaptive traversal on unstructured terrain. The second study delves into the complexities of contact-rich interaction through tool-aware resource excavation. The final study offers a unique validation of the core diversity principle in a competitive, high-speed, and adversarial domain. The quantitative results and qualitative behaviors observed in these experiments provide the evidence supporting the core claims of this thesis, showcasing the practical effectiveness of the developed framework in preparing autonomous systems for the unpredictable challenges of space.

== Adaptive Traversal on Unstructured Terrain <sec:validation:traversal>

Reliable autonomous navigation across the unstructured terrains of distant planetary surfaces is a critical enabler for future space exploration. This first and most comprehensive case study physically validates the adaptive traversal pipeline, from simulation training to deployment on a rover. It details the successful development and deployment of a robust control @policy for dynamic waypoint tracking on challenging granular surfaces, as presented in @pub:orsula2025sim2dust.

The core hypothesis of this validation is that policies trained with extensive procedural diversity can be transferred zero-shot to a physical rover and achieve robust, high-performance navigation to successfully bridge the @sim-to-real gap for a task dominated by complex contact dynamics. The @sim-to-real experiment, conceptually outlined in @fig:validation:traversal:concept, leverages the full capabilities of @SRB. It uses massively parallel simulation to train @RL @agent:pl across a vast distribution of procedurally generated @environment:pl with randomized physics. Furthermore, it explores the benefits of high-fidelity particle simulation for modeling granular media. The resulting @policy:pl are then deployed directly without any real-world fine-tuning onto a physical wheeled rover operating in the LunaLab, which is a lunar-analog facility filled with basalt gravel that was also used in @ch:foundation.

#v(-0.5em)

#figure(
  caption: dynamic-caption(
    [The conceptual parallel for the adaptive traversal case study from @pub:orsula2025sim2dust, where @agent:pl are trained in @SRB to track dynamic waypoints across diverse, procedurally generated scenarios. The @generalization learned from this experience enables the acquired policies to transfer to a physical rover operating on granular media in a lunar-analog facility.],
    [Conceptual workflow for the adaptive traversal case study],
  ),
  image("../figures/6_validation/sim2dust_concept.svg", width: 100%),
) <fig:validation:traversal:concept>

=== Experimental Setup and Methodology <ssec:validation:traversal:methodology>

The validation was built upon an integrated framework combining a powerful simulation @environment for training, a realistic physical testbed for evaluation, and a mission-relevant control task.

==== Simulation Framework and Training Regimes

All @policy development occurred within @SRB. The primary training methodology leveraged the massive parallelization capabilities of the framework, running 512 @environment instances on rigid surfaces simultaneously to generate the vast amount of experience required for @RL. To test the core hypothesis of this thesis, two distinct training regimes were explored, as illustrated in @fig:validation:traversal:sim_regimes:
- The *Stacked* regime served as a baseline representing a more traditional approach. All parallel @environment instances were trained on the same specific @PCG terrain. This setup risks @policy @overfit:pl to the specific features of that one scenario.
- The *Procedural* regime, embodying the core philosophy of this thesis, provided each of the 512 parallel @environment instances with its own unique @PCG terrain. This was designed to force the @agent to learn a generalizable navigation strategy, rather than memorizing paths on a single map.

#v(-0.75em)

#subfigure(
  gutter: 0.25em,
  columns: 2,
  figure(
    image("../figures/6_validation/sim2dust_sim_stacked.png", width: 100%),
    caption: text(
      size: 9pt,
    )[Stacked regime],
  ),
  figure(
    image("../figures/6_validation/sim2dust_sim_diverse.png", width: 100%),
    caption: text(
      size: 9pt,
    )[Procedural regime],
  ),
  caption: dynamic-caption(
    [Parallel simulation regimes of @SRB. In the stacked regime, all @agent:pl share a single static terrain, risking @overfit:pl. In the procedural regime, each parallel @environment instance is exposed to a unique terrain to foster @generalization.],
    [Comparison of training regimes in SRB],
  ),
  label: <fig:validation:traversal:sim_regimes>,
)

Beyond this structural diversity, extensive @DR was employed to enhance @policy robustness. At the start of each training @episode, key parameters were varied, including the gravity vector and small offsets of the rover's base frame to account for manufacturing variations. Crucially, randomized noise and variable delays were injected into both actions and observations to build resilience to the unpredictable latencies and sensor inaccuracies inherent in a physical system. The experimental framework also supports a high-fidelity physics mode, shown in @fig:validation:traversal:sim_particles, which models the granular media as millions of discrete particles. Due to its computational expense, this mode was reserved for a specialized fine-tuning experiment.

#v(-0.75em)

#figure(
  caption: dynamic-caption(
    [High-fidelity simulation @environment with millions of discrete particles used for fine-tuning. This setup provides a more realistic model of wheel--regolith interaction dynamics.],
    [Simulation with high-fidelity particle physics],
  ),
  image("../figures/6_validation/sim2dust_sim_with_particles.png", width: 100%),
) <fig:validation:traversal:sim_particles>

==== Physical Testbed and Task Formulation

All real-world validation was conducted in the LunaLab, a lunar-analog facility at the University of Luxembourg containing 20 tons of basalt gravel that emulates the properties of @regolith~@ludivig2020building. The robotic platform was the Leo Rover, a four-wheeled skid-steer mobile robot, shown in @fig:validation:traversal:lunalab_setup. For ground-truth localization, an OptiTrack motion capture system was used. This was a critical methodological choice, as it supplied the high-frequency pose data needed for both real-time control and post-experiment analysis, allowing for the evaluation of the @policy's performance independent of any potential state estimation errors.

#pagebreak()

The @agent's objective was to master dynamic waypoint tracking, formulated as a @POMDP. The @policy operated at 25~Hz, receiving the relative 2D position and yaw to the target and outputting linear and angular velocity commands. The @reward-function was carefully shaped to encourage a sequence of behaviors. It combined a continuous penalty on distance to guide the general approach, rewards for precise alignment that became dominant near the target, and penalties on large action changes to encourage smooth and stable tracking.

#v(-0.75em)

#figure(
  caption: dynamic-caption(
    [The real-world validation setup in the LunaLab facility with a Leo Rover.],
    [The real-world validation setup in the LunaLab facility with a Leo Rover],
  ),
  image("../figures/6_validation/sim2dust_lunalab_capsule.png", width: 100%),
) <fig:validation:traversal:lunalab_setup>

=== Algorithmic Comparison and Selection <ssec:validation:traversal:algos>

The investigation first identified the most suitable @RL algorithm for @zero-shot-transfer in this dynamic control task. Four algorithms spanning three paradigms were evaluated: @on-policy @PPO, a recurrent variant of @PPO with a @LSTM~@hochreiter1997long network, @off-policy @TD3, and model-based @DreamerV3. Each @agent was trained for its prescribed number of steps using 512 unique parallel @environment:pl in the procedural regime to ensure a fair test of @generalization. The learning curves from simulation, shown in @fig:validation:traversal:learning_curves, provided the first piece of evidence. @DreamerV3 demonstrated vastly superior @sample-efficiency, converging to a higher and more stable final episodic return in only 20 million steps, compared to the 100 million steps required by the model-free @agent:pl.

#figure(
  caption: dynamic-caption(
    [Learning curves of the evaluated @RL algorithms from @pub:orsula2025sim2dust. The results are averaged over five random seeds, with shaded regions representing the standard deviation. @DreamerV3 demonstrates superior @sample-efficiency and achieves a higher final return.],
    [Learning curves of RL algorithms on the dynamic waypoint tracking task],
  ),
  image("../figures/6_validation/sim2dust_learning_curves.svg", width: 90%),
) <fig:validation:traversal:learning_curves>

This simulated performance translated directly to the physical world. The quantitative @sim-to-real results, presented in @tab:validation:traversal:algos, decisively confirm the superiority of the @DreamerV3 @agent. It achieved a substantially lower @ATE across all tested velocities, often less than one quarter of the corresponding values for its model-free counterparts. While @PPO offered the lowest inference latency, a critical consideration for resource-constrained flight hardware, the vastly superior real-world tracking performance of @DreamerV3 made it the clear choice for this mission-critical application. The training and evaluation were conducted on a workstation with an AMD Ryzen~9~7950X CPU and an NVIDIA~RTX~4090 GPU. While this high-performance hardware acceleration is not yet space-qualified, this limitation is being continuously addressed by rapid advancements in onboard computing~@felix2024total.

#figure(
  table(
    columns: 5,
    align: (left, center, center, center, center),
    table.header([], [*PPO*], [*PPO (LSTM)*], [*TD3*], [*DreamerV3*]),

    [$5$ cm/s],
    [$13.2$ cm | $7.8degree$],
    [$11.4$ cm | $4.8degree$],
    [$12.6$ cm | $8.5degree$],
    [*$2.3$ cm | $1.7degree$*],

    [$15$ cm/s],
    [$13.7$ cm | $8.6degree$],
    [$11.2$ cm | $8.1degree$],
    [$11.6$ cm | $6.2degree$],
    [*$3.3$ cm | $1.9degree$*],

    [$25$ cm/s],
    [$14.8$ cm | $8.7degree$],
    [$12.9$ cm | $9.9degree$],
    [$13.1$ cm | $9.1degree$],
    [*$3.6$ cm | $2.3degree$*],

    table.hline(stroke: 0.5pt),

    [Training],
    [$13.5$ h ($100$M)],
    [$25.0$ h ($100$M)],
    [$15.0$ h ($100$M)],
    [$17.5$ h ($20$M)],

    table.hline(stroke: 0.5pt),

    [GPU Inference],
    [*$0.42 plus.minus 0.1$ ms*],
    [$0.71 plus.minus 0.2$ ms],
    [$0.43 plus.minus 0.1$ ms],
    [$1.27 plus.minus 0.1$ ms],

    [CPU Inference],
    [*$0.24 plus.minus 0.1$ ms*],
    [$0.71 plus.minus 0.2$ ms],
    [$0.43 plus.minus 0.1$ ms],
    [$2.38 plus.minus 0.2$ ms],
  ),
  caption: dynamic-caption(
    [A comparison of the @sim-to-real transfer @ATE (cm) and orientation error (degrees), training duration, and inference latency for policies trained with different @RL algorithms.],
    [Sim-to-real performance and computational cost of RL algorithms],
  ),
) <tab:validation:traversal:algos>

#block(breakable: false, width: 100%)[
  The quantitative superiority is visually apparent in the qualitative trajectory plots in @fig:validation:traversal:traj_algos. The path traced by the @DreamerV3 @policy is smooth, precise, and closely aligned with the target trajectory. In contrast, the other @agent:pl exhibit large deviations and erratic behavior, clearly demonstrating a failure to generalize to the complex dynamics of the physical world.
]

#v(-0.9em)

#figure(
  caption: dynamic-caption(
    [Real-world trajectories of the physical rover following a capsule-shaped path, controlled by policies trained with different @RL algorithms.],
    [Real-world trajectories for different RL algorithms],
  ),
  image("../figures/6_validation/sim2dust_traj_algos.svg", width: 75%),
) <fig:validation:traversal:traj_algos>

#place(bottom, float: true)[
  #v(-1em)
  #figure(
    caption: dynamic-caption(
      [Additional real-world trajectories executed by the @DreamerV3 @agent, including rectangular, circular, Lissajous, and lemniscate paths.],
      [Showcase of diverse real-world trajectories],
    ),
    image("../figures/6_validation/sim2dust_traj_showcase.svg", width: 80%),
  ) <fig:validation:traversal:traj_showcase>
]

Given its overwhelming advantages in both @sample-efficiency and real-world performance, @DreamerV3 was selected as the exclusive algorithm for all subsequent experiments in this study. The high quality of the learned controller was further demonstrated by deploying it on a series of more complex paths, as shown in @fig:validation:traversal:traj_showcase, and by observing the highly repeatable tracks it imprinted in the granular media, seen in @fig:validation:traversal:tracks.
#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [Repeatable lemniscate path imprinted by the rover's wheels in the basalt gravel of the LunaLab during a real-world deployment.],
      [Repeatable rover tracks imprinted inside the LunaLab],
    ),
    image(
      "../figures/6_validation/sim2dust_lunalab_lemniscate_projected.png",
      width: 100%,
    ),
  ) <fig:validation:traversal:tracks>
]

=== The Critical Role of Procedural Diversity <ssec:validation:traversal:diversity>

#block(breakable: false, width: 100%)[
  The experiment then systematically evaluated the core hypothesis that @policy robustness is a direct result of simulation diversity. Four distinct training regimes were compared. A baseline `static` @agent was trained with all 512 parallel @environment:pl sharing a single terrain. A `DR` @agent was trained on the same static terrain but with full @DR. The `DR&PCG` @agent was trained under the full procedural paradigm, with each instance featuring a unique terrain. A final `DR&PCG+PF` (particle fine-tuning) @agent augmented this with a fine-tuning stage using high-fidelity particle physics.
]

#place(bottom, float: true)[
  #v(-0.5em)
  #figure(
    table(
      columns: 5,
      table.header([Velocity], [Static], [DR], [DR&PCG], [DR&PCG+PF]),
      [$5$ cm/s],
      [$3.4$ cm | $4.2degree$],
      [$2.5$ cm | $1.6degree$],
      [$2.3$ cm | $1.7degree$],
      [*$2.2$ cm | $1.5degree$*],

      [$15$ cm/s],
      [$4.2$ cm | $6.8degree$],
      [$3.3$ cm | $2.3degree$],
      [*$3.3$ cm | $1.9degree$*],
      [$3.3$ cm | $2.0degree$],

      [$25$ cm/s],
      [$4.4$ cm | $7.1degree$],
      [$4.1$ cm | $2.9degree$],
      [*$3.6$ cm | $2.3degree$*],
      [$4.3$ cm | $2.6degree$],

      table.hline(stroke: 0.5pt),

      [Training],
      [$17.0$ h ($20$M)],
      [$17.0$ h ($20$M)],
      [$17.5$ h ($20$M)],
      [+$82.0$ h (+$1$M)],
    ),
    caption: dynamic-caption(
      [@Sim-to-real transfer @ATE (cm) and orientation error (degrees) across different training regimes.],
      [Sim-to-real performance of different training regimes],
    ),
  ) <tab:validation:traversal:regimes>
]

The results, presented in @tab:validation:traversal:regimes, support the value of procedural diversity under the tested conditions. While the `static` @agent learned the task in simulation, its performance on the physical rover was poor, exhibiting high tracking error and instability. The addition of `DR` alone provided a substantial improvement, particularly in orientation error. The `DR&PCG` @agent achieved the lowest tracking errors at the higher, more challenging velocities. The final particle-physics fine-tuning used eight parallel environments, compared with 512 for procedural training, and offered only a minor improvement at low speed for substantial additional training cost. This comparison therefore does not isolate the effect of fidelity from training diversity. Under these conditions, the results support the effectiveness of broad structural diversity from @PCG for transfer to the physical rover.

=== Ensuring Stability for Hardware Deployment <ssec:validation:traversal:smoothing>

The final set of experiments within this case study addressed a practical engineering concern critical for any real-world mission: ensuring the stability and smoothness of the learned controller. While @RL optimization can produce highly performant policies, the resulting controllers often generate actions with high-frequency oscillations. These jerky commands, while potentially optimal for maximizing a reward signal in the discrete-time @environment of a simulation, can lead to unstable behavior, cause excessive mechanical stress, and increase power consumption on physical hardware, thereby compromising the long-term reliability of the robotic system.

To investigate this issue and identify a practical solution, the performance of the raw, unfiltered @DreamerV3 @policy was compared against versions augmented with three different low-pass action filters. The selected filters represent common and computationally efficient approaches to signal smoothing:
- *Moving average* filter with a history window of 5 steps.
- *Savitzky--Golay* (third-order) filter with a history window of 9 steps.
- *Butterworth* (third-order) filter with a cutoff frequency of 2.5~Hz.

#place(bottom, float: true)[
  #v(-0.25em)
  #figure(
    table(
      columns: 5,
      table.header(
        [Velocity],
        [Unfiltered],
        [Moving Avg.],
        [Savitzky--Golay],
        [Butterworth],
      ),
      [$5$ cm/s],
      [$2.3$ cm | $1.7degree$],
      [*$2.2$ cm | $1.6degree$*],
      [$2.6$ cm | $1.7degree$],
      [$2.8$ cm | $1.7degree$],

      [$15$ cm/s],
      [*$3.3$ cm | $1.9degree$*],
      [$3.7$ cm | $2.4degree$],
      [$5.0$ cm | $2.3degree$],
      [$4.3$ cm | $2.1degree$],

      [$25$ cm/s],
      [*$3.6$ cm* | $2.3degree$],
      [$4.2$ cm | *$2.1degree$*],
      [$64.9$ cm | $16.4degree$],
      [$4.9$ cm | $2.4degree$],

      [Motion Jerk], [$1.00$], [$0.33$], [*$0.30$*], [$0.39$],
    ),
    caption: dynamic-caption(
      [Sim-to-real @ATE (cm), orientation error (degrees), and relative motion jerk of different action smoothing filters. The unfiltered @policy is the most accurate at high speeds but produces much jerkier motion. The Savitzky--Golay filter fails at high speed due to phase lag.],
      [Performance of action smoothing filters],
    ),
  ) <tab:validation:traversal:smoothing>
]
The results, presented in @tab:validation:traversal:smoothing, reveal a critical trade-off between tracking precision and motion stability. The unfiltered @policy achieved the best tracking accuracy at higher speeds but produced motion roughly three times jerkier than the filtered alternatives. All smoothing filters dramatically reduced motion jerk, but the Savitzky--Golay filter's large history window introduced a significant phase lag, leading to catastrophic instability at high speed. The simple moving average filter provided the most satisfactory compromise, substantially reducing motion jerk by 67% with only a minor and acceptable accuracy penalty at high speed. This experiment #box(width: 100%)[underscores a crucial lesson: optimizing for raw performance metrics alone is insufficient for real-world deployment. A well-tuned action filter represents a practical, computationally efficient, and effective method for achieving the control stability required for safe and reliable long-term robotic operation.]
=== The Perceptual Sim-to-Real Gap <ssec:validation:traversal:perception>

As a final investigation, this study explored the feasibility of learning an @end-to-end @policy directly from visual data. An @agent was trained with access to a 64$times$64 px depth map from an onboard camera. While this @policy could be transferred to the physical rover, its tracking accuracy was significantly degraded, with an @ATE of 9.2 cm and an orientation error of #box[6.5$degree$] at 15~cm/s. The reason for this performance collapse became immediately apparent when #box(width: 100%)[comparing the simulated and real-world sensor data, as shown in @fig:validation:traversal:depth_gap. The standard simulation provided a clean and ideal depth map, but the physical basalt gravel in the LunaLab created a noisy sensor signal with substantial dropouts due to its reflective properties and lack of significant texture when using the Intel RealSense D455 camera.]

#v(-0.75em)

#subfigure(
  gutter: 0.25em,
  columns: 2,
  figure(
    image("../figures/6_validation/sim2dust_depth_sim.png", width: 100%),
    caption: text(
      size: 9pt,
    )[Simulated depth map],
  ),
  figure(
    image("../figures/6_validation/sim2dust_depth_real.png", width: 100%),
    caption: text(
      size: 9pt,
    )[Real-world depth map],
  ),
  caption: dynamic-caption(
    [Comparison of simulated and real-world depth views. The simulated map is clean, while the real-world image suffers from significant noise and signal dropout due to the properties of the basalt gravel.],
    [Comparison of simulated and real-world depth views],
  ),
  label: <fig:validation:traversal:depth_gap>,
)

#pagebreak()

This result highlights a crucial limitation and a key area for future work. Even with a robust and well-generalized control @policy, unmodeled sensor physics can create a severe perceptual @sim-to-real gap that becomes the primary point of failure. It also serves as a strong justification for the methodological choice in this thesis to primarily focus on state-based observations for developing the core control and interaction methodologies. By decoupling the immense challenge of perception from the equally difficult challenge of control, it becomes possible to make systematic progress on the latter. Closing this perceptual gap through higher-fidelity sensor simulation and the development of perception algorithms robust to real-world noise remains a critical open problem for achieving true @end-to-end autonomy.

== Tool-Aware Regolith Excavation <sec:validation:excavation>

Following the successful validation of adaptive traversal on physical hardware, this second case study delves into the complexities of contact-rich manipulation. It addresses a challenge central to the vision of @ISRU: autonomous @regolith excavation. This task is foundational for future off-world construction and resource extraction, but it presents a formidable control problem. The interaction is dominated by the complex, unpredictable physics of granular media, where forces are difficult to model analytically. Furthermore, true autonomy demands versatility: a robot must be able to operate effectively with a variety of tools, whether due to mission requirements or unforeseen hardware degradation from the abrasive lunar environment.

#v(-0.75em)

#figure(
  caption: dynamic-caption(
    [A generalizable excavation skill is learned in @SRB by training an @agent on a vast distribution of randomized scenarios with procedurally generated tools.],
    [Simulation setup for training tool-aware excavation policies],
  ),
  image("../figures/6_validation/astra_sim_showcase.png", width: 100%),
) <fig:validation:excavation:concept>

This case study, based on the work in @pub:orsula2025learningtool, serves as a direct and rigorous validation of the adaptive control methodology proposed in @ch:autonomy. The core hypothesis is that an @agent can learn a generalizable excavation skill by combining a predictive @world-model with learned adaptive @compliance. The experiment is specifically designed to test whether training an @agent on a procedural distribution of tool geometries forces it to develop a robust, tool-aware @policy that can generalize to unmodeled tool changes.
=== Experimental Setup and Methodology <ssec:validation:excavation:methodology>

The experimental simulation setup for this validation was the `excavation` task within @SRB. To accurately capture the complex physics of the problem, the @regolith was modeled using a high-fidelity particle simulation based on extended position-based dynamics~@macklin2019small, as shown in @fig:validation:excavation:concept. This provided the realistic, nonlinear force feedback necessary for learning a physically grounded skill.

For this validation, the principle of procedural diversity was applied in two key ways, as shown in @fig:validation:excavation:procedural_paradigm. First, each of the 16 parallel training @environment:pl featured a unique lunar terrain generated by the @SimForge engine. Second, and central to this study, the @agent in each @environment was equipped with a unique @PCG excavation tool geometry.

The procedural pipeline for the tools, featuring over forty parameters, was designed to produce a wide spectrum of morphologies, varying scoop width, depth, curvature, and the number and shape of teeth. This forced the @agent to learn an abstract understanding of excavation, rather than a strategy tied to a single tool. A variety of the generated tools is shown in @fig:validation:excavation:tool_variety.

#v(-0.75em)

#subfigure(
  gutter: 0.25em,
  columns: 2,
  figure(
    image("../figures/6_validation/astra_procgen_examples.svg", width: 100%),
    caption: text(
      size: 9pt,
    )[Procedurally generated assets],
  ),
  figure(
    image("../figures/6_validation/astra_sim_16envs.png", width: 100%),
    caption: text(
      size: 9pt,
    )[Parallel training environments],
  ),
  caption: dynamic-caption(
    [The procedural paradigm for the `excavation` task, where @PCG pipelines generate diverse terrains and tools that are then used to populate parallel @environment instances.],
    [The procedural paradigm for the excavation task],
  ),
  label: <fig:validation:excavation:procedural_paradigm>,
)

#figure(
  caption: dynamic-caption(
    [A grid of @PCG excavation tool geometries from @pub:orsula2025learningtool.],
    [Procedurally generated excavation tool geometries],
  ),
  image("../figures/6_validation/astra_scoop_variety.svg", width: 90%),
) <fig:validation:excavation:tool_variety>

The @agent controlled a stationary Franka Emika manipulator and was trained using the @DreamerV3 algorithm. The task was formulated as a @POMDP, where the @agent had no direct knowledge of its equipped tool's geometry or the specific physical properties of the @regolith. Its action space was designed to directly test the adaptive @compliance framework, combining @SE3 motion commands with learned @stiffness ($K_p$) and @damping ($K_d$) gains for @OSC. The @reward-function was structured to incentivize lifting and stabilizing a large volume of @regolith while penalizing undesirable behaviors such as dust generation and jerky motions.

#pagebreak()

=== Results and Analysis <ssec:validation:excavation:results>

The validation involved a systematic comparison of @agent:pl trained under different conditions to isolate the effects of @compliance, procedural diversity, and perception. A baseline rigid `IK` @agent was compared against several compliant @agent:pl. A `SPECIALIST` @agent was trained with the full adaptive @compliance model but only ever used a single, static tool geometry. In contrast, the generalist `ADAPTIVE` @agent was trained on the full procedural distribution of tools. A final `VISUAL` @agent was also trained, augmenting the `ADAPTIVE` @agent's proprioceptive inputs with depth maps from two camera views, as shown in @fig:validation:excavation:vision_feedback.

#v(-1em)

#figure(
  caption: dynamic-caption(
    [Visual feedback provided to the `VISUAL` @agent from two camera views over the course of a single excavation @episode. The depth maps provide rich and real-time information about the robot workspace.],
    [Visual feedback for the excavation task],
  ),
  image("../figures/6_validation/astra_vision.svg", width: 100%),
) <fig:validation:excavation:vision_feedback>

#place(bottom, float: true)[
  #v(-1em)
  #figure(
    table(
      columns: 4,
      table.header(
        [Agent], [Excavated Volume (L)], [Dust Generated], [Motion Jerk]
      ),
      [`IK` (baseline)], [0.13], [1.00], [1.00],
      [`SPECIALIST`], [0.02], [0.91], [0.39],
      [`ADAPTIVE`], [0.14], [0.94], [0.44],
      [`VISUAL`], [*0.27*], [*0.89*], [*0.20*],
    ),
    caption: dynamic-caption(
      [Zero-shot @generalization performance on eight novel tool geometries. The `SPECIALIST` @agent fails to generalize, whereas the `ADAPTIVE` @agent generalizes well and the `VISUAL` @agent performs best on all metrics.],
      [Zero-shot generalization performance for the excavation task],
    ),
  ) <tab:validation:excavation:results>
]

#v(-0.5em)

The results strongly support the core hypotheses of this thesis. As shown in the learning curves in @fig:validation:excavation:learning_curves, the `SPECIALIST` @agent learned its task more quickly, as it only needed to master a single condition. However, this apparent efficiency was deceptive. When evaluated on a held-out test set of eight novel tool geometries, its performance collapsed, as shown in @tab:validation:excavation:results. It failed to generalize to tools it had never seen, excavating almost no @regolith. In stark contrast, the `ADAPTIVE` @agent, trained with procedural tool diversity, retained its performance on the unseen tools, matching the `IK` baseline in volume with far smoother motion. This outcome confirms that training with procedural diversity in @embodiment is a critical factor in forging a truly robust and tool-aware @policy.

#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [Learning curves for the excavation task, where the `VISUAL` @agent, trained with vision on diverse @PCG tools, achieves the highest final performance.],
      [Learning curves for the excavation task],
    ),
    image("../figures/6_validation/astra_learning_curves.svg", width: 74%),
  ) <fig:validation:excavation:learning_curves>
]

Furthermore, the study evaluated learned @compliance and visual perception. Compared with a rigid @IK baseline using @PCG tools, the `VISUAL` @agent achieved an 80% reduction in motion jerk. It also excavated nearly double the volume of @regolith compared with its proprioception-only counterpart. These measurements show smoother motion and higher excavation volume under the tested conditions. This case study demonstrates that the integrated framework can produce sophisticated, tool-aware behaviors, a capability relevant to autonomous construction and resource utilization in space.
=== Implications for Hardware Co-Design <ssec:validation:excavation:co-design>

This methodology presents a novel opportunity to inform hardware development. Because the learned generalist @agent can operate a wide variety of tools, it can serve as a consistent evaluation benchmark for different mechanical designs. The performance of the `VISUAL` @agent across the held-out set of novel tools, shown in @fig:validation:excavation:tool_comparison, reveals significant performance variation attributable to tool geometry alone. Some designs enabled the @agent to excavate far more material than others. For instance, tools with deeper cavities and more rounded designs generally performed better. This data-driven approach could enable a synergistic co-design process where hardware and control policies are developed in parallel to create tools that are inherently more compatible with autonomous systems.

#figure(
  caption: dynamic-caption(
    [The performance of the `VISUAL` @agent across the held-out set of novel tool geometries. The results show significant performance variation based on tool design, highlighting the potential for data-driven hardware optimization.],
    [Performance across novel tool geometries],
  ),
  image("../figures/6_validation/astra_scoop_rating.svg", width: 100%),
) <fig:validation:excavation:tool_comparison>

== Adversarial Air Hockey Diversity <sec:validation:air_hockey>

To test the generality of the core principles beyond traditional space robotics tasks, this final case study examines their application in the highly dynamic, competitive, and contact-rich setting of the Robot Air Hockey Challenge 2023, as detailed in @pub:liu2024retrospective. While seemingly unrelated to planetary exploration or orbital servicing, this task provides a test of the diversity-over-fidelity paradigm. In this context, diversity is strategic and adversarial: the changing behavior of an opponent gives the @agent varied experience to generalize from.

The challenge involved training a learning-based @agent to control a 7-@DoF KUKA iiwa14 manipulator to play air hockey against the @agent:pl of other teams, as shown in @fig:validation:air_hockey:sim. The task is characterized by fast-paced dynamics, the necessity for precise physical interaction with the puck, and the need to react to an intelligent opponent in real time. Consistent with the blueprint developed in this thesis, the @DreamerV3 algorithm was employed, training a @policy from sparse rewards corresponding only to goals scored or faults conceded. The control interface also adhered to the principle of task-space control, where the @agent learned to command an absolute target position for the mallet in the Cartesian plane, which was then mapped to joint commands via differential @IK.

#figure(
  caption: dynamic-caption(
    [MuJoCo~@todorov2012mujoco simulation @environment of the Robot Air Hockey Challenge.],
    [Robot Air Hockey Challenge simulation environment],
  ),
  image("../figures/6_validation/air_hockey_sim.png", width: 100%),
) <fig:validation:air_hockey:sim>

#v(-0.25em)

The core finding of this study parallels the procedural diversity experiments. An @agent trained solely against a single, static baseline opponent became highly specialized and @overfit. The `static` @agent achieved an average score of 14.5 to 0.1 against its predictable training partner, but performed poorly against opponents using novel strategies.

#v(-0.25em)

The solution was to introduce diversity through @self-play, a form of adversarial training. The `self-play` @agent was trained against an ever-evolving pool of its own past policies. This process was further enriched by pre-populating the opponent pool with specialist @agent:pl that had been trained with distinct @reward-function:pl to encourage aggressive, defensive, and balanced playstyles. This forced the @agent to continuously discover and patch weaknesses in its own strategy, leading to a much more robust and generalizable @policy.

The deceptive nature of the static training is made explicit by the quantitative results from head-to-head matches, summarized in @tab:validation:air_hockey:results. The `static` @agent utterly dominated the `baseline` it was trained against with an average score of 14.5 to 0.1. However, when matched against the `self-play` @agent, its strategy collapsed and it was defeated with a score of 0.7 to 14.3. This result is a powerful demonstration of @overfit:pl. The `static` @agent had not learned to play air hockey, but merely exploited the specific weaknesses of a single opponent.

#figure(
  table(
    columns: 3,
    align: (center, center, center),
    table.header([*Agent 1*], [*Agent 2*], [*Average Match Score*]),
    [`static`], [`baseline`], [14.5 : 0.1#h(2.0mm)],
    [`self-play`], [`baseline`], [6.1 : 0.2],
    [`static`], [`self-play`], [#h(2.2mm)*0.7 : 14.3*],
  ),
  caption: dynamic-caption(
    [Match results, where the `static` @agent, trained only against the `baseline` opponent, appears dominant until it faces the novel strategies of the `self-play` @agent.],
    [Match results for air hockey agents],
  ),
) <tab:validation:air_hockey:results>

This process is a strategic counterpart to training against procedurally generated terrains. In both cases, varied training experience can reduce @overfit:pl to a narrow set of conditions. The `self-play` @agent ultimately secured second place in the tournament, losing only to a solution that leveraged optimal control and task priors, and was transferred to the real-world robotic platform. These results support the value of training diversity in the tested settings.

== Discussion <sec:validation:discussion>

The case studies in this chapter provide comprehensive validation for the core claims of this thesis, transitioning the work from methodological design to practical demonstration. The results form a cohesive picture of how the proposed framework achieves adaptive autonomy.

A recurring finding is the value of varied training experience, which took different forms across these studies: procedural terrain diversity in traversal, procedural tool diversity in excavation, and strategic opponent diversity in air hockey. Together, these results support the role of training diversity in generalization under the tested conditions.

The excavation study also evaluated learned adaptive @compliance for contact-rich interaction. The @agent could modulate its @stiffness and @damping during the task, and the measured results showed improvements in motion smoothness relative to the rigid controller.

The evidence combines results from distinct settings. @SRB provided the simulation framework; physical traversal and the prior grasping study demonstrated physical transfer, while adaptive compliance and excavation were evaluated in simulation. The air-hockey policy was also transferred to a physical robotic platform. Together, these complementary results support the blueprint for adaptive autonomy proposed by this thesis.

Finally, these validations also highlight the frontiers of current capabilities. The pronounced perceptual @sim-to-real gap, identified in the traversal study, remains a significant hurdle. This finding suggests that even with a robustly transferred control @policy, unmodeled sensor physics can be a primary point of failure, isolating robust perception as the next critical frontier for achieving true autonomy. In conclusion, this chapter has grounded the contributions of this thesis in rigorous empirical evidence, providing tangible proof that the proposed framework is an effective and validated pathway toward building the autonomous systems required for the final frontier.
