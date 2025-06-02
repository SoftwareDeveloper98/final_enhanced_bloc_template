// lib/core/network/ssl_pinning_dio_adapter.dart
import 'package:dio/dio.dart';
// import 'dart:io'; // For HttpClient, SecurityContext (if manually configuring)
// import 'package:flutter/services.dart'; // For rootBundle if loading certs from assets

// To use native_dio_adapter, add to pubspec.yaml:
// native_dio_adapter: ^1.2.1 # Or latest (check pub.dev)
// import 'package:native_dio_adapter/native_dio_adapter.dart'; // Example of a preferred adapter

// --- IMPORTANT NOTE ---
// This file provides a conceptual outline for SSL pinning with Dio.
// Actual implementation is HIGHLY dependent on the chosen Dio HttpClientAdapter
// and the specific SSL pinning library or native capabilities used.
//
// RECOMMENDED ADAPTERS for easier SSL Pinning:
// - native_dio_adapter: Uses platform-native networking libraries (iOS NSURLSession, Android OkHttp).
//                       These often have more robust and simpler ways to configure pinning.
// - cronet_dio_adapter: Uses Google's Cronet engine, which also supports pinning.
//
// The code below is more illustrative of the concepts rather than a direct runnable solution
// without a specific adapter that supports these patterns easily.
// Using a library like `ssl_pinning_plugin` or `http_certificate_pinning` might also be an option,
// but they often work at a lower level than Dio adapters or require their own HTTP clients.

class SslPinningDioAdapter {
  static Future<void> configureAdapter(Dio dio, {List<String> allowedSha256Fingerprints = const []}) async {
    if (allowedSha256Fingerprints.isEmpty) {
      print("SSL Pinning: No SHA256 fingerprints provided. Pinning will not be enabled.");
      // In a production app, you might want to throw an error here or have a stricter policy.
      return;
    }

    // Option 1: Using an adapter like native_dio_adapter (Preferred for simplicity and robustness)
    // This is a conceptual representation. The actual API might differ slightly.
    /*
    if (dio.httpClientAdapter is NativeAdapter) { // Check if it's the NativeAdapter or a similar type
      final nativeAdapter = dio.httpClientAdapter as NativeAdapter;

      // The native_dio_adapter might have a method like this:
      // (This is hypothetical, check the package's actual API)
      // nativeAdapter.configureHttpPinning(
      //   host: 'your.api.domain.com', // Important: Pin only to your domain(s)
      //   pins: allowedSha256Fingerprints.map((hash) => Pin(sha256: hash)).toList(),
      //   // includeSubdomains: true, // Optional
      //   // validationMode: PinValidationMode.chainTrust, // Optional
      // );

      // Or, for some native adapters, it might be a global configuration or per-request.
      // For native_dio_adapter, you might pass pinning configuration when creating the adapter instance
      // that you then assign to dio.httpClientAdapter.
      // e.g. dio.httpClientAdapter = NativeAdapter(
      //   config: NativeAdapterConfig(
      //     httpPins: [
      //       HttpPin(
      //         pattern: 'your.api.domain.com', // Host pattern
      //         sha256Pins: allowedSha256Fingerprints,
      //       ),
      //       // Add more HttpPin objects for other domains if needed
      //     ],
      //   ),
      // );

      print("SSL Pinning: Attempted to configure via a NativeAdapter pattern (conceptual).");
      print("Ensure your chosen adapter (e.g., native_dio_adapter) is correctly set up and its API is used.");
    } else {
      print("SSL Pinning: Dio adapter is not a known native adapter type that supports easy pinning configuration. Manual setup might be needed or switch adapter.");
    }
    */

    // Option 2: Manual configuration with SecurityContext (More Complex, Less Recommended for Dio)
    // This approach is generally harder to get right with Dio because Dio abstracts away the HttpClient.
    // It's more common when using `dart:io` HttpClient directly.
    // If your Dio adapter exposes `onHttpClientCreate` (like DefaultHttpClientAdapter), you might try:
    /*
    if (dio.httpClientAdapter is DefaultHttpClientAdapter) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        // SecurityContext context = SecurityContext(withTrustedRoots: true); // Start with default CAs
        // try {
        //   // Example: Load custom certificate if pinning to a specific CA or self-signed cert
        //   // ByteData data = await rootBundle.load('assets/certs/my_certificate.pem');
        //   // context.setTrustedCertificatesBytes(data.buffer.asUint8List());
        // } catch (e) {
        //   print("SSL Pinning: Error loading certificate from assets: $e");
        // }

        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          // IMPORTANT: This is where your pinning logic goes.
          // 1. Extract the public key from `cert`.
          // 2. Compute its SHA-256 hash.
          // 3. Compare the hash with your `allowedSha256Fingerprints`.
          // This is non-trivial. You'd need a robust way to get the public key hash.

          // String? certFingerprint = _computePublicKeySha256(cert); // Conceptual
          // if (certFingerprint != null && allowedSha256Fingerprints.contains(certFingerprint)) {
          //   print('SSL Pinning: Certificate for $host VALID (matches fingerprint $certFingerprint)');
          //   return true; // Pin matched, certificate is trusted
          // }
          // print('SSL Pinning: Certificate for $host REJECTED. Fingerprint $certFingerprint not in allowed list.');
          // return false; // Pin validation failed, reject certificate

          // FIXME: Placeholder - DO NOT USE THIS LINE IN PRODUCTION. This bypasses all cert checks.
          print("SSL Pinning: BAD CERTIFICATE CALLBACK - CURRENTLY BYPASSING. IMPLEMENT PROPER LOGIC.");
          return true; // This line makes it insecure for testing only.
        };
        return client;
      };
      print("SSL Pinning: Attempted to configure via DefaultHttpClientAdapter.onHttpClientCreate (conceptual).");
    } else {
       print("SSL Pinning: DefaultHttpClientAdapter not in use, manual onHttpClientCreate setup skipped.");
    }
    */

    // TODO: Replace the conceptual parts above with actual SSL pinning logic
    // based on the chosen Dio adapter (e.g., native_dio_adapter, cronet_dio_adapter)
    // and your certificate management strategy.
    //
    // Ensure to:
    // 1. Securely store and provide your certificate SHA-256 public key hashes.
    // 2. Implement a strategy for certificate rotation (e.g., by including backup pins
    //    or fetching updated pins from a secure, separate endpoint - though this has risks).
    // 3. Test thoroughly on both Android and iOS.
    print("Placeholder: SSL Pinning for Dio should be configured here using a suitable adapter and valid SHA256 fingerprints.");
    if (allowedSha256Fingerprints.isNotEmpty) {
        print("SSL Pinning: Configured with fingerprints: $allowedSha256Fingerprints (Conceptual - ensure adapter applies this)");
    }
  }

  // Conceptual helper function for SHA256 fingerprinting of a public key.
  // Actual implementation requires careful handling of X.509 certificate parsing (ASN.1)
  // and cryptographic hashing. Libraries like `pointycastle` can help.
  // static String? _computePublicKeySha256(X509Certificate cert) {
  //   // Steps:
  //   // 1. Get the certificate in DER format (cert.der).
  //   // 2. Parse the DER to extract the SubjectPublicKeyInfo (SPKI) block.
  //   //    The SPKI contains the algorithm identifier and the public key itself.
  //   // 3. SHA-256 hash the raw bytes of the SPKI block.
  //   // 4. Base64 encode the hash.
  //   //
  //   // This is complex. For example, using OpenSSL command line:
  //   // openssl s_client -connect your.api.domain.com:443 | openssl x509 -pubkey -noout | openssl rsa -pubin -outform der | openssl dgst -sha256 -binary | openssl base64
  //   // Or for EC keys, replace `openssl rsa` with `openssl ec`.
  //   //
  //   // In Dart, you might need pointycastle or platform channels to native crypto APIs.
  //   // logger.warning("SSL Pinning: _computePublicKeySha256 is conceptual and not implemented.");
  //   return null;
  // }
}
