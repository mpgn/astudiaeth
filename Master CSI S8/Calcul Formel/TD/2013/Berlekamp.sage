'''Ici, f est un polynome defini sur un corps fini
k de cardinal p premier. Il est defini par
k=GF(p). L'anneau de polynomes est defini par :
pr.<x>=PolynomialRing(k).'''

def DegresDisctincts(f,p) :
    AnneauQuotient.<z>=pr.quotient(f)
    h=z
    i=0
    g=[1]
    while f.degree()>0 :
        AnneauQuotient.<z>=pr.quotient(f)
        i=i+1
        h=h^p
        g.append(gcd(h.lift()-x,f))
        f=f.quo_rem(g[i])[0]
    return g

'''Algorithme de Cantor Zassenhaus'''

'''f est un produit de polynomes irreductibles deux a
deux premiers entre eux de meme degre d'''

'''CZ1 donne un facteur non trivial de f ou 0'''

def CZ1(f,p,d) :
    AnneauQuotient.<z>=pr.quotient(f)
    deg=f.degree()
    a=pr.random_element(deg-1)
    g=gcd(a,f)
    if g<>1 :
        return g
    b=(a(z)^((p^d-1)/2)).lift()
    g=gcd(b-1,f)
    if g==1 or g==f :
        return 0
    else :
        return g
    
'''L'algorithme CZ donne la factorisation complete
d'un polynome f produit de polynomes irreductibles
deux a deux premiers entre eux de meme degre d '''

def CZ(f,p,d) :
    v=[]
    deg=f.degree()
    if deg==d :
        return [f]
    else :
        g=0
    while g==0 :
        g=CZ1(f,p,d)
    h=f.quo_rem(g)[0]
    v.extend(CZ(g,p,d))
    v.extend(CZ(h,p,d))
    return v

    
  
