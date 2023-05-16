
def Papillon(v,i,j,a): 
    (v[i],v[j])=(v[i]+a*v[j],v[i]-a*v[j])


def Miroir(j,k):
    v=ZZ(j).digits(2,padto=k) #ZZ(j) : sinon, le type de j n'est pas le bon, et on ne peut pas utiliser digits.
    return sum(v[i]*2^(k-i-1) for i in range(k))

def Permutation_Miroir(v,t,k):
    V=[]
    for i in range(t):
        V.append(v[Miroir(i,k)])
    return V

''' La fonction fft suivante prend exp(2*I*pi/t) comme racine
primitive t-ème de l'unité. Ici, t désigne la taille de v. C'est
une puissance de 2.''' 

def fft(v): # v est une liste de taille une puissance de 2.
    t=ZZ(len(v))
    k=len((t-1).digits(2)) # k est la taille de t-1
    m=t//2
    pas=1
    W=[1,n(exp(2*I*pi/t))]  # Liste des racines de l'unité
    for i in range(2,m):
        W.append(n(W[i-1]*W[1]))
    v=Permutation_Miroir(v,t,k)
    for i in range(k):      # Boucle principale
        for j in range(m):  # Boucle sur les couples de sous-listes
            for l in range(pas): #Boucle dans un couple de sous-listes
                Papillon(v,l+2*j*pas,l+(2*j+1)*pas,W[m*l])
        pas=2*pas
        m=m//2
    return v
