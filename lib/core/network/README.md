# Core Network Layer

This directory contains the core networking setup for the application, including the `NetworkService` abstraction, its Dio-based implementation (`DioNetworkService`), custom exceptions, and SSL pinning configurations.

## NetworkService
-   **`network_service.dart`**: Defines the abstract `NetworkService` class, which outlines the contract for making HTTP requests (GET, POST, PUT, DELETE). This allows for dependency inversion and makes it easier to test features that depend on network calls by mocking the `NetworkService`.
-   **`dio_network_service.dart`**: An implementation of `NetworkService` using the `dio` package. It handles:
    *   Base URL configuration.
    *   Timeouts.
    *   Interceptors for logging, adding authentication tokens (e.g., Bearer token from `SecureStorageService`), and potentially token refresh logic.
    *   Error handling and mapping `DioException`s to custom `NetworkException` types.
-   **`exceptions.dart`**: Defines custom exception classes like `NetworkException`, `ServerException`, `UnauthorizedException`, etc., to provide more specific error information to the application layers.

## SSL Pinning
-   **`ssl_pinning_dio_adapter.dart`**: Contains conceptual guidance and placeholder code for implementing SSL/TLS certificate pinning with Dio.
    *   **Importance:** SSL pinning is a crucial security measure that helps prevent man-in-the-middle (MitM) attacks by ensuring the application only communicates with servers that present a trusted, specific certificate (or public key). It complements standard TLS chain-of-trust validation.
    *   **Strategy:** Instead of just trusting any certificate signed by a CA in the device's trust store, the app "pins" the known certificate(s) or public key(s) of its backend servers.
    *   **Recommended Dio Adapters:**
        *   **`native_dio_adapter`**: Leverages platform-native networking libraries (iOS `NSURLSession`, Android OkHttp). These libraries often provide more robust and straightforward APIs for configuring SSL pinning. This is generally the **preferred approach** for new projects due to better performance, system integration (e.g., proxy settings), and easier pinning setup.
        *   **`cronet_dio_adapter`**: Uses Google's Cronet engine, which is the networking stack from Chromium. It's highly performant and also supports certificate pinning.
        *   Using the default `DefaultHttpClientAdapter` with manual `badCertificateCallback` is more complex and error-prone for pinning.
    *   **Implementation:** The actual pinning logic (validating certificate chains or public key hashes) is highly dependent on the chosen Dio adapter. The `ssl_pinning_dio_adapter.dart` file provides comments and conceptual code snippets for different approaches.
    *   **Certificate Rotation:**
        *   **Backup Pins:** Include SHA-256 hashes of not only your current server certificate's public key but also a backup or future certificate's public key. This allows you to rotate server certificates without immediately breaking older app versions.
        *   **Remote Pin List (Use with Extreme Caution):** Some systems attempt to fetch updated pin lists from a separate, highly secured endpoint. This is complex to implement securely, as the endpoint itself needs to be trustworthy and protected. It adds another point of failure.
        *   **App Updates:** The most common strategy is to update the app with new pins before the current server certificate expires.
    *   **Obtaining SHA-256 Hashes:** You need to calculate the SHA-256 hash of the SubjectPublicKeyInfo (SPKI) of your server's certificate(s). Tools like OpenSSL can be used for this. Example:
        ```bash
        openssl s_client -servername your.api.domain.com -connect your.api.domain.com:443 < /dev/null | \
        openssl x509 -pubkey -noout | \
        openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl base64
        ```
        (Adjust `rsa` to `ec` if using an EC key). Store these Base64 encoded hashes in your app for the pinning check.

## Configuration
-   The `DioNetworkService` is typically registered as a singleton in the DI setup (e.g., `lib/core/di/core_services_module.dart`).
-   SSL pinning should be configured early in the app's lifecycle, ideally when the `Dio` instance is created within `DioNetworkService`.
-   Environment variables (e.g., via `String.fromEnvironment`) can be used for `BASE_URL`.

This setup aims to provide a robust, secure, and maintainable networking layer for the application. Remember to consult the documentation of `dio` and any chosen adapters for the most up-to-date and detailed configuration instructions.
