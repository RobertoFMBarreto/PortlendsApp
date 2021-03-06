import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:portlends/models/category_arguments.dart';
import 'package:portlends/models/product.dart';
import 'package:portlends/models/subcategory.dart';
import 'package:portlends/providers/httpService.dart';
import 'package:portlends/providers/subcategories.dart';
import 'package:portlends/widgets/appbar.dart';
import 'package:portlends/widgets/product_item.dart';
import 'package:portlends/widgets/search_bar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int tag = -1;
  String search = '';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CategoryArguments;
    final mediaQuery = MediaQuery.of(context);
    final HttpService httpService = HttpService();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: httpService.getSubCategories(args.categoryID),
        builder: (BuildContext context, AsyncSnapshot<List<SubCategoria>> snapshot) {
          if (snapshot.hasData) {
            SubCategories subcategories = SubCategories(subcategorias: snapshot.requireData);
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  MyAppBar(
                    innerBoxIsScrolled: innerBoxIsScrolled,
                    height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.27,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    bottom: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          args.categoryName,
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.02,
                      ),
                      InputTextBox(
                        hint: 'Pesquisar Produtos',
                        onChanged: (text) {
                          setState(() {
                            search = text;
                          });
                        },
                      ),
                      SizedBox(
                        height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.02,
                      ),
                      ChipsChoice<int>.single(
                        value: tag,
                        onChanged: (val) {
                          setState(() => tag = val);
                          setState(() {
                            search = '';
                          });
                        },
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: subcategories.getFormatedStrings(),
                          value: (i, v) => subcategories.subcategorias[i].subcategoriaId,
                          label: (i, v) => v,
                        ),
                        choiceStyle: C2ChoiceStyle(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          showCheckmark: true,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          borderColor: Colors.blueGrey.withOpacity(.5),
                        ),
                        choiceActiveStyle: C2ChoiceStyle(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          showCheckmark: true,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          borderColor: Colors.blueGrey.withOpacity(.5),
                          brightness: Brightness.dark,
                        ),
                      ),
                    ],
                  ),
                ];
              },
              body: FutureBuilder(
                future: tag >= 0
                    ? httpService.getProductsSubCategory(args.categoryID, tag, search)
                    : httpService.getAllProducts(args.categoryID, search),
                builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                  if (snapshot.hasData) {
                    List<Product> _products = snapshot.requireData;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(0),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 40,
                          );
                        },
                        itemCount: _products.length,
                        itemBuilder: (_, index) {
                          return ProductItem(
                            prodId: _products[index].pdId,
                            prodName: _products[index].prodName,
                            cost: _products[index].cost,
                            unit: _products[index].unit,
                            imageURl: _products[index].imageURl,
                            isFav: _products[index].isFav,
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text('Getting Data');
                  }
                },
              ),
            );
          } else {
            return const Text('Getting Data');
          }
        },
      ),
    );
  }
}
