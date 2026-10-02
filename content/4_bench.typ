#import "../utils/all.typ": *
// EB Garamond has no arrows; name the font the printed edition used for them.
#show "↳": set text(font: "FreeMono")

= Forging Virtual Frontiers#dynamic-caption("", ": Space Robotics Bench") <ch:bench>

The proof of concept detailed in the previous chapter served as a critical validation. It confirmed that a simulation-centric approach grounded in procedural diversity could indeed bridge the @sim-to-real gap for a complex space robotics task. However, that foundational study also exposed a profound set of limitations. The bespoke, single-task @environment was an effective testbed for one experiment but represented a significant infrastructural bottleneck to broader scientific inquiry. To systematically investigate @generalization, evaluate advanced learning algorithms across diverse tasks, and explore the capabilities of a wide range of robot morphologies, a dedicated and standardized platform was required. This chapter introduces the core contribution of this thesis, the #gls("SRB", long: true).

@SRB is not merely a collection of simulation @environment:pl but a complete framework designed to accelerate the development of adaptive autonomy for space applications. It is the architectural answer to the infrastructural gap identified in the background review and the experimental limitations revealed in the foundational grasping study. This chapter provides a thorough overview of @SRB, detailing its design philosophy, its core architectural components, the suite of benchmark tasks it contains, and its seamless integration with the broader robotics and machine learning ecosystems. It presents @SRB as the foundational artifact upon which the core scientific investigations of this thesis are built, providing the necessary tools to rigorously test and validate the learning methodologies for achieving robust and generalizable robotic behavior in space. The @SRB source code is openly available at #link("https://github.com/AndrejOrsula/space_robotics_bench")[github.com/AndrejOrsula/space_robotics_bench].

== Design Philosophy <sec:bench:philosophy>

The design and development of @SRB were guided by a set of core principles formulated to address the specific needs of the robot learning and space robotics research communities. They ensure that @SRB is not just a powerful tool for this thesis, but also a valuable and lasting resource for researchers and developers working on the future of autonomous systems in space.

==== Realism and Diversity

The framework prioritizes the accurate simulation of space-relevant physics, including modeling of @regolith as a granular medium via particle physics based on extended position-based dynamics~@macklin2019small. However, this realism is not pursued for a single, static scenario. The core philosophy of this thesis dictates that true robustness for learning lies in capturing the immense diversity and unpredictability of space. This approach reframes the @sim-to-real gap not as a fixed bias to be bridged, but as a distribution of potential realities to be encountered and overcome. The goal is to train @agent:pl that are robust not because they have mastered one perfect simulation, but because they have learned to generalize across thousands of imperfect but varied ones, making the real world appear as just another variation~@tobin2017domain. This is achieved through the deep integration of @PCG and extensive @DR. For complex physical phenomena that are not explicitly modeled, such as atmospheric drag, the framework approximates their impact by applying random disturbances, forcing an @agent to learn a @policy that is inherently robust to a wide range of unmodeled dynamics.

==== Scale and Performance

Modern robot learning algorithms are notoriously data-hungry. To support this demand, @SRB is built to be highly parallelizable. Leveraging the GPU-accelerated physics and rendering of @Isaac-Sim, the framework can run over a thousand unique simulation instances concurrently, achieving a throughput of over 100k simulation steps per second for some tasks. This scale dramatically accelerates data collection for online @RL. The performance is further enhanced with backend optimizations, including Rust extension modules for high-performance CPU-bound logic via PyO3~@pyo3 and offloading computationally expensive task logic to the GPU using TorchScript~@ansel2024pytorch to maximize data throughput.

==== Modularity and Extensibility

#block(breakable: false, width: 100%)[
  Recognizing that every space mission is unique, @SRB is designed with a flexible and modular architecture. It avoids the monolithic, hard-coded task definitions of the initial grasping @environment. All assets, scenes, robots, actuation models, and tasks are instead implemented as configurable, interchangeable modules registered within an internal registry. This allows researchers to easily introduce new elements by providing a standard model format and a data-validated configuration, and thereby to adapt the framework to their specific needs without significant changes to the core codebase.
]

==== Openness and Accessibility

To maximize its impact and foster a collaborative research community, @SRB has been developed as a fully open-source project, directly addressing the lack of standardized benchmarks. The framework is accompanied by comprehensive documentation, user-friendly installation procedures, and a unified command-line interface. Crucially, it provides standardized interfaces to established ecosystems, including the @Gymnasium @API~@towers2024gymnasium for the robot learning community and the @ROS~2~@macenski2022ros2 @middleware for the broader robotics community.

== Benchmark Suite <sec:bench:suite>

@SRB is not a single @environment but a comprehensive suite of assets, robots, and tasks that can be composed into a vast array of mission-relevant scenarios. These components are the fundamental building blocks of the benchmark, providing the practical implementation of the modular design philosophy. This section details these components, beginning with the positioning of @SRB in the simulation landscape before diving into the multi-domain physics, the extensive robotic fleet, and the standardized tasks that constitute the suite.

=== Situating SRB in the Simulation Landscape <ssec:bench:suite:landscape>

The development of @SRB was motivated by a critical gap in the existing ecosystem of simulation tools. As outlined in @tab:background:simulator_comparison, current space simulators are typically designed for mission-specific @VandV and are often proprietary, while existing robot learning benchmarks exhibit a profound terrestrial bias and fail to capture the unique physics of space. @SRB is purpose-built to bridge this gap, offering an open-source platform that uniquely synthesizes massive parallelism, procedural diversity, and space-relevant challenges. It complements mission-specific simulators by providing a platform for data-intensive development of generalizable policies, and it expands the horizons of the robot learning community by introducing a new suite of challenges beyond the well-explored domain of tabletop manipulation.

=== Domains <ssec:bench:suite:domains>

#block(breakable: false, width: 100%)[
  Owing to its general-purpose simulation backend, @SRB can simulate a variety of extraterrestrial domains, each with distinct physical and visual characteristics. The framework models the gravitational pull of different celestial bodies and environmental factors like the intensity, color temperature, and angular diameter of solar illumination. Each domain presents unique challenges that directly influence robot dynamics, control strategies, and perception, as showcased in @fig:bench:domains.
]

#place(auto, float: true)[
  #subfigure(
    gutter: 0.25em,
    columns: (1fr, 1fr, 1fr),
    figure(
      image("../figures/4_bench/showcase_08.png", width: 100%),
      caption: text(
        size: 9pt,
      )[Surface of the Moon],
    ),
    figure(
      image("../figures/4_bench/showcase_03.png", width: 100%),
      caption: text(
        size: 9pt,
      )[Martian surface],
    ),
    figure(
      image("../figures/4_bench/showcase_13.png", width: 100%),
      caption: text(
        size: 9pt,
      )[Orbit --- Low Lunar Orbit],
    ),
    caption: dynamic-caption(
      [A selection of simulated @SRB domains, ranging from planetary @environment:pl to orbital scenarios. Each domain is characterized by its unique physical, visual, and environmental properties that directly impact the design and control of autonomous systems.],
      [A selection of simulated SRB domains],
    ),
    label: <fig:bench:domains>,
  )
]

The framework supports five primary domains. The *orbit* domain simulates the @microgravity @environment of space. The *asteroid* domain represents small celestial bodies with variable low gravity. Planetary domains include the *Moon* and *Mars*. Finally, a standard terrestrial *Earth* domain serves as a crucial baseline and is vital for @sim-to-real transfer. The key properties of these domains are summarized in @tab:bench:domain_properties.

#place(bottom, float: true)[
  #figure(
    table(
      columns: 4,

      table.header(
        [Domain],
        [Gravity ($m/s^2$)],
        [Solar Irradiance ($W/m^2$)],
        [Key Robotic Challenges],
      ),

      [Orbit], [$0.0$], [$1361$], [Momentum management, reaction dynamics, ...],

      [Asteroid],
      [$0.14 plus.minus 0.14$],
      [$190 plus.minus 25$#h(1.75mm)],
      [Low-traction mobility, unpredictable dynamics, ...],

      [Moon],
      [$1.62 plus.minus 0.01$],
      [$1361$],
      [Cratered terrain, harsh lighting, abrasive @regolith, ...],

      [Mars],
      [$3.72 plus.minus 0.01$],
      [$590 plus.minus 113$],
      [Challenging terrain, dusty atmosphere, ...],

      [Earth],
      [$9.81 plus.minus 0.03$],
      [$775 plus.minus 225$],
      [@Sim-to-real transfer for baseline performance validation],
    ),
    caption: dynamic-caption(
      [A comparison of the physical properties and associated robotic challenges for the primary domains simulated in @SRB.],
      [Physical properties of the simulated domains],
    ),
  ) <tab:bench:domain_properties>
  #v(2.0em)
]

Beyond these domain-level characteristics, @SRB supports additional application-specific interactions, including articulated rigid-body dynamics, propellant consumption of spacecraft, and particle physics for @regolith.

=== Robotic Fleet <ssec:bench:suite:fleet>

@SRB includes a diverse and extensible fleet of robotic platforms, organized into three main categories: *mobile robots*, *manipulation systems*, and *mobile manipulators*. The collection is summarized in @tab:bench:robot_fleet and includes commercially available robots and custom designs inspired by actual space hardware, enabling the systematic investigation of how a physical @embodiment influences learning. Although these robots are not space-rated, their inclusion is a deliberate choice that offers a practical and more accessible starting point for students and academics due to their widespread availability and well-documented specifications.

#v(-0.25em)

#figure(
  table(
    columns: 4,
    align: (left, left, left, center),
    table.header(
      [*Category*], [*Subcategory*], [*Examples*], [*Number of Platforms*]
    ),

    table.cell(rowspan: 4, fill: unilu-red-light)[Mobile Robots],
    table.cell(fill: unilu-red-light)[Wheeled],
    table.cell(fill: unilu-red-light)[Perseverance, Pragyan],
    table.cell(fill: unilu-red-light)[6],
    [Legged], [Spot, ANYmal], [7],
    table.cell(fill: unilu-red-light)[Aerial],
    table.cell(fill: unilu-red-light)[Ingenuity, Crazyflie],
    table.cell(fill: unilu-red-light)[2],
    [Spacecraft], [ISS, PCG CubeSat], [#h(6.5mm)11 + 1 @PCG],

    table.cell(rowspan: 3, fill: grey-tint)[Manipulation Systems],
    [Serial Arms], [Canadarm, Franka, Kinova, UR], [14],
    [Active @EE:pl], [Gripper, dexterous hand], [8],
    [Passive @EE:pl], [Screwdriver, PCG scoop], [#h(8mm)8 + 1 @PCG],

    table.cell(rowspan: 2, fill: unilu-blue-light)[Mobile Manipulators],
    [Humanoids], [Unitree H1, Unitree G1], [4],
    table.cell(fill: unilu-blue-light)[Combined],
    table.cell(fill: unilu-blue-light)[Any mobile base + manipulator],
    table.cell(fill: unilu-blue-light)[Composable],
  ),
  caption: dynamic-caption(
    [A quantitative overview of the robotic fleet available in @SRB.],
    [A summary of the robotic fleet in SRB],
  ),
) <tab:bench:robot_fleet>

#v(-0.25em)

A key feature of @SRB is its compositional design, which allows researchers to dynamically create novel mobile manipulators by combining any mobile base, manipulator arm, payload, and @EE, as shown in @fig:bench:modular_robot. While not all of the 5000+ possible configurations are physically sensible, this flexibility is aimed at empowering researchers to explore a vast design space.

#place(bottom, float: true)[
  #v(-2.0em)
  #figure(
    caption: dynamic-caption(
      [An example of the modular composition of robots in @SRB. The framework allows for the combination of any mobile base with any manipulator and any @EE to create novel mobile manipulation systems.],
      [Modular composition of a mobile manipulator in SRB],
    ),
    image("../figures/4_bench/configurable_mobile_manipulator.png", width: 56%),
  ) <fig:bench:modular_robot>
]

==== Actuation Models <sssec:bench:suite:fleet:actuation>

@SRB provides a library of modular actuation models that map normalized @agent actions to low-level robot commands. The framework emphasizes high-level abstractions, such as target velocity control for wheeled robots and @IK or @OSC for manipulators, to improve @generalization across @embodiment:pl. Furthermore, the composition of action spaces for multi-component robots and multi-robot systems is fully automated. For instance, an @agent controlling a mobile manipulator interfaces with a unified action space that seamlessly combines the individual models for the mobile base, manipulator, and actuated @EE. Supported control modalities include:
- *Wheeled*
  - Target linear & angular velocity mapped via @kinematics
  - Target joint velocities
- *Legged & Humanoid*
  - Target joint positions
- *Aerial*
  - Target linear & angular accelerations
- *Spacecraft*
  - Activation of static/gimbaled thrusters with limited fuel
  - Target linear & angular accelerations
- *Manipulator*
  - Differential @IK or @OSC
  - Target joint positions
- *End-Effector*
  - Target joint positions
  - Target joint velocities

==== Sensory Modalities <sssec:bench:suite:fleet:sensors>

@SRB also provides @agent:pl with access to a rich variety of sensory information, organized into distinct modalities to support diverse learning paradigms.
- *State:* Privileged simulation information (ground-truth poses, velocities, contact forces)
  - _Purpose: Establish performance upper bounds; enable privileged (asymmetric) learning_
- *Proprioception:* Internal measurements (kinematic state, #gls("IMU", long: false) readings, fuel)
  - _Purpose: Train @policy:pl with realistic onboard sensor data_
- *Visual:* Rendered images (RGB, depth, normals, segmentation masks)
  - _Purpose: Learn @end-to-end @policy:pl directly from pixel inputs_
- *Commands:* High-level control signals (target velocity, relative waypoint pose)
  - _Purpose: Develop goal-conditioned @policy:pl for navigation tasks_

To clearly distinguish between learning paradigms and optimize performance, tasks that utilize visual sensors are purposefully registered as separate @Gymnasium @environment:pl with a `_visual` suffix. This makes the intended input modality explicit and ensures non-visual tasks run more efficiently. Furthermore, observations are divided based on whether their dimensionality is fixed or varies with robot morphology. This design enables research into cross-morphology @policy learning by isolating morphology-invariant observations from those that depend on the specific robot configuration.

=== Standardized Tasks <ssec:bench:suite:tasks>

Building upon the diverse domains and robotic fleet, @SRB provides a suite of standardized benchmark tasks. Each task is designed to test specific capabilities, as showcased in @fig:bench:tasks_overview and detailed in @tab:bench:tasks. These tasks are designed to be representative of the challenges posed by future space missions, ranging from basic mobility to long-horizon, complex sequences. The design prioritizes the evaluation of complete, mission-relevant skills over narrow, isolated sub-problems. For example, the `peg_in_hole` task requires the full pick-and-place sequence, not just the final insertion. This holistic approach produces more practical and generalizable skills that can be composed into complex, long-horizon behaviors. The full suite of tasks is organized into three primary categories: *mobile robotics*, *manipulation*, and *mobile manipulation*.

#place(bottom, float: true)[
  #v(-1.8em)
  #subfigure(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 0.1em,
    figure(image("../figures/4_bench/showcase_14.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_01.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_15.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_05.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_03.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_04.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_06.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_12.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_10.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_07.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_02.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_16.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_11.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_08.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_13.png", width: 100%)),
    figure(image("../figures/4_bench/showcase_09.png", width: 100%)),
    caption: dynamic-caption(
      [A collage showcasing the diversity of @SRB tasks.],
      [A collage showcasing the diversity of SRB tasks],
    ),
    label: <fig:bench:tasks_overview>,
  )
  #v(1.8em)
]

#place(auto, float: true)[
  #figure(
    table(
      columns: (auto, 2fr, 1fr),
      align: (left, left, center),
      table.header([*Task ID*], [*Objective*], [*Robot Morphology*]),

      table.cell(colspan: 3, fill: unilu-red-light)[*Mobile Robotics*],

      [#h(1em) landing],
      [Descend and safely land with limited fuel],
      [Spacecraft],

      table.cell(fill: unilu-red-light)[#h(1em) rendezvous],
      table.cell(
        fill: unilu-red-light,
      )[Approach and match the state of a tumbling object],
      table.cell(fill: unilu-red-light)[Spacecraft],

      [#h(1em) orbital_evasion],
      [Maneuver to avoid dynamic obstacles],
      [Spacecraft],

      table.cell(fill: unilu-red-light)[#h(1em) velocity_tracking],
      table.cell(fill: unilu-red-light)[Follow dynamic velocity commands],
      table.cell(fill: unilu-red-light)[Wheeled],

      [#h(2em) ↳ locomotion\_\*],
      [#h(1em) ↳ Variant for legged systems],
      [Legged/Humanoid],

      table.cell(fill: unilu-red-light)[#h(1em) waypoint_navigation],
      table.cell(fill: unilu-red-light)[Track a dynamic waypoint],
      table.cell(fill: unilu-red-light)[Wheeled],

      [#h(2em) ↳ locomotion\_\*],
      [#h(1em) ↳ Variant for legged systems],
      [Legged/Humanoid],

      table.cell(fill: unilu-red-light)[#h(2em) ↳ aerial\_\*],
      table.cell(fill: unilu-red-light)[#h(1em) ↳ Variant for aerial vehicles],
      table.cell(fill: unilu-red-light)[Aerial],

      [#h(2em) ↳ orbital\_\*],
      [#h(1em) ↳ Variant for spacecraft],
      [Spacecraft],

      table.cell(
        colspan: 3,
        fill: grey-tint,
      )[*Manipulation (Fixed Base)*],

      [#h(1em) debris_capture],
      [Capture and stabilize a tumbling piece of debris],
      [Manipulator],

      table.cell(fill: grey-tint)[#h(1em) sample_collection],
      table.cell(fill: grey-tint)[Grasp a domain-specific sample],
      table.cell(fill: grey-tint)[Manipulator],

      [#h(2em) ↳ multi\_\*],
      [#h(1em) ↳ Variant with multiple samples],
      [Manipulator],

      table.cell(fill: grey-tint)[#h(1em) excavation],
      table.cell(fill: grey-tint)[Excavate and lift granular media],
      table.cell(fill: grey-tint)[Manipulator],

      [#h(1em) peg_in_hole],
      [Pick up and precisely insert a peg into its hole],
      [Manipulator],

      table.cell(fill: grey-tint)[#h(2em) ↳ multi\_\*],
      table.cell(
        fill: grey-tint,
      )[#h(1em) ↳ Variant with multiple assemblies],
      table.cell(fill: grey-tint)[Manipulator],

      [#h(1em) screwdriving],
      [Fasten a bolt into a threaded hole],
      [Manipulator],

      table.cell(fill: grey-tint)[#h(1em) solar_panel_assembly],
      table.cell(
        fill: grey-tint,
      )[Assemble a structure via a sequence of insertions],
      table.cell(fill: grey-tint)[Manipulator],

      table.cell(colspan: 3, fill: unilu-blue-light)[*Mobile Manipulation*],

      table.cell(fill: white)[#h(1em) mobile_debris_capture],
      table.cell(
        fill: white,
      )[Approach and capture a tumbling piece of debris],
      table.cell(fill: white)[Spacecraft + Manipulator],

      table.cell(fill: unilu-blue-light)[#h(1em) mobile_excavation],
      table.cell(
        fill: unilu-blue-light,
      )[Excavate and store granular media],
      table.cell(fill: unilu-blue-light)[Ground + Manipulator],
    ),
    caption: dynamic-caption(
      [Overview of the standard @SRB benchmark tasks with their primary focus.],
      [Overview of the standard SRB benchmark tasks with their primary focus],
    ),
  ) <tab:bench:tasks>
]

== Core Architecture <sec:bench:architecture>

The capabilities of @SRB are supported by a carefully designed software architecture that integrates a high-performance simulation backend, a powerful procedural generation engine, and a comprehensive system for @DR. This synergistic relationship creates the scalable and unpredictable training distribution that is essential for forging truly adaptive autonomy.

=== Simulation Backend <ssec:bench:architecture:backend>

#block(breakable: false, width: 100%)[
  The foundation of @SRB is built upon @Isaac-Sim, a modern robotics simulation platform powered by NVIDIA Omniverse~@omniverse. Its GPU-accelerated physics and ray-traced rendering enable the parallel execution of many independent simulation instances with complex interactions on a single workstation. As showcased in @fig:bench:parallel_architecture, this architecture enables the simultaneous rendering and physics simulation of many parallel @environment:pl, which is a feature fundamental to making the procedural paradigm practical while satisfying the data-hungry requirements of modern robot learning.
]

#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [The parallel architecture of @SRB in action during the training of the `excavation` task. Each of the 64 @environment instances features a unique @PCG terrain and a distinct particle physics system for simulating the granular @regolith as discrete particles.],
      [Parallelized training of an excavation policy in SRB],
    ),
    image("../figures/4_bench/parallel_excavation.png", width: 100%),
  ) <fig:bench:parallel_architecture>
  #v(0.5em)
]

To quantify the scalability of @SRB, the simulation throughput was evaluated across the benchmark tasks using a workstation equipped with an AMD Ryzen~9~7950X CPU and an NVIDIA~RTX~4090 GPU. The results, presented in @fig:bench:simulation_performance, show the aggregate throughput with respect to the number of parallel @environment instances.

#place(bottom, float: true)[
  #figure(
    caption: dynamic-caption(
      [The aggregate throughput of @SRB tasks.],
      [The aggregate throughput of SRB tasks],
    ),
    image("../figures/4_bench/simulation_performance.svg", width: 100%),
  ) <fig:bench:simulation_performance>
]

#block(breakable: false, width: 100%)[
  === Procedural Engine <ssec:bench:architecture:engine>

  To populate the simulation with a near-infinite variety of content, @SRB integrates a custom procedural engine named @SimForge. This engine automates the process of generating 3D assets on demand using parametric pipelines created in @Blender~@blender. @SimForge acts as a flexible, simulator-agnostic asset factory that decouples the complex task of content creation from the simulation @environment itself. Its modular architecture, shown in @fig:bench:simforge_architecture, is based on three core concepts: declarative *assets* that act as blueprints, *generators* that produce content from these blueprints, and *integrations* that connect the engine to frameworks like @SRB.
]

#v(-1em)

#figure(
  caption: dynamic-caption(
    [The modular workflow of the @SimForge architecture, where an integration can request assets, which are then produced by a generator and returned to the integration.],
    [The modular workflow of the SimForge architecture],
  ),
  image("../figures/4_bench/simforge_architecture.svg", width: 75%),
) <fig:bench:simforge_architecture>

The integration between @SimForge and @SRB is realized through a seamless, on-demand asset pipeline. Engineered for high-throughput operation, this system transforms the static concept of a simulation @environment into a dynamic, generative process, enabling the runtime creation and loading of unique procedural content for each parallel instance. As illustrated in @fig:bench:on_demand_pipeline, the workflow unfolds in five distinct stages when a new simulation is launched:
1. *Initialization:* The user defines a scenario, specifying the number of parallel @environment:pl, the desired robots, and the procedural assets (e.g., terrains, tools, targets). @SRB consumes this configuration and prepares the main simulation stage.
2. *Request:* For each parallel @environment, @SRB generates a unique, deterministic seed. It then identifies all procedural assets required for the scenario and dispatches a batch request to the @SimForge @API, specifying the asset blueprints and their corresponding seeds. This ensures every requested asset will be a distinct and reproducible variant.
3. *Generation:* @SimForge receives the batch request and invokes its generation backend in headless mode for each asset variant. This step is managed in the background, ensuring the generation process is fully isolated from the simulation runtime.
4. *Export:* As each asset is generated, the automated workflow of @SimForge bakes its procedural materials into a set of standard @PBR textures. The final model, comprising both its mesh and textures, is exported as a @USD file to a shared cache directory. The @USD format is optimized for rapid and parallel loading within the Omniverse ecosystem.
5. *Spawning:* @SRB monitors the cache for the newly created @USD files. Once the assets are available, @SRB loads each asset directly into memory and spawns it into its designated parallel @environment.

This entire pipeline is designed for efficiency, making the on-demand generation of hundreds of unique procedural worlds a practical reality that can be completed in a matter of seconds.

#v(-0.75em)

#figure(
  image("../figures/4_bench/srb_simforge.svg", width: 80%),
  caption: dynamic-caption(
    [The on-demand asset generation pipeline that programmatically links @SRB with @SimForge: (1)~Initialization, (2)~Request, (3)~Generation, (4)~Export, and (5)~Spawning.],
    [The on-demand asset generation pipeline],
  ),
) <fig:bench:on_demand_pipeline>

#figure(
  caption: dynamic-caption(
    [Examples of procedural assets generated by @SimForge, including varied terrains, rocks, and structured 3D models like excavation tools, peg-in-hole modules, and spacecraft.],
    [Examples of procedural assets generated by SimForge],
  ),
  image("../figures/4_bench/procgen_examples.png", width: 100%),
) <fig:bench:procgen_examples>

The primary generator uses @Blender to construct parametric pipelines for a wide range of assets, from extraterrestrial landscapes to spacecraft components, as shown in @fig:bench:procgen_examples. Each blueprint is a declarative Python class, illustrated schematically by the asteroid example in @raw:bench:simforge_asset. The generation process is fully automated so that when a new @environment instance is initialized, a unique seed is passed to @SimForge, which uses it to deterministically generate a unique asset.


#place(auto, float: true)[
  #v(-0.25em)
  #figure(
    caption: dynamic-caption(
      [Schematic pseudocode illustrating a declarative @SimForge asset definition for procedural asteroid geometry. The class represents a high-level blueprint for the underlying @Blender generation pipeline; the API names are simplified for illustration.],
      [A schematic declarative SimForge asset definition],
    ),
    kind: raw,
    [
      #codly(number-format: none)
      #codly(languages: (
        py: (name: "Python", icon: none, color: rgb("#3572A5")),
      ))
      #code-block(
        "simforge_asset.py",
        read(
          "../snippets/simforge_asset.py",
        ),
      )
    ],
  ) <raw:bench:simforge_asset>
  #v(0.25em)
]

=== Extensive Domain Randomization <ssec:bench:architecture:randomization>

While @SimForge provides structural diversity through @PCG, @DR applies a final, critical layer of parametric variation. At the beginning of each training @episode, a wide range of simulation parameters are sampled from predefined distributions across three main categories: *physics*, *visuals*, and *dynamics*. As summarized in @tab:bench:randomization_params, this comprehensive randomization strategy is essential for training @agent:pl that can handle the unpredictable nature of real-world physics and perception.

#[
  #v(-0.75em)
  #set list(indent: 0.5em, spacing: 0.5em)
  #figure(
    table(
      columns: 3,
      align: (center, left, left),

      table.header([Category], [Randomized Parameters], [Purpose]),

      [Physics],
      [
        - Gravity magnitude
        - Inertia matrix
        - Contact parameters
        - Material properties
        - Actuator modeling
      ],
      [Learning @policy:pl that are robust to unmodeled physical variations and hardware degradation.],

      [Visuals],
      [
        - Lighting direction
        - Lighting intensity
        - Lighting color
        - Skydome appearance
        - Camera pose
        - Post-processing effects
      ],
      [Achieving invariance to superficial visual changes and different lighting conditions.],

      [Dynamics],
      [
        - Initial entity state
        - External disturbances
        - Sensor noise level
      ],
      [Training @policy:pl that are stable and can recover from unexpected disturbances.],
    ),
    caption: dynamic-caption(
      [A summary of the parameters subject to @DR in @SRB.],
      [A summary of domain-randomized parameters in SRB],
    ),
  ) <tab:bench:randomization_params>
]

This three-tiered architecture of scalable parallelism, procedural diversity, and comprehensive randomization forms the technical core of @SRB, providing the rich and varied stream of experience necessary to train adaptive and generalizable @policy:pl.

== Open Platform for the Community <sec:bench:community>

A core objective of @SRB is to serve as a catalyst for research and collaboration. It is designed as an open and extensible platform for seamless integration with existing tools and workflows.

=== Integrations and Interfaces <ssec:bench:community:integrations>

@SRB directly integrates a number of modern @RL libraries like Stable-Baselines3~@raffin2021stable and skrl~@serrano2023skrl. To support more traditional development workflows and bridge the gap to physical hardware, the framework features a comprehensive, dynamically configured @ROS~2~@macenski2022ros2 interface that exposes nearly every aspect of the simulation to the @ROS ecosystem. This allows researchers to leverage standard robotics tools like the RViz2 visualizer, as shown in @fig:bench:ros_interface.

#figure(
  caption: dynamic-caption(
    [An example of the @ROS~2 interface showing the RViz2 visualization of the state and visual observations for a mobile manipulator inside an @SRB simulation.],
    [RViz2 visualization of a mobile manipulator in SRB],
  ),
  image("../figures/4_bench/ros_interface.png", width: 100%),
) <fig:bench:ros_interface>

Through its underlying backend, @SRB also supports the collection of visual data with ground-truth annotations. As shown in @fig:bench:orbital_inspection_visual, this includes synchronized RGB, depth, and segmentation streams from an onboard camera. This is essential for developing learning-based perception systems for tasks like orbital inspection.

#v(-0.25em)

#figure(
  image("../figures/4_bench/orbital_inspection.svg", width: 100%),
  caption: dynamic-caption(
    [Orbital inspection scenario of @SRB providing synchronized RGB, depth, and segmentation streams from an onboard camera maneuvered around the @ISS and Gateway.],
    [Orbital inspection scenario of SRB with synchronized camera streams],
  ),
) <fig:bench:orbital_inspection_visual>

Furthermore, the framework provides comprehensive support for human-in-the-loop @teleoperation using various input devices like those shown in @fig:bench:teleop_devices, enabling expert data collection for @IL and direct comparison of autonomous and human performance.

#place(auto, float: true)[
  #subfigure(
    gutter: 0.25em,
    columns: (1fr, 1fr, 1fr),
    figure(
      image("../figures/4_bench/teleop_gamepad.png", height: 14%),
      caption: text(
        size: 9pt,
      )[Gamepad],
    ),
    figure(
      image("../figures/4_bench/teleop_spacemouse.png", height: 14%),
      caption: text(
        size: 9pt,
      )[SpaceMouse],
    ),
    figure(
      image("../figures/4_bench/teleop_haptic_interface.png", height: 14%),
      caption: text(
        size: 9pt,
      )[Haptic interface],
    ),
    caption: dynamic-caption(
      [A selection of @teleoperation interfaces supported by @SRB.],
      [Supported teleoperation interfaces],
    ),
    label: <fig:bench:teleop_devices>,
  )
]

=== Sim-to-Real Workflow <sec:bench:sim_to_real>

A key innovation enabling rapid hardware deployment is the framework's automated @sim-to-real workflow. This system leverages runtime reflection to inspect a simulated @Gymnasium @environment and generate its lightweight, real-world counterpart. This hardware-specific @environment routes the actions, observations, rewards, and termination signals through a set of modular hardware interfaces that can be implemented via any @middleware, such as @ROS~2. The generation process automatically handles critical details like action space scaling and rate limiting to ensure consistency between the simulated and real domains. This modular design provides a versatile and robust solution for bridging the @sim-to-real gap, forming the critical pathway for the validation experiments in @ch:validation.

== Vision for Standardized Evaluation of Robots in Space <sec:bench:vision>

The ultimate purpose of @SRB extends beyond serving as a tool for individual research projects. It aims to catalyze a paradigm shift in how autonomous systems are developed and validated for space. By offering a shared suite of challenging tasks, a diverse robotic fleet, and consistent performance metrics, the benchmark enables researchers to directly compare the efficacy of novel algorithms in a reproducible scientific manner. This transforms development from disconnected efforts into a collaborative, community-driven pursuit.

Crucially, such a vision goes beyond simply measuring success rates on static tasks. The deep integration of @PCG and @DR enables a more meaningful form of evaluation: a direct measurement of @generalization capabilities across a wide distribution of unseen scenarios. This allows the community to move beyond asking whether an @agent can solve a task and toward answering the more critical question about the robustness of its solution to novelty and uncertainty. Quantifying this @generalization gap is fundamental to building trust in learning-based systems for safety-critical applications.
