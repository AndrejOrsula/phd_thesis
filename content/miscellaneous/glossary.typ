#let entry_list = (
  // =====
  // Space
  // =====
  (
    key: "ESA",
    long: "European Space Agency",
    group: "Space",
    description: [An intergovernmental organization of member states dedicated to the research and exploration of space.],
  ),
  (
    key: "NASA",
    long: "National Aeronautics and Space Administration",
    group: "Space",
    description: [An agency of the United States responsible for the civil space program and research.],
  ),
  (
    key: "JAXA",
    long: "Japan Aerospace Exploration Agency",
    group: "Space",
    description: [The Japanese national agency responsible for space exploration, research, and development.],
  ),
  (
    key: "ISS",
    long: "International Space Station",
    group: "Space",
    description: [A modular space station in low Earth orbit, serving as a microgravity and space research laboratory.],
  ),
  (
    key: "EVA",
    long: "extravehicular activity",
    longplural: "extravehicular activities",
    group: "Space",
    description: [An activity performed outside a spacecraft in a space environment, often involving tasks like assembly, maintenance, and scientific research.],
  ),
  (
    key: "ISAM",
    long: "in-space servicing, assembly, and manufacturing",
    group: "Space",
    description: [A paradigm of space operations focused on servicing existing satellites, assembling large structures in orbit, and manufacturing components directly in space.],
  ),
  (
    key: "ISRU",
    long: "in-situ resource utilization",
    group: "Space",
    description: [The practice of collecting, processing, and utilizing resources found on-site in an extraterrestrial environment to support future robotic and human missions.],
  ),
  (
    key: "cislunar",
    group: "Space",
    description: [The region of space between the Earth and the Moon.],
  ),
  (
    key: "microgravity",
    group: "Space",
    description: [A condition in which objects are perceived to be weightless, typically experienced in orbital environments.],
  ),
  (
    key: "regolith",
    group: "Space",
    description: [A layer of loose superficial deposits covering solid rock. It includes dust and soil found on the surface of the Moon, Mars, and other celestial bodies.],
  ),
  (
    key: "terramechanics",
    group: "Space",
    description: [The study of the interaction between vehicles and terrain, particularly for off-road traversal on deformable surfaces like sand or regolith.],
  ),
  (
    key: "VandV",
    short: "V&V",
    long: "verification and validation",
    group: "Space",
    description: [A process used to ensure that a system meets specifications and fulfills its intended purpose, particularly in safety-critical applications.],
  ),
  // ========
  // Robotics
  // ========
  (
    key: "ATE",
    long: "average tracking error",
    group: "Robotics",
    description: [A measure of performance for reference tracking problems, defined as the average linear or angular distance between the reference trajectory and the actual trajectory followed by the robot.],
  ),
  (
    key: "teleoperation",
    group: "Robotics",
    description: [The direct control of a remote system by a human operator. In space, this is often hindered by significant communication delays.],
  ),
  (
    key: "cartesian-space",
    short: "Cartesian space",
    group: "Robotics",
    description: [A coordinate system in which the position of a point is defined by its coordinates along a set of mutually perpendicular axes. In robotics, it is often used to describe the position and orientation in 3D space.],
  ),
  (
    key: "task-space",
    short: "task space",
    group: "Robotics",
    description: [The space in which a robotic manipulator operates, defined by the position and orientation of its end-effector.],
  ),
  (
    key: "compliance",
    group: "Robotics",
    description: [The ability of a robotic system to yield or deflect in response to external forces, which is a critical property for physical interaction.],
  ),
  (
    key: "damping",
    group: "Robotics",
    description: [A property of a control system that resists motion with a force proportional to its velocity. In compliant control, it is used to dissipate energy and prevent oscillations.],
  ),
  (
    key: "stiffness",
    group: "Robotics",
    description: [A property of a control system to resist displacement caused by an external force. In compliant control, high stiffness results in rigid behavior and faster response.],
  ),
  (
    key: "DoF",
    long: "degree of freedom",
    plural: "DoF",
    longplural: "degrees of freedom",
    group: "Robotics",
    description: [The number of independent parameters that define the configuration of a mechanical system. For a robotic arm, it typically refers to the number of its actuated joints.],
  ),
  (
    key: "embodiment",
    group: "Robotics",
    description: [The physical form and structure of a robot that includes its morphology, sensors, and actuators. The embodiment fundamentally influences how an agent can interact with and learn about its environment.],
  ),
  (
    key: "EE",
    long: "end-effector",
    group: "Robotics",
    description: [The tool at the end of a robotic arm that is designed to interact with its environment, such as a gripper, scoop, or drill.],
  ),
  (
    key: "IK",
    long: "inverse kinematics",
    group: "Robotics",
    description: [A computational method used in robotics to determine the joint configuration necessary to place the end-effector at a specific position and orientation in Cartesian space.],
  ),
  (
    key: "IMU",
    long: "inertial measurement unit",
    group: "Robotics",
    description: [An electronic device that measures the linear acceleration, angular rate, and sometimes orientation by using a combination of accelerometers, gyroscopes, and magnetometers.],
  ),
  (
    key: "Jacobian",
    group: "Robotics",
    description: [A matrix of first-order partial derivatives that relates the joint velocities of a manipulator to the linear and angular velocities of its end-effector.],
  ),
  (
    key: "kinematics",
    group: "Robotics",
    description: [A branch of mechanics that describes the motion of objects without considering the forces that cause the motion.],
  ),
  (
    key: "octree",
    group: "Robotics",
    description: [A hierarchical data structure in which each internal node has exactly eight children that partition a 3D space through a recursive subdivision.],
  ),
  (
    key: "OSC",
    long: "operational space control",
    group: "Robotics",
    description: [A control methodology for robotic manipulation that formulates the equations of motion and control laws directly in the task space. It allows for the explicit specification of the end-effector compliance via virtual stiffness and damping parameters.],
  ),
  (
    key: "SE3",
    short: "SE(3)",
    long: "special Euclidean group in 3D",
    group: "Robotics",
    description: [The mathematical group representing rigid body motions in 3D space through a combination of all possible translations and rotations.],
  ),
  // ================
  // Machine Learning
  // ================
  (
    key: "agent",
    group: "Machine Learning",
    description: [The learner and decision-maker in a reinforcement learning problem. It perceives its environment and takes actions to maximize a cumulative reward, also known as return.],
  ),
  (
    key: "RNN",
    long: "recurrent neural network",
    group: "Machine Learning",
    description: [A class of neural networks designed for processing sequential data by maintaining a hidden state that captures information about previous inputs.],
  ),
  (
    key: "LSTM",
    long: "long short-term memory",
    group: "Machine Learning",
    description: [A type of recurrent neural network architecture that is capable of learning long-term dependencies in sequential data.],
  ),
  (
    key: "BC",
    long: "behavior cloning",
    group: "Machine Learning",
    description: [A basic form of imitation learning where a policy is trained in a supervised manner to directly mimic the state-action pairs from a demonstration dataset.],
  ),
  (
    key: "DR",
    long: "domain randomization",
    group: "Machine Learning",
    description: [A technique used to bridge the sim-to-real gap by training a policy in a simulation with a wide range of randomized parameters.],
  ),
  (
    key: "environment",
    group: "Machine Learning",
    description: [In reinforcement learning, the world in which the agent exists and interacts. It receives actions from the agent and returns new states and rewards.],
  ),
  (
    key: "episode",
    group: "Machine Learning",
    description: [A single sequence of interactions between an agent and its environment, starting from an initial state and ending in a terminal state.],
  ),
  (
    key: "generalization",
    group: "Machine Learning",
    description: [The ability of a learned policy to perform effectively in scenarios that were not encountered during its training. It is the opposite of overfitting and a core focus of this thesis.],
  ),
  (
    key: "LfD",
    long: "learning from demonstration",
    group: "Machine Learning",
    description: [A machine learning paradigm where an agent learns to perform tasks by observing demonstrations. It can include techniques like imitation learning and behavior cloning.],
  ),
  (
    key: "IL",
    long: "imitation learning",
    group: "Machine Learning",
    description: [A type of machine learning where an agent learns to perform a task by observing and imitating demonstrations from a human or another controller.],
  ),
  (
    key: "latent-space",
    short: "latent space",
    group: "Machine Learning",
    description: [A lower-dimensional representation of high-dimensional data learned by a machine learning model, often used to capture the essential features of the data while discarding noise and redundancy.],
  ),
  (
    key: "MBRL",
    long: "model-based reinforcement learning",
    group: "Machine Learning",
    description: [A class of reinforcement learning algorithms that employ a model of the environment dynamics.],
  ),
  (
    key: "MDP",
    long: "Markov decision process",
    group: "Machine Learning",
    description: [A mathematical framework for modeling decision-making in situations where outcomes are at least partially under the control of an agent. It is the formal foundation for most reinforcement learning problems.],
  ),
  (
    key: "offline-RL",
    short: "offline RL",
    group: "Machine Learning",
    description: [A paradigm in reinforcement learning where the agent learns a policy from a static dataset of interactions, without any active exploration or online data collection.],
  ),
  (
    key: "on-policy",
    group: "Machine Learning",
    description: [A category of reinforcement learning algorithms that update the current policy using only data collected while acting with that same policy.],
  ),
  (
    key: "off-policy",
    group: "Machine Learning",
    description: [A category of reinforcement learning algorithms that can update the current policy using data collected from any policy, typically stored in a replay buffer.],
  ),
  (
    key: "overfit",
    plural: "overfitting",
    group: "Machine Learning",
    description: [To fit a function too closely to a limited set of data points, a modeling error known as overfitting. In reinforcement learning, it results in a policy that performs well on its training environment but fails to generalize to new situations.],
  ),
  (
    key: "policy",
    plural: "policies",
    group: "Machine Learning",
    description: [In reinforcement learning, the strategy used by an agent to determine which action to take in a given state. In deep learning, this function is typically approximated by a neural network.],
  ),
  (
    key: "POMDP",
    long: "partially observable Markov decision process",
    group: "Machine Learning",
    description: [An extension of the Markov decision process where the agent does not directly observe the full state of the environment but instead receives an observation that may be noisy or incomplete.],
  ),
  (
    key: "RL",
    long: "reinforcement learning",
    group: "Machine Learning",
    description: [A type of machine learning where an agent learns to make decisions by taking actions in an environment to maximize a cumulative reward signal.],
  ),
  (
    key: "reward-function",
    short: "reward function",
    group: "Machine Learning",
    description: [A function that defines the goal in a reinforcement learning problem. It provides a numerical signal to the agent at each step to indicate the immediate desirability of its actions.],
  ),
  (
    key: "sample-efficiency",
    short: "sample efficiency",
    group: "Machine Learning",
    description: [A measure of how much data an algorithm requires to learn a task. Algorithms with high sample efficiency can learn effective policies from a relatively small number of environmental interactions.],
  ),
  (
    key: "self-play",
    group: "Machine Learning",
    description: [A training method where an agent improves by playing against other agents, often previous versions of itself. It is a powerful technique for discovering robust and general strategies.],
  ),
  (
    key: "sim-to-real",
    group: "Machine Learning",
    description: [The process and challenge of transferring a policy or model trained in a simulation environment to a physical system operating in the real world.],
  ),
  (
    key: "world-model",
    short: "world model",
    group: "Machine Learning",
    description: [A learned model of environment dynamics used in model-based reinforcement learning. It can predict future states and rewards given the current state and an action.],
  ),
  (
    key: "zero-shot-transfer",
    short: "zero-shot transfer",
    group: "Machine Learning",
    description: [The process of deploying a model or a policy on a new task or in a new environment, without any additional training or fine-tuning on data from the newly encountered scenario.],
  ),
  (
    key: "DreamerV3",
    group: "Machine Learning",
    description: [A model-based reinforcement learning algorithm that learns a latent world model from observations and uses this model to train its actor-critic networks entirely within imagined trajectories.],
  ),
  (
    key: "PPO",
    long: "Proximal Policy Optimization",
    group: "Machine Learning",
    description: [An on-policy actor-critic reinforcement learning algorithm that uses a clipped surrogate objective function to discourage large policy updates and promote stable learning.],
  ),
  (
    key: "SAC",
    long: "Soft Actor-Critic",
    group: "Machine Learning",
    description: [An off-policy actor-critic reinforcement learning algorithm based on the maximum entropy framework, which aims to maximize both the expected return and the entropy of the learned policy.],
  ),
  (
    key: "TD3",
    long: "Twin Delayed Deep Deterministic Policy Gradient",
    group: "Machine Learning",
    description: [An off-policy actor-critic algorithm that addresses value overestimation and instability by taking the minimum of a pair of critic estimates, delaying policy updates, and smoothing target policy actions.],
  ),
  (
    key: "TQC",
    long: "Truncated Quantile Critics",
    group: "Machine Learning",
    description: [An off-policy actor-critic algorithm that extends Soft Actor-Critic with an ensemble of distributional quantile critics, whose pooled predictions are truncated by discarding the highest quantiles to control overestimation bias.],
  ),
  (
    key: "end-to-end",
    group: "Machine Learning",
    description: [A learning approach where a single model is trained to map raw inputs directly to outputs, with all intermediate representations learned jointly under one objective rather than engineered as separate modules. This is often used in complex applications where traditional feature engineering is impractical.],
  ),
  (
    key: "actor-critic",
    group: "Machine Learning",
    description: [A class of reinforcement learning algorithms that use two separate entities in the form of an actor that selects actions based on the current policy and a critic that evaluates the actions by estimating a value function, such as the action-value function. This architecture results in more stable and efficient learning.],
  ),
  (
    key: "value-function",
    short: "value function",
    group: "Machine Learning",
    description: [A function that estimates the expected cumulative reward, also called return, from a given state or state-action pair. It is used to evaluate the quality of states or actions in reinforcement learning.],
  ),
  // ========
  // Software
  // ========
  (
    key: "SRB",
    long: "Space Robotics Bench",
    group: "Software",
    description: [The open-source simulation framework developed in this thesis, designed for robot learning research in diverse and procedurally generated space environments.],
  ),
  (
    key: "PCG",
    long: "procedural content generation",
    group: "Software",
    description: [The programmatic and algorithmic creation of data, such as 3D models and environments. It is used in this thesis to generate diverse training scenarios at scale.],
  ),
  (
    key: "SimForge",
    group: "Software",
    description: [The open-source procedural engine developed in this thesis for generating diverse 3D assets and environments that are particularly tailored for space robotics.],
  ),
  (
    key: "API",
    long: "application programming interface",
    group: "Software",
    description: [A set of protocols for building software applications that define how different software components should interact.],
  ),
  (
    key: "Blender",
    group: "Software",
    description: [A free and open-source computer graphics software used for modeling, sculpting, animation, simulation, texturing, and rendering of 3D content. It is utilized in this thesis for both manual and procedural asset generation.],
  ),
  (
    key: "Gymnasium",
    group: "Software",
    description: [A widely adopted standard interface and library for reinforcement learning environments. All applications developed in this thesis are compliant with this interface.],
  ),
  (
    key: "Isaac-Sim",
    short: "Isaac Sim",
    group: "Software",
    description: [A scalable robotics simulator developed by NVIDIA. It serves as the core backend for the Space Robotics Bench.],
  ),
  (
    key: "middleware",
    group: "Software",
    description: [A framework that acts as a communication bridge between different software components.],
  ),
  (
    key: "PBR",
    long: "physically based rendering",
    group: "Software",
    description: [A computer graphics approach that seeks to render images in a way that models the flow of light in the real world, resulting in more consistent visual appearances.],
  ),
  (
    key: "ROS",
    long: "Robot Operating System",
    group: "Software",
    description: [A framework and set of tools for writing robot software. It is a popular standard for middleware in the robotics research community.],
  ),
  (
    key: "USD",
    long: "Universal Scene Description",
    group: "Software",
    description: [A file format and framework for the interchange of 3D computer graphics data. It is the native format for NVIDIA Isaac Sim.],
  ),
)
