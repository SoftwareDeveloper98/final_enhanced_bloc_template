# Core Contracts

This directory is intended for stable data contracts (entities, DTOs if universally shared)
that can be referenced by multiple features and core modules without creating circular dependencies.

Models here should have minimal dependencies themselves and represent shared understanding
of data structures across different parts of the application.

For example:
-   Shared domain entities that are used by multiple features.
-   Universally applicable DTOs that are not tied to a single feature's API interaction.

Subdirectories like `entities/`, `dtos/`, or `value_objects/` can be used to organize these contracts.
The key is that these contracts should be stable and broadly applicable to avoid coupling
between features that might otherwise need to share data definitions.
