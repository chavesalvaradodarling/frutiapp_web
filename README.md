# FrutiApp Web

Proyecto desarrollado con Flutter Web para la Semana 4 del curso IF0009 - Desarrollo de Software IV.

## Persistencia de datos con JSON

En esta práctica se implementó el manejo de información estructurada mediante archivos JSON.

### Funcionalidades implementadas

- Creación del modelo `AccessRecord`.
- Conversión de objetos Dart a JSON mediante `toJson()`.
- Reconstrucción de objetos Dart desde JSON mediante `fromJson()`.
- Importación de archivos JSON desde Flutter Web.
- Exportación y descarga de archivos JSON desde Flutter Web.
- Manejo de archivos JSON vacíos o con formato inválido.
- Pruebas con archivos JSON válidos, vacíos e inválidos.

## Dependencias utilizadas

- `file_selector`
- `web`

Además, se utilizó `dart:convert` para trabajar con JSON.

## Pruebas realizadas

### JSON válido

Se importó un archivo JSON con dos registros:

- Usuario: ana — Acceso exitoso.
- Usuario: luis — Acceso fallido.

### JSON vacío

Se probó un archivo JSON vacío y la aplicación mostró un mensaje indicando que el archivo no tenía un formato válido.

### JSON inválido

Se probó un archivo con contenido que no correspondía a un JSON válido y la aplicación mostró un mensaje de error.

### Exportación

Se exportaron los registros mediante Flutter Web y se descargó el archivo:

`bitacora_accesos.json`

## Git y GitHub

El proyecto fue versionado utilizando Git y posteriormente se creó y conectó un repositorio en GitHub.

Se realizaron commits para guardar los avances del proyecto y finalmente se realizó el `push` de la rama `main` al repositorio remoto.

## Tecnologías

- Flutter
- Dart
- Flutter Web
- JSON
- Git
- GitHub
