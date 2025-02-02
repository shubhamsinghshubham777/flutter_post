import 'package:flutter/material.dart';
import 'package:flutter_post/features/posts/model/post.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  const PostCard(
    this.post, {
    super.key,
    required this.onLikeButtonTap,
  });

  final Post post;
  final VoidCallback onLikeButtonTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: [
                Text(
                  '${post.email.substring(0, post.email.indexOf('@'))} says',
                  style: textTheme.labelLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Flexible(
                  child: Text(
                    DateFormat(
                      'EEEE, dd/MM/yyyy @ hh:mm a',
                    ).format(post.timestamp),
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              post.message,
              style: textTheme.titleLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: onLikeButtonTap,
                  icon: Icon(Icons.thumb_up_alt_outlined),
                ),
                Text(post.likeEmails.length.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
