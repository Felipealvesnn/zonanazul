import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class RoundedInputFormField extends StatelessWidget {
  final TextEditingController myController;
  final String? hintText;

  final ValueChanged<String>? onChanged;
  const RoundedInputFormField({
    Key? key,
    required this.hintText,
    this.onChanged,
    required this.myController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validatorless.multiple([
        Validatorless.required("E-mail Obrigatório"),
        Validatorless.email("E-mail Inválido"),
      ]),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: myController,
      //initialValue: "",

      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.white),
          fillColor: Colors.white,
          filled: true,
          hintText: "E-mail",
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(13))),
    );
  }
}
