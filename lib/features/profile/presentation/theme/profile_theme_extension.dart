import 'package:flutter/material.dart';

// Define a ThemeExtension for profile-specific theme properties
@immutable
class ProfileThemeExtension extends ThemeExtension<ProfileThemeExtension> {
  const ProfileThemeExtension({
    required this.profileAvatarBorderColor,
    required this.profileHeaderColor,
    this.actionButtonColor,
  });

  final Color? profileAvatarBorderColor;
  final Color? profileHeaderColor;
  final Color? actionButtonColor; // Example of another property

  // Define a light theme version
  static const light = ProfileThemeExtension(
    profileAvatarBorderColor: Colors.blue,
    profileHeaderColor: Colors.lightBlueAccent,
    actionButtonColor: Colors.blueGrey,
  );

  // Define a dark theme version
  static const dark = ProfileThemeExtension(
    profileAvatarBorderColor: Colors.cyan,
    profileHeaderColor: Colors.blueGrey,
    actionButtonColor: Colors.tealAccent,
  );

  @override
  ProfileThemeExtension copyWith({
    Color? profileAvatarBorderColor,
    Color? profileHeaderColor,
    Color? actionButtonColor,
  }) {
    return ProfileThemeExtension(
      profileAvatarBorderColor: profileAvatarBorderColor ?? this.profileAvatarBorderColor,
      profileHeaderColor: profileHeaderColor ?? this.profileHeaderColor,
      actionButtonColor: actionButtonColor ?? this.actionButtonColor,
    );
  }

  @override
  ProfileThemeExtension lerp(ThemeExtension<ProfileThemeExtension>? other, double t) {
    if (other is! ProfileThemeExtension) {
      return this;
    }
    return ProfileThemeExtension(
      profileAvatarBorderColor: Color.lerp(profileAvatarBorderColor, other.profileAvatarBorderColor, t),
      profileHeaderColor: Color.lerp(profileHeaderColor, other.profileHeaderColor, t),
      actionButtonColor: Color.lerp(actionButtonColor, other.actionButtonColor, t),
    );
  }

  // Optional: helper method to easily access the extension from context
  // static ProfileThemeExtension? of(BuildContext context) {
  //   return Theme.of(context).extension<ProfileThemeExtension>();
  // }
}

// Example Usage in a widget:
//
// class ProfileAvatar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final profileTheme = Theme.of(context).extension<ProfileThemeExtension>();
//     // final profileTheme = ProfileThemeExtension.of(context); // if using the static helper
//
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: profileTheme?.profileAvatarBorderColor ?? Colors.grey, // Fallback color
//           width: 2.0,
//         ),
//       ),
//       // ... other properties
//     );
//   }
// }
