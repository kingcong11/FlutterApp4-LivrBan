import 'package:flutter/material.dart';
import 'package:livrban/providers/product_provider.dart';
// import 'package:flutter/services.dart';

/* Packages */
import 'package:provider/provider.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/* Providers */
// import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

/* Screens */
// import './my_bag_screen.dart';

/* Widgets */
// import '../widgets/badge.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'product/edit';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  /* Properties */
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInitialized = false;
  var _isLoading = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '0',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrlPreview);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrlPreview);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    /* I placed this initialization of productId here because modalRoute or arguments coming from
    a route doesn't work inside initstate, so i placed it here and add a logic so that this initialization
    only run once, any initialization or special data that is needed to be loaded beforehand is placed inside initstate */

    if (!_isInitialized) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      // remove this later, testing purposes
      _initValues = {
        'title': 'Testing',
        'description': 'sample description',
        'price': '123',
      };
      _imageUrlController.text =
          'assets/images/products/10-removebg-preview.png';
    }

    _isInitialized = true;
    super.didChangeDependencies();
  }

  /* Builders */
  Widget _appbarBuilder(BuildContext context) {
    return AppBar(
      title: const Text(
        'Edit Product',
        style: TextStyle(fontSize: 20),
      ),
      centerTitle: true,
      actions: [
        // Consumer<Cart>(
        //   builder: (context, cart, child) {
        //     return Badge(
        //       child: child,
        //       value: cart.itemCount.toString(),
        //     );
        //   },
        //   child: IconButton(
        //     icon: Icon(FeatherIcons.shoppingBag),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(MyBagScreen.routeName);
        //     },
        //   ),
        // ),
      ],
      elevation: 0,
    );
  }

  /* Getters */
  double _computeMainContentSize(MediaQueryData mediaQuery, AppBar appbar) {
    return (mediaQuery.size.height -
        (appbar.preferredSize.height + mediaQuery.padding.top));
  }

  /* Methods */
  void _updateImageUrlPreview() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.endsWith('jpg') ||
          _imageUrlController.text.endsWith('png') ||
          _imageUrlController.text.endsWith('jpeg') ||
          _imageUrlController.text.isEmpty) {
        setState(() {});
      } else {
        return;
      }
    }
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();
    if (isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });

      if (_editedProduct.id != null) {
        /* Update product */
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        /* Add a new product */
        try {
          await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('An error Occured!'),
                  content: Text('Something went wrong'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('Okay'),
                    ),
                  ],
                );
              });
        } finally {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _appbar = _appbarBuilder(context);
    final _mediaQuery = MediaQuery.of(context);
    final _availableContentSize = _computeMainContentSize(_mediaQuery, _appbar);

    return Scaffold(
      appBar: _appbar,
      body: SafeArea(
        child: (_isLoading)
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      key: _form,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              initialValue: _initValues['title'],
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: value,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: _editedProduct.imageUrl,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: _initValues['price'],
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                labelText: 'Price',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field is required';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid amount.';
                                }
                                if (double.parse(value) <= 0) {
                                  return 'Amount should be greater than zero.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: double.parse(value),
                                  imageUrl: _editedProduct.imageUrl,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: _initValues['description'],
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  title: _editedProduct.title,
                                  description: value,
                                  price: _editedProduct.price,
                                  imageUrl: _editedProduct.imageUrl,
                                );
                              },
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  alignment: Alignment.center,
                                  margin:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  child: (_imageUrlController.text.isEmpty)
                                      ? Text('Image Preview')
                                      : Image.asset(
                                          _imageUrlController.text,
                                          fit: BoxFit.scaleDown,
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      controller: _imageUrlController,
                                      focusNode: _imageUrlFocusNode,
                                      style: TextStyle(color: Colors.black87),
                                      decoration: InputDecoration(
                                        labelText: 'Image URL',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.url,
                                      onEditingComplete: () => setState(() {}),
                                      onFieldSubmitted: (value) => _saveForm(),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'This field is required';
                                        }
                                        if (!value.endsWith('jpg') &&
                                            !value.endsWith('png') &&
                                            !value.endsWith('jpeg')) {
                                          return 'Enter a valid URL';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _editedProduct = Product(
                                          id: _editedProduct.id,
                                          isFavorite: _editedProduct.isFavorite,
                                          title: _editedProduct.title,
                                          description:
                                              _editedProduct.description,
                                          price: _editedProduct.price,
                                          imageUrl: value,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            FlatButton(
                              minWidth: 100,
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => _saveForm(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
