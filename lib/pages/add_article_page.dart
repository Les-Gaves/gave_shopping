import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  static const _defaultImageUrl =
      'https://storage.googleapis.com/images_gave/istockphoto-1980276924-612x612.jpg';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: '0');
  final _imageUrlController = TextEditingController();

  String? _category;
  bool _loading = false;
  String? _error;

  // Toutes les catégories sauf "tous", qui n'est qu'un filtre d'affichage.
  final _categories =
      MockData.categories.where((c) => c.id != 'tous').toList();

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final imageUrl = _imageUrlController.text.trim();
      final product = await ProductService.instance.addProduct(
        name: _nameController.text.trim(),
        category: _category!,
        brand: _brandController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.replaceAll(',', '.')),
        stock: int.parse(_stockController.text),
        imageUrl: imageUrl.isEmpty ? _defaultImageUrl : imageUrl,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('« ${product.name} » a été ajouté au catalogue.'),
          backgroundColor: AppTheme.riverPrimary,
        ),
      );
      Navigator.of(context).pop();
    } catch (_) {
      setState(() => _error = "Impossible d'ajouter l'article. Réessayez.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter un article',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.riverDark),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Nouvel article',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.riverDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Les champs marqués * sont obligatoires.',
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 24),

                      // Nom
                      TextFormField(
                        controller: _nameController,
                        decoration: _decoration('Nom *', Icons.label_outline),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Saisissez un nom'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Marque
                      TextFormField(
                        controller: _brandController,
                        decoration: _decoration('Marque', Icons.sell_outlined),
                      ),
                      const SizedBox(height: 14),

                      // Catégorie
                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: _decoration('Catégorie *', Icons.category_outlined),
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _category = v),
                        validator: (v) =>
                            v == null ? 'Choisissez une catégorie' : null,
                      ),
                      const SizedBox(height: 14),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: _decoration('Description', Icons.notes_outlined),
                      ),
                      const SizedBox(height: 14),

                      // Prix + Stock
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: _decoration('Prix TTC (€) *', Icons.euro),
                              validator: (v) {
                                final value = double.tryParse(
                                    (v ?? '').replaceAll(',', '.'));
                                if (value == null) return 'Prix invalide';
                                if (value < 0) return 'Prix négatif';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: _stockController,
                              keyboardType: TextInputType.number,
                              decoration: _decoration('Stock *', Icons.inventory_2_outlined),
                              validator: (v) {
                                final value = int.tryParse(v ?? '');
                                if (value == null) return 'Nombre entier';
                                if (value < 0) return 'Stock négatif';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Image
                      TextFormField(
                        controller: _imageUrlController,
                        keyboardType: TextInputType.url,
                        decoration: _decoration(
                          "URL de l'image (optionnel)",
                          Icons.image_outlined,
                        ),
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.safetyOrangeLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Color(0xFF7A2508), fontSize: 13),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loading ? null : _submit,
                        icon: _loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.add),
                        label: const Text("Ajouter l'article"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: AppTheme.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
