import 'package:flutter/material.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/feed/controllers/feed_controller.dart';
import 'package:flutter_angola/features/post/widgets/post_card.dart';
import 'package:flutter_angola/features/profile/screens/profile_screen.dart';
import 'package:flutter_angola/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final searchController = TextEditingController();
  bool isSearchUser = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Screen'),
        elevation: 0,
        actions: [
          SizedBox(
            width: 200,
            height: 30,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                print('value: $value');
                if (value != '') {
                  setState(() {
                    isSearchUser = true;
                  });
                } else {
                  setState(() {
                    isSearchUser = false;
                  });
                }
              },
              autofocus: false,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                border: InputBorder.none,
                hintText: 'Search Users',
              ),
            ),
          ),
        ],
      ),
      body: isSearchUser
          ? ref.read(searchUserProvider(searchController.text)).when(
              data: (data) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final user = data[index];
                    return GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, ProfileScreen.routeName,
                          arguments: user!.uid),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(user!.profilePic),
                        ),
                        title: Text(user.email.replaceAll('@gmail.com', '')),
                      ),
                    );
                  },
                  itemCount: data.length,
                ),
              );
            }, error: (err, stackTrace) {
              return ErrorScreen(error: err.toString());
            }, loading: () {
              return const Center(
                child: Loader(),
              );
            })
          : StreamBuilder<List<Post>>(
              stream: ref.read(feedControllerProvider).getPostStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Loader(),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorScreen(error: snapshot.error.toString());
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final snap = snapshot.data![index];
                      return PostCard(
                        snap: snap,
                      );
                    });
              }),
    );
  }
}
