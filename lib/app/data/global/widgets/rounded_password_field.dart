import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class RoundedPasswordField extends StatelessWidget {
  final TextEditingController myControllerPassword;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  const RoundedPasswordField({
    Key? key,
    this.onChanged,
    required this.myControllerPassword,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: Validatorless.multiple([
        Validatorless.required("Senha Obrigatória"),
        Validatorless.min(3, "Senha precisa ter pelo menos 3 caracteres")
      ]),
      controller: myControllerPassword,
      autofocus: false,
      obscureText: true,
      //initialValue: "Sua senha",
      decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.white),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(13))),
    );
  }
}
