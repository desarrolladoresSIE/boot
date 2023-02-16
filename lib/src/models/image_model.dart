class Imagemodel {
  final String? url;


  Imagemodel({
    this.url,
  });

  factory Imagemodel.fromMapJson(Map<String, dynamic> json) => Imagemodel(
        url: json['url'],
      );


}
