import 'package:flutter/material.dart';
import 'package:skeleton_morph/skeleton_morph.dart';

void main() {
  runApp(const SkeletonMorphExampleApp());
}

class SkeletonMorphExampleApp extends StatelessWidget {
  const SkeletonMorphExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skeleton Morph Example',
      home: SkeletonTheme(
        config: SkeletonConfig(),
        child: ProductPage(),
      ),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('skeleton_morph'),
        actions: [
          Switch(
            value: isLoading,
            onChanged: (value) => setState(() => isLoading = value),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return SkeletonMorph(
            enabled: isLoading,
            child: const ProductCard(
              title: 'Shampoo natural revitalizador',
              description: 'Producto natural para el cuidado del cabello.',
              price: '\$25.000',
            ),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
  });

  final String title;
  final String description;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonHint.image(
              width: 96,
              height: 96,
              borderRadius: BorderRadius.circular(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 96,
                  height: 96,
                  color: Colors.green.shade100,
                  child: const Icon(Icons.spa, size: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 12),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
