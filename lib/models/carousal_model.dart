class CarousalModel {
  String? images;

  CarousalModel({this.images});

  factory CarousalModel.fromJson(Map<String, dynamic> json) {
    return CarousalModel(
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['images'] = images;
    return data;
  }
}
