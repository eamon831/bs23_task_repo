class Repository {
  final String? name;
  final String? description;
  final String? language;
  final int? stars;
  final int? forks;

  Repository({
    this.name,
    this.description,
    this.language,
    this.stars,
    this.forks,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'],
      description: json['description'],
      language: json['language'],
      stars: json['stargazers_count'],
      forks: json['forks_count'],
    );
  }
  Map<String,dynamic>toJson()=>{

      "name":name,
      "description":description,
      "language":language,
      "stargazers_count":stars,
      "forks_count":forks,
  };

  static List<Repository> mapJSONStringToList(List<dynamic> jsonList) {
    List<Repository> list = [];
    jsonList.forEach((json) {
      list.add(Repository.fromJson(json));
    });
    return list;
  }
}