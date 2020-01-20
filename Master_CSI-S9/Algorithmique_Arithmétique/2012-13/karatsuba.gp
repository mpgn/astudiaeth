/* Polynomials are represented by vectors with v[i+1] = polcoeff(P,i).  */
/* To get back the polynomial P associated to a vector v, use Polrev(v) */
deg(A)=#A-1;

\\ Naive (quadratic) multiplication
mul(A,B) =
{ my (a = deg(A), b = deg(B), C = vector(a+b + 1));
  for (i = 0, a,
    for (j = 0, b, C[i+j+1] += A[i+1]*B[j+1])
  ); C;
}

\\ cut-off to naive multiplication
BOUND = 30;

\\ Karatsuba (subquadratic) multiplication, recursive workhorse.
\\ Assumes that deg(A) = deg(B) is odd; reduce to degrees (deg(A)-1)/2
kara(A, B) =
{
  if (#A <= BOUND, return (mul(A,B)) );
  my (d = #A/2, LOW = Str("..", d), HIGH = Str(d+1, ".."));
  my (A0 = vecextract(A, LOW), A1 = vecextract(A, HIGH));
  my (B0 = vecextract(B, LOW), B1 = vecextract(B, HIGH));
  my (C0 = kara(A0,B0), C2 = kara(A1,B1), C1 = kara(A0+A1,B0+B1) - C0 - C2);
  concat([C0, 0, C2]) + concat([vector(d), C1, vector(d)]);
}
\\ Main routine. Append 0s to ensure that deg(A) = deg(B) = 2^k - 1 for some k
karamul(A, B) =
{ my (a = deg(A), b = deg(B), d = max(a,b), D = 1);
  while (D < d, D = 2*D+1); \\ D = 2^k - 1
  kara(concat(A, vector(D-a)), concat(B, vector(D-b)));
}

N = 200;
A = random(100*x^N); a = Vec(A);
B = random(100*x^N); b = Vec(B);
\\ 1,856ms
for(i=1,10^2,mul(a,b))
\\ 1,114ms
for(i=1,10^2,karamul(a,b))

N *= 2;
A = random(100*x^N); a = Vec(A);
B = random(100*x^N); b = Vec(B);
\\ 7,629ms
for(i=1,10^2,mul(a,b))
\\ 3,423ms
for(i=1,10^2,karamul(a,b))
