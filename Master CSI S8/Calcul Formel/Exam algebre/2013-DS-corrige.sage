def UV(P) :
    G=gcd(P,P.derivative())
    U=P.quo_rem(G)[0]
    d=P.degree()
    kP.<y>=pr.quotient_ring(P)
    Ud=(U(y)^d).lift() 
    G2=gcd(Ud,P)       
    V=P.quo_rem(G2)[0]
    return (U,V)

'''C'est une facon economique de le faire si d est grand.
On pouvait aussi definir UV comme suit. On peut aussi
utiliser // à la place de quo_rem, mais pas / : dans ce
cas, le resultat n'est plus considere comme un polynome.
C'est genant pour la suite.
'''
def UV(P) :
    G=gcd(P,P.derivative())
    U=P.quo_rem(G)[0]
    d=P.degree()
    G2=gcd(U^d,P)       
    V=P.quo_rem(G2)[0]
    return (U,V)

def Racine(V,p) :
    V=pr(V)
    d=V.degree()
    v=V.coeffs()
    W=add(v[p*i]*x^i for i in range(d//p+1))
    return W

# psfc pouvait etre definie de facon recursive ou iterative.

def psfc_rec(P,p) :
    if P==1:
        return P
    (U,V)=UV(P)
    W=Racine(V,p)
    return psfc_rec(W,p)*U


def psfc_it(P,p) :  
    V=P
    U=1
    while V<>1 :
        (U_int,V)=UV(V)
        U=U*U_int
        V=Racine(V,p)
    return U

def RacineFq(V,p,j) :
    d=V.degree()//p
    cV=V.coeffs()
    cW=[cV[p*i]^(p^(j-1)) for i in range(d+1)]
    W=add(cW[i]*x^i for i in range(d+1))
    return W

