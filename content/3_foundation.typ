#import "../utils/all.typ": *

= Laying the Foundation#dynamic-caption("", ": Learning to Grasp on the Moon") <ch:foundation>

The progress of this thesis toward achieving adaptive autonomy in space began not with a comprehensive benchmark but with an empirical investigation into a fundamental manipulation skill. This chapter details the initial research presented in @pub:orsula2022learning, which served to validate the foundational hypotheses of this thesis. The work confronted the concrete challenge of teaching a robot to grasp unknown objects on the Moon. This task, while specific, served as a foundation for testing the core principles that underpin this entire thesis. The successful outcomes of this early work established the critical methodologies that would later be scaled and generalized into the full @SRB and the adaptive control framework. It provided the first concrete evidence that a simulation-centric approach, grounded in procedural diversity and robust perception, could successfully bridge the @sim-to-real gap for a complex space robotics task. This chapter recounts that foundational experiment, detailing its successes and exposing the limitations that motivated the more advanced work to come.

#v(-1.0em)

== Core Concepts <sec:foundation:concepts>

#v(-0.5em)

The research focused on the task of vision-based robotic grasping of previously unknown objects in a simulated lunar @environment. Grasping was selected as it is a prerequisite for a vast range of mission-critical operations, from sample collection and @ISRU to the assembly and maintenance of infrastructure. The goal was not merely to solve this specific problem but to use it as a testbed for establishing a set of core principles for learning generalizable @policy:pl. Four key concepts were central to this initial investigation.

#block(breakable: false, width: 100%)[
  First, the work revolved around a simulation-centric development approach. This principle acknowledges the prohibitive cost and practical constraints of collecting large datasets for modern @RL through physical trials in space. The safety-critical nature and logistical constraints of extraterrestrial operations make the virtual world the primary training ground. This decision necessitated the development of a simulation that was not only physically and visually realistic but also sufficiently diverse to foster the robust @generalization required for real-world deployment.
]

Second, to achieve this diversity, the research introduced the use of @PCG for creating environmental assets. This concept directly confronts the limitations of training on static, finite datasets of 3D models. Such datasets fail to capture the sheer variability of an unknown @environment like the lunar surface. Custom pipelines that synthesize a wide variety of terrains and rocks algorithmically make the training distribution effectively infinite. This approach forces the @agent to learn the general physical principles of grasping rather than memorizing the specific visual features of a limited set of objects.

Third, the research challenged the sufficiency of traditional 2D image-based observations for complex 3D manipulation. It proposed a novel approach based on 3D @octree representations of the @environment. The hypothesis was that a 3D data structure would provide a more natural and robust input for a @policy that must reason about objects and movements in three-dimensional space. A 3D representation can reduce view dependence, but remains affected by occlusion and point-cloud sampling. The @octree was chosen specifically for its computational and memory efficiency compared to dense voxel grids~@wang2017ocnn @wang2020deep @riegler2017octnet.

Finally, the control was formulated in the robot's @task-space to support transfer across different robotic arms. A @policy that learns to command individual joint angles is intrinsically tied to a specific kinematic structure. By instead commanding the desired displacement of the @EE in @cartesian-space, the @policy abstracts over joint kinematics, while portability still requires compatible observations, workspaces, and control mappings. These four concepts, when integrated, formed the blueprint for the successful proof-of-concept experiment detailed in this chapter.

== Simulation-Centric Approach <sec:foundation:simulation>

#block(breakable: false, width: 100%)[
  The entire development and training pipeline for this foundational study was centered within a custom simulation @environment. This approach was not a matter of convenience but a response to the practical constraints of @RL. The millions of interactions required to train a deep neural network @policy make data collection on physical hardware impractical, especially for a safety-critical and inaccessible domain like space. The primary goal, therefore, was to create a virtual world that was not just a replica of a single scenario but a diverse and challenging testbed for learning.
]

The @environment was built using the Gazebo robotics simulator~@koenig2004design. It was chosen for its open-source nature, which promotes reproducibility, and its mature and extensible architecture. For this contact-rich grasping task, physical realism was paramount. The simulation leveraged the DART physics engine for its stable and accurate handling of rigid-body dynamics~@lee2018dart. Visual fidelity was achieved using the OGRE 2 rendering engine, which provided @PBR capabilities for more realistic lighting and material interactions. The resulting @environment was designed to encapsulate the key characteristics of a mobile manipulation task on the lunar surface. It integrated a simulated rover with an articulated robotic arm and a stereo camera for visual perception.

=== Procedural Generation of Assets <ssec:foundation:simulation:assets>

A core innovation of this early work was the extensive use of @PCG to create the environmental assets. This strategy directly addressed the inadequacy of existing 3D model datasets for this specific domain. While large-scale datasets of common objects exist, they are not representative of the natural, geological forms found on planetary surfaces. Manually creating thousands of unique rock and terrain models would be prohibitively time-consuming. @PCG provided a scalable solution.

New pipelines were created using the Geometry Nodes feature of @Blender. These node-based systems allowed for the programmatic and parametric creation of assets, as conceptualized in @fig:foundation:procgen_pipeline. For the terrain, a flat 2D plane was programmatically displaced using a combination of procedural noise textures to create an uneven surface with features resembling impact craters. For the rocks, simple convex polyhedra were similarly displaced to generate a wide variety of shapes and sizes, including complex non-convex geometries. Each generated model was also assigned a random set of @PBR material textures from a static dataset to increase visual diversity. This approach allowed for the creation of a nearly unlimited number of unique @environment:pl from a small set of procedural rules.

#figure(
  caption: dynamic-caption(
    [The procedural generation pipeline for creating diverse lunar assets. It uses @Blender's Geometry Nodes to generate terrains and rocks, which are then exported with @PBR textures via automated Python scripts for direct use in the Gazebo simulator.],
    [Procedural generation pipeline for creating diverse lunar assets],
  ),
  image("../figures/3_foundation/simforge_procedure.svg", width: 92.5%),
) <fig:foundation:procgen_pipeline>

Extensive @DR was applied during training. In each @episode, the simulation randomized the pose of the rover, the camera extrinsics, the terrain model, the number and models of the rocks, their physical properties like density and friction, and even the direction of the simulated sunlight to mimic the harsh illumination conditions on the Moon~@tobin2017domain. This constant variation was essential for preventing the @agent from @overfit:pl and for encouraging the development of a robust, generalizable @policy.

#block(breakable: false, width: 100%)[
  The simulated task involved a Summit XL-GEN mobile manipulator, a rover equipped with a 7-@DoF Kinova Gen2 robotic arm and a three-finger gripper, as shown in @fig:foundation:robot. The @agent's task was to grasp one of the procedurally generated rocks scattered in its workspace and lift it to a specified height. Visual perception of the scene was provided by a simulated stereo camera, a sensor choice motivated by its prevalence on actual space rovers~@grotzinger2012mars. The camera produced both monochromatic images and depth maps of the scene from the perspective of the rover base.
]

#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [The Summit XL-GEN mobile manipulator, with a 7-DoF Kinova Gen2 robotic arm and a stereo camera, which was used in both the simulation and the physical experiments.],
      [The Summit XL-GEN mobile manipulator],
    ),
    image("../figures/3_foundation/summit_xl_gen.png", width: 60%),
  ) <fig:foundation:robot>
]

To maintain focus on the core manipulation skill, the problem was constrained to the immediate workspace of the manipulator. Any prior movement of the rover was assumed to be handled by other means. The simulation @environment provided a standardized interface compatible with modern @RL frameworks, specifically following the OpenAI Gym @API~@brockman2016openai and supported by the Gym-Ignition library~@ferigo2020gymignition. This allowed for seamless integration with the learning algorithm and facilitated a structured, episodic formulation of the grasping task. Communication between the simulation, the learning @agent, and the robot control stack was managed using @ROS 2~@macenski2022ros2. This choice simplified the eventual transfer of the learned @policy to the physical robot by providing an identical software interface in both the simulated and real domains.

== End-to-End Learning from 3D Octree Observations <sec:foundation:learning>

The learning methodology for this initial study was designed to directly map sensory inputs to robot actions in an @end-to-end fashion. This approach contrasts with traditional robotics pipelines that segment a task into discrete stages such as perception, pose estimation, grasp planning, and motion execution. Such pipelines can be brittle, as errors from an earlier stage can compound and lead to failure in later stages. An @end-to-end @policy, in contrast, learns a single function that maps raw observations directly to task-space commands, which can lead to more robust and reactive behaviors, albeit often at the cost of reduced interpretability and explainability~@levine2015end.

The approach, illustrated in @fig:foundation:system_overview, was built on the key innovation of using a compact 3D data structure for representing the visual scene while employing a model-free @RL algorithm for @policy optimization. The task-space action representation can support reuse across robot kinematics when observation, workspace, and control mappings are compatible. Procedural variation exposed the @agent to visual diversity during training. The grasping task was formulated as an @MDP, and the @agent's objective was to find an optimal @policy $pi^*$ that maximizes the expected discounted return from @eq:background:return.

#figure(
  caption: dynamic-caption(
    [An overview of the end-to-end learning approach. Visual data from a stereo camera is converted into a 3D @octree representation. This, along with proprioceptive data, is fed into a shared feature extractor. The resulting features are then used by separate actor and critic networks to produce continuous task-space actions for the robot @EE.],
    [System overview of the end-to-end learning approach],
  ),
  image("../figures/3_foundation/system_overview.svg", width: 100%),
) <fig:foundation:system_overview>

=== Octree-Based Scene Representation <ssec:foundation:learning:octree>

A central hypothesis of this work was that traditional 2D image-based observations are suboptimal for learning 3D manipulation tasks. While 2D convolutional networks generalize well over the horizontal and vertical position of features in an image, they do not inherently understand the spatial relationships of a three-dimensional world, a limitation noted in other robotics research~@gualtieri2018pick. To address this, the visual scene was represented as a 3D @octree, a choice motivated by the need for a data structure that is computationally efficient and provides a rich geometric representation suitable for 3D convolutional networks~@ahmed2018deep.

The process of constructing the observation, illustrated in @fig:foundation:perception_pipeline, began by converting the depth map and monochromatic image from the simulated stereo camera into a point cloud. This point cloud was transformed into the robot base coordinate frame and cropped to a fixed volume of $40$ cm $times$ $40$ cm $times$ $40$ cm. This fixed volume was then used to construct the @octree, a hierarchical data structure that efficiently represents the 3D space by recursively subdividing it into eight octants~@riegler2017octnet. Unlike a dense voxel grid, an @octree only recursively subdivides and stores data for occupied space, making it highly efficient for the sparse scenes typical of a robot workspace.

#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [The process of creating an #gls("octree")-based scene representation. A raw point cloud is generated from sensor data. This point cloud is then transformed into the robot base coordinate frame and cropped to a fixed volume. Finally, it is voxelized into an efficient @octree data structure, which serves as the primary visual input for the learning @agent.],
      [The octree creation pipeline],
    ),
    image("../figures/3_foundation/octree_creation_sketch.svg", width: 100%),
  ) <fig:foundation:perception_pipeline>
]

#block(breakable: false, width: 100%)[
  #v(0.75em)
  To provide the @agent with a rich description of the scene, three distinct features were computed and stored in the leaf nodes of the @octree for each occupied cell, as depicted in @fig:foundation:octree_features. These features were the average unit normal vector $overline(n)$, which provided crucial information about the local surface geometry, the average distance of the points from the cell center $overline(d)$, and the average intensity $overline(i)$ for textural information. This multimodal feature set gave the @agent a compact yet descriptive summary of the scene's geometry and appearance. The observation was completed with proprioceptive data, including the gripper's pose using a continuous 6D rotation representation~@zhou2019continuity and its open or closed state.
]

#v(-0.75em)

#figure(
  caption: dynamic-caption(
    [A representation of the features stored within a single leaf octant of the @octree. All points from the source point cloud that fall within the volume of a cell are used to compute the average unit normal vector $overline(n)$, the average distance to the cell center $overline(d)$, and the average intensity $overline(i)$.],
    [Features stored in a single octree leaf node],
  ),
  image("../figures/3_foundation/octree_features_sketch.svg", width: 45%),
) <fig:foundation:octree_features>

=== Model-Free Reinforcement Learning <ssec:foundation:learning:model_free_rl>

To learn the grasping @policy, a model-free, @off-policy @actor-critic algorithm known as @TQC was employed~@kuznetsov2020controlling. @TQC is a variant of @SAC~@haarnoja2018soft that is well-suited for continuous control problems. It operates under the maximum entropy @RL framework, which augments the standard reward objective with an entropy term to encourage exploration.

A novel neural network architecture, shown in @fig:foundation:network_architecture, was designed to process the 3D @octree observations. It adapted an #gls("octree")-based convolutional network~@wang2017ocnn to serve as a shared feature extractor for both the actor and critic. This feature extractor processed the @octree through a series of 3D convolutions and pooling layers to produce a compact @latent-space representation of the scene. Sharing the feature extractor reduces the total number of learnable parameters and allows both the @policy and the @value-function to benefit from a common, rich representation of the state.

The @policy learned by the @agent used a task-space action representation to support reuse across robots with compatible observation, workspace, and control mappings. The action space $cal(A)$ was defined in the @cartesian-space of the @EE:

#v(-0.25em)

$
  a_t = [Delta x, Delta y, Delta z, Delta phi_z, g_a]
$ <eq:foundation:action_space>

#place(bottom, float: true)[
  #v(-0.5em)
  #figure(
    caption: dynamic-caption(
      [The network architecture for @octree observations. The encoder uses 3D convolutions followed by max pooling and pointwise convolution. Extracted visual features are flattened, combined with proprioception, stacked, and then used by the @actor-critic networks.],
      [The actor-critic network architecture for octree observations],
    ),
    image(
      "../figures/3_foundation/actor_critic_network_stacked.svg",
      width: 100%,
    ),
  ) <fig:foundation:network_architecture>
  #v(0.5em)
]

where the first four terms represent the relative translational displacement and yaw rotation of the gripper, and $g_a$ is a continuous value controlling the gripper's state. These high-level commands were then sent to the MoveIt 2 motion planning framework, which used a combination of the TRAC-IK solver and the RRT-Connect planner to calculate the necessary joint movements to execute the action while ensuring collision-free motion~@beeson2015tracik @kuffner2000rrt.

To guide the learning process, a shaped @reward-function was used. The task was decomposed into four sequential stages, namely reaching, touching, grasping, and lifting. The @agent received a sparse positive reward upon the completion of each stage, with the reward value increasing exponentially to incentivize progress through the entire sequence. This provided a denser learning signal that guided the @agent toward the final goal.

== Sim-to-Real Validation in a Lunar Analog Facility <sec:foundation:validation>

The ultimate test for any @policy trained entirely in simulation is its performance in the physical world. For space robotics, this validation must take the form of a @zero-shot-transfer. The @policy must work out of the box. The final phase of this foundational research was therefore a rigorous @zero-shot-transfer experiment to validate the effectiveness of the developed approach.

This experiment was conducted in the LunaLab, a unique lunar-analog facility at the University of Luxembourg~@ludivig2020building. The LunaLab is specifically designed to replicate the visual characteristics of the lunar surface. It features a basin filled with basalt gravel that mimics the appearance of lunar @regolith, and a configurable light projector that can reproduce the harsh illumination found on the Moon. This facility provided a realistic and challenging testbed for the physical validation.

The Summit XL-GEN mobile manipulator used in the simulation was employed for the physical experiments, as shown in @fig:foundation:real_setup. The real robot was equipped with an Intel RealSense D435 stereo camera that was mounted at the base of the rover. To systematically evaluate the core hypotheses, the experiment was designed around two key variables, namely the type of sensory observation, either a 2D image or a 3D @octree, and the level of environmental diversity during training, reduced or full @DR. The real-world task involved scattering a set of eight different physical rocks, shown in @fig:foundation:real_rocks, within the robot workspace and tasking the @agent with grasping one of them over 25 independent trials for each condition.

#place(auto, float: true)[
  #figure(
    caption: dynamic-caption(
      [The physical setup for the @sim-to-real validation experiments, conducted in the LunaLab facility at the University of Luxembourg. It holds 20 tons of basalt gravel~@ludivig2020building.],
      [Physical setup in the LunaLab facility],
    ),
    image("../figures/3_foundation/real_setup.png", width: 100%),
  ) <fig:foundation:real_setup>
]
#place(auto, float: true)[
  #v(-2.5em)
  #figure(
    caption: dynamic-caption(
      [The eight physical rocks used during the @sim-to-real evaluation.],
      [The eight physical rocks used for evaluation],
    ),
    image("../figures/3_foundation/test_rocks.svg", width: 100%),
  ) <fig:foundation:real_rocks>
  #v(2.5em)
]

#place(bottom, float: true)[
  #v(-0.75em)
  #figure(
    caption: dynamic-caption(
      [A successful real-world grasp sequence.],
      [A successful real-world grasp sequence],
    ),
    image("../figures/3_foundation/real_grasp_sequence_2x2.svg", width: 100%),
  ) <fig:foundation:real_grasp_sequence>
  #v(0.75em)
]

#block(breakable: false, width: 100%)[
  A successful grasp sequence is depicted in @fig:foundation:real_grasp_sequence. The @agent, guided solely by its learned @policy, successfully perceives the scene, selects a target rock, approaches it with the gripper, secures a stable grasp, and lifts it off the ground. Despite the limited @sim-to-real success rate, the quantitative results from @tab:foundation:sim_to_real_results reveal two critical insights. First, @agent:pl trained in the fully randomized simulation @environment demonstrated considerably better performance on the real robot than those trained in the static @environment with reduced @DR. This result was all the more striking given that the @agent:pl trained with reduced randomization achieved much higher success rates within their low-diversity simulation @environment used during training. This demonstrated that they had not learned a generalizable skill but had effectively @overfit to the small and predictable set of scenarios. These results support the importance of environmental diversity for bridging the @sim-to-real gap.
]

#[
  #show: format-table(none, none, auto)
  #figure(
    table(
      columns: 3,

      table.header(
        [Observation Type], [Level of Randomization], [Success Rate ($N = 25$)]
      ),
      [Image], [Reduced], [#"12%"],
      [Image], [Full], [#"20%"],
      [Octree], [Reduced], [#"8%"],
      [Octree], [Full], [#"32%"],
    ),
    caption: dynamic-caption(
      [Quantitative results of the @sim-to-real transfer experiment.],
      [Sim-to-real transfer success rates],
    ),
  ) <tab:foundation:sim_to_real_results>
]

Second, in these 25-trial conditions, the @agent trained with 3D @octree observations and full @DR achieved the highest observed count (8/25, compared with 5/25 for the 2D image condition under full @DR). This provides evidence of feasibility under the tested conditions, but does not establish general statistical superiority for 3D scene representations. The successful demonstration of a learned @policy grasping previously unseen physical rocks in a realistic analog facility marked a critical milestone and demonstrated the viability of the simulation-centric learning pipeline.

== Limitations and Key Takeaways <sec:foundation:takeaways>

#block(breakable: false, width: 100%)[
  This foundational study on learning to grasp on the Moon yielded several key insights that profoundly shaped the subsequent research direction of this thesis. It served as a successful proof of concept. It validated the core premise that a simulation-centric approach could be used to train @policy:pl for complex, contact-rich manipulation tasks and successfully transfer them to the real world.
]

First, and most significantly, the study demonstrated the importance of diversity in training under the tested conditions. The @agent:pl trained with full @DR achieved higher success in the physical trials than those trained with reduced @DR. Because procedural assets were used in both conditions, this comparison does not establish the necessity of @PCG. Second, the study observed an advantage for 3D vision when combined with full @DR, but the 25 trials per condition do not establish general superiority. Finally, the successful use of task-space control and a modular software architecture suggested the potential for reuse across robots with compatible observation, workspace, and control mappings.

However, this initial work also revealed several critical limitations that motivated the next phases of research. While the model-free @RL algorithm was successful, its learning process was often sample-inefficient and exhibited instability, especially in the highly varied procedural @environment:pl. This highlighted the need to explore more advanced and data-efficient learning paradigms, such as @MBRL. A learned @world-model could potentially learn to filter out irrelevant environmental variations and enable the @agent to learn more efficiently.

#pagebreak()

Furthermore, the control strategy, while effective for grasping, was based on rigid kinematic control. The @policy had no mechanism for managing contact forces. It could only command a target pose, and the underlying controller would attempt to reach it regardless of resistance. This pointed toward the need to investigate compliant control methodologies like @OSC. A truly adaptive @agent must be able to modulate its physical interaction, not just its position in space.

Lastly, and most importantly, the entire experiment was built around a single simulation @environment for one specific skill. The ad hoc nature of this initial setup was not scalable for comparing different algorithms, testing a wide range of robots, or exploring long-horizon tasks. This infrastructural limitation was the most significant barrier to further progress. It became clear that before more advanced learning methodologies could be developed, a proper foundation had to be built. These limitations directly informed the design of @SRB and the development of the adaptive control framework detailed in the chapters that follow.
