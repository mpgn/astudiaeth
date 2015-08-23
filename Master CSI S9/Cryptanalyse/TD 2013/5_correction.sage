import hashlib
sha2 = hashlib.sha256
N = 16 # number of output bits of sha2


# truncated sha2. Return an Integer
def sha2Trunc(m):
   hashHexa = sha2(messageModif(m)).hexdigest()
   return ZZ(hashHexa[:N//4],16)


# Question 1

# floyd's cycle finding : starting from x0 return x in cycle
def floyd(x0):
    x = x0
    y = x
    x = sha2Trunc(x)
    y = sha2Trunc(sha2Trunc(y))
    while (x!=y):
       x = sha2Trunc(x)
       y = sha2Trunc(sha2Trunc(y))
    return x

# Question 2

# compute the period of the cycle containing x
def period(x):
  y = sha2Trunc(x)
  l = 1
  while y!=x:
    y = sha2Trunc(y)
    l +=1
  return l

# Question 3

# find a collision at a beginning of a cycle
def findCollision(x0):
  print "starting point", x0
  x = floyd(x0)  # x in cycle starting from x0
  print "in cycle with ",x
  l = period(x) # period of cycle
  print "period of cycle", l
  if l==1:
    print "period 1"
    return 0
  # compute x_l
  xc = x0
  for i in [1..l]:
    xc = sha2Trunc(xc)
  if xc == x0:
    print "no preperiod"
    return 0
  # compute start of cycle to find a collision: compute x_i and x_i+c until equality
  xxc = sha2Trunc(xc)
  xx0 = sha2Trunc(x0)
  c = 1
  while xxc!=xx0:
    xc = xxc
    x0 = xx0
    xxc = sha2Trunc(xc)
    xx0 = sha2Trunc(x0)
    c+=1
  print "lengh of preperiod", c
  return x0,xc

# timing = cputime()
# x,y = findCollision(ZZ.random_element(2^N-1))
# print x,y, (x!=y) and (sha2Trunc(x) == sha2Trunc(y))
# print "N = ", N, "Time taken", cputime(timing),"s" 

# N =  16 Time taken 0.00408899999979 s
# N =  24 Time taken 0.111315 s
# N =  32 Time taken 5.457244 s
# N =  40 Time taken 44.696461 s
# N =  48 Time taken 584.223444 s
# with 48 bits, i.e., 12 hexadecimal character we find :
# sha2('128719751402588').hexdigest()
# '8aac636705b2a33822a194de7b5d9bf6b182208e0899f6982e2191acda9dcf8d'
# sage: sha2('242860679932524').hexdigest()
# '8aac636705b24d9ef9b2b69812412447e1acf50714fd2d59e1ee404d80d4be56'


# Question 4

message = ["ALICE CERTIFIE QU'ELLE DOIT NEUF EUROS ET CINQUANTE CENTIMES A OSCAR.", "ALICE CERTIFIE QU'ELLE DOIT MILLE DEUX CENTS EUROS ET CINQUANTE CENTIMES A OSCAR."]

# apply a modification in lower case of message according to the bits of x
def messageModif(x):
   bits = x.digits(2,padto=N)
   m = ''
   index = bits[0]
   nbBits = 1
   pos = 0
   while nbBits < N:
     if message[index][pos] in [" ","'"]:
       m += message[index][pos]
     else:
       if bits[nbBits]:
         m += message[index][pos].lower()
       else:
         m += message[index][pos]
       nbBits+=1
     pos +=1
   m += message[index][pos:]
   return m

# replace str(m) in sha2Trunc(m) by  messageModif(m) before uncommenting
timing = cputime()
good = False
while not good:
  x,y = findCollision(ZZ.random_element(2^N-1))
  if (ZZ(x,16)-ZZ(y,16))%2:
    good = True
print "N = ", N
print x, messageModif(x), sha2(messageModif(x)).hexdigest()
print y, messageModif(y), sha2(messageModif(y)).hexdigest()
print "Time taken", cputime(timing),"s"

# N =  40
# 698737971864 ALicE CeRtIFiE qU'ellE DOIT NEUF euRoS eT CInQuANTE CENTIMES A OSCAR. 
# a0a37fffd86444d3864597056d24199c4c1279ce21efa3f81ec744b2bac4d130
# 941823564715 aLiCe CertIfiE QU'elle DOIT mILlE DeUx cEntS euROS ET CINQUANTE CENTIMES A OSCAR. 
# a0a37fffd8bcf23b429cda53d9f28eb64a7260dd2ba91e0e9456104163c90232
# Time taken 176.286967 s

