def Karatsuba(P,Q,n) :
    if n==1 :
         return [P[0]*Q[0]]
    m=n//2
    l=2*n
    P1=P[m:n]
    P2=P[0:m]
    Q1=Q[m:n]
    Q2=Q[0:m]
    S1=[P1[i]+P2[i] for i in range(0,m)]
    S2=[Q1[i]+Q2[i] for i in range(0,m)]
    R1=Karatsuba(P1,Q1,m)
    R2=Karatsuba(S1,S2,m)
    R3=Karatsuba(P2,Q2,m)
    R=[0 for i in range(0,l)]
    for i in range(0,n-1) :
        R[i]=R3[i]
    for i in range(m,m+n-1) :
        R[i]=R[i]+R2[i-m]-R1[i-m]-R3[i-m]
    for i in range(n,2*n-1) :
        R[i]=R[i]+R1[i-n]
    return R

# La fonction suivante convertit une liste en polynôme.

def ListeVersPol(P) :
    n=len(P)-1
    p=add([P[i]*x**i for i in range(0,n)])
    return p
