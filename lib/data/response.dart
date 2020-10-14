import 'data.dart';

class Response {

  final int currentPage;
  final List<Data> data;
	final int perPage;
	final String path;
	final Object prevPageUrl;
	final Object nextPageUrl;
	final String firstPageUrl;
	final String lastPageUrl;
	final int lastPage;
	final int total;
	final int from;
	final int to;

  Response({this.currentPage, this.data, this.perPage, this.path,
		this.prevPageUrl, this.nextPageUrl, this.firstPageUrl, this.lastPageUrl,
		this.lastPage, this.total, this.from, this.to});

	factory Response.fromJsonMap(Map<String, dynamic> map) {
		return Response(currentPage: map["current_page"],
		data: List<Data>.from(map["data"].map((it) => Data.fromJsonMap(it))),
		firstPageUrl: map["first_page_url"],
		from: map["from"],
		lastPage:  map["last_page"],
		lastPageUrl:  map["last_page_url"],
		nextPageUrl:  map["next_page_url"],
		path:  map["path"],
		perPage:  map["per_page"],
		prevPageUrl:  map["prev_page_url"],
		to:  map["to"],
		total:  map["total"]);
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['current_page'] = currentPage;
		data['data'] = data != null ? 
			this.data.map((v) => v.toJson()).toList()
			: null;
		data['first_page_url'] = firstPageUrl;
		data['from'] = from;
		data['last_page'] = lastPage;
		data['last_page_url'] = lastPageUrl;
		data['next_page_url'] = nextPageUrl;
		data['path'] = path;
		data['per_page'] = perPage;
		data['prev_page_url'] = prevPageUrl;
		data['to'] = to;
		data['total'] = total;
		return data;
	}

}
