import 'package:flutter/material.dart';

/* Packages */
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';


class ProductsGridFilters extends StatelessWidget {
  const ProductsGridFilters({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Filters',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(
          width: 5,
        ),
        Icon(
          FeatherIcons.filter,
          color: Colors.white,
          size: 19,
        ),
        SizedBox(
          width: 15,
        ),
        const Text(
          'Sort by',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(
          width: 5,
        ),
        Icon(
          MdiIcons.sortReverseVariant,
          color: Colors.white,
          size: 22,
        ),
      ],
    );
  }
}