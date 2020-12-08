import 'package:flutter/material.dart';
import '../core/models.dart';

class CocktailDetailPage extends StatelessWidget {
  final AsyncCocktailRepository repository;
  final String id;

  const CocktailDetailPage(this.repository, this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Cocktail>(
        future: repository.fetchCocktailDetails(id),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {
            return _buildDetailScreen(context, snapshot.data);
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildDetailScreen(BuildContext context, Cocktail cocktail) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildToolbar(context, cocktail),
              _buildCocktailInfo(cocktail),
              _buildCocktailIngredients(cocktail),
              _buildCocktailInstruction(cocktail),
              _buildRatingStars(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, Cocktail cocktail) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Image.network(
          cocktail.drinkThumbUrl,
          height: 375,
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          top: 58,
          left: 28,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        Positioned(
          top: 58,
          right: 19,
          child: Icon(Icons.launch, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStar(int index) {
    return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: Color(0xFF2A293A), borderRadius: BorderRadius.all(Radius.circular(24))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            index < 3 ? Icons.star : Icons.star_border,
            size: 32,
            color: Colors.white,
          ),
        ));
  }

  Widget _buildCategoryWidget(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(color: Color(0xffeaeaea), fontSize: 14),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(color: Color(0xFF15151C), borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0, bottom: 6.0),
                child: Text(value, style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _wrapIngredient(IngredientDefinition e) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, top: 8, bottom: 8),
      child: Row(
        children: [
          Text(e.ingredientName,
              style: TextStyle(color: Colors.white, fontSize: 14, decoration: TextDecoration.underline)),
          Spacer(flex: 1),
          Text(e.measure ?? "", style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCocktailInfo(Cocktail cocktail) {
    return Container(
      color: Color(0xFF1A1927),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  cocktail.name ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Spacer(flex: 1),
                Icon(
                  cocktail.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Id:${cocktail.id ?? ""}",
                style: TextStyle(color: Color(0xff848396), fontSize: 13),
              ),
            ),
            _buildCategoryWidget('Категория коктейля', cocktail.category.name),
            _buildCategoryWidget('Тип коктейля', cocktail.cocktailType.name),
            _buildCategoryWidget('Тип стекла', cocktail.glassType.name),
          ],
        ),
      ),
    );
  }

  Widget _buildCocktailInstruction(Cocktail cocktail) {
    return Container(
      color: Color(0xFF201F2C),
      child: Padding(
        padding: const EdgeInsets.only(left: 26, right: 26, top: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 24),
              child: Text('Инструкция для приготовления:', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
            Text(cocktail.instruction, style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Container(
      color: Color(0xFF1A1927),
      child: Padding(
        padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 24.0, bottom: 24.0),
        child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) => _buildStar(index))),
      ),
    );
  }

  Widget _buildCocktailIngredients(Cocktail cocktail) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text('Ингредиенты:', style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            children: cocktail.ingredients.map((e) => _wrapIngredient(e)).toList(),
          ),
        )
      ],
    );
  }
}
