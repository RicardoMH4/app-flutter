# Nombre provisional

Prototipo de interfaz Flutter para la app de audios.

## Preparar y ejecutar

Requiere Flutter instalado. Como este prototipo parte sin archivos de plataforma, genera Android, iOS y web desde la carpeta del proyecto y luego ejecuta:

```powershell
flutter create --platforms=android,ios,web .
flutter pub get
flutter run -d chrome
```

También se puede usar `flutter run` con un emulador o dispositivo móvil disponible.

## Alcance del prototipo

Incluye acceso de demostración, activación visual de la prueba de 7 días, inicio, búsqueda y categorías, ficha y controles visuales del reproductor, apartado extra, cuenta y pantallas de administración.

La autenticación, los pagos, el almacenamiento y la reproducción de audio (incluidos segundo plano y pantalla bloqueada) todavía no están conectados a servicios reales. Los controles de compra y administración son demostrativos.
