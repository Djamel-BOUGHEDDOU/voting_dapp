import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TxHeader extends StatelessWidget {
  final String txHash;
  const TxHeader({required this.txHash, super.key});

  @override
  Widget build(BuildContext context) {
    if (txHash.isEmpty) return const SizedBox.shrink();
    return Card(
      child: ListTile(
        leading: const Icon(Icons.lock),
        title: const Text('Latest tx hash'),
        subtitle: Text(txHash, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.content_paste),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: txHash));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Copied tx hash')));
          },
        ),
      ),
    );
  }
}
