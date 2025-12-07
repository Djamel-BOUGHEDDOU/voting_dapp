import 'package:flutter/material.dart';

class PrivateKeySheet extends StatelessWidget {
  final void Function(String privateKeyHex) onSubmit;
  const PrivateKeySheet({required this.onSubmit, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Enter your private key (hex) to sign the vote', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Private key (hex)', border: OutlineInputBorder()),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (v) {
              final val = v.trim();
              if (val.isNotEmpty) onSubmit(val);
            },
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final val = controller.text.trim();
                  if (val.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a private key')));
                    return;
                  }
                  onSubmit(val);
                },
                child: const Text('Submit & Sign'),
              ),
            )
          ]),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
