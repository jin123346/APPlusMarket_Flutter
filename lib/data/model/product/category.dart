class Category {
  int? id;
  String? categoryName;
  List<Category>? subCategory;
  int? parentId;

  Category(
      {required this.id,
      required this.categoryName,
      this.subCategory = null,
      this.parentId = 0});

  Category copyWith({
    int? id,
    String? categoryName,
    List<Category>? subCategory,
    int? parentId,
  }) {
    return Category(
        id: id ?? this.id,
        categoryName: categoryName ?? this.categoryName,
        subCategory: subCategory ?? this.subCategory,
        parentId: parentId ?? this.parentId);
  }

  factory Category.fromMap(Map<String, dynamic> json) {
    List<Category> getSubCate = [];

    if (json.containsKey('subCategoryList') &&
        json['subCategoryList'] != null) {
      getSubCate = (json['subCategoryList'] as List)
          .map((sub) => Category.fromMap(sub))
          .toList();
    }

    return Category(
      id: json['id'],
      categoryName: json['categoryName'],
      parentId: json.containsKey('parentId') ? json['parentId'] : null,
      subCategory: getSubCate,
    );
  }
}
