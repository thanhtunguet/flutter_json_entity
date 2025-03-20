import 'package:flutter/material.dart';

class SearchableAppBarTitle extends StatelessWidget {
  final bool isSearching;

  final TextEditingController searchController;

  final FocusNode searchFocus;

  final Function(String) onSubmitted;

  final String title;

  final String searchHint;

  const SearchableAppBarTitle({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.searchFocus,
    required this.onSubmitted,
    required this.title,
    required this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: isSearching
          ? TextFormField(
              key: const ValueKey('searchField'),
              focusNode: searchFocus,
              controller: searchController,
              onChanged: onSubmitted,
              decoration: InputDecoration(
                hintText: searchHint,
                border: InputBorder.none,
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            )
          : Row(
              key: const ValueKey('titleRow'),
              children: [
                Expanded(
                  child: Text(
                    title, // Replace with your desired title text
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20, // Adjust the font size as needed
                      fontWeight:
                          FontWeight.bold, // Adjust the font weight as needed
                      color: Colors.black, // Adjust the color as needed
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
