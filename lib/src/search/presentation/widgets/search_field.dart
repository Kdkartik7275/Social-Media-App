import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_x/core/utils/borders/borders.dart';
import 'package:social_x/src/search/presentation/bloc/search_bloc.dart';

class SeachTextField extends StatefulWidget {
  final Function(String)? onChanged;
  const SeachTextField({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SeachTextField> createState() => _SeachTextFieldState();
}

class _SeachTextFieldState extends State<SeachTextField> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      textAlignVertical: TextAlignVertical.center,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      textCapitalization: TextCapitalization.sentences,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            searchController.clear();
            context.read<SearchBloc>().add(ClearUsers());
          },
          child: Icon(
            Ionicons.close_outline,
            size: 12.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        hintText: 'Search...',
        hintStyle: const TextStyle(
          fontSize: 13.0,
        ),
        filled: true,
        fillColor: Colors.white,
        border: border(context),
        enabledBorder: border(context),
        focusedBorder: focusBorder(context),
      ),
    );
  }
}
