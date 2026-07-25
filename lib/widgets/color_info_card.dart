import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/color_picker_service.dart';

class ColorInfoCard extends StatelessWidget {
  final Color color;

  const ColorInfoCard({
    super.key,
    required this.color,
  });

  Future<void> _copyText(
    BuildContext context,
    String text,
    String label,
  ) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildValue(
    BuildContext context, {
    required String label,
    required String value,
    TextStyle? style,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _copyText(
          context,
          value,
          label,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Text(
            value,
            style: style ??
                Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final hex = ColorPickerService.getHex(color);
    final rgb = ColorPickerService.getRgb(color);
    final hsv = ColorPickerService.getHsv(color);
    final hsl = ColorPickerService.getHsl(color);

    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: scheme.outlineVariant,
            ),
          ),
        ),

        const SizedBox(height: 16),

        _buildValue(
          context,
          label: 'HEX',
          value: hex,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        _buildValue(
          context,
          label: 'RGB',
          value: rgb,
        ),

        _buildValue(
          context,
          label: 'HSV',
          value: hsv,
        ),

        _buildValue(
          context,
          label: 'HSL',
          value: hsl,
        ),

        const SizedBox(height: 10),

        Text(
          'Tap any value to copy',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}