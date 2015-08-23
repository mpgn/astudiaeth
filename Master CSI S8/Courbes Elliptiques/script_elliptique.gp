

powinit(E,P,n)=
{
my(S=[P],u=P,i);


for(i=1,n, u=elladd(E,u,u); S=concat(S,[u]););
return(S);
}



flexpow(E,P,n)=
{


my(v=0,l,k,u,m,R,Q,a,L);
if(n==1,return(P);,
if(n==0, return([0]);,
v=valuation(n,2);
l=divrem(n,2^v);
k=0;u=2;
while(u<l[1], u=2*u; k=k+1;);
m=divrem(l[1],2^k);
R=flexpow(E,P,m[2]);
Q=P;
L=powinit(E,Q,k);
a=length(L);
Q=L[a];
Q=elladd(E,Q,R);
L=powinit(E,Q,v);
a=length(L);
return(L[a]);););
}


generer(t,p,m)=
{

my(P,u);
P=0;u=1;
for(i=0,m-1,  P=P+random(p)*u; u=u*t;);
return(P);
}

ellrand(p,m)=
{
my(T,x,S,a,b,k);

T=ffinit(p,m,X);
x=ffgen(T);

a=0;b=0;k=0;
while(Mod(4*a^3+27*b^2,p)==0 && k<10,
S=[0,0,0];
for(i=1,2, S=concat(S,[generer(x,p,m)])); k=k+1;a=S[4]; b=S[5];);
E=ellinit(S);
return(concat([x],[E]));
}


ellpointrand(p,m)=
{
my(L,t,j,x,s,u,v,M);

L=ellrand(p,m);
t=L[1];
x=t;
s=t^3+L[2][4]*t+L[2][5];
j=issquare(s,&n);
while(j==0,
u=random(m);
v=random(p);
x=v+v*t^u;

s=x^3+L[2][4]*x+L[2][5];
j=issquare(s,&n);
);
M=[0,0,0,L[2][4],L[2][5]];
return(concat([x,n],[M]));
}

test(E,P,Q,i,j,e)=
{
my(d,m,n,u,k,R,S);
d=gcd(j,e);
m=e/d;
n=Mod(i*(j^(-1)),m);
n=lift(n);
u=0;
k=n-m; \\on commence à n-m car la première étape de la boucle while rajoute un m alors qu'elle ne doit pas
R=flexpow(E,P,m);
S=flexpow(E,P,n);
while(u<d && S!=Q,
S=elladd(E,S,R);
u=u+1;
k=k+m;
);
return(k);
}


pollard(E,P,Q)=
{
my(a,b,U,V,i,j,k,l,m,c,e);
e=ellorder(E,P);
U=[0];
V=P;
i=1; j=0;
a=1; b=0;
while(U!=V,
j=i+1; i=2*i;
U=V;
l=a; m=b;
\\On est obligé de rajouter cette étape sinon on ne rentre pas dans la boucle qui suit
c=Mod(a+b,3);
if(c==0, V=elladd(E,V,Q); b=b+1;);
if(c==1, V=elladd(E,V,V); a=2*a; b=2*b;);
if(c==2, V=elladd(E,V,P); a=a+1;);
j=j+1;


while(U!=V && j<=i,

c=Mod(a+b,3);
if(c==0, V=elladd(E,V,Q); b=b+1;);
if(c==1, V=elladd(E,V,V); a=2*a; b=2*b;);
if(c==2, V=elladd(E,V,P); a=a+1;);
j=j+1;
);

);

i=Mod(a-l,e);
j=Mod(m-b,e);
if(gcd(j,e)==1, j=Mod(j^(-1),e); return(lift(Mod(i*j,e)));, test(E,P,Q,lift(i),lift(j),e);)

}



trirapide(L)=
{
my(l,S,m,n,M,N,i,j,u);
l=length(L);
if(l==1,return(L););

m=floor(l/2);
n=l-m;
i=1;M=[];N=[];
\\On remplit les deux sous-listes
while(i<=m,
	M=concat(M,[L[i]]); i=i+1;
);
while(i<=l, 
	N=concat(N,[L[i]]); i=i+1;
);

M=trirapide(M);
N=trirapide(N);
i=1;j=1;S=[];

while(i<=m && j<=n,

		if(M[i]<=N[j],
			S=concat(S,[M[i]]); i=i+1;
			,
			S=concat(S,[N[j]]); j=j+1;
		);
);

\\On finit de remplir la liste 
if(i>m,
   for(u=j,n, S=concat(S,[N[u]]);
   );,
   for(u=i,m, S=concat(S,[M[u]]);
   );
);

return(S); 


}


precalcul(L)=
{
my(i,l,S);
l=length(L);
S=[];
k=0; \\ compteur qui compte le nombre d'élément neutre dans la liste.
for(i=1,l,
		if(L[i]!=[0];
			,
			 S=concat(S,[lift(L[i][1])]);
			,
			k=k+1;
		);
); \\On lifte pour pouvoir faire des comparaisons 


S=trirapide(S);
return(concat([k],S));
}







\\Le programme renvoie un n tel que Q=nP
babygiant(E,P,Q,u,v)=
{
my(l,L,S,U,K,M,W,X,k,G,D,i,j);
l=sqrt(v);
l=ceil(l);
L=[[0]];S=[0];
for(U=1,l-1, S=elladd(E,S,P); L=concat(L,[S]));
S=elladd(E,S,P); \\on calcule lP

M=[Q]; K=S;

for(U=1,l, M=concat(M,[ellsub(E,Q,K)]); K=elladd(E,K,S);); 






W=precalcul(L);



X=precalcul(M);



;
\\On teste si un élément(autre que le premier) de la liste L s'annule
if(W[1]>1,
	  w=2; while(w<=l, if(L[w]!=[0], w=w+1, print(l'ordre est); return(w););
		);
);
\\On teste si un élément de la liste M vaut 0 
if(X[1]!=0,
          
			w=2;while(w<=l+1,
					if(M[w]!=[0],w=w+1; ,print(l'ordre est); return(w-1);
					);
			    );
          
);

i=2; j=2;

while(i<=l && j<=l+1,
		
		if(W[i]<X[j]
			,
			    i=i+1;
			,
			if(W[i]>X[j],
					j=j+1;
				    ,
					k=concat(k,[W[i]]); i=i+1; j=j+1; \\ On garde en mémoire cette abscisse
			);
		);
);

\\Ainsi k est l'ensemble des abscisses communes
G=[];D=[];
K=length(k);
for(a=1,K,
for(i=2,l,
	if(lift(L[i][1])==k[a], G=concat(G,[i]););
);
 for(j=2,l+1,
	if(lift(M[j][1])==k[a], D=concat(D,[j]););
);

\\ G et D gardent en mémoire les indices des points ayant les mêmes abscisses
m=length(G);
n=length(D);

\\ Il ne reste plus qu'à chercher ceux dont les ordonnées coincident également
for(i=1,m,
	for(j=1,n,
			if( lift(L[G[i]][2])==lift(M[D[j]][2]), return((G[i]-1)+l*(D[j]-1)););
	);
);

);
}



\\Connaissant un n tel que E=nP le programme renvoie le plus petit possible
dlog(E,P,Q,n)=
{
my(L,o,A,j,i);

\\On distingue deux cas si Q=[0] (on cherche l'ordre) et si Q<>0 ou on peut réduire n mod l'ordre)
if(Q==[0],
	  L=[];
	  o=1;
	  A=factor(n);
	  m=matsize(A);
          for(i=1,m[1],
			j=1; u=A[i,1]; while(j<=A[i,2] && flexpow(E,P,n/u)==[0], j=j+1; u=u*A[i,1];); \\ On cherche la plus grande valuation de ce nombre premier
			L=concat(L,[j-1]); \\On prend j-1 car on va systématiquement un cran trop loin.
                        o=o*A[i,1]^(A[i,2]-j+1);
	   );
	   return(o);
	  , \\ sinon
	   o=dlog(E,P,[0],babygiant(E,P,[0],1,n)); \\on calcule l'ordre de P
	   return(divrem(n,o)[2]);
);
}

		
           
           		
baby2(E,P,Q,u,v)= \\ Pour les corps finis non premiers.
{
my(l,L,S,U,K,M,W,X,k,G,D,i,j);
l=sqrt(v);
l=ceil(l);
L=[[0]];S=[0];
for(U=1,l-1, S=elladd(E,S,P); L=concat(L,[S]));
S=elladd(E,S,P); \\on calcule lP

M=[Q]; K=S;

for(U=1,l, M=concat(M,[ellsub(E,Q,K)]); K=elladd(E,K,S);); \\une fois calculé ces deux listes on cherche un élément commun.
\\il faut distinguer deux cas: Q=[0] ou non

if(Q!=[0], \\aucun problème

i=1;
\\ On cherche brutalement un élément commun
while( i<=l,
	j=1;
	while(j<=l+1 && L[i]!=M[j],
		j=j+1;
	);
	if(j>l+1,
		i=i+1;
		,
		return((i-1)+l*(j-1));
	);
);

, \\ Si Q=[0] il faut faire attention car les premiers termes de L et M seront alors systématiquement 0

i=2;
while(i<=l,
	if(L[i]==[0],
		return(i-1);\\ On a trouvé 0 dans la liste L
		,
		i=i+1;
	);
);

j=2; \\idem pour M
while(i<=l,
	if(L[i]==[0],
		return(i-1);\\ On a trouvé 0 dans la liste L
		,
		i=i+1;
	);
);

\\ Si aucune solution simple on fait de même que tout à l'heure en évitant les premiers éléments de chaque liste.
i=2;
\\ On cherche brutalement un élément commun
while( i<=l,
	j=2;
	while(j<=l+1 && L[i]!=M[j],
		j=j+1;
	);
	if(j>l+1,
		i=i+1;
		,
		return((i-1)+l*(j-1));
	);
);

);


};
	
dlog_2(E,P,Q,n)=
{
my(L,o,A,j,i);

\\On distingue deux cas si Q=[0] (on cherche l'ordre) et si Q<>0 ou on peut réduire n mod l'ordre)
if(Q==[0],
	  L=[];
	  o=1;
	  A=factor(n);
	  m=matsize(A);
          for(i=1,m[1],
			j=1; u=A[i,1]; while(j<=A[i,2] && flexpow(E,P,n/u)==[0], j=j+1; u=u*A[i,1];); \\ On cherche la plus grande valuation de ce nombre premier
			L=concat(L,[j-1]); \\On prend j-1 car on va systématiquement un cran trop loin.
                        o=o*A[i,1]^(A[i,2]-j+1);
	   );
	   return(o);
	  , \\ sinon
	   o=dlog_2(E,P,[0],baby2(E,P,[0],1,n)); \\on calcule l'ordre de P
	   return(divrem(n,o)[2]);
);
}								 



Comptage(E,p,n,x)= \\Compte le nombre de points et en renvoie le nombre, x est un générateur du corps non premier
{
my(i,j,u,k,S,y,a);
\\On va distinguer les cas des corps premiers et les autres
if(n==1,
	k=1;	\\ k est le compteur du nombre d'éléments.Il y a toujours le point à l'infini
	S=[];    \\S contiendra tous les éléments du groupe.	
	for(i=0,p-1,
		u=i^3+E[4]*i+E[5];
		if(u==0,
			k=k+1; \\On ajoute un élément
			S=concat(S,[[i,0]]);
			,
			if(issquare(u,&y)==1,
				k=k+2; \\On rajoute deux éléments
				S=concat(S,[[i,y],[i,-y]]);
			);
		);
	);
	, \\si le corps n'est pas premier
	k=1;
	S=[];
	for(j=0,n-1, \\j parcourera les puissances de x
		for(i=0,p-1,
			a=i*x^j;
			u=(a)^3+E[4]*(a)+E[5];
			if(u==0,
				k=k+1; \\On ajoute un élément
				S=concat(S,[[a,0]]);
				,
				if(issquare(u,&y)==1,
					k=k+2; \\On rajoute deux éléments
					S=concat(S,[[a,y],[a,-y]]);
				);
			);
		);
	);
);
S=concat([k],[S]);
return(S);
}


torsion(m,E,p,n,x)= \\renvoie le nombre de point de m torsion d'une courbe.
{
my(A,l,S,k);
A=Comptage(E,p,n,x);
l=A[1];
S=A[2];
k=1; \\le neutre sera toujours de m-torsion
if(m==1,
	k=1;
	,
	for(i=1,l-1, \\On enlève le point à l'infini
		A=flexpow(E,S[i],m);
		if(A==[0],
			k=k+1;
		);
	);
);
return(k);
}

card(n,p)= \\Crée une courbe sur Fp de cardinal n;
{
my(u,A);
u=ellrand(p,1)[2];
A=ellinit([0,0,0,Mod(u[4],p),Mod(u[5],p)]);

while(Comptage(A,p,1)[1]!=n,
	u=ellrand(p,1)[2];
	
	A=ellinit([0,0,0,Mod(u[4],p),Mod(u[5],p)]);	
);
return(A);
}
