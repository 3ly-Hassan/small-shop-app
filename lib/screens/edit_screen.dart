import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_data.dart';
import 'package:shop_app/provider/products-model.dart';

class EditScreen extends StatefulWidget {
  final String id;

  const EditScreen({this.id});
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _isInit = true;
  var _isLoaded = false;
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
  };
  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit && widget.id != null) {
      _editProduct = Provider.of<ProductsData>(context, listen: false)
          .finItemById(widget.id);
      _initValue = {
        'title': _editProduct.title,
        'description': _editProduct.description,
        'price': _editProduct.price.toString(),
      };
      _imageController.text = _editProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageFocusNode.removeListener(_updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _savedForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoaded = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<ProductsData>(context, listen: false)
          .updateItem(widget.id, _editProduct);
    } else {
      try {
        await Provider.of<ProductsData>(context, listen: false)
            .addItem(_editProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            title: Text('an erorr has occured'),
            content: Text('something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('ok!'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
//      finally {
//        setState(() {
//          _isLoaded = false;
//        });
//        Navigator.of(context).pop();
//      }
    }
    setState(() {
      _isLoaded = false;
    });
    Navigator.of(context).pop();
  }

  void _updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Product'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _savedForm();
              })
        ],
      ),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValue['title'],
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              title: value,
                              description: _editProduct.description,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl,
                              favourite: _editProduct.favourite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please Enter a title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['price'],
                        decoration: InputDecoration(labelText: 'price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              title: _editProduct.title,
                              description: _editProduct.description,
                              price: double.parse(value),
                              imageUrl: _editProduct.imageUrl,
                              favourite: _editProduct.favourite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['description'],
                        decoration: InputDecoration(labelText: 'description'),
                        textInputAction: TextInputAction.newline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editProduct = Product(
                              id: _editProduct.id,
                              title: _editProduct.title,
                              description: value,
                              price: _editProduct.price,
                              imageUrl: _editProduct.imageUrl,
                              favourite: _editProduct.favourite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(8),
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.url,
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              controller: _imageController,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageFocusNode,
                              onFieldSubmitted: (_) {
                                _savedForm();
                              },
                              onSaved: (value) {
                                _editProduct = Product(
                                    id: _editProduct.id,
                                    title: _editProduct.title,
                                    description: _editProduct.description,
                                    price: _editProduct.price,
                                    imageUrl: value,
                                    favourite: _editProduct.favourite);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
