import 'package:flutter/material.dart';

import '../models/image_state.dart';
import 'color_info_card.dart';

class DesktopColorPanel extends StatelessWidget {
  final ImageState? imageState;

  const DesktopColorPanel({
    super.key,
    required this.imageState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (imageState == null) {
      return _buildEmptyState(
        context,
        icon: Icons.palette_outlined,
        message:
            'Select image to show color data',
      );
    }

    if (imageState!.selectedColor == null) {
      return _buildEmptyState(
        context,
        icon: Icons.colorize_outlined,
        message:
            'Click anywhere on image to pick color',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          Text(
            'Color data',
            style: theme.textTheme.titleLarge,
          ),

          const SizedBox(
            height: 24,
          ),

          _buildPalettePlaceholder(
            context,
          ),

          const SizedBox(
            height: 32,
          ),

          Text(
            'Selected color',
            style: theme.textTheme.titleMedium,
          ),

          const SizedBox(
            height: 16,
          ),

          Card(
            elevation: 0,
            color:
                colorScheme.surfaceContainerLow,
            child: Padding(
              padding:
                  const EdgeInsets.all(20),
              child: ColorInfoCard(
                color:
                    imageState!.selectedColor!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPalettePlaceholder(
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Image palette',
          style: theme.textTheme.titleMedium,
        ),

        const SizedBox(
          height: 12,
        ),

        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color:
                colorScheme.surfaceContainerHighest,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color:
                  colorScheme.outlineVariant,
            ),
          ),
          child: Center(
            child: Text(
              'Color palette coming soon',
              style:
                  theme.textTheme.bodyMedium
                      ?.copyWith(
                color:
                    colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String message,
  }) {
    final theme = Theme.of(context);
    final colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color:
                  colorScheme.onSurfaceVariant,
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              message,
              textAlign:
                  TextAlign.center,
              style:
                  theme.textTheme.bodyLarge
                      ?.copyWith(
                color:
                    colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
