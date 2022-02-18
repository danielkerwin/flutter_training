import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.provider.dart';
import 'package:shop_app/providers/products.provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  String _title = 'Add Product';
  bool _isLoading = false;

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _product = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initialForm = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initForm();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    final isValid = _form.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    _form.currentState?.save();

    final provider = Provider.of<Products>(context, listen: false);
    String message = 'Product added';

    try {
      if (_product.id.isNotEmpty) {
        await provider.updateOne(_product);
      } else {
        await provider.addOne(_product);
      }
      Navigator.of(context).pop();
    } catch (err) {
      message = 'Oops, something went wrong - try again later $err';
    } finally {
      setState(() => _isLoading = false);
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.hideCurrentSnackBar();
      scaffold.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void initForm() {
    final productId = ModalRoute.of(context)?.settings.arguments;
    _title = productId != null ? 'Edit Product' : 'Add Product';

    if (productId != null) {
      _product = Provider.of<Products>(context).getOneById(productId as String);
      _initialForm = {
        'title': _product.title,
        'price': '${_product.price}',
        'description': _product.description,
        'imageUrl': _product.imageUrl,
      };
      _imageUrlController.value = TextEditingValue(text: _product.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialForm['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (val) => _product = Product(
                        id: _product.id,
                        title: val as String,
                        description: _product.description,
                        price: _product.price,
                        imageUrl: _product.imageUrl,
                        isFavorite: _product.isFavorite,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Must provide a title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initialForm['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (val) => _product = Product(
                        id: _product.id,
                        title: _product.title,
                        description: _product.description,
                        price: double.tryParse(val ?? '0') ?? 0,
                        imageUrl: _product.imageUrl,
                        isFavorite: _product.isFavorite,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Must provide a price';
                        }
                        if (double.tryParse(val) == null) {
                          return 'Price must be a number';
                        }
                        if (double.parse(val) < 0) {
                          return 'Price must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initialForm['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (val) => _product = Product(
                        id: _product.id,
                        title: _product.title,
                        description: val as String,
                        price: _product.price,
                        imageUrl: _product.imageUrl,
                        isFavorite: _product.isFavorite,
                      ),
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Must provide a description';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Enter a URL',
                                  ),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              setState(() {});
                              _saveForm();
                            },
                            focusNode: _imageUrlFocusNode,
                            onSaved: (val) => _product = Product(
                              id: _product.id,
                              title: _product.title,
                              description: _product.description,
                              price: _product.price,
                              imageUrl: val as String,
                              isFavorite: _product.isFavorite,
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Must provide an image URL';
                              }
                              if (!val.startsWith('http')) {
                                return 'Must be a valid URL';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
