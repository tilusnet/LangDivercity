
class Language {
  String langId;
  LatLong langLocation;
  int colhue;
  
  Language(String langId) {
    this.langId = langId;
  }
  
  Language(String langId, LatLong ll, int colhue) {
    this.langId = langId;
    this.langLocation = ll;
    this.colhue = colhue;
  }

  public LatLong getLangLocation() {
    return this.langLocation;
  }
  
  public int getColourHue() {
    return this.colhue;
  }
}
