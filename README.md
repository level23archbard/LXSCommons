# LXSCommons

This package contains my personal suite of reusable chunks of swift code.

It may be fairly volatile, as I will add new functions, change extensions, and move some components to new packages at my discretion. I make no guarantee that this package or any of its libraries are suitable to use for your own project.

Some core libraries:
- LXSCommons: A standalone set of reusable extensions and helpful objects. I'll add to this library any code I use in more than one project, and may move content to its own library if it grows large enough.
- LXSLogging: A logger, included in the LXSCommons library. This one exception to the package, I will do my best to keep this one stable. I may add content to it at any time and rework internals, but external APIs should never change.
- LXSRandom: A probability and random generator framework, included in the LXSCommons library. This library will generally have functions related to producing randomization of varying distributions.
- LXSJson: A standalone JSON wrapper. This library serves as an intermediate between raw JSON data and codable, fixed structs or objects. It borrows heavily from javascript concepts to work with JSON data as completely arbitrary and flexible objects of any type.
- LXSGridGeometry: A standalone math library that works with integer-based geometries. It mostly consists of structs that help represent a grid and iterate through it.
- LXSLinearAlgebra: A standalone math library that works with vectors and matrices. It utilizes underlying Accelerate-based support, and is intended to simplify those interactions.
- LXSPluginMP, LXSPluginSCN: Any extension library to another library will be its own standalone. These may be very volatile, as I may arbitrarily move content in and out to their own libaries or even packages as needed.
