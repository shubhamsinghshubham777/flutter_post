import 'package:flutter_post/features/posts/model/post.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<Post>()])
// Annotations must be on some element
// ignore: unused_element
void _() {}
