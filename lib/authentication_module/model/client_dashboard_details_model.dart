class ClientDashboardDetailsModel {
  ClientDashboardDetailsModel({
      this.status, 
      this.message, 
      this.bannerList, 
      this.plan, 
      this.stats, 
      this.featuredTalents, 
      this.trendingJobs,});

  ClientDashboardDetailsModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['banner_list'] != null) {
      bannerList = [];
      json['banner_list'].forEach((v) {
        bannerList?.add(BannerList.fromJson(v));
      });
    }
    plan = json['plan'] != null ? Plan.fromJson(json['plan']) : null;
    stats = json['stats'] != null ? Stats.fromJson(json['stats']) : null;
    if (json['featured_talents'] != null) {
      featuredTalents = [];
      json['featured_talents'].forEach((v) {
        featuredTalents?.add(FeaturedTalents.fromJson(v));
      });
    }
    if (json['trending_jobs'] != null) {
      trendingJobs = [];
      json['trending_jobs'].forEach((v) {
        trendingJobs?.add(TrendingJobs.fromJson(v));
      });
    }
  }
  num? status;
  String? message;
  List<BannerList>? bannerList;
  Plan? plan;
  Stats? stats;
  List<FeaturedTalents>? featuredTalents;
  List<TrendingJobs>? trendingJobs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (bannerList != null) {
      map['banner_list'] = bannerList?.map((v) => v.toJson()).toList();
    }
    if (plan != null) {
      map['plan'] = plan?.toJson();
    }
    if (stats != null) {
      map['stats'] = stats?.toJson();
    }
    if (featuredTalents != null) {
      map['featured_talents'] = featuredTalents?.map((v) => v.toJson()).toList();
    }
    if (trendingJobs != null) {
      map['trending_jobs'] = trendingJobs?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class TrendingJobs {
  TrendingJobs({
      this.id, 
      this.title, 
      this.company, 
      this.tag, 
      this.location, 
      this.postedOn,});

  TrendingJobs.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    company = json['company'];
    tag = json['tag'];
    location = json['location'];
    postedOn = json['posted_on'];
  }
  num? id;
  String? title;
  String? company;
  String? tag;
  String? location;
  String? postedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['company'] = company;
    map['tag'] = tag;
    map['location'] = location;
    map['posted_on'] = postedOn;
    return map;
  }

}

class FeaturedTalents {
  FeaturedTalents({
      this.id, 
      this.name, 
      this.profession, 
      this.avatar, 
      this.location,});

  FeaturedTalents.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    profession = json['profession'];
    avatar = json['avatar'];
    location = json['location'];
  }
  num? id;
  String? name;
  String? profession;
  String? avatar;
  String? location;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['profession'] = profession;
    map['avatar'] = avatar;
    map['location'] = location;
    return map;
  }

}

class Stats {
  Stats({
      this.profileViews, 
      this.connections, 
      this.projects,});

  Stats.fromJson(dynamic json) {
    profileViews = json['profile_views'];
    connections = json['connections'];
    projects = json['projects'];
  }
  num? profileViews;
  num? connections;
  num? projects;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profile_views'] = profileViews;
    map['connections'] = connections;
    map['projects'] = projects;
    return map;
  }

}

class Plan {
  Plan({
      this.id, 
      this.name, 
      this.price, 
      this.durationDays, 
      this.features, 
      this.expiryDate, 
      this.isActive,});

  Plan.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    durationDays = json['duration_days'];
    features = json['features'];
    expiryDate = json['expiry_date'];
    isActive = json['is_active'];
  }
  num? id;
  String? name;
  String? price;
  dynamic durationDays;
  String? features;
  String? expiryDate;
  bool? isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['price'] = price;
    map['duration_days'] = durationDays;
    map['features'] = features;
    map['expiry_date'] = expiryDate;
    map['is_active'] = isActive;
    return map;
  }

}

class BannerList {
  BannerList({
      this.id, 
      this.title, 
      this.image, 
      this.link,});

  BannerList.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    link = json['link'];
  }
  num? id;
  String? title;
  String? image;
  String? link;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['image'] = image;
    map['link'] = link;
    return map;
  }

}