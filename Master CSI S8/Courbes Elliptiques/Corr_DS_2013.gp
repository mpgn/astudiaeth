/**************************************************************************/
/*  Courbes elliptiques, Master 1 CSI.                *********************/
/*  Corrigé du DS du 19 mars 2013                     *********************/
/**************************************************************************/



/*******************************************************************************/
/******************************  EXERCICE 1  ***********************************/
/*******************************************************************************/


/** QUESTION 1.1 **/

E=ellinit([0,1,1,-3,1]*Mod(1,61))
ellgroup(E)

/* réponse : [18, 3], ce qui signifie que E(F_61) est isomorphe à Z/18Z x Z/3Z */


/** QUESTION 1.2 **/

/* Oui : comme Z/18Z contient un sous-groupe isomorphe à Z/3Z, on en déduit que
Z/18Z x Z/3Z contient un sous-groupe isomorphe à Z/3Z x Z/3Z */


/** QUESTION 1.3 **/

/* Non : d'après le théorème de structure des groupes abéliens finis, Z/3Z x Z/3Z x Z/3Z
n'est ni cyclique, ni produit de deux groupes cycliques. Donc ce n'est pas un sous-groupe
de Z/18Z x Z/3Z. */


/** QUESTION 1.4 **/

/* Non, car il n'y a pas d'élément d'ordre 27 dans Z/18Z x Z/3Z. */


/** QUESTION 1.5 **/

/* Non : E(F_61) est un sous-groupe de E(F_(61^n)), donc si E(F_(61^n)) était cyclique,
alors E(F_61) serait lui aussi cyclique. */


/****************************************************************************/
/******************************  EXERCICE 2  ********************************/
/****************************************************************************/

H=ellinit([0,1,0,-3,-2]*Mod(1,2423))
t=ffgen(ffinit(2413,2),t)
P=[1205*t + 168, 1033*t + 1637]
Q=[1073*t + 770, 519*t + 2276]


/** QUESTION 2.1 **/

/* D'après Hasse, l'ordre du groupe H(F_(2423^2)) est majoré par
2423^2+1+2*2423=5875776. */


/** QUESTION 2.2 **/

babygiant(H,P,Q,5875776)

/* Méthode baby-step giant-step : programme non fourni. */
/* On trouve n=1112111 */


/** QUESTION 2.3 **/

M=babygiant(H,P,[0],5875776)

/* ce qui nous donne un multiple M de l'ordre de P.
Pour en déduire l'ordre de P, on effectue la commande */

ellorder(H,P,M)

/* réponse: l'ordre de P est 2937790 */


/** QUESTION 2.4 **/

/* l'ordre de P est 2937790, et gcd(1112111,2937790)=1, donc P et Q engendrent
le même sous-groupe */


/****************************************************************************/
/******************************  EXERCICE 3  ********************************/
/****************************************************************************/


/** QUESTION 3.1 **/

A=(X^3+X^2+X+2)*Mod(1,5003)
polisirreducible(A)

/* réponse: 1, donc A(X) est irréductible. Donc l'anneau quotient F_5003[X]/A(X)
est un corps. Plus précisément c'est une extension de degré 3 de F_5003.
On sait qu'un tel corps est isomorphe à F_(5003^3). */


/** QUESTION 3.2 **/

x=ffgen(A,x)
fforder(x)

/* réponse : 62612567513.
Sachant que le groupe multiplicatif de F_(5003^3) est d'ordre 5003^3-1=125225135026,
et que x est d'ordre 62612567513, on en déduit que x n'est pas un générateur. */


/** QUESTION 3.3 **/

fflog(x,x^3+1,5003^3-1)

/* réponse : m=31318801262. */

/****************************************************************************/
/**********************************FIN***************************************/
/****************************************************************************/



