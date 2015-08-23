/**************************************************************************/
/*  Courbes elliptiques, Master 1 CSI.                *********************/
/*  Corrigé du DS du 25 avril 2013                    *********************/
/**************************************************************************/



/*******************************************************************************/
/******************************  EXERCICE 1  ***********************************/
/*******************************************************************************/


/** QUESTION 1.1 **/

E=ellinit([1,1,1,-3,1]*Mod(1,521));
ellgroup(E)

/* réponse : [105, 5], ce qui signifie que E(F_512) est isomorphe à Z/105Z x Z/5Z. */


/** QUESTION 1.2 **/

/* Oui : comme Z/105Z contient un sous-groupe isomorphe à Z/5Z, on en déduit que
Z/105Z x Z/5Z contient un sous-groupe isomorphe à Z/5Z x Z/5Z. */


/** QUESTION 1.3 **/

P=[1,0];
Q=[21, 185];

ellorder(E,P)
ellorder(E,Q)

/* Donc P est d'ordre 5 et Q est d'ordre 105. */


/** QUESTION 1.4 **/

ellweilpairing(E,P,Q,105)

/* réponse : Mod(25, 521), qui est une racine primitive 5-ième de l'unité dans F_521.
Si P appartenait au sous-groupe engendré par Q, alors le couplage de Weil de P et Q
serait égal à 1, ce qui n'est pas le cas. */


/** QUESTION 1.5 **/

/* Oui : Q engendre un groupe cyclique d'ordre 105, et P engendre un groupe cyclique
d'ordre 5 qui n'est pas contenu dans le groupe engendré par Q. Donc le groupe engendré
par P et Q est isomorphe à Z/105Z x Z/5Z, donc est égal à E(F_512). */


/** QUESTION 1.6 **/

/* Le corps F_{521^k} contient les racines 3-ièmes de l'unité si et seulement si
l'ordre de F_{521^k}^* est divisible par 3, c'est-à-dire si et seulement si
521^k-1 est divisible par 3. La plus petite solution est k=2. */


/** QUESTION 1.7 **/

Z=elldivpol(E,3)
t=ffgen(ffinit(521,2),t)
factorff(Z+0*t)

/* Les racines de Z dans F_{521^2} sont -1, -334, -(145*t + 80) et -(376*t + 456).
Le polynôme Z a donc toutes ses racines dans F_{521^2}, donc tous les points de
3-torsion de E sont définis sur F_{521^2}. */


/** QUESTION 1.8 **/

ellordinate(E,-(145*t + 80))

/* réponse : [248*t + 468, 418*t + 132]. Donc le point S=[-(145*t + 80),248*t + 468]
est d'ordre 3. On calcule alors : */

ellweilpairing(E,R,S,3)

/* réponse : 520*t + 520, donc R et S n'appartiennent pas au même sous-groupe.
Donc <R,S> est isomorphe à Z/3Z x Z/3Z, ce qu'on voulait. */



/*******************************************************************************/
/******************************  EXERCICE 2  ***********************************/
/*******************************************************************************/


/** QUESTION 2.1 **/

p=90000049;
H=ellinit([0,0,1,1,0]*Mod(1,p));
ellgroup(H)

/* réponse : [89996054], donc le groupe est cyclique d'ordre 89996054. */

P=[36502070, 72583757];
ellorder(H,P)

/* réponse : 89996054, donc P engendre le groupe H(F_90000049). */


/** QUESTION 2.2 **/

Q=[74197837, 65666440];
hasse=floor(p+1+2*sqrt(p));

babygiant(H,P,Q,hasse)

/* Méthode baby-step giant-step : programme non fourni. */
/* réponse : n=12312312 */


/** QUESTION 2.3 **/

pollard(H,P,Q)

/* La méthode rho de Pollard est plus rapide dans cet exemple. */


/** QUESTION 2.4 **/

ellorder(H,Q)

/* réponse : 44998027. Sachant que l'ordre de H(F_90000049) est 89996054,
on en déduit que Q n'engendre pas ce groupe. */

