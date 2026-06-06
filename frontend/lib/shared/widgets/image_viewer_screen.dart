import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/deliveries/presentation/providers/deliveries_provider.dart';
import '../../core/router/app_routes.dart';

class ImageViewerScreen extends ConsumerWidget {
  final String imageUrl;
  final String? sourceAddress;
  const ImageViewerScreen({super.key, required this.imageUrl, this.sourceAddress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carta'),
        centerTitle: true,
        actions: [
          if (sourceAddress != null)
            TextButton(
              onPressed: () {
                ref.read(deliveryPrefillProvider.notifier).state = DeliveryPrefill(pickupAddress: sourceAddress);
                final pickup = Uri.encodeComponent(sourceAddress ?? '');
                context.go('${AppRoutes.deliveries}?pickup=$pickup');
              },
              child: const Text('Solicitar domi', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 56, color: Colors.grey)),
          ),
        ),
      ),
    );
  }
}
