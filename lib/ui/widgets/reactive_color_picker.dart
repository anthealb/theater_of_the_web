import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../constants/assets.dart';
import '../../constants/theming.dart';

class ReactiveColorPicker extends StatelessWidget {
  final String formControlName;
  const ReactiveColorPicker({required this.formControlName, super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<Color?, Color?>(
      formControlName: 'color',
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Colore', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: field.errorText == null ? null : Theme.of(context).colorScheme.error))
              .animate(autoPlay: false, target: field.errorText == null ? 0 : 1)
              .custom(duration: 167.milliseconds, builder: Theming.errorShakeBuilder),
          const SizedBox(height: 8),
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: Assets.colors.map((color) => colorButton(color, field)).toList(),
          ),
          if (field.errorText != null) ...[
            Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 8), color: Theme.of(context).colorScheme.error),
            Text(field.errorText!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error)),
          ],
        ],
      ),
    );
  }

  Widget colorButton(Color color, ReactiveFormFieldState<Color?, Color?> field) => SizedBox(
        width: 32,
        height: 32,
        child: MaterialButton(
          mouseCursor: SystemMouseCursors.click,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          color: Theming.colorSchemeLight.onSurface,
          hoverColor: Theming.colorSchemeLight.primary,
          child: Container(
            height: 32,
            width: 32,
            margin: EdgeInsets.all(field.value?.value == color.value ? 2 : 1.5),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: field.value?.value == color.value ? const Icon(Icons.check_rounded) : null,
          ),
          onPressed: () {
            field.didChange(color);
          },
        ),
      );
}
