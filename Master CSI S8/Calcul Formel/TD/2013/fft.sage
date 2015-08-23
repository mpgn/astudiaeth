def fftrec(L,W,p,n) :           # L : polynome sous forme de liste
    if n==1 :                   # W : liste des w^k
       return L
    m=n//2
    L0=[L[2*i] for i in range(0,m)]
    L1=[L[2*i+1] for i in range(0,m)]
    V0=fftrec(L0,W,2*p,m)
    V1=fftrec(L1,W,2*p,m)
    U=[0 for i in range(0,n)]
    for i in range(0,m) :
    	U[i]=V0[i]+W[p*i]*V1[i]
	U[i+m]=V0[i]-W[p*i]*V1[i]
    return U

def fft(L,w,n) :
    m=n//2
    W=[1,w]
    for i in range(2,m) :
    	W.append(w*W[i-1])
    return fftrec(L,W,1,n)

def ListeVersPol(P) :
    n=len(P)-1
    p=add([round(real(P[i]))*x**i for i in range(0,n)])
    return p

'''La fonction suivante multiplie P et Q, ou P et Q sont a coefficients dans Z
(a cause du round - real qui arrondit le resultat).
n est une puissance de 2 telle que n>deg(PQ).
P et Q peuvent etre rentres sous forme de liste de longueur n, ou
bien sous la forme p0+p1*x+ ...+pd*x^d (a condition d'avoir initialise
un anneau de polynomes avant, avec PR.<x>=PolynomialRing(ZZ)).
Le resultat est donne sous forme de polynome.'''

def Multiplication(P,Q,n) :
    w=exp(2*I*pi/n).N()
    TP=fft(P,w,n)
    TQ=fft(Q,w,n)
    TR=[TP[i]*TQ[i] for i in range(0,n)]
    R=fft(TR,w^(-1),n)
    return ListeVersPol(R)/n

