import 'package:flutter/material.dart';
import 'package:flutter_post/features/authentication/provider/authentication_provider.dart';
import 'package:flutter_post/features/posts/model/post.dart';
import 'package:flutter_post/features/posts/provider/post_provider.dart';
import 'package:flutter_post/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postManager = ref.watch(postManagerProvider.notifier);
    final currentUserEmail = ref.watch(
      authenticationStateProvider.select((state) => state.valueOrNull?.email),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('New post'),
        actions: [
          TextButton(
            onPressed: () {
              if (currentUserEmail == null) return;
              postManager.uploadNewPost(
                Post(
                  id: const Uuid().v1(),
                  email: currentUserEmail,
                  timestamp: DateTime.timestamp(),
                  message: _messageController.text,
                  likeEmails: [],
                ),
              );
              context.pop();
            },
            child: Text('Post'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        child: Column(
          spacing: 8,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  minLines: 4,
                  maxLines: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
