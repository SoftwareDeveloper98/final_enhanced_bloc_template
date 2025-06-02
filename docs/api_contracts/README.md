# API Contracts

This directory is intended to store and manage API contract definitions that the Flutter application relies on for communication with backend services. Maintaining clear, versioned API contracts is crucial for decoupling frontend and backend development and ensuring smooth integration.

## Purpose
-   **Single Source of Truth:** Provides a definitive reference for the structure of API requests and responses.
-   **Code Generation:** Enables automated generation of client-side networking code (DTOs/models, API service interfaces) using tools like OpenAPI Generator, Chopper, or gRPC tools.
-   **Clear Communication:** Facilitates clear communication and agreement between frontend, backend, and QA teams regarding API behavior.
-   **Version Management:** Helps in tracking changes to APIs over time.

## Types of Contracts

Depending on the backend technologies and architectural choices, this directory might contain:

1.  **OpenAPI Specifications (formerly Swagger):**
    *   Files are typically in YAML (`.yaml` or `.yml`) or JSON (`.json`) format (e.g., `openapi_v1.yaml`).
    *   These specifications describe RESTful APIs, including endpoints, request/response schemas, authentication methods, etc.
    *   **Tooling:** [OpenAPI Generator](https://openapi-generator.tech/) can be used to generate Dart client code from these specs. This often includes models (DTOs) and API client classes.
    *   **Location:** Store spec files directly here, possibly in versioned subdirectories (e.g., `openapi/v1/spec.yaml`, `openapi/v2/spec.yaml`).

2.  **GraphQL Schemas:**
    *   Files typically have a `.graphql` or `.graphqls` extension (e.g., `schema.graphql`).
    *   Defines the types, queries, mutations, and subscriptions available from a GraphQL API.
    *   **Tooling:** Packages like `artemis` or `graphql_codegen` can generate Dart types and client code from GraphQL schemas.
    *   **Location:** Store schema files here.

3.  **Protocol Buffers (Protobuf):**
    *   Files have a `.proto` extension (e.g., `user_service.proto`).
    *   Used for defining gRPC services and message structures.
    *   **Tooling:** The `protoc` compiler with Dart plugins (`protoc_plugin`) is used to generate Dart message classes and gRPC client stubs.
    *   **Location:** Store `.proto` files here, often organized by service or domain.

4.  **JSON Schema Definitions:**
    *   If not using OpenAPI but still needing to define JSON structures, JSON Schema files (`.json`) can be used.
    *   These are less common for full API client generation but can be useful for validation or manual model creation.

## Management and Workflow

-   **Source:** Ideally, API contracts are designed and maintained by the backend team or through a collaborative design process involving both frontend and backend.
-   **Version Control:** All contract files should be version-controlled in Git.
-   **Code Generation Integration:**
    *   The process of generating Dart code from these contracts should be automated as much as possible.
    *   This can be done via scripts (e.g., shell scripts, Dart scripts using build tools) that invoke the relevant code generation tools.
    *   Generated code is typically placed in a specific part of the Flutter project (e.g., `lib/core/network/generated/` or `lib/data/remote/generated/`).
    *   It's common to include these generation scripts in `melos.yaml` or as part of a pre-build step.
-   **Updates:** When an API contract changes:
    1.  The updated contract file is pulled into this directory.
    2.  The client code generation process is re-run.
    3.  The Flutter application code is updated to adapt to any changes in the generated models or API methods.

By centralizing API contracts, we ensure that the Flutter app interacts correctly with backend services and can adapt to API changes in a controlled and efficient manner.
