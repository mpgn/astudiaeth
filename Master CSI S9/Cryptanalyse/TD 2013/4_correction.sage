# update state of LFSR with retroaction P and output the stream bit

def LFSR_step(P, state):
  L = len(state)
  out = state[0]
  state = state[1:] + [sum(P[j+1]*state[L-1-j] for j in range(L))]
  return out, state

# update state of GEFFE with retroaction P1, P2, P3 and output the stream bit 

def GEFFE_step(P1, P2, P3, state1, state2, state3):
  x1, state1 = LFSR_step(P1, state1)
  x2, state2 = LFSR_step(P2, state2)  
  x3, state3 = LFSR_step(P3, state3)
  z = x1*x2+x3*x2+x3
  return z,state1,state2,state3

# nb stream bits with Geffe with polynomials P1, P2, P3, and init K1, K2, K3

def GEFFE(P1, P2, P3, K1, K2, K3, nb):
  s = []
  state1 = K1 
  state2 = K2
  state3 = K3
  for i in range(nb):
    z,state1,state2,state3 = GEFFE_step(P1, P2, P3, state1, state2, state3)
    s.append(z)
  return s

# Corellation attack on s with LFSR of retro P

def Correl(s, P):
  max = 0
  for init in VectorSpace(GF(2), P.degree()): # exhaustive search on LFSR
    state = Sequence(init)
    nb = 0
    for bit in s:   # comparison with stream s
      x,state = LFSR_step(P, state)
      if x == bit:
        nb = nb+1
    if nb > max:
      max = nb
      candidat = Sequence(init)
  print "Correl : ", RR(max/len(s)), candidat
  return candidat


def exhaus(s,K1,K3, P1, P2, P3): # exhaustive search of K2 given K1 and K3

  for init in VectorSpace(GF(2),11):
    state2 = Sequence(init)
    state1 = K1
    state3 = K3
   
    i = -1
    while true:
      out,state1,state2,state3 = GEFFE_step(P1,P2,P3,state1,state2,state3)
      i=i+1
      if (i == len(s)-1) or (out != s[i]):
        break

    if (i == len(s)-1) and (out == s[i]):
      return Sequence(init)

load "tp4-suiteGeffe.sage"

PR.<x> = PolynomialRing(GF(2))
P1 = x^13+x^4+x^3+x+1
P2 = x^11+x^2+1
P3 = x^9+x^4+1

print "Test vectors"
K1 = Sequence([GF(2)(1), 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1])
K2 = Sequence([GF(2)(1), 0, 1, 0, 1, 0, 1, 0, 1, 0, 1])
K3 = Sequence([GF(2)(1), 0, 1, 0, 1, 0, 1, 0, 1])

print "First 10 bits with"
print "K1 = ",K1
print "K2 = ",K2
print "K3 = ",K3
print GEFFE(P1,P2,P3,K1,K2,K3, 10)

print "Correlation on LFSR3"
timing = cputime()
K3 = Correl(s, P3) # Correl :  0.790000000000000 [1, 0, 1, 0, 1, 1, 0, 0, 0]
print "Time taken", cputime(timing) # Time taken 2.326036
print "Correlation on LFSR1"
timing = cputime()
K1 = Correl(s, P1) # Correl :  0.710000000000000 [0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1]
print "Time taken", cputime(timing) # Time taken 49.655442

print "Exhaust on LFSR2"
timing = cputime()
K2 = exhaus(s, K1, K3, P1, P2, P3) 
print "Time taken", cputime(timing) # Time taken 1.106932
print K2  # [1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1]
   
s2 = GEFFE(P1,P2,P3,K1,K2,K3, len(s))
print "ok ? ",s == s2

s2  = GEFFE(P1,P2,P3,K1,K2,K3,1000)

def BM(s):
  f = PR(1)
  L = 0
  list_L=[]
  list_f=[]
  m = -1
  g = PR(1)
  for k in range(len(s)):
    d = s[k] + sum([f[i]*s[k-i] for i in [1..L]])
    if d:
      h = f; f = f + g*x^(k-m)
      if L <= k/2:
        L = k + 1 -L
        m = k
        g = h

  return(L, f)


L, P = BM(s2)
print "linear complexity : ", L # linear complexity of 251 = 13*11+9*11+9;
# print "polynomial :",P
# Linear Complex for BM ->  with 2*251 bits : (2*251)^2 operations -> 252004
# correl attack : with 100 bits here : 2^9+2^13+2^11 -> 10752
# exhaust search : 2^9*2^13*2^11=2^33 -> 8589934592 operations 
 

