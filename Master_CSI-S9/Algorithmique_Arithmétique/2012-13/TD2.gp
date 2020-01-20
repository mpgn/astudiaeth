initFq(p, e) =
{
  Fq = ffgen(ffinit(p,e), 't); \\ global
}
\\ 1)
splitp(T) =
{
  my(p = Fq.p, q = p^poldegree(Fq.mod), x = variable(T));
  my(u,v,w,W);
  u = gcd(T,T');
  v = T/u;
  w = u/gcd(u,v^min(poldegree(T)-1, poldegree(u)));
  W = apply(a->a^(q/p), substpol(w, x^p, x));
  [v, W];
}
\\ 2)
CORE(T) =
{
  my(v2, [v,W] = splitp(T));
  while (poldegree(W), [v2,W] = splitp(W); v *= v2);
  v / pollead(v);
}
\\ 3)
DDF(T) =
{
  my (p = Fq.p, q = p^poldegree(Fq.mod));
  my (d = poldegree(T), x = variable(T), h);
  my (F = vector(d, i, 1), h = Mod(x, T), i = 1);
  while (i <= d / 2,
    h = h^q; \\ x^(q^i) mod T
    g = gcd(lift(h) - x, T);
    g /= pollead(g);
    F[i] = g;
    if (g != 1,
      T /= g;
      h = Mod(h, T);
      d = poldegree(T);
    );
    i++;
  );
  if (d, F[d] = T); \\ left-over irreducible part
  F;
}
\\ 4) assume T is a product of irreducibles of degree i

\\ g+g^2+...+g^2^(e-1)
TRACE(g, e) =
{
  my (h = g); g + sum(i = 1, e-1, h = h^2);
}
\\ p odd
split(T, i) =
{
  my (n = poldegree(T), d);
  if (n == 0, return ([]));
  if (n == i, return ([T / pollead(T)]));

  my (p = Fq.p, e = poldegree(Fq.mod), q = p^e, t = (q^i-1)/2);
  my (g);
  until(d > 0 && d < n,
    g = Mod(random(Fq * x^(n-1)), T);
    g = if (p == 2, TRACE(g, e), g^t - 1);
    g = lift(g);
    g = gcd(g, T);
    d = poldegree(g);
  );
  concat(split(g,i), split(T/g,i));
}

\\ 5)
Berlekamp(T) =
{
  my (p = Fq.p, q = p^poldegree(Fq.mod));
  my (n = poldegree(T), x = variable(T));
  my (M, g, xp);
  M = matrix(n, n);
  g = xp = Mod(x, T)^q;
  M[,1] = Col(1, n);
  for (i = 2, n,
    g = lift(g);
    M[,i] = vectorv(n, i, polcoeff(g, i-1));
    g *= xp;
  );
  K = matker(M - 1); \\ basis of Berlekamp algebra B
  s = #K; L = List();
  listput(L, T);
  my (t = (q-1)/2);
  while (#L < s,
    g = Mod(Polrev(K * vectorv(#K,i,random(Fq)), x), T); \\ random element in B
    g = if (p == 2, TRACE(g, e), g^t - 1);
    g = lift(g);
    for (i = 1, #L,
      my (f = L[i], h = gcd(g,f), dh = poldegree(h));
      if (dh > 0 && dh < poldegree(f),
        L[i] = h; \\ replace f
        listput(L, f/h);
      );
    );
  ); apply(x->x/pollead(x), L);
}

\\ some random example
initFq(3,4);
a = random(Fq*x^4);
b = random(Fq*x^4);
c = random(Fq*x^4);
T = a^3*b^2*c;

[v,W] = splitp(T)
T = CORE(T) \\ now assume that T is monic, separable
F = DDF(T)
factorback(F) == T
F2 = vector(#F, i, split(F[i],i))
F3 = Berlekamp(T)
