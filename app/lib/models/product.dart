class Product {
  final String prodName;
  final double cost;
  final String unit;
  final String imageURl;
  final String description;
  final int grade;
  final int pdId;
  final String gradeDesc;
  final bool disponibility;
  final bool isFav;

  const Product({
    required this.pdId,
    required this.prodName,
    required this.cost,
    required this.unit,
    required this.imageURl,
    required this.description,
    required this.grade,
    required this.gradeDesc,
    required this.disponibility,
    required this.isFav,
  });
}
