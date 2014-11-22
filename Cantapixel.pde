/*
 * Canta Pixel
 * Para domar la cosa.
 * Cada pixel "canta" su propia posición en binario.
 * Negro: comienzo de X.
 * Azul: cero. (Lsb primero)
 * Rojo: uno. (Lsb primero)
 * Verde: Nuevo bit para x
 * Gris: Nuevo bit para y
 * (En lugar de espaciado entre bit y bit
 * se podrían usar 4 pares de colores,
 * cero-par-x, uno-par-x, uno-impar-x, 
 * uno-impar-y, etc.
 * Sería más rápido pero costaría más
 * apuntar la referencia de cada led.
 * Además  mi daltonismo me impide concebir
 * ocho colores diferenciables).
 */

/* Coordenadas máximas x e y */
int maxx, maxy, powx, powy;
/* num fotograma */
int step;
/* num total de bits */
int lastpow;

void setup() {
  frameRate(.2);
  /* Con framerate mayor
   no da tiempo
   a dibujar todo
  */
  colorMode(RGB,255,255,255,100);
  step=0;
  maxx=width;
  maxy=height; 
  /* Obtener num de bits: */
  /* logaritmo base 2 de maxy*/
  powy=floor(1.0+(log(maxy)/log (2)));
  powx=floor(1.0+(log(maxx)/log (2)));
  lastpow=(powx+powy)*2;
  
  
}

void draw() {
  /* Stepa es el bit a enviar,
   * cada dos fotogramas
   * se envía uno
   */
  int stepa;
  if (step==0){
    /* El inicio de la transmisión
     * se marca con negro
     */
     background(0,0,0);
  } else {
    stepa=(step/2);
    /* los fotogramas impares se
     * manda un bit 
     */
    if ((step % 2)==1){
       for (int x =0; x <maxx; x++){
         for (int y=0; y <maxy; y++){
            renderdot(x, y,stepa);
         }
       }
    } else {
      /* los fotogramas pares se envía
      * una marca de espaciado.
      * Eso permite distinguir dos
      * bits iguales consecutivos y
      * también marca si se está mostrando
      * x o y
      */
      if (stepa<= powx) {
        /* Enviando x: verde*/
         background (0,255,0);
      } else {
        /* enviando y: gris*/
         background (128,128,128);
      }
    }
    
  }
  step++;
  if (step>lastpow) {
     step=0;
  }
}

void renderdot (int x, int y, int stepa){
 /*
  * stepa indica número de iteración
  * (descontando las de espaciado).
  * poww es una potencia de 2 que
  * se testa en x o y
  * dependiendo de stepa
  */
  int poww;
  boolean isone;
  if (x> maxx) return;
  if (y> maxy) return;
  /* los powx primeros bits son
   * de x; los siguientes de y:
   */
  if (stepa> powx) {
    poww=stepa-powx;
    isone=(y & ( 2 <<poww)) > 0;
  }else {
    poww=stepa;
    isone=(x & ( 2 <<poww)) > 0;
  }
  
  if (isone){
    /* Uno: Rojo */
    set (x, y, #FF0000);
  } else {
    /* Cero: Azul*/
      set (x, y, #0000FF);
  }
  
}
