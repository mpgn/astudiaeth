# 1
print "##################  exo 1 #################"
g,u,v = xgcd(22,32)  # g=22*u+32*v
print g,u,v,2*u+32*v # 2, 3, -2, 2
Polys.<x> = PolynomialRing(QQ) # anneau eucli. car poly une var sur corps commu.
g,u,v = xgcd(2*x^2+1,x+5)  
print ""
print g,u,v,u*(2*x^2+1)+v*(x+5) # 1, 1/51, -2/51x+10/51, 1



# 2
print "\n##################  exo 2 #################"
S = [i^2 for i in [0..20] if is_prime(i)] # 4, 9, 25,...
print ""
print S


# 3
print "\n##################  exo 3 #################"

a = 25
c = 1
while a != 1:   # algorithme naif !
   a = (a*25)%1000003
   c = c+1
print c # 50001

Zn = IntegerModRing(1000003)
a = Zn(25)
print a.multiplicative_order() # 500001


# 4
print "\n##################  exo 4 #################"

for i in [1..1000]:
  S = i.divisors()
  # s = 0
  # for el in S[:-1]:
  #   s = s + el
  # Plus direct :
  s = sum(el for el in S[:-1]) # -1 : enlève le dernier élément: pour n'avoir que les diviseurs stricts

  if s == i:
    print i  # 6 28 496


# 5
print "\n##################  exo 5 #################"

def VanDer(a):
 n = len(a)
 M = MatrixSpace(QQ,n)(0)
 for i in [0..n-1]:
   M[i] = vector([el^i for el in a])
 return M

print VanDer([2,4,3,9,5])


# on peut prendre l'autre fonction en remplacant QQ par a[0].parent()
#  ou créer la liste des coefficients puis la matrice :

print ""
def VanDer2(a):
  n = len(a)
  S = []
  for i in [0..n-1]:
    S.extend([el^i for el in a])  
  return matrix(n,n,S)

M = VanDer2([2,GF(3)(2),4,3,9,5])
print M
print parent(M)

# on peut aussi agrandir la matrice avec la fonction stack

print ""
def VanDer3(a):
  n = len(a)
  M = matrix([el^0 for el in a])
  for i in [1..n-1]:
    M = M.stack(matrix([el^i for el in a]))  
  return M

M = VanDer3([2,GF(3)(2),4,3,9,5])
print M
print parent(M)


# on peut travailler dans l'anneau symbolique de Sage :

print ""
x=var('x') ; y=var('y') ; w=var('w'); z=var('z')
M = VanDer3([x, y, w ,z])
print M
d = M.determinant()
print d
print factor(d) # prod (a_j-a_i), 1<=i<j<=n

print ""
# ou avec un anneau de polynôme en 4 variables comme le déterminant de M est un polynôme en les coefficients de M :

PR = PolynomialRing(QQ,'x',4)
v = PR.gens() # les 4 variables x0,x1,x2,x3
d = VanDer2(v).determinant()
print factor(d)


print "\n\nRévisions corps finis\n\n"

print "\n##################  exo 6 #################\n"

# 6

n = 25
A = Integers(25) # ou A = IntegerModRing(25)
a = A(1)
b = a
car = 1
while b!=0:
    b=b+a
    car=car+1
print "La caractéristique de ",A, "est", car

print "\nListe des inversibles"
L = []
for a in A:
    if a.is_unit():
        L.append(a)
print L

# ou avec la fonction de sage :

print A.list_of_elements_of_multiplicative_group()

print "\n##################  exo 7 #################\n"

# 7

F8.<a> = GF(2^3) #  Corps fini F_(8)
B = [1,a,a^2]
L = []
for cpt in mrange([2,2,2]):
   L.append(sum(cpt[j]*B[j] for j in range(3)))
# ou alors
print L
print F8.list()

for x in L:
   for y in L:
     if (x+y)^2 != x^2+y^2:
            print "oups" 

for el in L:
 if el^2 == el:
   print el
# on trouve F_2 soit 0 et 1, on peut utiliser une notation plus synthétique :
print [el for el in L if el^2 == el]


print "\n##################  exo 8 #################\n"

# 8
PR.<X> = PolynomialRing(GF(2))
P = F8.modulus()
print P
print P.is_irreducible()
'''
Le polynôme $X^3+X+1$ est irréductible sur $\F_2$ (il n'a pas de racine dans $\F_2$ donc n'est pas divisible par un polynôme de degré 1 et comme il est de degré 3 il est nécessairement divisible par un polynôme de degré 1 si réductible).

'''
print P.roots(ring=F8) 
'''
On a $P(a) = a^3+a+1 = 0$. D'autre part $P(X)^2 = (X^3+X+1)^2 = (X^3)^2+X^2+1 = P(X^2)$. On a donc $P(a^2)=P(a)^2=0$, de même $P(a^4)=0$, et $a^4=a^2+a$.
'''
V = F8.vector_space()
print F8([1,0,1]) + F8([0,1,1]), V(F8([1,0,1]) + F8([0,1,1]))
print 1+a^2+a+a^2
'''
Soit $(1+X^2) + (X+X^2) \mod P(X) = 1+X
l'addition se fait termes à termes dans $F_2$ : X-OR de chaque bit, c'est à dire X-OR des chaînes de bits.
'''

'''
Pour la multiplication : 
$(1,1,1) \times (0,1,1)$ : $(1+X+X^2) \times (X+X^2) = X^4+X \pmod{X^3+X+1}$. On effectue la division euclidienne qui donne le quotient $X$ et le reste $X^2$ : le résultat est $(0,0,1)$. 
'''
print ((1+X+X^2) * (X+X^2)), ((1+X+X^2) * (X+X^2)) % (1+X+X^3)
print (1+a+a^2)*(a+a^2)
'''
L'inverse se fait par algorithme d'Euclide étendu avec $X^3+X+1$. Par exemple pour calculer l'inverse de $(0,0,1)$ alias $X^2$  :
on pose $R_0 = 1 + X + X^3, R_1 = X^2, U_0 = 1, V_0 = 0, U_1=0, V_1=1$ de telle sorte que $U_0 (1+X+X^3) + V_0 (X^2) = R_0$ et $U_1 (1+X+X^3) + V_1 (X^2) = R_1$, on a ensuite
$$ R_0  = X R_1 + 1+X,$$
soit $Q_1= X$ et $R_2 = 1+X$ et $U_2 (1+X+X^3) + V_2 (X^2) = R_2$ avec $U_2 = U_0 - Q_1 U_1 = 1$ et $V_2 = V_0 - Q_1 V_1 = X$ (caractéristique 2). Enfin
$$ R_1 = (1+X) R_2 + 1,$$
soit $Q_2= 1+X$ et $R_3 = 1$ et l'identité de Bézout 
$U_3 (1+X+X^3) + V_3 (X^2) = R_3=1$ 
avec $U_3 = U_1 - Q_2 U_2 = 1+X$ et $V_3 = V_1 - Q_2 V_2 = 1+(1+X)X = 1+X+X^2$.
L'inverse de $X^2$ modulo $X^3+X+1$ est donc $V_3 = 1 + X + X^2$ c'est à dire $(1,1,1)$.
'''
print xgcd(X^3+X+1,X^2) # R_3, U_3, V_3
print (a^2)^(-1)


print "\n##################  exo 9 #################\n"

# 9

for el in F8:
   print el,"pol :",el.minimal_polynomial()
'''
Le polynôme minimal de 0 est X et celui de 1, X+1
On a vu que les racines de $P$ sont $a$ $a^2$ et $a^4=a(a+1)=a^2+a$.
Parmi les éléments de $\F_8$ on a donc déjà $0,1, a, a^2$ et $a + a^2$

On note $b=a+1$ comme seul $\F_2$ est inclus dans $\F_{2^3}$, $b$ est nécessairement racine d'un polynôme irréductible de degré $3$ sur $\F_2$, on le cherche :
$b^2=(a+1)^2=a^2+1$ et $b^3=(a+1)^3=a^3+a+a^2+1 = a^2$.
Donc $b$ est racine de $X^3+X^2+1$. Les autres racines sont $b^2=a^2+1$ et $b^4=a^4+1=a^2+a+1$. On a passé en revue tous les éléments de $\F_8$.
'''

for el in F8:
   if el:
      print el.multiplicative_order()


#Tous les éléments différents de 0 et 1 sont ici primitifs (car l'ordre du groupe multiplicatif est 7 qui est premier : donc les ordres sont 1 ou 7).

'''
a   = a       = b^5 
a^2 = a^2     = b^3 
a^3 = a+1     = b 
a^4 = a^2+a   = b^6 
a^5 = a^2+a+1 = b^4 
a^6 = a^2+1   = b^2 
a^7 = 1       = b^7 

'''

b = a + 1
tableB = [b^i for i in range(8)]

for i in range(8):
  print "a^",i,"=",a^i,"= b^", tableB.index(a^i)


print "\n##################  exo 10 #################\n"

# 10

print "F_2^4"

F16.<alpha> = GF(2^4) #  Corps fini F_(2^4)
print alpha.multiplicative_order() # 15 : alpha est primitif
beta = alpha^3 # 
print beta.multiplicative_order() # 5 : beta n'est pas primitif. 
P = beta.minimal_polynomial()
print P
print P.degree()
print P.is_irreducible()
print P.is_primitive()
# P est de degré 4 car beta n'est pas dans un sous corps : 
# Les sous-corps de F_2^4 sont F_2 et F_2^2 car 1 et 2 divisent 4. 
# beta différent de 0,1 donc pas dans F_2
# beta d'ordre 5 donc pas dans F_2^2 car  (F_2^2)* d'ordre 3 donc si beta était dans (F_2^2)*  son ordre devrait divisait 3
# donc beta a un polynome minimal de degre 4 qui est irreductible par définition et non primitif car beta non primitif


print "F_2^8"

F256.<a> = GF(2^8) #  Corps fini F_(2^8)

# F_(2^8) contient les F_(2^d) avec d | 8 : F_2, F_4, F_16
for el in F256:
  if el^16 == el:  # définition des éléments de F_16
    print el

print [el for el in F256 if el^16 == el] # plus concis !


# ou encore: (F_16)^* sous groupe d'ordre 15 du groupe cyclique (F_256)^*, a est d'ordre 255, et a^k est d'ordre o(a)/gcd(o(a), k) : si m := (2^8-1) div (2^4-1), on a^m d'ordre 15 donc engendre (F_16)^*

S = [F256(0)]
m = (2^8-1) // (2^4-1)
S.extend([a^(m*k) for k in [0..2^4-2]]) 
print S



print ""
print "F_2^100"

F.<c> = GF(2^100) #  Corps fini F_(2^100)
# Pour F_{2^100} on utilise la deuxième méthode : recherche exhaustive trop longue !

print ""
print "F_16 dans F_2^{100}"


S = [F(0)]
m = (2^100-1) // (2^4-1)
S.extend([c^(m*k) for k in [0..2^4-2]]) 
print S
for el in S:
  if el:
    print el.multiplicative_order(),
  print el^16 == el,

print ""
