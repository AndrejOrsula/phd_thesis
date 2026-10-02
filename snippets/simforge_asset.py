class Asteroid(GeometryBase):
    # Procedural pipeline
    nodes: Nodes = Nodes("geo_nodes.py")

    # Configurable asset properties
    detail: int = 5
    scale: Sequence[float] = (1.0, 1.0, 1.0)
    ...
