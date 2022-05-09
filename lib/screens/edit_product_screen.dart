import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static final String routeName = '/edit-product';

  @override
  State<StatefulWidget> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imgUrl: '');

  var _isInit = true;
  var _initValue = {'title': '', 'description': '', 'price': '', 'imgUrl': ''};
  var isLoading = false;

  @override
  void initState() {
    _imgUrlFocusNode.addListener(_loadImgUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imgUrl': _editedProduct.imgUrl
        };
        _imageUrlController.text = _editedProduct.imgUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(_loadImgUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _loadImgUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      var value = _imageUrlController.text.toString();
      if ((!value.startsWith('http') && !value.startsWith('https')) ||
          (!value.endsWith('.png') &&
              !value.endsWith('.jpg') &&
              !value.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    _formKey.currentState?.save();
    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .setProduct(_editedProduct);
      } catch (onError) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text('something wrong!'),
                  content: Text(onError.toString()),
                  actions: [
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okey'),
                    ),
                  ]);
            });
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }

    }

    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    //Navigator.of(context).pop();

    // print('title: ${_editedProduct.title}');
    // print('description: ${_editedProduct.description}');
    // print('price: ${_editedProduct.price}');
    // print('Image Url: ${_editedProduct.imgUrl}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product Screen'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (value) => _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value.toString(),
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imgUrl: _editedProduct.imgUrl,
                          isFavorite: _editedProduct.isFavorite),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (value) => _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value.toString()),
                        imgUrl: _editedProduct.imgUrl,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price must be greater than zero';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) => _editedProduct = Product(
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value.toString(),
                        price: _editedProduct.price,
                        imgUrl: _editedProduct.imgUrl,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length <= 10) {
                          return 'Description must be more than 10 character';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 16,
                            right: 8,
                          ),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter IMG URL')
                              : Container(
                                  child: FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text.trim(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imgUrlFocusNode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Image URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Image URL not valid';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              setState(() {});
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) => _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imgUrl: value.toString(),
                              isFavorite: _editedProduct.isFavorite,
                            ),
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
