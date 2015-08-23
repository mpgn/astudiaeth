# Exo 1 

print "\n******************** Exo 1 *************************\n"

# question 1
PR.<X> = PolynomialRing(GF(2))
P = 1+X^4+X^5

def LFSR_step(state):
  out = state[0]
  state = [state[1],state[2],state[3],state[4],state[0] + state[1]]
  return out, state

def LFSR(state, N):
  z = []
  stateInit = state
  period = 0
  for i in range(N):
      out, state = LFSR_step(state)
      z.append(out)
      if period == 0:
          if state == stateInit:
              period = i + 1

  return z, period

# question 2

init = Sequence([GF(2)(0),0,1,0,1]) # crée une séquence : tous les éléments sont dans GF(2)
z1, period = LFSR(init,50) 
print "P primitif    ?", P.is_primitive() # False
print "P irreducible ?", P.is_irreducible() # False


print "la suite avec fonction 1.:",z1
# [0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1]


print "la période :", period # periode 21 
# question 3

# la meme ds le cas general, avec longueur state = deg poly

def LFSR_step2(P, state):
  L = len(state)
  out = state[0]
  state = state[1:] + [sum(P[j+1]*state[L-1-j] for j in range(L))]
  return out, state


def LFSR2(P, state, N):
  z = []
  for i in range(N):
      out, state = LFSR_step2(P, state)
      z.append(out)
  return z



z2 = LFSR2(P,init,50) 
print "la suite avec fonction 3. :",z2
print z1 == z2 # True
v=(P.list())
v.reverse()  # attention lfsr_sequence prend les c_i dans l'autre sens !
z3 = lfsr_sequence(v,init,50)
print "la suite avec lfsr_sequence",z3
print z2 == z3 # True


# Exo 2
print "\n******************** Exo 2 *************************\n"


# question 1

def cycle(P, state):
  
  Registres = []
  while True:
      Registres.append(state)
      out, state = LFSR_step2(P, state)
      if state == Registres[0]:
        return Registres


# question 2

init1 = Sequence([GF(2)(0),0,1,0,1])
init2 = Sequence([GF(2)(0),1,0,0,0])
c1 = cycle(P, init1)
c2 = cycle(P, init2)
print "cycle avec état",init1
print c1 
# [[0, 0, 1, 0, 1], [0, 1, 0, 1, 0], [1, 0, 1, 0, 1], [0, 1, 0, 1, 1], [1, 0, 1, 1, 1], [0, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 0], [1, 1, 1, 0, 0], [1, 1, 0, 0, 0], [1, 0, 0, 0, 0], [0, 0, 0, 0, 1], [0, 0, 0, 1, 0], [0, 0, 1, 0, 0], [0, 1, 0, 0, 0], [1, 0, 0, 0, 1], [0, 0, 0, 1, 1], [0, 0, 1, 1, 0], [0, 1, 1, 0, 0], [1, 1, 0, 0, 1], [1, 0, 0, 1, 0]]
print "cycle avec état",init2
print c2
# [[0, 1, 0, 0, 0], [1, 0, 0, 0, 1], [0, 0, 0, 1, 1], [0, 0, 1, 1, 0], [0, 1, 1, 0, 0], [1, 1, 0, 0, 1], [1, 0, 0, 1, 0], [0, 0, 1, 0, 1], [0, 1, 0, 1, 0], [1, 0, 1, 0, 1], [0, 1, 0, 1, 1], [1, 0, 1, 1, 1], [0, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 0], [1, 1, 1, 0, 0], [1, 1, 0, 0, 0], [1, 0, 0, 0, 0], [0, 0, 0, 0, 1], [0, 0, 0, 1, 0], [0, 0, 1, 0, 0]]

# ce sont les mêmes mais décalés car 01000 est dans le premier cycle
print init1 in c2 # True
print init2 in c1 # True
init3 = Sequence([GF(2)(1),0,1,0,0])
# par contre comme 10100 n'est pas dans ce cycle, on trouve un différent avec
print "cycle avec état",init3
c3 = cycle(P, init3)
print c3
# [[1, 0, 1, 0, 0], [0, 1, 0, 0, 1], [1, 0, 0, 1, 1], [0, 0, 1, 1, 1], [0, 1, 1, 1, 0], [1, 1, 1, 0, 1], [1, 1, 0, 1, 0]]
print init3 in c1 # False


# question 3

def cycles(P):
   listeCycles = []
   for i in VectorSpace(GF(2), P.degree()):
      u = Sequence(i)
      new = true
      for c in listeCycles:
        if u in c:
          new = false
      if new:
       listeCycles.append(cycle(P,u))

   return listeCycles

print "Les cycles de ", P
for c in cycles(P):
  print c
  print len(c) # 1 21 7 3   21 =lcm(7,3)
print P.factor() # X^2+X+1 et X^3+X+1 qui sont primitifs -> periode 2^2-1=3 et 2^3-1=7
print (X^3 + X + 1).is_primitive()
print (X^2 + X + 1).is_primitive()

print

P = 1+X^2+X^4
print "Les cycles de ",P
for c in cycles(P):
  print c
  print len(c) # 1 6  6  3  6 =2*3...
print P.factor() # (X^2+X+1)^2 

print

P = 1+X+X^2+X^3+X^4
print "Les cycles de ",P
for c in cycles(P):
  print c
  print len(c) #  1 5  5  5 
print P.factor() # irred, racine ordre 5 :
F.<a> = GF(2^4, modulus=P)
print a.minimal_polynomial() # P
print a.multiplicative_order() #5
print P.is_primitive() # false
# irred donc toujours le pol min

print

P = 1+X+X^4
print "Les cycles de ",P
for c in cycles(P):
  print c
  print len(c) #  1 15
print P.factor() # irred, racine ordre 15=2^4-1, periode max pour tous les etats init
print P.is_primitive() # True
# irred donc toujours le pol min



# question 4
# on a g(X):=\sum_{i=0}^{L-1} X^i \sum_{j=0}^i ci-j sj

def g(f,state):
    L = len(state)
    return sum([X^i * sum([P[i-j]*state[j] for j in range(i+1)]) for i in range(L)])


print "Question 4"
P = X^5 + X^4 + 1
init = Sequence([GF(2)(1), 0, 1, 0, 1])
print "avec init =", init, " et P =", P
print g(P, init)/P # dans le grand cycle : c'est bien le pol min -> (X^2+1)/(X^5+X^4+1)
init = Sequence([GF(2)(1), 0, 1, 0, 0])
print "avec init =", init, " et P =", P
print g(P, init)/P # dans le cycle 7 : X^3+X+1 comme pol min  -> (X^2+X+1)/(X^3+X+1)
init = Sequence([GF(2)(1), 0, 1, 1, 0])
print "avec init =", init, " et P =", P
print g(P, init)/P # dans le cycle 3 : X^2+X+1 comme pol min  -> (X + 1)/(X^2 + X + 1)

P = 1+X^2+X^4
init = Sequence([GF(2)(1), 0, 0, 0])
print "avec init =", init, " et P =", P
print g(P, init)/P  #  dans le cycle 6 : (X^2+X+1)^2 est le pol min -> (X^2 + 1)/(X^4 + X^2 + 1)
init = Sequence([GF(2)(0), 1, 1, 0])
print "avec init =", init, " et P =", P
print g(P, init)/P  # dans le cycle 3 : (X^2+X+1) est le pol min -> X/(X^2 + X + 1)
L.<t> =  LaurentSeriesRing(GF(2))
print t/(t^2 + t + 1) 
# t + t^2 + t^4 + t^5 + t^7 + t^8 + t^10 + t^11 + t^13 + t^14 + t^16 + t^17 + t^19 + t^20 + O(t^21)
print [0] + (t/(t^2 + t + 1)).list()
# [0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1]
print LFSR2(X^4 + X^2 + 1, init,21)
# [0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1]




# Exo 3
print "\n******************** Exo 3 *************************\n"
# question 1

def BM(z):
  f = PR(1)
  L = 0
  list_L=[]
  list_f=[]
  m = -1
  g = PR(1)
  for k in range(len(z)):
    d = z[k] + sum([f[i]*z[k-i] for i in [1..f.degree()]])
    if d:
      h = f; f = f + g*X^(k-m)
      if L <= k/2:
        L = k + 1 -L
        m = k
        g = h
    # print latex(k) +"&"+latex(z[k]) + "&"+latex(d) + "&"+latex(L)+ "&"+latex(f) + "&"+latex(m) + "&"+latex(g) +"\\"
    list_L.append(L)
    list_f.append(f)
  return(list_L,list_f)

# version euclide
def BM_euclide(z):
  f = PR(z)
  ll = len(z)
  l = ll//2
  g = X^ll
  u0 = 1
  u1 = 0
  v0 = 0
  v1 = 1
  r0 = g
  r1 = f
  while r1.degree() >= l:
    q0,rr = r0.quo_rem(r1)
    r1,r0 = rr,r1
    u1,u0 = u0 - q0*u1,u1
    v1,v0 = v0 - q0*v1,v1
    print u1,v1,r1
  return v1


# question 2

P = 1+X+X^4
init = Sequence([GF(2)(0), 1, 1, 1])
print "avec init =", init, " et P =", P
z = LFSR2(P, init ,10)
print BM(z) # avec le polynome primitif on retrouve 1+X+X^4 quand assez de bits (2*complex lineaire)
print BM_euclide(z)
P = 1+X^4+X^5
init = Sequence([GF(2)(1), 0, 1, 1, 0])
print "avec init =", init, " et P =", P
z = LFSR2(P, init ,10)
print BM(z) # avec le premier et un etat d'un cycle de longueur 3 on trouve le X^2+X+1
print BM_euclide(z)
init = Sequence([GF(2)(1), 0, 1, 0, 0])
print "avec init =", init, " et P =", P
z = LFSR2(P, init ,10)
print BM(z) # idem avec cycle 7 -> X^3+X+1
print BM_euclide(z)
init = Sequence([GF(2)(1), 0, 0, 0, 0])
print "avec init =", init, " et P =", P
z = LFSR2(P, init ,10)
print BM(z) # avec le cycle 21 -> 1+X^4+X^5
print BM_euclide(z)
# similaire avec le (X^2+X+1)^2
# et avec le 1+X+X^2+X^3+X^4 on le retrouve toujours 

print lfsr_connection_polynomial(LFSR2(P, init ,10))
print berlekamp_massey(LFSR2(P, init ,10)).reverse() #  a l'envers !

#question 3

N = ZZ.random_element(2^49,2^50)
Z = [GF(2)(b) for b in N.digits(2)]
print Z
L = BM(Z)[0]
print L
#show(line([(k,L[k]) for k in range(len(L))]) + line([(k,k/2) for k in range(len(L))]))
# suite aléatoire on a L_k \approx k/2



# Exo 5
print "\n******************** Exo 5 *************************\n"

'''
La complexité linéaire de la suite est au plus 5 comme elle a été produite par un LFSR de longueur 5.
Au milieu on a 10 bits consécutif donc BM retrouve le polynôme de rétroaction minimal.
Ensuite on déroule et on retrouve tout grâce à la periode.
'''

P = BM(Sequence([GF(2)(0),0,1,1,0,1,0,1,0,0]))[1][-1]
print P #  X^5 + X^4 + X^2 + X + 1 
print P.is_primitive() # primitif donc période est 31
Z = LFSR2(P, Sequence([GF(2)(0),0,1,1,0]), 31)
print Z
#[0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0]
print "suite reconstituée :", Z[-3:] + Z[:18]
# [1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1]
#        *                                *        *        *


