/**************************************************************************/
/*CORRECTION DU DS COURBES ELLIPTIQUES M1CSI BORDEAUX 1 ANNEE 2010-2011*/
/**************************************************************************/



/*******************************************************************************/
/****************************** EXERCICE 1  *********************************/
/*******************************************************************************/

/* QUESTION 1.1*/
/*L'ensemble E[m] contient toujours le point [0], neutre pour l'addition sur la courbe E. Il est donc non vide.*/

/****************************************************************************/

/* QUESTION 1.2*/
/*La courbe E d'equation y^2=x^3-x possede les points [0], [0,0], [1,0] et [-1,0]. Ces quatre points sont des points de 2-torsion et sont rationnels sur le corps F_5.*/

/****************************************************************************/

/* QUESTION 1.3*/
/*La encore, courbe E d'equation y^2=x^3-x contient les points [0], [0,0], [1,0] et [-1,0]. Ces quatre points sont des points de 2-torsion, donc des points de 4-torsion, et sont rationnels sur le corps F_49.*/

/****************************************************************************/

/* QUESTION 1.4*/
E=ellinit([0,0,0,1,0])
ellgroup(E,7) 
/*reponse : 8.*/
/*L'ordre d'un element divise l'ordre du groupe, ici 8. Comme 7 est premier a 8, il n'y a pas d'element d'ordre 7. Seul le neutre verifie [7]P=0. Donc Card(E[7])=1 */

/****************************************************************************/

/* QUESTION 1.5*/
/*x(x-1)(x+2)=x^3+x^2-2x*/
E=ellinit([0,1,0,-2,0]) /*Attention a l'ordre des coefficients*/
ellgroup(E,23)
/*reponse : 12*2=24.
/*Comme au-dessus, Card(E[23])=1 */

/****************************************************************************/

/* QUESTION 1.6*/
E=ellinit([0,-1,1,-10,-20])/*Attention a l'ordre des coefficients !*/
forprime(p=5,100,print([p,ellgroup(E,p)]))
 /*On renvoie la liste [p,structure de E(F_p)]. Il n'y a plus qu'a comparer p et le cardinal.*/
/*reponse : p=19 et p=29.*/

/****************************************************************************/

/* QUESTION 1.7*/
E=ellinit([0,-1,1,-10,-20])/*Attention a l'ordre des coefficients !!*/

/*On remarque que toutes les courbes E supersingulieres en p verifient Card(E[p])=1.*/


/****************************************************************************/
/****************************** EXERCICE 2  *********************************/
/****************************************************************************/

/****************************************************************************/

/* QUESTION 2.1*/
E=ellinit([0,0,0,1,5])
ellgroup(E,11)
/*reponse : 11, la courbe est donc anormale en 11.

/****************************************************************************/

/* QUESTION 2.2*/
/*Un groupe fini de cardinal p premier est necessairement cyclique. Comme E(F_p) est un groupe, s'il est de cardinal p alors il est engendre par un point P a coordonnees dans F_p. */

/****************************************************************************/

/* QUESTION 2.3*/
E=ellinit([0,0,0,1,4])
ellgroup(E,19)
/*reponse : 19.*/


/****************************************************************************/
/****************************** EXERCICE 3  *********************************/
/****************************************************************************/

/* QUESTION 3.1*/
/*Posons*/ 
g=Mod(59,2011);
/*On calcule*/ 
znlog(933,g)
/*reponse : 123 */

/*Dans le cas general, on peut faire mieux en utilisant l'ordre de g :*/

znlog(933,g,znorder(g));

/*On verifie */
g^123==Mod(933,2011)
/*Victoire.*/ 



/****************************************************************************/


/* QUESTION 3.2*/
/*Posons*/ 
t=ffgen(ffinit(13,3));
/*On calcule*/
fflog(3*t^2+10*t+4,t)
/*reponse : 234 */
/*On verifie*/
t^(234)==3*t^2+10*t+4
/*Victoire.*/

/****************************************************************************/


/* QUESTION 3.3*/
/*On definit*/ 
E =ellinit([0,0,0,Mod(3,20101),Mod(4,20101)]); /* courbe elliptique sur le corps F_20101 (oui 20101 est un nombre premier !)*/
/*On pose*/ 
P=[Mod(17,20101),Mod(1238,20101)]; Q=[Mod(3317,20101),Mod(13320,20101)];
/*On teste*/ 
ellisoncurve(E,P); ellisoncurve(E,Q);
/* (ATTENTION Q=[3317,13320] n'est pas sur la courbe ellinit([0,0,0,3,4]) !!).*/

/*On va ensuite utiliser un algorithme de calcul de logarithme discret. Voici par exemple une version basique de la technique Pas de bebes-Pas de geants. */


babygiant(E,P,Q)=
{
  my(s,nbaby,ngiant,S,z,v,u,n);

  /*On cherche n tel que Q=[n]P.*/

  /* On verifie que P et Q sont bien sur la courbe. */
  if (!ellisoncurve(E,P), print("P="P " n'est pas sur la courbe elliptique E"));
  if (!ellisoncurve(E,Q), print("Q="Q " n'est pas sur la courbe elliptique E"));

  s=floor(sqrt(ellorder(E,P))+1);

  /* On verifie que P est bien un point de torsion. */
  if(s==1, print("P n'est pas un point de torsion !"); break);

  nbaby=s;   /* nombre de pas de bebes pre-calcules dans une liste Baby */
  ngiant=s;  /* nombre maximal de pas de geants*/

  /* Calcul et stockage des pas de bebes Q-[u]P pour minf <= u <=minf+nb-1 */
  Baby = vector(nbaby);
  Baby[1] = ellsub(E,Q, ellpow(E,P,1));

  if(nbaby>1, for(z=2,nbaby, Baby[z] = ellsub(E,Baby[z-1],P)));


  /* On pose S = [nbaby]P. On calcule les Pas de geants Geants=[v]S, jusqu'a egalite avec un bebe de la liste Baby */
  /* Si [v]S=Q-[u]P, alors v*nbaby=n-u et donc n=u+v*nbaby. */

  S = ellpow(E,P,nbaby);
  Giant=S;

  for(v=1, ngiant,
    for(u=1,nbaby,
       if(Giant==Baby[u],n=u+v*nbaby);
    );
    Giant = elladd(E,Giant,S);
  );
 n=lift(Mod(n,ellorder(E,Q)));

/*On raisonne modulo l'ordre du point Q pour obtenir un n plus petit. Cela fait perdre un tout petit peu de temps puisqu'il faut calculer l'ordre de Q.*/

 return(n);
}

/*Il reste a taper :*/
babygiant(E,P,Q)
/*reponse : 120*/
/*On verifie*/
ellpow(E,P,120)==Q
/*Victoire.*/


/****************************************************************************/


/* QUESTION 3.4*/


/*On programme ici la methode de Pollard de calcul de log discret sur une courbe elliptique. On commence par programmer l'application Phi de la methode de Pollard, puis le code d'apres utilise ce script trois fois a chaque etape pour trouver une collision entre Wi et W2i.*/

PollardPhi(E, P, Q, W) =
{
  my(a, b, d, vec, res);
  a=W[1]; b=W[2]; w=W[3]; /*le vecteur W est constitue de W=[a,b,aP+bQ]*/
  vec=[a,b];
  d=divrem(a+b,3)[2];
  
  if(d==0, vec=[a,b+1]);
  if(d==1, vec=[2*a,2*b]);
  if(d==2, vec=[a+1,b]);

  res=concat(vec, elladd(E,ellpow(E,P,vec[1]),ellpow(E,Q,vec[2])));
  return(res);
}

/*Voici un petite fonction toute naive pour calculer l'ordre d'un point. Elle sert lorsqu'on travaille sur un corps fini non premier.*/

ellorderff(E, P) =
{
  my(r, PP);
  r=1;
  PP = P;

  while (PP,  /*si PP=[0], on a trouve que l'ordre de P est r et on s'arrete.*/
    PP = elladd(E, PP, P);
    r++;
  );

  return(r);
}

/*On attaque a present le vrai code.*/

Pollard(E,P,Q)=
{
  my(W,W2,temp,couple,a1,b1,a2,b2,r,t,n,Qt,Pt,d,u);

  W=[1,0,P];
  W2=PollardPhi(E,P,Q,W);
  couple=[W,W2];

 while(!W[3]==W2[3], W=PollardPhi(E,P,Q,W);temp=PollardPhi(E,P,Q,W2);W2=PollardPhi(E,P,Q,temp));

 a1=W[1]; b1=W[2]; a2=W2[1]; b2=W2[2];

 /*On a alors l'egalite a1+b1*n=a2+b2*n d'ou (a1-a2)=(b2-b1)n.   */

 r=ellorderff(E,P); /*Pour gagner du temps, remplacer ellorderff par ellorder. Sinon on peut calculer l'ordre via un babygiant.*/
 d = gcd(b2 - b1, r);

/* Si d=pgcd(b2-b1,r)=1, on peut inverser modulo r et obtenir n=(a1-a2)/(b2-b1) mod r. Sinon on applique Bezout : (b2-b1)u+rv=d, donc [(b2-b1)u]P=[d]P, donc [(a1-a2)u]P=[(b2-b1)un]P=[dn]P, donc [(a1-a2)u-dn]P=0, donc r divise (a2-a1)u-dn, donc il existe un entier t (borne par les donnees du probleme) tel que (a1-a2)u-dn=rt, donc nd=(a1-a2)u-rt. On boucle sur t pour trouver un n convenable. */

 u = bezout(b2 - b1, r)[1];
 u = lift(Mod(u * (a1 - a2), r));


 if (d == 1,
    return(u);
    ,

    Qt = ellpow(E, P, u / d);
    Pt = ellpow(E, P, r / d);

    while(Qt != Q,
      u += r;
      Qt = elladd(E, Qt, Pt);
    );

    return(u / d);
  );

}
           
E=ellinit([0,0,0,1,0]);
t=ffgen(ffinit(11,5));
P=[t^4+9,5*t^3+t^2+3*t+6];
Q=[6*t^4+t^3+8,8*t^4+4*t^3+2*t+5];
Pollard(E,P,Q)
/*reponse : 111*/
/*On verifie*/
ellpow(E,P,111)==Q 
/*Victoire !*/





/****************************************************************************/
/**********************************FIN***************************************/
/****************************************************************************/



