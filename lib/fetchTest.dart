class Recipes {
  final String name;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final int prepTime;
  final int cookTime;
  final int totalTime;


  Recipes({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
  });

  Recipes.fromJson(Map<String, Object?> json)
      : name = json['name'] as String? ?? '',
        description = json['description'] as String? ?? '',
        imageUrl = json['imageUrl'] as String? ?? '',
        ingredients = (json['ingredients'] as List<dynamic>? ?? []).map((item) => item as String).toList(),
        instructions = json['instructions'] as String? ?? '',
        prepTime = json['prepTime'] as int? ?? 0,
        cookTime = json['cookTime'] as int? ?? 0,
        totalTime = json['totalTime'] as int? ?? 0;


  Map<String, Object?> toJson(){
    return {
      'name':name,
      'description':description,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions':instructions,
      'prepTime':prepTime,
      'cookTime':cookTime,
      'totalTime':totalTime,
    };
  }

}