import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/btn_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

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
                Logo( titulo: "Messenger",),
                _Form(),
                Labels(ruta: "register", mensaje1: "¿No tienes cuenta?", mensaje2: "Crea una ahora"),
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
            text: "Ingresar",
            onPressed: authService.autenticando ? null : () async {
              
              FocusScope.of(context).unfocus();
              final loginOk = await authService.login(emailCtlr.text.trim(), passCtlr.text.trim());
              
              if( loginOk ){

                // Cpnectar al socket server
                //TODO navegar a otra pantalla
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                // Mostrar alerta
                mostrarAlerta(context, "Login Incorrecto", "Revise sus credenciales nuevamente");
              }

            },
          ),
         ]
       )
    );
  }
}

