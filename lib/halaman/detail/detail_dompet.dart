// lib/halaman/detail/detail_dompet.dart
import 'package:flutter/material.dart';
import 'package:myapp/model/dompet_model.dart';

class DetailDompet extends StatelessWidget {
  final Dompet dompet;

  const DetailDompet({super.key, required this.dompet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dompet.namaDompet),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Dompet:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              dompet.namaDompet,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Saldo:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Rp ${dompet.saldo.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
