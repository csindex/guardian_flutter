import 'package:intl/intl.dart';
import 'dart:math';

import '../../data/posts/data-post.dart';
import '../../data/posts/data-comment.dart';
import '../../data/posts/data-like.dart';
import '../../utils/constants/utils.dart';

class PostViewModel {
  final PostData post;

  final sampleImages = [
    'https://www.gannett-cdn.com/presto/2020/01/26/USAT/048dcaa6-9da8-422f-a57f-2af33fb7ef3e-sw01_reg_4_1202.JPG',
    'https://scontent.fceb2-1.fna.fbcdn.net/v/t1.0-9/p960x960/120340883_205780370894383_5393545806826177250_o.jpg?_nc_cat=101&ccb=2&_nc_sid=7aed08&_nc_ohc=Ng31F8-86q8AX_W5dbK&_nc_ht=scontent.fceb2-1.fna&tp=6&oh=73fbbae4e14cfb55d12f464f2f65c5e1&oe=60052F5A',
    'https://pga-tour-res.cloudinary.com/image/upload/c_fill,dpr_3.0,f_auto,g_center,h_393,q_auto,w_713/v1/pgatour/editorial/2019/09/05/dj-847-andrewreddington.jpg',
    'https://cached.imagescaler.hbpl.co.uk/resize/scaleHeight/815/cached.offlinehbpl.hbpl.co.uk/news/OMC/Michael-Jordan-20200527083136253.jpg',
    'https://www.denverpost.com/wp-content/uploads/2019/06/1156333825.jpg',
    'https://assets2.rappler.com/F5E0E4D59131401F8B067F9DFA9F16D5/img/4FCD825E8C25405B88DE180E68ECEAFC/efren-bata-reyes-sea-games-billiards-semis-december-6-2019-002.jpg'
  ];

  PostViewModel({this.post});

  String get id {
    return this.post.postId;
  }

  String get text {
    return this.post.text;
  }

  String get author {
    return this.post.authorName;
  }

  String get avatar {
    return this.post.authorAvatar.replaceAll("//", "https://");
  }

  String get profilePic {
    return (this.post.authorProfilePic != null)
        ? '$secretHollowsEndPoint/img/${this.post.authorProfilePic}'
        : null;
  }

  String get authorId {
    return this.post.authorId;
  }

  String get articleImage {
    return '$secretHollowsEndPoint/img/${this.post.articleImage}'; //sampleImages[Random().nextInt(120) % 6]
  }

  List<LikeData> get likes {
    return this.post.likes;
  }

  List<CommentData> get comments {
    return this.post.comments;
  }

  String get date {
    return 'Posted on ${DateFormat('EEEE, MMMM d, y hh:mm a').format(DateTime.parse(this.post.date).add(Duration(hours: 8)))}';
  }
}
