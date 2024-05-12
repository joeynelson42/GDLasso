# GDLasso
GDLasso is a Swift package that provides a discrete, composable architecture pattern for the [Godot game engine](https://github.com/godotengine/godot).

GDLasso is essentially [Lasso](https://github.com/ww-tech/lasso), an open-source iOS architecture project, repurposed for Godot.

## How can it be used?
GDLasso is written in Swift and thus cannot be used directly in Godot (yet...). However, leveraging [SwiftGodot](https://github.com/migueldeicaza/SwiftGodot) you can write GDExtensions in Swift with GDLasso as an SwiftPM dependency.

## How does it work?
Similar to other unidirectional, reactive frameworks, the `View` sends actions to the `Store` which updates the `State` which the `View` is observing. In the context of Godot, the `View` is a `Node`.

The real power comes from composition. `Flows` are the "glue code" that manage multiple `Stores` and facilitate communication between them. `Stores` can communicate `Output` to `Flows` for this purpose.

As an example:
1. The `EnvironmentNode` notices a Node3D has walked into a patch of lava.
2. It communicates this to its store, `EnvironmentStore`.
3. `EnvironmentStore` then it dispatches `Output` to the `Flow`, notifying it that something has stepped into lava.
4. The `Flow` checks if it was the player, and if so it informs the `PlayerStore` that the player has taken damage from lava.
5. The `PlayerStore` applies damage to the player by reducing the `Health` value in its `State`.

See the [Example project](https://github.com/joeynelson42/GDLasso/tree/main/Example) for more details.

### Seems...overly complicated
It can seem complicated at first, especially when compared to Godot's Signals. However, Signals are (subjectively) an anti-pattern. In small projects Signals are great, and can help things move quickly, but when projects grow in size Signals cannot be managed sanely.

Think about it this way: A conversation with one other person in an empty room is straightforward, but once the room is full of people and those people are all having conversations with several other people simultaneously, conversation is impossible/infuriating.

By creating discrete, single-responsibility entities we can:
1. Keep control of our lines of communication.
2. Test each entity in a vacuum.
3. Reuse entities in different contexts.

## Usage
1. Create a Swift GDExtension using SwiftGodot
2. Add GDLasso as a dependency of your Swift GDExtension
3. Build your extension using the GDLasso pattern.

## Roadmap
I am currently using GDLasso to build [Riposte](https://github.com/joeynelson42/riposte). As I make progress there I will make improvements to GDLasso. The core concepts won't change, but APIs might be unstable for a while.

Things I'd like to see improved:
1. Flows, currently they're nothing more than an empty protocol. All "glue" functionality is totally custom.
2. More opinionated usage instructions.
