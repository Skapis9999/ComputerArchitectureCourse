int fib(int n) {
  if (n < 2)
    return n;
  int a = fib(n-1);
  int b = fib(n-2);

  return a + b;
}

void main() {
  
  int result = fib(30);
  
  return;
} 
