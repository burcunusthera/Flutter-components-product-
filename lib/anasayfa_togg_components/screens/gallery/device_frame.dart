import 'package:flutter/material.dart';

/// Tasarımın 375×812 çerçevesi: ekrana sığacak şekilde ölçeklenir, iç düzen 375 genişlikte kalır.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({super.key, required this.child, this.width = 375, this.height = 812});

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Container(
          width: width,
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 8))],
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            removeLeft: true,
            removeRight: true,
            child: child,
          ),
        ),
      ),
    );
  }
}
