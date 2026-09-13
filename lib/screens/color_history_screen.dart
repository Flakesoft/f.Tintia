import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/color_history_service.dart';
import '../services/color_picker_service.dart';

class ColorHistoryScreen extends StatefulWidget {
  const ColorHistoryScreen({
    super.key,
  });

  @override
  State<ColorHistoryScreen> createState() => _ColorHistoryScreenState();
}

class _ColorHistoryScreenState extends State<ColorHistoryScreen> {
  List<Color> _savedColors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadColors();
  }

  Future<void> _loadColors() async {
    final colors = await ColorHistoryService.getSavedColors();

    if (!mounted) {
      return;
    }

    setState(() {
      _savedColors = colors.reversed.toList();
      _isLoading = false;
    });
  }

  Future<void> _removeColor(Color color) async {
    await ColorHistoryService.removeColor(color);

    if (!mounted) {
      return;
    }

    setState(() {
      _savedColors.removeWhere(
        (savedColor) =>
            savedColor.toARGB32() == color.toARGB32(),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Color removed from history'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _clearHistory() async {
    if (_savedColors.isEmpty) {
      return;
    }

    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear color history?'),
          content: const Text(
            'All saved colors will be removed from your history.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true) {
      return;
    }

    await ColorHistoryService.clearColors();

    if (!mounted) {
      return;
    }

    setState(() {
      _savedColors = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Color history cleared'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _copyHex(Color color) async {
    final hex = ColorPickerService.getHex(color);

    await Clipboard.setData(
      ClipboardData(text: hex),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$hex copied'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildColorTile(Color color) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hex = ColorPickerService.getHex(color);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: scheme.surfaceContainerLow,
      child: InkWell(
        onTap: () => _copyHex(color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hex,
                      style: theme.textTheme.labelLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remove color',
                    onPressed: () => _removeColor(color),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_outlined,
              size: 64,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 20),
            Text(
              'No saved colors yet',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Save colors from the color picker and they will appear here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color History'),
        actions: [
          if (_savedColors.isNotEmpty)
            IconButton(
              tooltip: 'Clear history',
              onPressed: _clearHistory,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _savedColors.isEmpty
              ? _buildEmptyState(context)
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    int crossAxisCount;

                    if (width >= 1000) {
                      crossAxisCount = 6;
                    } else if (width >= 700) {
                      crossAxisCount = 4;
                    } else if (width >= 450) {
                      crossAxisCount = 3;
                    } else {
                      crossAxisCount = 2;
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(24),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: _savedColors.length,
                      itemBuilder: (context, index) {
                        return _buildColorTile(
                          _savedColors[index],
                        );
                      },
                    );
                  },
                ),
    );
  }
}