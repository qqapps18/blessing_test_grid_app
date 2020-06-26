/// Modelo del rezo en el cual definimos la estructura del objeto que necesitamos
/// para customizar el CardView en la pantalla principal.
class FestivitiesBlessing {
  String name;
  String fileName;
  String imagePath;
// agrego nombre de para el AppBAr de lectura del PDF
  String appBarName;

  FestivitiesBlessing(
      this.name, this.fileName, this.imagePath, this.appBarName);
}
