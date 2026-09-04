# FrutiApp Web

Proyecto desarrollado con Flutter Web para la Semana 4 del curso IF0009 - Desarrollo de Software IV.

## Descripción

FrutiApp Web implementa un sistema de control de acceso con validación de usuario y contraseña, persistencia del usuario mediante SharedPreferences y una bitácora de intentos de acceso.

La aplicación permite registrar los accesos autorizados y rechazados, visualizar la bitácora y trabajar con archivos JSON mediante importación y exportación.

## Funcionalidades implementadas

### Control de acceso

- Campo de correo electrónico con validación obligatoria.
- Campo de contraseña con validación.
- Opción para mostrar u ocultar la contraseña.
- Opción "Recordarme".
- Validación de credenciales.
- Mensaje para acceso autorizado o rechazado.
- Navegación al catálogo después de un acceso autorizado.

### Persistencia con SharedPreferences

- Guarda únicamente el usuario cuando se selecciona "Recordarme".
- Recupera automáticamente el usuario al volver a abrir o recargar la aplicación.
- Elimina el usuario guardado cuando "Recordarme" se desactiva.
- La contraseña nunca se almacena.

### Bitácora de accesos

Cada intento de acceso registra:

- Usuario.
- Fecha y hora.
- Resultado: `AUTORIZADO` o `RECHAZADO`.

La información se muestra mediante una lista de registros en la aplicación.

### Importación y exportación JSON

- Exportación de la bitácora a un archivo JSON.
- Descarga del archivo desde Flutter Web.
- Importación de archivos JSON.
- Validación de la estructura del archivo.
- Manejo de archivos JSON inválidos sin cerrar la aplicación.

## Estructura principal

```text
lib/
├── models/
│   └── access_record.dart
├── services/
│   ├── access_log_service.dart
│   └── preferences_service.dart
├── control_de_acceso.dart
└── home.dart
