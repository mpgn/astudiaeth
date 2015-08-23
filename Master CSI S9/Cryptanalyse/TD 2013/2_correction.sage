# 1) 

# Retroaction polynomial : X^l+X^(l-1)+1.
# one step
def LFSR_step(state):
  out = state[0]+state[1]*state[2]
  state = state[1:] + [state[0] + state[1]]
  return out, state

# N steps
def LFSR(state, N):
  z = []
  stateInit = state
  for i in range(N):
      out, state = LFSR_step(state)
      z.append(out)
  return z

l = 5
sk = [GF(2)(i) for i in range(l)]
print "l :", l
print "sk :",sk
z = LFSR(sk, 10)
print "10 first elements of keystream :",z 

l = 10
sk = [GF(2)(i+1) for i in range(l)]
print "l :", l
print "sk :",sk
z = LFSR(sk, 10)
print "10 first elements of keystream :",z 


l = 15
# create a random secret key
V = VectorSpace(GF(2),l)
sk = list(V.random_element())
state = copy(sk)
# go to t0
t0 = 100
for x in range(t0):
  out, state = LFSR_step(state)

state_t0 = copy(state)
n = l + 2
# n = l+2 bits of keystream after t0
Z = LFSR(state, n)

print "\nTrying to recover interne state at t0 =", t0
print "sk   :", sk
print "state_t0 :", state_t0
print "length of state :", l
print "keystream after t0", Z
print "length of keystream =", n


# 3) exhaustive search given Z

def LFSR_exaust(Z):
  n = len(Z)
  state_found = []
  for x in V: 
    state = x.list()
    cpt = 0    
    out, state = LFSR_step(state)
    while ((cpt < n-1) and (out == Z[cpt])): # abort as soon as different keystream
      out, state = LFSR_step(state)
      cpt += 1

    if ((cpt == n-1) and (out == Z[cpt])): 
      state_found.append(x.list())

  return state_found

print "\nExhaustive search :";
timing = cputime()
state_found = LFSR_exaust(Z)
print "Time taken", cputime(timing),"s" # 2^l iterations, l = 5 : 0.000883999999928 s, l = 10 : 0.026848 s, l = 15 : 0.779796 s,  l = 20 :  24.848024 s, l = 21 : 49.4849 s, l = 22 : 97.927339 s, l = 23 : 199.183026 s
# memory : quasi none
print "State found :", state_found
if len(state_found) == 1:
    if state_found[0] == state_t0:
      print "OK!"

# 4) Dictionnary Attack 

# dictionary keystream length n -> states

def LFSR_dict(n): # with dictionaries of python
  dict = {}
  for x in V:
    state = x.list()
    U = LFSR(state, n)
    if dict.has_key(tuple(U)):
        dict[tuple(U)].append(x.list()) # add in dict the value x for the key corresponding to the keystream generated keys must be hashable (can't be list)
    else:
       dict[tuple(U)]=[x.list()]

  return dict


def LFSR_dict2(n): # without dictionnaries of python : convert state to an integer
  dict = [[] for i in range(2^n)]
  for x in V:
    state = x.list()
    U = LFSR(state, n)
    dict[ZZ(U,2)].append(x.list()) # add in dict the value x in the integer index corresponding to the keystream generated   

  return dict

print 
print "Attack with dictionary"

print "Precomp :"
timing = cputime()
dict = LFSR_dict(n)   
print "Time taken", cputime(timing),"s" # , l = 5 : 0.00103899999999 s, l = 10 : 0.041433 s, l = 15 : 1.603994 s,  l = 20 :  63.800689 s, l = 21 : 133.628171 s, l = 22 : 280.65049 s
# dictionary : 2^l entries of size n = l + 2 bits : l = 5 : 224 bits,  l = 10 : = 12 Ko, l = 15 : 544 ko, l=20 : 22Mo, l=21 : 46Mo, l=22 : 96Mo, l=23 : 200Mo. In practice Sage uses a lot more of memory : approx 400Mo for l=20 and approx. 2.7Go for l=22    


timing = cputime()
dict2 = LFSR_dict2(n) 
print "Time taken", cputime(timing),"s" # , l = 5 : 0.00142899999997 s, l = 10 : 0.049507 s, l = 15 : 2.07881 s,  l = 20 :  77.304754 s, l = 21 : 164.063424 s, l = 22 : 320.067532s   . In practice takes as much memory than with python dictionnary


print "Active phase :"

state_found = dict[tuple(Z)]   #0s
print "State found :", state_found
if len(state_found) == 1:
    if state_found[0] == state_t0:
      print "OK!"


state_found = dict2[ZZ(Z,2)]   #0s
print "State found :", state_found
if len(state_found) == 1:
    if state_found[0] == state_t0:
      print "OK!"


# 5) Time Memory trade off Attack 

# dictionary of keystream of length n -> states ; with number random states 
# we use a dictionnary: with a sequence we need to allocate [[] for i in range(2^n)] : as memory as in the previous attack
def LFSR_TM_precomp(number): 
  dict = {}
  for iter in range(number):
    x = V.random_element() # random state
    state = x.list()
    U = LFSR(state, n)
    if dict.has_key(tuple(U)):
       if x.list() not in  dict[tuple(U)]:
         dict[tuple(U)].append(x.list()) # add in dict the value x for the key corresponding to the keystream generated keys must be hashable (can't be list)
    else:
       dict[tuple(U)]=[x.list()]

  return dict

# active attack : in a keystream Z search a substream of length n for which we know the corresponding internal state thanks to the dictionary dict

def LFSR_TM_active(dict, z):

  N = len(z)
  t = 0
  while (t + n) < N:
    t +=1
    if dict.has_key(tuple(z[t:t+n])):
      return t,dict[tuple(z[t:t+n])]
  return 0,0

# generate a new keystream of sqrt(2^n) + n -1 elements : ceil(sqrt(2^l)) windows of length n

N = ceil(sqrt(2^(l))) + n -1  

state = copy(state_t0)
z = LFSR(state, N)

print "Precomp :"
timing = cputime()
dict = LFSR_TM_precomp(N) # precomp with approx sqrt(2^n) keystream
print "Time taken", cputime(timing),"s" # l = 5 : 0.00106 s, l =10 : 0.005201 s, l = 15 : 0.029789 s, l = 20 : 0.158725 s, l = 25 : 1.124833 s, l = 30 : 7.688541 s, l = 35 : 52.594185 s, l = 40 : 336.46698 s
# dictionary : 2^(l/2) entries of size n = l + 2 bits : to be computed l = 15 : 3ko,  l = 20 : = 22 Ko, l = 25 : 153 ko, l=30 : 1Mo, l=35 : 6Mo, l=40 : 42Mo. In practice Sage uses a lot more of memory : approx 40Mo for l=30, approx. 187Mo for l=35, approx. 1.03 Go for l = 40, approx 4.3Go for l = 44, l = 44 : 1550.378024 s
 
print "Active phase :"
t_found, state_found = LFSR_TM_active(dict, z)
print "Time taken", cputime(timing),"s" # l = 5 : 0.001118 s, l = 10: 0.00536 s, l = 15 : 0.03013 s, l = 20 : 0.160096 s, l = 25 : 1.127504 s, l = 30 : 7.70433 s, l = 35 : 52.594185 s, l = 40 : 338.469023 s, l = 44 : 1550.804721 s

if not state_found:
  print "nothing found"
else:
  print "found", state_found, "at time", t_found
  print "Verif :"

  state = copy(state_t0)
  for x in range(t_found):
    out, state = LFSR_step(state)
    
  print "at time t0+",t_found,":",state
  if len(state_found) == 1:
    if state_found[0] == state:
      print "OK!"
      




