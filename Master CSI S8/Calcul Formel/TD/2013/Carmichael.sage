def Korselt(n):
    f=factor(n)
    t=len(f)
    if t<3:         # Le nombre de facteurs premier d'un nombre
        return 0    # de Carmichael est >2 (feuille 9 exercice 3)
    for i in range(t):
        if f[i][1]>1 or (n-1)%(f[i][0]-1)<>0 :
            return 0
    return 1

def Liste_Carmichael(Nombre):
    l=[]
    t=0
    n=3
    while t<Nombre:
       if Korselt(n)==1:
           l.append(n)
           t=t+1
       n=n+2
    return(l)

''' Chacun des deux tests suivants donne 1 s'il découvre que Nombre
est compose, et 0 sinon.
'''

def Test_Fermat(Nombre,Temoin):
    A=IntegerModRing(Nombre)
    a=A(Temoin)^(Nombre-1)
    if a==A(1):
        return 0
    else :
        return 1

def Deux_Valuation(Nombre):
    t=0
    while 2.divides(Nombre):
        t=t+1
        Nombre=Nombre/2
    return (t,Nombre)

def Test_RabinMiller(Nombre,Temoin):
    (t,m)=DeuxValuation(Nombre-1)
    A=IntegerModRing(Nombre)
    a=A(Temoin)
    b=a^m
    if b==A(1):
        return 0
    i=0
    while b<>A(-1) and i<t:
        i=i+1
        b=b^2
        if b==A(-1):
            return 0
    if i==t:
        return 1
    
    
