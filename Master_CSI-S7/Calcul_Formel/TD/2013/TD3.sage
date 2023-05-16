# Calcul de 2^(2^n))

def Fer(n):
    if n==0:
        return 2
    else:
        return Fer(n-1)*Fer(n-1)
    
def Fer2(n):
    if n==0:
        return 2
    else:
        return Fer(n-1)^2

# Calcul des nombres de Fibonacci

def Fib(n):
    if n<=1:
        return n
    else:
        return Fib(n-1)+Fib(n-2)

def Fib_it(n):
    if n<=1:
        return n
    a=0
    b=1
    for i in range(2,n+1):
        (a,b)=(b,a+b)
    return b

# Création d'une liste

def FaitListe(n,B):
    T=[]
    for i in range(0,n+1):
        T.append(ZZ.random_element(-B,B+1))
    return T


# Evaluation d'un polynôme en un point : méthone naïve, méthode de Horner.

def Calc(n,T,x) : 
    u = [1] 
    s = 0 
    for i in range(1,n+1) : 
    	u.append(x*u[i-1]) 
    for i in range(0,n+1) : 
    	s = s+u[i]*T[i] 
    return s 

def Horn(n,T,x) : 
    s=T[n] 
    for i in range(n-1,-1,-1) : 
    	s=T[i]+x*s 
    return s

# Exponentiation

def puiss(x,n) :
    if n==0 :
       return 1
    if n % 2 == 0 :
       return puiss(x^2,n//2)
    else :
       if n == 1 :
       	  return x
       else :
	  return x*puiss(x^2,n//2)

def puissit(x,n) :
    y=1
    m=n
    z=x
    while m<>0 :
    	  if m % 2 == 1 :
	     y=z*y
	  m=m//2
	  if m <> 0 :
	     z=z^2
    return y 

def puissit2(x,N) :
    y=1
    z=x
    r=len(N)
    for i in range(0,r) :
    	  if N[i] == 1 :
	     y=z*y
	  if i <> r :
	     z=z^2
    return y 

def puissit3(x,n) :
    y=1
    while n<>0 :
    	  if n % 2 == 1 :
	     y=x*y
	  n=n//2
	  if n <> 0 :
	     x=x^2
    return y 

# Exponentiation naïve

def puissnaive(x,n) :
    if n==0:
        return 1
    y=x
    for i in range(2,n+1):
        y=y*x
    return y


'''Liste dont les éléments sont les entiers de 1 à n,
placés dans un ordre aléatoire'''

def Desordre(n) :
    E=range(1,n+1)
    l=[]
    for i in range(n):
        alea=ZZ.random_element(0,n-i)
        l.append(E[alea])
        E.remove(E[alea]);
    return l


# Tri fusion

def Division(l,n) :
    m=n//2
    l1=[l[i] for i in range(0,m)]
    l2=[l[i] for i in range(m,n)]
    return ([l1,l2,m,n-m])

def Fusion(l1,l2,n1,n2) :
    i=0
    j=0
    l=[]
    while i<n1 and j<n2 :
        if l1[i]<l2[j] :
            l.append(l1[i])
            i=i+1
        else :
            l.append(l2[j])
            j=j+1
    if i==n1 :
        l.extend([l2[k] for k in range(j,n2)])
    if j==n2 :
        l.extend([l1[k] for k in range(i,n1)])
    return l

def TriFusion(l) :
    n=len(l)
    if n==1 :
        return l
    else :
        v=Division(l,n)
        v[0]=TriFusion(v[0])
        v[1]=TriFusion(v[1])
        return Fusion(v[0],v[1],v[2],v[3])
     
    
def TriSelection(l) :
    ll=l
    n=len(ll)
    for i in range(n) :
        petit=ll[i]
        indice=i
        for j in range(i,n) :
            if ll[j]<petit :
                petit=ll[j]
                indice=j
        (ll[i],ll[indice])=(ll[indice],ll[i])
    return ll

