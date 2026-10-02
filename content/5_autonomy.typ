#import "../utils/all.typ": *

= Achieving Adaptive Autonomy#dynamic-caption("", ": Model-Based End-to-End Approach") <ch:autonomy>

With @SRB established as the foundational framework for this investigation, the focus shifts from the @environment where an @agent learns to the principles of the learning process itself. The availability of a diverse, scalable, and realistic testbed provides the necessary foundation to move beyond baseline applications and enables a systematic investigation into the fundamental question of how an @agent forges the skills required for adaptive autonomy. This chapter presents the core methodological contributions of this thesis, detailing the inquiry into the learning paradigms, control representations, and perceptual strategies that together enable the development of robust, generalizable, and physically compliant robotic behaviors. It directly addresses the methodological limitations of sample inefficiency and rigid kinematic control identified in the foundational grasping study, presenting the advanced learning framework developed to overcome them.

Achieving this level of autonomy requires a holistic approach that extends beyond the selection of a single @RL algorithm. Therefore, this chapter systematically deconstructs the #gls("agent")--@environment interaction loop to construct a complete methodological blueprint. The first component is the learning paradigm, where an empirical comparison reveals the critical role of world modeling. The next component addresses the influence of perception, establishing a pragmatic approach for focused research. The central pillar of this framework, however, is the redefinition of how a learned @agent physically interacts with its world. This work moves past the brittleness of standard kinematic control to introduce a framework for learning compliant manipulation with @MBRL through @OSC. Finally, the blueprint accounts for the influence of @embodiment, showing how this adaptive methodology allows @agent:pl to develop strategies that are sensitive to their own physical morphology. This integrated methodology constitutes the workflow for learning adaptive control that is designed to produce a @policy capable of succeeding in the unpredictable domain of space.

== Learning Paradigm <sec:autonomy:paradigm>

The foundation of any autonomous @agent is the learning paradigm that governs its acquisition of knowledge and skill. This choice dictates how the @agent processes information, explores its @environment, and generalizes from its experience. This section opens with a systematic, empirical comparison of different @RL paradigms to establish the most effective approach for the challenging scenarios presented by @SRB.

=== Algorithmic Comparison and Baselines <ssec:autonomy:paradigm:baselines>

To ground the discussion of learning methodologies in empirical evidence, this research conducted a thorough comparison of algorithms representing the three main paradigms of deep @RL: @on-policy model-free (@PPO), @off-policy model-free (@SAC, @TD3), and model-based (@DreamerV3).

==== Focused Comparison on a Representative Task <sssec:autonomy:paradigm:baselines:focused>

#place(bottom, float: true)[
  #v(-0.25em)
  #figure(
    caption: dynamic-caption(
      [Procedurally generated assembly modules used in the peg-in-hole task to create a diverse training and evaluation distribution.],
      [PCG assembly modules of the peg-in-hole task],
    ),
    image("../figures/5_autonomy/colorful_modules.png", width: 100%),
  ) <fig:autonomy:colorful_modules>
  #v(0.25em)
]

The initial comparison focused on the procedurally generated peg-in-hole assembly modules shown in @fig:autonomy:colorful_modules, a prototypical challenge in contact-rich manipulation detailed in @pub:orsula2024leveraging. To isolate the core challenges of precision and @generalization that are independent of manipulator dynamics, the task was constrained to a simulation with direct control of the peg trajectory in @cartesian-space. The problem was formulated as a @POMDP due to the @agent having no direct access to latent physical properties like the precise geometry of the procedurally generated pegs, material friction, or contact forces.

As illustrated in @fig:autonomy:observation_space_pegs, the observation space was constructed from the relative transformations between the peg and the hole, and the @agent learned to output target linear and angular velocity commands.

#figure(
  caption: dynamic-caption(
    [The observation space of the peg-in-hole @agent:pl is defined by the $bold(T)_"entrance"^"peg"$ and $bold(T)_"bottom"^"peg"$ transformations that capture the kinematic state of the assembly.],
    [The observation space of the peg-in-hole task],
  ),
  image("../figures/5_autonomy/observation_space.svg", width: 90%),
) <fig:autonomy:observation_space_pegs>

#pagebreak()

This setup, combined with 1024 parallel @environment:pl featuring unique @PCG modules, provided a challenging testbed and a clear initial hierarchy of algorithmic performance, as shown in @fig:autonomy:peg_in_hole_baselines. In this task, the @MBRL @agent, @DreamerV3, reached high performance using fewer environment samples than its model-free counterparts. Although `SAC-STACK` eventually reached a higher final success rate on the training modules, @DreamerV3 attained high performance with a fraction of the samples.

#v(-0.5em)

#figure(
  caption: dynamic-caption(
    [Learning curves for the peg-in-hole assembly task from @pub:orsula2024leveraging, comparing model-free (@PPO, @SAC) and model-based (@DreamerV3) algorithms.],
    [Learning curves for the peg-in-hole assembly task],
  ),
  image("../figures/5_autonomy/peg_in_hole_learning_curves.svg", width: 100%),
) <fig:autonomy:peg_in_hole_baselines>
The performance of the model-free methods was directly tied to their ability to handle the task's partial observability. While the standard @PPO algorithm struggled, a variant incorporating a history of past observations (`PPO-STACK`) learned a moderately successful @policy. Similarly, the performance and stability of @SAC were improved by its `SAC-STACK` counterpart, underscoring the critical role of temporal context for model-free @agent:pl. In this comparison, @DreamerV3 reached high performance with fewer samples and achieved the quickest task completion times, as shown in @fig:autonomy:peg_in_hole_time_until_completion. Its recurrent @world-model is one possible explanation for this result, since it can represent temporal dependencies; however, the comparison does not isolate the memory architecture, so it cannot establish that recurrence caused the performance difference or that it is necessarily better than observation stacking.

#figure(
  caption: dynamic-caption(
    [Time until successful completion for the peg-in-hole assembly task. @DreamerV3 demonstrates the fastest completion times, followed by the @SAC variants.],
    [Time until successful completion for the peg-in-hole task],
  ),
  image(
    "../figures/5_autonomy/peg_in_hole_time_until_completion.svg",
    width: 100%,
  ),
) <fig:autonomy:peg_in_hole_time_until_completion>

The most critical distinction, however, emerged during evaluation on a test set of unseen procedural modules. Here, the @DreamerV3 @agent demonstrated robust @generalization by maintaining its high success rate, while the @SAC variants exhibited a significant performance degradation, highlighting their greater tendency to @overfit to the training distribution.

#v(-0.5em)

==== Baselines for the Space Robotics Bench <sssec:autonomy:paradigm:baselines:bench>

The performance hierarchy established in the focused study was also observed in a large-scale evaluation across the full suite of tasks in @SRB, as presented in @pub:orsula2025space. Under the tested configurations and budgets, the results, summarized in @fig:autonomy:srb_baselines, favored @DreamerV3 on most tasks. Across nearly all tasks, from `landing` to `sample_collection`, the @DreamerV3 @agent achieved the highest episodic returns and success rates.

Under this setup, the observed performance came at a greater computational cost in terms of wall-clock training time. With the adopted setup and 32 updates per @environment step, @DreamerV3 required on average 5.3$times$ longer to train than @PPO for the same number of @environment steps. This result illustrates a resource cost for @DreamerV3 under the tested configuration; its suitability relative to other paradigms depends on the task and budget. This large-scale evaluation also shows the limits of the tested configurations, as the most complex long-horizon tasks like `solar_panel_assembly` remained unsolved by any of the tested algorithms.

#figure(
  caption: dynamic-caption(
    [@RL baselines across @SRB tasks from @pub:orsula2025space. The results compare the performance of @PPO, @TD3, and @DreamerV3 @agent:pl. @DreamerV3 achieves the highest performance on most tasks.],
    [RL baselines of SRB tasks],
  ),
  image("../figures/5_autonomy/srb_baselines.svg", width: 100%),
) <fig:autonomy:srb_baselines>
=== Importance of World Modeling <ssec:autonomy:paradigm:world_modeling>

The consistent performance advantage of the @DreamerV3 @agent is a direct consequence of its core component, namely the learned @world-model~@hafner2025mastering. As depicted in @fig:autonomy:dreamer_imagination, this learned model provides two profound advantages. First, it dramatically improves @sample-efficiency by allowing the @agent to train on vast amounts of imagined experience, a process orders of magnitude faster than interacting with the full physics simulation. Second, the @world-model learns an abstract representation of the @environment. It learns to filter out the superficial sensory details introduced by @DR and @PCG to focus on the latent dynamics essential for prediction. This learned abstraction is a powerful, implicit mechanism for @generalization, forcing the @policy to become robust to the immense diversity of the training distribution.

#v(-0.75em)

#figure(
  caption: dynamic-caption(
    [The concept of learning in imagination, where the @agent uses its @world-model to predict sequences of future latent states and rewards. The @actor-critic networks are trained on these imagined trajectories, which dramatically improves @sample-efficiency.],
    [Learning in imagination with a latent world model],
  ),
  image("../figures/5_autonomy/dreamer_imagination.svg", width: 100%),
) <fig:autonomy:dreamer_imagination>

#pagebreak()

=== Benefits of Recurrent Architecture <ssec:autonomy:paradigm:recurrent>

The @world-model within the @DreamerV3 @agent integrates a @RNN. This structure is essential for addressing the partial observability inherent in all the benchmark tasks, as the @agent never has access to the complete ground-truth state of the @environment. The recurrent state of the @world-model functions as the @agent's memory, integrating the current observation with its previous state to build a more complete and temporally coherent understanding of the @environment's hidden dynamics. This ability to reason about the world over time is critical for success and explains why adding observation stacking also improved the performance of the model-free @RL @agent:pl in the peg-in-hole task from @pub:orsula2024leveraging.

#v(-0.4em)

== Role of Perception <sec:autonomy:perception>

The ability of an autonomous @agent to act effectively is fundamentally constrained by its ability to perceive its @environment. This section investigates the challenges of learning directly from raw visual data, a critical step toward creating truly @end-to-end autonomous systems.

#v(-0.6em)

=== Learning from Pixels <ssec:autonomy:perception:pixels>

Learning directly from high-dimensional visual observations is a significant challenge, requiring the @agent to simultaneously learn a meaningful representation of the world from raw pixel data in addition to a control @policy. To explore this within @SRB, experiments were conducted on the `landing` and `peg_in_hole` tasks using only rendered RGB images as input, with camera perspectives shown in @fig:autonomy:pixels_setup.

#place(bottom, float: true)[
  #v(-1em)
  #subfigure(
    gutter: 0.25em,
    columns: (1fr, 1fr),
    figure(
      image(
        "../figures/5_autonomy/landing_visual_camera_feed.svg",
        width: 100%,
      ),
      caption: text(
        size: 9pt,
      )[`landing_visual`],
    ),
    figure(
      image(
        "../figures/5_autonomy/peg_in_hole_visual_camera_feed.svg",
        width: 100%,
      ),
      caption: text(
        size: 9pt,
      )[`peg_in_hole_visual`],
    ),
    caption: dynamic-caption(
      [Camera perspectives for @end-to-end learning. The `landing` task uses a bottom-mounted camera, while the `peg_in_hole` task uses wrist- and base-mounted cameras.],
      [Camera perspectives for the end-to-end learning experiments],
    ),
    label: <fig:autonomy:pixels_setup>,
  )
  #v(-0.5em)
]

The results, summarized in @tab:autonomy:pixels_results, demonstrated that learning from pixels is indeed feasible, but performance was lower than that of @agent:pl trained with access to privileged state information. The learning process was slower, less stable, and resulted in a lower final success rate. These findings highlight the immense challenge that visual complexity adds to the learning problem. They also underscore the value of state-based observations as a tool for research by decoupling the perception and control problems.

#show: format-table(none, auto, auto, auto)
#figure(
  table(
    columns: 4,
    table.header([Task], [State], [Proprioception], [Visual]),
    table.cell(fill: unilu-red-light)[`landing`],
    table.cell(fill: unilu-red-light)[#"63.2%"],
    table.cell(fill: unilu-red-light)[#"11.4%"],
    table.cell(fill: unilu-red-light)[#"47.6%"],
    table.cell(fill: unilu-blue-light)[`peg_in_hole`],
    table.cell(fill: unilu-blue-light)[#"97.8%"],
    table.cell(fill: unilu-blue-light)[#"0.0%"],
    table.cell(fill: unilu-blue-light)[#"73.2%"],
  ),
  caption: dynamic-caption(
    [Success rates of @end-to-end @policy:pl trained with different sensory modalities.],
    [Success rates for different sensory modalities],
  ),
) <tab:autonomy:pixels_results>
== Learning Adaptive Compliance <sec:autonomy:interaction>

For the complex manipulation tasks central to this thesis, actions result in physical, contact-rich interactions. This section details the investigation into control representations that enable skillful and safe interaction, moving from the inherent limitations of rigid control to a more sophisticated framework of learned, adaptive @compliance.

=== Brittleness of Rigid Kinematic Control <ssec:autonomy:interaction:brittleness>

The standard actuation model for many robotic manipulators is differential @IK. While effective for motion in free space, this position-based approach is fundamentally non-adaptive when faced with physical contact, attempting to follow a commanded trajectory regardless of external forces. This rigidity is a critical failure point in unstructured environments. If an @agent attempts to insert a peg with a slight misalignment, the rigid controller can generate an uncontrolled escalation of contact forces, leading to jamming, hardware damage, or mission failure. This inherent brittleness, first identified as a key risk in the foundational grasping study, necessitates a control paradigm that can gracefully and intelligently manage physical contact.

=== Operational Space Control as a Compliant Framework <ssec:autonomy:interaction:compliant_control>

To overcome the brittleness, this research adopted #gls("OSC", long: true)~@khatib1987osc. This framework formulates the control problem directly in the @task-space and models the @EE as a programmable mass-spring-damper system, providing a principled method for implementing software-defined @compliance. The first step of the investigation was to confirm the hypothesis that even non-adaptive @compliance offers an advantage. To this end, initial experiments compared the rigid `IK` baseline against an `OSC-CONST` strategy, which used @OSC with fixed, hand-tuned gains. As shown in the learning curves of @fig:autonomy:compliant_learning_curves, the results were clear. Across contact-rich tasks, the `OSC-CONST` @agent demonstrated significantly more stable learning and achieved higher final returns than its rigid counterpart. This confirmed that even a constant level of @compliance is a powerful first step toward robust interaction.

#v(-0.5em)

#subfigure(
  columns: (1fr, 1fr),
  figure(
    image(
      "../figures/5_autonomy/compliant_debris_capture_learning_curves.svg",
      width: 100%,
    ),
    caption: text(
      size: 9pt,
    )[`debris_capture`],
  ),
  figure(
    image(
      "../figures/5_autonomy/compliant_peg_in_hole_assembly_learning_curves.svg",
      width: 100%,
    ),
    caption: text(
      size: 9pt,
    )[`peg_in_hole`],
  ),
  caption: dynamic-caption(
    [Learning curves comparing different control strategies on the `debris_capture` and `peg_in_hole` tasks. The adaptive @OSC variants (`OSC-STIFF` and `OSC-VAR`) exhibit task-dependent convergence and final returns relative to the rigid `IK` approach.],
    [Learning curves for compliant control strategies],
  ),
  label: <fig:autonomy:compliant_learning_curves>,
)

=== Learning to Dynamically Modulate Stiffness and Damping <ssec:autonomy:interaction:modulation>

While fixed @compliance provides some benefits, the ideal level of @compliance is not constant but dynamic and task-dependent. For example, a manipulator should be stiff and precise during free-space motion but become soft and yielding upon making contact to guide a part into place. This observation motivated the central methodological contribution of this thesis: empowering an @MBRL @agent to learn its own adaptive @compliance strategy.

This was achieved by augmenting the @agent's action space. In addition to commanding the desired @EE motion, the @agent also learned to output the desired @stiffness and @damping gains for the @OSC controller at each timestep. Two adaptive strategies were investigated: `OSC-STIFF`, where the @agent modulated only the six @stiffness ($K_p$) gains, and `OSC-VAR`, where it learned to control all twelve gains (six @stiffness ($K_p$) gains and six @damping ($K_d$) gains), as illustrated in @fig:autonomy:osc_concept.

#place(auto, float: true)[
  #v(-2em)
  #figure(
    caption: dynamic-caption(
      [Conceptual illustration of adaptive @compliance through @OSC. The @RL @agent learns to dynamically modulate the @EE's @stiffness and @damping parameters in addition to its @SE3 motion commands, enabling it to adapt its physical interaction strategy in real time.],
      [Conceptual illustration of adaptive compliance through OSC],
    ),
    image("../figures/5_autonomy/osc.svg", width: 80%),
  ) <fig:autonomy:osc_concept>
]

The performance metrics, summarized in @tab:autonomy:osc_results, quantify these effects. Adaptive @compliance consistently reduced motion jerk, while its effect on normalized return varied by task.

#figure(
  table(
    columns: 4,
    align: (left, left, center, center),
    table.header([*Task*], [*Controller*], [*Return*], [*Motion Jerk*]),
    table.cell(rowspan: 2, fill: unilu-red-light)[`debris_capture`],
    table.cell(fill: unilu-red-light)[`IK`],
    table.cell(fill: unilu-red-light)[*1.00*],
    table.cell(fill: unilu-red-light)[1.00],
    [*`OSC-VAR`*], [0.97], [*0.42*],
    table.cell(rowspan: 2, fill: unilu-blue-light)[`peg_in_hole`],
    table.cell(fill: unilu-blue-light)[`IK`],
    table.cell(fill: unilu-blue-light)[1.00],
    table.cell(fill: unilu-blue-light)[1.00],
    [*`OSC-VAR`*], [*1.10*], [*0.50*],
  ),
  caption: dynamic-caption(
    [Relative performance of @DreamerV3 using rigid @IK and adaptive @OSC controllers. The results are normalized with respect to the @IK baseline for numerical clarity.],
    [Performance comparison of IK and OSC controllers],
  ),
) <tab:autonomy:osc_results>
As shown in @fig:autonomy:compliant_learning_curves and @tab:autonomy:osc_results, learned @compliance improved motion smoothness, while its effect on normalized return was task-dependent rather than uniformly superior. This pattern was observed across distinct manipulation challenges:
- For the delicate `debris_capture` task, the adaptive @agent achieved a 58% reduction in measured motion jerk compared to the rigid `IK` controller.
- For the high-precision `peg_in_hole` task, the adaptive @OSC @agent achieved a 10% higher normalized return than the rigid `IK` controller.

These results support learned adaptive @compliance as a way to tune the trade-off between task performance and motion smoothness. The benefits depend on the task, and lower jerk alone does not establish safer interaction.

#v(-0.75em)

== Influence of Embodiment <sec:autonomy:embodiment>

#v(-0.35em)

The behavior of an autonomous @agent is shaped not only by its learning algorithm and control representation but also by its physical form, or @embodiment. The modular design of @SRB provides a unique opportunity to investigate this interplay. Experiments comparing different robot morphologies on several key tasks revealed that physical design creates strong priors that either facilitate or hinder the learning process. In the `locomotion_velocity_tracking` task, quadrupedal robots consistently learned stable gaits more quickly than bipedal robots, suggesting their inherent static stability provides a simpler learning landscape. In the `landing` task, performance varied significantly between different spacecraft designs. These results, with learning curves shown in @fig:autonomy:morphologies_learning_curves, underscore that optimal performance is achieved when the hardware @embodiment and the learned control @policy are well matched. This highlights that @embodiment is a key factor, and a truly general @agent must learn policies that can generalize not just across environments but also across variations in its own physical form. This principle of #gls("embodiment")-awareness finds its most compelling validation in the tool-aware manipulation case study of the next chapter.

#v(-1.0em)

#subfigure(
  gutter: 0.25em,
  columns: 3,
  figure(
    image(
      "../figures/5_autonomy/morphologies_landing_learning_curves.svg",
      width: 100%,
    ),
    caption: text(
      size: 8pt,
    )[#linebreak() `landing`],
  ),
  figure(
    image(
      "../figures/5_autonomy/morphologies_locomotion_velocity_tracking_learning_curves.svg",
      width: 100%,
    ),
    caption: text(
      size: 8pt,
    )[#linebreak() `locomotion_velocity_tracking`],
  ),
  figure(
    image(
      "../figures/5_autonomy/morphologies_screwdriving_learning_curves.svg",
      width: 100%,
    ),
    caption: text(
      size: 8pt,
    )[#linebreak() `screwdriving`],
  ),
  caption: dynamic-caption(
    [Learning curves comparing the performance of different robot morphologies.],
    [Learning curves for robot morphologies],
  ),
  label: <fig:autonomy:morphologies_learning_curves>,
)

== Blueprint for Adaptive Control <sec:autonomy:blueprint>

The investigations detailed throughout this chapter distill into a cohesive blueprint for achieving adaptive control in complex robotic systems. This blueprint is not a single algorithm but a methodological framework that combines three key principles.

The first principle is the adoption of a model-based learning paradigm. Under the tested configurations, @DreamerV3 showed strong @sample-efficiency and @generalization across several partially observable tasks, supporting its use in this blueprint.

Building upon this predictive model, the second principle is to embrace learned compliant control. The brittleness of pure position-based controllers makes them unsuitable for reliable interaction. This blueprint, therefore, prescribes using a compliant control framework like @OSC and, crucially, empowering the @agent to learn not just where to move but how to physically behave by dynamically modulating its own @compliance parameters.

Underpinning this entire framework is the final principle of training with maximum experiential diversity. The ability of an @agent to develop generalizable and adaptive strategies depends strongly on the richness of its training distribution. @SRB, with its procedural engine @SimForge, is the practical embodiment of this principle and provides the necessary experiential foundation for the learning methodologies to succeed.
