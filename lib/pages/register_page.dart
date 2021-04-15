import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/btn_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height *.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo( titulo: "Registro"),
                _Form(),
                Labels(ruta: "login", mensaje1: "¿Ya tienes una cuenta?", mensaje2: "Ingresa ahora"),
                Text("Terminos y condiciones de uso", style: TextStyle(fontWeight: FontWeight.w200),),
                SizedBox( height: 1 ),
              ]
            ),
          ),
        ),
      )
    );
  }
}



class _Form extends StatefulWidget {

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  
  final nameCtlr = TextEditingController();
  final emailCtlr = TextEditingController();
  final passCtlr = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: "Nombre",
            textController: nameCtlr,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: "Correo",
            keyboardType: TextInputType.emailAddress,
            textController: emailCtlr,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: "Contraseña",
            textController:passCtlr,
            isPassword: true,
          ),
          
          // TODO: Crear Boton
          
          Btn_Azul(
            text: "Crear Cuenta",
            onPressed: authService.autenticando ? null : () async{
              print(emailCtlr.text);
              print(nameCtlr.text);
              print(passCtlr.text);
              final registerOk = await authService.register(nameCtlr.text.trim(), emailCtlr.text.trim(), passCtlr.text.trim());
              
              if (registerOk == true) {
                //TODO Conectar socket server
                //}
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                
                mostrarAlerta(context, 'Registro Icorrecto', 'Registro Ok');
              }
            },
          ),
         ]
       )
    );
  }
}

