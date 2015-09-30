//With this application you can calculate:
// - The GCD of 2 integer numbers, using the extended Euclides algorithm.
// - Modular inverse.
// - Modular power using the binary exponentiation algorithm.
// - Check if a number is or is not a prime number, using the Miller-Rabin test.
// - Modular logarithm using the baby-step giant-step algorithm.
// - The Legendre symbol.
// - Modular square root.
// - Integer number factoring using the Fermat method and the p Pollard algorithm

#include <iostream>
#include <cstdlib>
#include <vector>
#include <cmath>
#include <sstream>
#include "gmp.h"
#include "gmpxx.h"
void error();
long signed int *euclides(long signed int a, long signed int b);
mpz_class euclides_mpz(mpz_class a, mpz_class b);
mpz_class mod (mpz_class a, mpz_class b);
signed long int potencia_mod(mpz_class a, mpz_class b, mpz_class n);
bool primo_miller(mpz_class n);
unsigned long int log_mod(mpz_class a, mpz_class c, mpz_class p);
short signed int legendre(mpz_class a, mpz_class p);
mpz_class raiz_mod(mpz_class a, mpz_class p);
std::string fermat(mpz_class n);
std::string pollard(mpz_class n);
bool cuadrado_perfecto(mpz_class n);
mpz_class inverso (mpz_class a, mpz_class b);

using namespace std;

int main(int argc, char *argv[])
{
  if ((argc < 3) || (argc > 5)) error();
  if ((argc != 4) && (atoi(argv[1]) == 1)) error();
  if ((argc != 4) && (atoi(argv[1]) == 2)) error();  
  if ((argc != 5) && (atoi(argv[1]) == 3)) error();
  if ((argc != 3) && (atoi(argv[1]) == 4)) error();
  if ((argc != 5) && (atoi(argv[1]) == 5)) error();
  if ((argc != 4) && (atoi(argv[1]) == 71)) error();
  // if ((argc != 5) && (atoi(argv[1]) == 72)) error();
  if ((argc != 3) && (atoi(argv[1]) == 81)) error();
  if ((argc != 3) && (atoi(argv[1]) == 82)) error();
  mpf_set_default_prec(400);

  switch(atoi(argv[1])){
  case 1:{//LIMITE DE LONG INT
    signed long int *p_res = euclides(atol(argv[2]), atol(argv[3]));
    cout << "Apartado 1: El máximo común divisor por el algoritmo de Euclides extendido de " << argv[2] << " y de " << argv[3] << " es: " << *p_res << " = (" <<*(p_res+1) << "*" << argv[2] << ")+(" << *(p_res+2) << "*" << argv[3] <<")\n";
  }break;
     case 2:{
       mpz_class inv = inverso(mpz_class(argv[3], 10),mpz_class(argv[2], 10));
      cout << "Apartado 2: El inverso de " << argv[2] << " con módulo " << argv[3] << " es: ";//Modulos negativos en c++ dan problemas
      if (inv == 0) cout << "No tiene inverso."<<endl;
      else cout << inv <<endl;
    }break;
    case 3:{//pag. 177
      cout << "Apartado 3: " << argv[2] << "^" << argv[3] << " mod "<<argv[4]<<" = "<<potencia_mod(mpz_class(argv[2], 10),mpz_class(argv[3], 10),mpz_class(argv[4], 10))<<endl;
    }break;
    case 4:{
      string primo;
      if (primo_miller(mpz_class(argv[2], 10)) == true) primo = " ES PROBABLE que sea";
      else primo = " NO es";
      cout << "Apartado 4: El número "<<argv[2]<<primo<<" primo."<<endl;
    }break;
  case 5:{//El logaritmo tiene que ser menor que long int
      mpz_class a, c, p;
      unsigned long int log;
      a = mpz_class(argv[2], 10);//Numero
      c = mpz_class(argv[3], 10);//Base
      p = mpz_class(argv[4], 10);//Modulo
      // if (primo_miller(p == true)){
        log = log_mod(a,c,p);
	if (log == 0) cout << "No existe el logaritmo." << endl;
	else cout << "Logaritmo de "<<a<<" con base "<<c<<" y módulo "<<p<<" es: "<<log<<endl;
	//}
	//      else cout << "P no es primo, y tiene que serlo. Saliendo..." << endl;
    }
      break;
    case 6: break;
    case 71:{
      mpz_class a = mpz_class(argv[2]);
      mpz_class p = mpz_class(argv[3]);
      if (primo_miller(p) == false){
	cout << "El segundo número NO es primo, y tiene que serlo. Saliendo..."<<endl;
	exit(1);
      }else{
	short int leg = legendre(a,p);
	if ((a>=p) || (leg != 1)){
	  cout << "'A' no es residuo cuadrático de 'p' (símbolo de Legendre = "<<leg<<")"<<endl;
	  exit(1);
	}else{
	  a = raiz_mod(a,p);
	  cout << "Las raices de 'a' módulo 'p' son: "<<a<<" y "<<p-a<<endl;
	}
      }
    }break;
    case 72:{
    }break;
  case 81:
    cout << argv[2] << " = " << fermat(mpz_class(argv[2]))<<endl;
    break;
  case 82:
    cout << argv[2] << ": " << pollard(mpz_class(argv[2]))<<endl;
    break;
  default:{ cout << "OTRO";
  }break;
  }
  return 0;
}

mpz_class inverso (mpz_class a, mpz_class b){
  mpz_class y=0,v=1,r=(a%b),c,temp;
  while (r != 0){
    c = (a/b);
    temp = y;
    y = v;
    v = temp - (v*c);
    //cout << a <<" "<<b<<" "<<r<<" "<<c<<" "<<y<<" "<<v<<endl;
    a = b;
    b = r;
    r = a%b;
  }
  if (b != 1) return 0;
  else return v;
}

 string pollard(mpz_class n){
   mpz_class a,x,y,L=1000,i,eucl;
   stringstream temp;

   srand(time(NULL));
   a = (mod(mpz_class(rand()),n-1))+1;//1=<a=<n-1
   x = potencia_mod(a,2,n)+1;
   y = potencia_mod(x,2,n)+1;

   for (i=0;i<L;i++){
     eucl = euclides_mpz(y-x,n);
     cout << eucl.get_str() << " " << n.get_str()<<endl;
     if (eucl == n) return "Es probable primo.\n";
     if (eucl == 1){
       x = potencia_mod(x,2,n)+1;
       y = potencia_mod(y,2,n)+1;
       y = potencia_mod(y,2,n)+1;
       continue;
     }
     return eucl.get_str()+" es un divisor de "+n.get_str();
   }
   return "Es probable primo.\n";
 }

 mpz_class euclides_mpz(mpz_class a, mpz_class b){
   mpz_class c,r=1;
   if (a<b){c=a;a=b;b=c;}
   while(r>0){
     c=a/b;
     r=mod(a,b);
     if(r<0){
             if(c<0) c-=1;
             if(c>=0) c+=1;
             r=a-(b*c);
          }
     a=b;
     b=r;
   }
   if (a<0) a=-a;
   return a;
 }

 string fermat(mpz_class n){
   string st;
   mpz_class x = sqrt(n) + 1;
  while(!cuadrado_perfecto((x*x)-n)) x++;
  st = x.get_str(10) + "^2 - ";
  x = sqrt((x*x)-n);
  st += x.get_str(10) + "^2";
  return st;
}

bool cuadrado_perfecto(mpz_class n){
  mpf_set_default_prec(sizeof(n)*8);
  mpf_class x = sqrt(mpf_class(n));
  if (x == trunc(x)) return true;
  else return false;
}

mpz_class raiz_mod(mpz_class a, mpz_class p){
  mpz_class n=1,s,u=0,resu,b,j=0,res;
  signed long int *p_res;
  while(legendre(n,p) != -1) n++;
  s = p-1;
  while(mod(s,2) == 0){
    s>>=1;//Lo mismo que dividir por 2
    u++;
  }
  resu = potencia_mod(a,(s+1)/2,p);
  p_res = euclides(a.get_si(),p.get_si());
  res = mod(mpz_class(*(p_res+1)),p);
  b = potencia_mod(n,s,p);
  while(j<=u-2){
    if(potencia_mod(mod(res*potencia_mod(resu,2,p),p),pow(2,u.get_ui()-2-j.get_ui()),p) == p-1) resu = mod(resu*b,p);
    b=potencia_mod(b,2,p);
    j++;
    }
  return resu;
}

short signed int legendre(mpz_class a, mpz_class p){
  if (a==0) return 0;
  if (a==1) return 1;
  short signed int resultado;
  if (mod(a,2) == 0){
    resultado = legendre(a/2, p);
    if (((p*p-1) & 8) != 0) resultado = -resultado;
  }
  else{
    resultado = legendre(mod(p,a), a);
    if (((a-1)*(p-1) & 4) != 0) resultado = -resultado;
  }
  return resultado;
}

unsigned long int log_mod(mpz_class a, mpz_class b, mpz_class m){//a=numero, b=base, m=modulo
  mpz_class b_s, temp = 1, i, j, s = sqrt(m)+1;//Condicion del algoritmo
  vector<mpz_class> tabla;

  b_s = potencia_mod(b,s,m);
  tabla.push_back(mod(a,m));//Genero la tabla. 1er elemento
  for (i=1; i<s; i++) tabla.push_back(mod(tabla[i.get_ui()-1]*b,m));
  cout <<endl;
  for (i=0; i<s; i++) cout << tabla[i.get_ui()] << " ";
  cout << endl<<endl;
  for (i=0; i<s; i++){//Busco en la tabla anterior
    temp = mod(temp*b_s,m);
    cout << "Buscando " << temp << endl;
    for (j=0; j<s; j++) if ((tabla[j.get_ui()] == temp) && (j < 4294967295)){
        temp = ((i+1)*s)-j;
	return temp.get_ui();
      }
  }
  return 0;
}


bool primo_miller(mpz_class n){
  if (mod(n,2) == 0) return false;
  mpz_class s = n-1, u = 0;
  //Descompongo n en 2^u*s
  while (mod(s,2) == 0){
    s >>= 1;//Hace que el numero sea impar
    u++;
  }
  srand(time(NULL));//Inicializo semilla
  mpz_class a = mod(rand(), n-3) + 2;//numero = rand() % (xfin-xini+1) + xini;
  a = potencia_mod(a,s,n);
  if ((a == 1) || (a == n-1)) return true;
  else{
    mpz_class i;
    for (i=1; i<u; i++){
      a = potencia_mod(a,2,n);
      if (a == n-1) return true;
      else if (a == 1) return false;
    }
    return false;
  }
}

signed long int potencia_mod(mpz_class a, mpz_class b, mpz_class n){
  mpz_class i, resultado = 1;
  i = mod(a,n);
  while(b > 0){
    if (mod(b,2) == 1) resultado = mod(resultado*i,n);
    i = mod(i*i,n);
    b = b/2;
  }
  if (resultado < 2147483647) return resultado.get_si();
  else return 0;
}

long signed int *euclides(long signed int a, long signed int b){
  long signed int temp[3], *p_temp, t;
  if (b!=0){
    //cout << (-7/3) <<" "<<(7/-3)<<" "<<(-7/-3)<<endl;
    //cout << mod(-7,3)<<" "<<mod(7,-3)<<" "<<mod(-7,-3)<<endl;
    p_temp = euclides(b, mod(a,b).get_si());
    temp[0] = *p_temp;
    temp[1] = *(p_temp+2);
    t = *(p_temp+1) - ((a/b)*temp[1]);
    temp[2] = t;
  }else{
    temp[0] = a;
    temp[1] = 1;
    temp[2] = 0;
  }
  p_temp = temp;
  // cout <<a<<" "<<b<<" "<<temp[0]<<" " << temp[1]<<" " << temp[2]<<endl;
  return p_temp;
}

mpz_class mod (mpz_class a, mpz_class b){
  if(b < 0) return mod(a, -b);  
  mpz_class ret = a % b;
  if(ret < 0) ret = ret + b;
  return ret;
}

void error(){
    cout << "Error en los parametros. Sintaxis: ./p1 [apartado del ejercicio] [parametros del ejercicio]\n\n";
    exit(1);
}
