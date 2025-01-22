import 'package:flutter/material.dart';

/*
  2025.01.21 이도영 : 드롭다운 커스텀 양식
*/
class CustomDropdownFormField<T> extends FormField<T> {
  final List<DropdownMenuItem<T>> items;
  final InputDecoration decoration;
  final Widget? hint;

  CustomDropdownFormField({
    Key? key,
    required T? initialValue,
    required this.items,
    required this.onChanged,
    this.decoration = const InputDecoration(),
    this.hint,
    FormFieldValidator<T>? validator,
    bool autovalidate = false,
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: validator,
          autovalidateMode: autovalidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<T> state) {
            return GestureDetector(
              onTap: () async {
                FocusScope.of(state.context).unfocus();
                T? selected = await showModalBottomSheet<T>(
                  context: state.context,
                  builder: (BuildContext context) {
                    return ListView(
                      children: items.map((DropdownMenuItem<T> item) {
                        return ListTile(
                          title: item.child,
                          onTap: () {
                            Navigator.pop(context, item.value);
                          },
                        );
                      }).toList(),
                    );
                  },
                );
                if (selected != null) {
                  state.didChange(selected);
                  onChanged(selected);
                }
              },
              child: InputDecorator(
                decoration: decoration.copyWith(
                  errorText: state.errorText,
                ),
                isEmpty: state.value == null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    state.value != null
                        ? Text(
                            (items
                                    .firstWhere(
                                        (item) => item.value == state.value)
                                    .child as Text)
                                .data!, // Text 위젯의 data를 가져옵니다.
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          )
                        : (hint ?? Container()),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            );
          },
        );

  final void Function(T?) onChanged;
}
